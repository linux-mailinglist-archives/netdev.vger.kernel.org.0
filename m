Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DB541F702
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355587AbhJAVfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355642AbhJAVeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BABB61AF7;
        Fri,  1 Oct 2021 21:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123956;
        bh=7eSPmozrdY1hvz00w7UPDEpUJuVmaElmKsmh6pRlGis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTaY0ztLPqTYPW2GF+6YO0RbDI/RZV8R4ppbLEaaJvBa/TPv8w3/88AMpcTNzHwlb
         Z0npItWfnPf+OayIYzQ6XpjFCpj3jGL33NOXGioF1cluhMeojRRpzUoTuLfTkMEaY6
         B05XncIVmOBhb1ecRKdlAdAROmdPEE5HIwPtKX9PxquU5xlhjdcJRhosEfAuFimG1y
         XHSBe2RcYIZH4ODRo8MndlLdwqUXyA++TmPAtFb7FuaqyJPOoPus/vZEp71aGr+Zkl
         bbY3UhX0DledHIQAXOzelpBFg2/xXquxWg5vIi3AqfmlBD5Wr6V4VztuzniM2zN9pm
         98p16LJQleXAg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH net-next 10/11] fddi: use eth_hw_addr_set()
Date:   Fri,  1 Oct 2021 14:32:27 -0700
Message-Id: <20211001213228.1735079-11-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert from memcpy(), include is needed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: "Maciej W. Rozycki" <macro@orcam.me.uk>
---
 drivers/net/fddi/skfp/skfddi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index cc5126ea7ef5..652cb174302e 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -78,6 +78,7 @@ static const char * const boot_msg =
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/fddidevice.h>
 #include <linux/skbuff.h>
 #include <linux/bitops.h>
@@ -433,7 +434,7 @@ static  int skfp_driver_init(struct net_device *dev)
 	}
 	read_address(smc, NULL);
 	pr_debug("HW-Addr: %pMF\n", smc->hw.fddi_canon_addr.a);
-	memcpy(dev->dev_addr, smc->hw.fddi_canon_addr.a, ETH_ALEN);
+	eth_hw_addr_set(dev, smc->hw.fddi_canon_addr.a);
 
 	smt_reset_defaults(smc, 0);
 
@@ -500,7 +501,7 @@ static int skfp_open(struct net_device *dev)
 	 *               address.
 	 */
 	read_address(smc, NULL);
-	memcpy(dev->dev_addr, smc->hw.fddi_canon_addr.a, ETH_ALEN);
+	eth_hw_addr_set(dev, smc->hw.fddi_canon_addr.a);
 
 	init_smt(smc, NULL);
 	smt_online(smc, 1);
-- 
2.31.1

