Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2011A4D0675
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbiCGS1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiCGS1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:27:01 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1972492D13
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RxAW2X7nvwwiYQ+TtxL78u3hQYKl4WGQ8PSgA7Hu+Dg=; b=iV1Y0i5sYQ95EVa+t4oKnyGkMn
        50iriw1DQmdxgJy9rxXpN9fNq2sybTfb0cwcrp3Heljr0krVqMYXqzelrU0rrZhsPsbvuyp3kj/hX
        s6AwJMKmnrPZSAPOdFGg/htH1avQJGNYLFdgOwejHVnEQEd5/pt8cyenoEMiNtamDvYM=;
Received: from p200300daa7204f0005a7b0458a613fd2.dip0.t-ipconnect.de ([2003:da:a720:4f00:5a7:b045:8a61:3fd2] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nRI3X-0007w7-Q4
        for netdev@vger.kernel.org; Mon, 07 Mar 2022 19:26:03 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH 2/2] sch_fq_codel: fix running with classifiers that don't set a classid
Date:   Mon,  7 Mar 2022 19:26:02 +0100
Message-Id: <20220307182602.16978-2-nbd@nbd.name>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220307182602.16978-1-nbd@nbd.name>
References: <20220307182602.16978-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If no valid classid is provided, fall back to calculating the hash directly,
in order to avoid dropping packets

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/sched/sch_fq_codel.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 839e1235db05..b2a13185bb63 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -88,7 +88,7 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 
 	filter = rcu_dereference_bh(q->filter_list);
 	if (!filter)
-		return fq_codel_hash(q, skb) + 1;
+		goto out;
 
 	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
 	result = tcf_classify(skb, NULL, filter, &res, false);
@@ -104,10 +104,13 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 			return 0;
 		}
 #endif
-		if (TC_H_MIN(res.classid) <= q->flows_cnt)
+		if (TC_H_MIN(res.classid) > 0 &&
+		    TC_H_MIN(res.classid) <= q->flows_cnt)
 			return TC_H_MIN(res.classid);
 	}
-	return 0;
+
+out:
+	return fq_codel_hash(q, skb) + 1;
 }
 
 /* helper functions : might be changed when/if skb use a standard list_head */
-- 
2.32.0 (Apple Git-132)

