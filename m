Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51313F1D7B
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhHSQIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:08:52 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:64993
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233896AbhHSQIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:08:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvkAqV5/ffLeuJuM00vswkPv08P9jHB+l6p3Jqfmyz19zZf3ZZuzRigauG2RiEWSvK+Lzq/fy3sJ9WoKtUGuuZ7FuH3ir+yI1WsUTaJ1UBOFWuqfXPA8/+AOiGJd956laB/kHLUfKNqmhKhZn0mvvjnWO/VNL7Wd5oia53My9jOt6GOR23qXtM//3iD6eXCwmNGj1V8N02ZxMGySgyBv9smgoPr4VV3v/ByVkiZZjYSUgTyW6/eYjgU+AIhkIOpky2LZjG1+69owWCdK8imHR8awNLSLVX9QrraaW7DmoaocFa3Eb/SvwwK56e5EaC6hfoK3iWdPpFXI5Y1vA5RaLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7n40T/EXJo8b/Ipbn/PgFJsI7T4DH+XAd38nGHgIlA=;
 b=lX0lioDICYXk3hEI/X/EnvHdy57MtYSlSX9N19jgHAFiI4GF/E69R4+bfkaxEOeRABcM+0RI3u+Psl17gZaROzWEVKzpcv16Q5rU9L40dd1e7boys660m4BMmZ6A+SoYnE2obh4tV3h/0C/YlGNTejUkP+IHR1dtdY9F1PjCz+NRaRTrI34ujT0B8dfUym6TWexTdxzEJeaPHETR8ZOwFpCkLCifM6/jmjFcez8ivJEyXSFZGSrd4EBZFsANDMkUptemBoBg/tXOUhlxQV/B3cOpLcAD4D3pHAlVxbp8oGswLjJYXWfyTkFWg5j9lhMHS51PM7PdziycTkp6xl2r9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7n40T/EXJo8b/Ipbn/PgFJsI7T4DH+XAd38nGHgIlA=;
 b=FPi4kxGxLILXhZ3ycWfTyOLaar1YebQcykprf3REhOYDEfVF7BtSCgncsW/BoPk4WJ0xoNpf6WiJELvSBkon/P6cDUODlJvu74blq6PqmGcDFXvchP2EBN+AV4cWXKShzSgridR+1vkodFM0p339CqX04DrUrEnZXbne8/tk1XE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 16:08:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:08:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net-next 5/5] net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously
Date:   Thu, 19 Aug 2021 19:07:23 +0300
Message-Id: <20210819160723.2186424-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P189CA0004.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:08:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2ee5e8d-48cc-4aa6-fa77-08d9632b8794
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB62695088533CFB24407E435CE0C09@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkwNvdmU+jBHQlxQegNt+2+ks6ZbQpWue2VrKn6+2Ygtok4om2cWjamKIBn5Xs2ltooOEmLvyDWEqBdrxyv+WpYp59NgqBbVLJ/aCbyJV9R8IcwPIQLZtsqKb6DIG1eq3MCYCyLZ/a+AsJ/4gqb01AbdCQ86fNErK6/hz+yg1ALnQ8Aeaum+q94AITT0+/4PZ6V46B/JukxAlaF2Vcj7XlWCwCk15GvKxdswDtoiTMtJq3m05+lw2/jYps1CwjRIq2NCKVtDJ0qMV6usH3oVxNf1od+5NbV3AJFAI+Ydkk5aqFgdHcCt4QGQCSN2MUZxtNTp1tmw2ltR+rSRWAx8nl6EQMrZbenojrvrCbDpLIc7TzDvUnebpp+iT+fkWaWx3AY/SthBttDJk2dn5dqe75BruiBIT1zzrC1DgAOJP/slkH+CxImu/AHY1pISKwJzxcDsyvdRpL4gYF3kR9W8eMdghr5WTwdgsrzpqtfeKIISr5pFtsdnkuHWQsrE3aejz2UZ/hnP1Xzld5edv1asjGQn4IxL70SfU3NSYjbl0wEs3CP/lO7ZqHTDiPdMKU/Hv4ndzNjUUa4WcI0n4PAF5os3mTr5x+AAYylc2K6tYDeZoJsPbwQP1b84/FtvM5B8oVvBn3btcYnc4UZ+0V24Cx+DX307rDT19ieVRca4uc/x83KRAO8sQgeejbIRneBls6wjARBueKnP/Q1CHXha3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(7406005)(2616005)(26005)(6486002)(38350700002)(5660300002)(38100700002)(7416002)(4326008)(8676002)(316002)(54906003)(110136005)(6512007)(6506007)(6666004)(478600001)(44832011)(186003)(1076003)(8936002)(956004)(66476007)(52116002)(2906002)(83380400001)(36756003)(86362001)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k1AvpqyaQ6IQvxa8M8o8zJ6N6T3SmfGb+dBG956ofmZ+1FhFDX+8nBCDmsbc?=
 =?us-ascii?Q?GvUzoOF77nOJvkQ6nsWlFnfJNBLN1NJqAi2ULNyHZ1rece/r/p7XaDxnfnHB?=
 =?us-ascii?Q?fddIfGVbhgqJAVH1UB7hImsL98cIRpawJxh7eUDHHZXmHBmap33LD9BkZDNs?=
 =?us-ascii?Q?vGr8Hlk+11InMFF4GGX8rurKBydCpWpLDNeNfb8ZtRpeB1K0hRwA5AtpShqQ?=
 =?us-ascii?Q?3+Xc+2nZGhGdqrI2+xlN9HGf+izf5wLXS1WGv6j5ObMQr/2BKuh2p5otD9pu?=
 =?us-ascii?Q?VczKHrWTcMjIy48XGfTxW5KHBZB5JL9BxBBYo6A2GcXw1KTTl6xgq1dz7QVb?=
 =?us-ascii?Q?6C91Wur4JAtdlz86K1fZl5HLAD1b3z3jXOXC8SZ0621HuCcoDZtQeWXVlBCS?=
 =?us-ascii?Q?ru/qbhlyEi5GgEbPBEJ9O3xyyxENYTMwUh7/u/nXHgAvTrSOHh78CaoVHiEk?=
 =?us-ascii?Q?ClzFWunIg7hfa/jbYafgrVMhaBSgRgvLgqGwLTIuOHJT7dYtCJc7ARBaQQRv?=
 =?us-ascii?Q?95RUB3cBtHOLurmaGfyYou2ASmdCyCB5hDa3DOV2ePxyEASY6VVFlO1Hcdji?=
 =?us-ascii?Q?3/3ktSkhei9YxgC+EgmEOi2M03NA3/GkknOFeyt3+XF/3h9gDdvvGWWrvsT0?=
 =?us-ascii?Q?meLmtiYZY92UlZrs6LCBvY1UDpVh3SrBwTbKMFCJVMducfZs4BbusbuiaMGN?=
 =?us-ascii?Q?7NGOXAcHZL0ArVElTkGDXqh1HBqiDspOcIxxTW4KQTto12AEXwrpHLAaWf0T?=
 =?us-ascii?Q?ReDLzoGaNWtgE3lm1BLYY/DNmjSwhIgsCJ4W8+RADcH1r6RjBLyI8Yct3/dR?=
 =?us-ascii?Q?KoUqeZaRNz/9wG58jJYGVWhJ2g1eEgTSQCpSK8nKl01OF9DCxc5pwggJ0DGy?=
 =?us-ascii?Q?wSnHhXsCW7YK0CCwt+6I+8JwiXuWTtf6hIuocG9O2prP/SabiDuEgWK4qjfb?=
 =?us-ascii?Q?y1ia5qiSAAKVMNGi1qNU4asRL4RqAsAcgzNIB4bgdbbmVx2fxJ85QxQ3aj13?=
 =?us-ascii?Q?LinFMWQRl+nL4W7aSl7MYDpMMn+dpJdjzBB1Ee1w89igJAjjM/XISysyvmNd?=
 =?us-ascii?Q?6uRP2V1RdkNQH1CoEeQq4t11q5F7me+H5Z37Cxp4tZGrDBDj4whc7hLT1Mct?=
 =?us-ascii?Q?2tki6CB2rNfMcD2WSWuWBlSQw9oHOqGnBzgAb2JWoRXhGwc4PLUsl0Y5811D?=
 =?us-ascii?Q?VhKz+MuBvf+aJ5q5LH9ouk8hqVDvOPg4trOIS8WTJYH/brSpaRmwdhJZBB70?=
 =?us-ascii?Q?jt1fG/iNckYbZ3SOU/BV1AxpaXPRjy9nQMuhwB+wj4MtvxYpa4fTybtkjPY7?=
 =?us-ascii?Q?/GSyLx1tP67mQOv7Slvty65X?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ee5e8d-48cc-4aa6-fa77-08d9632b8794
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:08:06.2415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hprdHj4f5MDw0oLldzHp6UsNpX2Khs3vo5VD1jFvv7OJLBNuAA13vWEaReQ4LBGwpBmFJy9jeikKSa3di9sL9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the switchdev FDB entry notifications are now blocking and
deferred by switchdev and not by us, switchdev will also wait for us to
finish, which means we can proceed with our FDB isolation mechanism
based on dp->bridge_num.

It also means that the ordered workqueue is no longer needed, drop it
and simply call the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa.c      |  15 -------
 net/dsa/dsa_priv.h |  15 -------
 net/dsa/slave.c    | 110 ++++++++++++---------------------------------
 3 files changed, 28 insertions(+), 112 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1dc45e40f961..b2126334387f 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -338,13 +338,6 @@ static struct packet_type dsa_pack_type __read_mostly = {
 	.func	= dsa_switch_rcv,
 };
 
-static struct workqueue_struct *dsa_owq;
-
-bool dsa_schedule_work(struct work_struct *work)
-{
-	return queue_work(dsa_owq, work);
-}
-
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
@@ -465,11 +458,6 @@ static int __init dsa_init_module(void)
 {
 	int rc;
 
-	dsa_owq = alloc_ordered_workqueue("dsa_ordered",
-					  WQ_MEM_RECLAIM);
-	if (!dsa_owq)
-		return -ENOMEM;
-
 	rc = dsa_slave_register_notifier();
 	if (rc)
 		goto register_notifier_fail;
@@ -482,8 +470,6 @@ static int __init dsa_init_module(void)
 	return 0;
 
 register_notifier_fail:
-	destroy_workqueue(dsa_owq);
-
 	return rc;
 }
 module_init(dsa_init_module);
@@ -494,7 +480,6 @@ static void __exit dsa_cleanup_module(void)
 
 	dsa_slave_unregister_notifier();
 	dev_remove_pack(&dsa_pack_type);
-	destroy_workqueue(dsa_owq);
 }
 module_exit(dsa_cleanup_module);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b7a269e0513f..f759abceeb18 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -125,20 +125,6 @@ struct dsa_notifier_tag_8021q_vlan_info {
 	u16 vid;
 };
 
-struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
-	struct net_device *dev;
-	struct work_struct work;
-	unsigned long event;
-	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
-	 * SWITCHDEV_FDB_DEL_TO_DEVICE
-	 */
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
-	bool host_addr;
-};
-
 /* DSA_NOTIFIER_HSR_* */
 struct dsa_notifier_hsr_info {
 	struct net_device *hsr;
@@ -169,7 +155,6 @@ const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
-bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b6a94861cddd..faa08e6d8651 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2278,73 +2278,18 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void
-dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+static void dsa_fdb_offload_notify(struct net_device *dev,
+				   const unsigned char *addr,
+				   u16 vid)
 {
 	struct switchdev_notifier_fdb_info info = {};
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-
-	if (!dsa_is_user_port(ds, switchdev_work->port))
-		return;
 
-	info.addr = switchdev_work->addr;
-	info.vid = switchdev_work->vid;
+	info.addr = addr;
+	info.vid = vid;
 	info.offloaded = true;
-	dp = dsa_to_port(ds, switchdev_work->port);
-	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
-}
-
-static void dsa_slave_switchdev_event_work(struct work_struct *work)
-{
-	struct dsa_switchdev_event_work *switchdev_work =
-		container_of(work, struct dsa_switchdev_event_work, work);
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-	int err;
-
-	dp = dsa_to_port(ds, switchdev_work->port);
-
-	rtnl_lock();
-	switch (switchdev_work->event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
-						    switchdev_work->vid);
-		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-			break;
-		}
-		dsa_fdb_offload_notify(switchdev_work);
-		break;
-
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
-						    switchdev_work->vid);
-		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-		}
-
-		break;
-	}
-	rtnl_unlock();
 
-	dev_put(switchdev_work->dev);
-	kfree(switchdev_work);
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev, &info.info,
+				 NULL);
 }
 
 static bool dsa_foreign_dev_check(const struct net_device *dev,
@@ -2369,10 +2314,12 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 			       const struct switchdev_notifier_fdb_info *fdb_info,
 			       unsigned long event)
 {
-	struct dsa_switchdev_event_work *switchdev_work;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	const unsigned char *addr = fdb_info->addr;
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
+	u16 vid = fdb_info->vid;
+	int err;
 
 	if (ctx && ctx != dp)
 		return 0;
@@ -2397,30 +2344,29 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (dsa_foreign_dev_check(dev, orig_dev))
 		host_addr = true;
 
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return -ENOMEM;
-
 	netdev_dbg(dev, "%s FDB entry towards %s, addr %pM vid %d%s\n",
 		   event == SWITCHDEV_FDB_ADD_TO_DEVICE ? "Adding" : "Deleting",
-		   orig_dev->name, fdb_info->addr, fdb_info->vid,
-		   host_addr ? " as host address" : "");
-
-	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
-	switchdev_work->event = event;
-	switchdev_work->dev = dev;
+		   orig_dev->name, addr, vid, host_addr ? " as host address" : "");
 
-	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
-	switchdev_work->vid = fdb_info->vid;
-	switchdev_work->host_addr = host_addr;
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		if (host_addr)
+			err = dsa_port_host_fdb_add(dp, addr, vid);
+		else
+			err = dsa_port_fdb_add(dp, addr, vid);
+		if (!err)
+			dsa_fdb_offload_notify(dev, addr, vid);
+		break;
 
-	/* Hold a reference for dsa_fdb_offload_notify */
-	dev_hold(dev);
-	dsa_schedule_work(&switchdev_work->work);
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (host_addr)
+			err = dsa_port_host_fdb_del(dp, addr, vid);
+		else
+			err = dsa_port_fdb_del(dp, addr, vid);
+		break;
+	}
 
-	return 0;
+	return err;
 }
 
 static int
-- 
2.25.1

