Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC9F28CF7D
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgJMNtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:43 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:35766
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387942AbgJMNte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Di1jTQYF7cllTj99vS2gHuIacZtfXDZwd63g56RPVIjiqz3N7VyxboW+2oiwEWYsm5pe5O+x+bBVp9vFIdv746jE5iYKhnQ5/ZhJwH7d5lZUr97acGbfoewNSkjP3S6s8it3wwbeeQcLJST8rvpwzrTvqK9ccBZe62ztzmFfLV+UIfa9tWGNDGzrfgax//z53O2UuHKMgBZoYoFNnbOiRPQgkdH5V3IEafZ8ws3JeyrPUGxfFXvr7dDNNEMiaoZif9p7wMCZjTxJqAlhszcEcGVSxhLS30vwE10sNQb8XX6cuDmjHt1zGYcPBglXPJ3asjpZwvIXn+2vqeGJexvN8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZPbWd+BADewH2Rioj6eK+ZJZvmn8/WcMC9gAFV6JFw=;
 b=CUQejWiWEi3zByHBLcHlvkbPDkB/6NWEGff1ttIyWDLcVXBCjZ5mpEMI8plHrdjtlNzHQCTqaHltUeFuYbiQGpDgcPg3pLU7zndbF/5Ab1M+b8hQ/orcnAtjUM87g+k8NWVqfVTRJQNoLloosTThA1wF0OkLJiBclfm2DNWBGpBji1uJS9ehudu8/CoEb5fZy2dzJoVp4VS9M1eCuHFwuiylZbUPoWvSEKguVBz+4SXIXnRh3SL+MF0B1cRvwX1TaE0mot2o3QSAsUtJyhTaKIYM0nCEhZ7SXXYNlvBMYHxEZR99PICY/ya159LR/RbT/lPepvi4ShqRWHcD7YCl5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZPbWd+BADewH2Rioj6eK+ZJZvmn8/WcMC9gAFV6JFw=;
 b=C2yecvOLjoErzg/4CvPeCvxzBD9LPJBkDwaMwT/n+HfmQ8eNyV3+aATw8/pLnlj6pmAgqi3XjgZHIIataGPyDyxvRK9D3FUNmuvH10zGtEExTU9G0sImsEVC9jaQAsVWlGsCvHKhPCJido9C3Rei+QwriRkZr0gnJF+BJQ3HUio=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Tue, 13 Oct
 2020 13:49:18 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 06/10] net: mscc: ocelot: export NUM_TC constant from felix to common switch lib
Date:   Tue, 13 Oct 2020 16:48:45 +0300
Message-Id: <20201013134849.395986-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd751fe0-40d6-4014-9c6b-08d86f7ec785
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104A740B7BD5B4ED9AAF4D6E0040@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wstfvXPF09M5pO06MJhSMBdeJuDwF6k/FbSYHq37OmL/IhmmUWP1Ot05bYkE92TYOBhfCRzntoUOBhgnYoEFjtGB8hUrmzZ+8uxBelS1fGa0nUvyTplRjhijBOv9MADNY/zDFAsYZzqf8uePs2aAYeOEENuj2fF5NFpQgbnGTDHlm+d6mU2ogtS9zgqciSLSNGMMVvJ54EtKJ2CRV0bDLSZAmUhubUIeOcpnm8APceaCBn/0ppIF07x8YOg315FAVOUzVfMEc4Wbodwl2vmAx18C/xqX5HQNTI6DYE1zgxkvwhDovFjnPGT82rWDUJaGvfGzpXJtt/MVZJc0ZZLNuPYu/Ku3i4UtW+Xmysi9YswP2YqdkKqa8ADeKD9a6qmV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(478600001)(83380400001)(6506007)(8936002)(69590400008)(6486002)(66556008)(66476007)(6666004)(66946007)(5660300002)(1076003)(316002)(4326008)(36756003)(956004)(8676002)(86362001)(2616005)(186003)(6916009)(16526019)(26005)(52116002)(44832011)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9VzXrXzWOrZPL9EakPzQEi0e/t4ldrsNevS/94FAm3LgR07DuXM8nr3XQaTJxb/+7NAHnHHQKNuK35bsfsU4IJrdBzl/BR854YJoQEgWmYuPbjeW9MJJQXRUsH8K00IBxoRXo5PDFSP2wdAoavmzFAHkke6Wlr5bLrwzz6lz7+7cvoSwgIHCn0cCiMhsz6r1fXLykXCHae1qZObch/gLUNJS2BJemLi48syS4i2XeiOM7PT+M3DGsE31dtWBKoslX4uOw+tyQjOo63XlDJFKQfXGmlweRlit1QrosY6nhTUgfrUK0k5oxhdQwPkV8yqgwbd+UGnKlupUEHLMfsX4S2XWPspQIBC5hwOlRkZcblTF80X2eKOz5qgFV0h4QVTy5Y0Pl9W5kTl1+/7k8zPP4isFckLo2kVQlB3ecTvgTSQXpWKxMu9EJLJQ3+8++qTFXq99Nyf288J8X5SdeHoCCO7yUIk+/nx1NDFkqw/eBoXuLELc0cTmHoxDA1TelFdN1t6LCk+q2BSDl4Djk7Gftb8DFoL/u6d2w1AzJKni6/XrqDbtLKVAqU3r31wKQPHpadvFWIzutm01RB9hCus2GI6m/A7UHolSG69ingxh2BGCvLuCJ5qgeu4ivEDYD/KwnrYKtfP1GSzWOX4ylGUulg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd751fe0-40d6-4014-9c6b-08d86f7ec785
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:18.0657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mI33jlEzmaeRm8g9vnHlv1wn6gWo6Vk+aEPc1XQ/cxqXnSDPZsta7D0LLN1ZiSiVdRTyd5gVEPYPvKg4Ksjgig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should be moving anything that isn't DSA-specific or SoC-specific out
of the felix DSA driver, and into the common mscc_ocelot switch library.

The number of traffic classes is one of the aspects that is common
between all ocelot switches, so it belongs in the library.

This patch also makes seville use 8 TX queues, and therefore enables
prioritization via the QOS_CLASS field in the NPI injection header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 include/soc/mscc/ocelot.h                | 1 +
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 89d99e0e387d..ed2e00af8baa 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -309,7 +309,7 @@ static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
 		       ANA_PORT_QOS_CFG,
 		       port);
 
-	for (i = 0; i < FELIX_NUM_TC * 2; i++) {
+	for (i = 0; i < OCELOT_NUM_TC * 2; i++) {
 		ocelot_rmw_ix(ocelot,
 			      (ANA_PORT_PCP_DEI_MAP_DP_PCP_DEI_VAL & i) |
 			      ANA_PORT_PCP_DEI_MAP_QOS_PCP_DEI_VAL(i),
@@ -608,7 +608,7 @@ static int felix_setup(struct dsa_switch *ds)
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_UC);
 	/* Setup the per-traffic class flooding PGIDs */
-	for (tc = 0; tc < FELIX_NUM_TC; tc++)
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++)
 		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
 				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
 				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 5434fe278d2c..994835cb9307 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -5,7 +5,6 @@
 #define _MSCC_FELIX_H
 
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
-#define FELIX_NUM_TC			8
 
 /* Platform-specific information */
 struct felix_info {
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index d4ef440d6340..2e82d68819bc 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1376,7 +1376,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.vcap			= vsc9959_vcap_props,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
-	.num_tx_queues		= FELIX_NUM_TC,
+	.num_tx_queues		= OCELOT_NUM_TC,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
 	.ptp_caps		= &vsc9959_ptp_caps,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b9890d18ad16..5c4000abb275 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1201,6 +1201,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap			= vsc9953_vcap_props,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
+	.num_tx_queues		= OCELOT_NUM_TC,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4f4390408925..c6153c73dbfe 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -98,6 +98,7 @@
 #define IFH_REW_OP_TWO_STEP_PTP		0x3
 #define IFH_REW_OP_ORIGIN_PTP		0x5
 
+#define OCELOT_NUM_TC			8
 #define OCELOT_TAG_LEN			16
 #define OCELOT_SHORT_PREFIX_LEN		4
 #define OCELOT_LONG_PREFIX_LEN		16
-- 
2.25.1

