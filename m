Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60DD113101
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfLDRpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:45:46 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47726 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfLDRpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:45:46 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4HjcK2127869;
        Wed, 4 Dec 2019 11:45:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575481538;
        bh=gxbZ2CIIPVbvS4ohqvpxPEVJEByegcE8HUnwN5BOVvA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=uOW/oMMPSTymicdBBIWztbG9y5JeVgV/1dthB+jNeSdh2tQAOAwwA+xYU5MjnuruW
         CfNvC3sKOMLu+r3hJLXoU3GmPNrs0O13KE7uOtD7/SHgrYRpjR0+CaSA1gSSfwoUiv
         +ra6sNIZ4pkDZcQ9r1Kd3BlUOAlxbjsL3QOP6LX0=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB4Hjcbo121173
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Dec 2019 11:45:38 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 11:45:38 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 11:45:37 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4Hjb55034557;
        Wed, 4 Dec 2019 11:45:37 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Randy Dunlap <rdunlap@infradead.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 1/2] net: ethernet: ti: cpsw_switchdev: fix unmet direct dependencies detected for NET_SWITCHDEV
Date:   Wed, 4 Dec 2019 19:45:32 +0200
Message-ID: <20191204174533.32207-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204174533.32207-1-grygorii.strashko@ti.com>
References: <20191204174533.32207-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace "select NET_SWITCHDEV" vs "depends on NET_SWITCHDEV" to fix Kconfig
warning with CONFIG_COMPILE_TEST=y

WARNING: unmet direct dependencies detected for NET_SWITCHDEV
  Depends on [n]: NET [=y] && INET [=n]
  Selected by [y]:
  - TI_CPSW_SWITCHDEV [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_TI [=y] && (ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST [=y])

because TI_CPSW_SWITCHDEV blindly selects NET_SWITCHDEV even though
INET is not set/enabled, while NET_SWITCHDEV depends on INET.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 9170572346b5..a46f4189fde3 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -62,7 +62,7 @@ config TI_CPSW
 config TI_CPSW_SWITCHDEV
 	tristate "TI CPSW Switch Support with switchdev"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
-	select NET_SWITCHDEV
+	depends on NET_SWITCHDEV
 	select TI_DAVINCI_MDIO
 	select MFD_SYSCON
 	select REGMAP
-- 
2.17.1

