Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004AA16C364
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgBYOIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:08:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34839 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730644AbgBYOIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so14907967wrt.2;
        Tue, 25 Feb 2020 06:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uS00F9df3Z8T26CltpV3tuHM711DSQH+xwYM8pFxAPw=;
        b=Ui6poiqUtcT7NPAd/IJGd2X4oqkVtpNnFjq5pulaPASdrypyJaM6KSHWuoxv3ws3x0
         V1Z+ncLQXHDtpv+mgeFBrwBPcfMQaiLdOQx8uU2+E9f6fSafNxkSipQYJfjnp5fH20a+
         XmZ+lCXIOHTd4Y+/PuOWp+f0DONjYY7l5O2eeT3B2UmsENnf2ohBJHbz3ReZOOV7OTtA
         ZQ8ix6SsLVkFDsi7brG+eABUHq8W3vEAnH7a/Ja/sX435b1IIVS1toJ/wBu5bSwiWqUk
         Jrom1cEK9TIaheIxZw8J1LwxZzeCmhKbmQ8XQ0wv8QjbSnXjVXwup0gE9wYOnarfCp6G
         ka8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uS00F9df3Z8T26CltpV3tuHM711DSQH+xwYM8pFxAPw=;
        b=AusAdE42iC+zeyHhloJmd2McWVyavBjnIVJqTRUwDTCWCYAlgcGEfbyYK7Uilws/Wr
         ICrjlbnI2XZ/XDxNKywsthGSFzv5C4Jr59PDB17K8UAvMoZ2m3/hKTOgTqbDFIXPdt8t
         dsCpBUs78vHkSPa8k/7uRwdx72c4eCkDQedrzyTL+QJb36CD/k9klrArSzHRimieIXU2
         wso8k9K6ijRSxgGAo5jxjFM182uZWyB9yC6iLbp9nXZchCtuEIuv91qkE3B/U7zo329A
         xoWYEbqeGHGj3kWKUyLM+Mjct3edNjzC3cyTVOJZY7Y6tZdt55Djygo3FignV9SFLM0l
         eF+w==
X-Gm-Message-State: APjAAAX/TfpEQEIn2jlE0Lg542H9gmGqr+H/xZHJJv4O2ahZlmXXoc2v
        2UDKg193voPdbooL8zOQ9Zs=
X-Google-Smtp-Source: APXvYqwcpV/tnbD0GvKb8+QQLoFm6W5RwS+JPggqwRsi2oXVsP1V9iSAVGcRl1JpCG+3hXcnD5Po2g==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr75540376wrq.280.1582639716888;
        Tue, 25 Feb 2020 06:08:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id d13sm25185614wrc.64.2020.02.25.06.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:36 -0800 (PST)
Subject: [PATCH v3 7/8] PCI: pci-bridge-emul: use PCI_STATUS_ERROR_BITS
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
Message-ID: <f9327217-4095-e26b-b7bd-4eb95ebd864d@gmail.com>
Date:   Tue, 25 Feb 2020 15:07:12 +0100
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

Use new constant PCI_STATUS_ERROR_BITS to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- fix typo
---
 drivers/pci/pci-bridge-emul.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index fffa77093..93d8e8910 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -50,12 +50,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 		       (PCI_STATUS_CAP_LIST | PCI_STATUS_66MHZ |
 			PCI_STATUS_FAST_BACK | PCI_STATUS_DEVSEL_MASK) << 16),
 		.rsvd = GENMASK(15, 10) | ((BIT(6) | GENMASK(3, 0)) << 16),
-		.w1c = (PCI_STATUS_PARITY |
-			PCI_STATUS_SIG_TARGET_ABORT |
-			PCI_STATUS_REC_TARGET_ABORT |
-			PCI_STATUS_REC_MASTER_ABORT |
-			PCI_STATUS_SIG_SYSTEM_ERROR |
-			PCI_STATUS_DETECTED_PARITY) << 16,
+		.w1c = PCI_STATUS_ERROR_BITS << 16,
 	},
 	[PCI_CLASS_REVISION / 4] = { .ro = ~0 },
 
@@ -100,12 +95,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 			 PCI_STATUS_DEVSEL_MASK) << 16) |
 		       GENMASK(11, 8) | GENMASK(3, 0)),
 
-		.w1c = (PCI_STATUS_PARITY |
-			PCI_STATUS_SIG_TARGET_ABORT |
-			PCI_STATUS_REC_TARGET_ABORT |
-			PCI_STATUS_REC_MASTER_ABORT |
-			PCI_STATUS_SIG_SYSTEM_ERROR |
-			PCI_STATUS_DETECTED_PARITY) << 16,
+		.w1c = PCI_STATUS_ERROR_BITS << 16,
 
 		.rsvd = ((BIT(6) | GENMASK(4, 0)) << 16),
 	},
-- 
2.25.1




