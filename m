Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14B12160F5
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 23:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGFV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 17:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgGFV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 17:29:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020E1C061755;
        Mon,  6 Jul 2020 14:29:46 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a6so413075wmm.0;
        Mon, 06 Jul 2020 14:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YZ4Pql26T2moc6ZBm7cHRup7HWUPcoRhzK3Ds8OBJWc=;
        b=ekYUdyKjMfCAkGTCUphtxoBBxcPth2d8dIx4NYzjWDmCQ4da/8O1ep1cUteadAgk39
         lRovPgx2I6NqVGy7SFpwvaYcL8snmiPuw5QFQP01S7jzbqIujE9s9IAgpOIjv9N6Vz3b
         xaCYWb4MKbijtHnsyB3cJvgFOr5fQFDugJegPjenez2prJiRmH7CrOpqtLRFxM6gRCJb
         489ipsLMPdccjZSJKxXuWDqw9qtUvl35oOlptyG8w5OJubKhZ4m5ZnpWIGlTX56Vg98s
         57sX83xxQRnBpLNZk0g8FitPZxWkpmJPscphfJWEU89PjA59pWJzKN90RBy7ebEw4Hn2
         AAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YZ4Pql26T2moc6ZBm7cHRup7HWUPcoRhzK3Ds8OBJWc=;
        b=gY75WZqp8v3h8ARZvVpZyxJFp4X20fi9wUP0CCsCakFF1ILNaHRiJdVPjsqKyreJ2W
         Mh8wRTWEB212WXSSwM+a6+r0woDP4nnQ0PqE7m1sbyR6B0GnE3DAjRybN7TyTFx31kE2
         Y94S7rxvKckSmoUrxuT8UBdBbG/9iej/m6MLeaxZoNArNKCgWQVYwV9MVCk1YY+S8SQj
         co4wrcpVrslDGoY0NYGdKC/qjr67QbqPghnYeN2jbkO+zx6WWl5BIB1dWc3nujv0eysa
         EhLTvHNG6lE/trLkwpIlgtcx2JB+dmpJ6+SQpzjhVdoO8Vt3RaYTiKjsahfTbCfj8UQj
         HerQ==
X-Gm-Message-State: AOAM532lwhHtSn9G9xtqF2q5+jiRC0SCbjHZzBBx/9wxzxIenx4+4HU2
        Wn1kR9M9XKVFlZHSEY29hQqSC09t
X-Google-Smtp-Source: ABdhPJw1sjpEEt32mXeA+R7BazYYa1pjnPGQtAtJzSuPP89XD3+NZF1ZtQH3F4Exiw6Fe0U39EZwng==
X-Received: by 2002:a1c:6706:: with SMTP id b6mr982876wmc.167.1594070985277;
        Mon, 06 Jul 2020 14:29:45 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l1sm13841535wrb.12.2020.07.06.14.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 14:29:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: systemport: Add support for VLAN transmit acceleration
Date:   Mon,  6 Jul 2020 14:29:39 -0700
Message-Id: <20200706212939.15856-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SYSTEMPORT is capable of performing VLAN transmit acceleration, support
that by configuring it appropriately, providing the VLAN ID and PCP/DEI
where necessary.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 37 ++++++++++++++++++++--
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b25356e21a1e..b470551bae4f 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -160,13 +160,26 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 	/* Hardware transmit checksum requires us to enable the Transmit status
 	 * block prepended to the packet contents
 	 */
-	priv->tsb_en = !!(wanted & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM));
+	priv->tsb_en = !!(wanted & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				    NETIF_F_HW_VLAN_CTAG_TX));
 	reg = tdma_readl(priv, TDMA_CONTROL);
 	if (priv->tsb_en)
 		reg |= tdma_control_bit(priv, TSB_EN);
 	else
 		reg &= ~tdma_control_bit(priv, TSB_EN);
+	/* Indicating that software inserts Broadcom tags is needed for the TX
+	 * checksum to be computed correctly when using VLAN HW acceleration,
+	 * else it has no effect, so it can always be turned on.
+	 */
+	if (netdev_uses_dsa(dev))
+		reg |= tdma_control_bit(priv, SW_BRCM_TAG);
+	else
+		reg &= ~tdma_control_bit(priv, SW_BRCM_TAG);
 	tdma_writel(priv, reg, TDMA_CONTROL);
+
+	/* Default TPID is ETH_P_8021AD, change to ETH_P_8021Q */
+	if (wanted & NETIF_F_HW_VLAN_CTAG_TX)
+		tdma_writel(priv, ETH_P_8021Q, TDMA_TPID);
 }
 
 static int bcm_sysport_set_features(struct net_device *dev,
@@ -1236,6 +1249,12 @@ static struct sk_buff *bcm_sysport_insert_tsb(struct sk_buff *skb,
 	/* Zero-out TSB by default */
 	memset(tsb, 0, sizeof(*tsb));
 
+	if (skb_vlan_tag_present(skb)) {
+		tsb->pcp_dei_vid = (skb_vlan_tag_get_prio(skb) >>
+				    VLAN_PRIO_SHIFT & PCP_DEI_MASK);
+		tsb->pcp_dei_vid |= (u32)skb_vlan_tag_get_id(skb) << VID_SHIFT;
+	}
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		ip_ver = skb->protocol;
 		switch (ip_ver) {
@@ -1251,6 +1270,9 @@ static struct sk_buff *bcm_sysport_insert_tsb(struct sk_buff *skb,
 
 		/* Get the checksum offset and the L4 (transport) offset */
 		csum_start = skb_checksum_start_offset(skb) - sizeof(*tsb);
+		/* Account for the HW inserted VLAN tag */
+		if (skb_vlan_tag_present(skb))
+			csum_start += VLAN_HLEN;
 		csum_info = (csum_start + skb->csum_offset) & L4_CSUM_PTR_MASK;
 		csum_info |= (csum_start << L4_PTR_SHIFT);
 
@@ -1330,6 +1352,8 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 		       DESC_STATUS_SHIFT;
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		len_status |= (DESC_L4_CSUM << DESC_STATUS_SHIFT);
+	if (skb_vlan_tag_present(skb))
+		len_status |= (TX_STATUS_VLAN_VID_TSB << DESC_STATUS_SHIFT);
 
 	ring->curr_desc++;
 	if (ring->curr_desc == ring->size)
@@ -1503,7 +1527,13 @@ static int bcm_sysport_init_tx_ring(struct bcm_sysport_priv *priv,
 		reg |= RING_IGNORE_STATUS;
 	}
 	tdma_writel(priv, reg, TDMA_DESC_RING_MAPPING(index));
-	tdma_writel(priv, 0, TDMA_DESC_RING_PCP_DEI_VID(index));
+	reg = 0;
+	/* Adjust the packet size calculations if SYSTEMPORT is responsible
+	 * for HW insertion of VLAN tags
+	 */
+	if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)
+		reg = VLAN_HLEN << RING_PKT_SIZE_ADJ_SHIFT;
+	tdma_writel(priv, reg, TDMA_DESC_RING_PCP_DEI_VID(index));
 
 	/* Enable ACB algorithm 2 */
 	reg = tdma_readl(priv, TDMA_CONTROL);
@@ -2523,7 +2553,8 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	netif_napi_add(dev, &priv->napi, bcm_sysport_poll, 64);
 
 	dev->features |= NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
-			 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+			 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+			 NETIF_F_HW_VLAN_CTAG_TX;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 
-- 
2.17.1

