Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642B7456AAF
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKSHNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233337AbhKSHNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAEDE61B54;
        Fri, 19 Nov 2021 07:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305842;
        bh=6nxIfaGLof83WMub9SHq2uOOtSJ2hYOc8YaEnCl/+I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hg1fd33jkdRWyesAh14YLDhWIjZyN9eNaFnkWl3bnx6Z1xATAR9Hs4ivvFe2qenAg
         wTEnSeF3H+DjiT8OpDcF8SlMONBoHGkBPZDAsky+s0tphdkBEHIAVea0Ou31sW8/iz
         +8NYWDONGkqqCggJjTKxAsTshTs5s1189t4XD8BC+CVpmwby/oTFH/GBwmyGtoPLb1
         TAJyCsNEe1qeBH+kguG2EWN9XU5Vei6/AjOJHjX0lKkTq1lMaBwMrSLtqN8sXpzuRu
         J4IxCs7QVuMZ1SqqudK5WeRQcMnVXMS5Bzl3ZyFGoBPwX3flGRfwN/7twTetiB9onZ
         gzmjVPTtRAbhw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/15] amd: atarilance: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:23 -0800
Message-Id: <20211119071033.3756560-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/atarilance.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 9c7d9690d00c..27869164c6e6 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -471,6 +471,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 	int 					i;
 	static int 				did_version;
 	unsigned short			save1, save2;
+	u8 addr[ETH_ALEN];
 
 	PROBE_PRINT(( "Probing for Lance card at mem %#lx io %#lx\n",
 				  (long)memaddr, (long)ioaddr ));
@@ -585,14 +586,16 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 		eth_hw_addr_set(dev, OldRieblDefHwaddr);
 		break;
 	  case NEW_RIEBL:
-		lp->memcpy_f(dev->dev_addr, RIEBL_HWADDR_ADDR, ETH_ALEN);
+		lp->memcpy_f(addr, RIEBL_HWADDR_ADDR, ETH_ALEN);
+		eth_hw_addr_set(dev, addr);
 		break;
 	  case PAM_CARD:
 		i = IO->eeprom;
 		for( i = 0; i < 6; ++i )
-			dev->dev_addr[i] =
+			addr[i] =
 				((((unsigned short *)MEM)[i*2] & 0x0f) << 4) |
 				((((unsigned short *)MEM)[i*2+1] & 0x0f));
+		eth_hw_addr_set(dev, addr);
 		i = IO->mem;
 		break;
 	}
-- 
2.31.1

