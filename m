Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1702450D3AA
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiDXQ4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiDXQ4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:56:12 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520D62FE71
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 09:53:09 -0700 (PDT)
Received: (qmail 99495 invoked by uid 89); 24 Apr 2022 16:53:08 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 24 Apr 2022 16:53:08 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, kuba@kernel.org
Subject: [PATCH net-next RESEND] net: bcmgenet: hide status block before TX timestamping
Date:   Sun, 24 Apr 2022 09:53:07 -0700
Message-Id: <20220424165307.591145-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware checksum offloading requires use of a transmit
status block inserted before the outgoing frame data, this was
updated in '9a9ba2a4aaaa ("net: bcmgenet: always enable status blocks")'

However, skb_tx_timestamp() assumes that it is passed a raw frame
and PTP parsing chokes on this status block.

Fix this by calling __skb_pull(), which hides the TSB before calling
skb_tx_timestamp(), so an outgoing PTP packet is parsed correctly.

As the data in the skb has already been set up for DMA, and the
dma_unmap_* calls use a separately stored address, there is no
no effective change in the data transmission.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 9a41145dadfc..bf1ec8fdc2ad 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2035,6 +2035,11 @@ static struct sk_buff *bcmgenet_add_tsb(struct net_device *dev,
 	return skb;
 }
 
+static void bcmgenet_hide_tsb(struct sk_buff *skb)
+{
+	__skb_pull(skb, sizeof(struct status_64));
+}
+
 static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -2141,6 +2146,8 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	GENET_CB(skb)->last_cb = tx_cb_ptr;
+
+	bcmgenet_hide_tsb(skb);
 	skb_tx_timestamp(skb);
 
 	/* Decrement total BD count and advance our write pointer */
-- 
2.31.1

