Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1225A44786
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404498AbfFMRAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:00:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44468 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbfFLX7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:59:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id x47so20501096qtk.11
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WZTIny3KoE3YeNP8BFKvNhJNvN4rp0SgvOPeYgw5PaA=;
        b=bn5AADe+piB0NGuUGh6DATCR6FfPMFIesLF1VbtqPfNDKz4a9+IxTnaGjnPPLHWAA/
         we12q0zCXfiadkreW8vxZ2NKFg5/mgyr/d1T3g28enWGP1ceYdNqSGiq2lHyRFp5giqx
         6QhifrVcRHuE7WInxwBckBPn1n8UUCO9nVtXm6ng9xI0+YmfJktDyvMyyIEoR+G4JckO
         iJE8/yKAY0eLacuSIvUrXqD1XC9LgrDyZVhBvCQtll1H9CPNR6mBOKF5LDL4Y+utW+HA
         DgC1AZieO1+gnl1Oy+1hzoRKXE4RPbt4PYDLxyLVQNtTxCm59ZhunHkTFhPIwnrgv4Fj
         mfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WZTIny3KoE3YeNP8BFKvNhJNvN4rp0SgvOPeYgw5PaA=;
        b=OfYsWlYHghWvqfVPnpzH3hqDBFH3YbEtUR0N/rj3kaNK5vudzPN4UQh7e6QFJQRRHZ
         C7TK0qIYUKCGVb02/645noGmA357gtYtkXms5UHLcd7RIesNJqZuWsvC6IMPbUtY6HXs
         YbHrbRDk+pUt0VW/kR2UGP0gqwWMW5lb5/qtfIaiPJBUi/TFYOTiszWMEoBV8vuOq6VW
         TZ16rtOUdLEqv7mS3taEx0RB+//gXSakFln+HPLf3hPlKKmYBRswtAUpcqm6D0ctgn3N
         ZFHOPgnuZJFttNc0tMMk3TTteu6rrObOQnyiZbPbibpxDFcK4j1bStWzeMlIXTRTF+rI
         KNxw==
X-Gm-Message-State: APjAAAXwRu+c6MYBAKlgN7DQZWPqbsxYC+92YdA0Mx3dNt65/MciqCU4
        rgYC+OrXUjcQBmXAKaG315ErRw==
X-Google-Smtp-Source: APXvYqzZnelmGrzxJPF24GeyHQQlr3GHcdiqnMjPB2PAF7fpSFpTycQJc4uy9PaDbUEiT7RAt+/N/A==
X-Received: by 2002:ac8:2af8:: with SMTP id c53mr28314640qta.387.1560383959375;
        Wed, 12 Jun 2019 16:59:19 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p4sm490891qkb.84.2019.06.12.16.59.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 16:59:18 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 2/2] nfp: print a warning when binding VFs to PF driver
Date:   Wed, 12 Jun 2019 16:59:03 -0700
Message-Id: <20190612235903.8954-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612235903.8954-1-jakub.kicinski@netronome.com>
References: <20190612235903.8954-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users sometimes mistakenly try to manually bind the PF driver
to the VFs, print a warning message in that case.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 948d1a4b4643..60e57f08de80 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -596,6 +596,10 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	struct nfp_pf *pf;
 	int err;
 
+	if (pdev->vendor == PCI_VENDOR_ID_NETRONOME &&
+	    pdev->device == PCI_DEVICE_ID_NETRONOME_NFP6000_VF)
+		dev_warn(&pdev->dev, "Binding NFP VF device to the NFP PF driver, the VF driver is called 'nfp_netvf'\n");
+
 	err = pci_enable_device(pdev);
 	if (err < 0)
 		return err;
-- 
2.21.0

