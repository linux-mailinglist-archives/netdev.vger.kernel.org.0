Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7951C5D5C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgEEQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:21:37 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45014 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgEEQVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:21:37 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045GLVnj022356;
        Tue, 5 May 2020 11:21:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588695691;
        bh=OxUyjvjTpC4dkBUPPz1IUnY359iQO02H2M1zKF1GPlc=;
        h=From:To:CC:Subject:Date;
        b=RbzphmRfOpEU1RoFFZjjFWb0wr6p1BzWmY3ZnlTL9AQT3O0gTHH4Xr7copS1vrCeu
         quUAd71JiKxoQTk9o7HDQCbCu23xb3OXLWrUD/oKWp9QR67+RhJs8pFR7i65K7kC2o
         kvWBkrD5XX8CX4PH3nwZwUs5DEhf9Z/GMfYGnUAk=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 045GLV6Y087775
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 May 2020 11:21:31 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 11:21:31 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 11:21:31 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045GLUkF026653;
        Tue, 5 May 2020 11:21:30 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Anders Roxell <anders.roxell@linaro.org>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpts: fix build
Date:   Tue, 5 May 2020 19:21:23 +0300
Message-ID: <20200505162123.13366-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible to have build configuration which will force PTP_1588_CLOCK=m
and so TI_K3_AM65_CPTS=m while still have TI_K3_AM65_CPSW_NUSS=y. This will
cause build failures:

aarch64-linux-gnu-ld: ../drivers/net/ethernet/ti/am65-cpsw-nuss.o: in function `am65_cpsw_init_cpts':
../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685: undefined reference to `am65_cpts_create'
aarch64-linux-gnu-ld: ../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:(.text+0x2e20):
relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `am65_cpts_create'

Fix it by adding dependencies from CPTS in TI_K3_AM65_CPSW_NUSS as below:
   config TI_K3_AM65_CPSW_NUSS
   ...
     depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS

Note. This will create below dependencies and for NFS boot + CPTS all of them
have to be built-in.
  PTP_1588_CLOCK -> TI_K3_AM65_CPTS -> TI_K3_AM65_CPSW_NUSS

While here, clean up TI_K3_AM65_CPTS definition.

Fixes: b1f66a5bee07 ("net: ethernet: ti: am65-cpsw-nuss: enable packet timestamping support")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/net/ethernet/ti/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 4ab35ce7b451..988e907e3322 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -99,7 +99,7 @@ config TI_K3_AM65_CPSW_NUSS
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
 	select TI_DAVINCI_MDIO
 	imply PHY_TI_GMII_SEL
-	imply TI_AM65_CPTS
+	depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS
 	help
 	  This driver supports TI K3 AM654/J721E CPSW2G Ethernet SubSystem.
 	  The two-port Gigabit Ethernet MAC (MCU_CPSW0) subsystem provides
@@ -112,9 +112,8 @@ config TI_K3_AM65_CPSW_NUSS
 
 config TI_K3_AM65_CPTS
 	tristate "TI K3 AM65x CPTS"
-	depends on ARCH_K3 && OF && PTP_1588_CLOCK
+	depends on ARCH_K3 && OF
 	depends on PTP_1588_CLOCK
-	select NET_PTP_CLASSIFY
 	help
 	  Say y here to support the TI K3 AM65x CPTS with 1588 features such as
 	  PTP hardware clock for each CPTS device and network packets
-- 
2.17.1

