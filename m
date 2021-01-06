Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E2F2EBD03
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbhAFLHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAFLHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 06:07:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07601C06134C;
        Wed,  6 Jan 2021 03:06:38 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ce23so4456477ejb.8;
        Wed, 06 Jan 2021 03:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b3QDmAqDwF0sazvMztxOmX4udySg+OaATBeXCjKrg24=;
        b=fSltrPhTKX2QhqWf+vxbb9eKe6A6JcTzzVI0dCblEfMk8z0hyNVTJaZIg1fIRi5ZKN
         qjDdvzFvMhAsMyqOYK92sBl86wPyWbewibvyuxS/f8EBRCk2oF0/xdtnzqJmg/bMfb/Q
         iv2KtpE2HR75JyIqONg7shf8b5Q6LGrbNTNih04gB9aobxqIwqqfTxFjqaHPgBdZ1FWQ
         LJG5FSTxsLVe5+oupDuQnQ6cgeSYTHzw8Kp2qb3zTva/+ufSITAOSCtWnKmjiygG0LqW
         GOzXY028qgQnxjC7i+Zu89273dl9ITM9jcuohVAVFEOCdk0eNDHePhldCXvsrygt2ofk
         NY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b3QDmAqDwF0sazvMztxOmX4udySg+OaATBeXCjKrg24=;
        b=PtRa52nkfvyABQIV/ZQjF0ezbV3RPCVHUw9hksD0r6RBrPa/dG8Kw5z3Tf9KH8u9ZC
         cGuCyrMloZNJDblDHotbfKNvPsKtAZdnyloS/yxYfQqmTsuIpgVcqWFH6iKI3zSvD53T
         b1e2Tebn5r760SDhmYY8wUUE71SfY3zxNh0bziAtv8KBj7YH1RP2ArGSraAJIPG08NCt
         XYLbKtD5ddcywSXxLVLe6Y7E5uDhwzP2NwIBo6UTSg50A0MAmrFCiW+wkMKn1izXWrws
         SLf9JKolJkHd/ZLy9QSRWOxpPC7P3zpCDVeLpk3mhqMCCAT0lNaQtb9pGa95sGPMdwqE
         kChA==
X-Gm-Message-State: AOAM531gM+/Xzh4HMkvDMr391I73wd/6Am1iUctbwDh+2qFglOyYu4ox
        zFzbIXL01fvE/n9It+d2EaP7VAHgSc4=
X-Google-Smtp-Source: ABdhPJxm1C/f7y/acwIbOO25z2zUp14oA3auR1Zpq3+mvX6Md+Vit3cSAU4T80/YIhsO6qxM1VcvDA==
X-Received: by 2002:a17:906:8693:: with SMTP id g19mr2613004ejx.111.1609931196573;
        Wed, 06 Jan 2021 03:06:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id rk12sm1105544ejb.75.2021.01.06.03.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 03:06:36 -0800 (PST)
Subject: [PATCH v2 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
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
Message-ID: <5b100322-7a53-8f5e-32f9-a67c3cd2beeb@gmail.com>
Date:   Wed, 6 Jan 2021 12:05:41 +0100
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

Use new PCI core function pci_quirk_broken_parity(), in addition to
setting broken_parity_status is disables parity checking.
This allows us to remove a quirk in r8169 driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- remove additional changes from this patch
---
 arch/arm/mach-iop32x/n2100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index 78b9a5ee4..9f2aae3cd 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -125,7 +125,7 @@ static void n2100_fixup_r8169(struct pci_dev *dev)
 	if (dev->bus->number == 0 &&
 	    (dev->devfn == PCI_DEVFN(1, 0) ||
 	     dev->devfn == PCI_DEVFN(2, 0)))
-		dev->broken_parity_status = 1;
+		pci_quirk_broken_parity(dev);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, PCI_ANY_ID, n2100_fixup_r8169);
 
-- 
2.30.0


