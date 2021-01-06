Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493862EC2C8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbhAFRxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbhAFRxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:53:18 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E621C061575;
        Wed,  6 Jan 2021 09:52:38 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b73so5098546edf.13;
        Wed, 06 Jan 2021 09:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ghlzx0ngHPmtJ8Qunegeez7cCjaR86UkMnCfsZmtjo=;
        b=VEP6JOKXTfSSSHt54dhX2M0EY3gZKRFIfgHhhiI7Og8tqz6x6nymRwbS1aX8rmcKAH
         WxJKi38i7YCYgCfw5Pli4ICQ/9NQ9Mddm2PYLvAQRWduqJvJaiKJ0CJtGYLVF1L2eFGp
         UVp4irLbrVHxqAKOuZGzonCXZucKPtfeWEei5rHiLFHldVCaRhykWymVN/nQv4kNiJyr
         Wp0gWPj9FpnRtl4LTtmM41V6eGNQXrIG4pt+PTPPnNWJ8+GV2r62MD0vAL/tGV9VzMpu
         U22YdMWGQeokTLJVak8/fdcXrPsYNLtITro2Lthv0vwbWZVQLEVYZvHf2DeMFqnhVUtm
         T/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ghlzx0ngHPmtJ8Qunegeez7cCjaR86UkMnCfsZmtjo=;
        b=N1PXXJnBC67/t2ua1W6iCtfJqnYZgTw/HJNEsD9I5N0eC+NRM9bPpmq+Fj2LjGdJ4t
         flCVVQ34GVr9m5mbKX9mVX4FRgbOJaItmYjVUAULi0MQwUh0gCcAdDMZbShjyIxNxYcc
         UfAJWb8tNSbKdRGn+hAr9ioh6BRkjiTfUDl+AS+QZ3lWPYgVtZKqrMDAV6IXa9AhF4Wg
         23f3QB4jwheveJx32Ykg/S+CHOkk3FBiJXzTmWy0Vy8+E41e+OsguLOtE4aRuVNkvoca
         Xkg2CE9E5+SP0o3YMTXRvPt8q6SzXKVv3y9ucfkIWo8CzYjNbS9hHjq0lIsDZJyapmr0
         JXBg==
X-Gm-Message-State: AOAM530DMRa1DwFJvjcg8Q6OiRiMxDKxyaaVj4H+xntQjfb/hjQxnpxH
        xiKkHpXY25uNbB7Impej07c4XiiIGAs=
X-Google-Smtp-Source: ABdhPJxBXK4SYZHFJDf9fLt/cH+7SWdNrNdo4NDmnLPKwGuS+QgJHO8xx/Rdky/fMVKBPVYl0v4pTA==
X-Received: by 2002:aa7:c886:: with SMTP id p6mr4686827eds.207.1609955556398;
        Wed, 06 Jan 2021 09:52:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id hb18sm1533707ejb.86.2021.01.06.09.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 09:52:35 -0800 (PST)
Subject: [PATCH v3 1/3] PCI: Disable parity checking if broken_parity is set
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
References: <992c800e-2e12-16b0-4845-6311b295d932@gmail.com>
Message-ID: <d375987c-ea4f-dd98-4ef8-99b2fbfe7c33@gmail.com>
Date:   Wed, 6 Jan 2021 18:50:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <992c800e-2e12-16b0-4845-6311b295d932@gmail.com>
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



