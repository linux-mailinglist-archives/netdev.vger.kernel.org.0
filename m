Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4F720B7F8
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgFZSRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:17:31 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:48598 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgFZSRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:17:30 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHGIJ002416;
        Fri, 26 Jun 2020 13:17:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593195436;
        bh=CxrNJvy49UltKzg8PWt+ReX2BFl8riwjabZ60O6qQNg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=KaXcba3GnACSHVvbXmGnlTSVdCNENiwjlio+efHBflx2KXGAOfbztH5Xmn/AiuueR
         SVe5/1mkQ9P1nbOoGRqwiMfu4OKxhNxNJwFJk5mXMwhvFS0/q0zfQRdCMDuJaCd0+J
         cyUxXyTKvfmArkmYuwuirbTVSPL3Yew2e5pM9NLA=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05QIHGKO058715
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 13:17:16 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 13:17:15 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 13:17:15 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHFgQ122852;
        Fri, 26 Jun 2020 13:17:15 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 3/6] net: ethernet: ti: am65-cpsw-nuss: fix ports mac sl initialization
Date:   Fri, 26 Jun 2020 21:17:06 +0300
Message-ID: <20200626181709.22635-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626181709.22635-1-grygorii.strashko@ti.com>
References: <20200626181709.22635-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC SL has to be initialized for each port otherwise
am65_cpsw_nuss_slave_disable_unused() will crash for disabled ports.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Not critical as current driver supports one port only.

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 89ea29a26c3a..7a921a480f29 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1768,6 +1768,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				common->cpsw_base + AM65_CPSW_NU_FRAM_BASE +
 				(AM65_CPSW_NU_FRAM_PORT_OFFSET * (port_id - 1));
 
+		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
+		if (IS_ERR(port->slave.mac_sl))
+			return PTR_ERR(port->slave.mac_sl);
+
 		port->disabled = !of_device_is_available(port_np);
 		if (port->disabled)
 			continue;
@@ -1811,10 +1815,6 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			return ret;
 		}
 
-		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
-		if (IS_ERR(port->slave.mac_sl))
-			return PTR_ERR(port->slave.mac_sl);
-
 		mac_addr = of_get_mac_address(port_np);
 		if (!IS_ERR(mac_addr)) {
 			ether_addr_copy(port->slave.mac_addr, mac_addr);
-- 
2.17.1

