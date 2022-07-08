Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0056B407
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 10:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbiGHIDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 04:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237491AbiGHIDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 04:03:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97927E02F;
        Fri,  8 Jul 2022 01:03:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so1107095pjl.4;
        Fri, 08 Jul 2022 01:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5CxjGwuv1eeMSRhwp2Wg3MjAsxLxFjnx3j2wvAINBQA=;
        b=G2m/oWv/l0TNwr39XyBlU+DwPU8Y+Bc+6CvSk0ocmJBd6hmceX8fWVhooLDiFxS6I/
         13MXtVrbKkBQAOoQ9418TERvyMnepZwGWY9xjkmw/scHT3QEMjTufwb+cAEDjSMeNCqV
         b+YbYQOKXlJDwXIetNsTt2vQujvdvKayJy8ZI4JwQfCNrazYI1lvWpYTzb/EehPxp6N1
         W9yRH5CmMQ571W3eEt13jW//sZ7sWRBd/eifQJ0wjSghfVZP3UJgvUZZsCkLKmrFjVl1
         2a7LMsQ40n5ZSwQ6NFWwJaFuZRni2D4PPwah5bSImKLqNnAPI0VkoN39zdGYzCuT/85b
         12VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5CxjGwuv1eeMSRhwp2Wg3MjAsxLxFjnx3j2wvAINBQA=;
        b=zvyRUciiEcDxnBHaGFzCFxEmReFTNbSIfPvxdQXVVgRBXk348Bc+k+5vKthttsEwhg
         rMjZpxuB1BU0wfrrf+PxnyV+WgoiJYf/kniOiWXXNQj6NWX+sLAgWosUzaMPYa4s//e2
         CgXz764lUuIsSBMzbKU3QYtLnWcI3GBEYzL1fYevgAZkGkHYRZOCvEmCTyM0Jux3zBnW
         bpgEyCwfGDtPf6LIyyFPHUdw3jnQTIOwEtx2P9N5I8vO5PLd9bhNjwLIzeNnAKklf+zi
         wOMkVv4qYkM693bQTHOu/QDg3BKgjvX6o3v/4WgFN6q6xlqZhvRLdRpMlDK6NDbNv0aT
         MbDw==
X-Gm-Message-State: AJIora8kr0u4eQ3AhdibsqPNASF2ARt64l7RxFImD3Bk5k2SqnZi1j0q
        Fauoq42M4Q3hfoqFMNGyv0A=
X-Google-Smtp-Source: AGRyM1uswYE7xwOiZkzonBXbmZ/r79On/2X/fK8yaP1x4TIKYebD3unBfA+Et8mJmrPU2jEtsIbOGA==
X-Received: by 2002:a17:90b:3b8a:b0:1ef:b87d:309d with SMTP id pc10-20020a17090b3b8a00b001efb87d309dmr2598738pjb.176.1657267402161;
        Fri, 08 Jul 2022 01:03:22 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016be2bb8e68sm10496097plb.303.2022.07.08.01.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 01:03:21 -0700 (PDT)
From:   Sieng-Piaw Liew <liew.s.piaw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH] bcm63xx: fix Tx cleanup when NAPI poll budget is zero
Date:   Fri,  8 Jul 2022 16:03:03 +0800
Message-Id: <20220708080303.298-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220615060922.3402-1-liew.s.piaw@gmail.com>
References: <20220615060922.3402-1-liew.s.piaw@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAPI poll() function may be passed a budget value of zero, i.e. during
netpoll, which isn't NAPI context.
Therefore, napi_consume_skb() must be given budget value instead of
!force to truly discern netpoll-like scenarios.

Fixes: c63c615e22eb ("bcm63xx_enet: switch to napi_build_skb() to reuse skbuff_heads")
Signed-off-by: Sieng-Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 514d61dd91c7..193dc1db0f4e 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -423,7 +423,7 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 /*
  * try to or force reclaim of transmitted buffers
  */
-static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
+static int bcm_enet_tx_reclaim(struct net_device *dev, int force, int budget)
 {
 	struct bcm_enet_priv *priv;
 	unsigned int bytes;
@@ -468,7 +468,7 @@ static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
 			dev->stats.tx_errors++;
 
 		bytes += skb->len;
-		napi_consume_skb(skb, !force);
+		napi_consume_skb(skb, budget);
 		released++;
 	}
 
@@ -499,7 +499,7 @@ static int bcm_enet_poll(struct napi_struct *napi, int budget)
 			 ENETDMAC_IR, priv->tx_chan);
 
 	/* reclaim sent skb */
-	bcm_enet_tx_reclaim(dev, 0);
+	bcm_enet_tx_reclaim(dev, 0, budget);
 
 	spin_lock(&priv->rx_lock);
 	rx_work_done = bcm_enet_receive_queue(dev, budget);
@@ -1211,7 +1211,7 @@ static int bcm_enet_stop(struct net_device *dev)
 	bcm_enet_disable_mac(priv);
 
 	/* force reclaim of all tx buffers */
-	bcm_enet_tx_reclaim(dev, 1);
+	bcm_enet_tx_reclaim(dev, 1, 0);
 
 	/* free the rx buffer ring */
 	bcm_enet_free_rx_buf_ring(kdev, priv);
@@ -2362,7 +2362,7 @@ static int bcm_enetsw_stop(struct net_device *dev)
 	bcm_enet_disable_dma(priv, priv->rx_chan);
 
 	/* force reclaim of all tx buffers */
-	bcm_enet_tx_reclaim(dev, 1);
+	bcm_enet_tx_reclaim(dev, 1, 0);
 
 	/* free the rx buffer ring */
 	bcm_enet_free_rx_buf_ring(kdev, priv);
-- 
2.17.1

