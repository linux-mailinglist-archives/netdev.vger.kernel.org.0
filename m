Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE4716C370
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgBYOJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:09:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34245 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730240AbgBYOIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id i10so1194234wmd.1;
        Tue, 25 Feb 2020 06:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eyXZbYhJwbPUHpTlxOFb8ilZjqXa8eHWzE7fBgVE9Xk=;
        b=Tgejs1RtD9lZ+fRHFgFRqCifXvDscbHRfyDTGXGn0LqTsGZFT317qnA7hcWbiFLu8M
         Lpa/15GZjxT3Jw4gE03oBiGU6A+WHcGTMotw+3umW1XJV7g/mc8QVkemIRLW55Swfsfq
         7PoUpdINm7YdDlNtUG1/ntJdzm6A9E80YsVwjY8mfH1Kyso92x9Gt13dqex8C95iZfw7
         dfJl4/9+muKn6GE3MAFqWrjvKfwCi7j6FVX0vC8ne9KM082fGmqiFhBw4eQk2hHB+EUd
         0P8etoJHwBaGNF8SWxjRpX0ry2OP8PB2mc0D1P0qnIL2BRuZLSkYDLpElkVmpZMyTIw8
         d71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eyXZbYhJwbPUHpTlxOFb8ilZjqXa8eHWzE7fBgVE9Xk=;
        b=liXk7zhvNNWOko7NXjWU2sRQSujLiMKaSr6Ap7i9qav7exw1Dhb60USuOxO6pAdU3l
         HZnbsQi0kzvtU55APi8SlnaZQyi+qu9roOZK+d9Qyv7+McbE9uUBIMQEIkA7jLrDbXUl
         WtbGNRgTRsvt5iTLg193ATeWrvuSuauybIq3JyKUxa0VFNY0rBCnn3XI+Y2tvvyOcCBN
         kVeR+UStKRUHrgEUxbpRrohV8Whx9IFe5SgWF5Pghn4Hv6AQ1HNkXKq+//0Yrheb44dA
         /u6qgQXorE4F4J57gKj3FUGAy5d4KsatkAqMdlf+GpuutacpjKK15dMj+WO47c2LfBAT
         U2gA==
X-Gm-Message-State: APjAAAWhJ7HnmlUjlU4RoW1zQEGftRl6ilVJQTz6dMD+5051LdiRqWni
        o7QDIDSEvOD1Ui4HpCMMvcQ=
X-Google-Smtp-Source: APXvYqwXEQTkS3WWQVIpWtCGM/LaodNCg+YS2vwu9PPvca4AxsHvS9RRpsvVW5dKB+nF3MM94zFx3A==
X-Received: by 2002:a1c:a1c3:: with SMTP id k186mr5466464wme.179.1582639712042;
        Tue, 25 Feb 2020 06:08:32 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id c9sm4347680wmc.47.2020.02.25.06.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:31 -0800 (PST)
Subject: [PATCH v3 3/8] r8169: use pci_status_get_and_clear_errors
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
References: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
Message-ID: <d11d10d9-aeeb-e31f-29f6-02de977f29bf@gmail.com>
Date:   Tue, 25 Feb 2020 15:04:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
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
index f081007a2..4495a3cf9 100644
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
-		pci_status & (PCI_STATUS_DETECTED_PARITY |
-		PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT |
-		PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_SIG_TARGET_ABORT));
-
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
 
-- 
2.25.1


