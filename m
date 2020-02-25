Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB51316BA5F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgBYHQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:16:01 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36240 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbgBYHPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so1946251wma.1;
        Mon, 24 Feb 2020 23:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eyXZbYhJwbPUHpTlxOFb8ilZjqXa8eHWzE7fBgVE9Xk=;
        b=lFQ8s76SQxs/TPgj46U5q4nM69WPMtbhckVXYhlQkTZj0xwgXgyc3eN91REL3/q7vx
         xUsWoDafZKGKCm3xrhsxt8pRKI/jBNqzH6tyUNdDa/FbQ2irKs0MAib4LzbRq7oJRD1+
         /7YiBSXV9KzonCscTVHvOKw7AM51L3iby8P+X+vI7hn5yx8xRUjb19Sy6zGqDlraAQVn
         xzLgJT+4hhiG/YqbcJQkqfU31lJ0JMz88Gii2Z1pzy1NUc+489kDpnKd/EwhlULF6Vx2
         T9EJSmcUk/fqfFYqdnJFf0asSC6N4AHc/D/+aN3qyZrf/DhTJBPWfcVe7eUCFE2Een03
         HWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eyXZbYhJwbPUHpTlxOFb8ilZjqXa8eHWzE7fBgVE9Xk=;
        b=leH/gIIDq/niDnM2xXExc094mKiIBGH0uVEg+QlexRExH/8FxfJyPiy8ATkRQoIuTF
         AqKFu6ooB1oqdfvr6Qf7Du7mELHtb2JpmBTj5HjYXuQhgl9NIiJr4dvHHsa5xvkKUn+1
         p3WeTcGMwV60TWDyNRNhQ6mokxnmXzraUQt/kVpzRMPiX1UaL4qsY3dkFddb8Y9S3yMH
         pvGMRvS+O9lcwZcPGTV7N3EUYmATr2z9BL6JxA1SSKPZsNFPZLh43GDV1UtbhgdLXysC
         IDFskoazN4bpMaTrNQn2PWlr+s8aBqrqDgTRbI64mbEoeh9eoLRcHFco33dZi4RMiRw8
         ouvw==
X-Gm-Message-State: APjAAAXS7PdL2PJQ8UXFx/q6aIlPU2WNnC9unZqXhhDhA5kvVLhx2cIo
        aXhDf3aqmpnxCYUMIthmnFU=
X-Google-Smtp-Source: APXvYqzrrDcVi2I2IosglXQ3ELaLAkdyVpNi1dkCdPizuR3Nlwl0rBChT04mSg4oJj5ZbDEALIRNKw==
X-Received: by 2002:a05:600c:251:: with SMTP id 17mr3525800wmj.59.1582614928558;
        Mon, 24 Feb 2020 23:15:28 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id r6sm23019115wrq.92.2020.02.24.23.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:28 -0800 (PST)
Subject: [PATCH v2 3/8] r8169: use pci_status_get_and_clear_errors
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
Message-ID: <591b94fd-9d52-9a81-ad94-c593fb4c7b17@gmail.com>
Date:   Tue, 25 Feb 2020 08:10:17 +0100
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

