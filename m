Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF1863C227
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiK2OOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbiK2ONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:37 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2045.outbound.protection.outlook.com [40.107.14.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEB059FF3;
        Tue, 29 Nov 2022 06:13:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOUwolairIQOh4CMSTCtb/oFKFpJeZMqtpVchdm1bheVB09ud/FGTlBCfoRwJ/C086kSnSeUKlfKzAslUM2c0cDtb2WXp9aOqY7iy8ZvbezBSBfzf0d/xEiSWktjLG9XmOBsTEWvKlfWiNlbnZlHpwkFHYcpnZcsnw3N5aEvYTY8RCM/xRkbZWz6i41gykUdWUSu0Tl/vqBYkO23ib1HsPAocSEePfxpnuyKlmtlK3i05D8RlRgU3llE5yImbfnxId9T7WU3JdOZrgp1b7LncUB02uutPdSk+fcByIZezHZBPg5qZiSBJWG6Jt0Wnse2NXxcXTEOObhueIebojyEqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRVZHG6LZC//yPukE+GrIF/6r139Ks9S++FsZwOF6ro=;
 b=No+LMriJMb9l07eRpAB4ZlWg61ju8GqFC63IOxmESfSc5moKvoagXSXAIBvv4XT0c5EzC9ZZBeJulRsK7s4GcKsjVe2wfgHYgbRaQD0+nPqXPayn3A3Huu87gLpe1XLuLv8H2rn2OImFWFtSaMUdBT43S9Gqs8gFXuCTQAfuSHspKvH5g8VmU1IdElHrVrUb8HTv0A9X7pEMFZEpZvAms8ew4yZKyEBCo8F0m55mLkTsWTD8VUluVcTC/iuclhVw0maKKkxz4qYjaQS7nOEdcdydMPUtNo6niHOb1oGaxo4e7CAuQfAsoPq2moNKSzeBusUkJvfZFWCbVciSQOI8RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRVZHG6LZC//yPukE+GrIF/6r139Ks9S++FsZwOF6ro=;
 b=GeDpJ4LcDOoayD2/0EAIq2q0qS/ujmg7t4BShgDH7SM3qNZAQ/jES0FjcV0ip2rAmSzGMcxzzVQh5pBNgC+XRE/fBOzr+JNuw43hh6YGttbhtKmw8sHHLJznqpSOwrf0bwuhLur4VAhdzUpE+wAOEvW+XobIeqDYarljlx64S2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/12] net: dpaa2-eth: serialize changes to priv->mac with a mutex
Date:   Tue, 29 Nov 2022 16:12:19 +0200
Message-Id: <20221129141221.872653-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 339ee98c-b4a4-4b71-1efe-08dad213c6c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNfmsdiB5eQ5xlm9DpBjFAW/WD5btZMfkg9kYdA+2zurfLAy2ne41KbYPV5XQI6lizy5HG6gj1KZ9fwKHV51i7vNQSNFTlbz5KtrKIF3YcfzQumzvn37IGkJKBLJICap2UNmOnLA6bzUbX/KCxHNYYSaN7rERb7P7W5nmrgDN6yieyeLgjC9tRvGnrVqKP39RdFaJ+2SSBGqMkoN0lOXQ4Mhgao+2N8NLybfH5bWXIp5+IspGRreuygfZAJbrujw9D7zjZ2zKyptqQ5rL5C16NROY9ns2Vfp8yvyz2H5XcVLSvNLKlQwXhZ7VwcPYGiuRenu6F4M4TeIkagxZiIWD0h20Q0xQ8LaHoI5K/Fe8S8VRLMsnwvmNQBbloPjFP4ZvpF2pfmGdPBUkXv2A5UqF4kb13iCtbpTk19uqD2RxmjAQVcVc8sWziYp8M7CjmD+hzsYIvj8NSgXsn8e2zYzjF3b/6dzvNbwc4wevZcJkuSviiuFpC7/DvK9og/70qBu3KD48U+T6JJnruSTc5jFBvohz6RvI3qpRfZTWVdZGpmoeUDDB3IKYz6eqolKZZqtnGAYFQeu07mXtzxkZ1Ti6f9mH6KisgPJRMmShcUcA7wMWoMaZq+bJqL7yh1MweNCQsYd+vljzSLI2ehiyel2VryDBTZUlOG9ooX62nWFRxRw94gsaNRHxTGtQdUysw68UKWRFpNMSjbOxVKsrNuN8SCsRZQchBYwS6UE/cyIEOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(30864003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qnC6lWnrEM/8Yp6VrdVh7oJ9y9JcwH5y/CQ+3aQWBnIDxzIpmgg2DjV4TdYj?=
 =?us-ascii?Q?vaK1XZ81lsGuZZJxmS74pFCctyU8lZ1N7Sl48Jvmg+B4QXYQlN9WEDYzuaCv?=
 =?us-ascii?Q?qZJBlGtO40UlasSiXE46w4KBJZk528TPHFsvciR4KNRnkiFBlQKH70n+EoLQ?=
 =?us-ascii?Q?W6nOClvwHMHCus+JNxD2SePLlTG11KPmX/Lm6EaomrrGFYGObUYOzZuIFBBj?=
 =?us-ascii?Q?0pXkdyFp0a2Q5mWhopMxy6Hdo1a3JgeGIbjMmPDfQoNBCUHLS+CsZqV1VD+3?=
 =?us-ascii?Q?++ETt6Dmf4W/DdQqniKmAVLHay8IWHHWvX1SBVtbcz6GCQ9tYfQUOQW2RzbT?=
 =?us-ascii?Q?7xMa6v9uWfKgw/JINJFIe15SQE2b5jSHXXBbDv/He2pQ4i3E1zGzsJUwI2tq?=
 =?us-ascii?Q?Er5r/xNTYyyRrlMYVgLH5vGjcKPkAAecXPFGKjKQMx7fbeITyKxtmZ36oi7n?=
 =?us-ascii?Q?xqaeQP4W25h4PuHfMywW38s76LsCAzcebzjIU81enS0OyXXMsDNLobfkx6f7?=
 =?us-ascii?Q?3DpYW0/wtEAbhHF5mWDshf53hEIPZa/OBBAv3juxAuuw9Z0GFOZc7G/NsKZk?=
 =?us-ascii?Q?4FEqrtV9E4zjwglhqwwtBQDxoAEuki2YtgWNSl5mqqn1B0zeBvj4VoeQjBbD?=
 =?us-ascii?Q?8n+aa+YujfwNTPjxdlsCTXp6EXPiP3cqQdFme/6botzX9Kk3C/NRy3HM5IGA?=
 =?us-ascii?Q?6xTVYxWvag5VfXsgxVS3LdmgQbokjV4m8vlI2+9F6xEvViRvHVbzoQ/gLXWj?=
 =?us-ascii?Q?JjH3I5GYk92ToGMvxesNEUB3k0RHw48THZA6Vg0nn13SjxRAqss7xQu3bLu2?=
 =?us-ascii?Q?OwClvoTPtouvybcMcMUX9x3uOw1KiX/EXWvQVui4vwguG3VO1JeNaCtQ0xfJ?=
 =?us-ascii?Q?N4lOWh/+nNymueudw3ZKm777QG/NxZDOxHoZ+Cl4XHiVe8ODdOvaCEU/yrti?=
 =?us-ascii?Q?Az4eJg2fAZT1I0tfzyQOYxruimyjPR4TxFdZ5BEH17tUirJ62cWwNC8IG0k7?=
 =?us-ascii?Q?SnjHU1eLFz3thFmMZdbW8yK5KjvZT86w5CVGYyyKC2fHA/XCEwRlf2qZyI8i?=
 =?us-ascii?Q?uMTNcbmt17cDO0RR8HQQ2p/FseSU76THjhuUPq0qS5Qlo7WV03RfSHiDJPJN?=
 =?us-ascii?Q?mTwyO4Um3oAsMK/YwnAlX2lhwyUMwpHtEOVGh/qJqvons+Piz72wqoI8GKmC?=
 =?us-ascii?Q?D7txyMSkJdR/RIDvR/+XJwjRitmKs/8Zr0Kb+auCSKYcwta9WcZ8ieNqlJB8?=
 =?us-ascii?Q?JBjUgnx6FWB7v7QGtU812Ka8CsUuy2x4eEKt/OPHifinTuv7lxKlzkRDDNhG?=
 =?us-ascii?Q?0SeFvL6mfvQ87oN9bMxAI2Qd6N/URPtsDZh2FFC7jPnHQ+diX3YaebnECxsI?=
 =?us-ascii?Q?W4kwh/Hoy9hT2Eh1nImw2eWRh5nYHLjv+0yblotsc7CDPzSy0qxt7aW58+6d?=
 =?us-ascii?Q?Z1rJFDxvfOR03gG8hZnf9NH4I/vdzdbj0mLtar5gxT97X9DkNMdJS3w7slyt?=
 =?us-ascii?Q?3Q+bndeZtvABCuBfWMgOKHC3HhmdKB3UBLFCBHCWLFDX6hlxNGrCe7bROxYI?=
 =?us-ascii?Q?N5ICb76wdX6u2j1Q2+ENcQBmB30GrVF58zteEl893XhcmEvX06SpnkusF4XL?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339ee98c-b4a4-4b71-1efe-08dad213c6c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:40.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYlnXBnwTMPRBzHmr24M/BbbNM3121iiFSW/CEul+YP2OYyOgzBY6YWp4fXQiA8+rycdSjKj3CWHJNqYELK5MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2 architecture permits dynamic connections between objects on
the fsl-mc bus, specifically between a DPNI object (represented by a
struct net_device) and a DPMAC object (represented by a struct phylink).

The DPNI driver is notified when those connections are created/broken
through the dpni_irq0_handler_thread() method. To ensure that ethtool
operations, as well as netdev up/down operations serialize with the
connection/disconnection of the DPNI with a DPMAC,
dpni_irq0_handler_thread() takes the rtnl_lock() to block those other
operations from taking place.

There is code called by dpaa2_mac_connect() which wants to acquire the
rtnl_mutex once again, see phylink_create() -> phylink_register_sfp() ->
sfp_bus_add_upstream() -> rtnl_lock(). So the strategy doesn't quite
work out, even though it's fairly simple.

Create a different strategy, where all code paths in the dpaa2-eth
driver access priv->mac only while they are holding priv->mac_lock.
The phylink instance is not created or connected to the PHY under the
priv->mac_lock, but only assigned to priv->mac then. This will eliminate
the reliance on the rtnl_mutex.

Add lockdep annotations and put comments where holding the lock is not
necessary, and priv->mac can be dereferenced freely.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 43 ++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  6 ++
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 58 +++++++++++++++----
 3 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b77d292cd960..3ed54c147e98 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2147,8 +2147,11 @@ static int dpaa2_eth_link_state_update(struct dpaa2_eth_priv *priv)
 
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
+	 * We can avoid locking because we are called from the "link changed"
+	 * IRQ handler, which is the same as the "endpoint changed" IRQ handler
+	 * (the writer to priv->mac), so we cannot race with it.
 	 */
-	if (dpaa2_eth_is_type_phy(priv))
+	if (dpaa2_mac_is_type_phy(priv->mac))
 		goto out;
 
 	/* Chech link state; speed / duplex changes are not treated yet */
@@ -2179,6 +2182,8 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 
 	dpaa2_eth_seed_pools(priv);
 
+	mutex_lock(&priv->mac_lock);
+
 	if (!dpaa2_eth_is_type_phy(priv)) {
 		/* We'll only start the txqs when the link is actually ready;
 		 * make sure we don't race against the link up notification,
@@ -2197,6 +2202,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 
 	err = dpni_enable(priv->mc_io, 0, priv->mc_token);
 	if (err < 0) {
+		mutex_unlock(&priv->mac_lock);
 		netdev_err(net_dev, "dpni_enable() failed\n");
 		goto enable_err;
 	}
@@ -2204,6 +2210,8 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 	if (dpaa2_eth_is_type_phy(priv))
 		dpaa2_mac_start(priv->mac);
 
+	mutex_unlock(&priv->mac_lock);
+
 	return 0;
 
 enable_err:
@@ -2275,6 +2283,8 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	int dpni_enabled = 0;
 	int retries = 10;
 
+	mutex_lock(&priv->mac_lock);
+
 	if (dpaa2_eth_is_type_phy(priv)) {
 		dpaa2_mac_stop(priv->mac);
 	} else {
@@ -2282,6 +2292,8 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 		netif_carrier_off(net_dev);
 	}
 
+	mutex_unlock(&priv->mac_lock);
+
 	/* On dpni_disable(), the MC firmware will:
 	 * - stop MAC Rx and wait for all Rx frames to be enqueued to software
 	 * - cut off WRIOP dequeues from egress FQs and wait until transmission
@@ -2607,12 +2619,20 @@ static int dpaa2_eth_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 static int dpaa2_eth_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	int err;
 
 	if (cmd == SIOCSHWTSTAMP)
 		return dpaa2_eth_ts_ioctl(dev, rq, cmd);
 
-	if (dpaa2_eth_is_type_phy(priv))
-		return phylink_mii_ioctl(priv->mac->phylink, rq, cmd);
+	mutex_lock(&priv->mac_lock);
+
+	if (dpaa2_eth_is_type_phy(priv)) {
+		err = phylink_mii_ioctl(priv->mac->phylink, rq, cmd);
+		mutex_unlock(&priv->mac_lock);
+		return err;
+	}
+
+	mutex_unlock(&priv->mac_lock);
 
 	return -EOPNOTSUPP;
 }
@@ -4639,7 +4659,9 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 		}
 	}
 
+	mutex_lock(&priv->mac_lock);
 	priv->mac = mac;
+	mutex_unlock(&priv->mac_lock);
 
 	return 0;
 
@@ -4652,9 +4674,12 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 {
-	struct dpaa2_mac *mac = priv->mac;
+	struct dpaa2_mac *mac;
 
+	mutex_lock(&priv->mac_lock);
+	mac = priv->mac;
 	priv->mac = NULL;
+	mutex_unlock(&priv->mac_lock);
 
 	if (!mac)
 		return;
@@ -4673,6 +4698,7 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 	struct fsl_mc_device *dpni_dev = to_fsl_mc_device(dev);
 	struct net_device *net_dev = dev_get_drvdata(dev);
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	bool had_mac;
 	int err;
 
 	err = dpni_get_irq_status(dpni_dev->mc_io, 0, dpni_dev->mc_handle,
@@ -4690,7 +4716,12 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 		dpaa2_eth_update_tx_fqids(priv);
 
 		rtnl_lock();
-		if (dpaa2_eth_has_mac(priv))
+		/* We can avoid locking because the "endpoint changed" IRQ
+		 * handler is the only one who changes priv->mac at runtime,
+		 * so we are not racing with anyone.
+		 */
+		had_mac = !!priv->mac;
+		if (had_mac)
 			dpaa2_eth_disconnect_mac(priv);
 		else
 			dpaa2_eth_connect_mac(priv);
@@ -4792,6 +4823,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	priv->net_dev = net_dev;
 	SET_NETDEV_DEVLINK_PORT(net_dev, &priv->devlink_port);
 
+	mutex_init(&priv->mac_lock);
+
 	priv->iommu_domain = iommu_get_domain_for_dev(dev);
 
 	priv->tx_tstamp_type = HWTSTAMP_TX_OFF;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 04270ae44d84..d56d7a13262e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -615,6 +615,8 @@ struct dpaa2_eth_priv {
 #endif
 
 	struct dpaa2_mac *mac;
+	/* Serializes changes to priv->mac */
+	struct mutex		mac_lock;
 	struct workqueue_struct	*dpaa2_ptp_wq;
 	struct work_struct	tx_onestep_tstamp;
 	struct sk_buff_head	tx_skbs;
@@ -768,11 +770,15 @@ static inline unsigned int dpaa2_eth_rx_head_room(struct dpaa2_eth_priv *priv)
 
 static inline bool dpaa2_eth_is_type_phy(struct dpaa2_eth_priv *priv)
 {
+	lockdep_assert_held(&priv->mac_lock);
+
 	return dpaa2_mac_is_type_phy(priv->mac);
 }
 
 static inline bool dpaa2_eth_has_mac(struct dpaa2_eth_priv *priv)
 {
+	lockdep_assert_held(&priv->mac_lock);
+
 	return priv->mac ? true : false;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index bd87aa9ef686..e80e9388c71f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -85,11 +85,16 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 static int dpaa2_eth_nway_reset(struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int err = -EOPNOTSUPP;
+
+	mutex_lock(&priv->mac_lock);
 
 	if (dpaa2_eth_is_type_phy(priv))
-		return phylink_ethtool_nway_reset(priv->mac->phylink);
+		err = phylink_ethtool_nway_reset(priv->mac->phylink);
+
+	mutex_unlock(&priv->mac_lock);
 
-	return -EOPNOTSUPP;
+	return err;
 }
 
 static int
@@ -97,10 +102,18 @@ dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 			     struct ethtool_link_ksettings *link_settings)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int err;
 
-	if (dpaa2_eth_is_type_phy(priv))
-		return phylink_ethtool_ksettings_get(priv->mac->phylink,
-						     link_settings);
+	mutex_lock(&priv->mac_lock);
+
+	if (dpaa2_eth_is_type_phy(priv)) {
+		err = phylink_ethtool_ksettings_get(priv->mac->phylink,
+						    link_settings);
+		mutex_unlock(&priv->mac_lock);
+		return err;
+	}
+
+	mutex_unlock(&priv->mac_lock);
 
 	link_settings->base.autoneg = AUTONEG_DISABLE;
 	if (!(priv->link_state.options & DPNI_LINK_OPT_HALF_DUPLEX))
@@ -115,11 +128,17 @@ dpaa2_eth_set_link_ksettings(struct net_device *net_dev,
 			     const struct ethtool_link_ksettings *link_settings)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int err = -EOPNOTSUPP;
 
-	if (!dpaa2_eth_is_type_phy(priv))
-		return -EOPNOTSUPP;
+	mutex_lock(&priv->mac_lock);
+
+	if (dpaa2_eth_is_type_phy(priv))
+		err = phylink_ethtool_ksettings_set(priv->mac->phylink,
+						    link_settings);
 
-	return phylink_ethtool_ksettings_set(priv->mac->phylink, link_settings);
+	mutex_unlock(&priv->mac_lock);
+
+	return err;
 }
 
 static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
@@ -128,11 +147,16 @@ static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	u64 link_options = priv->link_state.options;
 
+	mutex_lock(&priv->mac_lock);
+
 	if (dpaa2_eth_is_type_phy(priv)) {
 		phylink_ethtool_get_pauseparam(priv->mac->phylink, pause);
+		mutex_unlock(&priv->mac_lock);
 		return;
 	}
 
+	mutex_unlock(&priv->mac_lock);
+
 	pause->rx_pause = dpaa2_eth_rx_pause_enabled(link_options);
 	pause->tx_pause = dpaa2_eth_tx_pause_enabled(link_options);
 	pause->autoneg = AUTONEG_DISABLE;
@@ -151,9 +175,17 @@ static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
 		return -EOPNOTSUPP;
 	}
 
-	if (dpaa2_eth_is_type_phy(priv))
-		return phylink_ethtool_set_pauseparam(priv->mac->phylink,
-						      pause);
+	mutex_lock(&priv->mac_lock);
+
+	if (dpaa2_eth_is_type_phy(priv)) {
+		err = phylink_ethtool_set_pauseparam(priv->mac->phylink,
+						     pause);
+		mutex_unlock(&priv->mac_lock);
+		return err;
+	}
+
+	mutex_unlock(&priv->mac_lock);
+
 	if (pause->autoneg)
 		return -EOPNOTSUPP;
 
@@ -309,8 +341,12 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	}
 	*(data + i++) = buf_cnt_total;
 
+	mutex_lock(&priv->mac_lock);
+
 	if (dpaa2_eth_has_mac(priv))
 		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
+
+	mutex_unlock(&priv->mac_lock);
 }
 
 static int dpaa2_eth_prep_eth_rule(struct ethhdr *eth_value, struct ethhdr *eth_mask,
-- 
2.34.1

