Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73E54A6D6
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354023AbiFNC0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353760AbiFNCYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:24:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13EE424A8;
        Mon, 13 Jun 2022 19:11:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i1so6596392plg.7;
        Mon, 13 Jun 2022 19:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=FYzXgdthAZD32NzfmkML1dqEbj0WlSr8VfOOFBhh2h4=;
        b=o+5aALer+JB8O4pzESBBqN0ncmWIYjVBpXSSFwMEZ+VFzArRO2BosS77zMfXKRFh9o
         3n+xL9UVssxOFdxywa+Uu18gDfSZHJ+St1rsrCCB2k3Jj29Fv/enU65Yms//SHWgvvqJ
         ogshTTpVuWvveAy7G1IoTOjJUFmCk5fsZV2EDHOOL3FlH2jA1baB58zUWlMwCSCocNOc
         d1/j7HWU8tv/C91PigB2XMJc6jsTwy4qj6d01NTbJRQ7KYg+mE9YWes1WTedUDzprryT
         IhPtVl7jVlW7hdlNOyM8KVGXUgwpxhdWLG3ulM7G7wAigx7aNjYGjiXwNu4GatnvrUPL
         1W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FYzXgdthAZD32NzfmkML1dqEbj0WlSr8VfOOFBhh2h4=;
        b=se/x40kfSbM+aTSLpGGAk+53E7WXETzBJeqowsqomraH2d/jrtUP0IU4ZP5yWb/gPd
         6OAoz6RINtMYYp7d2u8WF50dTSdyuo3qixhEF3cLJIyXa4zGI70At4u2srSk7SsMHNzV
         WVhoEeinjIu32/uzRVArj6rZLrABYcXxJsRZSG/fjX2LVcp6TPWcYeEERUdNVWXWimTR
         T3eVb/O+WS8+FroqhgCkAr4Qsxjnj21I2zIAArOu1hH2zHUe9eDh3gUeWyzEW89Qzff/
         e/56FHyxyepdTas2lnP+mYtrM5msYqMLSspc383Zin03PRcAAqi8t+flyaEPxozQDugj
         ccig==
X-Gm-Message-State: AJIora/2NpjuuBWVa4t+lKCA5gJUQAel65QgzlVm8s4TW3wtAll2II9v
        uaBub9L9ok3TpT8q4U6rCUA=
X-Google-Smtp-Source: ABdhPJw8XCUTMeHfehkgeeG+OjcOFxUsFl3t9W9PfSU3TbupRf5AvP5AT06zc0c42bKzGM3CDnMXOQ==
X-Received: by 2002:a17:902:ca0d:b0:166:44aa:abea with SMTP id w13-20020a170902ca0d00b0016644aaabeamr1916555pld.67.1655172672188;
        Mon, 13 Jun 2022 19:11:12 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain (kbu-120-71.tm.net.my. [203.106.120.71])
        by smtp.gmail.com with ESMTPSA id a13-20020a62e20d000000b0051c2fc79aa8sm6291116pfi.91.2022.06.13.19.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 19:10:42 -0700 (PDT)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     davem@davemloft.com, edumazet@google.com, kuba@kernel.org,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH] bcm63xx_enet: reuse skbuff_head
Date:   Tue, 14 Jun 2022 10:10:09 +0800
Message-Id: <20220614021009.696-1-liew.s.piaw@gmail.com>
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

napi_build_skb() reuses NAPI skbuff_head cache in order to save some
cycles on freeing/allocating skbuff_heads on every new Rx or completed
Tx.
Use napi_consume_skb() to feed the cache with skbuff_heads of completed
Tx so it's never empty.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
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

