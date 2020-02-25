Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3DA16C369
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgBYOJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:09:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40738 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbgBYOIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id t3so14871392wru.7;
        Tue, 25 Feb 2020 06:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ePoQM9FMGKqv4Tet944qGjHoWr4YdITdi8WCr48XQE=;
        b=XpQ6CUy4B0PFiqUcCWR4KG3hEvT/x0Lcnjq+gE6xukN6aT+b2mJVFAI5E8t2BKP1fT
         ZmGr0fynPhH2JLewq2h9lxi0QLix779zBY/9lfQAqF+0pCspm1s3HM3A+YFBOk2Ws2fH
         9Ma6td7x2F0gwy7oOAWzkQhgc2MW9bPTMQcBjCJzsgcoZDiEa6jRakzhV5eWAx1UQJdB
         4BbsKGzb8S+1tJi+H9vp+IuH2M7b3UD4CQbyeqCFybBpZyvjBfkjTfz3iCBrbvjhPUo/
         FW6Qkp+rEb6yOXreDvBPC84kylfdopRBMyHE+5ys4+pxmQwxVMwZN8XfIUEK8PparXsK
         Ye1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ePoQM9FMGKqv4Tet944qGjHoWr4YdITdi8WCr48XQE=;
        b=coKd5ZnslF1bSPHPwurO1vHpT6+b0g8WTHx5zXuC82g1CRFYA9Wez2BjqYu1tgETe+
         VLC3hwPKztPLxh5v0HmtwL917UUuaqPujCavNSA3ZE1uRsaB6XeIsT/sj6IPMuV8MmEI
         zopbem2so3dB7NqjHQOuiU1NAqjPlyzf8Yn8yYaD0ZH50FCLA7um2QunzZnknuRn6oZR
         6OzfDwZPOiXWgPhriHpxpGikgKA9DQkVvjkdhn71j7hzM6ML2RcJG7DZLMh4wizeDPaL
         XNtCSItd0fS6oNPeZxuO/Qhfs+YQs3pTNaI/agaKstnpzrreDzTnHS9qGzzXYNkWYcsV
         +VFA==
X-Gm-Message-State: APjAAAX3+xZ6z1sULYE/+fZ3B2s//qb5zmK+3OoGcmsxru+O7MFdb88S
        MzFGX/snfCuXsF4XA5WOb3i6RpPc
X-Google-Smtp-Source: APXvYqz7xgbDNu/OOcuZuP7PhmhDEKBWzd5vYhy4rP3mhq+YavENk+sOCb4AhtghYWKGJbOUQVvl+g==
X-Received: by 2002:a5d:568f:: with SMTP id f15mr10277574wrv.202.1582639714509;
        Tue, 25 Feb 2020 06:08:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id a13sm6764537wrt.55.2020.02.25.06.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:34 -0800 (PST)
Subject: [PATCH v3 5/8] net: sungem: use pci_status_get_and_clear_errors
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
Message-ID: <63fd34e0-3f45-762b-804a-4ebacb954842@gmail.com>
Date:   Tue, 25 Feb 2020 15:05:47 +0100
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




