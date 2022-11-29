Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D07063C224
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiK2OON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiK2ONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:36 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BB960345;
        Tue, 29 Nov 2022 06:13:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoER3DLXPCV+jQLKEUPyDlxyla7WNYNbgnIYrNkyCydoZMPGXNAJ4JcttAkpfEtEHZsqOA+gO4yZ9JYmRAv8QsPEsUxbMV4LvuQ4ggLkZF3nXrAM+Bop3L73k5aCKzbeHMRJbLCf6/ccFqdZmbr3AVHgPZIHOPpakRwr1SEDp/Dwhgywx6AAzB4IUMF0qPjX9JpC2xnMI80MZpT/fxSbkyiBOWHEwLvG7yP3Pw8QQmmX7bMbXh4o17JSn9LjjuLlPQ1PUhequdUs44zXzO1Jdlob19GKXNmBI2lJSo5coOslUukUEAa4O8aqQhEG38fUryFOG8R9/QNlGye4easvnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlYyeYNjtccvTJFdx+DJV5OG7RVmdD6O6Q2XlD8jUPs=;
 b=Argxuk2msq6A1mCn+mg8JuC8oTubAwgfHnGE6k9xy8/oHgvOvwUJ5dc2HiD65SxR5/aY6wrSAO1HL9H52MmHP53XDTe859NVrTSz62xTinlxLDnZobY2I+yCfp2ckSacnK88T8mlKG9ptZiKdJoZvhq0RvUV/LxMeo7CoChDQTXB4LdqV76BxQs+gjS6O3cE/hwkGwfrX2/1pPf9TQP7catR7rOwNxt5kA5Gc8hxdgUTC/RC81b3Sy+wg7u019xMGGw3FRqzmJeMpEREw/Z1aQpJd+HUcwRU9okR1HZCzwZ++ewO1/Y+pR9xpGjSPdGiSLiQCm7VA8fKWVk5IYYDHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlYyeYNjtccvTJFdx+DJV5OG7RVmdD6O6Q2XlD8jUPs=;
 b=hho3a1/3nb78Xow9hfrQJwcFLtPdlr0p02561H1ytXo7tQtAsdvmH5ZBaBgaXduvoVacKWnfVlif381FKlfFipNiALfMv1WNFmrBKywb5cwS65DGtgyyFUTpnrYKM3L6g7PwCFDkB8XecuAV/aZMEZTzJnUE/GOC5OemTztTPVU=
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
Subject: [PATCH net-next 09/12] net: dpaa2-eth: connect to MAC before requesting the "endpoint changed" IRQ
Date:   Tue, 29 Nov 2022 16:12:18 +0200
Message-Id: <20221129141221.872653-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 27bf02e3-a215-486d-127e-08dad213c659
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: io75qtPVp3fnTG28qVkRoPQkYCPOzWUyf7OmmUabEFNZzPyF5JMNK7Ey6A090WjIBDDqfbGJFQfO9hk1uWiYl7wGP7aJ+5BstSBvEfXgolWxQpxw1nkS1MI+sZ5kaoVNNhWJfgdzt750Un8kLrcuxn04cS6e2sY7i1VOLfZz+TdaVRT0PKI2xeZCFMJ8+BMxHtXgviti0N+32+Ebw8t5fhqNPU4Pmv9Va38D/AOVxIzwhOclsGVkU5alzdMur1ACf1+MFdUvjBy/b/4v4gaUyZfvf+qldH1OAB6S9iOU5K2pIhC8cWg+IH2XzGMTWjFX5IwLjrZKVWe1nq4Ak1Ojz02p8jloSQH/kzP4yyYZM/q0YetFD7IJMZfE1oj3ysx3xFq1HWt/w/+1IJ49qm/XXjwn/JYETMdJVKyBJY1Gr8rU2UoB1xVzkeHtF88z3QnR0bfFlHVBpyL7KD0NiBt9RZyCAeLbgI3rn2Vw4oTZg9SGBk9Q/NQvuUT03Iaidy2lJ7Y2OKIIxKRZeBwuEMDlDtaPFocsk+n1LbQd+lTQ+mVEKgQH8/tRcWw7AMz/68/LjS0Gu/qvEUOohl47I2tM1Hv+ctBio/H39MLD4zknD8mh3BvHPvau1JA+OKkHIZIneLmPKzyF/YNpOyVOGzZUPtrS8cHjYowzHwMme9FXSNmxFPPB3EqM2GLYzItUTHKK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5QJgABLLJJi/9qoB1XxQgXwH9VwSHTBD7jiRl0NewprGbX8w1AHtcKw8ZTGN?=
 =?us-ascii?Q?S3ElR6lgKwwGa/VE32FiiP7Rokf46FpzRx40EPIWTz4JRZwudZd9XEtpnr+k?=
 =?us-ascii?Q?sWOIWi592DgFDQhxZc4L6eNiBpuGLITR5WUKT/4SAfEY8klLzn/b597CiUWg?=
 =?us-ascii?Q?9ZQt0eQB5T4b9njhu44bK1yLnTDns0FDeevGJRwz7XzkSd2gRTrWfySqr8vw?=
 =?us-ascii?Q?HFZ1yveY+uo50h4bdYeHUPmDEDCgK57pqxVsADOCs3DhTKuxRwx1YtP5KlRZ?=
 =?us-ascii?Q?/4UaLqm1ExY10WeGeHlgEzLuyepC6YCYUJDGVSEaM0glSEJGOT7SKG1Lda7H?=
 =?us-ascii?Q?v5qr5aP8iZLo+bvc8K+CFeyjibBq2jVwZhvvVLHKnOzeAqpf9lHnZM1q5bbg?=
 =?us-ascii?Q?o79da+vMQDG67BTKF6XmAVaMXTdyn5xXBR7qRlkEuPy+jxpKb8qAdCXEfGQH?=
 =?us-ascii?Q?gjwS9ZqAZbVKldTD/Eqh6QMQMQArRKEyRI4RnzCQSlimhYMuK3V3uBwljLUN?=
 =?us-ascii?Q?VqJBEWgurE8RKm8hUTjCxXW+FlsqMHFk7K6NQooIgdgaLnSjkNUhu3QJ7xBz?=
 =?us-ascii?Q?CFtVqP9wtU/JOWzAfQobYTM2TKZNkbkMBuHVhlQgJN6JP4wnqm/Lq60V20Q7?=
 =?us-ascii?Q?u1xrnORrGZG7fBZkyRKqSKEaVbNtf3Gf8o3F0j14/X2J4+dMUG8yRBLvnIFI?=
 =?us-ascii?Q?igpUSZbEm+pjrzuNIo+GbELRa7BVGO9a9DTBj5neLEVbbfrW3f1r7DztHEv6?=
 =?us-ascii?Q?HZ90xRVpC3aqDeOF9YiM7gQsAjuAzjEOuuY5vfs6RfNgjTlTvoEYbpFdpbLU?=
 =?us-ascii?Q?OMhmI6ysdaUD2y0X4hRPaBhcVOwhe19+giPv42/cZh4Ha43H79bpQmwOh3uo?=
 =?us-ascii?Q?Q6SzDINpB0fF+UMZxRxbK1OtOERwaXucQJqxV8J33OrnCrmZQa2C49TUnKmU?=
 =?us-ascii?Q?NHv8oJTbA+J3FPAbY8+8eLyk923DitrgqFbZFvfLI7kClE/3Sfl8uHmSPV68?=
 =?us-ascii?Q?mz6VA7Ixj44tPi4OMb1Fn2PUTc6Qrs909nfhNvkbyH0vHL8YLzsTdaXUKkPK?=
 =?us-ascii?Q?UaOsCmDLZciSJPnkKYZ099rGy9wRO2Q0qSqpHdjUmQGHDFXbu1TVXVa8gBfa?=
 =?us-ascii?Q?YXnn6QjelGBI+ESP4vaI6WFEfsUi6SyY2QMCFFjarnFktjTecpqR0qeDpHK2?=
 =?us-ascii?Q?QWPM+7JEiQwjUJs4qdy5EMEJ5UYZgoC3/aFNaVXDYenPEFlRgG6XMYl3A+NK?=
 =?us-ascii?Q?yux8dN5pMzF1M1j/+ArAF9fl43kXpXafULBz2gHvOLJZh2SnO2hAdIg5XWmY?=
 =?us-ascii?Q?hZwYTtoB53bfS1f0N1wWSE9sEcSsvLdNIKJiQeYowQlodwOZlVWxn6Keybjd?=
 =?us-ascii?Q?XtxvJhEo/pH1o4X+TuUroE6ejXUY14fDqJFPnsUWi3tXdyawOolorAm10IWb?=
 =?us-ascii?Q?1NcByoxIW1csl75WWGCoR5Y68XndbyXcnmSc9iFRpkaTl3RfVFmjaRWECIpL?=
 =?us-ascii?Q?/VHASplLkarZYQnKOLVkpKYKtqRMADHvXC8GqDJdNOguG043/9nOtFH5rpUV?=
 =?us-ascii?Q?/88pm78+mcFBDLWpBDwobeAVDV9xHMEc35AcTapkWfDYfI8+qt8TwPLuqTsN?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27bf02e3-a215-486d-127e-08dad213c659
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:40.2002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3EY1uERHrXdZVhlPdeTUx99NtZDhZJDwXmpPXiswbJD/qcI7ojMumT104hDkZvqQI4aR3cy3l22dt7y7wdM/Q==
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

dpaa2_eth_connect_mac() is called both from dpaa2_eth_probe() and from
dpni_irq0_handler_thread().

It could happen that the DPNI gets connected to a DPMAC on the fsl-mc
bus exactly during probe, as soon as the "endpoint change" interrupt is
requested in dpaa2_eth_setup_irqs(). This will cause the
dpni_irq0_handler_thread() to register a phylink instance for that DPMAC.

Then, the probing function will also try to register a phylink instance
for the same DPMAC, operation which should fail (and this will fail the
probing of the driver).

Reorder dpaa2_eth_setup_irqs() and dpaa2_eth_connect_mac(), such that
dpni_irq0_handler_thread() never races with the DPMAC-related portion of
the probing path.

Also reorder dpaa2_eth_disconnect_mac() to be in the mirror position of
dpaa2_eth_connect_mac() in the teardown path.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 4dbf8a1651cd..b77d292cd960 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4899,6 +4899,10 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	}
 #endif
 
+	err = dpaa2_eth_connect_mac(priv);
+	if (err)
+		goto err_connect_mac;
+
 	err = dpaa2_eth_setup_irqs(dpni_dev);
 	if (err) {
 		netdev_warn(net_dev, "Failed to set link interrupt, fall back to polling\n");
@@ -4911,10 +4915,6 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		priv->do_link_poll = true;
 	}
 
-	err = dpaa2_eth_connect_mac(priv);
-	if (err)
-		goto err_connect_mac;
-
 	err = dpaa2_eth_dl_alloc(priv);
 	if (err)
 		goto err_dl_register;
@@ -4948,13 +4948,13 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_dl_trap_register:
 	dpaa2_eth_dl_free(priv);
 err_dl_register:
-	dpaa2_eth_disconnect_mac(priv);
-err_connect_mac:
 	if (priv->do_link_poll)
 		kthread_stop(priv->poll_thread);
 	else
 		fsl_mc_free_irqs(dpni_dev);
 err_poll_thread:
+	dpaa2_eth_disconnect_mac(priv);
+err_connect_mac:
 	dpaa2_eth_free_rings(priv);
 err_alloc_rings:
 err_csum:
@@ -5002,9 +5002,6 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 #endif
 
 	unregister_netdev(net_dev);
-	rtnl_lock();
-	dpaa2_eth_disconnect_mac(priv);
-	rtnl_unlock();
 
 	dpaa2_eth_dl_port_del(priv);
 	dpaa2_eth_dl_traps_unregister(priv);
@@ -5015,6 +5012,9 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	else
 		fsl_mc_free_irqs(ls_dev);
 
+	rtnl_lock();
+	dpaa2_eth_disconnect_mac(priv);
+	rtnl_unlock();
 	dpaa2_eth_free_rings(priv);
 	free_percpu(priv->fd);
 	free_percpu(priv->sgt_cache);
-- 
2.34.1

