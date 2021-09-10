Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27113406737
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 08:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhIJG3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 02:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhIJG3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 02:29:30 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C3AC061574;
        Thu,  9 Sep 2021 23:28:20 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id g16so1045918wrb.3;
        Thu, 09 Sep 2021 23:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BEChKUpHUmXhTGEtZcd0x0DwjyIGrrpVYK+hpDQ+L/k=;
        b=YhlEoJTSoEafgKpmxDwPRCClV7fs+0ObWNjO4p4XJgj/DZXUt8U5MjLL7KylgcpXZJ
         sjTtX6gxgGzg0G0FZ6Py0pZeqMMVUhf1m67hGUYTFmtFvOAgcl6NOrhyrnIpv7cXo5kc
         Qnyu7xToNTiZsZntVL8E0vyLVmhfZGl9z/gOcQKti1jTc3UyhvqiJCY0fklMSUoFxp2Q
         BJ+j25X2zljxBrYdqJA119/hScwi3LCCwOXCr+u4Zlj8XaWshq8ryRHBhcTZa/alzgyG
         HIS5VhsYv+rnFvu4g5RVR6BhUB1EPNnFwuTS02L5clCXMuHA+UEfZkEYBjYFN3L7oRWU
         waLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BEChKUpHUmXhTGEtZcd0x0DwjyIGrrpVYK+hpDQ+L/k=;
        b=pNojfETUmds4eEeNI+a/SgMDcS7qT0zkGcAz1kg5DOoAuPvz+29CH9XmS+Dosbel+y
         pQxdO2tdosAPqdCi7bW82RRjPeFgiBGwTttysXC8zVQ3dSqOoN4aXEdVGbi6a2Q4TQSy
         zNUEvHIxis3IvCYyTCsOYDG8iBM3+vvOfTuKHfcroAvRe7ane180I7YLqQ9VXPGrtfKl
         DMBh9xPWunwyWVnof0PAXuueJLJGQCeuioMVVOtnm7YVBb8KGqP9EnZhSU7jGHAGL3Qv
         xVyCm0zuYx6hIOpUG1uwtoBUTTf9rhTr80mEifsVMAV5E0oFdMDLkAalbPIQuz+iaqz0
         UNTg==
X-Gm-Message-State: AOAM530w6Vr8WFtcaKuZD8sKcnhRQs8RCML0zxplYRyzfuyJ3Rn1D2Bm
        Zl3sl9qdJhTQ1DCTnRWcZgENPRf5ObI=
X-Google-Smtp-Source: ABdhPJxIIGGVU5DA0a69MXDVvABs5Pz2jNzE6lelZxBsSiXoDqdDNxhwoXFd4qMtbi0qZja9to+DFg==
X-Received: by 2002:adf:fd8c:: with SMTP id d12mr7733884wrr.21.1631255298731;
        Thu, 09 Sep 2021 23:28:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c9c:396a:4a57:ee58? (p200300ea8f0845000c9c396a4a57ee58.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c9c:396a:4a57:ee58])
        by smtp.googlemail.com with ESMTPSA id a6sm3364537wmb.7.2021.09.09.23.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 23:28:18 -0700 (PDT)
Subject: [PATCH 5/5] cxgb3: Remove seeprom_write and use VPD API
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Message-ID: <a0291004-dda3-ea08-4d6c-a2f8826c8527@gmail.com>
Date:   Fri, 10 Sep 2021 08:27:08 +0200
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

Using the VPD API allows to simplify the code and completely get
rid of t3_seeprom_write().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb3/common.h   |  1 -
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 11 ++----
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c    | 35 -------------------
 3 files changed, 3 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/common.h b/drivers/net/ethernet/chelsio/cxgb3/common.h
index 56312f9ed..d115ec932 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/common.h
@@ -676,7 +676,6 @@ void t3_link_changed(struct adapter *adapter, int port_id);
 void t3_link_fault(struct adapter *adapter, int port_id);
 int t3_link_start(struct cphy *phy, struct cmac *mac, struct link_config *lc);
 const struct adapter_info *t3_get_adapter_info(unsigned int board_id);
-int t3_seeprom_write(struct adapter *adapter, u32 addr, __le32 data);
 int t3_seeprom_wp(struct adapter *adapter, int enable);
 int t3_get_tp_version(struct adapter *adapter, u32 *vers);
 int t3_check_tpsram_version(struct adapter *adapter);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index d73339682..e185f5f24 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2054,7 +2054,6 @@ static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
 	u32 aligned_offset, aligned_len;
-	__le32 *p;
 	u8 *buf;
 	int err;
 
@@ -2080,17 +2079,13 @@ static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	if (err)
 		goto out;
 
-	for (p = (__le32 *) buf; !err && aligned_len; aligned_len -= 4, p++) {
-		err = t3_seeprom_write(adapter, aligned_offset, *p);
-		aligned_offset += 4;
-	}
-
-	if (!err)
+	err = pci_write_vpd(adapter->pdev, aligned_offset, aligned_len, buf);
+	if (err >= 0)
 		err = t3_seeprom_wp(adapter, 1);
 out:
 	if (buf != data)
 		kfree(buf);
-	return err;
+	return err < 0 ? err : 0;
 }
 
 static void get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index ec4b49ebe..cb85c2f21 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -595,44 +595,9 @@ struct t3_vpd {
 	u32 pad;		/* for multiple-of-4 sizing and alignment */
 };
 
-#define EEPROM_MAX_POLL   40
 #define EEPROM_STAT_ADDR  0x4000
 #define VPD_BASE          0xc00
 
-/**
- *	t3_seeprom_write - write a VPD EEPROM location
- *	@adapter: adapter to write
- *	@addr: EEPROM address
- *	@data: value to write
- *
- *	Write a 32-bit word to a location in VPD EEPROM using the card's PCI
- *	VPD ROM capability.
- */
-int t3_seeprom_write(struct adapter *adapter, u32 addr, __le32 data)
-{
-	u16 val;
-	int attempts = EEPROM_MAX_POLL;
-	unsigned int base = adapter->params.pci.vpd_cap_addr;
-
-	if ((addr >= EEPROMSIZE && addr != EEPROM_STAT_ADDR) || (addr & 3))
-		return -EINVAL;
-
-	pci_write_config_dword(adapter->pdev, base + PCI_VPD_DATA,
-			       le32_to_cpu(data));
-	pci_write_config_word(adapter->pdev,base + PCI_VPD_ADDR,
-			      addr | PCI_VPD_ADDR_F);
-	do {
-		msleep(1);
-		pci_read_config_word(adapter->pdev, base + PCI_VPD_ADDR, &val);
-	} while ((val & PCI_VPD_ADDR_F) && --attempts);
-
-	if (val & PCI_VPD_ADDR_F) {
-		CH_ERR(adapter, "write to EEPROM address 0x%x failed\n", addr);
-		return -EIO;
-	}
-	return 0;
-}
-
 /**
  *	t3_seeprom_wp - enable/disable EEPROM write protection
  *	@adapter: the adapter
-- 
2.33.0


