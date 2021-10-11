Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3C1428D8B
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbhJKNLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhJKNLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 09:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A1AC60C41;
        Mon, 11 Oct 2021 13:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633957752;
        bh=j3GhamgjQ817qBJDf5Z90iwe0/GLxeTS0a3GBkuadJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qrpC40pDBeBOSY8f/0iytQaUH61T/3+p8eWz7EP7tV0nEMNE84Ez4rVZNJTR0Sasi
         c2rga0hj/uMb1dEU1ajOmSwXJVKEHUZv1sSw6KNjBOI3N7Cx+rDZKNzMdUBO2Hl5sL
         /7rT6vgMLcAAYOCI5n7Isn8BarP9CH19e2wnvfrwVIIAM+pjkh7r61U0nCNRwZpD2K
         CD5HFXYwEC6+1bUjuPK9rtEodvgGKNLVzgDJerWrN1hskUC3CBoR6qd4pzsjxvbo7y
         4OsYg3w78imOtFPWBVCEUjbX8WC+OpDeIJIrPIboorP5AojyY768fRmOGzJjcrDRVl
         GadyMi0weliXQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, joe@perches.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tulip: fix setting device address from rom
Date:   Mon, 11 Oct 2021 06:09:09 -0700
Message-Id: <20211011130909.3867214-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I missed removing i from the array index when converting
from a loop to a direct copy.

Fixes: ca8793175564 ("ethernet: tulip: remove direct netdev->dev_addr writes")
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 2 +-
 drivers/net/ethernet/dec/tulip/dmfe.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 1e3c90c3c0ed..d51b3d24a0c8 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -1823,7 +1823,7 @@ static void de21041_get_srom_info(struct de_private *de)
 #endif
 
 	/* store MAC address */
-	eth_hw_addr_set(de->dev, &ee_data[i + sa_offset]);
+	eth_hw_addr_set(de->dev, &ee_data[sa_offset]);
 
 	/* get offset of controller 0 info leaf.  ignore 2nd byte. */
 	ofs = ee_data[SROMC0InfoLeaf];
diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index 6e64ff20a378..83f1727d1423 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -476,7 +476,7 @@ static int dmfe_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Set Node address */
-	eth_hw_addr_set(dev, &db->srom[20 + i]);
+	eth_hw_addr_set(dev, &db->srom[20]);
 
 	err = register_netdev (dev);
 	if (err)
-- 
2.31.1

