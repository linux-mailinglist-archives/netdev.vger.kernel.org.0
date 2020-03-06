Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28BA17C8E5
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 00:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCFXry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 18:47:54 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:56988 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgCFXrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 18:47:53 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 026NlorX071120;
        Fri, 6 Mar 2020 17:47:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583538470;
        bh=I9VP0Qi6GVJYk0qeT0StJbkrG9a238W1Rw1wxcLPnEw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=bZynxjyYVXgsf4tgjBhicCWrveHNoL0tHhYv3OQhWLuz+jlspBqAnJeuZp2P7fSuf
         ZOG4zWzW18Ko8Va9j2u6168ypvbSIfG4CPiXVn/xjSeq9z2cRnzrCZXkW5MR6hu7X1
         BYTI63QT02g90pNP88aphV8BUxeh9y9SlCmPfpUs=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 026NloG2018390
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Mar 2020 17:47:50 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Mar
 2020 17:47:50 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Mar 2020 17:47:50 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 026Nlnqa027871;
        Fri, 6 Mar 2020 17:47:49 -0600
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
Subject: [PATCH net-next v2 3/9] net: ethernet: ti: ale: am65: add support for default thread cfg
Date:   Sat, 7 Mar 2020 01:47:28 +0200
Message-ID: <20200306234734.15014-4-grygorii.strashko@ti.com>
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

