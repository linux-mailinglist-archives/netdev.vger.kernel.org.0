Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658171E3763
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgE0Efw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgE0Efu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:35:50 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5126CC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:50 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x13so11264603pfn.11
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EkzL/BGsNUdUyg3y8Xr2lfREoy2cCNVAC2wqTo+1JDs=;
        b=h7LXFZslmc+Bi5sNYTbziMMVzRI099vHfYyOMB8RAmbCCgfm1aFFIerago/QkJwUOj
         iTnm4b8xhaNewmBms44moVI1f2oQ0T8v3i1ar80nl8X2T3+f0/DuhEvWPVQXFTndsijA
         RBK2TKBolgmX+0o0k2FfSBIk+eZHQwz7TuKfN6Fbg4wspblkKEehO6HTjd7GFlZQ4QTo
         rtbX1abl9m+aBUoVgvCnx5r4Aur5FoSgqgOi2HDDGu8VCHsNIdfihKQF6xwrTT5wKgcp
         yIlzZ+3ohLzpoYWdBs0pKG538YJkLxuxr9BNe0w+16KN31g3LK+gZkaLlcZ2aAgId5gy
         grpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EkzL/BGsNUdUyg3y8Xr2lfREoy2cCNVAC2wqTo+1JDs=;
        b=KsUCfgzDNkqfLKy6He1wbFf0lbkA8+o7fwC6+5NVa3MTafbkfG+QX8OeShuyQyMRvA
         ODcFG8xXWoNbF0H/skHjaalp0UouLn9FTFW5zLdpsJ6iDGSfVZOApgq6D7syqwEZXR3O
         EG7fyE6IYgaPTXLwuFjbT2SvCGgcrhOSvIEQVxtgb5TfEWMAjR+5ySHKDwk0r8wvM7Z8
         /nh7XP/bzxdoi7iD2J5SVfK3hs8Ph4nfG58PWqLeBgQMYlcLEFiCStbm4RilSALCdStZ
         CThR73pb6xgupfPa/mP1/AOrssgdCtDnyO8AqJ+Zexh6uHAFCGRkmSFAt7YPDXJ45qxT
         4xPQ==
X-Gm-Message-State: AOAM533ChlXllU+FE9bsBuj/BTuLP5YYjksUhfhMTbX1L1ZOih5OcDNp
        6uNZjbXpcjCECREKsHcZSmFppqHk
X-Google-Smtp-Source: ABdhPJwai22rzW/SVUzbC7Gf4nnYH2eJcULBtI6cU6o6IGBKGwROf7uMYGFTp0Qb6PrGuAT9WySLeQ==
X-Received: by 2002:a63:1f0e:: with SMTP id f14mr1906154pgf.405.1590554149727;
        Tue, 26 May 2020 21:35:49 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id 62sm884990pfc.204.2020.05.26.21.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:35:49 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next 1/5] net_sched: use qdisc_reset() in qdisc_destroy()
Date:   Tue, 26 May 2020 21:35:23 -0700
Message-Id: <20200527043527.12287-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
References: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qdisc_destroy() calls ops->reset() and cleans up qdisc->gso_skb
and qdisc->skb_bad_txq, these are nearly same with qdisc_reset(),
so just call it directly, and cosolidate the code for the next
patch.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_generic.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index ebc55d884247..7a0b06001e48 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -949,7 +949,6 @@ static void qdisc_free_cb(struct rcu_head *head)
 static void qdisc_destroy(struct Qdisc *qdisc)
 {
 	const struct Qdisc_ops  *ops = qdisc->ops;
-	struct sk_buff *skb, *tmp;
 
 #ifdef CONFIG_NET_SCHED
 	qdisc_hash_del(qdisc);
@@ -957,24 +956,15 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 	qdisc_put_stab(rtnl_dereference(qdisc->stab));
 #endif
 	gen_kill_estimator(&qdisc->rate_est);
-	if (ops->reset)
-		ops->reset(qdisc);
+
+	qdisc_reset(qdisc);
+
 	if (ops->destroy)
 		ops->destroy(qdisc);
 
 	module_put(ops->owner);
 	dev_put(qdisc_dev(qdisc));
 
-	skb_queue_walk_safe(&qdisc->gso_skb, skb, tmp) {
-		__skb_unlink(skb, &qdisc->gso_skb);
-		kfree_skb_list(skb);
-	}
-
-	skb_queue_walk_safe(&qdisc->skb_bad_txq, skb, tmp) {
-		__skb_unlink(skb, &qdisc->skb_bad_txq);
-		kfree_skb_list(skb);
-	}
-
 	call_rcu(&qdisc->rcu, qdisc_free_cb);
 }
 
-- 
2.26.2

