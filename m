Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D93516BA50
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgBYHPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:15:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46981 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbgBYHPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id j7so825547wrp.13;
        Mon, 24 Feb 2020 23:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MXnr7SXWd3sZ9y2GpLG8oulHQdSPNjGvm3z7+mtPRUs=;
        b=AnKwuP9rjTVPLHpwzlq6lc1d9k+g7tRnfitmWw9TPc2iN76SjDoJsVSHeRh2v+rWhi
         VhnM1IffT24IeJKADgx9ThDnS44nGkbCkGMuZ0othHiXStl9+06ppqBo49o5LT9TSAjW
         SgbYJtx35XigMCFd5MeQw04/hLUTPIEovEZpnmwRKXLEpyOmoh7izkiUjsEdz0FkH0Oc
         o3U3vytGm2HcYlLJ8TpUwzUE8riQsb2tasQ9jCCP1xH1v0uDN23EzRi5DHHFRCy715Ro
         7EBb9E/EujcWa6sG08lBpWUqrigm65yoWI+wDyKBSOXHyd4s/nGOlENfjpuFphOwUD3a
         /bNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MXnr7SXWd3sZ9y2GpLG8oulHQdSPNjGvm3z7+mtPRUs=;
        b=UIpjCdtEc4qUryrpvgthm4FTFoOEkWXv0c7uuuNDfixiYmX8PsZInMsUqqYCAKybAp
         jAo4x9q/rBxzLmfaOIdJ/0R7MiRjWfWJF5qOvyrDbbRKazWLdMn8bKBSjZemtmRfAXJI
         DBEQsBlZ8TpC91hORfZpy0R7k7OM8c/nXWXtakyVQTpNMZQxoKiZDopfKqzm3rtptdkx
         stlWqGmEwmdvnehYmRmYbZUzer2Smy6iDnva6fxwTy/XfTqnKRuZY8xSmpH2a3KMVC8O
         em16LmvSGEWa+I2/1JPAZCBS1i248TYZBs7jyqSxFk32ZjL+6QhsLaQstKL4ZoCGwu01
         NXFw==
X-Gm-Message-State: APjAAAWNHr+5xDZCW1B1Y1ejJz+7WhyOCnLLAQf8+oTQQm0j3H45VAao
        43lcQvw602foaKKoXJt8vQ4=
X-Google-Smtp-Source: APXvYqxESA2RAgAht8QxLCevNSuB36AfskfMG08xU9EgkYdswvy4qyDRiWiFQtOnciHwTbOfmP3qkQ==
X-Received: by 2002:adf:ab4e:: with SMTP id r14mr19352165wrc.350.1582614929835;
        Mon, 24 Feb 2020 23:15:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id x11sm2867274wmg.46.2020.02.24.23.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:29 -0800 (PST)
Subject: [PATCH v2 4/8] net: cassini: use pci_status_get_and_clear_errors
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
Message-ID: <a340836a-172a-38ab-3723-34a21e7e604b@gmail.com>
Date:   Tue, 25 Feb 2020 08:11:16 +0100
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

Use new helper pci_status_get_and_clear_errors() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/sun/cassini.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 6ec9163e2..e6d1aa882 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1716,34 +1716,26 @@ static int cas_pci_interrupt(struct net_device *dev, struct cas *cp,
 	pr_cont("\n");
 
 	if (stat & PCI_ERR_OTHER) {
-		u16 cfg;
+		int pci_errs;
 
 		/* Interrogate PCI config space for the
 		 * true cause.
 		 */
-		pci_read_config_word(cp->pdev, PCI_STATUS, &cfg);
-		netdev_err(dev, "Read PCI cfg space status [%04x]\n", cfg);
-		if (cfg & PCI_STATUS_PARITY)
+		pci_errs = pci_status_get_and_clear_errors(cp->pdev);
+
+		netdev_err(dev, "PCI status errors[%04x]\n", pci_errs);
+		if (pci_errs & PCI_STATUS_PARITY)
 			netdev_err(dev, "PCI parity error detected\n");
-		if (cfg & PCI_STATUS_SIG_TARGET_ABORT)
+		if (pci_errs & PCI_STATUS_SIG_TARGET_ABORT)
 			netdev_err(dev, "PCI target abort\n");
-		if (cfg & PCI_STATUS_REC_TARGET_ABORT)
+		if (pci_errs & PCI_STATUS_REC_TARGET_ABORT)
 			netdev_err(dev, "PCI master acks target abort\n");
-		if (cfg & PCI_STATUS_REC_MASTER_ABORT)
+		if (pci_errs & PCI_STATUS_REC_MASTER_ABORT)
 			netdev_err(dev, "PCI master abort\n");
-		if (cfg & PCI_STATUS_SIG_SYSTEM_ERROR)
+		if (pci_errs & PCI_STATUS_SIG_SYSTEM_ERROR)
 			netdev_err(dev, "PCI system error SERR#\n");
-		if (cfg & PCI_STATUS_DETECTED_PARITY)
+		if (pci_errs & PCI_STATUS_DETECTED_PARITY)
 			netdev_err(dev, "PCI parity error\n");
-
-		/* Write the error bits back to clear them. */
-		cfg &= (PCI_STATUS_PARITY |
-			PCI_STATUS_SIG_TARGET_ABORT |
-			PCI_STATUS_REC_TARGET_ABORT |
-			PCI_STATUS_REC_MASTER_ABORT |
-			PCI_STATUS_SIG_SYSTEM_ERROR |
-			PCI_STATUS_DETECTED_PARITY);
-		pci_write_config_word(cp->pdev, PCI_STATUS, cfg);
 	}
 
 	/* For all PCI errors, we should reset the chip. */
-- 
2.25.1

