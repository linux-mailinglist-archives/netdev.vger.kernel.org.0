Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED0031442
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfEaRzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:55:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38307 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaRzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:55:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so7069722wrs.5
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GbiuSmQzffHigthf/AQCpBxGe91ttl1QTpYiMWUAxhg=;
        b=K3m3TIfkafEk0A7zQI9vk4q5gdHzeHXqlZQPaCtwlKm+4SI/WNhk6xoZ2IGmesdTli
         MyQ2D21/bjUhA5HOd1BagSW5TXMTuQ4lPAfc+NR5muCZk0zypl6lsSso769Qwb5+sTjA
         i8hUoBwMcBhB7d7Ft20QMAyEXpePfFSJE23S8VAX4C+9RE/11H4TOh2DNYaXGOn/3jV+
         YJssU0vYK76A4g2HDTsG9RYt19QM5PO8fW6rFHyBEREFJRVos7KrS2ZJJaRHZYGHkNmr
         lV7DzhlGbumexBOzsYwPjXaZBnww2cXJmKpHmrTYpSmSV1olprKAidmzppNkls7tcpms
         qhOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GbiuSmQzffHigthf/AQCpBxGe91ttl1QTpYiMWUAxhg=;
        b=piF097kFDXbKcntORKtfdWlec76RuSYFhhYc8T3fMIBTHRk2mxBwTmoeio6iszj0Oy
         t3rGU3TzmF8n7yoSP/2jdagwSfu1yvCwLn6eom24vEjIDzL5tRTo34wEuDVSwnkX6iXg
         C0tkw9bVcvHos4f1KmPpcjEeuTHr75jMJUMy+b7u73v/IQaUjOKUKTXfP3F+/EfdT5TK
         mn1ppCTX45pVvsLpwrHNWcLLGVV0DjuWAM3k7FjGxBDNvmL46ZRM3/WUAlGUdf2H8sux
         mpLOGBx22TFmAYXE+Do2cEvsc7wZ1qLiZ11DRpBFHQAeo+xAfGIZzw147VJ3588el+Ee
         j8oQ==
X-Gm-Message-State: APjAAAXU2VUee4y/TqlsNPAM9w4fPal4yNAMqyCNXmuTcAWGAyHSoEyK
        kFtwwpJiEzK6O8wnBqTXt1X0jiNs
X-Google-Smtp-Source: APXvYqx17uSjTYJz/h5NXO1KxoX4NEJLBWP3gb7KAbbcx12ASsJW0iI1/x43XBGNRQJ7L6gGs+AJUA==
X-Received: by 2002:a5d:65c9:: with SMTP id e9mr7504589wrw.348.1559325319321;
        Fri, 31 May 2019 10:55:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id n4sm1759652wmk.41.2019.05.31.10.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:55:18 -0700 (PDT)
Subject: [PATCH net-next 3/3] r8169: avoid tso csum function indirection
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
Message-ID: <2d7d8add-39e6-3102-c3e7-9249e3764c0f@gmail.com>
Date:   Fri, 31 May 2019 19:55:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace indirect call to tso_csum with direct calls. To do this we have
to move rtl_chip_supports_csum_v2().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 46 +++++++++++++---------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index fc58f89be..2705eb510 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -656,7 +656,6 @@ struct rtl8169_private {
 	struct clk *clk;
 
 	void (*hw_start)(struct rtl8169_private *tp);
-	bool (*tso_csum)(struct rtl8169_private *, struct sk_buff *, u32 *);
 
 	struct {
 		DECLARE_BITMAP(flags, RTL_FLAG_MAX);
@@ -5780,8 +5779,7 @@ static int msdn_giant_send_check(struct sk_buff *skb)
 	return ret;
 }
 
-static bool rtl8169_tso_csum_v1(struct rtl8169_private *tp,
-				struct sk_buff *skb, u32 *opts)
+static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
 
@@ -5798,8 +5796,6 @@ static bool rtl8169_tso_csum_v1(struct rtl8169_private *tp,
 		else
 			WARN_ON_ONCE(1);
 	}
-
-	return true;
 }
 
 static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
@@ -5889,6 +5885,18 @@ static bool rtl_tx_slots_avail(struct rtl8169_private *tp,
 	return slots_avail > nr_frags;
 }
 
+/* Versions RTL8102e and from RTL8168c onwards support csum_v2 */
+static bool rtl_chip_supports_csum_v2(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -5911,9 +5919,13 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(skb));
 	opts[0] = DescOwn;
 
-	if (!tp->tso_csum(tp, skb, opts)) {
-		r8169_csum_workaround(tp, skb);
-		return NETDEV_TX_OK;
+	if (rtl_chip_supports_csum_v2(tp)) {
+		if (!rtl8169_tso_csum_v2(tp, skb, opts)) {
+			r8169_csum_workaround(tp, skb);
+			return NETDEV_TX_OK;
+		}
+	} else {
+		rtl8169_tso_csum_v1(skb, opts);
 	}
 
 	len = skb_headlen(skb);
@@ -6951,18 +6963,6 @@ static void rtl_hw_initialize(struct rtl8169_private *tp)
 	}
 }
 
-/* Versions RTL8102e and from RTL8168c onwards support csum_v2 */
-static bool rtl_chip_supports_csum_v2(struct rtl8169_private *tp)
-{
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
-	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
-		return false;
-	default:
-		return true;
-	}
-}
-
 static int rtl_jumbo_max(struct rtl8169_private *tp)
 {
 	/* Non-GBit versions don't support jumbo frames */
@@ -7158,12 +7158,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* Disallow toggling */
 		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
-	if (rtl_chip_supports_csum_v2(tp)) {
-		tp->tso_csum = rtl8169_tso_csum_v2;
+	if (rtl_chip_supports_csum_v2(tp))
 		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
-	} else {
-		tp->tso_csum = rtl8169_tso_csum_v1;
-	}
 
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
-- 
2.21.0


