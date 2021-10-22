Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E9A437CBB
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhJVSqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:54 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:9427
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232296AbhJVSqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOc3/fCit6/IaZEZRIoCQJfcaW1kAKXLr3q2N8j1iM6eP4/Xv+bpLPkkkNYfuCv4v8WA8ZWS2tmC+YK79k0OTIxyAjuR3BqivhFtWQ9Mmb/d1kp+VpfF/PIYX3PGbaSC+NpPLKNfp1lV+6tA20lbtX8putL80gK01weIkR5QUJNWPswo+Sj3JHemP4PgP+SfpZDcYk7l5SeFrO+SXcLV5BudIxFyhs6tvGDWp0yXBMf/mhXl+I1ap18a8Q3iUDXFMd9NjBRwgbAdqixYlK7aTm9DibG/pGZ0RjWxuni58MIA5ymFz/rlh0eDXchmQKbtqSU90p5iukUP5wYhxJ/GGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gstyh8iE0GJ5B7sZF/bRFIzSFBHwM4f1o/Pm79ZRtDw=;
 b=O3UZx6AOtXBYmJVuIqkE1kEE1ImgmSoZ492GRQKCkVZ6/RzcIv2di70vjiRbANBiHmHoP92yxZtBwL3og9aOfPuzsi5lDp7LVHQOCMtRJHlkGaUx1qRax4VH8xoJ9QE2dOZpxkUWTsimvSfbFxZu+T3ZdgUElbvN5fKGxL2ta/6QpZrwIWkGHvxiUYYpWdkRZ9NVKBSZCGFnVfmiEMBX+2YAOpv2F4j3o0HZgT2zrSem0hgFoYz3hAdqO9N7/ND9tDSRkWbOJhPjaahcvck1ge1UNUNnygo6dwewkEWpbKqpXPnJmSWD0DcZaHqwDu3VGuFbxn0f8YzMshrypdOifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gstyh8iE0GJ5B7sZF/bRFIzSFBHwM4f1o/Pm79ZRtDw=;
 b=PDKZ4K7BTrNWCsNKiB8+1QQ1UUUj34bX2sDx/9O5c/Uy+nVRNL+keHlP6w8snYakDzbUmMDB++CkPqPwqhYywsOiv+Oc+THU9XmYLmIQ/+NYW4Xr5G8VtSnKehzO4E5So5FuFGlySlXbZu6VQhXSOCVGm/4F6guCuxOmATXhU9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v4 net-next 6/9] net: dsa: introduce locking for the address lists on CPU and DSA ports
Date:   Fri, 22 Oct 2021 21:43:09 +0300
Message-Id: <20211022184312.2454746-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 813467d0-b6e0-4a26-7453-08d9958bfc66
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862489E090041EF8D24BC8CE0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5IICkUNTIpeiZ/eVT1nFZ3e0YDqR9RxqThSRCJDxyl/WcPVM0J+OE9DqDB9MnKELjSVvBZXNXyUFoEeInzkFVBmZfyoXD6FeAsBP+oIG20xdZjV9H/HXRddSnCRT3Bp6yPLTMAvBTsu84I2/nZRjmhfXzsAi/aPJGc+5ga6fc+HeOVIBNwISGolI768yLr0yEGC4QeYbnmvvsdVXuFp89zmtWTwAr7oxjFHHnMTcaGGlrfBDbhBXnGJYzCmcPlZ0fRBZd1t6iXqRQBE4Na4/Y7DaQQQyfpOrJN+DdvRiUubuDLNVCQBD+YnCH/yFfmNrINPEHZitHBAzjdR0UqC/vBtGXRw41vZlvVcTBSJgb25IEcM+RvoRXzJCUiy0vlDqbWi4xTUHPeE1ExnWzDFz7oQigHXxPNOb25CfTEPVHoGA/+GDjod2hoNhPWxqrC98Pagorv/DuSPsjCT2SpHTlGVqMO4bEPzgWnlHgHXEFU6RuBfGnP1H/iBSIAcTum7BuANqwuL8C7IG5lH2VyRKmTzuZC3Dap0H/ARWAZtW5Gp0q7je56xl+RhiWmPG3vvvaIvq9UEyNcXlWhyg12k7gpW5bk17HnaH4/ziJFKeI+nH2STp2gkjBpJEooFROOGo5JjJZKbJtAFOfhyVMHmD5LjbB7Mo6Vq9zNy1nqzFkGUAJ9rZ2rnpUZunkwZwcnG94yPZayGv+1FF19xQ+/8Kvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y5uf14+BAmyHV88WNSvo4gZFLHWgov04I6F+Ip70bULg4H40E8eNhiOKV57z?=
 =?us-ascii?Q?yIDeLdv5GK6zWEvslZPH8YqzrrRNGIOCHG8CaSYQJsXJ1xNIvbLh2I0OsgnC?=
 =?us-ascii?Q?9JnZ0lUF1bk/COeTLUv2Dyr+/jU4/wcCWVYenj+Yw7LuXjLB/o6kZTcvPoIr?=
 =?us-ascii?Q?Yn6gxymwswxXwoYMT+QW5VJd3a8iAJP5GO0qq3FBQduiArQLpdK6P6nlzty8?=
 =?us-ascii?Q?Lx+i2+Mx7XwPYSJ85Gbr0RUWWUbXDc8Km30USwWOk3uqh1xOqxUNpVElVchj?=
 =?us-ascii?Q?IuJIccuxRD3nR/pW4DJyZMz/3R0fyf8iDFwkU3a048UcxfmLfDNFj/sHGxHu?=
 =?us-ascii?Q?DnTub81o8EM+izz9YFjHD2JaFY95U09zm4SzNqeg/J7hzd28PynxXF6eC/Qy?=
 =?us-ascii?Q?uTJcMVcEKXMSlVUXQ/UegPXrepz8ukZ80b7YJL+dLl2+t6DyU5hV7vykGCna?=
 =?us-ascii?Q?nUuTfdA08leMPAdgWEmaW8SGAbbg6C0gyZT92S4Um2lUBT1jKxRJWVjfJDPf?=
 =?us-ascii?Q?6DZCNDFfrN1ivNcTRoJ4iC3a1mLZaDiLJNzbIKQbM1wjeI4Tbg058cNXNWPQ?=
 =?us-ascii?Q?Z4/VfNR3QGZ+Xj4f/33f+yu5C0W0k1i3vJ/imj6lc40EMdykMRMFD+BPqvC1?=
 =?us-ascii?Q?C4A+rFe5RCLJ9uY16FfOmpM6WRoCDD+hxXLhjA4sE6/5eSnFoNyV8QMC804A?=
 =?us-ascii?Q?0kSWs2AghYEB/S68FjFTRPzmwctfpoW5/Y5fdcvLha6Yl8aBsqdqmTlGOWQt?=
 =?us-ascii?Q?zmEUy/Gm0PdeOiJiDEnLRqRFNOu326cBqk1z4McMLR8lAxwHKu7lgoM/oyl3?=
 =?us-ascii?Q?yQKrhVvxH/tqc3NaZPqy6KruZS6fAiPw+HLeRBR0x1o/dZYb95r8nivk5ed/?=
 =?us-ascii?Q?qxOpPVR66sXytHz3J5X6/VTam8iz+2TyhOuuDZ9U1hDFZ00D5WH/EQCUyqjN?=
 =?us-ascii?Q?ZAlxHLOUoMxsPAWFVFHd/PxXqwXx75pwMfIVRcOXjc42V2CBr7F0g+nhtABZ?=
 =?us-ascii?Q?DmhUUIEXAbxMefFOPW4hT6CniW+L9E+WvWo650wa1J8bngb/TzawvCaBa5U9?=
 =?us-ascii?Q?08eMSdVDrxsFY+peqfl4H0flMT8HcKP0i3PcLfwnG1jQOpsGzrb2aW9fCHgm?=
 =?us-ascii?Q?zjHuhVf59pGNzSNeVNV5BnL4H9n9U/iYiGIqO6G6LN4H38hiYGE7eVSQKf3n?=
 =?us-ascii?Q?R7qqchWTN5TnJrwWRZDAa+mdel80F3WWcpk1tHTrGZ0TZmkjWQGdbPbvxFIC?=
 =?us-ascii?Q?Ob2qdAFfJGIMI84x8IuEkIqnvWWLuPPq7Q+IURmDQcIiHOurU/Ya1H/uZlve?=
 =?us-ascii?Q?31X0LxnJKvY0S1rtRk1DIrAA3eAMR0U4DGmQsprugD1/dpV2Rlw7tIYNxvIC?=
 =?us-ascii?Q?m0dgPjDkayJN2O3mFdtqLfGc+2ArlkAvMaRfanBR8Ofy+5RI+FmzJkULbsni?=
 =?us-ascii?Q?QQ/eJd7mHP9pLjYRe4l0pPF0GnhUy9EG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 813467d0-b6e0-4a26-7453-08d9958bfc66
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:31.9020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the rtnl_mutex is going away for dsa_port_{host_,}fdb_{add,del},
no one is serializing access to the address lists that DSA keeps for the
purpose of reference counting on shared ports (CPU and cascade ports).

It can happen for one dsa_switch_do_fdb_del to do list_del on a dp->fdbs
element while another dsa_switch_do_fdb_{add,del} is traversing dp->fdbs.
We need to avoid that.

Currently dp->mdbs is not at risk, because dsa_switch_do_mdb_{add,del}
still runs under the rtnl_mutex. But it would be nice if it would not
depend on that being the case. So let's introduce a mutex per port (the
address lists are per port too) and share it between dp->mdbs and
dp->fdbs.

The place where we put the locking is interesting. It could be tempting
to put a DSA-level lock which still serializes calls to
.port_fdb_{add,del}, but it would still not avoid concurrency with other
driver code paths that are currently under rtnl_mutex (.port_fdb_dump,
.port_fast_age). So it would add a very false sense of security (and
adding a global switch-wide lock in DSA to resynchronize with the
rtnl_lock is also counterproductive and hard).

So the locking is intentionally done only where the dp->fdbs and dp->mdbs
lists are traversed. That means, from a driver perspective, that
.port_fdb_add will be called with the dp->addr_lists_lock mutex held on
the CPU port, but not held on user ports. This is done so that driver
writers are not encouraged to rely on any guarantee offered by
dp->addr_lists_lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v4: none

 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    |  1 +
 net/dsa/switch.c  | 76 ++++++++++++++++++++++++++++++++---------------
 3 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1cd9c2461f0d..badd214f7470 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -287,6 +287,7 @@ struct dsa_port {
 	/* List of MAC addresses that must be forwarded on this port.
 	 * These are only valid on CPU ports and DSA links.
 	 */
+	struct mutex		addr_lists_lock;
 	struct list_head	fdbs;
 	struct list_head	mdbs;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f5270114dcb8..826957b6442b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -433,6 +433,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	mutex_init(&dp->addr_lists_lock);
 	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 2b1b21bde830..6871e5f9b597 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -215,26 +215,30 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_mdb_add(ds, port, mdb);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
 	if (a) {
 		refcount_inc(&a->refcount);
-		return 0;
+		goto out;
 	}
 
 	a = kzalloc(sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return -ENOMEM;
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = ds->ops->port_mdb_add(ds, port, mdb);
 	if (err) {
 		kfree(a);
-		return err;
+		goto out;
 	}
 
 	ether_addr_copy(a->addr, mdb->addr);
@@ -242,7 +246,10 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->mdbs);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_port_do_mdb_del(struct dsa_port *dp,
@@ -251,29 +258,36 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_mdb_del(ds, port, mdb);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
-	if (!a)
-		return -ENOENT;
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	if (!refcount_dec_and_test(&a->refcount))
-		return 0;
+		goto out;
 
 	err = ds->ops->port_mdb_del(ds, port, mdb);
 	if (err) {
 		refcount_inc(&a->refcount);
-		return err;
+		goto out;
 	}
 
 	list_del(&a->list);
 	kfree(a);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
@@ -282,26 +296,30 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_fdb_add(ds, port, addr, vid);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
 	if (a) {
 		refcount_inc(&a->refcount);
-		return 0;
+		goto out;
 	}
 
 	a = kzalloc(sizeof(*a), GFP_KERNEL);
-	if (!a)
-		return -ENOMEM;
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = ds->ops->port_fdb_add(ds, port, addr, vid);
 	if (err) {
 		kfree(a);
-		return err;
+		goto out;
 	}
 
 	ether_addr_copy(a->addr, addr);
@@ -309,7 +327,10 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->fdbs);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
@@ -318,29 +339,36 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
 	int port = dp->index;
-	int err;
+	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
 		return ds->ops->port_fdb_del(ds, port, addr, vid);
 
+	mutex_lock(&dp->addr_lists_lock);
+
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
-	if (!a)
-		return -ENOENT;
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	if (!refcount_dec_and_test(&a->refcount))
-		return 0;
+		goto out;
 
 	err = ds->ops->port_fdb_del(ds, port, addr, vid);
 	if (err) {
 		refcount_inc(&a->refcount);
-		return err;
+		goto out;
 	}
 
 	list_del(&a->list);
 	kfree(a);
 
-	return 0;
+out:
+	mutex_unlock(&dp->addr_lists_lock);
+
+	return err;
 }
 
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
-- 
2.25.1

