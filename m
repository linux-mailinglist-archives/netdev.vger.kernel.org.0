Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D184846C2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiADROu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:50 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234521AbiADROh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHfAhCJ8Eqfza22cUYAaloBN+qh/vi+XYL5mx2jQaOP7rQEq7Nnh6p3c3YlS5hjHc1NPBaEj7eeGvDQ6h1snQaqyEIBR9BMWaNmigXok0qtFFhagPmGDHHNN3kAiuGg4F+RxabXK4M9do/7kuYYwNLe9Iwr9c92KtGc+Mb5SbleIko942/4EmMkh6ir93jRe+mCCKZ56u8AaBMmmiuLavxvpiYzqSmWvu5edMtBxnoJkcYpmHCXCRF6OJivFsKAUrEN97Ll8pNBhrzcZo17VemmkhC8KfsWep7He2jx2KQ7yVfMG9uh7pHWu/qJrP0AzeY2wTHfKfIhSKF4trn/lGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWbE/KHnl5jiZw6mXHQUz5y9TP5cdKiXhmEZFCqR+uQ=;
 b=U+8QjPo1/pzdp0VsGtrXBvLQ/tv2Lub0hkxkjjWCP9mJWYnUOwcR+5JWjOl8D/nZSuevIraDWc+O9YLOJ50ZqnZL490qlOmrk07Q1BxCPKs517+c7byKZeq2oCMA2cWnWp7QTjYjDCBOLlMY7uYTkngzG3/rVWJHnv+27n8e50HEPXIyqxQWYYjSI9HiE0OgSJRmLKpLWUg3jq3s9tBpkIdMKf/tg///8i01JCmhD9iJv0QHRnPL/oNCU0OaSWLoLGZzMhYZSH9TvPukXvYi0H97d27bu54eeygZIJlnz+/fRPUcWyTkBuJb4jXis4ouucaTyYyfudtA2JcoxGBzSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWbE/KHnl5jiZw6mXHQUz5y9TP5cdKiXhmEZFCqR+uQ=;
 b=NlW0o2ak4ZU8cAl9qqjMRjedP3BNOOoEWPHtujDre63WlgoUAspW88WKcUgadAnTomSIbVIDGoINMl4KG6eLKFCHcCQIovV2cb6yY30urgbWosB221VuEC9+TJqiT54QsvkHyP7vf/UTCccF4isBXRCf2ki12Xzgvx2CTL/5z1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 03/15] net: dsa: stop updating master MTU from master.c
Date:   Tue,  4 Jan 2022 19:14:01 +0200
Message-Id: <20220104171413.2293847-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2aed15e2-cba4-48b0-3d3f-08d9cfa5ad15
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB710408D883DE18421D59E6CBE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YX90tUFIHS5bUHikgov9fypgZcdBoiV928xp54wiOPJaWLvVxYYDz40O357zsfWGYKnA13XF0uiULhUDSCxXMPQKgApgFEZN+sZOI6yxgdmC6zzlWJsQU6taIn1jddWem0lZwg6kKX4kr/mxKpcroqGXPYF0OoLhtmQDGtGXkouOgyD/MOi2Dd8XunCnATSulsV9dX04u1DowLoJnqk3Wpall78oi7xAK/FTUv44CN19dMWf+c1xdqHWmE85OsJyaeg9t2ITR0aBlPsebikWRfC9Ts5ejSFj7PgAKP4aWQwUjMNDGvhkgNz4OqYtRGmynv2n8zqc3amcBmgzJqT+niUQxdeDXkx/uCpZNWQSTUx5A+oYpXSAbDDxUgeGgxeZGpPos1SWgYh0c6sk5pVHbqPbYPJhXpLLm0HeSkvuk1BPBwAMs7dQh1b9Cr8kmtmA9T1JKdZ2FIxbT9GX5H+sfInTT5D3MkJI3JJfyLvvYBqojssZtEWBTxq1G5a/Q6x+CE4NkwoEDMRL1tG0IOI5bziacjeeDkM45vA+75JFbHPB7u3u0IvPl8UNdwYho9mjX8oGWelgWiIRFWiT1HMUdNy3/5Ln7QZLwuYNntNAXR2ySZ81zvV6x2q4DaGyZjpYxUula47QKBgOamyCQG5PhBP+NfVpFs2ahncxSLAVZs1wHWqJcpErjbG4zRXcE+PfO2bMwHperfpQeltGPX28NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y0V++fIZAEpzZf/KuTn/LKXMyaODmEZwxZcw2b98Hy7y9kHL9/D3NzRN9qOb?=
 =?us-ascii?Q?qyUMv9AsOcXF2Fz2H7hPTg9NdnI2Z/ZQ3RRMIvrNqkhwDrQKbluUqoIiB4tS?=
 =?us-ascii?Q?TI81+8PLifN2+yDNeSONatMuqu4ip07KQu2UamF9To6nJ0d90Ht5Q3Zwsxjg?=
 =?us-ascii?Q?fNAY4G367aXbrgmYKUXYqM6tyTWYd0wfdu6w0sOmut1eZQKpCDq2kLlViW7N?=
 =?us-ascii?Q?b9e5JcwptjWPcm47UQ2qfIiBakWWPedBHNJxO/T3fwbW2R8sVgm1sB5RS4ZH?=
 =?us-ascii?Q?ZJc+9DNICIolfOM4axil3KxPbOJI9e7Acd3YlOF3X1eSk/As179TbUu6nVq1?=
 =?us-ascii?Q?XxM6UwRaqALtLPoF5+fRmY+c5/5X7cZLmRbyLEVCRXNImiQvO381Af6OQoVq?=
 =?us-ascii?Q?6t1lI9icvJFAiWrfNPojqxIqlt7SZJCR5Dv06Ppw+iDOBEvHcfbonZ0LvvNp?=
 =?us-ascii?Q?zkHeq+hcRCPCHumOLf68KtxnkIHunJ5saokkf1Et2mCx6D/aHRmR6hQvlhP2?=
 =?us-ascii?Q?lF5ol8JYYGogZMDakkMz1M2W1tD/6t7LvWMvB2kRANi5uhObU4OEYCiRnyQa?=
 =?us-ascii?Q?DHkHPJ1JSNzMAzPd79wzlUYvrci1M+p0JKnR29YUMyXf4lwbKh1yXc+6oXR+?=
 =?us-ascii?Q?MYs3pKF4Rd+aeh2yATdp9Bc4WwcaO3wNaxn71zZ0U7Z+rC3dvbbxCcUWAyMk?=
 =?us-ascii?Q?SBQzkkaQiXEElG6q903Hp9hcatfStXLNnt4HbhL2u73EML2Wza72Rc32+P70?=
 =?us-ascii?Q?ZHMR8975xXqqW0n6EepfpMGzELOthmY3u5Dwb5B9KqE0NGcUOCAqXfdao5kh?=
 =?us-ascii?Q?GJUiQGPzY5JABkPIeRIoOfJ3+Dt9AeQtRNUU6/bikvM+WayPD95ajSG0mbPs?=
 =?us-ascii?Q?l/N7dIZJS10neTl8fvlwCXb392B36IXKZS50aM40Ke2f+2PJwsDaD+NQkeU1?=
 =?us-ascii?Q?cRsuAA2v8HICUNJGIxc8r5Kpf8nd5YTblPOR+1A9eC7BCKaJwIh9SUzD4Xjb?=
 =?us-ascii?Q?kIWx5rBMWFtetLb0ffKjZFO4cv17JjQNgCV/ApqQPOKY6xq8+Jb65K5agPSK?=
 =?us-ascii?Q?J2z4DwnrV/plyd8pLo/qVJVRjXiv3Ga0JLalL/ZRy5pB24/mHk6xtq9QQIee?=
 =?us-ascii?Q?sWziWvOX+wz5wqmIT3KtHDRsAz7ZfNNZZ/X5E/b+1pEUUNpioh77wL2kOLUq?=
 =?us-ascii?Q?rIGbLhA+m5F5EXJ7MJMjRAgMLfCfwWAWyYBb7afENte4iRvIaSGJX7jyO4Ko?=
 =?us-ascii?Q?4JoWFSvBat8uXOYRCzwh8YdJTtGlhf/GkZkpHXz4FXGpzgr26kclNlgjEXMV?=
 =?us-ascii?Q?cKglgckicj6Brb6Ar2ZgzC3b5az+7LoXQ13XW4xpru8vGq7+7e+t2xodYaxo?=
 =?us-ascii?Q?TTfDm6AQXwIutqHHEKQpXjk7c38TXr64dm+So4A1JvtddnHfl9XgVn3Z5DVx?=
 =?us-ascii?Q?upb0TFkpPDWo6nVNpKypT72mi/cAmKQF9CLRcl0HgnqrdKf6PJX3lbtQgo60?=
 =?us-ascii?Q?R3MF0rrKG0T1vZfwUtvOPu0uQTm5Jpy+NXPNBjtQpYgOwFoC8ulALUAmMo3I?=
 =?us-ascii?Q?i5LG/UJCPLxr813LGyfqHX7vFbfttHAx0R65dnt/48WYq8XtAHLmqLkqIhkC?=
 =?us-ascii?Q?WWXyS9F7zpa5nL6e1utpLcQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aed15e2-cba4-48b0-3d3f-08d9cfa5ad15
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:33.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOAa+HOT4L4NIgpPRM6S/JRHN+1FiDTsvi7C1uFZuAYdxRKsjb4a1fKxaGBPsUDqNTybU1NLYYWCq0m5OcMOKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present there are two paths for changing the MTU of the DSA master.

The first is:

dsa_tree_setup
-> dsa_tree_setup_ports
   -> dsa_port_setup
      -> dsa_slave_create
         -> dsa_slave_change_mtu
            -> dev_set_mtu(master)

The second is:

dsa_tree_setup
-> dsa_tree_setup_master
   -> dsa_master_setup
      -> dev_set_mtu(dev)

So the dev_set_mtu() call from dsa_master_setup() has been effectively
superseded by the dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN) that is
done from dsa_slave_create() for each user port. The later function also
updates the master MTU according to the largest user port MTU from the
tree. Therefore, updating the master MTU through a separate code path
isn't needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/master.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index e8e19857621b..f4efb244f91d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -330,28 +330,13 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_reset_mtu(struct net_device *dev)
-{
-	int err;
-
-	rtnl_lock();
-	err = dev_set_mtu(dev, ETH_DATA_LEN);
-	if (err)
-		netdev_dbg(dev,
-			   "Unable to reset MTU to exclude DSA overheads\n");
-	rtnl_unlock();
-}
-
 static struct lock_class_key dsa_master_addr_list_lock_key;
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
-	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int mtu, ret;
-
-	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
+	int ret;
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
@@ -361,13 +346,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 			   "Failed to create a device link to DSA switch %s\n",
 			   dev_name(ds->dev));
 
-	rtnl_lock();
-	ret = dev_set_mtu(dev, mtu);
-	rtnl_unlock();
-	if (ret)
-		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
-			    ret, mtu);
-
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
@@ -405,7 +383,6 @@ void dsa_master_teardown(struct net_device *dev)
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
-	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
-- 
2.25.1

