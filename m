Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F22885989
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 06:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfHHE6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 00:58:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55006 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfHHE6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 00:58:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so988240wme.4;
        Wed, 07 Aug 2019 21:58:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q7D/8BznaDXMUKeNwuiimCqxMs4M4U8z2oe/6Zp1LH0=;
        b=QRz6meNnUgB1d68hz4Y0uHhl2sc9Lil/A6oHvm/LlDvt5vmfju0IUgGZVfQVVeXTOn
         YwOggKYCXh2e9wvVL2y1IJdlMbUtYmPOuzxMADhLNuC/D1gN0IQZDBKv563Nhx2TuwSH
         FKsNcGQVT+E8R0XTsx/TXjbYLJx4dZoS6wlSSHko92DnmlVJwFOCDJrkk8kA1mGq0gny
         t36kMtEoEZIBxtnXlsyv/yH0PBUn/mJdAymAldrZn3Je2zXp/Hp5fQVqhfk9infMIT0R
         T36ePaWFEco5ENVQlfRSACgnCiNvmbeCbxFUFQZoJDMPFqT5Ol8X6RlS/M9hOAy59Qnh
         HF+w==
X-Gm-Message-State: APjAAAUtHwGGjMGHrZ7mNiC9CDAiDy28FlfWP7gsOGpikMvB86Hz/iO8
        H0khtR0Up+3l4dUY887ptqU=
X-Google-Smtp-Source: APXvYqxouo6xkD/Ka8KpoCVDtmIK16o8FHZU0T4FDxQSAnEw7PlKO9Sge9gjs2gBwXn8UQ+e4dHxHA==
X-Received: by 2002:a1c:751a:: with SMTP id o26mr1727442wmc.13.1565240282122;
        Wed, 07 Aug 2019 21:58:02 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id 32sm87082644wrh.76.2019.08.07.21.58.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 21:58:01 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bjorn.helgaas@gmail.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] liquidio: Use pcie_flr() instead of reimplementing it
Date:   Thu,  8 Aug 2019 07:57:53 +0300
Message-Id: <20190808045753.5474-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

octeon_mbox_process_cmd() directly writes the PCI_EXP_DEVCTL_BCR_FLR
bit, which bypasses timing requirements imposed by the PCIe spec.
This patch fixes the function to use the pcie_flr() interface instead.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
index 021d99cd1665..614d07be7181 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
@@ -260,9 +260,7 @@ static int octeon_mbox_process_cmd(struct octeon_mbox *mbox,
 		dev_info(&oct->pci_dev->dev,
 			 "got a request for FLR from VF that owns DPI ring %u\n",
 			 mbox->q_no);
-		pcie_capability_set_word(
-			oct->sriov_info.dpiring_to_vfpcidev_lut[mbox->q_no],
-			PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
+		pcie_flr(oct->sriov_info.dpiring_to_vfpcidev_lut[mbox->q_no]);
 		break;
 
 	case OCTEON_PF_CHANGED_VF_MACADDR:
-- 
2.21.0

