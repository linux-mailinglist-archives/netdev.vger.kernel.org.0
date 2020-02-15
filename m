Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB52815FEB5
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgBONyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:54:43 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40222 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgBONym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:54:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so13867030wmi.5
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xhcr1JSZN9mrLpDzKd4UDLzrvfdLETKaAWkV9cGi/AQ=;
        b=chbI49HNBlylen5mTRISq5nsTUX3uV93N4sOLnLNYvcTjPJdfDgKzzvpP9Pk4XskP7
         KMp1yqKBtvXz3Y7osBQV8L4HtgsDAsgtXreMcIlqQBeauWT+/KccEnpAPcWDhPBqFEjL
         QXMhi6ZLtJAvR3jCiPkE9+vp9WwVjrSG0l++LWXVlOglIzqkP4LHNctn7e6IUhrJe9zq
         WFCCL4j8veNTBzBBFjyU7JqagSwXvlGURalHsqz2riIS6bExTtdbDHNnTL1uuihdwRcY
         wAc2AV2yBwHlZtzbGPKwzffBJq8TmmGeobM2YVPFnl67s+dUHxA6rU/puSO8WEi3qbCz
         PThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xhcr1JSZN9mrLpDzKd4UDLzrvfdLETKaAWkV9cGi/AQ=;
        b=dy7bZdbhHYx2+SvgrjTuw+lan0LFPAbUooKlLgG7tUtGvsWxLPO/m1cOWBH90cpJ9d
         L+K6p62AJ76EZ4X9aAm66mb8W0JbdV1Pn3hToo9rL/8N3uxPFSdrNhJg12RUkOymAApj
         6rfuQuvatsiWS8+9+pMiIIN/TGEqH0UiX/uXMfe4IBfAYiy+8C5xThjWKFb/pG6C29dM
         qeRP7aTHVbHtxZbeWsV9bvnCd0KP3ge1CNHe4f+2BjZuF+bV3k6r15PbIgUPISfiAm97
         h7atRNjWfnC4wftFOV4fWZCunq0j0DuiR7vMKXDfI3kY//7naNcvXLAJR8Vp4GwEt3L4
         2Rhg==
X-Gm-Message-State: APjAAAW+LZIoWfdSL/60LVQdYhMLMKSpOPEPZCDL8gA25SD77i6cthDW
        galPZfJ9fXx1erl8zlt6HW4fkfn+
X-Google-Smtp-Source: APXvYqyZu5UPvql1aIlG3AR8KfkPlDUeUvC0Z6WpVpUA1/cmNNCTaEvj5EaDkwZxgKCVLYTHHItwwg==
X-Received: by 2002:a7b:ce18:: with SMTP id m24mr11081577wmc.123.1581774879904;
        Sat, 15 Feb 2020 05:54:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id v14sm11480968wrm.28.2020.02.15.05.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:54:39 -0800 (PST)
Subject: [PATCH net-next 6/7] r8169: improve rtl_jumbo_config
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Message-ID: <44dcba3f-c804-ed96-fe52-46a7be8ba858@gmail.com>
Date:   Sat, 15 Feb 2020 14:52:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge enabling and disabling jumbo packets to one function to make
the code a little simpler.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 69 +++++++++--------------
 1 file changed, 27 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 25b0cae73..ce4cb7d7b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2472,66 +2472,52 @@ static void r8168b_1_hw_jumbo_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~(1 << 0));
 }
 
-static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
+static void rtl_jumbo_config(struct rtl8169_private *tp)
 {
-	rtl_unlock_config_regs(tp);
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_12:
-	case RTL_GIGA_MAC_VER_17:
-		pcie_set_readrq(tp->pci_dev, 512);
-		r8168b_1_hw_jumbo_enable(tp);
-		break;
-	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
-		pcie_set_readrq(tp->pci_dev, 512);
-		r8168c_hw_jumbo_enable(tp);
-		break;
-	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
-		r8168dp_hw_jumbo_enable(tp);
-		break;
-	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
-		pcie_set_readrq(tp->pci_dev, 512);
-		r8168e_hw_jumbo_enable(tp);
-		break;
-	default:
-		break;
-	}
-	rtl_lock_config_regs(tp);
-}
+	bool jumbo = tp->dev->mtu > ETH_DATA_LEN;
 
-static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
-{
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
-		r8168b_1_hw_jumbo_disable(tp);
+		if (jumbo) {
+			pcie_set_readrq(tp->pci_dev, 512);
+			r8168b_1_hw_jumbo_enable(tp);
+		} else {
+			r8168b_1_hw_jumbo_disable(tp);
+		}
 		break;
 	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
-		r8168c_hw_jumbo_disable(tp);
+		if (jumbo) {
+			pcie_set_readrq(tp->pci_dev, 512);
+			r8168c_hw_jumbo_enable(tp);
+		} else {
+			r8168c_hw_jumbo_disable(tp);
+		}
 		break;
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
-		r8168dp_hw_jumbo_disable(tp);
+		if (jumbo)
+			r8168dp_hw_jumbo_enable(tp);
+		else
+			r8168dp_hw_jumbo_disable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
-		r8168e_hw_jumbo_disable(tp);
+		if (jumbo) {
+			pcie_set_readrq(tp->pci_dev, 512);
+			r8168e_hw_jumbo_enable(tp);
+		} else {
+			r8168e_hw_jumbo_disable(tp);
+		}
 		break;
 	default:
 		break;
 	}
 	rtl_lock_config_regs(tp);
 
-	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
+	if (!jumbo && pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
 		pcie_set_readrq(tp->pci_dev, 4096);
 }
 
-static void rtl_jumbo_config(struct rtl8169_private *tp, int mtu)
-{
-	if (mtu > ETH_DATA_LEN)
-		rtl_hw_jumbo_enable(tp);
-	else
-		rtl_hw_jumbo_disable(tp);
-}
-
 DECLARE_RTL_COND(rtl_chipcmd_cond)
 {
 	return RTL_R8(tp, ChipCmd) & CmdReset;
@@ -3875,7 +3861,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
 
-	rtl_jumbo_config(tp, tp->dev->mtu);
+	rtl_jumbo_config(tp);
 
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
 	rtl_pci_commit(tp);
@@ -3891,10 +3877,9 @@ static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl_jumbo_config(tp, new_mtu);
-
 	dev->mtu = new_mtu;
 	netdev_update_features(dev);
+	rtl_jumbo_config(tp);
 
 	return 0;
 }
-- 
2.25.0


