Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440173F3FA3
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhHVOCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbhHVOCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:12 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06C1C06175F;
        Sun, 22 Aug 2021 07:01:30 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id f5so21903692wrm.13;
        Sun, 22 Aug 2021 07:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EnYMLu3bLS8APgjASOjSEYt7FoYkDIJwe7q4cBAmVQk=;
        b=GZXbBbPYnuCE2fsTYmDNLccrUeRTMHMo7shzujcxhlB/DcAvRlguC4lRCpvN7WrCyB
         G8DRc9jGaddclUaYSeI2CBxIQUaagOLmkh3s+Mcqv/B80cJzXEOgIVnYrhvTtjJQVJds
         Juuh6KQbNout+9uBUyJ9HTN4nmTQvjJneu19065xHdjJ1jczSWZPcrDRbNQkOdtXol/l
         u3wxICK9d44apLzS0y2li4OXSPk/+bIDH3LYUzYAkKuXch/NA30+89vvX2H5YSJ8aOeY
         FArbGDDzZlbxGpOK9ujndJ6shhpYQ7YZW9MkFHR0dL9nbBkWBhvsVFDpJnk+HkVqaVd3
         rgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EnYMLu3bLS8APgjASOjSEYt7FoYkDIJwe7q4cBAmVQk=;
        b=a0nAqluSVQNB4p2D7iWXCBlzZhGUtb+BWDYpo/P7jJGqTeKaUq4KOA5B9htZtIqMNR
         pMo4p9X1WSX9/uDEQJ4BHju+dzH0dlUUeg1D3w1NZkUYo6IDbMSTPpXkPSKK5cO1+W1X
         CNx2EEhmiPb0QDmLz2P0x4/Tqbah4js/sOWfF27aOFZqLWMAcsbKuMEsRGhg6/9j1m38
         M0Tjl+yV/4vOmQFY2UMsLMxk9wcvvHQPENSG4TOYtg6+J4WQ9Sp50HMIX7QVLVk3Xe43
         BrJEtL+Nkn51AWHRu5e6Uke2zjciGh7WSkKmdDoIMIFb0MpViToNx8iw7ethV4TVzK5k
         UZ9w==
X-Gm-Message-State: AOAM533zmPb2bcKPtM9xdcjp4jRoCqe2/Y8fge5fDshve834G/AOQEYE
        r1bBA+QsMWXk3awtLqeErZ0qq8nIhVQShg==
X-Google-Smtp-Source: ABdhPJyXJaWGFa8Bw5s6sjp12lxvolmrG8hLqT9uUaXw1nXDDt4X8qikLz9JOJarzGBm0c71HTDH6w==
X-Received: by 2002:a05:6000:22d:: with SMTP id l13mr8873114wrz.410.1629640889403;
        Sun, 22 Aug 2021 07:01:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id d4sm12264453wrz.35.2021.08.22.07.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:27 -0700 (PDT)
Subject: [PATCH 07/12] bnxt: Read VPD with pci_vpd_alloc()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <62522a24-f39a-2b35-1577-1fbb41695bed@gmail.com>
Date:   Sun, 22 Aug 2021 15:55:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use pci_vpd_alloc() to dynamically allocate a properly sized buffer and
read the full VPD data into it.

This simplifies the code, and we no longer have to make assumptions about
VPD size.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 893bdaf03..00a9b7126 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13171,22 +13171,17 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
 	return rc;
 }
 
-#define BNXT_VPD_LEN	512
 static void bnxt_vpd_read_info(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
 	int i, len, pos, ro_size, size;
-	ssize_t vpd_size;
+	unsigned int vpd_size;
 	u8 *vpd_data;
 
-	vpd_data = kmalloc(BNXT_VPD_LEN, GFP_KERNEL);
-	if (!vpd_data)
+	vpd_data = pci_vpd_alloc(pdev, &vpd_size);
+	if (IS_ERR(vpd_data)) {
+		pci_warn(pdev, "Unable to read VPD\n");
 		return;
-
-	vpd_size = pci_read_vpd(pdev, 0, BNXT_VPD_LEN, vpd_data);
-	if (vpd_size <= 0) {
-		netdev_err(bp->dev, "Unable to read VPD\n");
-		goto exit;
 	}
 
 	i = pci_vpd_find_tag(vpd_data, vpd_size, PCI_VPD_LRDT_RO_DATA);
-- 
2.33.0


