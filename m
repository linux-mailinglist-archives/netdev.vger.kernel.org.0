Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD12443A680
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhJYW1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:48 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:7454
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234007AbhJYW1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVobLvf8mnjb+ZgOfUzsN7mC08M13OlGILWof4zDCvgNifpjoiMz/+yRP4jlZAzbb7zjrFxI0tF6fTeCZYPvUb6tQKkGvhOy0xeffPzqIf9i5/R660pBzmRswkAe3Y/UTc5A5nZNOHdoWaZRO4ywUQAb13Ir15xav1tRs+ng45LZuY5U8ZUm+zn/xVRGmJO9nP8fmUFDJWFR3n11oNqgacQxcSXhjTG4ivqUrtPnnNtF/jTBwVpaBQmoEHRx0+JTAXe2MNk7QHQVY8TESxCP0om/m2yySmUkMK7BtPao42FpunzSbb6nAmnvUCzg3kmv6EWXlZTwugI/Mzhp7Ui37w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LItZF0TwQ6OmHQ+2NaK5WYdjq58N8qLnMd4D39tOjg=;
 b=kqeaBry1w15V3D0N0YNhBW5xCRvIrClQ9jYXBQb2FWDcwEQc0jwUcv7J5bqLxJ9yF+iiBEgxT50ytnulPEUSsOx/Oi7zAhsoRdkY+aIMHSetT/pd26qw80po1r0Zp1C5zUjWKd8KbgJhZJFZWEt6O0CnJDVKSLB13TJlhuCKIAtjlpN4SKDsODuEZxRI8Myh30RoDJUGq7UTGmAQhdxE9w/PeZP/c+MmvTH4XfKbYsC4P06jjfmSyz7u36a9CDyyFN0hOGj7+z1YMN5c0EX93bvRfPuwTj7LT8lNJblVNQV3Od3x6Jb7liRTXb3dEAPQd1UXSm6pswgJkPTqggF5ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LItZF0TwQ6OmHQ+2NaK5WYdjq58N8qLnMd4D39tOjg=;
 b=QLPTkHO7HWQzz62kxd69cGbbQHrSGt/Vm495zELS00i8eD8GplYaC/8Zn3MgN9KMvMVUC1alytraMnLLItnEKeVaoZbuuMmA84PIl38LWFS6fv3PM3qddvMbyJ0viEEpG5a9XKNlmP0es4Q52dbf9O73FvHYqUc0Y2EAibPawCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 14/15] net: dsa: propagate feedback to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
Date:   Tue, 26 Oct 2021 01:24:14 +0300
Message-Id: <20211025222415.983883-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7f453b7-0ee6-4775-8e72-08d998064023
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB230454861741657815F32F8CE0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: moVt2mMgOUjY65cbwtiRu2BcDIa/pzz6ljUxNvmuDtxRCnJgVeGy822AiGTHvTLirm2TVjN8JF6BfgguMxlJ3QMqDWJ9ZGIvMt3BQgfv4RugfNN+dxpCuKhDxVRmkis2WlPSIUKTmMXQAa9qKbmhcufsHguGXbqUyt0U0hI6Em36ABZ8hmpkrrHBuEPfh/gpunIKCaU9OV6/qLW2m9Ku8y8l1TalB0nuQHucsYiQxwfgSWpN2ncBuUw691m27xQPIaKDKm9Obsjx+dztua6EkOMB/uio7V1VPH4j1iYI1FzVsm2r9fRMaNWwN/VoMLB8Lygs/jAZnIOei51+8Sv4QtPO03weGU+ySY01X3Ex1r9652RVwxBQNviPNABk9hzWyReeYBVqta/U05SuRcHW/edtuT/Fb8VCeCjAs5AiHwoljAnnAWbS60Ioi1cxmn8RuP3fBccCnAAviiUnTv4PFWyzv/+a4xVgiYEaoXEIvxMyWZbSiiZp6mh0zkqnE7k49LamP9CicyXl3gmFXvGhdsYXt9zE7Acm5I9RBlUqbY+CnC4x6oZpfCSNh7hKBfL3tOhWstutgdW7iOFss3Gd04zuDi0HUkJxNoA/XL17L+0nteogJaecgNtNitx+lLouO2ZpFK7YPm6DoQc7a93O58M4K4tEuRm4pFuT5aDYr0kZf6YfFRxCnNZeckBqBF6j+z/QkHiPvlXOVVuzBKxwOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?avBztsCZHMXJENrxcj97+aO5EKh63QQ8sMA7qmWtXc/pFLFvGk2wMsqUeszZ?=
 =?us-ascii?Q?8HLePBxMNMJB2jjaVfsAcQYrEwb35RpEwDBgehOtLM7gOoO8eQuW7W7ffEWJ?=
 =?us-ascii?Q?DoCtNiBA4sLLXUs6/kecqVvNLfizvq/gDfjo4fXiaYb+7uLOlh5LAYkf4CMp?=
 =?us-ascii?Q?rwL9A2KxCWvuCJafSPTybatFi0tmhOjfw3kx9wNLRbP1MJ3Sjl+5DTr9ogV1?=
 =?us-ascii?Q?A1Tmk5r+cA1u6cGBT+7s41trTBqevrdnLMdmjKVPCzTAZo81P2GfUzPNKmCc?=
 =?us-ascii?Q?hH+iwWNXTdB/LdjhnAT0nQ+3+qOLK4IG/Xu7JWWQAIdqUiKYmj7q+guWzuLw?=
 =?us-ascii?Q?UHkKwizFi3YKPgsJH8r4pJPlUIwnarVOebpG4+yGlKU+9G1plMbSpqMx6viK?=
 =?us-ascii?Q?a7nq+qdWJ71lGd/KuNpDN9NawpW/Wket5h8R+xcFEkBm8ljlWmwHAKKG6RQr?=
 =?us-ascii?Q?kGGkXQXdSlKJQ8kzmyxb8Bt5z6dihmFZtuDLcNlsDHW1AevU2lZ/kn5WAMB+?=
 =?us-ascii?Q?9oiLi+P4/yAsqzVSMNmstbYFUjsyzubgcC63oUmBHV4kVudT0chnUniL7LPO?=
 =?us-ascii?Q?kdewbn96WUzFXj+MG74X02pZdHAorL6BwQ0CKs2ADn4T5/W7rlVfbAhv9bt0?=
 =?us-ascii?Q?wc/pxGeFSq7DZEEi6YG1rVvaBJ3hCqdm7+olCEtc6V+Tq2srx3pHONHWsRtm?=
 =?us-ascii?Q?WAfCQR183SGgMKO47uR3Z8rYoWnI38jMI4vErbT9Fyvd/AFnwSAmBntBH6tw?=
 =?us-ascii?Q?QG8zvO/uVGXq7OaE0EYJkj0Vwr4BdgfZw0qUtrEheugIel9tlp9X+wk2RDnv?=
 =?us-ascii?Q?TVX1FYpUgKQm8HZsqiLCjn2AcCy+Whmmy2QC8x6ZDCT0jnvgWsMiKsj4PdqC?=
 =?us-ascii?Q?Y7w/IVzgLP7wBXwyUgyJauAV45J/HNASyPHh+ClGFyz3piZz9ZTaStHsFPqk?=
 =?us-ascii?Q?/uq3RY1eYpr2VlAQ9o3+VovFBe8VB3Bx6ud0MjmPVMSJzLIuIk14oHAZ4bPt?=
 =?us-ascii?Q?+UFW/DeA7/UGv8Og/2V7J+q4yTfl27ToocWK3erA2Bc9XfmWYgCY9tM835Sa?=
 =?us-ascii?Q?bJ+Rf41R4oZujUdolYb5CaFKz+SFoWDQWBaurAG0JLvJIOS6YVJTvPbC/h/3?=
 =?us-ascii?Q?mo6kIIOjF6uFniiEDvKZx4JUGHM9LwMVDc5e0qDBj/2uJamNSpSygNuSPaYE?=
 =?us-ascii?Q?+dks6OJyK4S/9GbXR9CH/Q11jJH+5sIOp4P6sJWLkd9PsTsWL5QpY5TSpPf7?=
 =?us-ascii?Q?Z/j2FzXeJeDii1td2GM2EeOcT1+0Cx/SKis4HRxcErCZDjhDibWlqyCGJDG5?=
 =?us-ascii?Q?mGhH2RwXpmw18MPzQOFgOlc63deJyNVVmrg1AY/ECDFtsUZKIzefywNUacTG?=
 =?us-ascii?Q?4PS2q+HoTAd5BVRAu63/7WiUpSfcadz4OC4ZtpLeoHFFw75dA1uv7txCggnZ?=
 =?us-ascii?Q?tuoFeUCphZGbRIU8oZ0gQJ2FcEuqebbeCY0J65Bi0DL1oRqsgKL4jJ7ezFsC?=
 =?us-ascii?Q?nh/+1YNCXK+9/wj8flh8MbAmhxVitz9FX7oeLgN/NAFgESTO0SDEqnzCIyFU?=
 =?us-ascii?Q?Sa4V71n3aqPWd1tFcTgcocl3edN7PPuCfajOos6lUFfDHVQl9hR68H2eXbDh?=
 =?us-ascii?Q?AujsaSrdlEiWG4AwN+Pul/8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f453b7-0ee6-4775-8e72-08d998064023
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:46.4052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgwibABlu7VEFZ0KX2Rgq2DCPMj1rsVNOj3y7MA/xH3cnBUm0PMXdnFTdaPBpm6bqhXNLU7uiB8nWf1yxPItMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strategy is to copy the entire struct switchdev_notifier_fdb_info to
our deferred work, since that contains pointers to the bridge cookies
waiting for us to tell it how things went with offloading the FDB entry.

Now that we have a full struct switchdev_notifier_fdb_info in the
deferred work, we can use that just fine to call dsa_fdb_offload_notify,
although that is not the primary purpose of this patch.

The shelf life of the cookies is basically right until the point where
we call switchdev_fdb_mark_done(). Since that wakes up the completion
and therefore the process that called into the bridge, it can just as
well free its on-stack data structures, so drivers can do nothing
(safely) with their struct switchdev_notifier_fdb_info copy after that
point.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  6 +-----
 net/dsa/slave.c    | 42 +++++++++++++-----------------------------
 2 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a5c9bc7b66c6..5d3f8291ec7f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -131,11 +131,7 @@ struct dsa_switchdev_event_work {
 	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
-	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
-	 * SWITCHDEV_FDB_DEL_TO_DEVICE
-	 */
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
+	struct switchdev_notifier_fdb_info fdb_info;
 	bool host_addr;
 };
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index af573d16dff5..1329e56e22ca 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2388,66 +2388,50 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 static void
 dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 {
-	struct switchdev_notifier_fdb_info info = {};
+	struct switchdev_notifier_fdb_info *fdb_info = &switchdev_work->fdb_info;
 	struct dsa_switch *ds = switchdev_work->ds;
 	struct dsa_port *dp;
 
 	if (!dsa_is_user_port(ds, switchdev_work->port))
 		return;
 
-	ether_addr_copy(info.addr, switchdev_work->addr);
-	info.vid = switchdev_work->vid;
-	info.offloaded = true;
+	fdb_info->offloaded = true;
 	dp = dsa_to_port(ds, switchdev_work->port);
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
+				 dp->slave, &fdb_info->info, NULL);
 }
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
 {
+	struct netlink_ext_ack *extack;
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
+	struct switchdev_notifier_fdb_info *fdb_info = &switchdev_work->fdb_info;
 	struct dsa_switch *ds = switchdev_work->ds;
 	struct dsa_port *dp;
 	int err;
 
 	dp = dsa_to_port(ds, switchdev_work->port);
+	extack = switchdev_notifier_info_to_extack(&fdb_info->info);
 
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+			err = dsa_port_host_fdb_add(dp, fdb_info->addr, fdb_info->vid);
 		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-			break;
-		}
+			err = dsa_port_fdb_add(dp, fdb_info->addr, fdb_info->vid);
 		dsa_fdb_offload_notify(switchdev_work);
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+			err = dsa_port_host_fdb_del(dp, fdb_info->addr, fdb_info->vid);
 		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-		}
-
+			err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
 		break;
 	}
 
+	switchdev_fdb_mark_done(fdb_info, err);
 	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
 }
@@ -2516,12 +2500,12 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
-	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
-	switchdev_work->vid = fdb_info->vid;
+	memcpy(&switchdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
 	switchdev_work->host_addr = host_addr;
 
 	/* Hold a reference for dsa_fdb_offload_notify */
 	dev_hold(dev);
+	switchdev_fdb_mark_pending(fdb_info);
 	dsa_schedule_work(&switchdev_work->work);
 
 	return 0;
-- 
2.25.1

