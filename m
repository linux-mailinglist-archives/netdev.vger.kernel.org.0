Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7940216B270
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgBXVaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:30:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33738 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgBXV3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:29:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so12206778wrt.0;
        Mon, 24 Feb 2020 13:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MXnr7SXWd3sZ9y2GpLG8oulHQdSPNjGvm3z7+mtPRUs=;
        b=oW/vOC6VRNovnTJmYJe/0RE2OYTtG2Uysvbdg0BWeBhHRAW+3WC63ZiQ2c/50tQTGu
         0jfQiKSU2AMja6jPEbMAwMJyj9kHvDFCtl6t1BdUofmECIiM/kkwsWnUNSjEm2SyGVuK
         kpfaEOUIOiy9kc1LU8fNMx5Tr9TEnqfMK7lAruLj2xIATpWrobvbNMxP+tOE+uiQGShE
         dum63bMsXyLdkxj4fH1nJw+Fg/cLvqsbMfnoj9BcuENsBJsMfniTVKY/sVq5+zRKGyeH
         ElUP3c1ngWAVEtcBF8KpuCt2toxxqir9wNZt6rgQCiQD8sycXZz2Tnv6QCizOKvMUaLo
         8xug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MXnr7SXWd3sZ9y2GpLG8oulHQdSPNjGvm3z7+mtPRUs=;
        b=bBIetAgCTMTtXrZksp+CYeWrLnD8DE42vNqdmlRQE5lczGErVRLbGT1cZre9twW+cx
         KxffQ8RtefcRquA1DaSg/Bx8nmKfBhic+cue0XUklNknTrVw4wIcU1OTF3ln21r4ATbF
         wLvTDKt+VZLOhxNkwjNh0GTx348ojOdCxJSjOkaJc0mrbMA2Lbil+G3M2qyiHhso+Kcq
         dGLDQrYdc5RfkZHvpvjbd+v9VBDN+H905Giyax/JjOL1lgPa5o7w/q13jmWKYsVEkGCO
         FhMJzETtBmY8frpt81Yei0wCS7+M6150rahpWN8xLGOqsTbbTWOPzH/k/VfOdrb8LRQ8
         t7DA==
X-Gm-Message-State: APjAAAWvFUtCPOdDnNlyueSnizz59OyqQItLvpE9aZWYlO2wWzZ/CGwH
        tf0XsNt5ygunS4YlosyOE9M=
X-Google-Smtp-Source: APXvYqyTfooq6YqjLy2mLntbawK0f8ew7gDmTCSEpy/IJgY0QtDfVtFmWKI7569tWqvu9bscS7JeHQ==
X-Received: by 2002:a5d:6087:: with SMTP id w7mr67170408wrt.36.1582579786300;
        Mon, 24 Feb 2020 13:29:46 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id t131sm1026424wmb.13.2020.02.24.13.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 13:29:45 -0800 (PST)
Subject: [PATCH 4/8] net: cassini: use pci_status_get_and_clear_errors
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
Message-ID: <72272163-46a9-93ff-cfce-977c492cc75a@gmail.com>
Date:   Mon, 24 Feb 2020 22:25:50 +0100
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


