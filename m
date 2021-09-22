Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E6B414FE4
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhIVSc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233210AbhIVScz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC946127B;
        Wed, 22 Sep 2021 18:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632335484;
        bh=lHHzgiWaDLpQSO9ltbYMVLbwp7mW6qy1fxTQlS+3T2Q=;
        h=From:To:Cc:Subject:Date:From;
        b=bWkUwXULmi4uj8834FM7hhBuvItRzSOAIRrBPuITZRDNSNRtWxJLPK+PC/f5cajzg
         bqO0A91w5xeqyC+nN4U/zSD6fcVVlVff9pFyMTz+1nRNhbA12OL1Zfhyin+CIXnfpx
         5smiztHRCpee9eXN8XUrWATG6mBH/FlH8EX8WoFdFDhYYqdPp3LuXo7XTC0WrzUJ84
         BmoS3q3cwwRv32BHZqxd44cso0CYeCEWc1ZPNSPchg6ohCDtauNDDte4Kx9gNkAumY
         Qxvq2DhkJodyEkdZbP0QChQ1G7UvaYZsBBpHxvDehmZuTHp0B6woOBG/86OhUcHqC1
         J/Pow5J4B5mAQ==
From:   Mark Brown <broonie@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH] nfc: st-nci: Add SPI ID matching DT compatible
Date:   Wed, 22 Sep 2021 19:30:37 +0100
Message-Id: <20210922183037.11977-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=945; h=from:subject; bh=lHHzgiWaDLpQSO9ltbYMVLbwp7mW6qy1fxTQlS+3T2Q=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBhS3XgUsgbXAKWr0RmmEqN2i8+6GJAieLfpEXusIMz 5f3D6GuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYUt14AAKCRAk1otyXVSH0B9AB/ 9HZi3geac3R0sUIE+5Dm0Uf8k19DwJc87aO5KzppHBHvLR6nPxvghYOCXFoBe628eAVngfArFRI13F YG3hF2axXoJJYRuV8glAaNq3Zm/UG5bEcudF8KOkKgGmnruo6VIM4ar2pv7e4IooEx49GwvFXjupr0 HdNQX8kezDdjv7XkenhFOwFAWyAg8WRhx8Mxopta8EjXNIn5idrJYG9rlnovmtQ5dDmrBPjUnNfElB MxTK4FWNMSw370vp+ChLBI8eWe5G329WfvKv0bTNhILsunNOzcSbei2JyZ7YUpHztr/fcdJnJ94Cqu IL2r850Il0/UyyZTD5aYL/635d+5Ai
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding the part name used in
the compatible to the list of SPI IDs.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/nfc/st-nci/spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index a620c34790e6..0875b773fb41 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -278,6 +278,7 @@ static int st_nci_spi_remove(struct spi_device *dev)
 
 static struct spi_device_id st_nci_spi_id_table[] = {
 	{ST_NCI_SPI_DRIVER_NAME, 0},
+	{"st21nfcb-spi", 0},
 	{}
 };
 MODULE_DEVICE_TABLE(spi, st_nci_spi_id_table);
-- 
2.20.1

