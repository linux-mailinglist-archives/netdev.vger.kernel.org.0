Return-Path: <netdev+bounces-9147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E027278D1
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E99EC2814BB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE84747E;
	Thu,  8 Jun 2023 07:29:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EB5628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4177CC433EF;
	Thu,  8 Jun 2023 07:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686209357;
	bh=fTXGZtsvjHuJPXHpI4JJ8GQPMLGUVrrCn8vbVtMpWuU=;
	h=From:To:Cc:Subject:Date:From;
	b=BaPNrsyCybUJr40Mpe35lK+mkb7m8gkxBYtXCziieTrN8YOPBsJH49B+Ho870Nn4k
	 r8JLLSxvU9CuDdaKgNGMlwNkYuQvuHAHgWqL1zbiUHKbSK2zBQ/ZZGSpHGUI7zdIg2
	 cN7y+R/vFuEYURbrDboUfV8gkulNcYpXiRgdivhLLTnMyBm3zSB7VZDO2NVbH6sqGQ
	 YRzV7PHbk8SPk4wHBo3Unmr4GdDWXn0pNG1O7JltTLq+8VGF/9ex4VvD3tmXLp3NZL
	 q9C5bhz7DkR6GGJBha0UycHbCjc+e3O5iKQ/9u7lF38ZPOOwGbp3noeCX91A0p+ap6
	 cUbY41qH47IkA==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@kernel.org
Subject: [PATCH v2 1/1] net/sched: cls_u32: Fix reference counter leak leading to overflow
Date: Thu,  8 Jun 2023 08:29:03 +0100
Message-ID: <20230608072903.3404438-1-lee@kernel.org>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the event of a failure in tcf_change_indev(), u32_set_parms() will
immediately return without decrementing the recently incremented
reference counter.  If this happens enough times, the counter will
rollover and the reference freed, leading to a double free which can be
used to do 'bad things'.

In order to prevent this, move the point of possible failure above the
point where the reference counter is incremented.  Also save any
meaningful return values to be applied to the return data at the
appropriate point in time.

This issue was caught with KASAN.

Fixes: 705c7091262d ("net: sched: cls_u32: no need to call tcf_exts_change for newly allocated struct")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
---
v1 -> v2:
  - Instead of decrementing the refcnt in the error path, move the
    point of failure up above the section which increments it.

net/sched/cls_u32.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4e2e269f121f8..d15d50de79802 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -718,13 +718,19 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 			 struct nlattr *est, u32 flags, u32 fl_flags,
 			 struct netlink_ext_ack *extack)
 {
-	int err;
+	int err, ifindex = -1;
 
 	err = tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
 				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
+	if (tb[TCA_U32_INDEV]) {
+		ifindex = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
+		if (ifindex < 0)
+			return -EINVAL;
+	}
+
 	if (tb[TCA_U32_LINK]) {
 		u32 handle = nla_get_u32(tb[TCA_U32_LINK]);
 		struct tc_u_hnode *ht_down = NULL, *ht_old;
@@ -759,13 +765,9 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 		tcf_bind_filter(tp, &n->res, base);
 	}
 
-	if (tb[TCA_U32_INDEV]) {
-		int ret;
-		ret = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
-		if (ret < 0)
-			return -EINVAL;
-		n->ifindex = ret;
-	}
+	if (ifindex >= 0)
+		n->ifindex = ifindex;
+
 	return 0;
 }
 
-- 
2.41.0.rc0.172.g3f132b7071-goog


