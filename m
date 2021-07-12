Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464493C5F28
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhGLPZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:32 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235428AbhGLPZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUo8bve3Kof+8D0jSpRUe8dKum/zIsU0VTuoxNoP6+kmzKVJcOJz3NC0w4qjxcAx7tGK3revDjtw35NjZiXLWEL0GXLrwdqImfjJ50zLUByt0+bmauiQtVo/e2qTFKMn83vdQbjpLxr5ya7mttPHhr9hGf5+z0+rkmatssTD8zPcovk31OTx9Vix6wy/7BB7KYmrb+lnW8InmJD59Z65+6flD2Ct2PQiv0QYWRmYHuEDm0ei0ZcEeA/13mdSRWiZhOK9qM6YvFNY6lo1wSaozNbu142g8mfAUaAr9BX5WMBHjkAf6rE2zvAc/KAly4DuQXqSsv4kAOXbHnWJxTGUSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2ZwB8h2us0ABt7cEto8hppA/4dpgdBopoyjYPvxdb4=;
 b=EVGHpHAIKAQwYCtJOIupm9ntOL3HqbZtpeRYgMJiQ3rPTmtdoK3XvcHd8tLP11gOPNEXLG6UYnVFntwIwSnxB/Fzs670TlMIlnLvja3tLDOWLzzya0P7DeJ72DXx0HYkf5FKoFoWYCjdEzzpbO/FE7fP2Z1QFRm8cM7ArzQSjD30D65yyAb7OVYhIdg28lhiSSkPneph0AkykObFR0KmuC8zQ96l+EaksoyFT0/LlP1P16M+whj6tvG+cEsHIzi7OLcQtTdZHYTV8zAfLoiwFeYz+U7gaFJB78DAZvPhKkdYOhmNKnRMHfjAw5S/9+p0WFGe/ach7RN1zITwaFcJJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2ZwB8h2us0ABt7cEto8hppA/4dpgdBopoyjYPvxdb4=;
 b=FHuWGCJxIoa6ocgaKZLiF7b3TLIFriOlI43fO6WpcP5MJJzXy8R2ifiYVUSznN+YyDjzbOkFQCArQ2ovEkWflk5Er1AOqy0hnd3KjC1CyY9MGL/pDxPBKNTaBddZ6uVvdUxhkWKjHP+mlXn0JORrWblHxtN9YU3VBTwcKLG4V3U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 15/24] net: bridge: propagate ctx to switchdev_port_obj_{add,del}
Date:   Mon, 12 Jul 2021 18:21:33 +0300
Message-Id: <20210712152142.800651-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 670b76d2-5dfb-4cfb-83c5-08d94548dbd6
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62711853B088464BC6CC6828E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +oS4guePqFIFFQFAoiaELSe8xVmkJTkhm4exb13MvkocP01zYfD/Jjt1k+Z3e3mlohfpadX3OA6KaK8xrUBKnF3PNDrWpM2n+XTaShjNQqDeuCWr8SdbqJsNyl+Fr6NgY/oShfa/d03Hc9g72XzU4JjkrmiJzl1sL6w2WZyEwEF8HmuUELljLuS/9i76lwc28vJCndRN6NCQpSWDQb6pamI1MAjPwFlXR0UM7gEktxm8HiZwKMAt3DQsUKhHv5AK+vihsmEI8t8yC/xVaJJdtlltREmgPyQPprQw/Z6hK7z2I+3Gsl8zSzgK8SRGvwfSjN9KTbN4rjE3uCSbKSWJ+q9ax0+LmQixqEdCAyv4bb2lkf7zzowpSIF6QJF5bjwt6Jpu/QfoD+uaHUJud4XQGRCDtcloa/ec9XRWw/TI0XnU4B2/QDQh8eJsjWZ/tkW9AkbLCc7VRFUgzfEl2dSTTpGnEg6EeKMtJlDufsVACFI5m6PsaGuozKk4ebxPhBvZU7JP/Fj5GJ0l9XvnkQyVcuMjGq9wsQ/rKngw7qL/myeI9yvHMllAM/adUxMLp/IrZKvKRWWl7heEXOFg+1MPwGy6Wm7K8l45y/dBaGC7PJ3PixQz71Dt4a3u03pDm3GGyfuOHfa+mRTDj0LG51UI/eyOGKELnaw1H8Dv3ZVcTjJPTAi4kDeBTISI++QMuezH+aiNGMlMdA3CeA6YuHwMzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?28TXNJcUZMYBCHuW+o50vxxj0qRJklqCvdyb85tDIBj7/4Fj1nmgOY9E4MHo?=
 =?us-ascii?Q?6M/ZJOkdqjKOnwfmUhTpLNoj+jyboJoSnpIQcaRUW1jnrwYjinlH55thhrJj?=
 =?us-ascii?Q?ulH8y3mlvBw6oDKYyn/SzfnyT01VYbhL5etExBgVkzRqKrvOI/V3jbscSjjL?=
 =?us-ascii?Q?NHUXGbQCMKmDgZ+BdnP5zXB6lm+xwjQf5gulrq8rIvun9v/IT5ENxBMkM4Cv?=
 =?us-ascii?Q?UFk73Eqr4PJ5Z7NOber0VUsABn4s4aGi9Kg55qJ5/+nyVaPnNpcjjiDH1MuV?=
 =?us-ascii?Q?9bcclRoLcB4XzUrVffG6yKQAqQpxy7ShQK/E4W05yP1npmaevwUBddzOrgvQ?=
 =?us-ascii?Q?59BA+MHYHyYL8akHhFnusdBaOdLcTs9/KlR1johpdmjKLzDW30iCtRnEnAb5?=
 =?us-ascii?Q?UkoPCpV48F9GTeugzNm6z2KY5/ipv7LFdYCGqW92+We+Z6nUg1wNGToFaDX5?=
 =?us-ascii?Q?6EKNAN4duYQmnydQ01PR7H30uAcMV+j2vgcjsI97MjYcQ5taenCTQI25VoD/?=
 =?us-ascii?Q?BHgJnUsNT7l3DGaT0yErqRGHI+ZK/r+H3mb7AwlU1SmLCkgRlq4EVU5/iu4d?=
 =?us-ascii?Q?rau3OsPG5MI4EUVbEXy3uJKVWLbocHlST9M+SjVt2nbX6crzc70Aw0HRJDYw?=
 =?us-ascii?Q?6bkyZdGQH0iwWLTGdmRpMgNzftKvmqirqT1tlyM+vHlamKkcLxSezdftAhgo?=
 =?us-ascii?Q?xqzWN1gfj7Hatd7A6c8jVPcOA+2aviEhi+m1jFWaifiM4Zu7jpjbIJLQozxi?=
 =?us-ascii?Q?S1aO9pucjZos9QiPA4V+k0vlkGHgUP5oM73BN4kbsJAZF+puRjBMlye/hNqH?=
 =?us-ascii?Q?7svouXLmOygISmL45lBkiOv+mRLKR0NQ0AwkWMXRNwHfRByeIvjWAMWWnMHc?=
 =?us-ascii?Q?IQhxh/Oz1tF2z8Ph4/aUSQ6H1LhxiPVorS7LUfRpT/GiHWI0TFxp/Z6pf2wo?=
 =?us-ascii?Q?8S30DzfA8HP+dZ/BEltn3nT7QXqdgygRBOcbGGTSiCgvwoCRfO4B7x8ghmJh?=
 =?us-ascii?Q?rq0q4uBFveNe535j47Ka8Ni/v0LWp1DRIxjGahlR6OTVPrNGjb+KvNApKvWr?=
 =?us-ascii?Q?vuBbeV5tWKihEbvMhAJtDX8u60TOAxCIGrWkDV8IYK7XPdc+9b99+a3cJTZi?=
 =?us-ascii?Q?vs9EyD0V1kLYma3DBBO3FspDr7EIboZ6ud3bLKYu3UdUXOtI6FdTLEDIL9CY?=
 =?us-ascii?Q?jvKYWS7iNbNRB3a7LtcvjOd4HASZJQuAkSWUrZDjot6bTfdSyVSh+rhGKk22?=
 =?us-ascii?Q?Wyp/t+ijbY2duLTFR+WvML4KDXxRbhHJwRA61oTQT6FBPXaECchiybKxm5po?=
 =?us-ascii?Q?Tj3HZ5KM8QizYpk2iEgW4mAe?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 670b76d2-5dfb-4cfb-83c5-08d94548dbd6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:27.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3kUx5Kd6fSCRda8h8WWP/ZildkamEm0OE99FIk4VOOEfg6M2yl+vUsW6+hF5OIendeptD0tNJgtk/RQXyFt6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We would like to make br_mdb_replay() and br_vlan_replay() use the
public switchdev blocking notifier chain, and in order for that to
happen, we need to pass the void *ctx pointer that the replay helpers
use through switchdev_port_obj_add() and switchdev_port_obj_del().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h       |  8 ++++++--
 net/bridge/br_mdb.c           | 10 ++++++----
 net/bridge/br_mrp_switchdev.c | 20 +++++++++++---------
 net/bridge/br_switchdev.c     |  4 ++--
 net/switchdev/switchdev.c     | 30 +++++++++++++++++++-----------
 5 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 68face5dca91..edc6670ed867 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -246,9 +246,11 @@ int switchdev_port_attr_set(struct net_device *dev,
 			    struct netlink_ext_ack *extack);
 int switchdev_port_obj_add(struct net_device *dev,
 			   const struct switchdev_obj *obj,
+			   const void *ctx,
 			   struct netlink_ext_ack *extack);
 int switchdev_port_obj_del(struct net_device *dev,
-			   const struct switchdev_obj *obj);
+			   const struct switchdev_obj *obj,
+			   const void *ctx);
 
 int register_switchdev_notifier(struct notifier_block *nb);
 int unregister_switchdev_notifier(struct notifier_block *nb);
@@ -296,13 +298,15 @@ static inline int switchdev_port_attr_set(struct net_device *dev,
 
 static inline int switchdev_port_obj_add(struct net_device *dev,
 					 const struct switchdev_obj *obj,
+					 const void *ctx,
 					 struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int switchdev_port_obj_del(struct net_device *dev,
-					 const struct switchdev_obj *obj)
+					 const struct switchdev_obj *obj,
+					 const void *ctx)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 17a720b4473f..209aea7de6a8 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -705,10 +705,10 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
 
 	switch (type) {
 	case RTM_NEWMDB:
-		switchdev_port_obj_add(lower_dev, &mdb.obj, NULL);
+		switchdev_port_obj_add(lower_dev, &mdb.obj, NULL, NULL);
 		break;
 	case RTM_DELMDB:
-		switchdev_port_obj_del(lower_dev, &mdb.obj);
+		switchdev_port_obj_del(lower_dev, &mdb.obj, NULL);
 		break;
 	}
 }
@@ -752,11 +752,13 @@ void br_mdb_notify(struct net_device *dev,
 			complete_info->ip = mp->addr;
 			mdb.obj.complete_priv = complete_info;
 			mdb.obj.complete = br_mdb_complete;
-			if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
+			if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj,
+						   NULL, NULL))
 				kfree(complete_info);
 			break;
 		case RTM_DELMDB:
-			switchdev_port_obj_del(pg->key.port->dev, &mdb.obj);
+			switchdev_port_obj_del(pg->key.port->dev, &mdb.obj,
+					       NULL);
 			break;
 		}
 	} else {
diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index cb54b324fa8c..4fb1f6c57db9 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -11,9 +11,9 @@ br_mrp_switchdev_port_obj(struct net_bridge *br,
 	int err;
 
 	if (add)
-		err = switchdev_port_obj_add(br->dev, obj, NULL);
+		err = switchdev_port_obj_add(br->dev, obj, NULL, NULL);
 	else
-		err = switchdev_port_obj_del(br->dev, obj);
+		err = switchdev_port_obj_del(br->dev, obj, NULL);
 
 	/* In case of success just return and notify the SW that doesn't need
 	 * to do anything
@@ -42,7 +42,7 @@ int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
 	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
 		return 0;
 
-	return switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL);
+	return switchdev_port_obj_add(br->dev, &mrp_obj.obj, NULL, NULL);
 }
 
 int br_mrp_switchdev_del(struct net_bridge *br, struct br_mrp *mrp)
@@ -88,9 +88,10 @@ br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
 	 */
 	mrp_role.sw_backup = true;
 	if (role != BR_MRP_RING_ROLE_DISABLED)
-		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL,
+					     NULL);
 	else
-		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
+		err = switchdev_port_obj_del(br->dev, &mrp_role.obj, NULL);
 
 	if (!err)
 		return BR_MRP_SW;
@@ -133,7 +134,7 @@ int br_mrp_switchdev_set_ring_state(struct net_bridge *br,
 	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
 		return 0;
 
-	return switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
+	return switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL, NULL);
 }
 
 enum br_mrp_hw_support
@@ -166,9 +167,10 @@ br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
 	 */
 	mrp_role.sw_backup = true;
 	if (role != BR_MRP_IN_ROLE_DISABLED)
-		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
+		err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL,
+					     NULL);
 	else
-		err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
+		err = switchdev_port_obj_del(br->dev, &mrp_role.obj, NULL);
 
 	if (!err)
 		return BR_MRP_SW;
@@ -189,7 +191,7 @@ int br_mrp_switchdev_set_in_state(struct net_bridge *br, struct br_mrp *mrp,
 	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
 		return 0;
 
-	return switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL);
+	return switchdev_port_obj_add(br->dev, &mrp_state.obj, NULL, NULL);
 }
 
 enum br_mrp_hw_support
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index e335cbcc8ce5..c961d86bc323 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -111,7 +111,7 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 		.vid = vid,
 	};
 
-	return switchdev_port_obj_add(dev, &v.obj, extack);
+	return switchdev_port_obj_add(dev, &v.obj, NULL, extack);
 }
 
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
@@ -122,7 +122,7 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 		.vid = vid,
 	};
 
-	return switchdev_port_obj_del(dev, &v.obj);
+	return switchdev_port_obj_del(dev, &v.obj, NULL);
 }
 
 static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 7b20b4b50474..bbb187bc0ef5 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -38,9 +38,11 @@ struct switchdev_deferred_item {
 static int
 call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
 				  struct switchdev_notifier_info *info,
+				  const void *ctx,
 				  struct netlink_ext_ack *extack)
 {
 	info->dev = dev;
+	info->ctx = ctx;
 	info->extack = extack;
 	return blocking_notifier_call_chain(&switchdev_blocking_notif_chain,
 					    val, info);
@@ -125,8 +127,8 @@ static int switchdev_port_attr_notify(enum switchdev_notifier_type nt,
 		.handled = false,
 	};
 
-	rc = call_switchdev_blocking_notifiers(nt, dev,
-					       &attr_info.info, extack);
+	rc = call_switchdev_blocking_notifiers(nt, dev, &attr_info.info,
+					       NULL, extack);
 	err = notifier_to_errno(rc);
 	if (err) {
 		WARN_ON(!attr_info.handled);
@@ -207,6 +209,7 @@ static size_t switchdev_obj_size(const struct switchdev_obj *obj)
 static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 				     struct net_device *dev,
 				     const struct switchdev_obj *obj,
+				     const void *ctx,
 				     struct netlink_ext_ack *extack)
 {
 	int rc;
@@ -217,7 +220,8 @@ static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 		.handled = false,
 	};
 
-	rc = call_switchdev_blocking_notifiers(nt, dev, &obj_info.info, extack);
+	rc = call_switchdev_blocking_notifiers(nt, dev, &obj_info.info, ctx,
+					       extack);
 	err = notifier_to_errno(rc);
 	if (err) {
 		WARN_ON(!obj_info.handled);
@@ -236,7 +240,7 @@ static void switchdev_port_obj_add_deferred(struct net_device *dev,
 
 	ASSERT_RTNL();
 	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					dev, obj, NULL);
+					dev, obj, NULL, NULL);
 	if (err && err != -EOPNOTSUPP)
 		netdev_err(dev, "failed (err=%d) to add object (id=%d)\n",
 			   err, obj->id);
@@ -256,28 +260,30 @@ static int switchdev_port_obj_add_defer(struct net_device *dev,
  *
  *	@dev: port device
  *	@obj: object to add
+ *	@ctx: driver private data in case of bridge port with multiple lowers
  *	@extack: netlink extended ack
  *
  *	rtnl_lock must be held and must not be in atomic section,
  *	in case SWITCHDEV_F_DEFER flag is not set.
  */
 int switchdev_port_obj_add(struct net_device *dev,
-			   const struct switchdev_obj *obj,
+			   const struct switchdev_obj *obj, const void *ctx,
 			   struct netlink_ext_ack *extack)
 {
 	if (obj->flags & SWITCHDEV_F_DEFER)
 		return switchdev_port_obj_add_defer(dev, obj);
 	ASSERT_RTNL();
 	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					 dev, obj, extack);
+					 dev, obj, ctx, extack);
 }
 EXPORT_SYMBOL_GPL(switchdev_port_obj_add);
 
 static int switchdev_port_obj_del_now(struct net_device *dev,
-				      const struct switchdev_obj *obj)
+				      const struct switchdev_obj *obj,
+				      const void *ctx)
 {
 	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_DEL,
-					 dev, obj, NULL);
+					 dev, obj, ctx, NULL);
 }
 
 static void switchdev_port_obj_del_deferred(struct net_device *dev,
@@ -286,7 +292,7 @@ static void switchdev_port_obj_del_deferred(struct net_device *dev,
 	const struct switchdev_obj *obj = data;
 	int err;
 
-	err = switchdev_port_obj_del_now(dev, obj);
+	err = switchdev_port_obj_del_now(dev, obj, NULL);
 	if (err && err != -EOPNOTSUPP)
 		netdev_err(dev, "failed (err=%d) to del object (id=%d)\n",
 			   err, obj->id);
@@ -306,17 +312,19 @@ static int switchdev_port_obj_del_defer(struct net_device *dev,
  *
  *	@dev: port device
  *	@obj: object to delete
+ *	@ctx: driver private data in case of bridge port with multiple lowers
  *
  *	rtnl_lock must be held and must not be in atomic section,
  *	in case SWITCHDEV_F_DEFER flag is not set.
  */
 int switchdev_port_obj_del(struct net_device *dev,
-			   const struct switchdev_obj *obj)
+			   const struct switchdev_obj *obj,
+			   const void *ctx)
 {
 	if (obj->flags & SWITCHDEV_F_DEFER)
 		return switchdev_port_obj_del_defer(dev, obj);
 	ASSERT_RTNL();
-	return switchdev_port_obj_del_now(dev, obj);
+	return switchdev_port_obj_del_now(dev, obj, ctx);
 }
 EXPORT_SYMBOL_GPL(switchdev_port_obj_del);
 
-- 
2.25.1

