Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AF62EA7CC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbhAEJot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbhAEJos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:44:48 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF741C061793;
        Tue,  5 Jan 2021 01:44:07 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id lt17so40411560ejb.3;
        Tue, 05 Jan 2021 01:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hyCKX7wWLjpBih18O2/1WqNll8TAh0zyeUSpeo505RQ=;
        b=kh6QFSA4OhPvNC+iVQ74akY1E1jsvkksmE6ZlzNckKaFXdlaiwzRM49r0OjjxHEzJj
         oTVlxLwpFE1lTHdMa63BqbQpuXqNry3JG38EiNHoWljyDBboXpqgqvw4lxIhbGrtfa05
         Cdpg0Ile3MiwhbJ/4jS38Kpnym3h+YPrD/eL97gHT/8j79fIIQp+7GrMajh32ZSINKnA
         6jwSKjPIf1JLY8CL3FENNVMfuvP67KoUB8TVVMXNn4gSL2td1G2KBhmeCJZA4cTuTvkh
         828JgAgO9lT0S+bNjc+R1LdGUWP23N5XexveP5+R4OjAJK3hDu5h2tIwue38olBoZ/iA
         eDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hyCKX7wWLjpBih18O2/1WqNll8TAh0zyeUSpeo505RQ=;
        b=Yd7fMoYWpD0RKwNldRMjCpP7YT4g4ZgTn3mQF2iGthdgLVvhJHWt1d4RCi8hV7I1Xy
         HQSO/YnAAXLJBmX41EeiVcwnCehLnQSxe89GrC/omIN5d4fsAwsrmqEKQNTV5Yh7oZ5g
         KlUrXoSKpUx/cbg91NDNchr1JEva0y2ltO5lGw+6smJ3eUlBgWF7eektJAK4gfZwmhn0
         JVwfhfxzRtxljs2R3pCbBw7kn/rVwq23hT4j6dvYy/f1w93jwcxe/BDbNoFvZk7g6eXn
         6lSdmPSKd1Kggh5u5AuL76yLKO9dmTvRf7QbX9ek/gobgavEDy1kCs4yRCTVkzGJrjhu
         fujg==
X-Gm-Message-State: AOAM533R82UPLA5vHvFgQuCBNXeg5KVum3Sm5I78pKv30/ohhBh46N4l
        VgsUuYAxd3/aVjCl8l/ZIDQRC2q/jMU=
X-Google-Smtp-Source: ABdhPJw8qDs2JyPs5xGd0F+p4GgVv9a9tY8Ct2oUsLOVThxQoKo+urq0gbnaNkgh7U72HVE/PUHxVw==
X-Received: by 2002:a17:906:eb8d:: with SMTP id mh13mr68391695ejb.299.1609839846413;
        Tue, 05 Jan 2021 01:44:06 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1? (p200300ea8f06550005ee6bfdb6c98fa1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1])
        by smtp.googlemail.com with ESMTPSA id h15sm25235984ejq.29.2021.01.05.01.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 01:44:05 -0800 (PST)
Subject: [PATCH 1/3] PCI: Disable parity checking if broken_parity_status is
 set
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
References: <a6f09e1b-4076-59d1-a4e3-05c5955bfff2@gmail.com>
Message-ID: <a4249b65-b63c-9f9e-818c-9f5bf2e802a9@gmail.com>
Date:   Tue, 5 Jan 2021 10:41:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a6f09e1b-4076-59d1-a4e3-05c5955bfff2@gmail.com>
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


