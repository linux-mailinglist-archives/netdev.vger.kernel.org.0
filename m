Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBCD6BF138
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjCQSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCQSzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:55:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DE21689B;
        Fri, 17 Mar 2023 11:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrQFb73nji7IMN+vQIgck/lzexEcBQyYtWvOzo7VQovdxns+aYzgFdaWrL6rFT3G8V/oL1PYxJadxRHnPf6AqEaKTq6WGmEQ6+2DdG3/Rm+RSHDcadyQeDc4z4a4f2mabYRWjJl/QpLcotfycfntP+erLZ+qCg5rcPV6GrAIzpzKbjQDgZ9ePP6ThBjwnhB14pbbWQkA2zqBdvVEzoR9JlWWc9EBQEKVTvdbT+xtpJ3iA910ZvQIQ6/C50luQvvSgrbwkwifCP04AzBvl6vDvv8J6ucVSG7nabB+1ZbI+JIPIr5rmyTZvRv5YXeHwJtP9pdiyLKgFOhy7LUjsfcr0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afirkYxq9We+wpvbVE/YgSrfNUSP5IDRkvzeyR2TCh8=;
 b=FD1L537UgvTeVxmOTpgCQ5f1GJ78RwNsx6ED8ERkLCSgxmHQ+p3kT0PxOt5WtgLo/ZTwTrcyfFNfcXIclFE24n46bcBWUVkPBNCJQdBoDHfclzjfMqYyt6ZOlpN1/O71km8RHF5h05BGGbe6CiZRYXsHk9/83FU6jht6yPjqwhHoC45SEKtAwUxrPSzCd3K0rAvOWHPHTa5ipj6hk/VqVp5R35FBLEoWOw7u4YyVodZPHwVNHNeMAR0E1rIw/Tla+9axXHsK0iLTNFZlr6Jg6ymAKoDpfMSlLll13KGLbwnNu3/uV3pAfFDEaTK5kFU/Urum2ZHSLOlF2Oz/glf3iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afirkYxq9We+wpvbVE/YgSrfNUSP5IDRkvzeyR2TCh8=;
 b=j21L1ROKZETjJSWdRClxv0FdXDm8VAuOxC8EQ1IEu5CBCmIiRJKIHCcyrPfIsfu6tIqFE5XcF7cjtaTksQ7CnAjURqLHvqCDQ2Q/OfX37xI7WeBurhEQvFBYBfCS97I4iJa4zj7Z/oblZgcY4gMLMxIkATHCy6AVL8ESPmCCImA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN0PR10MB5959.namprd10.prod.outlook.com
 (2603:10b6:208:3cd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 18:54:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:35 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 5/9] net: mscc: ocelot: expose serdes configuration function
Date:   Fri, 17 Mar 2023 11:54:11 -0700
Message-Id: <20230317185415.2000564-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MN0PR10MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c9bedf8-eb8f-4d17-e5b8-08db27190d44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NScfzaKpkD8MnKUGG8ObVZ3z5nhQ+19SybrFUnkrMIZ8+w/ZE6/+WSxd2vnwvq/Yvz4E1on6yIbp9LoZZeQgLh3wSY3KkBUofMj+44O6GKWIWS8Kjbgej6CInbn83zWV5J2WoUXnKWXD2jl0IigHMzE6afDLPeaCkCiIVieDx2EdvaQbDtT38vqcvwGmOj/+YkmWCnlM5rMy0Ab2kNsl4QSZr3P0uuCxnm9EcaxoDvf3GeqKvfeIxC/xnRHD8I/c+tdmFDvtvD4udIBULIQqc4KnMjjZjMnMifpoIejXl8/UmnHtL43ceyNB5mpA9awX9fjw2qm12kaCmbD5V1JVBBAaqnjg6d24KeygAGeOwXv9G93wRK+7P/V4kJsCE/oN9WjDOHPjdQ4wLUw3RdcpFuIFx3aHYSTYsnTW9SkjrOFaDBYqf7azCEQ7qB6cDLgOmdHm0i5iFz0cvN2y59NEUxcfabSvzrkEqWK+AivPT77UMwhNGsdpbAXTv+wb6IMMfWdarhkpDRewYbMpmy3VRllKOKAQEjZctEQwPM9WLlBVzXOZ+IN7uIlrVjS4Nc+YZh+e7HE8/s7OqF7SdmjsC+rb34fjJ7rzGpGtL2YNhHAl3bb8r/VGbpTgRDTaPv1bQLSHYFGL1aRFc+vMYR/4ZfXNQt9bNcJBb84jk/Q+TNnL/MC9lrVndadjrf5BSFVAf0cYT5O910ApEFsC7rhnow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(39830400003)(136003)(366004)(451199018)(8676002)(86362001)(5660300002)(44832011)(7416002)(478600001)(66946007)(66556008)(2616005)(52116002)(186003)(38350700002)(6486002)(6666004)(2906002)(6512007)(1076003)(6506007)(26005)(36756003)(66476007)(38100700002)(316002)(41300700001)(54906003)(8936002)(83380400001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+WYB3cAJxRxI+48ynucso5uUGtkQk0GHVFWyQrc1Lqo12mPs3yCiTUnWqm7?=
 =?us-ascii?Q?wA9pKYnbFJl1mw1axv8oJXRrsgqqaHLjC/FvfBzXPBNv+J+NRymYkE47jiFI?=
 =?us-ascii?Q?KVF+DW4HT8L68bnwQDfjlgTZDqr1CB3gG4It8tWyDC2Azj6swWR32H+vdQ2y?=
 =?us-ascii?Q?7Q5x7fz4x0/VbVKmPvVR9vqsQJ4sqeg9FlVZVDXanvfGbuGoOG9TDOQYASb0?=
 =?us-ascii?Q?VIwtsyKD5/3tYU1CLYl+JXXqbbJ+ItIU/7YwKW3WK4ecWibTwhUYVEkzMtt8?=
 =?us-ascii?Q?bR+X2ZR4k4H7LlFbTsm73j5XzIeeAZDh2I2fWvP9sXm/P5HwePeVcTXHq4Oy?=
 =?us-ascii?Q?t1m1bpBNwo9hFVcjPJjDgA4riUVzQav7m0y6Y0jnUoNEslXQ7pFitw9Wd1GP?=
 =?us-ascii?Q?R5kjGj8ZRGeJLtnNyM7h8/UkqeaKAptC3cmvV27N7gyrPqrtMXMlmNfIyUCW?=
 =?us-ascii?Q?YiOX+tjWZb5wnpBob4kiVUrdxdoNnJI7PAKQ+7YqG46bX+SNh61EJolT8H4/?=
 =?us-ascii?Q?Wg3va/7QjAmAZ6c9XqWBvd3a7pRmkuNXe95V4sRcPP2tWe5hpXQDfjn0sTMk?=
 =?us-ascii?Q?c3tplNSdjR/GczXYxbpNBrpuX+aJUDjq3xnnPEZRwdQU/S6xRQxjq2bIXYp/?=
 =?us-ascii?Q?LK9IyEGwCwMRF7RNYqj9nAE2Gz0piTwYKSyR1bjXYcveWRbHQoTX4tPcJo0a?=
 =?us-ascii?Q?jnxTURjpghial9jnY07cLhLg3o0OI17r2nrcqpyoBnxI5r2RROqLIM5K2jqu?=
 =?us-ascii?Q?e/odV+hMeMEqjjVBItaLZDSMTCg16fQ9T2eFxlHKNOXwLUoX2j9gK4ig9o5L?=
 =?us-ascii?Q?TGzGrEmnsgx9mgzZbJwHbIRC4MxFS40lnCJ9qV2oLm9XPRtzf+5Bp+BZHAKj?=
 =?us-ascii?Q?qr1BY8ZxHhR3Kvjdzkm6jCzgDam0wdBDOawNU8ZVAlixI7XzGeJStQ/monlt?=
 =?us-ascii?Q?UrH/lQRj4XIWG0eR5isevqYO13dVK7eQGCfigaEqJwdN+DoMKLl0ReOpUuOa?=
 =?us-ascii?Q?P3y9s454Z5wIRBy/j3rCvAd32N3Oe5k8MD3m9n7boZsFa35XLykWbjH6Hbmx?=
 =?us-ascii?Q?7JOIdcQ5bArcMe0nRvefnDXK9KfqwwCW7hyfRwnnCcB83cYZyIdoHOrMQW7M?=
 =?us-ascii?Q?BWYolJJQ1nDUKDPhjJdEj4CAVXi1E5Ki1MCUG3Ds+A3nTEp2ZIUhlzW11yP+?=
 =?us-ascii?Q?VSayFAq9L8UTqCwO3ncqASeG/rYR/u+1Naaxp3LH1SXTji4m3XjsIp5n3p/b?=
 =?us-ascii?Q?D1IyrtC8vNv8vkYRvnjStSTjjPdVNpHC7gV2niTqyHuZqsAuDd898BNtTMlv?=
 =?us-ascii?Q?5FO+TLiNKa3bo5qtWf+vcvvCAQFXZo7kPWWrvnNJL2jEEWoyOCeSDW+DuQlK?=
 =?us-ascii?Q?fV4YiPlrVo9zmFR0xW/zlr4xnS7xXK8dglc2QH3giCKPTvWltp0jrnXSez5I?=
 =?us-ascii?Q?3NgiOOI1VI3PGPjnTa052a7q3G5rYl3ppkX3am0CCjIHP8PAolhIfUgf3qR/?=
 =?us-ascii?Q?99W6qjXACaYaDDETcUU8P2xX+fBizLDh0qHPCKGFUjfZ36CWhK2BXQeq49uH?=
 =?us-ascii?Q?cKnVYlWJtto1oVf+TfcCvyMEc4y3pQg3jDCq+61zqIT8xdG/QMgEp5ttxez7?=
 =?us-ascii?Q?ZNydDIbFKfDc6nCCz6k8sdU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9bedf8-eb8f-4d17-e5b8-08db27190d44
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:35.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3SiKB1XFAX9tMwkTPhlL28oNOLrT/XVwQyU29S6oHYMALgVlSMEKtRSSJ/EK8X/fEzpvaem0DhlfZ/LI6q4LV1f4vJp7CL+JEdGOyoYd5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5959
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During chip initialization, ports that use SGMII / QSGMII to interface to
external phys need to be configured on the VSC7513 and VSC7514. Expose this
configuration routine, so it can be used by DSA drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch

---
 drivers/net/ethernet/mscc/ocelot.c     | 40 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c | 29 ++-----------------
 include/soc/mscc/ocelot.h              |  4 +++
 3 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8292e93a3782..1502bb2c8ea7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -7,6 +7,7 @@
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <linux/iopoll.h>
+#include <linux/phy/phy.h>
 #include <soc/mscc/ocelot_hsio.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
@@ -809,6 +810,45 @@ static int ocelot_port_flush(struct ocelot *ocelot, int port)
 	return err;
 }
 
+int ocelot_port_configure_serdes(struct ocelot *ocelot, int port,
+				 struct device_node *portnp)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct device *dev = ocelot->dev;
+	int err;
+
+	/* Ensure clock signals and speed are set on all QSGMII links */
+	if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_QSGMII)
+		ocelot_port_rmwl(ocelot_port, 0,
+				 DEV_CLOCK_CFG_MAC_TX_RST |
+				 DEV_CLOCK_CFG_MAC_RX_RST,
+				 DEV_CLOCK_CFG);
+
+	if (ocelot_port->phy_mode != PHY_INTERFACE_MODE_INTERNAL) {
+		struct phy *serdes = of_phy_get(portnp, NULL);
+
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			dev_err_probe(dev, err,
+				      "missing SerDes phys for port %d\n",
+				      port);
+			return err;
+		}
+
+		err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
+				       ocelot_port->phy_mode);
+		of_phy_put(serdes);
+		if (err) {
+			dev_err(dev, "Could not SerDes mode on port %d: %pe\n",
+				port, ERR_PTR(err));
+			return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_port_configure_serdes);
+
 void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
 			       unsigned int link_an_mode,
 			       const struct phylink_link_state *state)
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 590a2b2816ad..21a87a3fc556 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1742,34 +1742,11 @@ static int ocelot_port_phylink_create(struct ocelot *ocelot, int port,
 		return -EINVAL;
 	}
 
-	/* Ensure clock signals and speed are set on all QSGMII links */
-	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
-		ocelot_port_rmwl(ocelot_port, 0,
-				 DEV_CLOCK_CFG_MAC_TX_RST |
-				 DEV_CLOCK_CFG_MAC_RX_RST,
-				 DEV_CLOCK_CFG);
-
 	ocelot_port->phy_mode = phy_mode;
 
-	if (phy_mode != PHY_INTERFACE_MODE_INTERNAL) {
-		struct phy *serdes = of_phy_get(portnp, NULL);
-
-		if (IS_ERR(serdes)) {
-			err = PTR_ERR(serdes);
-			dev_err_probe(dev, err,
-				      "missing SerDes phys for port %d\n",
-				      port);
-			return err;
-		}
-
-		err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET, phy_mode);
-		of_phy_put(serdes);
-		if (err) {
-			dev_err(dev, "Could not SerDes mode on port %d: %pe\n",
-				port, ERR_PTR(err));
-			return err;
-		}
-	}
+	err = ocelot_port_configure_serdes(ocelot, port, portnp);
+	if (err)
+		return err;
 
 	priv = container_of(ocelot_port, struct ocelot_port_private, port);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 87ade87d3540..d757b5e26d26 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -644,6 +644,7 @@ enum ocelot_tag_prefix {
 };
 
 struct ocelot;
+struct device_node;
 
 struct ocelot_ops {
 	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
@@ -1111,6 +1112,9 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   enum devlink_sb_pool_type pool_type,
 				   u32 *p_cur, u32 *p_max);
 
+int ocelot_port_configure_serdes(struct ocelot *ocelot, int port,
+				 struct device_node *portnp);
+
 void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
 			       unsigned int link_an_mode,
 			       const struct phylink_link_state *state);
-- 
2.25.1

