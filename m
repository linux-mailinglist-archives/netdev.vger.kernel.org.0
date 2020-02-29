Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E41749AC
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgB2W3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:32 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38797 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgB2W3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id u9so1307283wml.3;
        Sat, 29 Feb 2020 14:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5ecRrf1/V6B1CB3S5yVtFNvzXeyCocerP3hSIfKLkMA=;
        b=ryn3luSmm8QmTP8w9thNRNUH22Ta29tZvFO3g8hkxwVjbp1M3OrDLGa3BeiPequhMC
         sqf+ekkMQSvwm++PMD5RcWrtnTugbshuqFMJRb3A4Oa2JOddZkCArCG4CWn2KHkQvxQC
         gQiJAfnQJwX7B7WaEMK891vIeoOcSbnTuNOrBvQXC4AJACvQj2Nu2j4KpcUR9oZUUT0a
         drAu3UND2LhLXP+jPDovdbbgQZdOXA1N+dm4hu65nA6rJ9c3wXAnbfbeIH3lxlRRpQAM
         KxXmSF1RUeQytEiAnlG95vik+2hl0c4gabr07zRJXdGgPu0giWaEv7nRHb6sH1gQlpZq
         vWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ecRrf1/V6B1CB3S5yVtFNvzXeyCocerP3hSIfKLkMA=;
        b=IFyK23UOG5DjYerd3S750zsY6+79U9ppR0x1zuIm6jmA3tzmCZLpyKgGXfukgNeejw
         S+EvxTnrW2Duy7NKAhO8vmbwi9QF7ZXNybKaYCDHGLG2uMnFVNsva+++7NGainTBGVBC
         +OJwa2rp8aSBbKRi3it6+MxV8Z2503Dd9+oHsKthMvbKYynEggXMVJLmlZQZoymPLgpn
         lH3s11AS53xvbJKBdxlYPVycjg0MbIClGkS8upCy9+mwG07jAZVGQ3kQgtvRv2UJL7Xe
         helQzZffq0nAqK45vjJf91+Mro+P79NaULV4HIZa2Kr84UeFtCdLkpuGOuQiyN2LXjfK
         ojTg==
X-Gm-Message-State: APjAAAXb1VXNbjxJMPgCj+GH0QmaXRsTuFrUiOpcWk5kamzk+ZstvLof
        vgN9tuuDvYAxe/9GbK/hUbfiLjzc
X-Google-Smtp-Source: APXvYqx3ZAaL08Q5gur34JZGBFCqs6CgMQ4PCsqEDX+qNrcrsXclX+kybkTR9nKILr5gkKEoHBCEIQ==
X-Received: by 2002:a05:600c:2104:: with SMTP id u4mr11363395wml.93.1583015370047;
        Sat, 29 Feb 2020 14:29:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id a26sm8442970wmm.18.2020.02.29.14.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:29 -0800 (PST)
Subject: [PATCH v4 06/10] r8169: use pci_status_get_and_clear_errors
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
Message-ID: <823d89ad-7161-fd62-0933-f3e52f32ff95@gmail.com>
Date:   Sat, 29 Feb 2020 23:25:05 +0100
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

Use new helper pci_status_get_and_clear_errors() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7c9892a16..4495a3cf9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4357,13 +4357,15 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct pci_dev *pdev = tp->pci_dev;
-	u16 pci_status, pci_cmd;
+	int pci_status_errs;
+	u16 pci_cmd;
 
 	pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
-	pci_read_config_word(pdev, PCI_STATUS, &pci_status);
 
-	netif_err(tp, intr, dev, "PCI error (cmd = 0x%04x, status = 0x%04x)\n",
-		  pci_cmd, pci_status);
+	pci_status_errs = pci_status_get_and_clear_errors(pdev);
+
+	netif_err(tp, intr, dev, "PCI error (cmd = 0x%04x, status_errs = 0x%04x)\n",
+		  pci_cmd, pci_status_errs);
 
 	/*
 	 * The recovery sequence below admits a very elaborated explanation:
@@ -4380,11 +4382,6 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 
 	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 
-	pci_write_config_word(pdev, PCI_STATUS,
-		pci_status & (PCI_STATUS_DETECTED_PARITY | PCI_STATUS_PARITY |
-		PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT |
-		PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_SIG_TARGET_ABORT));
-
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
 
-- 
2.25.1


