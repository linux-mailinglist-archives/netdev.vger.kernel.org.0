Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A77616BA55
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBYHPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:15:38 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40114 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729339AbgBYHPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so1922042wmi.5;
        Mon, 24 Feb 2020 23:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zpCq4CEFKSBkbpCeszKlhtkuryYcBaKsjTcQjlXd8Gw=;
        b=XIZzVYyYB9YdfecTMCIKiUtDHr6HSeewFxBZC0cQtfxk8opi5W9UJim32wfLUlBsvO
         GQzWzw5VNgJqKbp9oTGMykLnjjrA8qdcqKSmMy1ekfuHR8pKaIsBT923aRKXoMfyjkB0
         y4lgZ/39CEtTHBtp/zDniNiPi1cxY7sMGcJY3iM2N6M2MPY3+Qt9JbdmxGsdgnrpZ+2G
         O3GCN71IVR0/OumJxjZOP5sn2YPG89l5SdzDh9rebF11Pfgke/Tr0PSgBiLU1b9jg6rK
         p9xXpqGi58R+GZN6xxwg+Z8DSs9JM9+CFB5CSozBfZLYKIEi1mmUqCVcLZSLxOMrae8a
         uYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zpCq4CEFKSBkbpCeszKlhtkuryYcBaKsjTcQjlXd8Gw=;
        b=GVlzInKtTUiH8Zb9mkAY+SBLUET49sv6JnZkBw7lDVuO1vgvIA/D7UflHCbqg7k/a4
         in4aEn9g6CoNp9aEmABAHBWxlIioQ+3ZF4rbgkRbNUl3NV6D/7vUJ6OKZx2rPhlFWnlZ
         8amPktvfmTCOvUye0I5pyy2vwTUaDw+zczuzg9CT+MxOoxiFCnD125crBQ3oPRlj3Yh5
         v58g3DOKyNJBDGAlDZjQMmhFsTzCiCUxRbK4URSMElFjdXBZ+wIP78gB05fkshx8ierl
         EndiuTKm/LYIx8+HQLOS4p8i+AeCZvBG2Tub2WH+loxM5CmkrsErUPNuNPNqWwKj87Ip
         nKLw==
X-Gm-Message-State: APjAAAVLCCikeUkvmWy0OWwwEeZcCOsaziyungRiRSnxjB6oybZnL725
        jsKu4zOfz41VsfC13zg1b2g=
X-Google-Smtp-Source: APXvYqzTmJ4TmhnX7u2zchosksdqKEOofJymuxVvsL2BS+wGH8udJrGqKMGNAmVmQ5x7v3zN0029fw==
X-Received: by 2002:a1c:5f41:: with SMTP id t62mr3631629wmb.42.1582614933772;
        Mon, 24 Feb 2020 23:15:33 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id t128sm2978626wmf.28.2020.02.24.23.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:33 -0800 (PST)
Subject: [PATCH v2 7/8] PCI: pci-bridge-emul: use PCI_STATUS_ERROR_BITS
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
References: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
Message-ID: <4a64e635-728e-2f61-3b85-b0526bb0d9e2@gmail.com>
Date:   Tue, 25 Feb 2020 08:13:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new constant PCI_STATUS_ERROR_BITS to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/pci-bridge-emul.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index fffa77093..93d8e8910 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -50,12 +50,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 		       (PCI_STATUS_CAP_LIST | PCI_STATUS_66MHZ |
 			PCI_STATUS_FAST_BACK | PCI_STATUS_DEVSEL_MASK) << 16),
 		.rsvd = GENMASK(15, 10) | ((BIT(6) | GENMASK(3, 0)) << 16),
-		.w1c = (PCI_STATUS_PARITY |
-			PCI_STATUS_SIG_TARGET_ABORT |
-			PCI_STATUS_REC_TARGET_ABORT |
-			PCI_STATUS_REC_MASTER_ABORT |
-			PCI_STATUS_SIG_SYSTEM_ERROR |
-			PCI_STATUS_DETECTED_PARITY) << 16,
+		.w1c = PCI_STATUS_ERROR_BITS << 16;
 	},
 	[PCI_CLASS_REVISION / 4] = { .ro = ~0 },
 
@@ -100,12 +95,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 			 PCI_STATUS_DEVSEL_MASK) << 16) |
 		       GENMASK(11, 8) | GENMASK(3, 0)),
 
-		.w1c = (PCI_STATUS_PARITY |
-			PCI_STATUS_SIG_TARGET_ABORT |
-			PCI_STATUS_REC_TARGET_ABORT |
-			PCI_STATUS_REC_MASTER_ABORT |
-			PCI_STATUS_SIG_SYSTEM_ERROR |
-			PCI_STATUS_DETECTED_PARITY) << 16,
+		.w1c = PCI_STATUS_ERROR_BITS << 16;
 
 		.rsvd = ((BIT(6) | GENMASK(4, 0)) << 16),
 	},
-- 
2.25.1



