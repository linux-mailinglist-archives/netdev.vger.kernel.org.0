Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB872EA7CE
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbhAEJov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbhAEJot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:44:49 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4212DC061794;
        Tue,  5 Jan 2021 01:44:09 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id i24so30366706edj.8;
        Tue, 05 Jan 2021 01:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XmXaHO6XtlhHHB5hr+caHztCDCfS/3Yl6IO2xbPe16k=;
        b=gfbZAVluaUqAozdn9jK6zB3yBcuBHNf9CLjz8QKiIYMnz8pEGY+0EylU2s12/mZULU
         ZAcU1oz+XARDrvcRCl0amZP+GPZV2buPTWzMrgUu3UsrDtwCL3ACyGLKdu3Gz1ByvcA3
         nc6E7IQhwmkGPNEK5OiTnOzMXiXj1N4IyMlorzj1X2kg7vG0anr+eCrRVxX5ZxYIPdiV
         HjQUYDT3RyNMZm/gtcy8XkWe69eZQ++EI7o/g9RIKaidM2OJ4JoZizJIZWrvd1zdBCYe
         n4Br++yELMy6Mq6TrDWLOoNQsOLh/3VYOh49CrYf64KQa/F3DC//s27wqCsqbtu9ryne
         mu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XmXaHO6XtlhHHB5hr+caHztCDCfS/3Yl6IO2xbPe16k=;
        b=DjQQ38Dt3rYdCmNEOYbTcD3da8nB6YUJfKaMZRFkSj+p0ShGHvcevUL++Yqgy0DXYQ
         zb8+V8unkk5bncdS1bi2N343cFVIdVpjG7maGtkdhFM7lC5/vPD7MPRkBu2aD/JKBXkR
         PVcv+ypqYC27wxQp6uCWO0OEzDQpuBpt/R0Lgv+Im2Q+cfJuMokjSMTxwgvwcFtM5YIf
         gsIicCmmCJ5nijW7MXOtz7HYK8KukDxL+/yPP9KTbmGjg2WDc7FwGr4epap4LEWPolK5
         kGbRveeYBdoAyUXCjgM2RLdAhK6RsZcUf6mRu4Qu/7ls7julHuGZnauhU9EoGJGxuXFQ
         o8gg==
X-Gm-Message-State: AOAM533gJQolefIf5knhiYcr+C8M2eD0FRjuFrqt9k7ZwyNx2RK2LK6c
        GK4SqxFQEaLKArYiS6PtIC2m+6aXjP8=
X-Google-Smtp-Source: ABdhPJwRYM03xT7yONzoDkBZsabwRjqq8Mork0bii5H2CPRKf8zDK8nIEhGoIt4NVJNNRwLlIt0DwA==
X-Received: by 2002:aa7:c444:: with SMTP id n4mr73120970edr.226.1609839847685;
        Tue, 05 Jan 2021 01:44:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1? (p200300ea8f06550005ee6bfdb6c98fa1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1])
        by smtp.googlemail.com with ESMTPSA id e25sm22382832edq.24.2021.01.05.01.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 01:44:07 -0800 (PST)
Subject: [PATCH 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
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
Message-ID: <d53b6377-ff2a-3bba-612f-d052ffa81d09@gmail.com>
Date:   Tue, 5 Jan 2021 10:42:31 +0100
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

Simplify the quirk by using new PCI core function
pci_quirk_broken_parity(). In addition make the quirk
more specific, use device id 0x8169 instead of PCI_ANY_ID.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 arch/arm/mach-iop32x/n2100.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index 78b9a5ee4..24c3eec46 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -122,12 +122,10 @@ static struct hw_pci n2100_pci __initdata = {
  */
 static void n2100_fixup_r8169(struct pci_dev *dev)
 {
-	if (dev->bus->number == 0 &&
-	    (dev->devfn == PCI_DEVFN(1, 0) ||
-	     dev->devfn == PCI_DEVFN(2, 0)))
-		dev->broken_parity_status = 1;
+	if (machine_is_n2100())
+		pci_quirk_broken_parity(dev);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, PCI_ANY_ID, n2100_fixup_r8169);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, 0x8169, n2100_fixup_r8169);
 
 static int __init n2100_pci_init(void)
 {
-- 
2.30.0


