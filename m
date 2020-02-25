Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D1416BA5D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgBYHPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:15:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35803 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgBYHPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:32 -0500
Received: by mail-wm1-f68.google.com with SMTP id m3so1752519wmi.0;
        Mon, 24 Feb 2020 23:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ePoQM9FMGKqv4Tet944qGjHoWr4YdITdi8WCr48XQE=;
        b=RMvN0nzagkNH3rADUoq43XFUKTNTV61lqBDyblWsePyR5efhsEzZF1dFizbVAuvq7r
         0JygeyjMPt1zs7zNvgvlOJaxKePoR3l+zb8yNk8y3TmL/LzwCwSXPZ2wzm7shrmetpO5
         YOvzpAOQLygocy/8XjjcT4YDONSR36O+x0Z9Io8qzG0x2chmtsoBTeZL8Ad45vkwMxUt
         qVh97Ph38gO/jyPjbvZToj8RJgMSWSsqgVvA1mT6+srlFkrr0rIPzEKHeh8sEYsy0x/q
         +PeofHomDWiqel1jBqaF43NgbfD/8WKK2+3kcpxvZzYUefLsBMFTcAGfzKP+1taWTIj6
         NL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ePoQM9FMGKqv4Tet944qGjHoWr4YdITdi8WCr48XQE=;
        b=sqvaj6LU8IISoZ/dVcdrksXE8asFTQUlzi2ymlh7JtJxwLEA1V3EYo0QfjlmvJDjjU
         boH/gcXsqSu8maGzFxZyK8NB+YP6yhZLGrFzDiUncR5AG0eL45ic/Jy6xJzvBUI80d4g
         48NpFqxUr3c2BoskUuQwV6g1WEIcDJQ5/eUAOB/AKxbxByHlo+lQmXCB1RZQYzeVHzWy
         lymzK+H1+bpCOea3eMXSRz9ioKuaUvIe7Veyg6CnqgrvAlVFwUxD10m5ZSxPaC8oEBix
         UbT6VCRM6qe2EJgrLoaYg3cJJ/Ct/aJEea9LUQwGQDya1kA6+q1xMPqZAvQ6RyTeMExO
         oNOA==
X-Gm-Message-State: APjAAAWEiposSa6fcVsfcCi4OoEUwXZysjz3ykOyxk1ohxLgwgr0AofV
        HguWZsWD2yA2oyA82Lpq+a4=
X-Google-Smtp-Source: APXvYqxyJq8TM0zX7/rjcKiH/KgQ2ZEar29/iF+rJzVHQf1kWyZKrHbqfZJZGLghyxyxZVYosqbqtg==
X-Received: by 2002:a7b:c389:: with SMTP id s9mr3383352wmj.7.1582614931095;
        Mon, 24 Feb 2020 23:15:31 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id b186sm1026249wmb.40.2020.02.24.23.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:30 -0800 (PST)
Subject: [PATCH v2 5/8] net: sungem: use pci_status_get_and_clear_errors
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
Message-ID: <a5ab63e7-f39c-a525-9940-31427edc81a1@gmail.com>
Date:   Tue, 25 Feb 2020 08:11:59 +0100
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



