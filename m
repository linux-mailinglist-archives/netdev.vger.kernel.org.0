Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F5C1749A1
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgB2W3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36883 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgB2W3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so7805651wrx.4;
        Sat, 29 Feb 2020 14:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jVYqGE3zFQNBfIcS/dkWQZWOWyucD3CajAp6Ynd+Hzk=;
        b=OaATaKOfIaajcpbpgibKbkpwskhmu50Vjjtlx2EirgUo5PV1p5HL+/rxdUohgs5iZY
         A8oIht778UYbAlaUXkTCmf//DoQnHtIepIR3OvL9Jirl/sXhOgqtAk09MGrtxgbUsUiK
         b4BpBIqXGvtrb+5Bt0mz24l5kOqniJIzXCwrR/sIlUgInT9DImbycfK3K6nNJIdUB59n
         gzkNJ5KejFTsGlpy3Pp4nM3xZF/OhO5wZCg7S6vt+RNkuOkZllGWGCaIrvmtimXxfu7s
         jkO+ccPv8WUy4Gho96D33awi8wM+ejiuuilJcsjlYp3uPQEOx4lFku456WeLbKWGx5QM
         vjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jVYqGE3zFQNBfIcS/dkWQZWOWyucD3CajAp6Ynd+Hzk=;
        b=fmMxIzUFdziyLo9WcJrCrFoV8g6RX2P7Q2A4GxaOQvOd+iCb78gQNS+BWJQ0QU+e1i
         LjdD5HA9yIp3eUTNPoDbHd25fA8CRYjAP6yh5J3Ir+vwhRQkJEqxV2yNa/aV6EzRWuID
         qIMvSr7eycMItoNFPCOgnLX+dS37j0J/L3IWOS2J7MYzIKSU36c/DcBk418lAfqv5pHi
         h1p4pPqELPR7jOZxn1likHxIsqfqDexRDbsvj9eOkI7lgbGb+sKpUBSr6NnusjVSIqkg
         IXOf7QDg2oNcoz1hvGBvDNmUmUuJtVSTzKW3KqiU7tE6Z2G9kHtHPPgbxZAUYey7ih2o
         p+2w==
X-Gm-Message-State: APjAAAU+14ClTHNuP1drys5lsBaWZbljK74RPR7z6eGrBJwP/pEzyHyq
        VfMvZ3lV9nX/kmepBkQ32aI=
X-Google-Smtp-Source: APXvYqzl/hXV0qSgKwkh/YikHZvhUeSMY6k/AO3khueq4Xn4PyW7j2eWXvjgOcfRyRaKxbbmWmPRXA==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr7958780wrr.426.1583015371300;
        Sat, 29 Feb 2020 14:29:31 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id b21sm8012210wmd.37.2020.02.29.14.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:30 -0800 (PST)
Subject: [PATCH v4 07/10] net: sun: use pci_status_get_and_clear_errors
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
Message-ID: <f2b690d8-bae5-6172-7f8c-1fe9b9e8e421@gmail.com>
Date:   Sat, 29 Feb 2020 23:26:49 +0100
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
 drivers/net/ethernet/sun/cassini.c | 28 ++++++++++------------------
 drivers/net/ethernet/sun/sungem.c  | 30 +++++++++---------------------
 2 files changed, 19 insertions(+), 39 deletions(-)

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


