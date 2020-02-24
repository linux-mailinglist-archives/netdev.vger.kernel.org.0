Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0862F16B25E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgBXV3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:29:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51317 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBXV3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:29:49 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so846657wmi.1;
        Mon, 24 Feb 2020 13:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ePoQM9FMGKqv4Tet944qGjHoWr4YdITdi8WCr48XQE=;
        b=Wsb1P9jQEiF1IO2n76fs9xq4T9QbIj9YXd6SI/DA4Y8j8BTYxfPy+wrh2QxV4WjHBx
         34rvlUTboSsZUi4H79FEYfym43FdNTOfMsuUcOGvWMFZdrYjf5zJW2OTODXD7AZ9+Ane
         aPdroTgvj3vfXzspmGpHDEnAKRlOfb/GHjyYKawYHj7gTX17Ue1VkFzhHYSgJVPqCNzX
         vgi/6n88QKy9NiwuFt3N7qgD0PU7/bg/6CuTEX8ABVV5FWMI0PlK30uVbf9CnN6H8GPO
         82gds9gHr4hufC1K4u+H/4ABcZdp1IxfQwD79fU0FM2Jtpug3uq7G2JxQ98D1w6Cw14B
         TubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ePoQM9FMGKqv4Tet944qGjHoWr4YdITdi8WCr48XQE=;
        b=hRsEUfpA0mxSBbsqxoRXwgg+a4ZvUZF41AP9WGepOOFhuDB4cNpHeSHiCTsRIrNzZ1
         FmE6Jxdlbzf8ignyWuXdVbbDTEPT72a8lQaJJE8Ebuz6bGH+b5FHIKbfMbDq4vDHmSpE
         So4qEXOnbGY4I1L+wtWkTvZawo+VFuqGAjQ2Q7W87uDdLvhCAn1DIddOryRpk2J7cLzl
         virF1aC6xh7+fnGAz5KFdhSweQ+sRSnRGBvTp2VZKSynShPr5VlJbGWFT1bNsW4zQEIR
         GPkg1CmglO70PalYwYlo937zKDc7yI1fWVdhacoIe7YwXJkk23qAaEUZRk/v3n9UvH0R
         ySMA==
X-Gm-Message-State: APjAAAXC7F4L6WVh+t4pFNb4duyeptmiUKItZ4VFrTo8dslcBQWb3yMO
        iKnwh+6GBrRKQBSts0HfHlkJkmy+
X-Google-Smtp-Source: APXvYqxbfXTP6O46zvXnsmgQaL9+Uu+XGMcGZo8uQYQDFGZv8m9jO7d9kHr2VszACwNX16y6av14Fw==
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr919880wmh.164.1582579787655;
        Mon, 24 Feb 2020 13:29:47 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id b11sm20510727wrx.89.2020.02.24.13.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 13:29:47 -0800 (PST)
Subject: [PATCH 5/8] net: sungem: use pci_status_get_and_clear_errors
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
References: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
Message-ID: <e88effc4-bd85-9734-533d-60e3d40d27f2@gmail.com>
Date:   Mon, 24 Feb 2020 22:26:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
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
 drivers/net/ethernet/sun/sungem.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 8358064fb..2d392a7b1 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -545,37 +545,25 @@ static int gem_pci_interrupt(struct net_device *dev, struct gem *gp, u32 gem_sta
 	}
 
 	if (pci_estat & GREG_PCIESTAT_OTHER) {
-		u16 pci_cfg_stat;
+		int pci_errs;
 
 		/* Interrogate PCI config space for the
 		 * true cause.
 		 */
-		pci_read_config_word(gp->pdev, PCI_STATUS,
-				     &pci_cfg_stat);
-		netdev_err(dev, "Read PCI cfg space status [%04x]\n",
-			   pci_cfg_stat);
-		if (pci_cfg_stat & PCI_STATUS_PARITY)
+		pci_errs = pci_status_get_and_clear_errors(gp->pdev);
+		netdev_err(dev, "PCI status errors[%04x]\n", pci_errs);
+		if (pci_errs & PCI_STATUS_PARITY)
 			netdev_err(dev, "PCI parity error detected\n");
-		if (pci_cfg_stat & PCI_STATUS_SIG_TARGET_ABORT)
+		if (pci_errs & PCI_STATUS_SIG_TARGET_ABORT)
 			netdev_err(dev, "PCI target abort\n");
-		if (pci_cfg_stat & PCI_STATUS_REC_TARGET_ABORT)
+		if (pci_errs & PCI_STATUS_REC_TARGET_ABORT)
 			netdev_err(dev, "PCI master acks target abort\n");
-		if (pci_cfg_stat & PCI_STATUS_REC_MASTER_ABORT)
+		if (pci_errs & PCI_STATUS_REC_MASTER_ABORT)
 			netdev_err(dev, "PCI master abort\n");
-		if (pci_cfg_stat & PCI_STATUS_SIG_SYSTEM_ERROR)
+		if (pci_errs & PCI_STATUS_SIG_SYSTEM_ERROR)
 			netdev_err(dev, "PCI system error SERR#\n");
-		if (pci_cfg_stat & PCI_STATUS_DETECTED_PARITY)
+		if (pci_errs & PCI_STATUS_DETECTED_PARITY)
 			netdev_err(dev, "PCI parity error\n");
-
-		/* Write the error bits back to clear them. */
-		pci_cfg_stat &= (PCI_STATUS_PARITY |
-				 PCI_STATUS_SIG_TARGET_ABORT |
-				 PCI_STATUS_REC_TARGET_ABORT |
-				 PCI_STATUS_REC_MASTER_ABORT |
-				 PCI_STATUS_SIG_SYSTEM_ERROR |
-				 PCI_STATUS_DETECTED_PARITY);
-		pci_write_config_word(gp->pdev,
-				      PCI_STATUS, pci_cfg_stat);
 	}
 
 	/* For all PCI errors, we should reset the chip. */
-- 
2.25.1


