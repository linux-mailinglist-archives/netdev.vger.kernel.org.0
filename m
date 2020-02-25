Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D93916C359
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgBYOIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:08:36 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51586 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgBYOIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id t23so3144963wmi.1;
        Tue, 25 Feb 2020 06:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MXnr7SXWd3sZ9y2GpLG8oulHQdSPNjGvm3z7+mtPRUs=;
        b=ggyx+DhJDs4IZW2NRQNVlJkJfvaztAI1R7yNUYaMvijzwfWBnKsuacf0Wr4M3vvda0
         hiKM6OWN0Y2KCeoEnZU9qeFKYKM3SGmg9i7Fc1mbVfjAO0+4F4falIn7uvGbpY6ZOEio
         WIwYrgZ1xsfj+xmSeg7fTWcawQ+DHE4fjsi/LweT+1VFdl7W4V++ul3920JT/Qw/HOFk
         2nGtxsabeaNMYE3EBRNz6qqV618wKN7rRGt3bM2S8+7EmwPLre1YP1I1OoKNB0REqv4N
         zTcEp95XvpaOHCe53qkr7JH/oNxBxdroGRJrDbT39NN93XChMPv4W8MgGDM5xaiY+Lqr
         PI1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MXnr7SXWd3sZ9y2GpLG8oulHQdSPNjGvm3z7+mtPRUs=;
        b=CpiQyts6DUwW+XExGPx9p/VV7PBR+YDtVby0TB95rk2nzQTDj/+rEJWGRf1z4EeL7F
         1lSvneiRn58AV8c6+yPA1AfbWTFTo6rsLovoOMx+BFY9CrC3RGhP3roSvTilyDsS6Qy9
         d33TEoMeBBmoMyqr/eLi/lDX7EdZaaeVNvhelwdpo374mC4wfN52czzHCS8cmclu5ZGn
         gYXxgvzQUvO26tLrpFsTQx7ZQlsPutXx+gR+Zibhq3i63YqkKoI5bvDgBKEGtE1scExM
         7uxItkYjT7A6+K2OYP8+KJXGynl/SYExUmArKQ4sZ/UbRCTAb343PMf2AJeNdmHANh05
         TAVA==
X-Gm-Message-State: APjAAAXpZ3KNYx839Mw2UcrFP+xXNGqtd5YsN/7ZxOYb+s2wnF9GzYAq
        S13Rs/WAXVIWeZE9+qzstWo=
X-Google-Smtp-Source: APXvYqx8olBiiKkdtYFvGn2/zTjsT2GqKL8ObDMkWU8WiL6yR2S5w+lKgH6FdOMBVF7oEsYDFplamQ==
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr3243800wmf.101.1582639713263;
        Tue, 25 Feb 2020 06:08:33 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id g14sm14009578wrv.58.2020.02.25.06.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:32 -0800 (PST)
Subject: [PATCH v3 4/8] net: cassini: use pci_status_get_and_clear_errors
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
Message-ID: <58e21232-e3c7-f26a-aebc-f03f27a851d1@gmail.com>
Date:   Tue, 25 Feb 2020 15:05:19 +0100
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


