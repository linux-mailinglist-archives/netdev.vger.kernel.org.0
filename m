Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7525B23F6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiIHQwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiIHQv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:51:28 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20087.outbound.protection.outlook.com [40.107.2.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EE96425;
        Thu,  8 Sep 2022 09:49:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vi/ovSGmbv932ole/7swESiwjFxXiJRGveYAiF6oFRJpfRuZ1mylNQc7WhjBTAQiyFGpr55pzIL1/uXSAnJb/tKHLEp0vmNvFrEUN4iELo3ytCvG7ph9u+ouycvrpNMLjQNcfccjmahBriq4r1spI+9hNT+HdcknyzM3aEvZPso9WdC7QkDA0ozd1kV5O4bFAqkH7W9z01n3ToNI5LWQDDhe/nK0t/n62kjUi5nc5IdcK6ebHvcbsKcU/nEM4Gvv6bbQ+SvE2pLq4kSJe5+vFUKBsGtqOoH1zKZTb6T9sOKwf6kRCToT+PGq8cmHJWGrYOdGDnWn/RIxF0XYnyQdYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1diHf7899e55Zkfa9eDlvvGRvX9RxwYA/ufkCOkIiA=;
 b=l9HELV0cLJ4Wm8Y4FPjyNTpRqAIx5I7R3KXEgWSUoMW6d4NTXSD4J1CO0s+yq5KL+8UBCh/eHhMimlRqPMq5NENBGC4Axk4X5NxR9x0KEXDvH3nqp/MJ9gJmpqzxesQEWKbuQSAON2VyQ2P+t4Jtm9CMwOQ0agTTGXVkyHysg+4PiBFzzwLfiXKdSWL8C7bYO/aVfmnyTbxLEc7EFm7kdI7ma9DPp1+cfUXUprLA4/+tLiEN+43RHa+/HJV7QqNm0eU+UNezFkshnjMDIMQawuSVgi2WBMvAdCj4h2glHmJcOpCc3of80mXVB1wzUPE/jot+FLKAr5j5WpM8c9+RhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1diHf7899e55Zkfa9eDlvvGRvX9RxwYA/ufkCOkIiA=;
 b=q2nPTSyiuawi2gWXCaazGjt/WD8eVh6glzupZkaBQPVwE7w4ofVB4NLZZ1bDxtcuKESIqfw5EAJGj5X3YbPOiie7MiHLlgCRk+JRqMlGgOxSj+/8bLnIlJ914pdsx/fd2JgdMc8pOETny+D3dSqC9iFJ0JCXUzrLUnEn662gc9E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5154.eurprd04.prod.outlook.com (2603:10a6:208:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 16:48:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:48:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/14] net: mscc: ocelot: make access to STAT_VIEW sleepable again
Date:   Thu,  8 Sep 2022 19:48:04 +0300
Message-Id: <20220908164816.3576795-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc2c82d1-3b63-42bb-ba7d-08da91b9f507
X-MS-TrafficTypeDiagnostic: AM0PR04MB5154:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aVIHehMO1FKt2do/2qwjJm1lmeCNKH9wTMNabhwR2PIPpiKkB58sgNnd6783zpWe+YFxVoO717lyWXP3ofiOre2irenWt4jFW9FMAblUZ50sCXb6X6KS00vM/DDOKwuw8wa8c40dipeTTCszYRMIzsUBnGSP9Gex4cuFiOPi3+KxuJHrBZDADxsiROUrusN83jEe6HJ0l2n9QpRODJBg0+wDLaFFdZDbxT5UbWaPYs7UM7UgNQypH9Tc5sk+asrN2qNBgGH0hRj/fjNIlCu58F6xcVrOUw3Vgx6K/zQ6s6PEK39bOb50zwniVr7p2f63ytqvjYTad3SAOBxOxtG0tJeI7ybVQb5Myv4fp9N/k5blnovoSYgB3cIvdbQlxQH9xbpm67xEr4Q5GlYgebiV7bB2F2jdGdR4+dMpZ1Wvxz3H/5cvRXHER1QfjhFxNkbybJ9CvK++YZIwpSIdzv/ZGeVgI3reSfr4HH5y43mzJB/GaXX7NzU4CTk6cxD7B9xpdaYl2vmxc77U+ogaiJjQSPPWmTLdws3cDDM9sz+xKMgBDSVExDPHdh3njXN5k0phNtorsG0m7wZh3TRmAApOTUJKGm+PqmdzQ+vZvqRQspFFvwZidtOiDgrvB3ZLXkUR9xG8sIRz1z8kwoI+m+E8hjx5qH0TugfGbjzVGOMWvzr+FtcqrMf06F0ZTCcEHTRybF0uSEk85iGojp3mvzI0WLMRAKRguPjWYHawbTV7Ellxc+ALSCpJWrxbCVfVZGVF7sQD+U279iAOX21t91pV8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(6506007)(41300700001)(1076003)(6512007)(6666004)(478600001)(6486002)(2616005)(26005)(52116002)(38100700002)(86362001)(38350700002)(5660300002)(83380400001)(54906003)(316002)(44832011)(4326008)(8676002)(2906002)(8936002)(66476007)(66556008)(66946007)(6916009)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lAxqABXlqdQStPiznVOSwhQ7KgMAy++03GeY/rja0w1eyMsG+3z92hFZD34U?=
 =?us-ascii?Q?XGslVIBPtMrbb4gcdxOCQqzhaqPXsGu1FkvYKMojlVeLYIgaRQ6gfpjIz3Im?=
 =?us-ascii?Q?4SqUs8oXcCcMoPHuHHQpx015UdfPGA+XSrteEsNHjF4vnKyfqWThlqC26YKl?=
 =?us-ascii?Q?o033sYJ/CQSnvdCI+1BWyySIAR0hyn1THKpXaeXfz13saZIyFIuXW5UREez1?=
 =?us-ascii?Q?qRbMSHRUWjYm5CUkH5fTub76g5RBD+BUVZe9P5WY8Bwq4hKJqMT8o7pSkhxw?=
 =?us-ascii?Q?+Keg05g6KLrU0AIe61AraafWASha5ZQFu3taJqfYoeYJFq9tDpxS+tJPO4se?=
 =?us-ascii?Q?uC1XsUh27kjt3pRm7+xQ91TGXqxFngRNF0q+igUUOn82SFtvuhTSZBeQgxq4?=
 =?us-ascii?Q?QGfASGvlcVZmVYoUNWlAOckzQHija7pfkSnSVB1ifq/kGMlYHhOFuzTKdaOs?=
 =?us-ascii?Q?Xqmmj5At8SheOJoLXECa3bhPdkPo3VKHr3idxdvpt15R+y/2ZYu7F2hqNLFk?=
 =?us-ascii?Q?s+UQWxDHFf7SYSwxflxq5sngAobSOjD0umBBMj7BkCVeQx62UuZ1GxLIhVNz?=
 =?us-ascii?Q?OYbJcgf4SzsOSv1r5lG7IKhrLUx+acU6IV1AwGl5lPz1tk0wrRyl2EZgh1dF?=
 =?us-ascii?Q?AcRWLlpx9AxNsFVRVp0dGc17vakmSwyRJOZpbQXx1jAgchfJZrCVjNUxthkZ?=
 =?us-ascii?Q?Uy0HZ2NOsqQGrnUUS4S9jK0dFFUOqK+s3w00nldp851C/UOni3heShFP29hl?=
 =?us-ascii?Q?nPgfMyglQ+a+DD7yCBd91CumuGZfFxtR2XzVLF8oLKY+pl4PhItJU8pjvoIy?=
 =?us-ascii?Q?2eqFACsrOAzfyKmcGlatPhQk7yzym3tbDBIjhTSie0tHWAen5esXEsij7JOC?=
 =?us-ascii?Q?ffmU8Ky7QwYTZmpjLLBSXrRbcftGVV5O5RruvtzhPnfKQx7EPJ5aX1Oo3gc9?=
 =?us-ascii?Q?6bmZG7LxKPOlT3atHKlnD3QReHY36KCrGyHTD7OtztGEBFOLscoweYJAyhw2?=
 =?us-ascii?Q?rKJlDAPqXQRnwG4ke2W1bGj3xrpdBNraGyxIIwGSsutildYeheSf9Up24+3X?=
 =?us-ascii?Q?3Jzfl7KweuCKdmEqHEUDj6olWQ59kVt1y/Gjm5YhIe3TKxSrK84yBOpbg1bF?=
 =?us-ascii?Q?FEBDeyz76PiRjO9ZlXHZSsP1dwpBlgvf5KYEevQSafThTvreL3fSJZp/Jr/u?=
 =?us-ascii?Q?YtIKQRs/rQftmEekJpfT5RB+THSHSD0/bbahznSszzi87S7zV1GADzToyOEK?=
 =?us-ascii?Q?Sgg2Gv8eyNVjJubGeWjS9TUMWomNKUmSu3oCvrqTH6Y0nIJ3yG9aQ9q6hi2k?=
 =?us-ascii?Q?8xZbllMsUlbB9OolB864AszQ9JPmTL1rl9bnH6HYRzOszUSeYO8wnF/9WKS2?=
 =?us-ascii?Q?oxwOSgZVH5xGQCbfn8DmC+qeQqN/2GbBh2X7yXGA4i9006ekanfzySybZGk6?=
 =?us-ascii?Q?GFDkDL1g1J/s8MRFYFmu3w0BDMbKu1kyejvHXf8lg/vcO5ZNhF7lARhaXmVk?=
 =?us-ascii?Q?+Hs6dvJkp4phzlDuIKH4W87MfbxD1QSTOk3zyjdqYat0AtvGmDhosbsucIUc?=
 =?us-ascii?Q?X/3FosgXnvPje/Aaw8PXHaev8d1Kd2y3vg/UHcgoXAKgTscEaDXjuftxTCcQ?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc2c82d1-3b63-42bb-ba7d-08da91b9f507
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:29.3966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hc7ssOn7npPAsbNKLtAm+EMiFBkGPbyk80DZ0Y2CjCBHCVOb+xtoSyPTuM73JMP8dxR+9AHaqlqs07tdCOC5Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support SPI-controlled switches in the future, access to
SYS_STAT_CFG_STAT_VIEW needs to be done outside of any spinlock
protected region, but it still needs to be serialized (by a mutex).

Split the ocelot->stats_lock spinlock into a mutex that serializes
indirect access to hardware registers (ocelot->stat_view_lock) and a
spinlock that serializes access to the u64 ocelot->stats array.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |  4 +--
 drivers/net/ethernet/mscc/ocelot.c     | 48 ++++++++++++++++++++------
 include/soc/mscc/ocelot.h              |  9 +++--
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 10db0b69b681..18543bee793b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2519,7 +2519,7 @@ static void vsc9959_psfp_sgi_table_del(struct ocelot *ocelot,
 static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 				      struct felix_stream_filter_counters *counters)
 {
-	spin_lock(&ocelot->stats_lock);
+	mutex_lock(&ocelot->stat_view_lock);
 
 	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
 		   SYS_STAT_CFG_STAT_VIEW_M,
@@ -2538,7 +2538,7 @@ static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 		     SYS_STAT_CFG_STAT_CLEAR_SHOT(0x10),
 		     SYS_STAT_CFG);
 
-	spin_unlock(&ocelot->stats_lock);
+	mutex_unlock(&ocelot->stat_view_lock);
 }
 
 static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index dddaffdaad9a..a677a18239c5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1870,12 +1870,13 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
-/* Caller must hold &ocelot->stats_lock */
+/* Read the counters from hardware and keep them in region->buf.
+ * Caller must hold &ocelot->stat_view_lock.
+ */
 static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
 {
-	unsigned int idx = port * OCELOT_NUM_STATS;
 	struct ocelot_stats_region *region;
-	int err, j;
+	int err;
 
 	/* Configure the port to read the stats from */
 	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
@@ -1885,7 +1886,21 @@ static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
 				       region->count);
 		if (err)
 			return err;
+	}
+
+	return 0;
+}
 
+/* Transfer the counters from region->buf to ocelot->stats.
+ * Caller must hold &ocelot->stat_view_lock and &ocelot->stats_lock.
+ */
+static void ocelot_port_transfer_stats(struct ocelot *ocelot, int port)
+{
+	unsigned int idx = port * OCELOT_NUM_STATS;
+	struct ocelot_stats_region *region;
+	int j;
+
+	list_for_each_entry(region, &ocelot->stats_regions, node) {
 		for (j = 0; j < region->count; j++) {
 			u64 *stat = &ocelot->stats[idx + j];
 			u64 val = region->buf[j];
@@ -1898,8 +1913,6 @@ static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
 
 		idx += region->count;
 	}
-
-	return err;
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1907,15 +1920,21 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct delayed_work *del_work = to_delayed_work(work);
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
-	int i, err;
+	int port, err;
 
-	spin_lock(&ocelot->stats_lock);
-	for (i = 0; i < ocelot->num_phys_ports; i++) {
-		err = ocelot_port_update_stats(ocelot, i);
+	mutex_lock(&ocelot->stat_view_lock);
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		err = ocelot_port_update_stats(ocelot, port);
 		if (err)
 			break;
+
+		spin_lock(&ocelot->stats_lock);
+		ocelot_port_transfer_stats(ocelot, port);
+		spin_unlock(&ocelot->stats_lock);
 	}
-	spin_unlock(&ocelot->stats_lock);
+
+	mutex_unlock(&ocelot->stat_view_lock);
 
 	if (err)
 		dev_err(ocelot->dev, "Error %d updating ethtool stats\n",  err);
@@ -1928,11 +1947,15 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i, err;
 
-	spin_lock(&ocelot->stats_lock);
+	mutex_lock(&ocelot->stat_view_lock);
 
 	/* check and update now */
 	err = ocelot_port_update_stats(ocelot, port);
 
+	spin_lock(&ocelot->stats_lock);
+
+	ocelot_port_transfer_stats(ocelot, port);
+
 	/* Copy all supported counters */
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
 		int index = port * OCELOT_NUM_STATS + i;
@@ -1945,6 +1968,8 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 
 	spin_unlock(&ocelot->stats_lock);
 
+	mutex_unlock(&ocelot->stat_view_lock);
+
 	if (err)
 		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
 }
@@ -3396,6 +3421,7 @@ int ocelot_init(struct ocelot *ocelot)
 		return -ENOMEM;
 
 	spin_lock_init(&ocelot->stats_lock);
+	mutex_init(&ocelot->stat_view_lock);
 	mutex_init(&ocelot->ptp_lock);
 	mutex_init(&ocelot->mact_lock);
 	mutex_init(&ocelot->fwd_domain_lock);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 99d679235070..e85fb3b15524 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -901,12 +901,15 @@ struct ocelot {
 
 	struct ocelot_psfp_list		psfp;
 
-	/* Workqueue to check statistics for overflow with its lock */
-	spinlock_t			stats_lock;
-	u64				*stats;
+	/* Workqueue to check statistics for overflow */
 	struct delayed_work		stats_work;
 	struct workqueue_struct		*stats_queue;
+	/* Lock for serializing access to the statistics array */
+	spinlock_t			stats_lock;
+	u64				*stats;
 
+	/* Lock for serializing indirect access to STAT_VIEW registers */
+	struct mutex			stat_view_lock;
 	/* Lock for serializing access to the MAC table */
 	struct mutex			mact_lock;
 	/* Lock for serializing forwarding domain changes */
-- 
2.34.1

