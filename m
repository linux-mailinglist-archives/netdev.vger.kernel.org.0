Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A5515BBF
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfEGF5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbfEGFhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:37:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B12205ED;
        Tue,  7 May 2019 05:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207462;
        bh=dFbAUPTxZV6FtJ6O1Xc6VM+HTS3OQjDCaQseBTiXcos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLKDKzfb4I0tc8CPKb4L1KsAoeJ35rGMjS3JK6cgIRAdVbCK7a6bEkfogghyz6G2d
         BBn4RhJB+LBCFjkhpYvqA7Njf90+dvYzKW2tg+82e3ygnHtvTzFSLcaELhhkx0hQMl
         2I+r2QOq8bS8o7kg2kuuhfbC5O/QR5qFnv4vg6v0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Gomez <dagmcr@gmail.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 56/81] spi: Micrel eth switch: declare missing of table
Date:   Tue,  7 May 2019 01:35:27 -0400
Message-Id: <20190507053554.30848-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Gomez <dagmcr@gmail.com>

[ Upstream commit 2f23a2a768bee7ad2ff1e9527c3f7e279e794a46 ]

Add missing <of_device_id> table for SPI driver relying on SPI
device match since compatible is in a DT binding or in a DTS.

Before this patch:
modinfo drivers/net/phy/spi_ks8995.ko | grep alias
alias:          spi:ksz8795
alias:          spi:ksz8864
alias:          spi:ks8995

After this patch:
modinfo drivers/net/phy/spi_ks8995.ko | grep alias
alias:          spi:ksz8795
alias:          spi:ksz8864
alias:          spi:ks8995
alias:          of:N*T*Cmicrel,ksz8795C*
alias:          of:N*T*Cmicrel,ksz8795
alias:          of:N*T*Cmicrel,ksz8864C*
alias:          of:N*T*Cmicrel,ksz8864
alias:          of:N*T*Cmicrel,ks8995C*
alias:          of:N*T*Cmicrel,ks8995

Reported-by: Javier Martinez Canillas <javier@dowhile0.org>
Signed-off-by: Daniel Gomez <dagmcr@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/spi_ks8995.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
index f17b3441779b..d8ea4147dfe7 100644
--- a/drivers/net/phy/spi_ks8995.c
+++ b/drivers/net/phy/spi_ks8995.c
@@ -162,6 +162,14 @@ static const struct spi_device_id ks8995_id[] = {
 };
 MODULE_DEVICE_TABLE(spi, ks8995_id);
 
+static const struct of_device_id ks8895_spi_of_match[] = {
+        { .compatible = "micrel,ks8995" },
+        { .compatible = "micrel,ksz8864" },
+        { .compatible = "micrel,ksz8795" },
+        { },
+ };
+MODULE_DEVICE_TABLE(of, ks8895_spi_of_match);
+
 static inline u8 get_chip_id(u8 val)
 {
 	return (val >> ID1_CHIPID_S) & ID1_CHIPID_M;
@@ -529,6 +537,7 @@ static int ks8995_remove(struct spi_device *spi)
 static struct spi_driver ks8995_driver = {
 	.driver = {
 		.name	    = "spi-ks8995",
+		.of_match_table = of_match_ptr(ks8895_spi_of_match),
 	},
 	.probe	  = ks8995_probe,
 	.remove	  = ks8995_remove,
-- 
2.20.1

