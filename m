Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D6817C8E2
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 00:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCFXrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 18:47:46 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43972 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgCFXrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 18:47:46 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 026NlhxW099811;
        Fri, 6 Mar 2020 17:47:43 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583538463;
        bh=Xzf0pl4I+GiIsTovME8OTFIU5DSaFYgw7dndhzZDk6Y=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=GBXMGsnfVMwwxWU6P9ARiOU9PRI7ziEkTR8/6e2E5EKNPrGsoZEgA86sF0mGk/OgP
         3bAjGnEh0N+IGVtD2FuYYHEHl30ObFT7meiWiBQGI0K/OK8Lphls0psEB8EnRc4hO0
         EdvOWIcdsQlzmvRhkzxKTElzEtsYvIE4frNgrVL0=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 026NlhRt018307
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Mar 2020 17:47:43 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Mar
 2020 17:47:43 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Mar 2020 17:47:43 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 026Nlg4n101236;
        Fri, 6 Mar 2020 17:47:42 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 2/9] net: ethernet: ti: ale: add support for mac-only mode
Date:   Sat, 7 Mar 2020 01:47:27 +0200
Message-ID: <20200306234734.15014-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306234734.15014-1-grygorii.strashko@ti.com>
References: <20200306234734.15014-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new CPSW ALE version, available on TI K3 AM654/J721E SoCs family,
allows to switch any external port to MAC only mode. When MAC only mode
enabled this port be treated like a MAC port for the host. All traffic
received is only sent to the host. The host must direct traffic to this
port as the lookup engine will not send traffic to the ports with the
p0_maconly bit set and the p0_no_learn also set. If p0_maconly bit is set
and the p0_no_learn is not set, the host can send non-directed packets that
can be sent to the destination of a MacOnly port. It is also possible that
The host can broadcast to all ports including MacOnly ports in this mode.

This patch add ALE supprt for MAC only mode.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 16 ++++++++++++++++
 drivers/net/ethernet/ti/cpsw_ale.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 5815225c000c..719e7846127c 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -779,6 +779,22 @@ static struct ale_control_info ale_controls[ALE_NUM_CONTROLS] = {
 		.port_shift	= 0,
 		.bits		= 1,
 	},
+	[ALE_PORT_MACONLY]	= {
+		.name		= "mac_only_port_mode",
+		.offset		= ALE_PORTCTL,
+		.port_offset	= 4,
+		.shift		= 11,
+		.port_shift	= 0,
+		.bits		= 1,
+	},
+	[ALE_PORT_MACONLY_CAF]	= {
+		.name		= "mac_only_port_caf",
+		.offset		= ALE_PORTCTL,
+		.port_offset	= 4,
+		.shift		= 13,
+		.port_shift	= 0,
+		.bits		= 1,
+	},
 	[ALE_PORT_MCAST_LIMIT]	= {
 		.name		= "mcast_limit",
 		.offset		= ALE_PORTCTL,
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 70d0955c2652..eaca73c17ae7 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -62,6 +62,8 @@ enum cpsw_ale_control {
 	ALE_PORT_UNKNOWN_MCAST_FLOOD,
 	ALE_PORT_UNKNOWN_REG_MCAST_FLOOD,
 	ALE_PORT_UNTAGGED_EGRESS,
+	ALE_PORT_MACONLY,
+	ALE_PORT_MACONLY_CAF,
 	ALE_PORT_BCAST_LIMIT,
 	ALE_PORT_MCAST_LIMIT,
 	ALE_NUM_CONTROLS,
-- 
2.17.1

