Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828832EC2CD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbhAFRxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbhAFRxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:53:19 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC22C061357;
        Wed,  6 Jan 2021 09:52:39 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b2so5222989edm.3;
        Wed, 06 Jan 2021 09:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zo4puXWJu0y1i/wQ/38qDQeCk416sEyKVYwIE550Uso=;
        b=k4aMCi9BM2ZvNUO37aKxnOf2oDq3WvPS0tHkyDmv3alZSTPp0k3FOH+jRP5RrYLfQt
         G4KSjMuvC85EQPxsZINaWvapPDwcGtY8TVP4n/SjCLxsby1h5Q2yZoDc0FlCR2uTBW2e
         ObJS0Jjha0As/HLZUCNbkPM4J6kWl9OGhoVimLK11Kzkg2i6PzRBWtE9mPU6hsR1oAdS
         J1lXtcoSqGsEYub64TGDSA/L9I502uTs0BaMJFQb41FJj9VU2vRREGBk9n//2d0Q5X/2
         +mHF8BsVZJmehmTFxKT2EWQx9gKWvh1xXHFmUoubP2pMl/1fn8B1Hkdk6AtKKr61XSFG
         gQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zo4puXWJu0y1i/wQ/38qDQeCk416sEyKVYwIE550Uso=;
        b=OhfF+mkEEzl+M2LX0o0lP/Hd5ysgOzM5bJyYmsRJY/D9RpsZzU2JhkvLGoyNEUp1rU
         3Q6sbyqWjYib7F0nNnOeNd80pOgKylHZ9PQk0OPkHS8pkeGRLiCV7+lqJnM6/+6/JJIG
         WofuvuLoEftvTfVEBvgqFDVDvwikcp8AYQgMijhTk9pgWlVb9oHdIr4IIrll1CSo1sMC
         W+QSKbgMdrlOIS3RImH9zwqFx+zPRD/23PZ9NAz91qbKD5elLpvAOfzaVs5qUu68oyN8
         gjpMvmHuN5Z4tIdhOlvg4t4a6wad39PFprqrLvcfUfwLs0nA7YhM38VqDs8yIO6IgLg5
         xHxQ==
X-Gm-Message-State: AOAM530/4CNx3Jo8VoVEZ1LbmF0EcFM+/Siojf58p45dDEfSn57HbhfV
        ROecD4a7rr2yv4E2oEwEwg0lELuAQPw=
X-Google-Smtp-Source: ABdhPJxKbl+eDJVjJz8AQaORCoddjTDiCIciOrwhOqu7vlt69dpwQRjyQfvUh8rFreDMbGLx05W5FQ==
X-Received: by 2002:aa7:c5d6:: with SMTP id h22mr4659789eds.82.1609955557752;
        Wed, 06 Jan 2021 09:52:37 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id t19sm1532069ejc.62.2021.01.06.09.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 09:52:37 -0800 (PST)
Subject: [PATCH v3 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
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
Message-ID: <0c0dcbf2-5f1e-954c-ebd7-e6ccfae5c60e@gmail.com>
Date:   Wed, 6 Jan 2021 18:51:43 +0100
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

Use new PCI core function pci_quirk_broken_parity() to disable
parity checking.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- remove additional changes from this patch
v3:
- improve commit message
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



