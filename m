Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB71D4846BE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiADROq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:46 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234442AbiADROf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLkQMIrQmYV3FOPcEP9GijuESMCaeWIcsFWUq69nJUvkpzLNb6UAufLimnKBTQeAAnfuT5/9KRDPKo4OhlXfu2OB0TmzxzCZvPXpd0ZXAMC+Hy5dMqn8B/XbRQz13uduiL/tV7t6HywzgMtQFyIee1O4Q0B+q1Wtoy2qtAfWFlKoXLz0n8Vn+kg+5+wIIPZtQ5eBt7XOLWkuoUqO/ejVeigVLeeeS3dWExk30xRwC/8lgMf/NNQ6nBEba7EfILss1M0Q+RmxjBwbHvcLj5xCxgw4g1sK18HyuV8gtdFWawq/QySNvL2WSAnH18Gr4Sp35YXeiD6c3T/THDob1xSD3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCv1XAfSgWVWoG50wYbuhv4Ds/TH+NhgS4MWIH/kdig=;
 b=mDhsnI0WVUFBE4YQWEptj+zqHbgS/EoIZjCBaZqQutIZB0k/HsALolmlq72b6Q05aR85RJjFQA/b7S8L4LJmttXeC8vPyLPUqJkNY0GPFjhX7LyF4VZuxxftjKpjkSluTcA4wZfIE7TqGuEcUp2PHX3VHHnTW9twDeKyGJ9duXS2h4iqSTIytp+xJaH7W2L8hTGxygt7FC0G6/0AJ+Et31KjD6EoIKpjYhRsB6VTmB/dTsszeKGe4z6SX99jmmYWNAaoGp/FaTM3PttD7XBSBhV/UioCvONSk3Nbfe73Yd5pJ/omU3+r5X/cedas1nfgfbFbnqesxfTXxwQRsB9kXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCv1XAfSgWVWoG50wYbuhv4Ds/TH+NhgS4MWIH/kdig=;
 b=d7vbEfDuuffeEn62txLdktvB87IUWvMRG3zcm1GRidGlK7XTnbz9+3iOEiEt72nfl4siifXQRFcaeKygAIAo7bWVtvZn+Dvq78mXTA6Crp9iwWJ9r58OCELsJQpMJywQvBhQ0N4cm5529cYfDmK1TOdt0TiL/JruR7Ywr/1BNi0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 01/15] net: dsa: reorder PHY initialization with MTU setup in slave.c
Date:   Tue,  4 Jan 2022 19:13:59 +0200
Message-Id: <20220104171413.2293847-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd4da096-b3dd-4acf-8aa7-08d9cfa5abf9
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB71044EA90E1786891E631B7AE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ftl3Y5P1dKQ3w8Ln1NbUNDR84hPfLC4vgEf711leVfITtz9r3IOMKtJ395AWbCYCNYhRQiiu6+4KALr8f3vMsuGa8+sNdcVAT+n5vjTF5qWbxNIVFcqDgY0KNb4UA5qkFVBG0n/vpeD37Lx25qdcvxbEXzBhq5cW8s/OIWyEyAU5+4nLm4r3BzJEjYlOGsylu7Wox9E0Xig/ZDmcyjebmcAknIcU2M3l26gqNZorYI7x9AtHZRRUhayk6kbn+tIF4U3v9UkXyhwRxL47sg3eWBNo9ny3v3KhjAZIacpYQAooF7UTAyLD2aJLglgAfmt4ByKwSC65L5gb8B+niejJ7yJB7TjdFFv5ShWqPpxU2DzFwq95HZJTRVL52fAtUxKTfnf/ua8kgrVuQthwr6cSbpQgLMbR53rNNSg+I0KVQikdprcW8SPA7bvFRN0YRuA5ywIc1hfNH1e1MqJmsqdhzgGKemLourhp5kMwHVlA0nOeB6Xk03pgrrfmPpdSJ9VAkwjJ0CnyE358BcLrzflX93DNsSv1U5THL2FApw5GY2bNLR0D6DKOdOMzyyBhBbVRfXLoS9yWJDgmbVh5rS7BI6/8MHhPrt5dabHkSusPYc1vNUm7nyUqCY6xneLAkLZQUqTi+P7t/3mxzr4oVpyzdkhsc12r12Oe+dB+2WHTgzXrHEaZqBwY3POZz88YtQFuWMTD/D3tDN5R3U3mms6mCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?reOlWG1b0k4gANdk1IDA+z7Cdw6xvvTQGKgQ9PTKXEbGDCFY1GDHLF1Ixcz6?=
 =?us-ascii?Q?pjn6fN55uXh8qjQTjcl9B9qveMI9LSsdMlQveR0p8Yymf+JH/X5Gzv1hjO+q?=
 =?us-ascii?Q?wiTbtwmTniwLbl/43jOIy8LD4ll+BLHKRFbug2TM1Ywt4sXClsHLNyrfzuy2?=
 =?us-ascii?Q?PwUBqXDybsAeukgwthk8hGwDj+a2PnLTtMhXoH3oL5nfqgFf58IgWpqh/v0R?=
 =?us-ascii?Q?62Vtb6KAdzrPwpQiPkW6fTQdacmRH/26iyj3syCFzlg0zobUwlF0CtzGp25V?=
 =?us-ascii?Q?r3m7R6lUdFV0pVidPxoxrBrbQ+RhcUfVRDLFdL64+Z1WXNjUlmJ31y56Uq/Z?=
 =?us-ascii?Q?b/ZWfuw6ghu6XuE/VOO16Q7FVzNaTnItBMKXkn5psN/VxiiQOb+KDGVh5r8B?=
 =?us-ascii?Q?hRNiROsOSwc9zBJXwYn0uHCGM/QpmaRgeFkXinXrpI4j3PctEGJjNqv/EROF?=
 =?us-ascii?Q?BXF4o2CZGN59C+7eojwLTlPNuKnKvUpBKDRIQvNRfooTAfj+vIW2xldOxb+c?=
 =?us-ascii?Q?xaGC0lGl7KzbrHV+Sx8TWsUAUJv4eKprCZ8V/c0jUa8UJbxDwilchRd15ZAo?=
 =?us-ascii?Q?lvPvoYrQlsnmOwzo7VYdox5odU/O6OOMDAHzXYccC2nq2VF8T4w83D0Rbd5e?=
 =?us-ascii?Q?kZgjQxKaGMSw9Cyokf7m049Mo+L0DXILb9+L7IkPp8CLwtDJSaYO7Vzq3cV6?=
 =?us-ascii?Q?IX9om4fsVoFsVr1F3vjluJXhSdHprfX//GReJbZdeNKdRqfwzxq9NUb6glvN?=
 =?us-ascii?Q?DbXhSVlmRp30aJDdZ5HEHtgq+LnBX9geAkB1UMn191a+tbKTDubCOsQcjA98?=
 =?us-ascii?Q?mPWJkNn6uaOvtIExtZp6rIOSeNwRQ7DzD3h7t3lRsZNVRNrVjRf4z/hqL9MX?=
 =?us-ascii?Q?47FF1BvPa0xGyltM1kLuMgSPvh13SsLI+qqYXKhTl2MQKtPTGmFO5lG/IJC4?=
 =?us-ascii?Q?WsDTOobRCiDAt2h1+yJdTpHDZuUW1fJjflfSAUHmuCNflZV79ZyKkYyaTSb3?=
 =?us-ascii?Q?JcbV00I8q3MwIKhPohR10Kuat0XJLWYC2ssrTlRXke5sQZ/fndblplmGlOH+?=
 =?us-ascii?Q?+QorCJBXxDtF/1zi/fkHBbpXmLnXLgEk+2laj05zs5IP2Lo9sWp04pvAagml?=
 =?us-ascii?Q?/Ps4Rwoj+56p6Q/z6A/O2q7K+Rmj4Ar9GfpVyNPa4OKt9Bqf2jkiep63F8FT?=
 =?us-ascii?Q?YyQfjC2GVSqsRyWH3vkUuG2NjeW/SkPl6PrFCLzfPBXZJawrbxqlV9Yw68qy?=
 =?us-ascii?Q?5+5bqRXs4kYfTNPbt/yZlMNpQ/F7Z6p+Zt0+/otqCUe7oMlX6QaB7DE2bged?=
 =?us-ascii?Q?r8tW1iCmCvCUtdh76e+bD+SSPNitSrziXDfhB3Mrhg1RHbLi6+pvTyuhffcr?=
 =?us-ascii?Q?0EwkwVYSoI2LuddX49TrsbUggQVqfQdsAbOqBUIWO2oe+LLiJNkETN5HA9Oo?=
 =?us-ascii?Q?NWseCh4EWgfD4IREuOeVn1MIzyJWzu4XLIQ9xbiDfcaiBSOR78iNl3iVGuNg?=
 =?us-ascii?Q?qay2eMCU9bSVMtzKzSrrYHpGDA2D1wzFK8/nvUFUOsz8pqsvNOdRsXdpBTlK?=
 =?us-ascii?Q?rsfFwXePHq06xLGZuhdG+9U2wS8aWqfqPgM/xGdjRx/QxPtZrmAT/P+vQAf0?=
 =?us-ascii?Q?XNehZJK4ecPBwEHQbjfHURc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4da096-b3dd-4acf-8aa7-08d9cfa5abf9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:31.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B619K59ktTRyPIoXRmAXiV5R9JpJNRiAQ1pPWzFSDRaWPpBCfBJfCLcNIDEweP2YJFTKE88vvES8W73E802Y6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dsa_slave_create() there are 2 sections that take rtnl_lock():
MTU change and netdev registration. They are separated by PHY
initialization.

There isn't any strict ordering requirement except for the fact that
netdev registration should be last. Therefore, we can perform the MTU
change a bit later, after the PHY setup. A future change will then be
able to merge the two rtnl_lock sections into one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 88f7b8686dac..88bcdba92fa7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2011,13 +2011,6 @@ int dsa_slave_create(struct dsa_port *port)
 	port->slave = slave_dev;
 	dsa_slave_setup_tagger(slave_dev);
 
-	rtnl_lock();
-	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
-	rtnl_unlock();
-	if (ret && ret != -EOPNOTSUPP)
-		dev_warn(ds->dev, "nonfatal error %d setting MTU to %d on port %d\n",
-			 ret, ETH_DATA_LEN, port->index);
-
 	netif_carrier_off(slave_dev);
 
 	ret = dsa_slave_phy_setup(slave_dev);
@@ -2028,6 +2021,13 @@ int dsa_slave_create(struct dsa_port *port)
 		goto out_gcells;
 	}
 
+	rtnl_lock();
+	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
+	rtnl_unlock();
+	if (ret && ret != -EOPNOTSUPP)
+		dev_warn(ds->dev, "nonfatal error %d setting MTU to %d on port %d\n",
+			 ret, ETH_DATA_LEN, port->index);
+
 	rtnl_lock();
 
 	ret = register_netdevice(slave_dev);
-- 
2.25.1

