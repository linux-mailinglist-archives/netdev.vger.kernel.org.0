Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0D62F2A16
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405577AbhALIcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405230AbhALIcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:32:05 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45DDC061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:31:24 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a12so1495282wrv.8
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PQQa2bXqMB0L6EZnJGHlqQyCdoS8v8GxuelOcwERFVg=;
        b=Nwu4utx8eltQUuq6657VtbcWWvDyLrfVeNcqW3dzh/0DI/e+8FFLcLFMym0hjIesw3
         VqGXqLW+wFqZcxfpx6XuogKDx1+zlMhY+4D2esHzG5fl3aP/ehN2nUWujj89W1l7Ucal
         wseYftq1/KVFN4/xaY1Awoqbero34RdSkTSU+P9Ko4Zl3l+TfvHU1KhsPnyzF55IVwVR
         SyCwQI3vhxMrosWb13DUrQ+5FHya5v2MFsNxWOGRW24Mq/gj4eSh9ggSBoLW3nks4G5R
         2dGkyCkitncxNcJwQDHRsTRuBEVlEsQDc37PEz31ZqWP896fF12H4Kx9D1uBcER72gy+
         wngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PQQa2bXqMB0L6EZnJGHlqQyCdoS8v8GxuelOcwERFVg=;
        b=K3CAsdWAuJHg8VysG33ZI4Ww4E4wEhu4A1iJ350Zg6FzlEQKeNsVZ6QdV2mBRR8RQd
         DXsiS2xMLF5mJHhh+K26Sgqxuf/mUyZByjT/qCkxzqscZoVGdpfspmK+o+0M9G66RtV1
         AdJQPK+BvXETyflhnqJWU6QIA4mh4f9q95apwD8gBxBNqZEepbhlgBCUSBp+o4ZpBEBp
         Ub9XoqqPqONje06L384Nu+GlPaen2tEcpo0mM9dHIrdVqo1d1RKP1PO15+sZNlHC7C3J
         IgMijErkTUu9qWljlTivlm++DlDbgvUY9CoWn0Cl83MnO6OrdiXD8o1t41SYjbFQ0hy3
         MGsQ==
X-Gm-Message-State: AOAM530CvUCg6QM5QFDoNeZ/cEMeKwtjrfKdgk2MU7K6lPl2s2YZj2Mt
        dlYV1NtfboxgCaThDVB11KEkzQw5kg8=
X-Google-Smtp-Source: ABdhPJw6eieqMKF5G0MM4OQwdJIyVH+HNuieFpRV/GaKYgWtWaxYKw/nq2boedgbrFMXliZImU3SBw==
X-Received: by 2002:adf:9d82:: with SMTP id p2mr3013208wre.330.1610440283404;
        Tue, 12 Jan 2021 00:31:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:d420:a714:6def:4af7? (p200300ea8f065500d420a7146def4af7.dip0.t-ipconnect.de. [2003:ea:8f06:5500:d420:a714:6def:4af7])
        by smtp.googlemail.com with ESMTPSA id h5sm3789093wrp.56.2021.01.12.00.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 00:31:23 -0800 (PST)
Subject: [PATCH net-next 3/3] r8169: improve DASH support
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Message-ID: <e8797322-21f1-5d13-ca22-cf1d793ef3ab@gmail.com>
Date:   Tue, 12 Jan 2021 09:31:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of doing the full DASH check each time r8168_check_dash() is
called, let's do it once in probe and store DASH capabilities in a
new rtl8169_private member.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 53 ++++++++++-------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b4c080cc6..fb67d8f79 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -591,6 +591,12 @@ enum rtl_flag {
 	RTL_FLAG_MAX
 };
 
+enum rtl_dash_type {
+	RTL_DASH_NONE,
+	RTL_DASH_DP,
+	RTL_DASH_EP,
+};
+
 struct rtl8169_private {
 	void __iomem *mmio_addr;	/* memory map physical address */
 	struct pci_dev *pci_dev;
@@ -598,6 +604,7 @@ struct rtl8169_private {
 	struct phy_device *phydev;
 	struct napi_struct napi;
 	enum mac_version mac_version;
+	enum rtl_dash_type dash_type;
 	u32 cur_rx; /* Index into the Rx descriptor buffer of next Rx pkt. */
 	u32 cur_tx; /* Index into the Tx descriptor buffer of next Rx pkt. */
 	u32 dirty_tx;
@@ -1184,19 +1191,10 @@ static void rtl8168ep_driver_start(struct rtl8169_private *tp)
 
 static void rtl8168_driver_start(struct rtl8169_private *tp)
 {
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
-	case RTL_GIGA_MAC_VER_28:
-	case RTL_GIGA_MAC_VER_31:
+	if (tp->dash_type == RTL_DASH_DP)
 		rtl8168dp_driver_start(tp);
-		break;
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
+	else
 		rtl8168ep_driver_start(tp);
-		break;
-	default:
-		BUG();
-		break;
-	}
 }
 
 static void rtl8168dp_driver_stop(struct rtl8169_private *tp)
@@ -1215,44 +1213,35 @@ static void rtl8168ep_driver_stop(struct rtl8169_private *tp)
 
 static void rtl8168_driver_stop(struct rtl8169_private *tp)
 {
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
-	case RTL_GIGA_MAC_VER_28:
-	case RTL_GIGA_MAC_VER_31:
+	if (tp->dash_type == RTL_DASH_DP)
 		rtl8168dp_driver_stop(tp);
-		break;
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
+	else
 		rtl8168ep_driver_stop(tp);
-		break;
-	default:
-		BUG();
-		break;
-	}
 }
 
 static bool r8168dp_check_dash(struct rtl8169_private *tp)
 {
 	u16 reg = rtl8168_get_ocp_reg(tp);
 
-	return !!(r8168dp_ocp_read(tp, reg) & 0x00008000);
+	return r8168dp_ocp_read(tp, reg) & BIT(15);
 }
 
 static bool r8168ep_check_dash(struct rtl8169_private *tp)
 {
-	return r8168ep_ocp_read(tp, 0x128) & 0x00000001;
+	return r8168ep_ocp_read(tp, 0x128) & BIT(0);
 }
 
-static bool r8168_check_dash(struct rtl8169_private *tp)
+static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_27:
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
-		return r8168dp_check_dash(tp);
+		return r8168dp_check_dash(tp) ? RTL_DASH_DP : RTL_DASH_NONE;
 	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
-		return r8168ep_check_dash(tp);
+		return r8168ep_check_dash(tp) ? RTL_DASH_EP : RTL_DASH_NONE;
 	default:
-		return false;
+		return RTL_DASH_NONE;
 	}
 }
 
@@ -2222,7 +2211,7 @@ static void rtl_wol_enable_rx(struct rtl8169_private *tp)
 
 static void rtl_prepare_power_down(struct rtl8169_private *tp)
 {
-	if (r8168_check_dash(tp))
+	if (tp->dash_type != RTL_DASH_NONE)
 		return;
 
 	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
@@ -4880,7 +4869,7 @@ static void rtl_remove_one(struct pci_dev *pdev)
 
 	unregister_netdev(tp->dev);
 
-	if (r8168_check_dash(tp))
+	if (tp->dash_type != RTL_DASH_NONE)
 		rtl8168_driver_stop(tp);
 
 	rtl_release_firmware(tp);
@@ -5240,6 +5229,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->mac_version = chipset;
 
+	tp->dash_type = rtl_check_dash(tp);
+
 	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
@@ -5344,7 +5335,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    jumbo_max, tp->mac_version <= RTL_GIGA_MAC_VER_06 ?
 			    "ok" : "ko");
 
-	if (r8168_check_dash(tp)) {
+	if (tp->dash_type != RTL_DASH_NONE) {
 		netdev_info(dev, "DASH enabled\n");
 		rtl8168_driver_start(tp);
 	}
-- 
2.30.0


