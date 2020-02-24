Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29CF16B264
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgBXVaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:30:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36361 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgBXV3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:29:52 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so12188687wru.3;
        Mon, 24 Feb 2020 13:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zpCq4CEFKSBkbpCeszKlhtkuryYcBaKsjTcQjlXd8Gw=;
        b=ZA4j743yWR4iZIHk2ux0rTSsGdauVbc0HDJ2lwZfhWdngWk9bomgb193cZyLEfuXnS
         wM92i//o8O0wNLPodEkdiRVOFofkpNtinwavzbcvQhwVRJx+SpfRSgYQ2+vxAqIAcom1
         LhNASPsse0uI5VEuuTWpjgWTHSZpPkBs7qWZGDrhciaOT/gaLG66azJOJnrf9Ap2Zn9+
         FouVaKG+aTTf6arCXv4qgzzbAXXnawyuXAzbAmCpU5tLbbXKBgfOCMbTXKu4fepbriLq
         Nb7RagiNwz8XMdluGQJbFH7Lmz7hyXpoeFZ5m7jeTEVLlvAZ2eeDaeYTLiN+/QAvaR6X
         7RCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zpCq4CEFKSBkbpCeszKlhtkuryYcBaKsjTcQjlXd8Gw=;
        b=AmbaiPbERYSRQkJVYSeMvy1R4fFbs5Ob/br2yvT2gJONnayvMPp2xeVE+DWvY+s6M8
         G/++ADLaLy0FBtUqZAU5OnfGELXo19hGbUTCGiNrrvuAZUZRsrTb9pLvAu8AFv/Tczw0
         e3E+yQeWUAjBjj6yS/xd1erWubQQlnAvx12WqG3KncLnck5MxpEthOarBGOBDnhWrDYt
         1qhuwvA373686iSvdLAmuwnT6hISks2ljhVcRjzM49GZOkNCEe+cPLPmIpnrpi7wNRJY
         Oxg4TWqkWqMCwxUdYBqNx0bnYqq8VEqUGFZWpJZkqjL6Aagyfbj3Ni1/C1kc1YNOsoaL
         njZg==
X-Gm-Message-State: APjAAAVtciPy5X1voPRNlCOPVa9hqFDl3zkd/7vVX05kDvlQXL59JPIx
        g2vnN1XzbDIPwQA1V4DCRF8=
X-Google-Smtp-Source: APXvYqz7qV3IX/HT3yUMsEGXJUCwRw5AeDpe1BNiKvRh+1y6ProPnkzUP4ghOeq5hQlyU4H2Bemh7w==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr66697348wru.422.1582579790513;
        Mon, 24 Feb 2020 13:29:50 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id t81sm1007367wmg.6.2020.02.24.13.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 13:29:50 -0800 (PST)
Subject: [PATCH 7/8] PCI: pci-bridge-emul: use PCI_STATUS_ERROR_BITS
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
Message-ID: <7b039d0c-3501-d9f7-d44b-11a984273c52@gmail.com>
Date:   Mon, 24 Feb 2020 22:28:04 +0100
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

Use new constant PCI_STATUS_ERROR_BITS to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
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
+		.w1c = PCI_STATUS_ERROR_BITS << 16;
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
+		.w1c = PCI_STATUS_ERROR_BITS << 16;
 
 		.rsvd = ((BIT(6) | GENMASK(4, 0)) << 16),
 	},
-- 
2.25.1


