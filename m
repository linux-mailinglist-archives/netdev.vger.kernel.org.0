Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0390E4F5B85
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 12:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347275AbiDFKUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377788AbiDFKSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:18:46 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918DA127585;
        Tue,  5 Apr 2022 20:56:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o10so886026ple.7;
        Tue, 05 Apr 2022 20:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=S2Mrxod2ITgWYTN04g5x9FPQTpq7BfhJLFyLK5OxcvE=;
        b=Q2HPjZrJAOUw3d6ApjMSFPkwq1oi2IIv1t5HPdFBZTbPNFE7ki+367dgP8rUtuaULA
         whMJA2ZEZryQ0DTAvO4caIpoJViiIrU2urjAQCQiUpXn8rnqZoE8pMwjsTYf00LYylOK
         1kse5KDOg+/pXMPwG0dqA6oLNUofWqfF4wue69e3zRGT0NqvvhBnXgIyHJi5nl3oorGo
         E0niSWqKljoLehFWw/3rb7gdFEDUohZVKl8Nz2QUgUIANOk5UjFyOO+0NtN1WEJmwT27
         Tp1QcUleliDm9EyAcXxhRUGDpC7pD14omPO87GrFLcg+8fRmg6z2NThdH+W48Tf5QTa2
         n4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S2Mrxod2ITgWYTN04g5x9FPQTpq7BfhJLFyLK5OxcvE=;
        b=c4aPBdkcnlpsm+WFYiElR1zFu68c0unY1FMe5Gf9a4/tRrhiQ6csbIWzypIbHCSHK1
         EXGEllQ2E2HLV3qRFPfIKwNGBeoIovRjXalO+4VDilVHMuL2ZSk33f7A27DZQrbvnOub
         ACa1zlENqpGs1grYhywlVMfytE3Gk4rMcRrI+9lOmjiqT3th3Npm7qrnGFrg2sAYESQ1
         Ii02EeIzjmXu85XeBesOlmgFjx/3PyL0F5Yb34T/oDUsy1GWrGCKE7AeSAtI0iK3SMCw
         SATIZaAxcUYeDDSPc+uDvlCQkswypXIC6MtW1pRinoto9BeyRLITksti0mdJH2zn/iV7
         FLPg==
X-Gm-Message-State: AOAM530al4CuIiJ8LMm3lhWfEq+FN1wxoR84rRyc6+YNPOloh/3NUWDP
        MK3v4UoplD0ouzEwI4VJOmA=
X-Google-Smtp-Source: ABdhPJzKjQL395BwiPaZzTXSWdTdQXcmoXkAdWxmDnCrmEwIUBuEuvMGTyhf76hKsr4/sfZZQH1skA==
X-Received: by 2002:a17:90b:915:b0:1ca:b584:8241 with SMTP id bo21-20020a17090b091500b001cab5848241mr7708111pjb.46.1649217363132;
        Tue, 05 Apr 2022 20:56:03 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id fw15-20020a17090b128f00b001ca93a34d0dsm3611087pjb.19.2022.04.05.20.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 20:56:02 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH v3] myri10ge: fix an incorrect free for skb in myri10ge_sw_tso
Date:   Wed,  6 Apr 2022 11:55:56 +0800
Message-Id: <20220406035556.730-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All remaining skbs should be released when myri10ge_xmit fails to
transmit a packet. Fix it within another skb_list_walk_safe.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v2:
 - free all remaining skbs. (Xiaomeng Tong)

changes since v1:
 - remove the unneeded assignmnets. (Xiaomeng Tong)

v2:https://lore.kernel.org/lkml/20220405000553.21856-1-xiam0nd.tong@gmail.com/
v1:https://lore.kernel.org/lkml/20220319052350.26535-1-xiam0nd.tong@gmail.com/

---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 50ac3ee2577a..21d2645885ce 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2903,11 +2903,9 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 		status = myri10ge_xmit(curr, dev);
 		if (status != 0) {
 			dev_kfree_skb_any(curr);
-			if (segs != NULL) {
-				curr = segs;
-				segs = next;
+			skb_list_walk_safe(next, curr, next) {
 				curr->next = NULL;
-				dev_kfree_skb_any(segs);
+				dev_kfree_skb_any(curr);
 			}
 			goto drop;
 		}
-- 
2.17.1

