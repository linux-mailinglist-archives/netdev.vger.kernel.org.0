Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E9502D47
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355620AbiDOPtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355613AbiDOPtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:49:10 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11698986C5
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:46:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TV21O5CrQFcUeTZ8gRzVyVoavkIwibDwIvHpT+kIDdU9H0Yw9M7/h/LzKPS3wC1wPlrQlg5PTvk4T2CyPjMJayXue8XQVjPBNjin9P1pfQqnpBCGI21kuJCOupHJqoQZ97NbpiQKktwXosmI0ysF4KWmBRk+BGReVihQ3W0lQO8zBXpI83S2yKu0Mj3XJIVkJmd0mkv0oRfn4RDFQGt7MEYdrqdLAxyeco4chQy3jKD/D6Qs7eQe8+KSwQX14c9mY5CKaVig8ZQyX9RYAw8Vgj8FmIdHzK7n9KZAHUc4YNSqi7ADdEki389X63LnMW+ic7+S+2NS2L2f7sRtkGW4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/LvsxtdSrTWt2IL6OqKGfVeC1DdRtdfEJCAXdHMYRw=;
 b=QubDZBoH5OpI8pCOTeR8l2bO6d/OAexFNgHF5uxtQcArVe5dKqwkDgCLwMkbKcEdZtO0b2xGUBKqi/arjzR0ZKVvF/ZpHzzmjDQMsxZbeQmWhRL2ME09AOx9IUbKXQsYvE10nVHm5PrW1ITDmE+z+B4q7zPT1bHISvCbwV9yMng4FeWF54J3CcnfxvTDaQZzjO9tsB6GIH7l7/Zk/jZt/Uqcpgm8yMJgnIDNy/IpjJPHwqXp8J3804v4BpLF9Z2UXpRZ5YbNq/62cBZDYM0p6LXgoTNFDcQMgvIvrfxgBS8BFDCin3rxYJ6hLnv9fUIakWd2TPmQMJi/EfkYo8fJYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/LvsxtdSrTWt2IL6OqKGfVeC1DdRtdfEJCAXdHMYRw=;
 b=qMioMKZQ5J9IIE1px+ss7UJpSRRQ4WLSpfVww6YF/ei+jf3od1tT78xT2P7mSb4WDzs1tDIOi6z3Ma+PGhPinsotPrnF/aaqGWhe0XoNvNP176q4ZZIvzYHGyd8ugAMHc+TWh49SEAVPIn1zXJZkeA+UyZ9Nj9EqBMxn59wTl7Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3385.eurprd04.prod.outlook.com (2603:10a6:7:8a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:46:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:46:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 6/6] net: dsa: don't emit targeted cross-chip notifiers for MTU change
Date:   Fri, 15 Apr 2022 18:46:26 +0300
Message-Id: <20220415154626.345767-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415154626.345767-1-vladimir.oltean@nxp.com>
References: <20220415154626.345767-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9d1b313-5c41-4a68-ad4d-08da1ef7208e
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3385:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB338535B0B1B551837E9246EDE0EE9@HE1PR0402MB3385.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZPdEL+GIE3QluGOQKm79kZkKTHE2BVwhP47GJTz9lBXW8sAKSQZi0POXgvRTnNOFThJOnVjuoOkxS1tjwSkiYKV5Tp1F7AsZXSAqJmZPEFuGm5uXw6CBuv+KmuEJ4tgu4fvHPhq4LGEG9bXqg1z/QfdEdmvSmCl4TB/2aylaCRhSdi6CFP6Z2Tvp63w9P2IJ8IPq3KZjnMpXMXyzxZujRxTzed8BtwAbiJCFPpd19sjexLOezyTCRBlqE862oYnD+WjL4/1QhWTEnI7WfzjX7NeNUAu3AJW8+2d0VDWAc/axwcwJ83O2IM+VvqfhXKHUd1HL9X53+YlKVFTfH/L2bcvWv4GNfL5S4USdHp33TAZuLwjkvs3icsjqXJxI2jKIAe/O3g22xzzMJxUAVTDRkYHocyg/QH9KLnxYorjEb2z8P/qylKlLu5iRqPJ2A39vESk3JekHMA/YX4mEF/TNXsjlGVq3Xv8oeRIUcAOmpdfj1573kkKmDsyWjYy/PySpjW7V1BymYYTXm5OEQyJrAoLqr/4npCj1U/yJ7qkJyVMES3/sc7qvHuOOMtsP9Vcb34nkT7pSHa6dO2rHYaGpgRqD2xim94MmnNMJOYncVM/7av3rGTCh0NbvnzDHQKWLzqhn6FkI8fThZvcYfr3U9zk6WidB7lTGhPqxbDpNB8SoehtJrU8RtZwTD0CjXcgr7ZWwAjn5nNzf84JVaez8Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(6486002)(36756003)(316002)(52116002)(2616005)(508600001)(186003)(5660300002)(54906003)(38100700002)(38350700002)(6506007)(8936002)(6666004)(6512007)(2906002)(44832011)(4326008)(66556008)(66476007)(66946007)(83380400001)(86362001)(6916009)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tis3YpCJ/sBxfhTYC21aqVVL72qLEGj+m2/qtwRvjjEcJSM1hp7T8NzIgD8H?=
 =?us-ascii?Q?6YI9ryDjJbHf8E3H4bL6OF9wA/kSX0L2F/T3MWHcgu3+4ct+dCSFjglNcpnY?=
 =?us-ascii?Q?EpGst3ll0q03YJH91j0CR5HsNotg5Pq0+Xk9RHoDSvI4MrdBi1aW6/lPn+Jz?=
 =?us-ascii?Q?aczTtcC9rbO1wxVR7U3fiWPSD7FYp1FxuIVAbAzkaHTLvfNI2ZJLb0KyjvaM?=
 =?us-ascii?Q?6lDIfg7nOxIAmcfKDWR+V0Zc5dB2eLDvVCPHVZ5ZGzkPwB+Y4ZRPKplgnqNp?=
 =?us-ascii?Q?4qI8Jh5sOR9SjWgRc+ME67Tu7UvWYPFlFi71UbOOWukEg+ySlOoqgwFH21Jd?=
 =?us-ascii?Q?il76dfKld1KFf3XRSgS5ydEdEM0Rb01Xu+fcS0lMrm08UypMMHWtMs4e1dBw?=
 =?us-ascii?Q?SZ6j5VxK6n+mcwxns9Y650MoRBeysqWZQxhsVHV74U4tU3QBOsId/wP5XfeI?=
 =?us-ascii?Q?xh5ActHwllwHS8Cw/tfHOop9cEeGZrjJmR3pUC/dqjmgv22dONzcCRf3sNkY?=
 =?us-ascii?Q?XIREr1qTziM4Yp2CBNHV8wpo5CLIJj4deb2f0h5/OPvrEy3lXRVA0AQMvMO+?=
 =?us-ascii?Q?ToRKcCQTrCpf98iw76mNevBPxJmIItNXATeznhpwLk57V2LakDs64eUo4KpI?=
 =?us-ascii?Q?ORuDWc7yNjY0G97k3zLL6lyvskchrh3gDjkDD2lcqLsZSIkoLeqHIscDYC8w?=
 =?us-ascii?Q?+AS863xiJBKaGT8su9QLjUmE59ApVf1F5zrx3j0GIOSh2bBPHFbA9IchE31y?=
 =?us-ascii?Q?3Ny0r4+RxkLAiFzm+l369YdXWWCBPXCvTO1cHMrxl3S6ts985Ig4z9yqk1O5?=
 =?us-ascii?Q?MS6Wuqt7/MOLkytYEOAph781krBlUt0VLkhdJCHa4JNEPreVm4xh79qosJo4?=
 =?us-ascii?Q?ZN4DiU/Uy8ZsOc8blq+hN9FSJ2DZKH7PpJ6It767xvXbiYZUCc52g8VwvtkN?=
 =?us-ascii?Q?bhbKe1g9zt+DS1GTeXQNXmROqACG50KG6y8Bv6WT2ZjSKU9n00tySks9WUKf?=
 =?us-ascii?Q?8YM5MxT6c+4Btr2+VIhNXGvkWqNm7BlSUmzluHyOPZlC4CIqWEDEi0wSTwmQ?=
 =?us-ascii?Q?f5E6OnsJshh1bEXw127hfAM4Ly6sp50aUJCtM7kuq3d+VeJ/AHxM2SlbI8Gj?=
 =?us-ascii?Q?tGJa1UGmn9YhwzBwnna8Plp60GUiYe6tSN5BYD6ppbtzSgbGApaakyCgvRo2?=
 =?us-ascii?Q?yFSpUhcn4TiiR6NuuqM5HkjlP09F0fFgE/IIS80NY/mgdlM9Atl0CfI0atoH?=
 =?us-ascii?Q?uAHg5f2nD4esJxEy2BrsQ3XUA4IZDVpvXwOe1JLCVGYPdL7ZtIB5W+8sJANn?=
 =?us-ascii?Q?zMkDN8aHbRGqGftmH3jkeK7ucBqdrGkVMydJu4kzOn8N+54qj4Twu/JVZB9E?=
 =?us-ascii?Q?90AXsXqv4o/XfJmTJsKVS/fSHUeDk853CrxfYRyrB0c1c3cDLdUfi7nQolOs?=
 =?us-ascii?Q?jcjgVeZ7+x/9ScB0H+/NwQDdTXRnsVYKpUhzhAMRkFpbBJZkRUYoe08nFCk+?=
 =?us-ascii?Q?tXBM90tUC2NnBIsO4fYjTxwOYqV/1kkHDvRemdUXxIcZDQD3mB5Hl8RL+7le?=
 =?us-ascii?Q?ULyOYah+POYss+gaB5YlVLtZ/QwBpLA7oEt5idGDXW8uwhCqjtDjFkPsIOYi?=
 =?us-ascii?Q?PSnLVC7kqnmY0jBLo/m/MG/LOtt6YKwUI+eX1SFlvw1xtqSAi6LbqhjSHP0k?=
 =?us-ascii?Q?QP1Ry6tWzscD1Ut9mRSRrF84TEkFF3SUI31eJOTuNcdY4O2CAOLBDpgslKTH?=
 =?us-ascii?Q?PXtVn3fDMD3n2oREBB4NmtrnjC2mxzQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d1b313-5c41-4a68-ad4d-08da1ef7208e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:46:37.9416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eupBFl/gBvmhZfE6zJu0uDHICD1nzzj/MTWVmcQw6M9X+16HsaZL/lasywyqfmekrIdgypE1k416gquo3E3bwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A cross-chip notifier with "targeted_match=true" is one that matches
only the local port of the switch that emitted it. In other words,
passing through the cross-chip notifier layer serves no purpose.

Eliminate this concept by calling directly ds->ops->port_change_mtu
instead of emitting a targeted cross-chip notifier. This leaves the
DSA_NOTIFIER_MTU event being emitted only for MTU updates on the CPU
port, which need to be reflected also across all DSA links.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  4 +---
 net/dsa/port.c     |  4 +---
 net/dsa/slave.c    | 10 ++++------
 net/dsa/switch.c   | 14 +-------------
 4 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 67982291a83b..7c9abd5a0ab9 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -100,7 +100,6 @@ struct dsa_notifier_vlan_info {
 /* DSA_NOTIFIER_MTU */
 struct dsa_notifier_mtu_info {
 	const struct dsa_port *dp;
-	bool targeted_match;
 	int mtu;
 };
 
@@ -231,8 +230,7 @@ int dsa_port_mst_enable(struct dsa_port *dp, bool on,
 			struct netlink_ext_ack *extack);
 int dsa_port_vlan_msti(struct dsa_port *dp,
 		       const struct switchdev_vlan_msti *msti);
-int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
-			bool targeted_match);
+int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 711de8f09993..8856ed6afd05 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -930,12 +930,10 @@ int dsa_port_vlan_msti(struct dsa_port *dp,
 	return ds->ops->vlan_msti_set(ds, *dp->bridge, msti);
 }
 
-int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
-			bool targeted_match)
+int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
 {
 	struct dsa_notifier_mtu_info info = {
 		.dp = dp,
-		.targeted_match = targeted_match,
 		.mtu = new_mtu,
 	};
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index bf93d6b38668..63da683d4660 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1859,15 +1859,14 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 			goto out_master_failed;
 
 		/* We only need to propagate the MTU of the CPU port to
-		 * upstream switches, so create a non-targeted notifier which
-		 * updates all switches.
+		 * upstream switches, so emit a notifier which updates them.
 		 */
-		err = dsa_port_mtu_change(cpu_dp, cpu_mtu, false);
+		err = dsa_port_mtu_change(cpu_dp, cpu_mtu);
 		if (err)
 			goto out_cpu_failed;
 	}
 
-	err = dsa_port_mtu_change(dp, new_mtu, true);
+	err = ds->ops->port_change_mtu(ds, dp->index, new_mtu);
 	if (err)
 		goto out_port_failed;
 
@@ -1880,8 +1879,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 out_port_failed:
 	if (new_master_mtu != old_master_mtu)
 		dsa_port_mtu_change(cpu_dp, old_master_mtu -
-				    dsa_tag_protocol_overhead(cpu_dp->tag_ops),
-				    false);
+				    dsa_tag_protocol_overhead(cpu_dp->tag_ops));
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
 		dev_set_mtu(master, old_master_mtu);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d3df168478ba..704975e5c1c2 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -49,19 +49,7 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 static bool dsa_port_mtu_match(struct dsa_port *dp,
 			       struct dsa_notifier_mtu_info *info)
 {
-	if (dp == info->dp)
-		return true;
-
-	/* Do not propagate to other switches in the tree if the notifier was
-	 * targeted for a single switch.
-	 */
-	if (info->targeted_match)
-		return false;
-
-	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
-		return true;
-
-	return false;
+	return dp == info->dp || dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp);
 }
 
 static int dsa_switch_mtu(struct dsa_switch *ds,
-- 
2.25.1

