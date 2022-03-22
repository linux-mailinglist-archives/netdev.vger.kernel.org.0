Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F544E35A3
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiCVAit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbiCVAip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:38:45 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20054.outbound.protection.outlook.com [40.107.2.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C2249910
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 17:37:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxSn4O1xu7GJE7Z6lblSW5xsd4qnKRVYvGpsGLnUpSIdcp8AOdtyDWPG8R6e4dU+lyLIU/ZRGbj16Y9ufHkQGesA75ImB/4QkLESsiwbzcM5CNui4kR8a/FT1b+OJIslgd4gNokSffugq9wPkxyCKLdz4pm447HQ7Szt78v8rjUa1rvifPDxhTkGZPbeFIVRnLUpRuG5h9ElR+JtdMwMKZsWULmHp2nzXYnsXZx/oaJZdCTheR5YBUcqxyBcMv+5g+CQFMKV3uwfkBYdyidxQkON3niXvuoXeYMsy7j/Svce9DBZiZB6QARc7xXsvHDwr122GKiDZhQUKJO9CnD0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylEScaauOLVd19FjXnns1lBOkAxjJiQzoXh73SpaSIY=;
 b=A+0PEIUfbfOnr2kJSRErOfaxuPVM4mwFyPfHFn7AD/l/ENbgQsHZ3hD8SMTmDMsTabV4PH0O1e+j/UXIkBBb9fcBGLP+PnB76yCaFKs6kn/0u6wuTNQlbV8QhwhWWZdRFJNwAUjPr13jeJVIPHWPDhF6wwNZUrVfI95bcEeGvxjfmKmUPW+eofc2Uefn244AnDd7cx72B4edrW7lHifFxjkDmUR22MVGPQIWLBhEpLhBu9X50s47F1GumL7j3iFDR9IMUqRVIg+pR15GqgURSNjGWNcp2XTqoM84QD4/+iDdMzfoS20UG4K1JM62VStklIaPqidxfbNTNVKp9ZOnrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylEScaauOLVd19FjXnns1lBOkAxjJiQzoXh73SpaSIY=;
 b=SFcsr4X9/Aec4jqAv1+C7i98N+8lA/aPz2Q/9hnaYueBMLw5pxWg3C3ty8ZyHK5/n/uWIoqVXyJ0Zv0q+xhnqBbfOXdbksPRVTGT7yoJnapCPZqE8uLDb4ZDgim2ZfPjQSwO1rQg/J9+k48z5718uoim3dLcJpkwdQ8Ae96Eno0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6356.eurprd04.prod.outlook.com (2603:10a6:208:17a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.23; Tue, 22 Mar
 2022 00:37:15 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 00:37:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: fix missing host-filtered multicast addresses
Date:   Tue, 22 Mar 2022 02:37:01 +0200
Message-Id: <20220322003701.2056895-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0275.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::48) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cb1a5f4-62e5-466f-ff5a-08da0b9c1c62
X-MS-TrafficTypeDiagnostic: AM0PR04MB6356:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB63565B32F1E6561B3D3A1344E0179@AM0PR04MB6356.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lNoAZxj2J938yTkP7DVEo2+DrBPB0H0XJndFC/nD/heOzF9HrUAwlvfcVa+qaB3yDBJufSRfEYjEM+efVp3Y9UolnyBLFbqswiKfreQAFKkxKkle8qlQAsPvjkIMQqEn/hniu/A3Y/vj17H3ZA6SnevHBkKhn1z4aoa2MjJS/5h3BePleOp7JltetLN98/QFDWiV+wIBp5Ba87X9YUdG0fidlM4FVkiDCpNFhZlV/u6wh+8D5epuf31G4rdYn7BWmYYqT/hYhnIz5RYPkODNidmo+pE9KUTmu0BhBDsVr4pTSiqg0f9c9FUsMt0gCHvL9rzYxTmS4I1LmeRlbbQD4hoAafBK1cO1vSOcRupMUiPOptQ3gmuiO7FBpm6JNo3vM4m5jmxwoKStIuYxIPWZgL7hGHqFcxbrzMownffUwkBI/Jvv8ZnCnD9VCN1hRoWmQo9DVETKzS7uUQqTxyP7QkusNYP3T/8110dZ3PhEpmsfyTc/pS07lLOehpsc63cgB2dVWwvo3tIBanqkl7Z4QihNw3ePgIFFfeUzMsuz6q+rxXjgEEXeQXFCULU2980YLTB492Qe3o7qcNlK4acTmndk8du/44zDYpAqRnatOm8CFN6rglN1mpmXB3R6bBMiy5jVhHDrpRhJ3zuGfYd+VUcE78KXXae00uVpe5UeQV948SZ6W7EIZGM0MEDig1pJj0prtnAFCu5kn3qcF6ZUssA9rVKzimgrxwWlx9Ay1YWRdOVRO2PSOERJ8yGpsaHax8sg6pko+TuA7CzDNFYoeLPTocPmQQf6UuTUKJaNJzg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(8936002)(508600001)(2906002)(38350700002)(38100700002)(54906003)(1076003)(6916009)(2616005)(316002)(186003)(6666004)(26005)(44832011)(4326008)(8676002)(66476007)(66556008)(66946007)(86362001)(6506007)(52116002)(5660300002)(966005)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KJSMvibHGu6jbfmz2z4/pg9nrXSrTynlHVNlM1eBHjoDJahGTWBW5YIZLMJK?=
 =?us-ascii?Q?fv8xS8oMwqp/+/2rR2TbstRKRlp0nDYkm+RWOAHlYvsd+4x4v++Th1A5FIYA?=
 =?us-ascii?Q?DkrLPqaMgcRDKuBX7dynP4sz3VM7NLGXmLHdzHUQe+v/aAR58TVBgnxTZrRk?=
 =?us-ascii?Q?62UmtNW74CLuFqqb54CT6Tp6CN3uSGVnMNXKIj98Kf9VQKGKyIGEO4Zva/OW?=
 =?us-ascii?Q?VcPkCcG7TumFitKq/kegs+L0uE0mwEaTNahP+soGW2ri9EQHhXjBUDvJOFVd?=
 =?us-ascii?Q?mN+Q15sLhuV90Z2QDkRi+Js+zFUl2f9HCp40q/KRwDc2Ixzn/sx5qbNuXUJY?=
 =?us-ascii?Q?LT+U/S3n28IyZAjV6GFRrNw1TJGra9DXWDjqcwMR6utAJUqaOpy9Ce/YLPNg?=
 =?us-ascii?Q?qgGXoFHNT/mMs3hg4hRFVs68pZdvZWbpZgV/zOk1kPP2jlO0UNOYi2eNavur?=
 =?us-ascii?Q?x3FmDThy1zY/y6AKFyJIV+AW3IgRfUNFKmn3eYWjz0f/0pHiyZzGzjI+9V89?=
 =?us-ascii?Q?/6A37Hm0FLoANUrd9CufEfj27tyAxscQmu4iOntpmiXV+pfML7vdHBF3/rin?=
 =?us-ascii?Q?k4JfFyWYgL3rpPVNQtSC7oQmgQAYBdOYQk0fEmsLo2dzITVKTHANZxo1g/US?=
 =?us-ascii?Q?YJRnFyyivuB20dpJ7ewbBDlQ2wjJaZAiYu780q8T9khM9Lw9SQt9cFU5gHkt?=
 =?us-ascii?Q?5Aq0UqOPOnuE1aFlkl16ZuTiy3i47fyb+kJbEMaTPIs3g/hRmuuMnGL6a3Hj?=
 =?us-ascii?Q?VZWjEqsMlE19BhDu/NkoD6KLVs0rAJ+Sb0wIDMfO1Phe1qkjQyx9UDjxy5fr?=
 =?us-ascii?Q?1ObtISmmG4oBaRGDBUpZQ+kAUOMHygqZWubLNbZPQzNSv2rffqzzqA7PZ4Pb?=
 =?us-ascii?Q?wNGAM1wgOtHQZyYk2KgPHQJK4kZRtdJG+Sst3KHp7fg+5XXPh/bOWJjdOscN?=
 =?us-ascii?Q?HnypI2e1GHQmN66Mf+mSbFa4GyWoVwAxPB94PN8kI1N1cS87EChF1B8UUiCZ?=
 =?us-ascii?Q?nycjOaS+8kDDqk3WYD3cnCKID4Gi0uLJ+yVT3shCaE0nrWT7LmLKDKnO98RW?=
 =?us-ascii?Q?6VJOo1VTOjw3TDqd4qNmWf+/yDMucjvkZIcHB10PQDJBC04Ia4icdREB2nJc?=
 =?us-ascii?Q?/zchtSkk5pdBYzTVWfRSSTLciD/LrSQmm4Akf8Faw+dgKG80BtdBGsly59Po?=
 =?us-ascii?Q?hBAKHPR+ornEaRj40oFw4Cqz2grzozfTCkZ2F2EHvKrLescppm+DeVELwwN9?=
 =?us-ascii?Q?ZBscGY0JTXCVxBo7185eCrRSh26CCuCj4r5ZE7kbdI/XQL5CQXf3JyXXC7VR?=
 =?us-ascii?Q?S6aQDOgEaszyWh7hm8bSD2ep1+uM8oJfNJbCSjHi3SjTOKz2vSslChZ0QQ1Z?=
 =?us-ascii?Q?YWYYS6g2+zlJbFD0TZxUZ1d/M7MlaLszBrI2fW5q3bc9vYaiZdVV8hsg9Yox?=
 =?us-ascii?Q?MjWxpTFNnCOFJV3QeH6YkRqayoQ6hB6IqQ7wsOqlOK7J4yHAR6U9Dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb1a5f4-62e5-466f-ff5a-08da0b9c1c62
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 00:37:14.8681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJyKc7rwCByJYtJ7LLHbv68Da2uqBiPNteI+Y1t7qtm82+PBbQolaQjPAMZA7ZGTAPJ13VhDzr1kVfkLciGh5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6356
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA ports are stacked devices, so they use dev_mc_add() to sync their
address list to their lower interface (DSA master). But they are also
hardware devices, so they program those addresses to hardware using the
__dev_mc_add() sync and unsync callbacks.

Unfortunately both cannot work at the same time, and it seems that the
multicast addresses which are already present on the DSA master, like
33:33:00:00:00:01 (added by addrconf.c as in6addr_linklocal_allnodes)
are synced to the master via dev_mc_sync(), but not to hardware by
__dev_mc_sync().

This happens because both the dev_mc_sync() -> __hw_addr_sync_one()
code path, as well as __dev_mc_sync() -> __hw_addr_sync_dev(), operate
on the same variable: ha->sync_cnt, in a way that causes the "sync"
method (dsa_slave_sync_mc) to no longer be called.

To fix the issue we need to work with the API in the way in which it was
intended to be used, and therefore, call dev_uc_add() and friends for
each individual hardware address, from the sync and unsync callbacks.

Fixes: 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
Link: https://lore.kernel.org/netdev/20220321163213.lrn5sk7m6grighbl@skbuf/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d1a3be158d8d..41c69a6e7854 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -111,24 +111,56 @@ static int dsa_slave_schedule_standalone_work(struct net_device *dev,
 static int dsa_slave_sync_uc(struct net_device *dev,
 			     const unsigned char *addr)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	dev_uc_add(master, addr);
+
+	if (!dsa_switch_supports_uc_filtering(dp->ds))
+		return 0;
+
 	return dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD, addr, 0);
 }
 
 static int dsa_slave_unsync_uc(struct net_device *dev,
 			       const unsigned char *addr)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	dev_uc_del(master, addr);
+
+	if (!dsa_switch_supports_uc_filtering(dp->ds))
+		return 0;
+
 	return dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL, addr, 0);
 }
 
 static int dsa_slave_sync_mc(struct net_device *dev,
 			     const unsigned char *addr)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	dev_mc_add(master, addr);
+
+	if (!dsa_switch_supports_mc_filtering(dp->ds))
+		return 0;
+
 	return dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD, addr, 0);
 }
 
 static int dsa_slave_unsync_mc(struct net_device *dev,
 			       const unsigned char *addr)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	dev_mc_del(master, addr);
+
+	if (!dsa_switch_supports_mc_filtering(dp->ds))
+		return 0;
+
 	return dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
 }
 
@@ -283,16 +315,8 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 
 static void dsa_slave_set_rx_mode(struct net_device *dev)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_switch *ds = dp->ds;
-
-	dev_mc_sync(master, dev);
-	dev_uc_sync(master, dev);
-	if (dsa_switch_supports_mc_filtering(ds))
-		__dev_mc_sync(dev, dsa_slave_sync_mc, dsa_slave_unsync_mc);
-	if (dsa_switch_supports_uc_filtering(ds))
-		__dev_uc_sync(dev, dsa_slave_sync_uc, dsa_slave_unsync_uc);
+	__dev_mc_sync(dev, dsa_slave_sync_mc, dsa_slave_unsync_mc);
+	__dev_uc_sync(dev, dsa_slave_sync_uc, dsa_slave_unsync_uc);
 }
 
 static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
-- 
2.25.1

