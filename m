Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A895C4B0DDD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241820AbiBJMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiBJMwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:22 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAD8264D
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fb+OZ73PbcVLqfE6gz6wE4a79ByqyH3NLhte+e7rVujGxNTDpTqA8S1+/EIwc4VQM8QodvC1FhsFRoyAQBOmogA4RzgJyzHvUQJAAEqfxBpdLyyKEKAT6joOV4o9ooS8z+akoqopPphOhUmy40b7V5HF85cdBGDnx+SWiTMsNXOKLlWlCHZFpuJ31AAd5OwbQ60/fxhgSPYykadZYPRaQ3+JEaYy9fETjzR222gwqS8npn1GvlFsQ/0JQtFBjPbK7o/VPbeJEormR0OWvQXVtuGO7eIjOlfOhXtwXl5E7yDcYmnLlr6MlNMBnrPZMg2nb67BLieS3bZBkJBO7H0McQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1iOeDcXDPen86tKsOQEqJ3+pjGkSIWnWyScUZ+FtUk=;
 b=TMJZIFxt7Z1nQg6/5l/xgeBxHeA7/Xq1fRWn9FzPS7eCJVmPJFal7CRzCBgM8ZX1TvqDY3Wh+P3SUL2GnDpIb/HNzf+5JuNfXhiwC2slvk1R4we0bg9eYSo9MH3yaSegZ/KLfXolhJP3bYwSU5S7GCRDJxIwIggDMkxYzl5o0oKKm00cDadr/9SIFudnVpBZyY3w3GBlN7gHOjt6dmMAq/WDFsKoMoZmCMUck8jjzOcfQGj0cQ8TCjd403HaNav/ZP32AguJjFiInyFYNA//3CWLa2PeKcQygijPO3pwbtHx3rH2hr5IUWlH15IV860dhCCKNc3u5/PL6/7YDUaJNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1iOeDcXDPen86tKsOQEqJ3+pjGkSIWnWyScUZ+FtUk=;
 b=KakaQGlrPBH8yDFZZzNniIAfqtPcb4HW9q5ee52oVf2Lq+VzE7VpX9CqO+FC+esnXo/Uv0RnmCgDZVjMRnruRQ7znfpoJoeYkAVA6Xt8uCsuAsNQoQKeV+qymfPniv8HIQUA9R+Cue/f0a9oo3n7qWBjAXMAugoj4u106/t7M5c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 03/12] net: dsa: qca8k: rename references to "lag" as "lag_dev"
Date:   Thu, 10 Feb 2022 14:51:52 +0200
Message-Id: <20220210125201.2859463-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a2c346a-eaf5-4122-8a5f-08d9ec942b7c
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB88068008488927E5DACE7476E02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qctYBePCPL8U2b/CFMv7+9Ejoc4nDWckE2cbQzkhyG6k3wL/vKfvh2EbKNb9UGaUzWxmEcV6g6B0rXzCnt6qfyZvVVT4+5BiD8nyooxwZJXgCDjL+TAAeJ6KMVynOQX5ssFBlCZQuh9/xt5/ugGJjsHV6OwlhbSYvf7madeuZ6X3q23DtDA0gS3pOG7cv+NHN676WPvV8OV/9Zv1DJdjaYRQLlRiEewkMv2mJPLC52idEjqeWenABxdJZpLO73qgDpcL9L0T9ks1jXy4tS9ANNdCUdPmYNiLjuzAWQJeTskrR+3PxVPhuskKSPQ84vYF1eB3LKePnIkcokX9PIEgGT/t0FdJ07SlBogESgEPU2Qx2LoljXRYHFgNOAUJcRQSS2zB7cIdxljEImXXumSoFAq1oLXOmgKld2aAVaNhURD5Olcs3hYi/CLZz6QTNIx7TlWAf2ilpfTG8xyzD16JIcN3w/7sylgsYql69pBrxYbCG8sQ7kxqHC21lj2OZoEyx0uPARFhzg4MsdGz2fN54/JwdXLlDfc4bnobwhR9Ii4DVMNVM2oRVQToTVszdGYqE6FlAcbEwN8u5yV/uqP7T+7H3YYHyDllfvu9HcIm4E4CsrfX4y4FGOkAP9zTUtnDlg6ZT4LMz8eXt3yD2A+NiY1oRrwQEJgxlTSepTIhgHAbKc3MaL+eSdYGALA/bFo2qiKmiW3Kq9UwyOX1q9GtkXddAONQjcNmCn8lLvyU4LU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Eu40ICi3aKJ49YHQShoS18pZzXSsmqJf7AqB6WjPrq1OkmCkQdxzvHFEQjJ?=
 =?us-ascii?Q?s81mOa3ecqmrNcFru+wfn8S+AU26021ePNoENdpHkITBiyr5kDdRCzUcjZHQ?=
 =?us-ascii?Q?Jo2KJR03BiEK6D12JlmcxeK7jRQ8Spup/CHhVib8g26or52Ok/4mgPlG8OTn?=
 =?us-ascii?Q?+AF6qGoeiuOL2eHSIj60rNtQ4+3ihfGMDEBIFG7cyotLCdIh7oJeR2XFoQJ9?=
 =?us-ascii?Q?18y9vAz9fBgWxg3WXLNCkxeodero2vCCyRvcfgflffkOFI39Lq0pSDPzV0LK?=
 =?us-ascii?Q?IKzhICARAMsuXyfmoQxv8PtJKkn//i8sdcYiWzHxwkQ24rLhcsmNmz1TAqFW?=
 =?us-ascii?Q?cge95m8QILNRolgcdC9BlUfK1Yi9PvVzPfoZX2H2CP7GVAcgvN02ZWIQmMq1?=
 =?us-ascii?Q?hGS8KrOY+QykZ2nZI9Rmj54HR4Z3bXEkJ8GP22AAT90MhF2ZLpnWFM9ejWzV?=
 =?us-ascii?Q?g18H/mXuSymH2a6f4wEof+00+WJj4oEpA9rU243IKEtM3tLzGjxGJ5SI1kJi?=
 =?us-ascii?Q?nkW1Getof2JnVRCpoLeqKIBUzI0gsf+KZRXi89spXB4bTtqn48I5LOoKQb08?=
 =?us-ascii?Q?QWlCbQgiNuLKi2hqqLRCpYTStMi0055zAccPM2djyUUSvT8J51DUiFRMhE/4?=
 =?us-ascii?Q?jhPD214Yb5Lux9HrxuWrv11ltNzgDU6ZNudwo91UkCsxQYcWSA+/j3aJ6WJ4?=
 =?us-ascii?Q?5ucrzsShmtfey5s9pLJEu4hzm7EPRrEUgJ2TmSi3Cw7RKAACtndVQW8fCCs4?=
 =?us-ascii?Q?lFCJyzhq/PRBA3mvx4GIGQ4BqGCJ3MnnZM6PzySiNZyIw+RTu1980gmxFAyw?=
 =?us-ascii?Q?JdBEOjooEXKZbnfI2JQiawkgbfyK9pacLJ6WPMdjyGUBLB4he/Hr+mIPxEcL?=
 =?us-ascii?Q?FqIcv1nS8KEJ+llIcw/YDm7IBuAp7JT5IXf4U1ykqbrfWyTtrMwoQ/NlEzQi?=
 =?us-ascii?Q?KPl2Gi0Sq9W3gvVkmveF0jdHJWLErXZSY0kzi5X8IxK9q0ldml4NiamqErOX?=
 =?us-ascii?Q?TwiHL3qkN7RltG0zNBugREvUS69vrbco6BjWh5Cc6FuUCluJTQLSIEtYqsx1?=
 =?us-ascii?Q?LYp+l5DhpqMcesQXCfLc5ofLC3R7MT1j7ijljWWdNhvuyrbz1k12Dz7VxBMN?=
 =?us-ascii?Q?R2YK1rKwfd4PuABvb3+Nm+Xt6QoqL/szYSS2NkmKk6DpKC2OuEDVsypfXl2P?=
 =?us-ascii?Q?vUqAAT+tPfSnbn0wYPt1xBOp/A5OMHDzyMozuf335z9PmtbxVHyIa7KwZZfK?=
 =?us-ascii?Q?2wf4JYPEBsVsnTML98UIxa71b6431oxUxx2JWsxLwVhRKCmJ/qnOUY7o9b1R?=
 =?us-ascii?Q?LRxifIsj+NfDJ+QNGmdqpAeUzJIEGFQ+EGtNSF1zEhyXjMGnesGgttw9Z3T6?=
 =?us-ascii?Q?fd/F1hf+H4pJAhXkM9Ba4sIx8ZaFEcj4TrGp0bjRE51d62Qsar0fAZjwdVIW?=
 =?us-ascii?Q?PM7HD82NRcMeQWc3BqFsf46TQfSe9CWkkgHMLFKFR7tCMPBJjTkTdmsm3y4R?=
 =?us-ascii?Q?SyelRXlX5BKsNeeu1L52lWMok9/mS60GxCZjg2enIM7SPUjdkUsBMdiJCK9O?=
 =?us-ascii?Q?Cx5ympMYEsNvqnYt8RIaH9sFvUqO69rFOItH6+CUjMKWvWHwxg8vt4OhlPpv?=
 =?us-ascii?Q?uyHSOZldk+iktyeJTjTEqs8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a2c346a-eaf5-4122-8a5f-08d9ec942b7c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:18.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8IXmEYdo7fjXqOI+MqFWwDy+rcrWdptRiwAoVfOkfDHYN26/iwk2C7FmZnYYe0BUU9vWgWA/T6eY68/kBprsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in qca8k to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/qca8k.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bb2fbb6826ac..337aa612cc9f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2780,17 +2780,17 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 
 static bool
 qca8k_lag_can_offload(struct dsa_switch *ds,
-		      struct net_device *lag,
+		      struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *info)
 {
 	struct dsa_port *dp;
 	int id, members = 0;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -2809,7 +2809,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 
 static int
 qca8k_lag_setup_hash(struct dsa_switch *ds,
-		     struct net_device *lag,
+		     struct net_device *lag_dev,
 		     struct netdev_lag_upper_info *info)
 {
 	struct qca8k_priv *priv = ds->priv;
@@ -2817,7 +2817,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	u32 hash = 0;
 	int i, id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	switch (info->hash_type) {
 	case NETDEV_LAG_HASH_L23:
@@ -2849,7 +2849,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	if (unique_lag) {
 		priv->lag_hash_mode = hash;
 	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag, "Error: Mismatched Hash Mode across different lag is not supported\n");
+		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -2859,13 +2859,13 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 static int
 qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct net_device *lag, bool delete)
+			  struct net_device *lag_dev, bool delete)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int ret, id, i;
 	u32 val;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
@@ -2928,26 +2928,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_lag_join(struct dsa_switch *ds, int port,
-		    struct net_device *lag,
+		    struct net_device *lag_dev,
 		    struct netdev_lag_upper_info *info)
 {
 	int ret;
 
-	if (!qca8k_lag_can_offload(ds, lag, info))
+	if (!qca8k_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	ret = qca8k_lag_setup_hash(ds, lag, info);
+	ret = qca8k_lag_setup_hash(ds, lag_dev, info);
 	if (ret)
 		return ret;
 
-	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, false);
 }
 
 static int
 qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct net_device *lag)
+		     struct net_device *lag_dev)
 {
-	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, true);
 }
 
 static void
-- 
2.25.1

