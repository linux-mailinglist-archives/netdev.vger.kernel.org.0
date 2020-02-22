Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AE4168FFE
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 16:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgBVP6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 10:58:18 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53974 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgBVP6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 10:58:16 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01MFwEKN093937;
        Sat, 22 Feb 2020 09:58:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582387094;
        bh=I9VP0Qi6GVJYk0qeT0StJbkrG9a238W1Rw1wxcLPnEw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=tuPHEVcKbgQ3BW6AziNQx0rB9XxSDji3Jk0o6u3MfQHLZwHU5mB23F3UMkyQE5UZZ
         V8ZKQMe5w23HMaSrbYWfvK21jL/dswyNAbqRcNUz4CtO4WcEjLZnAqATlIxn2CWodX
         QqPDTseyTz9op5hJNSd3Uigy4ss9NIl3n3RjgvCA=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01MFwEdI045993
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 22 Feb 2020 09:58:14 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 22
 Feb 2020 09:58:13 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 22 Feb 2020 09:58:13 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01MFwC4W118354;
        Sat, 22 Feb 2020 09:58:13 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Roger Quadros <rogerq@ti.com>, Tero Kristo <t-kristo@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 3/9] net: ethernet: ti: ale: am65: add support for default thread cfg
Date:   Sat, 22 Feb 2020 17:57:46 +0200
Message-ID: <20200222155752.22021-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200222155752.22021-1-grygorii.strashko@ti.com>
References: <20200222155752.22021-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for default thread configuration for AM65x CPSW NUSS ALE to
allow route all ingress packets to one default RX UDMA flow.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 18 ++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_ale.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 719e7846127c..39acd8c64994 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -44,6 +44,8 @@
 #define ALE_UNKNOWNVLAN_FORCE_UNTAG_EGRESS	0x9C
 #define ALE_VLAN_MASK_MUX(reg)			(0xc0 + (0x4 * (reg)))
 
+#define AM65_CPSW_ALE_THREAD_DEF_REG 0x134
+
 #define ALE_TABLE_WRITE		BIT(31)
 
 #define ALE_TYPE_FREE			0
@@ -843,6 +845,22 @@ static struct ale_control_info ale_controls[ALE_NUM_CONTROLS] = {
 		.port_shift	= 0,
 		.bits		= 6,
 	},
+	[ALE_DEFAULT_THREAD_ID] = {
+		.name		= "default_thread_id",
+		.offset		= AM65_CPSW_ALE_THREAD_DEF_REG,
+		.port_offset	= 0,
+		.shift		= 0,
+		.port_shift	= 0,
+		.bits		= 6,
+	},
+	[ALE_DEFAULT_THREAD_ENABLE] = {
+		.name		= "default_thread_id",
+		.offset		= AM65_CPSW_ALE_THREAD_DEF_REG,
+		.port_offset	= 0,
+		.shift		= 15,
+		.port_shift	= 0,
+		.bits		= 1,
+	},
 };
 
 int cpsw_ale_control_set(struct cpsw_ale *ale, int port, int control,
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index eaca73c17ae7..6a3cb6898728 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -66,6 +66,8 @@ enum cpsw_ale_control {
 	ALE_PORT_MACONLY_CAF,
 	ALE_PORT_BCAST_LIMIT,
 	ALE_PORT_MCAST_LIMIT,
+	ALE_DEFAULT_THREAD_ID,
+	ALE_DEFAULT_THREAD_ENABLE,
 	ALE_NUM_CONTROLS,
 };
 
-- 
2.17.1

