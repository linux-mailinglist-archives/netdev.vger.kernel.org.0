Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F15F4BDC32
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357116AbiBUMCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:02:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357241AbiBUMCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:02:11 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3816F6544
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 04:01:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BL9AOR8haL/oUyJv8n3ogCNL7dWHM3CH5/6AB0pq6qe2mj/sWjmdoNMBFDE1e/gylAXlehSxfzlT68NSbZKYQp1D7mcM5O9NSaivx2LOTHR4PX85olV3iGlKPardCyaEuPpBiD0Ygi9lEw7qm5XW8F+E7OB83/XEG3vY07aq14w6fXxShnrw2uM53UwmWtM+x654cOz0NuSr3bm66dKevNW1yGxWTjDkiLfP7vyBo7/JFHLebmFiVA0LUCcE+emnKNON4m5/9D/z652CYGG/sn8BMaoJIU/zQ2OgAipQb3Ne6Z6Wty8kdCcQMUlf6Du1rrqvpZKsKm426vl4fs1OkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXXDduDJs2A/3gdaAsFof4MIcm1EqvZoujybBo3Y9+Q=;
 b=M7I3/uv2zfBOF5BNgFKjUA08A/fq/T9+yOebh9gcqNNp3xH72qd+qjE/yyGV2oMBkau9C5jppN4NhRkqaWQuk2MQFmnYaL76jAlFuDLzKP1DSCnim7LGtPtr2SNbjdbAc5hWJj2SDsvTubkoT7kp7E+UzwB56duOWFMiary+wM7nu/54pIPRrbrElxfoPwbVHkZ6bBG7MzJidmb1sXCyCGTXl0rcnteqPjMteSZeg/63njc8GZP6iwMCfIuCz0t52UWEtjIcPxvhowRHDKXH/zYRwTln4gZ0ZrQbyYMzRguQb7acyHypigTRgFC3O7YJ0lhyCcF/Oai/QphZpTzCww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXXDduDJs2A/3gdaAsFof4MIcm1EqvZoujybBo3Y9+Q=;
 b=Fp/WAULrXkQpuBiaTInYktupNAoEPM/Cy/RQPIg+C/WivYQFdnHVAmdPMb5S3JSiwUe8ucq49BgTpTgVLqzQC5DAS65vs7okMagbAq5Ju7P+mYYj4es9l67fVxbhPY+SUS6sh8IFukZGBQWpTq588KceXMFSjD148Ny18tp2ugY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5330.eurprd04.prod.outlook.com (2603:10a6:208:5d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 12:01:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 12:01:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next] net: switchdev: avoid infinite recursion from LAG to bridge with port object handler
Date:   Mon, 21 Feb 2022 14:01:30 +0200
Message-Id: <20220221120130.1342581-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0082.eurprd09.prod.outlook.com
 (2603:10a6:802:29::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d57f927c-964e-4998-c303-08d9f531ec44
X-MS-TrafficTypeDiagnostic: AM0PR04MB5330:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB533039CD783DEA212328BB55E03A9@AM0PR04MB5330.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rp0Nbo9tJDC0+kwc2MGZ1yQLHq3MI70ixqt+w88zFWQzRZ+fwzSxQFvNIiKpIIkNmPMJY95yqgdkkumPpoBd5idZGxv0yCitNNcVTDA8J3MSuNIyh5VCPgM3AdB+6JGKje2ubfe+jEGVcVuKGRDXRxT6MtVQGP/WKFxMKLIqNjKdezd6581HESrNyO1+rdqa8ya52PJ7HFezvz6xOVX5qH6+xXBcckUEHfjnJuq6BRyvl9c69bZ5P9Nl3yFAPNpi/dQ2qDp4PynpzUzycGfFDvb5/AeXByHFH0Rg1yuG4adacw+OJKhNaQz04hbLitxoOW8CmMcnPfMgV580MMeRSujC4pcf2jyCgZrjfyUTJbREFZfyoNSawuSV648tIOzb0DOmY+uzau87HaX5aTGVNwR9lmEfW/S3FC8u+F+BDI0vse3dSyj3XbHge2BlzfiwlfhkI+WA83ptNFSy11ICvvyYZLGndvH3y3fpDW5tpGqd5Lv8yckql2nSxP1ViLdGKUOnF58WcXG/pBtC+5HF3K6NTn7X/uJKX8fDyS9UuNQgMaJof96XxdXRUCIlS0ioFA619QIXDKx+gq4sg+C6o9SH3vxYdN+zv2uo6b+ERbJE9bzNJtINRrpFPWCykhSTa4JjxnAEXGhE86YJWwm4wyMOEzI/QvbSpEpK3i8KWfRxaIEF/NX92JDIA6+u6EZyFn0ZXrPjACCcik5dWO7bfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6486002)(1076003)(26005)(186003)(2616005)(508600001)(6506007)(83380400001)(54906003)(36756003)(316002)(52116002)(44832011)(5660300002)(66556008)(38350700002)(66476007)(86362001)(66946007)(8676002)(38100700002)(2906002)(7416002)(6512007)(8936002)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nci9FWpYbZlx+kK0Mq5oytmbS0g/G1XyadF34vjM6tRmFlJFMB+ub1ntnvvK?=
 =?us-ascii?Q?cTCnatE86OkyIYCVu2ZaFSUNF4fVh5HA/XBC8jd5fB+EJbKZgvVbwyVjp5yo?=
 =?us-ascii?Q?n1K50okjgp+SJIAJESe5N6n/31NnkSkjsqdoBGigoMK+9YGTvBBRh34MvfbD?=
 =?us-ascii?Q?wYg8MrugiipQ0yb9MoYqd7eJmjMlGlX5eGEG04Nv1i1prHkI3JhpQJk18Xgj?=
 =?us-ascii?Q?6UHiceHacMom8gisjDgZCYV76bTdlYvAvykAafJLpb6hWYmlmxOULRiaqZte?=
 =?us-ascii?Q?Wz4nL+KlxSmu4cdrKUFNrWCF7ZXH+jIDL4biNxI2lFkJHW/mLP9Elk8axl90?=
 =?us-ascii?Q?ewqXMaBC18wnoCXE4/fBoM5vAq9krB3NORdSo6cA+HQOxa72i3F0afRLvaY3?=
 =?us-ascii?Q?wfzMZ+a52gL/OWMH6S0ONgK+GP9fGNtL+Tayh/QX41w4++JCXVkSq9USV91+?=
 =?us-ascii?Q?PzpPZn7ZX8ri2i4t4g/L5Q9gE4iuvhn59mdRs+Ag+Ayhq+9LB4qU+PEPQOnU?=
 =?us-ascii?Q?nLy007kr+XS6kXwtdp6SuUHK05KJgD9xIRFegAJNbm9wjPvSdI9RU9J6TdfK?=
 =?us-ascii?Q?qkKOk9R7ZTxWkWXM8JebWBLud1UFWFk65TnrrrcG97r7Y1KtgbIBUjci5yMf?=
 =?us-ascii?Q?YFAPR/K5R6mBs3mf7ZmaEXqyk4XIF68FSwp4rdWxcuKYxUEeaBgphwUpNoV2?=
 =?us-ascii?Q?qn9/ZUIXTiu53R74mH2kTQ9KLjvKE7EULtgyxDIO4WsO638z1tGjOePxjlQ9?=
 =?us-ascii?Q?7pBtaLnrcuQg8P347U3jACTTM+kG7HMxaS6emPh88NXgSDny/YUjfqEWIVQP?=
 =?us-ascii?Q?dHtfARoRFUVXor5lWFSEcBeHHF724nG+26olCLC58oHlwXwqS5u1lDUDJXkw?=
 =?us-ascii?Q?jFvG+JdkX0hmFSBaXGAcabuRxtEuTJX14CMlSUK7g1q6q38rzD/8lZTjjuAD?=
 =?us-ascii?Q?3OGpBwXTAK1X++znODAg1yww2CMc8OvZ1J7eKiG4mTRX7cOiv62c3rqPzUpC?=
 =?us-ascii?Q?cG1DBANRaBUPqXG9ObuyK5XP8eIMBqBCBXaBlmBPTGcNv3W5eL+YgO1DV7zU?=
 =?us-ascii?Q?B6F0YTrOwB9mOLnU5aeQHxPl5LBC6hDul6TeAyUt8343ipfH7w6zU4RUHhAE?=
 =?us-ascii?Q?FAfM2dTpfe742xeU4VRBjVJBuaNSYspdw+q+hGe1LrQnOHTqA+va02xSlzxU?=
 =?us-ascii?Q?xoIbaAJzoho/flMgh4C9cEektPtCvINRrszdSL4OJQaC1JSXH2bL7XH87/9n?=
 =?us-ascii?Q?3X9C5/6zPqs8aoloYo+6W4G4gQoPCtsTTS7aIza2hXWfSCmOIofUqZpAzkEG?=
 =?us-ascii?Q?JdSkW46IxBIVhqsp8p2zyyl+z3ufvkopemh6MCFGLWB9wl1n7ZASgBYu3TiY?=
 =?us-ascii?Q?GpeMKsAulZrkKyJB6JadsOPeau5xDzXsCNLZGGnZguBc5CDWNJWsfTb7rx0c?=
 =?us-ascii?Q?xIK0d/B3JD7/Rnhq0ozJ5i4W0rYqq/n2VLdbVfQXdn63loPLAg/Xe0tgjsoe?=
 =?us-ascii?Q?vCqBHO1tpY4fn/xsZ+1mPUm57CvNyATDQ6+do/FWiEQcr32A5e0hLDyJYlsI?=
 =?us-ascii?Q?8hvE8WumEzMlayezmRgt2Sc1MouzGyJYa6nfzGSt7cjfwewploBtFMJioQJ4?=
 =?us-ascii?Q?HcsGkxXRGhrqKGmDOFVAMSg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57f927c-964e-4998-c303-08d9f531ec44
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 12:01:41.8423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQT9tUpRdQvn4l/2Q4K2C4vSWYcm0ZTEVSZAxja5e+c0ifOTg08DTxbtluCPNxCXMKYNG06JePLGliG/BJ4uTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5330
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic from switchdev_handle_port_obj_add_foreign() is directly
adapted from switchdev_handle_fdb_event_to_device(), which already
detects events on foreign interfaces and reoffloads them towards the
switchdev neighbors.

However, when we have a simple br0 <-> bond0 <-> swp0 topology and the
switchdev_handle_port_obj_add_foreign() gets called on bond0, we get
stuck into an infinite recursion:

1. bond0 does not pass check_cb(), so we attempt to find switchdev
   neighbor interfaces. For that, we recursively call
   __switchdev_handle_port_obj_add() for bond0's bridge, br0.

2. __switchdev_handle_port_obj_add() recurses through br0's lowers,
   essentially calling __switchdev_handle_port_obj_add() for bond0

3. Go to step 1.

This happens because switchdev_handle_fdb_event_to_device() and
switchdev_handle_port_obj_add_foreign() are not exactly the same.
The FDB event helper special-cases LAG interfaces with its lag_mod_cb(),
so this is why we don't end up in an infinite loop - because it doesn't
attempt to treat LAG interfaces as potentially foreign bridge ports.

The problem is solved by looking ahead through the bridge's lowers to
see whether there is any switchdev interface that is foreign to the @dev
we are currently processing. This stops the recursion described above at
step 1: __switchdev_handle_port_obj_add(bond0) will not create another
call to __switchdev_handle_port_obj_add(br0). Going one step upper
should only happen when we're starting from a bridge port that has been
determined to be "foreign" to the switchdev driver that passes the
foreign_dev_check_cb().

Fixes: c4076cdd21f8 ("net: switchdev: introduce switchdev_handle_port_obj_{add,del} for foreign interfaces")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/switchdev/switchdev.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 6a00c390547b..28d2ccfe109c 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -564,7 +564,7 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 				      struct netlink_ext_ack *extack))
 {
 	struct switchdev_notifier_info *info = &port_obj_info->info;
-	struct net_device *br, *lower_dev;
+	struct net_device *br, *lower_dev, *switchdev;
 	struct netlink_ext_ack *extack;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
@@ -614,7 +614,11 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	if (!br || !netif_is_bridge_master(br))
 		return err;
 
-	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+	switchdev = switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb);
+	if (!switchdev)
+		return err;
+
+	if (!foreign_dev_check_cb(switchdev, dev))
 		return err;
 
 	return __switchdev_handle_port_obj_add(br, port_obj_info, check_cb,
@@ -674,7 +678,7 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
 				      const struct switchdev_obj *obj))
 {
 	struct switchdev_notifier_info *info = &port_obj_info->info;
-	struct net_device *br, *lower_dev;
+	struct net_device *br, *lower_dev, *switchdev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
@@ -721,7 +725,11 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
 	if (!br || !netif_is_bridge_master(br))
 		return err;
 
-	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+	switchdev = switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb);
+	if (!switchdev)
+		return err;
+
+	if (!foreign_dev_check_cb(switchdev, dev))
 		return err;
 
 	return __switchdev_handle_port_obj_del(br, port_obj_info, check_cb,
-- 
2.25.1

