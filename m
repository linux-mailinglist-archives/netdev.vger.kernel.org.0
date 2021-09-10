Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D291406734
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 08:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhIJG3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 02:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhIJG3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 02:29:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC58C061574;
        Thu,  9 Sep 2021 23:28:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m25-20020a7bcb99000000b002e751bcb5dbso571731wmi.5;
        Thu, 09 Sep 2021 23:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WvdbKbJMvq+eieS3i12cZKM/UZny/bR09IRoyLStsYI=;
        b=Q+dv54qf2yNvF2g35D3Xe6UesG++wEmbatOfJonRyXTaDmUnAQ6HFwbO+9Ylb4FHvC
         TzyvdR1nynMNgM1T26/XW5AStfowUVyqDahbIC9q/3Np8J6WfRi53HxxiIYtkss916zi
         H5bLH2YiQLaj3ZatgGCqygfdn+tFD1vVKVGHQ3U0EWwhHAQ/o6al6/n7CWyvJmVTXApF
         ny10nWSbn1XZcmYNnZV3fkeqw0gTxWi5T/2anJmwxKqfm/cbKIUtZbCoQEmdC8VpR3Rr
         z4ZrmblCKE61sAGGIvoT1zVz17MAO+cd8px/LY5oVg3ra2DLfkGAJ5705D7DSuVquOJR
         kvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WvdbKbJMvq+eieS3i12cZKM/UZny/bR09IRoyLStsYI=;
        b=0WazIWcKZhLJBFqqA+bog22FW5GbY9cD73VRR9NyvlbbNCwEKrbH17msUd0tNzV2Yf
         XT4dThq0LOLPrcbw1/ye7w8abyQr6aVTK7vaN7LgiKI8+9+uX4c3rGu9gqqjBvxFBAnT
         u129yURNV7L0jbmL84gQTnSLUZ1thOUDPelaZ6cFCZb/qfblLUpEXBbJdjexxnMokzCW
         Y9ls/whf/vr4hScnLHb+jWF+oBDGWXTGtlwwx1grSGYH8eXYn7nI1Y85u32vOm1DP734
         BWU2mSfyt2+bL9225GB8ffCQ10spZu6pErQGze5/xEqW5Qikx0HjqqeVI6s2oemEFaHC
         3aOg==
X-Gm-Message-State: AOAM532YrBoqD2UtUjNeO39W+zz6G9YpZlw5HWH6gXdOCLzD0k1UkUA5
        8BVo36K7n3XHA50Qn4VprtJ0kXh9OrM=
X-Google-Smtp-Source: ABdhPJyQktFxj6Iae09ku4OarF/xLtnG4RccOzodP0b2pWYAMsCcoKs/V5od8ZfRSIOp/B3ef3ng7A==
X-Received: by 2002:a1c:7e85:: with SMTP id z127mr6661179wmc.141.1631255292199;
        Thu, 09 Sep 2021 23:28:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c9c:396a:4a57:ee58? (p200300ea8f0845000c9c396a4a57ee58.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c9c:396a:4a57:ee58])
        by smtp.googlemail.com with ESMTPSA id l7sm3198306wmp.48.2021.09.09.23.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 23:28:11 -0700 (PDT)
Subject: [PATCH 3/5] cxgb3: Remove t3_seeprom_read and use VPD API
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Message-ID: <68ef15bb-b6bf-40ad-160c-aaa72c4a70f8@gmail.com>
Date:   Fri, 10 Sep 2021 08:24:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the VPD API allows to simplify the code and completely get rid
of t3_seeprom_read(). Note that we don't have to use pci_read_vpd_any()
here because a VPD quirk sets dev->vpd.len to the full EEPROM size.

Tested with a T320 card.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/common.h   |  1 -
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 27 ++++------
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c    | 54 +++----------------
 3 files changed, 18 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/common.h b/drivers/net/ethernet/chelsio/cxgb3/common.h
index b706f2fbe..56312f9ed 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/common.h
@@ -676,7 +676,6 @@ void t3_link_changed(struct adapter *adapter, int port_id);
 void t3_link_fault(struct adapter *adapter, int port_id);
 int t3_link_start(struct cphy *phy, struct cmac *mac, struct link_config *lc);
 const struct adapter_info *t3_get_adapter_info(unsigned int board_id);
-int t3_seeprom_read(struct adapter *adapter, u32 addr, __le32 *data);
 int t3_seeprom_write(struct adapter *adapter, u32 addr, __le32 data);
 int t3_seeprom_wp(struct adapter *adapter, int enable);
 int t3_get_tp_version(struct adapter *adapter, u32 *vers);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 38e47703f..d73339682 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2036,20 +2036,16 @@ static int get_eeprom(struct net_device *dev, struct ethtool_eeprom *e,
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
-	int i, err = 0;
-
-	u8 *buf = kmalloc(EEPROMSIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	int cnt;
 
 	e->magic = EEPROM_MAGIC;
-	for (i = e->offset & ~3; !err && i < e->offset + e->len; i += 4)
-		err = t3_seeprom_read(adapter, i, (__le32 *) & buf[i]);
+	cnt = pci_read_vpd(adapter->pdev, e->offset, e->len, data);
+	if (cnt < 0)
+		return cnt;
 
-	if (!err)
-		memcpy(data, buf + e->offset, e->len);
-	kfree(buf);
-	return err;
+	e->len = cnt;
+
+	return 0;
 }
 
 static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
@@ -2072,12 +2068,9 @@ static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 		buf = kmalloc(aligned_len, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
-		err = t3_seeprom_read(adapter, aligned_offset, (__le32 *) buf);
-		if (!err && aligned_len > 4)
-			err = t3_seeprom_read(adapter,
-					      aligned_offset + aligned_len - 4,
-					      (__le32 *) & buf[aligned_len - 4]);
-		if (err)
+		err = pci_read_vpd(adapter->pdev, aligned_offset, aligned_len,
+				   buf);
+		if (err < 0)
 			goto out;
 		memcpy(buf + (eeprom->offset & 3), data, eeprom->len);
 	} else
diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index 7ff31d102..4ecf40b02 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -599,42 +599,6 @@ struct t3_vpd {
 #define EEPROM_STAT_ADDR  0x4000
 #define VPD_BASE          0xc00
 
-/**
- *	t3_seeprom_read - read a VPD EEPROM location
- *	@adapter: adapter to read
- *	@addr: EEPROM address
- *	@data: where to store the read data
- *
- *	Read a 32-bit word from a location in VPD EEPROM using the card's PCI
- *	VPD ROM capability.  A zero is written to the flag bit when the
- *	address is written to the control register.  The hardware device will
- *	set the flag to 1 when 4 bytes have been read into the data register.
- */
-int t3_seeprom_read(struct adapter *adapter, u32 addr, __le32 *data)
-{
-	u16 val;
-	int attempts = EEPROM_MAX_POLL;
-	u32 v;
-	unsigned int base = adapter->params.pci.vpd_cap_addr;
-
-	if ((addr >= EEPROMSIZE && addr != EEPROM_STAT_ADDR) || (addr & 3))
-		return -EINVAL;
-
-	pci_write_config_word(adapter->pdev, base + PCI_VPD_ADDR, addr);
-	do {
-		udelay(10);
-		pci_read_config_word(adapter->pdev, base + PCI_VPD_ADDR, &val);
-	} while (!(val & PCI_VPD_ADDR_F) && --attempts);
-
-	if (!(val & PCI_VPD_ADDR_F)) {
-		CH_ERR(adapter, "reading EEPROM address 0x%x failed\n", addr);
-		return -EIO;
-	}
-	pci_read_config_dword(adapter->pdev, base + PCI_VPD_DATA, &v);
-	*data = cpu_to_le32(v);
-	return 0;
-}
-
 /**
  *	t3_seeprom_write - write a VPD EEPROM location
  *	@adapter: adapter to write
@@ -708,24 +672,22 @@ static int vpdstrtou16(char *s, u8 len, unsigned int base, u16 *val)
  */
 static int get_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
-	int i, addr, ret;
 	struct t3_vpd vpd;
+	u8 base_val = 0;
+	int addr, ret;
 
 	/*
 	 * Card information is normally at VPD_BASE but some early cards had
 	 * it at 0.
 	 */
-	ret = t3_seeprom_read(adapter, VPD_BASE, (__le32 *)&vpd);
-	if (ret)
+	ret = pci_read_vpd(adapter->pdev, VPD_BASE, 1, &base_val);
+	if (ret < 0)
 		return ret;
-	addr = vpd.id_tag == 0x82 ? VPD_BASE : 0;
+	addr = base_val == PCI_VPD_LRDT_ID_STRING ? VPD_BASE : 0;
 
-	for (i = 0; i < sizeof(vpd); i += 4) {
-		ret = t3_seeprom_read(adapter, addr + i,
-				      (__le32 *)((u8 *)&vpd + i));
-		if (ret)
-			return ret;
-	}
+	ret = pci_read_vpd(adapter->pdev, addr, sizeof(vpd), &vpd);
+	if (ret < 0)
+		return ret;
 
 	ret = vpdstrtouint(vpd.cclk_data, vpd.cclk_len, 10, &p->cclk);
 	if (ret)
-- 
2.33.0


