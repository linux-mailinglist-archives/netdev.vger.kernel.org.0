Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60B443A67E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbhJYW1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:33 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:7454
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233709AbhJYW1X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdJ11uDd/2pKk8zIIEp1bE+l0/Qn0ExX3xVuc12W7J+YgwNO7Unab0o2fVtP4YqXRvWeVA7HSbx59yK6l61JmzCioWuzGGL5WnrTmlW8xcneCwBfQGt0gkPqSK77gFg9naV0ouKFhlyiw5nCoS2wcUtlbvwjoZblrUtFxxacVVIMW9XLSyEHUlU1is+ErelZ/CKNX8ZqMBDMU0cj/nGbxx8JsedeA2GbDbv7qFs43LHR0lqT0m5qE4F6IpUlGmZRrpkAno1W+DZohChrKROOC5ahKMfN0v9WMEH3+vVlOifZqcOWzajGHt9NjwmNcVWXl0tagLY3ocSmVjvrFoG7HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXDfqdX9ZBWmMcbpaaX/4+I4de2hUXgm3pAvEAN2bvI=;
 b=UKcVdol4Xvd/VdSonzODKiya7lztfcUbjFgD9XTzPZvv4dSa/6SpTyf0VWi0yQ46lPPM1nqyu93Jyt77g9XynhY4gd3XuVgUsa+mTlczvslbJI23pcGHDX+aa2qcZFufqMimZkB8AfPi7nQS6DbGHw8swgDcpOxs6mqT7G7qW7YtQ3eHBSVE9mKiAeatMmztmfzaq4hB0P9Nk/hWTGo6atNAa5Jmz6f0l45vPXbMSBnQ0UsAr9R1ZsZj1KjjS9g+qY9iecIQpKUVw+KQLDmM3lr5HPafEkSJ1+Y2pOii86McjM/C2LGHfEEBCo0G3XJ9ieSY+BXk4gWwHfEEPmfzVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXDfqdX9ZBWmMcbpaaX/4+I4de2hUXgm3pAvEAN2bvI=;
 b=nlEQvn6hyKAxS8Bu/cQyF0vIamLxEQiTnx1ytRLrGFTUBbORdrsJ3C/Qs8d3BSdBOhDeTHGG+1GwQUjfs8+CVWizUjLcu28k+ZNDk8cgYn8H5/oTDEkLl48DkgsvveXX+YIk6KDSCDlLQnAhJxQSB2JEgJBEO9cTgGnvo4uEjpc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:44 +0000
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
Subject: [RFC PATCH net-next 12/15] net: rtnetlink: pass extack to .ndo_fdb_del
Date:   Tue, 26 Oct 2021 01:24:12 +0300
Message-Id: <20211025222415.983883-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a46cfa2c-f417-4a7e-140c-08d998063ec0
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23048DEBE4282E461A63E5B4E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvK+zc64x0tQFnR+owOlQvx052E7+7/K6VIRl3yXIxUBZgKJNySwOwPrN85frS020P2K3CuvHL/x9E8ybmAZcaBVMzp1Ef4YevbIRqxGJpAxbVoAgiWMs+AY8uI6T5HnOZ/EwEB98OSFpaHu9vnNEJKQZDwhWlRWf1ZcKsyukBd3ZhWJfOgo7f1xgQY+A/SJMOrLYTbIPjoN/wR6FwBoRJ57U4DLU6xahDDKSqCVOgzZoiYSZ2q9CJEhkrxrrWMJ+4fRcVeBWtQg4lYC/XqpDNW4HRe1mDDOrMr9sGXkkfYFDELoUrWkVc4nrWmKVZJqldAz0ISy9ufeesp482xVGD7JCGzQH83PbhEraEuYj+2uubJpoPP1rJ55AuyeZ0GSHRlrzzghsyMdKDA6HrbNav2AyVSxOvUw2tiPEy2v3gqI2jvXkxakrI6caCDISTZLYrV0+mNPR0G/YKi9BzEy9V/QphfEBNG1FeBUg4lxNRrxidMmSKTtpKErgZlq2qVgy45tcbnBqWlTk3qjHgNvidByehLUPxJTCKY/xGSMVA5OvFvRm0/zTptPRibszYoKx+x1tq0Gqrh8sVO8dWdGDLAn7TnkYrFWMxdOGodpi20Al1RLl+vvmn4YNhqM0loQijLk3K4CXn+/hUa4cNUTNs/ICwJYH5I9fm8HTDDBRvIJ6+LrD26g9faot5cDC10MkB150dGPcKuHDxtrS/biHLM6eEaj80hVTDz3tZL/Ie8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PpQrwobALZ1R0+QhgYtepXAIAO/5WrrgI/DlaZT44yk29oPIC5WsQuNoT5cu?=
 =?us-ascii?Q?uZuFJWoPMxDtpUb8OMYPnFRuYy5TrEZyw54X4BNrv/+sRrKX/uLQWmSJV2uz?=
 =?us-ascii?Q?eufONf/LvdD9hWiu2bUzhxGkDNDpaT3rEaYVqV3bdcUrhh45/tsgQBYHCEQF?=
 =?us-ascii?Q?hq2dO/QlyI9M0kXi2dtMjnKy5lsiHZJYevF0Ms/IMrB3+vaWycbH15V4O4W8?=
 =?us-ascii?Q?tEZCJc6VhObTYiHEl54kCrvR6GHNAPEzCFQbLrbKHNapD4QZ3aHXrZFRskMU?=
 =?us-ascii?Q?f8KZCWL5LBXDmv9d+luE/Lc32dL6+APMzHVOX/Bx8dbzAO4gMWY81gpUHfDK?=
 =?us-ascii?Q?xeLf9d0/PxRN9fN++uz7HMGDie6wSsvyi/zQQVMOx6cPUl4IEFJzX+3uPkyu?=
 =?us-ascii?Q?RFH2B3oy5G/KvG5bjDcIgUDAsxBqfXqON/rUdAlY/z4Ovzm+eGizSWWDgcTG?=
 =?us-ascii?Q?XeCArQToQVylps8a9pMPO1C6deW+kpv+Y/lby+Q6Wsjv+2xGwKt6feZTgUZi?=
 =?us-ascii?Q?YIJgTVG82RzYuFithUq92966cLIj/5MAMdSU2Bpe7d6uWmbx1UqltPfWAt5L?=
 =?us-ascii?Q?XM0WISlL9AAYZPNwPEcBmLI+dj+y+nHaHnBA3ivyzrCYg9qALVcK3cceAYbp?=
 =?us-ascii?Q?pF59i3KmneKZb7B0ghFhGCQzWxLcq/yiwASoNpzi/VaWCJPioeHpEAMpQtny?=
 =?us-ascii?Q?8NRAljBMusWHGVxUcMEIJiXmTetngtbrpOpsWw7cslAEz4IhA1+RbnlEfcnn?=
 =?us-ascii?Q?zfDmr9g6wKmLrzxnEzP2XArOGYovRiQuCiNfuPmIRs/skwPIX4BfkyrjKUpX?=
 =?us-ascii?Q?Ti3Ocfhbl3/iZaZMR0o8V/oUZkDNercLbmz0NBaYp4vvF0M+Pg+Ro85nGW6p?=
 =?us-ascii?Q?N9W0BPGMLyYPI8UL6F6qEK6DGTvtn/qyte2eFDIDEnRzekqIz0p22+TpXeUp?=
 =?us-ascii?Q?dLi+knzBv/qu1uWx0vZ67/XtIJvY9VHv8AqUVWeGwLIzNHIR9jy4/h7cq7Hn?=
 =?us-ascii?Q?Ol/Ce+m+9pGqe/kfgEawetE4Kun0maecU/MLpuEAzrhmn7eSqYvHJIu8Ka14?=
 =?us-ascii?Q?kaR9bp81UakYaS8kGgqCKh+LFurntic9ph4NsEC+h14qWMoxVs5isRLkka41?=
 =?us-ascii?Q?HKpnPXO0WpO7wlsNEbtn/NzzL1+s4PdhjVAgwakloDmByqUVd868xke7LRJk?=
 =?us-ascii?Q?nIeqLatd8rEomP9qFwGFftEQNVFkdvy2VP4KYOZInklN3zBcXVX4SLdP56Wm?=
 =?us-ascii?Q?UpQx/RO97i/0w8WHaG+xW6byxPGEtllBBGFkAm4gvKRLHsZgp+nsHJiYmSbx?=
 =?us-ascii?Q?j1hj5aipTEi/7Haa+gEzzxCxW1TEPPHnu0f3GP/1iaO0LXNfzek4pUtXx7II?=
 =?us-ascii?Q?oDsqsPNY1g8wwW8TT1SLky+HqnNUA2PCJACoNPzmQtRmGd+qu9uHoCEow7Ie?=
 =?us-ascii?Q?fJH6KAeNrhYoNidA/5Rk1tO2dvVqOLz+k3MzWrdxGeR+nkJeg+6lQkwsz/e9?=
 =?us-ascii?Q?vORpllCqJfHl59aSJnup9h2VfZe+JbA4HuWb+NkfVf/+WRborfFSw6haIJOv?=
 =?us-ascii?Q?DkzP89e0rSD2vKcpKGdqWEqO/4bc+3cWXb/jU+GTxJJd5DnWyxex4xPQopcK?=
 =?us-ascii?Q?7jWarCKpK3VSeSeuQdqSqVQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a46cfa2c-f417-4a7e-140c-08d998063ec0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:44.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1BBHrBCtxcgWpw7Ss6jv81sYTg7oyJmVt4C4uK9QPo7s2fx06W3H8dcTTkijeOWfvyfgfXHUFvWHVir34VwBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .ndo_fdb_del method can already return an int error code, let's also
propagate the netlink extack for detailed error messages to user space.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c        | 4 ++--
 drivers/net/ethernet/mscc/ocelot_net.c           | 3 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 5 +++--
 drivers/net/macvlan.c                            | 3 ++-
 drivers/net/vxlan.c                              | 3 ++-
 include/linux/netdevice.h                        | 6 ++++--
 net/bridge/br_fdb.c                              | 3 ++-
 net/bridge/br_private.h                          | 3 ++-
 net/core/rtnetlink.c                             | 4 ++--
 9 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9ba22778011d..7e0741d62aae 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5434,12 +5434,12 @@ ice_fdb_add(struct ndmsg *ndm, struct nlattr __always_unused *tb[],
 static int
 ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
 	    struct net_device *dev, const unsigned char *addr,
-	    __always_unused u16 vid)
+	    __always_unused u16 vid, struct netlink_ext_ack *extack)
 {
 	int err;
 
 	if (ndm->ndm_state & NUD_PERMANENT) {
-		netdev_err(dev, "FDB only supports static addresses\n");
+		NL_SET_ERR_MSG_MOD(extack, "FDB only supports static addresses");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index eaeba60b1bba..8f53c9858cc1 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -664,7 +664,8 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 
 static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct net_device *dev,
-			       const unsigned char *addr, u16 vid)
+			       const unsigned char *addr, u16 vid,
+			       struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index ed84f0f97623..f276cc2c4351 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -367,8 +367,9 @@ static int qlcnic_set_mac(struct net_device *netdev, void *p)
 }
 
 static int qlcnic_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
-			struct net_device *netdev,
-			const unsigned char *addr, u16 vid)
+			  struct net_device *netdev,
+			  const unsigned char *addr, u16 vid,
+			  struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	int err = -EOPNOTSUPP;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d2f830ec2969..49377ef174c0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1014,7 +1014,8 @@ static int macvlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 
 static int macvlan_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			   struct net_device *dev,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid,
+			   struct netlink_ext_ack *extack)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	int err = -EINVAL;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 141635a35c28..45e872d4e052 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1342,7 +1342,8 @@ static int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 /* Delete entry (via netlink) */
 static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 			    struct net_device *dev,
-			    const unsigned char *addr, u16 vid)
+			    const unsigned char *addr, u16 vid,
+			    struct netlink_ext_ack *extack)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	union vxlan_addr ip;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a..79284bdd4b6f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1245,7 +1245,8 @@ struct netdev_net_notifier {
  *	Adds an FDB entry to dev for addr.
  * int (*ndo_fdb_del)(struct ndmsg *ndm, struct nlattr *tb[],
  *		      struct net_device *dev,
- *		      const unsigned char *addr, u16 vid)
+ *		      const unsigned char *addr, u16 vid,
+ *		      struct netlink_ext_ack *extack);
  *	Deletes the FDB entry from dev coresponding to addr.
  * int (*ndo_fdb_dump)(struct sk_buff *skb, struct netlink_callback *cb,
  *		       struct net_device *dev, struct net_device *filter_dev,
@@ -1501,7 +1502,8 @@ struct net_device_ops {
 					       struct nlattr *tb[],
 					       struct net_device *dev,
 					       const unsigned char *addr,
-					       u16 vid);
+					       u16 vid,
+					       struct netlink_ext_ack *extack);
 	int			(*ndo_fdb_dump)(struct sk_buff *skb,
 						struct netlink_callback *cb,
 						struct net_device *dev,
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e8afe64dadcc..ce49e5f914b1 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1243,7 +1243,8 @@ static int __br_fdb_delete(struct net_bridge *br,
 /* Remove neighbor entry with RTM_DELNEIGH */
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 		  struct net_device *dev,
-		  const unsigned char *addr, u16 vid)
+		  const unsigned char *addr, u16 vid,
+		  struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p = NULL;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f5f7501dad7d..6c663ccc346c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -773,7 +773,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		   const unsigned char *addr, u16 vid, unsigned long flags);
 
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
-		  struct net_device *dev, const unsigned char *addr, u16 vid);
+		  struct net_device *dev, const unsigned char *addr, u16 vid,
+		  struct netlink_ext_ack *extack);
 int br_fdb_add(struct ndmsg *nlh, struct nlattr *tb[], struct net_device *dev,
 	       const unsigned char *addr, u16 vid, u16 nlh_flags,
 	       struct netlink_ext_ack *extack);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2af8aeeadadf..eed5eefe2bcd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4152,7 +4152,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		const struct net_device_ops *ops = br_dev->netdev_ops;
 
 		if (ops->ndo_fdb_del)
-			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
+			err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid, extack);
 
 		if (err)
 			goto out;
@@ -4164,7 +4164,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ndm->ndm_flags & NTF_SELF) {
 		if (dev->netdev_ops->ndo_fdb_del)
 			err = dev->netdev_ops->ndo_fdb_del(ndm, tb, dev, addr,
-							   vid);
+							   vid, extack);
 		else
 			err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
 
-- 
2.25.1

