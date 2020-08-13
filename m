Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2775B243BAF
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHMOjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:39:14 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:43718 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgHMOjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 10:39:14 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4BS8Mx079nzB09ZC;
        Thu, 13 Aug 2020 16:39:09 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id wl3HWTVpgapq; Thu, 13 Aug 2020 16:39:08 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4BS8Mw5d2Rz9vD3t;
        Thu, 13 Aug 2020 16:39:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7148A8B7A4;
        Thu, 13 Aug 2020 16:39:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id hlroaEI3dq4H; Thu, 13 Aug 2020 16:39:10 +0200 (CEST)
Received: from po17688vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.230.104])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3E8EB8B7A1;
        Thu, 13 Aug 2020 16:39:10 +0200 (CEST)
Received: by po17688vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 36A1C65C8D; Thu, 13 Aug 2020 14:39:10 +0000 (UTC)
Message-Id: <44e26ec6a1bc01b5b138c29b623c83d5846718b2.1597329390.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH] sfc_ef100: Fix build failure on powerpc
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Date:   Thu, 13 Aug 2020 14:39:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ppc6xx_defconfig fails building sfc.ko module, complaining
about the lack of _umoddi3 symbol.

This is due to the following test

 		if (EFX_MIN_DMAQ_SIZE % reader->value) {

Because reader->value is u64.

As EFX_MIN_DMAQ_SIZE value is 512, reader->value is obviously small
enough for an u32 calculation, so cast it as (u32) for the test, to
avoid the need for _umoddi3.

Fixes: adcfc3482fff ("sfc_ef100: read Design Parameters at probe time")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 36598d0542ed..234400b69b07 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -979,7 +979,7 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		 * EFX_MIN_DMAQ_SIZE is divisible by GRANULARITY.
 		 * This is very unlikely to fail.
 		 */
-		if (EFX_MIN_DMAQ_SIZE % reader->value) {
+		if (EFX_MIN_DMAQ_SIZE % (u32)reader->value) {
 			netif_err(efx, probe, efx->net_dev,
 				  "%s size granularity is %llu, can't guarantee safety\n",
 				  reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
-- 
2.25.0

