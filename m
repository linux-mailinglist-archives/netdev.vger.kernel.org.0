Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052A34B5E49
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiBNXcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiBNXcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:17 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD3B107A94
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4kP7VZ03Kx7/1WW4zE3QWony53jF6V2W7FRY+0BSCNXv8pcTd7JLeN7EDdbZWOXpRuTaQ1Xff/7BKDhvMp5rhk8Qob3H53cGEsRSA3Ize+P6BGLTZtG84xzHmUpbsquBXu5OToHrZuhTYUYfRFE4lWfyfWepqBXkOR93xK825fir8RB4Q1NGWfm1Aj9Jo4xvF4ptAhItbMrTWxM7EgoR7YlJFEa0LzYP3MwE0iM+2KB6E1tCh2mxiF7ZqX7Vztm8Xp7QnljPnRaoEJSrGNXQ5GDFPuSPenEqHTNcyOx1BsGUc2XvB2xxmZSZyMXpULmg3VOIGgtaZsOjPX0Yx9+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWJaCd8Rj5X/mtYn317sh7HpOrQN41YUIDymOIOm+sQ=;
 b=U3EJYx000oG0ZZEtP+4tENtlZYEpxFLMK1KSY4RpXQ4ZGdm/KjQCZVju/0/lCkiPwcvmEESLkkxs6rn/rqVooFpCXTVxkFvdMyEKCETMFZBAfmwMXJNPtjzHijUMWf3pOQFy/YXFDH52NvSEEsM52qaaMTbIemqz/q/RJLMZ0XnK3Ots4qn0nQTOocZ2a1wvfc14oRkovKhfI8cL9MYdwiMfQWF7qVgWEKVftoob7mDrEqau5ZtJbjJLO5zKOfdQavN0YZsOT0eQrdmUiNRrWhNYTyAW5agIt5t/UasQ6T/AVWQkB0E5fabTUtOs6kEfm/dS0cBwa3kweQCMDFdLrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWJaCd8Rj5X/mtYn317sh7HpOrQN41YUIDymOIOm+sQ=;
 b=WnmDaVdLFGg17WOYuEht1iyrPcr7K/hbpky5y2iPTp5ZuKgKxi6nVfzHJ6Zo+dpOqkSXfoOdxWunhjDdpPXKmFn4URKKy9JWmCvfPJT5L3vvDk+8hM87TY+mx8zF6BF9ZnbDhDUi6HypkPlkfO2Pvx3bWERFIpkNsRWhghmDymk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:05 +0000
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
Subject: [PATCH v2 net-next 2/8] net: bridge: switchdev: differentiate new VLANs from changed ones
Date:   Tue, 15 Feb 2022 01:31:05 +0200
Message-Id: <20220214233111.1586715-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e46670c-1258-49e4-0ad7-08d9f01235ca
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB550462AAF2BE81CEFC7FA5FCE0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GP7fSg4mOsR83c5eRYCG66+LhbAA2g/D3aH3tbYR20Wl7gPH228tLFzAf8VFe6DjMJ8YsdK8t1Kor+tT/ObNKpYe1TPmjriDPhN7RB8MAdKBb2/IxUznElGdaveDNJw8UpIaZdeVXsXw/yYB3uwVYRnnkxqAGpKd+YvKXtTS7N/y3+s6hWeWn7uhK//lrv1O+d2NjKezJDacKO6knSS+IfeAxFvfVkX9T8ptlLmINB4D7aSSWuCDD+J5JRN2RjGbJS1S5LR7v+UVJZPZEPibnEItsm/dUsJHWF6zUt4VRGkWg9d3tZ9XIypVVRVAd2kCfmBSeUcNryz9BA378r2gKbX/i+1fTPnJ+1hlQJFVlv32xcB/ERhqZPdtaocaAKYHHrUHW3QDLvs6cHGya4BzF9AsNdCyhUCpxDTM2SaEnht09w8t/++fBCk5tJZ1X6uEE4izY+2d6LORPYnXH/du23E3oJfG1cDtMRTeQNfqgOJvkYb+CTaGWII6GVwE/l1spmtTgFj6GNKYSmwsD93ROLJgqPRCDImkpbeoIgrsO5T4gIGWI+Zgwy8W/3xgYb5dmejGh2xWyJef5DzWZKPZ0P08Oaa+hxTePpN752Z+PHaNv2A8H1F/DA8t0v1GQAglXzA14vLKthEDikauWEHnq05FJHlDeYala7lchJqPDCpi68mCYFgdVgEKeV+l1EcvEW/Ub13sDWBHn+Cqw3mYMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6506007)(52116002)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q4XF8D8mmgkXrwLXu9KHNR+49EsdLxAz3aIZ3dNnnIePvOSYS/+/ezZTmda0?=
 =?us-ascii?Q?1vRVdjvsdLfVNUkJZP0Ig5sEdYh8i5MYB48MZ2kreDkVS1zWfY/rHSCKyaWD?=
 =?us-ascii?Q?6jeFmpO8uEshk1Ddyjk+8K+5OESHHcCBsxxoDjLp7MuG/kLJvdPCJMR5T+iq?=
 =?us-ascii?Q?/UWU5ZQCPzoTJxwC+4TcjRxBvnn52Dp5l7+qak3ka+liJ2WgkQrvyD13Nuwe?=
 =?us-ascii?Q?I/KNLorxTqYzgtFZ9AUnyL8TA5CyY/VZVoYtxSTY3Midnm/TkVMF2rGCeu0a?=
 =?us-ascii?Q?5yOCJYSQYrnA7cVLCyquO66veBUZNsyYPGxD6O8NyI+SMgKXMVIAi+yBp+q/?=
 =?us-ascii?Q?gYA1oRso2z+u105ARAOrqJ8qGRgTOWnFxS1GU7Lp0LBYNB4q5gOW+dLyrL2N?=
 =?us-ascii?Q?HjR7hxCfsbqAi8y9FVMXX8rPePS3iBAb4SN5oXtAmLd0bihBp9iW4eMVROoR?=
 =?us-ascii?Q?8Z3bKwbhPE50tjokJBM2BwAuAHPRvPg/tMu/fGD9tt6kZqaUhcn0dUkTjmry?=
 =?us-ascii?Q?Kv922IT7/crvURmvJUUe75WQi5zu7Ukgh64eQ9uriC6U6+Kj48Mt6xo1xGSz?=
 =?us-ascii?Q?QTBYbrIkILL2twZ6JUTODXJXTp4ZRR2n33S3BiAQWxGn/kgGnCBEOdtyfSUG?=
 =?us-ascii?Q?VDYzv5oXdMqXKrxH/4FsIAm9RtCekWdTl9W4KN1nmHqX7ZFKJtALcMfiwwFB?=
 =?us-ascii?Q?3jS+5lYDtsUSzmAG75WByD1dOsJq9JWiLni6ds2MKJcxMf9OUhe97i+qvHC0?=
 =?us-ascii?Q?ATJ3+tjE4dCDXb1B7SIWnaEicxWguJSH3wSRd8mD0F1BxfsMXHvusYhQHTLG?=
 =?us-ascii?Q?vLC2CST2vOMSDKu0G7RAdk8h7lu7tieZbMtS9XV7J6uw4EvTRKWzwLWKbll/?=
 =?us-ascii?Q?CTlj396C3zappCpfChz/zegDXrK+nYRJ90vrtfQ20d7FE4XLq8t5i/clWkka?=
 =?us-ascii?Q?Zo3I4D5muJMw0D688DNJWTqKT/7xf/L0CyEt9S6Wiy757N0mSt9Q64IQSJiq?=
 =?us-ascii?Q?Ajjqcp8BNIP+Zh5rFIR6a7KWF+w2NHjBa9CHZhOrc8RFT6wofDKEw9rPEG7C?=
 =?us-ascii?Q?E2RQvw/uf4gtcewGHM5n89l66yI3UQBTnSF1X+gWxyHbNWF2LU90Ym6DMb/z?=
 =?us-ascii?Q?zBqHJEydTOD//Z/qozkOsprHf8SI1dXEP00PyFmwbIOyAAL7mWF5xQ485JZq?=
 =?us-ascii?Q?KSgB0qKD0LZIlv57PmiauSGPX7oQmx4iW8QDZ33QYw12vuo4j4Cn3VIcTOZQ?=
 =?us-ascii?Q?alQ/RH06WRC1YvF2nXLWYdSv3Tg+iRA3jF9j9Nxa2ynNzaomUzq30RkMNQQN?=
 =?us-ascii?Q?OnJgfhrcfCfyoCPICMg0f/4kO3YcE+OuJm4RXzYa/WNXP/+WTD2ncgU7aMK4?=
 =?us-ascii?Q?7bgyF8S2P2aU3Ub90ABjVv+wHO4cpzbgNZEU0KKYw5nRRg0unVNPArvFnn5l?=
 =?us-ascii?Q?LAgWG29CyOO9T7mreeFCmp7l57sCyPD9CEWkMbVpUY8uOMxymh78Cq1QG13n?=
 =?us-ascii?Q?LB0z4fMFcfUaKJEtdw2KkOpcxOKEQvEnnFnLlwv9Vb382GJbhSlY/SMAaDKk?=
 =?us-ascii?Q?4f/VhhjFLDgeaYHWEr7y/sGdrvA85fJypxuKfpWtLF+0h1hm/d0HgQ5NNZGe?=
 =?us-ascii?Q?DD8A8p6KVQ66bR2r6OkXkkQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e46670c-1258-49e4-0ad7-08d9f01235ca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:05.3240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6usW4rd/M/Ss2lxVvKn/ZozwA8bGEFEZR4kJbhGqTNkHTQByZhQ89mLrCdX2tXc96ynifp3/E5NSPh0O/jeahw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_switchdev_port_vlan_add() currently emits a SWITCHDEV_PORT_OBJ_ADD
event with a SWITCHDEV_OBJ_ID_PORT_VLAN for 2 distinct cases:

- a struct net_bridge_vlan got created
- an existing struct net_bridge_vlan was modified

This makes it impossible for switchdev drivers to properly balance
PORT_OBJ_ADD with PORT_OBJ_DEL events, so if we want to allow that to
happen, we must provide a way for drivers to distinguish between a
VLAN with changed flags and a new one.

Annotate struct switchdev_obj_port_vlan with a "bool changed" that
distinguishes the 2 cases above. If the VLAN is changed, also provide
the old flags such that the driver can determine which flags were
actually changed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new, logically replaces the need for "net: bridge:
        vlan: notify a switchdev deletion when modifying flags of
        existing VLAN"

 include/net/switchdev.h   |  6 ++++++
 net/bridge/br_private.h   |  6 ++++--
 net/bridge/br_switchdev.c |  3 +++
 net/bridge/br_vlan.c      | 12 +++++++-----
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index d353793dfeb5..24ec1f82a521 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -79,8 +79,14 @@ struct switchdev_obj {
 /* SWITCHDEV_OBJ_ID_PORT_VLAN */
 struct switchdev_obj_port_vlan {
 	struct switchdev_obj obj;
+	/* Valid only if @changed is set */
+	u16 old_flags;
 	u16 flags;
 	u16 vid;
+	/* If set, the notifier signifies a change of flags for
+	 * a VLAN that already exists.
+	 */
+	bool changed;
 };
 
 #define SWITCHDEV_OBJ_PORT_VLAN(OBJ) \
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2661dda1a92b..633cc048c590 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1985,6 +1985,7 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     struct net_bridge_port_group *pg,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
+			       bool changed, u16 old_flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
 void br_switchdev_init(struct net_bridge *br);
@@ -2052,8 +2053,9 @@ static inline int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
-static inline int br_switchdev_port_vlan_add(struct net_device *dev,
-					     u16 vid, u16 flags,
+static inline int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid,
+					     u16 flags, bool changed,
+					     u16 old_flags,
 					     struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f8fbaaa7c501..f36f60766478 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -160,6 +160,7 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 }
 
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
+			       bool changed, u16 old_flags,
 			       struct netlink_ext_ack *extack)
 {
 	struct switchdev_obj_port_vlan v = {
@@ -167,6 +168,8 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.flags = flags,
 		.vid = vid,
+		.changed = changed,
+		.old_flags = old_flags,
 	};
 
 	return switchdev_port_obj_add(dev, &v.obj, extack);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index c5355695c976..6f3ee4d8fea8 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -105,7 +105,7 @@ static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
 	/* Try switchdev op first. In case it is not supported, fallback to
 	 * 8021q add.
 	 */
-	err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
+	err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, 0, extack);
 	if (err == -EOPNOTSUPP)
 		return vlan_vid_add(dev, br->vlan_proto, v->vid);
 	v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
@@ -297,7 +297,8 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 		}
 		br_multicast_port_ctx_init(p, v, &v->port_mcast_ctx);
 	} else {
-		err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
+		err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, 0,
+						 extack);
 		if (err && err != -EOPNOTSUPP)
 			goto out;
 		br_multicast_ctx_init(br, v, &v->br_mcast_ctx);
@@ -688,7 +689,7 @@ static int br_vlan_add_existing(struct net_bridge *br,
 	*changed = __vlan_flags_would_change(vlan, flags);
 	if (*changed) {
 		err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
-						 extack);
+						 true, vlan->flags, extack);
 		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
@@ -1266,8 +1267,9 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 		*changed = __vlan_flags_would_change(vlan, flags);
 		if (*changed) {
 			/* Pass the flags to the hardware bridge */
-			ret = br_switchdev_port_vlan_add(port->dev, vid,
-							 flags, extack);
+			ret = br_switchdev_port_vlan_add(port->dev, vid, flags,
+							 true, vlan->flags,
+							 extack);
 			if (ret && ret != -EOPNOTSUPP)
 				return ret;
 		}
-- 
2.25.1

