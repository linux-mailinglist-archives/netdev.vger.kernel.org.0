Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135A82EC2CC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbhAFRxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbhAFRxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:53:21 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D4BC061358;
        Wed,  6 Jan 2021 09:52:40 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id jx16so6118951ejb.10;
        Wed, 06 Jan 2021 09:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LMhEikvRUZQaIKyyHYQPd9FehVZ9OCrs1+Guuen9CX0=;
        b=tFjOXOsquLgJec5Svj2aNg4kNYEga6uS+V4sECR+77oIWlS4xBlhguxxaXIZkuBYHd
         OZZ1n95oRVDx+yVtvgBdvvyopTPR2JG8/n58G717wNHR7eHBAsE7Sx13XZ4FkZV4PGx9
         osesB+IphuyUNg7iZLWFLj27JJ2DRykAaRIyzxuGFykfGlo5Q5vsNzk1wfXsfpRGbxfI
         IxHB8D+rQYOANCJ44ReQstv3M5fVeYevvRHELPRLc9JzCGX8jJYOcCrQNJQTwBIgIUfv
         rHMAkvrxfD8y8UAs4sWYt+KvY1lpEfKiyv+Mjv8ZrEgX5qHxk9lNvKtAVknzi9brkptg
         Gyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LMhEikvRUZQaIKyyHYQPd9FehVZ9OCrs1+Guuen9CX0=;
        b=k/rFNRIwJRRrraIfE6T8HnJKUo9JLOGjy5E3Dbnu/ACHBoioSqp/q6+S13rDE3KXR9
         TPV5+Ikn3M6NtMy6hcjmRsLur5AHG7AT0Ryc3OadmgFFNr1tOCUCxBBr7hrQli9ypY8w
         D0SiuWHdhSy9DZb3OAHnmI5YojmSxW5sTwawpicm5oklP4R51y8bGBZPTluG6k8x52BU
         I3qAQPSTPqdw8rM56HtemgoiKjeYvPHIRs/SJNIIM0ZUhREa8cX2TqEbgzEekCcejqkK
         WpWl/EDJhFXTl/KO687IgiHGJ25o5BGgod18Echfumj0mxVcLmHEfZHtRtUhKMRiIPOd
         EHkg==
X-Gm-Message-State: AOAM530DLyVBsK3Dt7aIZ0HSZwCdZdOm2zQQMcuW44kjWi1de3ji0L6V
        pcQ+78oMQ/XeakC8TV0IlsNVO8yBq8k=
X-Google-Smtp-Source: ABdhPJzZhqLPes8FWc+g2+meURM8xcd5OE4SEtJiwwW78Jp8SQlh6ANKZ06XF4U9QcDU5ltSn0Ryfg==
X-Received: by 2002:a17:906:c790:: with SMTP id cw16mr3694633ejb.344.1609955559148;
        Wed, 06 Jan 2021 09:52:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id d13sm1728045edx.27.2021.01.06.09.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 09:52:38 -0800 (PST)
Subject: [PATCH v3 3/3] r8169: simplify broken parity handling now that PCI
 core takes care
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
Message-ID: <9e312679-a684-e9c7-2656-420723706451@gmail.com>
Date:   Wed, 6 Jan 2021 18:52:28 +0100
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

Meanwhile the PCI core disables parity checking for a device that has
broken_parity_status set. Therefore we don't need the quirk any longer
to disable parity checking on the first parity error interrupt.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c9abc7ccb..024042f37 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4329,20 +4329,6 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 	if (net_ratelimit())
 		netdev_err(dev, "PCI error (cmd = 0x%04x, status_errs = 0x%04x)\n",
 			   pci_cmd, pci_status_errs);
-	/*
-	 * The recovery sequence below admits a very elaborated explanation:
-	 * - it seems to work;
-	 * - I did not see what else could be done;
-	 * - it makes iop3xx happy.
-	 *
-	 * Feel free to adjust to your needs.
-	 */
-	if (pdev->broken_parity_status)
-		pci_cmd &= ~PCI_COMMAND_PARITY;
-	else
-		pci_cmd |= PCI_COMMAND_SERR | PCI_COMMAND_PARITY;
-
-	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
-- 
2.30.0



