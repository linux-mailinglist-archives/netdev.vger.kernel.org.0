Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719F315AA4
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbfEGFko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbfEGFkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:40:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC97420675;
        Tue,  7 May 2019 05:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207642;
        bh=1Ohsioqf6e9PSqCMvFBCxo6ssLXNXK3ezfG6Snz+1is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJszTVfgS3EUTBCmd8TIFp7tV6Nc265+9hVB5kp2NNFJqhR3eAM8F/WCjFKPN53tD
         44vEhFmsln6n/ElabpJmTWg/3cA2lVAjBgZz5iwqDkIj/bs8cbUR0QZTuLB5qBgP8w
         lT68rLfjBDu3h1qMdd0mIdCnNdOzbvzlkD2D8RGk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 75/95] net_sched: fix two more memory leaks in cls_tcindex
Date:   Tue,  7 May 2019 01:38:04 -0400
Message-Id: <20190507053826.31622-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 1db817e75f5b9387b8db11e37d5f0624eb9223e0 ]

struct tcindex_filter_result contains two parts:
struct tcf_exts and struct tcf_result.

For the local variable 'cr', its exts part is never used but
initialized without being released properly on success path. So
just completely remove the exts part to fix this leak.

For the local variable 'new_filter_result', it is never properly
released if not used by 'r' on success path.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/sched/cls_tcindex.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 52829fdc280b..75c7c7cc7499 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -322,9 +322,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		  struct nlattr *est, bool ovr)
 {
 	struct tcindex_filter_result new_filter_result, *old_r = r;
-	struct tcindex_filter_result cr;
 	struct tcindex_data *cp = NULL, *oldp;
 	struct tcindex_filter *f = NULL; /* make gcc behave */
+	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
 
@@ -363,13 +363,10 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	cp->h = p->h;
 
 	err = tcindex_filter_result_init(&new_filter_result);
-	if (err < 0)
-		goto errout1;
-	err = tcindex_filter_result_init(&cr);
 	if (err < 0)
 		goto errout1;
 	if (old_r)
-		cr.res = r->res;
+		cr = r->res;
 
 	if (tb[TCA_TCINDEX_HASH])
 		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
@@ -460,8 +457,8 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	if (tb[TCA_TCINDEX_CLASSID]) {
-		cr.res.classid = nla_get_u32(tb[TCA_TCINDEX_CLASSID]);
-		tcf_bind_filter(tp, &cr.res, base);
+		cr.classid = nla_get_u32(tb[TCA_TCINDEX_CLASSID]);
+		tcf_bind_filter(tp, &cr, base);
 	}
 
 	if (old_r && old_r != r) {
@@ -473,7 +470,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	oldp = p;
-	r->res = cr.res;
+	r->res = cr;
 	tcf_exts_change(&r->exts, &e);
 
 	rcu_assign_pointer(tp->root, cp);
@@ -492,6 +489,8 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 				; /* nothing */
 
 		rcu_assign_pointer(*fp, f);
+	} else {
+		tcf_exts_destroy(&new_filter_result.exts);
 	}
 
 	if (oldp)
@@ -504,7 +503,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	else if (balloc == 2)
 		kfree(cp->h);
 errout1:
-	tcf_exts_destroy(&cr.exts);
 	tcf_exts_destroy(&new_filter_result.exts);
 errout:
 	kfree(cp);
-- 
2.20.1

