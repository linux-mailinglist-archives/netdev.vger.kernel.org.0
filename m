Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4315415FEB4
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgBONyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:54:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36097 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgBONyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:54:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so14363906wru.3
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ipD4LW6uHm0pxW7Uj+c2BamCcec0X8UMajzOQ1sCxqM=;
        b=MpUF7xG4e2QzBgUuxaT/T6rm5FdBQK0PqshtbUOW0wdi48WZfZBlO6n5G7ZkLpsFy6
         WXopulSyBq7Ny0yiE96MuUMRM0pv5/ndSXhp0LrU/Jk/Ayu4P5EHbLGxzrX15kcTn3d7
         Tq0ZovMVvAys4m2PPrc6Sw1Ar2CYZjmArgvDlOfLig21b+GqO7lSqXx/b4DWdHig4DaD
         MgOpweKHeoWFyZe5IGy8lj0OauoO80xeaXDmgkAomnoHlM+dS+L0YR+tE9mRjcLU5WP4
         NBgqzwcUGkrKpfQdnwSP8jTrhLhN/c7RAfdHJGmFVZb6E4hpIBv5DMy84RmOpjg4YDao
         sXKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ipD4LW6uHm0pxW7Uj+c2BamCcec0X8UMajzOQ1sCxqM=;
        b=ZBFisHNYIocyK6OyPlPr7ZU8tJ/LNabhPwewkzCcJE2cG0AqfbassTGsJIVQz/377f
         YhjdlxJqesbQH0PdqlrXYWoWoTxaj3XkqOLDhH0UoDycTSsb3L7jh8n2P1MwQRRMQAP4
         lEAyuZvoAj4zq0nHTQIGzOPPKLBuLdTTtCKn/CPv6a3DKrCjcDyEMRnAyEU4NuNmrNxD
         7sPOgd7tXmDJ26f0lsqV4tKwWtWmWTFN3Habvz5eGgqPo7FGf2ArnJdLv/JLP/UU02Qu
         uBJVZ4ZaOBh/khcpGOZabsEZlU4jdJWDXbImj3+Ide/5kl7nLe1ntr1r51ltf0aTT6Hj
         b5dg==
X-Gm-Message-State: APjAAAV8eKB6q34GKy6nXbDJYueSZeAWjmOeDa+3Wx656g8lG3Pzk1K0
        uNuv+ZAZkLF7ZCS6DN65UywGxLF4
X-Google-Smtp-Source: APXvYqwZgfZwze67UNb8gd/Rk09mfuYqLeb71Ms7w4BD3iUf3LxvHVKgQtaIVSL+Fj9G4oGMpWYdig==
X-Received: by 2002:a05:6000:8c:: with SMTP id m12mr10373468wrx.142.1581774878935;
        Sat, 15 Feb 2020 05:54:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id x132sm21294070wmg.0.2020.02.15.05.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:54:38 -0800 (PST)
Subject: [PATCH net-next 5/7] r8169: improve rtl8169_get_mac_version
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Message-ID: <8e8ffa83-3ab1-a53a-2eda-f0f3a793d21a@gmail.com>
Date:   Sat, 15 Feb 2020 14:52:05 +0100
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

Currently code snippet (RTL_R32(tp, TxConfig) >> 20) & 0xfcf is used
in few places to extract the chip XID. Change the code to do the XID
extraction only once.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 50 ++++++++++++-----------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 46e8e3dfa..25b0cae73 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2045,7 +2045,7 @@ static void rtl_enable_eee(struct rtl8169_private *tp)
 		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, adv);
 }
 
-static void rtl8169_get_mac_version(struct rtl8169_private *tp)
+static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 {
 	/*
 	 * The driver currently handles the 8168Bf and the 8168Be identically
@@ -2061,7 +2061,7 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 	static const struct rtl_mac_info {
 		u16 mask;
 		u16 val;
-		u16 mac_version;
+		enum mac_version ver;
 	} mac_info[] = {
 		/* 8125 family. */
 		{ 0x7cf, 0x608,	RTL_GIGA_MAC_VER_60 },
@@ -2148,22 +2148,22 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 		{ 0x000, 0x000,	RTL_GIGA_MAC_NONE   }
 	};
 	const struct rtl_mac_info *p = mac_info;
-	u16 reg = RTL_R32(tp, TxConfig) >> 20;
+	enum mac_version ver;
 
-	while ((reg & p->mask) != p->val)
+	while ((xid & p->mask) != p->val)
 		p++;
-	tp->mac_version = p->mac_version;
-
-	if (tp->mac_version == RTL_GIGA_MAC_NONE) {
-		dev_err(tp_to_dev(tp), "unknown chip XID %03x\n", reg & 0xfcf);
-	} else if (!tp->supports_gmii) {
-		if (tp->mac_version == RTL_GIGA_MAC_VER_42)
-			tp->mac_version = RTL_GIGA_MAC_VER_43;
-		else if (tp->mac_version == RTL_GIGA_MAC_VER_45)
-			tp->mac_version = RTL_GIGA_MAC_VER_47;
-		else if (tp->mac_version == RTL_GIGA_MAC_VER_46)
-			tp->mac_version = RTL_GIGA_MAC_VER_48;
+	ver = p->ver;
+
+	if (ver != RTL_GIGA_MAC_NONE && !gmii) {
+		if (ver == RTL_GIGA_MAC_VER_42)
+			ver = RTL_GIGA_MAC_VER_43;
+		else if (ver == RTL_GIGA_MAC_VER_45)
+			ver = RTL_GIGA_MAC_VER_47;
+		else if (ver == RTL_GIGA_MAC_VER_46)
+			ver = RTL_GIGA_MAC_VER_48;
 	}
+
+	return ver;
 }
 
 static void rtl_release_firmware(struct rtl8169_private *tp)
@@ -5440,9 +5440,10 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct rtl8169_private *tp;
+	int jumbo_max, region, rc;
+	enum mac_version chipset;
 	struct net_device *dev;
-	int chipset, region;
-	int jumbo_max, rc;
+	u16 xid;
 
 	/* Some tools for creating an initramfs don't consider softdeps, then
 	 * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
@@ -5509,10 +5510,16 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
 
+	xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;
+
 	/* Identify chip attached to board */
-	rtl8169_get_mac_version(tp);
-	if (tp->mac_version == RTL_GIGA_MAC_NONE)
+	chipset = rtl8169_get_mac_version(xid, tp->supports_gmii);
+	if (chipset == RTL_GIGA_MAC_NONE) {
+		dev_err(&pdev->dev, "unknown chip XID %03x\n", xid);
 		return -ENODEV;
+	}
+
+	tp->mac_version = chipset;
 
 	tp->cp_cmd = RTL_R16(tp, CPlusCmd);
 
@@ -5530,8 +5537,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	chipset = tp->mac_version;
-
 	rc = rtl_alloc_irq(tp);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Can't allocate interrupt\n");
@@ -5619,8 +5624,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_mdio_unregister;
 
 	netif_info(tp, probe, dev, "%s, %pM, XID %03x, IRQ %d\n",
-		   rtl_chip_infos[chipset].name, dev->dev_addr,
-		   (RTL_R32(tp, TxConfig) >> 20) & 0xfcf,
+		   rtl_chip_infos[chipset].name, dev->dev_addr, xid,
 		   pci_irq_vector(pdev, 0));
 
 	if (jumbo_max)
-- 
2.25.0


