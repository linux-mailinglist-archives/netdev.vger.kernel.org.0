Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0927726A
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfGZTv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:51:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33071 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbfGZTv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:51:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so55662311wru.0
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5LkRE/JWbQBieMjA9x2ocuqgBsG0SHATA3QIioyLlOs=;
        b=Sld2VNZl5NfcmY8KiqVlkKKPEuJHfe12pDz1eXKnsZ5V/QBl9WiqCgI7g6Wkt0mMg0
         yRmafJwvkg/1twmdQg056TuWwoE5DcoW/7cMNJ6FJhTdCW+XlqW6lBtavzlBgNJUcUNe
         OCJngBgI38k2UDsCBzuJty3//h+qDzT+LimTivDKl2g3vjdzmSFD5iutj9jLml9dfwSX
         YmXdCgxbsRZuN6o2zmWMz5OzDofXWtGC7EmX6pNJYrHjG5zAQ+rAaRjRYAJy6quVnJLE
         TFGXU5iXMPZq+QW8jIEGQ+NINGMC/1tQyyM+HMFNdJ9FSM/BRSuyQKYbtWDooUU5NcFj
         go6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5LkRE/JWbQBieMjA9x2ocuqgBsG0SHATA3QIioyLlOs=;
        b=sI85Kek6bSunh89mY/6V47I9MbU0EBECwcgvYczhJl8EMyNYc1/gTJyNvgso4vFAoP
         qV9/RXOeTgClIjzIwaUDb/ua+0mht71TDwyLhUyNyZRZQogEL4yUx+HVEPDlL82kfB8c
         YR+CT3/Bjhf31I7Ql9pf05pNFbcSCjZS0Rj7N3mPCsOs4Gcxhd57WGHyysJJeYMsPSdm
         rx9M+nwfwMXscBNTqkPAAFxPTqlxUryWcgz8OHFI1cATL8IbQ+xXWtQ2/oTN+nfLdMaW
         GQ3nLJMyFARokXd+mwXHLzPhF7XmnljrZlISOB65IY+uFJBXzBLkexT4fN9tOld6ye+C
         Tblw==
X-Gm-Message-State: APjAAAUup/Jsj+nryzWNO+HabYl1RLN3Ir9KVfSaSgCUMmsApX5iJ5Si
        Wnk3JzQu5ngA+vXoSJLfMo/Q9GMP
X-Google-Smtp-Source: APXvYqwbJxGszrCaGiCwnmYEW9JBRKwbbjwPPL9saQk4cnlgehGitQwfWTYfnnNrlFAFmuV4AeJqLQ==
X-Received: by 2002:adf:db50:: with SMTP id f16mr92741589wrj.214.1564170713931;
        Fri, 26 Jul 2019 12:51:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id z1sm57144592wrv.90.2019.07.26.12.51.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:51:53 -0700 (PDT)
Subject: [PATCH net-next 2/4] r8169: implement callback ndo_features_check
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Message-ID: <7360d76e-2d95-116c-a519-a3d32df92b34@gmail.com>
Date:   Fri, 26 Jul 2019 21:49:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement callback ndo_features_check and move all feature checks there.
This will allow us to get rid of r8169_csum_workaround() completely in
a subsequent step. Like in the vendor driver disable HW csum for short
packets on RTL8168b.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 60 ++++++++++++++---------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 52a9e2d2f..7e1b68b19 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -539,11 +539,11 @@ enum rtl_tx_desc_bit_1 {
 	TD1_GTSENV4	= (1 << 26),		/* Giant Send for IPv4 */
 	TD1_GTSENV6	= (1 << 25),		/* Giant Send for IPv6 */
 #define GTTCPHO_SHIFT			18
-#define GTTCPHO_MAX			0x7fU
+#define GTTCPHO_MAX			0x7f
 
 	/* Second doubleword. */
 #define TCPHO_SHIFT			18
-#define TCPHO_MAX			0x3ffU
+#define TCPHO_MAX			0x3ff
 #define TD1_MSS_SHIFT			18	/* MSS position (11 bits) */
 	TD1_IPv6_CS	= (1 << 28),		/* Calculate IPv6 checksum */
 	TD1_IPv4_CS	= (1 << 29),		/* Calculate IPv4 checksum */
@@ -5534,11 +5534,6 @@ static void r8169_csum_workaround(struct rtl8169_private *tp,
 		} while (segs);
 
 		dev_consume_skb_any(skb);
-	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		if (skb_checksum_help(skb) < 0)
-			goto drop;
-
-		rtl8169_start_xmit(skb, tp->dev);
 	} else {
 drop:
 		tp->dev->stats.tx_dropped++;
@@ -5595,13 +5590,6 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 	u32 mss = skb_shinfo(skb)->gso_size;
 
 	if (mss) {
-		if (transport_offset > GTTCPHO_MAX) {
-			netif_warn(tp, tx_err, tp->dev,
-				   "Invalid transport offset 0x%x for TSO\n",
-				   transport_offset);
-			return false;
-		}
-
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
 			opts[0] |= TD1_GTSENV4;
@@ -5624,16 +5612,6 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 ip_protocol;
 
-		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
-			return !(skb_checksum_help(skb) || eth_skb_pad(skb));
-
-		if (transport_offset > TCPHO_MAX) {
-			netif_warn(tp, tx_err, tp->dev,
-				   "Invalid transport offset 0x%x\n",
-				   transport_offset);
-			return false;
-		}
-
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
 			opts[1] |= TD1_IPv4_CS;
@@ -5790,6 +5768,39 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 }
 
+static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
+						struct net_device *dev,
+						netdev_features_t features)
+{
+	int transport_offset = skb_transport_offset(skb);
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	if (skb_is_gso(skb)) {
+		if (transport_offset > GTTCPHO_MAX &&
+		    rtl_chip_supports_csum_v2(tp))
+			features &= ~NETIF_F_ALL_TSO;
+	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (skb->len < ETH_ZLEN) {
+			switch (tp->mac_version) {
+			case RTL_GIGA_MAC_VER_11:
+			case RTL_GIGA_MAC_VER_12:
+			case RTL_GIGA_MAC_VER_17:
+			case RTL_GIGA_MAC_VER_34:
+				features &= ~NETIF_F_CSUM_MASK;
+				break;
+			default:
+				break;
+			}
+		}
+
+		if (transport_offset > TCPHO_MAX &&
+		    rtl_chip_supports_csum_v2(tp))
+			features &= ~NETIF_F_CSUM_MASK;
+	}
+
+	return vlan_features_check(skb, features);
+}
+
 static void rtl8169_pcierr_interrupt(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -6546,6 +6557,7 @@ static const struct net_device_ops rtl_netdev_ops = {
 	.ndo_stop		= rtl8169_close,
 	.ndo_get_stats64	= rtl8169_get_stats64,
 	.ndo_start_xmit		= rtl8169_start_xmit,
+	.ndo_features_check	= rtl8169_features_check,
 	.ndo_tx_timeout		= rtl8169_tx_timeout,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= rtl8169_change_mtu,
-- 
2.22.0


