Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305F7434F72
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhJTP6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230219AbhJTP6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AD466135E;
        Wed, 20 Oct 2021 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745386;
        bh=5JUbhxfhKImOKsPJ+9O5DfM2iko+4IoVYaUu6DevYak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcln9NNZd8T7eULAX59iLLDwDwnXTVRDBVyFWVNfRY5meAM7e5sr9z2jvjWSkznET
         yKqvAWsta7xs22uyQ//xZ40BU03PHHYB89cV/rOn6fD12Ee4sJSHEC35mGwfFtVP1O
         udm2FiNOz1iMzNbIDm50/VCwxCbofdEX2+dwVSbGdH7n9VBvwup51aB/hsdLa1zNut
         hYLD3S+4ZKIDLDCRQdicFUMUb0nK9Pt+h97Yq6AGXl2F/FCnWmDnsGraQ8Gq97D0tq
         hEHFAg/tTvisG7M29fcGDkTbZtRk/eUGho6w9cLRAs+6JS9/iPszDT2ldzBqeAUBuV
         KNEI39QW8POMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        macro@orcam.me.uk
Subject: [PATCH net-next 05/12] fddi: defxx,defza: use dev_addr_set()
Date:   Wed, 20 Oct 2021 08:56:10 -0700
Message-Id: <20211020155617.1721694-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: macro@orcam.me.uk
---
 drivers/net/fddi/defxx.c | 6 +++---
 drivers/net/fddi/defza.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index 5810e8473789..b584ffe38ad6 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -1117,7 +1117,7 @@ static int dfx_driver_init(struct net_device *dev, const char *print_name,
 	 *       dfx_ctl_set_mac_address.
 	 */
 
-	memcpy(dev->dev_addr, bp->factory_mac_addr, FDDI_K_ALEN);
+	dev_addr_set(dev, bp->factory_mac_addr);
 	if (dfx_bus_tc)
 		board_name = "DEFTA";
 	if (dfx_bus_eisa)
@@ -1474,7 +1474,7 @@ static int dfx_open(struct net_device *dev)
 	 *		 address.
 	 */
 
-	memcpy(dev->dev_addr, bp->factory_mac_addr, FDDI_K_ALEN);
+	dev_addr_set(dev, bp->factory_mac_addr);
 
 	/* Clear local unicast/multicast address tables and counts */
 
@@ -2379,7 +2379,7 @@ static int dfx_ctl_set_mac_address(struct net_device *dev, void *addr)
 
 	/* Copy unicast address to driver-maintained structs and update count */
 
-	memcpy(dev->dev_addr, p_sockaddr->sa_data, FDDI_K_ALEN);	/* update device struct */
+	dev_addr_set(dev, p_sockaddr->sa_data);				/* update device struct */
 	memcpy(&bp->uc_table[0], p_sockaddr->sa_data, FDDI_K_ALEN);	/* update driver struct */
 	bp->uc_count = 1;
 
diff --git a/drivers/net/fddi/defza.c b/drivers/net/fddi/defza.c
index 0de2c4552f5e..3a6b08eb5e1b 100644
--- a/drivers/net/fddi/defza.c
+++ b/drivers/net/fddi/defza.c
@@ -1380,7 +1380,7 @@ static int fza_probe(struct device *bdev)
 		goto err_out_irq;
 
 	fza_reads(&init->hw_addr, &hw_addr, sizeof(hw_addr));
-	memcpy(dev->dev_addr, &hw_addr, FDDI_K_ALEN);
+	dev_addr_set(dev, &hw_addr);
 
 	fza_reads(&init->rom_rev, &rom_rev, sizeof(rom_rev));
 	fza_reads(&init->fw_rev, &fw_rev, sizeof(fw_rev));
-- 
2.31.1

