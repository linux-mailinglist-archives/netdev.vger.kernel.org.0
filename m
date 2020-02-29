Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 832241749B2
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgB2W33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:29 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51463 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbgB2W32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:28 -0500
Received: by mail-wm1-f66.google.com with SMTP id 9so1046947wmo.1;
        Sat, 29 Feb 2020 14:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=myR4RAc//3dCnqTEQ8pVmIEQ+AFWBKpyKIszlN9NwYU=;
        b=TwswjIcVZfUuOsVFnI9BtvkCoHfapq371Mt/CK9szBaoH6IFLmYziO8L+680Rg92ED
         +Vm6sjrJouR9p+j0N5dHKxzO40ggdAk3Kr5NN5d0ziTbRBZLBLl1KppyAqib1Um/0KqF
         ze4il5mlV+BBZzqXnVweEiTSXNUncqab8lzYeEqCzIyFtdT83qm8mXoxLG700dedhDIi
         umHEytNJVYXGykkrSnpqbAmPEkOk0tLmG70U8i8RsXoSL/lTEJNzUoqucXTw8KO2N5Og
         79sqct9fphheiXzt9xZF6upl8dU/M7Pbkz4uYhe44K21rDVF+ZR33uQ53qMEWhxkGn6L
         wXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=myR4RAc//3dCnqTEQ8pVmIEQ+AFWBKpyKIszlN9NwYU=;
        b=WJ7f+fv33mPyz00lm6E2l/C1WhYMuAupKF38I5Kj+T4xgmhFpjL1Y6tO+YrydMwht2
         Y2GOx818AE+3BGh/hhx+ro06cLklrj0SHscGvOzn/S8bfbPnjlGhSYh30GYFO2qyahww
         5gTVz1Kes/BQObfiWdIxNUrWmBzMYT+QiE+QQ/6vTtQ5y71NF9bvSUjiLKjZO2np+xXN
         33VOpSwevMYWDLk0posHQxfRQhSvckbbIxxIQ+FEbCCvhWC3Bwinb+UPBhRBVbYinjhL
         ivs1PHLvcyv1OnFHjI8yNBMn5d/8KEyLMQ1p26yKAPqMUx2liJomWC1wGxpWRUI+kWa6
         sJZA==
X-Gm-Message-State: APjAAAUwQS3JtbUk2IupxqAyzQrZZzVrdx2nu8YD4oXFwZlKVcCLDO6I
        h8Bgjkj+4sQMQbBHB8hiEPg=
X-Google-Smtp-Source: APXvYqwzs7Zoc9nr2q/NPXFPCKZAB5tA8lu9Kr/BNlJwkZDymFknQXHa2NV02VZ/jB3jqQPfR4jxSQ==
X-Received: by 2002:a1c:a70a:: with SMTP id q10mr6956306wme.88.1583015366430;
        Sat, 29 Feb 2020 14:29:26 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id c9sm7873948wmc.47.2020.02.29.14.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:26 -0800 (PST)
Subject: [PATCH v4 03/10] r8169: add PCI_STATUS_PARITY to PCI status error
 bits
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
References: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Message-ID: <94e0dca7-859d-12f6-9316-55fc107dd49d@gmail.com>
Date:   Sat, 29 Feb 2020 23:22:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out PCI_STATUS error bit handling let drivers
use the same collection of error bits. To facilitate bisecting we do this
in a separate patch per affected driver. For the r8169 driver we have to
add PCI_STATUS_PARITY to the error bits.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f081007a2..7c9892a16 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4381,7 +4381,7 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 
 	pci_write_config_word(pdev, PCI_STATUS,
-		pci_status & (PCI_STATUS_DETECTED_PARITY |
+		pci_status & (PCI_STATUS_DETECTED_PARITY | PCI_STATUS_PARITY |
 		PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT |
 		PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_SIG_TARGET_ABORT));
 
-- 
2.25.1


