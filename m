Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB87456AB5
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhKSHNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233428AbhKSHNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B984B61AF0;
        Fri, 19 Nov 2021 07:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305843;
        bh=AwoMy3iEsQvcvQehkOEmIpV0s695gfROOik8GwBb7ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHYbGDbSLutM+bvE79EBRrx/zZZkEhMhCYC1V56g1LeUPqGFECTEpI8Tncnj5lT2z
         w7LoFWhc6vwmkbNzMunGqjl/rXyF7ndaPsfRikkrcg4TNz2y5HebY2twEZnK+dhH+h
         MrsXU2RyCrfyXvquf7h4NCsxfAHo16THRW/Ik9KUEzRQj4SXceUEosgmiVSdRsH1vA
         IXlA+Fma18TLGerqZefdRcz2Ntl7MqQkQZ3wOrxkrJCSgq4qLhMh9WW968moYdIH0M
         c45LLCsvxO704iMY5TTc8HHUF1qsF8hM2GFfm4BuI+s3Mi5JfFSw+cnPGOCxLGdYWB
         8EMtopO04y2Vw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/15] smc9194: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:29 -0800
Message-Id: <20211119071033.3756560-12-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_addr is set from IO reads, and broken from a u16 value.

Fixes build on Alpha.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/smsc/smc9194.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index 0ce403fa5f1a..af661c65ffe2 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -856,6 +856,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 	word configuration_register;
 	word memory_info_register;
 	word memory_cfg_register;
+	u8 addr[ETH_ALEN];
 
 	/* Grab the region so that no one else tries to probe our ioports. */
 	if (!request_region(ioaddr, SMC_IO_EXTENT, DRV_NAME))
@@ -924,9 +925,10 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 		word	address;
 
 		address = inw( ioaddr + ADDR0 + i  );
-		dev->dev_addr[ i + 1] = address >> 8;
-		dev->dev_addr[ i ] = address & 0xFF;
+		addr[i + 1] = address >> 8;
+		addr[i] = address & 0xFF;
 	}
+	eth_hw_addr_set(dev, addr);
 
 	/* get the memory information */
 
-- 
2.31.1

