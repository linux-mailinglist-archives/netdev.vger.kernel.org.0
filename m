Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44ADD2EBCEF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbhAFLDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAFLDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 06:03:47 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99817C06134C;
        Wed,  6 Jan 2021 03:03:06 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id 6so4486130ejz.5;
        Wed, 06 Jan 2021 03:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ghlzx0ngHPmtJ8Qunegeez7cCjaR86UkMnCfsZmtjo=;
        b=jDTBxuk8u1KOGxA7ihc5vhOEISiXcpoaaMsyFJWcgUPuiLWF+CJLvigEf8XYPkBXSP
         yJmvSrytcHol8IhMyvSXGTNnuJlU/HmLKFteEUw3VFh6xipYFVUXg5bICRZEa3NyXAIq
         E30jv2cN5/jfxzZj0rllxDDtNLmEu6XGp06CAKduICikbZEggfT04toCFcMYXNlvWIXX
         rC/CTJT7Vzq3t+B9xzobs02Y9kDsuhalj0jjJu1X2CVjD2cZU6ZHuHMmaLF3Kuqo+jDr
         mCJaBPI793MdRwkJhTZKFg4VXbzGJh7lp04YTIsUCwrbv+Ax23V+zjSREqJejceofE3J
         Fq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ghlzx0ngHPmtJ8Qunegeez7cCjaR86UkMnCfsZmtjo=;
        b=kslnIrGLk97QxS+2k2bIpCizDz/mcedxfwo9xFan1npGwkaYbuluGoqYyOErDM6xXt
         TRXweJo56KpBIzkIip5pVqLyo46uO4wuSdHlv2/7QRLYlcZqk/XS0W6IFCXkX5i0+LzM
         IurfGZF7DlJfO+f6VazWGeaKPauui4q7gYEcY6DFbzlmKiQNEi6SlVPMlRMXcaLgkSul
         kUobjX4yRXrWv0UL5jegzmqtaBhalhSFA0xZBoS6T2m7C2mNyzmImaGwjDphpjuraPKJ
         ZmRCrdAlfz79oA43VqZmGB5DLjMoPNqOa97m1hdMJJGF49fsF1f+9AqiMNuQdv8dNcTq
         NU7A==
X-Gm-Message-State: AOAM5331XRe+7ivkhistCmh6UL9thQw0zOmQrbKT/FS5G9J3coDmTmxc
        9D5IH/EhMvBldJYF6MAE+LlQjyP8wZA=
X-Google-Smtp-Source: ABdhPJyxFiGtR9Ws4sEhjtXSSCtcsOpKSeQJXnWvsImiv4jVFI2dVvQyy8pW9yHANVwlV1wjMO6y/g==
X-Received: by 2002:a17:906:4d8d:: with SMTP id s13mr2482699eju.305.1609930984438;
        Wed, 06 Jan 2021 03:03:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id qu21sm1092635ejb.95.2021.01.06.03.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 03:03:03 -0800 (PST)
Subject: [PATCH v2 1/3] PCI: Disable parity checking if broken_parity is set
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bbc33d9b-af7c-8910-cdb3-fa3e3b2e3266@gmail.com>
Message-ID: <ee1e400f-33b7-865c-2f6a-e77581e11f3f@gmail.com>
Date:   Wed, 6 Jan 2021 12:03:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <bbc33d9b-af7c-8910-cdb3-fa3e3b2e3266@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we know that a device has broken parity checking, then disable it.
This avoids quirks like in r8169 where on the first parity error
interrupt parity checking will be disabled if broken_parity_status
is set. Make pci_quirk_broken_parity() public so that it can be used
by platform code, e.g. for Thecus N2100.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/quirks.c | 17 +++++++++++------
 include/linux/pci.h  |  2 ++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3b..ab54e26b8 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -205,17 +205,22 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
 				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
 
+void pci_quirk_broken_parity(struct pci_dev *dev)
+{
+	u16 cmd;
+
+	dev->broken_parity_status = 1;	/* This device gives false positives */
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	pci_write_config_word(dev, PCI_COMMAND, cmd & ~PCI_COMMAND_PARITY);
+}
+
 /*
  * The Mellanox Tavor device gives false positive parity errors.  Mark this
  * device with a broken_parity_status to allow PCI scanning code to "skip"
  * this now blacklisted device.
  */
-static void quirk_mellanox_tavor(struct pci_dev *dev)
-{
-	dev->broken_parity_status = 1;	/* This device gives false positives */
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, quirk_mellanox_tavor);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, quirk_mellanox_tavor);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, pci_quirk_broken_parity);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, pci_quirk_broken_parity);
 
 /*
  * Deal with broken BIOSes that neglect to enable passive release,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b32126d26..161dcc474 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1916,6 +1916,8 @@ enum pci_fixup_pass {
 	pci_fixup_suspend_late,	/* pci_device_suspend_late() */
 };
 
+void pci_quirk_broken_parity(struct pci_dev *dev);
+
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
 #define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
 				    class_shift, hook)			\
-- 
2.30.0


