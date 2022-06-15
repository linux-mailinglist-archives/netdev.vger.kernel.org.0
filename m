Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D1554C1B1
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351284AbiFOGLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346051AbiFOGLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:11:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B1627CE5;
        Tue, 14 Jun 2022 23:11:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so1069789pjg.5;
        Tue, 14 Jun 2022 23:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A0WUe+ant8QpycVpCnxMIq6JosP90ibIEJ2d6QtyqYw=;
        b=T+038nmKBBf4KuTEJj/v5IT7sB1IPYgA/s9u8T4/+81XodtSAmt46Q5BL3tGHmNG9S
         mDPZXFcSihOzfHGqRyjvogPkrA5VFTg6QJvY6z1CXw7Wfj0eL2IHH1pS2jXBxb0taQLI
         fkgSTsswNiRQpD+LnKRlXhsDpbe5lc7Q22rvFQY0TNgZGiLAXetZcoKKIDJV3UCYfOs+
         eCehZq6NjrI6KN0mRGQXACkv467JTG1a1V/qf4KX96AX9vlzH7iRFT6Q/7FAxgRA+4KG
         3GDqW8tNtvcoII/A4UTlNIm/YicAkD74GSuucJkoObPpZcSAR7AQNWdTj6ylPuOiAaZw
         tZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A0WUe+ant8QpycVpCnxMIq6JosP90ibIEJ2d6QtyqYw=;
        b=tmk5GuZaICV+epyI7dhqcSFdgINE8kd8iVAuRHzg1eB+k8xWkFN0TgsAEq9RkElGUC
         7pd1zZFsQvccTy3rLwTClJe//tF+KJjWHs2LoEQ28RDZW2BVzitSwjsHQmTxkV8HMIPZ
         LGJK4y8/pRvdvb8BAtf1OnChBDrx3yG1+LTLTISdMLqircmbzsB8U20GhMBHplMD7WZZ
         g1aQe7cCPnWG3NBnpFpbRFW0mN3sbn+OnP3+tU4IwFDy/i14pgt2uFATp74CkXfHI/yU
         +NJ7hJQAWH2gOxyWfr5BpCIRQj3quNw/ptEpyAMu/Ly0DFgvbcHvNxhc3CtZmhuHWtQM
         vocg==
X-Gm-Message-State: AJIora/hkYG4fIRXtRz2pPCjoac265OuCy+05S89xnR/qBxJzBI3qAtb
        8ZNJuDeu/T6EUdLUXBiafTHcdzKpSsM=
X-Google-Smtp-Source: AGRyM1tA+bL6FJK7kE8UZTprkXFTpmn4zCf/iuCUvS3zyiSH2HIqFUwRoJfp3VVRwXP0QcrJ5T5wRw==
X-Received: by 2002:a17:90b:3ec6:b0:1e8:a001:5c95 with SMTP id rm6-20020a17090b3ec600b001e8a0015c95mr8554338pjb.96.1655273468035;
        Tue, 14 Jun 2022 23:11:08 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id z10-20020aa785ca000000b0051b95c76752sm8725907pfn.153.2022.06.14.23.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 23:11:07 -0700 (PDT)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH V2] bcm63xx_enet: switch to napi_build_skb() to reuse skbuff_heads
Date:   Wed, 15 Jun 2022 14:09:22 +0800
Message-Id: <20220615060922.3402-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220614021009.696-1-liew.s.piaw@gmail.com>
References: <20220614021009.696-1-liew.s.piaw@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_build_skb() reuses NAPI skbuff_head cache in order to save some
cycles on freeing/allocating skbuff_heads on every new Rx or completed
Tx.
Use napi_consume_skb() to feed the cache with skbuff_heads of completed
Tx so it's never empty.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 698438a2ee0f..514d61dd91c7 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -388,7 +388,7 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 					 priv->rx_buf_size, DMA_FROM_DEVICE);
 			priv->rx_buf[desc_idx] = NULL;
 
-			skb = build_skb(buf, priv->rx_frag_size);
+			skb = napi_build_skb(buf, priv->rx_frag_size);
 			if (unlikely(!skb)) {
 				skb_free_frag(buf);
 				dev->stats.rx_dropped++;
@@ -468,7 +468,7 @@ static int bcm_enet_tx_reclaim(struct net_device *dev, int force)
 			dev->stats.tx_errors++;
 
 		bytes += skb->len;
-		dev_kfree_skb(skb);
+		napi_consume_skb(skb, !force);
 		released++;
 	}
 
-- 
2.17.1

