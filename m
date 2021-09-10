Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042E440672F
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 08:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhIJG3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 02:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhIJG3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 02:29:18 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6459C061574;
        Thu,  9 Sep 2021 23:28:07 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t18so1083673wrb.0;
        Thu, 09 Sep 2021 23:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JWf4yF5KquCSwG+63OJJa1U7ntFDUJfhUzH00QrGcfU=;
        b=YizobErLJdrH7022UAiQyOvkewG4HyS05ecVD8IwQz9OKvhrnbbvspIKSol5R6YYTK
         IYksQn+SY1DxYpLVNMYEwb4/9qWggQUqbWntNstG1kjp149XU1dYOGb4cYOGh7FRQ7+O
         vrfWvhYQSPcOFfEFDuQWEcQ//++3DyIFkTA99cDx1YP0yiErSPJwRHaQl0BLU30kArNW
         O15zfhItll1+GjMLz8EI2JOEYPnAJRPFdVPHsUkREUCwTq8DEd9N8GvdIg/kpryP8ot/
         d60VEeIY2H5soUz/2AX0EqU09tqQmUHggOXumaRW1ccR5ngKy1JxrkW1zmktxTEA3l68
         Il7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JWf4yF5KquCSwG+63OJJa1U7ntFDUJfhUzH00QrGcfU=;
        b=7bzcJlhkoRi5nF0/1F9eJsnD+ENMCymQxYTJHtXb3Us9KewWjCTjO6L06m3TBSfNMv
         PeuYbjF22np6xL7WLxKUpmrvvjoHoVPtnkh15rcpLEapnVyrzv0DygesjKbem5THsNJa
         TD2Pp2u6DvEqoOSgmAAjXIGJrCxfHZT2b2B7VSr7fP85GIpHrOVxuGgEakcRY7yFiHC/
         PnxwTLvd36/dDQ7UvFpBG0IMuRUV1HFNuEF9NtqON1TT9g6lRFUqPWAbKF6Mw1IqEdvA
         N5DwQZa9gohtdLDnN45CEsBzU6IVKSdmFPc2Etur7GWZ9xl1cJxRSmWgLa6/z1wLH2A1
         B4vA==
X-Gm-Message-State: AOAM5326vurtrWPlQOU/ENHBLy987kc4pHQSPDnuOWeNwRfG33+bV+P4
        4xA69seP7PKqOoIIz7XTLzucBlDAnAU=
X-Google-Smtp-Source: ABdhPJysvk/ywMehS9Iujv5cudSBURB3fGf4P63th6jMzOJuBM9XVWhdRjC0I+cjPDSteQClzUfwGw==
X-Received: by 2002:adf:ecc6:: with SMTP id s6mr494360wro.361.1631255285655;
        Thu, 09 Sep 2021 23:28:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c9c:396a:4a57:ee58? (p200300ea8f0845000c9c396a4a57ee58.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c9c:396a:4a57:ee58])
        by smtp.googlemail.com with ESMTPSA id m29sm3875515wrb.89.2021.09.09.23.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 23:28:05 -0700 (PDT)
Subject: [PATCH 1/5] PCI/VPD: Add pci_read/write_vpd_any()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Message-ID: <93ecce28-a158-f02a-d134-8afcaced8efe@gmail.com>
Date:   Fri, 10 Sep 2021 08:22:06 +0200
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

In certain cases we need a variant of pci_read_vpd()/pci_write_vpd() that
does not check against dev->vpd.len. Such cases are:
- reading VPD if dev->vpd.len isn't set yet (in pci_vpd_size())
- devices that map non-VPD information to arbitrary places in VPD address
  space (example: Chelsio T3 EEPROM write-protect flag)
Therefore add function variants that check against PCI_VPD_MAX_SIZE only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c   | 72 +++++++++++++++++++++++++++++++--------------
 include/linux/pci.h |  2 ++
 2 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 25557b272..286cad2a6 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -138,9 +138,10 @@ static int pci_vpd_wait(struct pci_dev *dev, bool set)
 }
 
 static ssize_t pci_vpd_read(struct pci_dev *dev, loff_t pos, size_t count,
-			    void *arg)
+			    void *arg, bool check_size)
 {
 	struct pci_vpd *vpd = &dev->vpd;
+	unsigned int max_len = check_size ? vpd->len : PCI_VPD_MAX_SIZE;
 	int ret = 0;
 	loff_t end = pos + count;
 	u8 *buf = arg;
@@ -151,11 +152,11 @@ static ssize_t pci_vpd_read(struct pci_dev *dev, loff_t pos, size_t count,
 	if (pos < 0)
 		return -EINVAL;
 
-	if (pos > vpd->len)
+	if (pos >= max_len)
 		return 0;
 
-	if (end > vpd->len) {
-		end = vpd->len;
+	if (end > max_len) {
+		end = max_len;
 		count = end - pos;
 	}
 
@@ -199,9 +200,10 @@ static ssize_t pci_vpd_read(struct pci_dev *dev, loff_t pos, size_t count,
 }
 
 static ssize_t pci_vpd_write(struct pci_dev *dev, loff_t pos, size_t count,
-			     const void *arg)
+			     const void *arg, bool check_size)
 {
 	struct pci_vpd *vpd = &dev->vpd;
+	unsigned int max_len = check_size ? vpd->len : PCI_VPD_MAX_SIZE;
 	const u8 *buf = arg;
 	loff_t end = pos + count;
 	int ret = 0;
@@ -212,7 +214,7 @@ static ssize_t pci_vpd_write(struct pci_dev *dev, loff_t pos, size_t count,
 	if (pos < 0 || (pos & 3) || (count & 3))
 		return -EINVAL;
 
-	if (end > vpd->len)
+	if (end > max_len)
 		return -EINVAL;
 
 	if (mutex_lock_killable(&vpd->lock))
@@ -365,6 +367,24 @@ static int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
 	return -ENOENT;
 }
 
+static ssize_t __pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf,
+			      bool check_size)
+{
+	ssize_t ret;
+
+	if (dev->dev_flags & PCI_DEV_FLAGS_VPD_REF_F0) {
+		dev = pci_get_func0_dev(dev);
+		if (!dev)
+			return -ENODEV;
+
+		ret = pci_vpd_read(dev, pos, count, buf, check_size);
+		pci_dev_put(dev);
+		return ret;
+	}
+
+	return pci_vpd_read(dev, pos, count, buf, check_size);
+}
+
 /**
  * pci_read_vpd - Read one entry from Vital Product Data
  * @dev:	PCI device struct
@@ -373,6 +393,20 @@ static int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
  * @buf:	pointer to where to store result
  */
 ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf)
+{
+	return __pci_read_vpd(dev, pos, count, buf, true);
+}
+EXPORT_SYMBOL(pci_read_vpd);
+
+/* Same, but allow to access any address */
+ssize_t pci_read_vpd_any(struct pci_dev *dev, loff_t pos, size_t count, void *buf)
+{
+	return __pci_read_vpd(dev, pos, count, buf, false);
+}
+EXPORT_SYMBOL(pci_read_vpd_any);
+
+static ssize_t __pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count,
+			       const void *buf, bool check_size)
 {
 	ssize_t ret;
 
@@ -381,14 +415,13 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf)
 		if (!dev)
 			return -ENODEV;
 
-		ret = pci_vpd_read(dev, pos, count, buf);
+		ret = pci_vpd_write(dev, pos, count, buf, check_size);
 		pci_dev_put(dev);
 		return ret;
 	}
 
-	return pci_vpd_read(dev, pos, count, buf);
+	return pci_vpd_write(dev, pos, count, buf, check_size);
 }
-EXPORT_SYMBOL(pci_read_vpd);
 
 /**
  * pci_write_vpd - Write entry to Vital Product Data
@@ -399,22 +432,17 @@ EXPORT_SYMBOL(pci_read_vpd);
  */
 ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf)
 {
-	ssize_t ret;
-
-	if (dev->dev_flags & PCI_DEV_FLAGS_VPD_REF_F0) {
-		dev = pci_get_func0_dev(dev);
-		if (!dev)
-			return -ENODEV;
-
-		ret = pci_vpd_write(dev, pos, count, buf);
-		pci_dev_put(dev);
-		return ret;
-	}
-
-	return pci_vpd_write(dev, pos, count, buf);
+	return __pci_write_vpd(dev, pos, count, buf, true);
 }
 EXPORT_SYMBOL(pci_write_vpd);
 
+/* Same, but allow to access any address */
+ssize_t pci_write_vpd_any(struct pci_dev *dev, loff_t pos, size_t count, const void *buf)
+{
+	return __pci_write_vpd(dev, pos, count, buf, false);
+}
+EXPORT_SYMBOL(pci_write_vpd_any);
+
 int pci_vpd_find_ro_info_keyword(const void *buf, unsigned int len,
 				 const char *kw, unsigned int *size)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cd8aa6fce..9649bd9e4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1350,6 +1350,8 @@ void pci_unlock_rescan_remove(void);
 /* Vital Product Data routines */
 ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
 ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
+ssize_t pci_read_vpd_any(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
+ssize_t pci_write_vpd_any(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
 
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
-- 
2.33.0


