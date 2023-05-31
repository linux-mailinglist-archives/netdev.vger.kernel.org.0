Return-Path: <netdev+bounces-6810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B14E718488
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18E912814ED
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A8615491;
	Wed, 31 May 2023 14:16:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA771429C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F541C433D2;
	Wed, 31 May 2023 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685542585;
	bh=6xPVFqexSIW7Z9IDBUUq4nFv5EZETSZ0A3H+jexY8Ug=;
	h=From:To:Cc:Subject:Date:From;
	b=mO68rUpe21FDD87sqVUTxkHqsjWPBsyqdMq9X0kKabvZb5rCQuye9Ls2ovHj46Esm
	 toJZVU3bPGB+7TO9sKR1unvcK2cqZJgibVtbPqNtD2CxdQtJ7nCuj713Qj0a3hCj5m
	 C4cHGoMroa63d+q6HIrRBBG+XGn2acHkI52BrjqwqN2jU0upMi6Rg4sHrprNQnrgFL
	 +xSP8hbglakFAPuRQ1UmjU7lZLiJWAXqkPSyzGSJ62wQrnArUxbaUvG8LBu9Jsqb4z
	 syWYHiynewVeLFY5S9kOMIrPdz4dNfwP0uMp1x2RV12GwAJntAmp5Iqsrcydl02Y8a
	 2cj1fk/xnT+Qw==
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
Subject: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak leading to overflow
Date: Wed, 31 May 2023 15:15:56 +0100
Message-ID: <20230531141556.1637341-1-lee@kernel.org>
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

Cc: stable@kernel.org # v4.14+
Signed-off-by: Lee Jones <lee@kernel.org>
---
 net/sched/cls_u32.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4e2e269f121f8..fad61ca5e90bf 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -762,8 +762,11 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 	if (tb[TCA_U32_INDEV]) {
 		int ret;
 		ret = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
-		if (ret < 0)
+		if (ret < 0) {
+			if (tb[TCA_U32_LINK])
+				n->ht_down->refcnt--;
 			return -EINVAL;
+		}
 		n->ifindex = ret;
 	}
 	return 0;
-- 
2.41.0.rc0.172.g3f132b7071-goog


