Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6448E1B9433
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 23:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgDZVhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 17:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726184AbgDZVhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 17:37:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E01CC061A10
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:37:04 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d15so16630414wrx.3
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q5e+bi1cnGpr6cVmIvYMzhmTFzbpKVAwnDYnF4NIAN4=;
        b=OfINhdLi+GOCnhpGJF2YZQKD7PA4VelcYt6FpEK+EHynuLu2dPAaEdoXkgh9/ChTz7
         la5GG/mCBZZT2Y9oTPArcSZmQ1yl5cI6+agy/kqPcrFHUVb+lYtPyYLDNquHJRjUA5zD
         W7sYTOHbfloEydGVSYYqMkz/E/VBLuUB7QgwZbtc4nCQqGMBp7nQNDSlJLRMtBjC2rHc
         UKABWI3O+AVDiEFGA5wHepNoy/gbFGNy+lQSwobEGCQMUxvOVo0uOn1KLgWZqlnlWxVb
         KcH3qo6dvV/UoFhwMMZKUx0TWgct/g9O2dAhHklZCc+eQJfd0aGlrqI0ut+A2Gohe+pv
         SBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q5e+bi1cnGpr6cVmIvYMzhmTFzbpKVAwnDYnF4NIAN4=;
        b=ApxvDv3FuD+ZjVWznEAaU/sC/8CHpPt+VI8gkJhH0+QY3/IK50F20HmnFkeOBpWQuX
         EzcCVJmf0wTLebeuftKfYiJqvBzFCmMgeZ3Fc5txdiRjlWVd36QDv9Z2/kwAJeGe47XA
         KgcYfWe2kJPee4UMlah3mOkEarsrUEAyF4DDv7oF7gtsiYMYJUbWZRj6e6lSyOH6sKNf
         IWMMWY0yjR+zdFxyoFCS7MVhYo+pgA7R+6ISLScMpucBHAxXU+2DHkoj+l9bocrH1cAe
         tU10PqZRDTBSX8npO2LZoGDvIwphk2Ch1zWw64fmcoSQZFU7y8lfk6hrMPCJHHeq9Y8p
         Qhiw==
X-Gm-Message-State: AGi0PuY/GIOdPk+Cjfeez7ZPjnye5hNzM4e6p+eMHHyScO6ZLSJm8YBi
        DoiDq/KHcnTkc5bVnqnbPz8WCTWD
X-Google-Smtp-Source: APiQypJG/8nB81s24X0sWaKCuzfEBS1P85Q2+BQtfKAoJiDMSoAqHWxAuud76e5ezG2VCRRL9GC1kg==
X-Received: by 2002:a5d:6082:: with SMTP id w2mr23391178wrt.163.1587937023107;
        Sun, 26 Apr 2020 14:37:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d1d0:8c1c:405c:5986? (p200300EA8F296000D1D08C1C405C5986.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d1d0:8c1c:405c:5986])
        by smtp.googlemail.com with ESMTPSA id g69sm13568766wmg.17.2020.04.26.14.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 14:37:02 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: improve configuring RxConfig register
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e076bba2-e4dc-f8ce-d119-5b6735017727@gmail.com>
Message-ID: <64225a09-e14c-3438-7f87-c3ffb865b3fd@gmail.com>
Date:   Sun, 26 Apr 2020 23:36:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e076bba2-e4dc-f8ce-d119-5b6735017727@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two bits in RxConfig are controlled by the following dev->feature's:
- NETIF_F_RXALL
- NETIF_F_HW_VLAN_CTAG_RX (since RTL8125)

We have to take care that RxConfig gets fully configured in
rtl_hw_start() after e.g. resume from hibernation. Therefore:

- Factor out setting the feature-controlled RxConfig bits to a new
  function rtl_set_rx_config_features() that is called from
  rtl8169_set_features() and rtl_hw_start().
- Don't deal with RX_VLAN_8125 in rtl_init_rxcfg(), it will be set
  by rtl_set_rx_config_features().
- Don't handle NETIF_F_RXALL in rtl_set_rx_mode().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 38 ++++++++++++-----------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 06a877fe7..f70e36c20 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -388,10 +388,12 @@ enum rtl_register_content {
 	/* rx_mode_bits */
 	AcceptErr	= 0x20,
 	AcceptRunt	= 0x10,
+#define RX_CONFIG_ACCEPT_ERR_MASK	0x30
 	AcceptBroadcast	= 0x08,
 	AcceptMulticast	= 0x04,
 	AcceptMyPhys	= 0x02,
 	AcceptAllPhys	= 0x01,
+#define RX_CONFIG_ACCEPT_OK_MASK	0x0f
 #define RX_CONFIG_ACCEPT_MASK		0x3f
 
 	/* TxConfigBits */
@@ -1497,19 +1499,15 @@ static netdev_features_t rtl8169_fix_features(struct net_device *dev,
 	return features;
 }
 
-static int rtl8169_set_features(struct net_device *dev,
-				netdev_features_t features)
+static void rtl_set_rx_config_features(struct rtl8169_private *tp,
+				       netdev_features_t features)
 {
-	struct rtl8169_private *tp = netdev_priv(dev);
-	u32 rx_config;
-
-	rtl_lock_work(tp);
+	u32 rx_config = RTL_R32(tp, RxConfig);
 
-	rx_config = RTL_R32(tp, RxConfig);
 	if (features & NETIF_F_RXALL)
-		rx_config |= (AcceptErr | AcceptRunt);
+		rx_config |= RX_CONFIG_ACCEPT_ERR_MASK;
 	else
-		rx_config &= ~(AcceptErr | AcceptRunt);
+		rx_config &= ~RX_CONFIG_ACCEPT_ERR_MASK;
 
 	if (rtl_is_8125(tp)) {
 		if (features & NETIF_F_HW_VLAN_CTAG_RX)
@@ -1519,6 +1517,16 @@ static int rtl8169_set_features(struct net_device *dev,
 	}
 
 	RTL_W32(tp, RxConfig, rx_config);
+}
+
+static int rtl8169_set_features(struct net_device *dev,
+				netdev_features_t features)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	rtl_lock_work(tp);
+
+	rtl_set_rx_config_features(tp, features);
 
 	if (features & NETIF_F_RXCSUM)
 		tp->cp_cmd |= RxChkSum;
@@ -2395,8 +2403,6 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
-	u32 vlan;
-
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
@@ -2411,9 +2417,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
 	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
-		/* VLAN flags are controlled by NETIF_F_HW_VLAN_CTAG_RX */
-		vlan = RTL_R32(tp, RxConfig) & RX_VLAN_8125;
-		RTL_W32(tp, RxConfig, vlan | RX_FETCH_DFLT_8125 | RX_DMA_BURST);
+		RTL_W32(tp, RxConfig, RX_FETCH_DFLT_8125 | RX_DMA_BURST);
 		break;
 	default:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
@@ -2680,14 +2684,11 @@ static void rtl_set_rx_mode(struct net_device *dev)
 		}
 	}
 
-	if (dev->features & NETIF_F_RXALL)
-		rx_mode |= (AcceptErr | AcceptRunt);
-
 	RTL_W32(tp, MAR0 + 4, mc_filter[1]);
 	RTL_W32(tp, MAR0 + 0, mc_filter[0]);
 
 	tmp = RTL_R32(tp, RxConfig);
-	RTL_W32(tp, RxConfig, (tmp & ~RX_CONFIG_ACCEPT_MASK) | rx_mode);
+	RTL_W32(tp, RxConfig, (tmp & ~RX_CONFIG_ACCEPT_OK_MASK) | rx_mode);
 }
 
 DECLARE_RTL_COND(rtl_csiar_cond)
@@ -3866,6 +3867,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
 	rtl_init_rxcfg(tp);
 	rtl_set_tx_config_registers(tp);
+	rtl_set_rx_config_features(tp, tp->dev->features);
 	rtl_set_rx_mode(tp->dev);
 	rtl_irq_enable(tp);
 }
-- 
2.26.2


