Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8EC3EA45F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 14:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhHLMRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 08:17:54 -0400
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:28109
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234942AbhHLMRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 08:17:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daUMr1cumvGJTggyE/aUSDjzZUHmZwCQH61TvEhevJZVXncLw4wPH5bgrCp0AESm8DwESBHPy3Mu5C3dUXxyWFJ7zqWrD/I2FUfyHjHNU7Rc84HVhI7RsVRbyhiSjlUeDjusOFvN8nva735Gz1+XJ+iIu8TQtNhA0tzaBKbvqaNEZKnXF3lDWYIkDNPLpiQ2R9qhnhhIGMWXbXWkS3dFvjN3gzwPVT0w8snOv91fjmGE01z4bZuEkkxZANHV76ejQJW/Mf1XAdR92vbpxag88fw3TaCStndgYOt8hpFxVU0xxwRE5MkxCXAMUpBzD9KWIta1vf0k+fJpz1sVmPFnCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdc9H/XTV3M9kZvLnKLntrgGZcGbIMf+8vlu7qbcfsM=;
 b=bKLhH+RjucVW2fulbZP8IDcvB4ID/b/GvbLKyHrPyXRdmPduoLPOhq+xDCTAsZVEISrrpg0WQirnyy7Vn72jDjSLoTdG4FE477alWnZkdo3EWF9JmlaKS0Pombg99yK5a18dvCOgHJz+K558eYgX4XinVoxa18DQCW3A/owCFlzWwsLYNX05H5CndkgauP5O2q4b7mSr3DW1NEViNFhlCcp5uTGZWEbutzqZS4cKrnKO7CDMkCQsWgkqUHE5pQTHRr1xuDyhl1eHd6jllxkUXOoV5YhG3xQOXmhRsoxF+wogFHHg91D13RFAU5cYDToTONi8oietAqgJ8av9MYucOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdc9H/XTV3M9kZvLnKLntrgGZcGbIMf+8vlu7qbcfsM=;
 b=BDAZo1ZA+AS63okRWuY1RO5ulvh2fjn3SXHB5+ZncI0ilngveNvEl+Gc80uQxwjCAQho5gaylBzIjAWdzzNw/faqUmXZ2pKNsMqSvwBxc1ZHdz3trc4ske+uFJQaZdzFeV6AUZ1Gkocsw6isX+bCrzmXHTl/cpGCM1MKGRtgYTs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 12:17:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 12:17:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next] net: bridge: switchdev: expose the port hwdom as a netlink attribute
Date:   Thu, 12 Aug 2021 15:17:03 +0300
Message-Id: <20210812121703.3461228-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 12:17:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f8a5b3f-a985-4f3b-0621-08d95d8b256c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26877E3816CD2892ACE7477AE0F99@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z5t5RK8hDLALVOXNi8eIwDFwsmr6+Ob598ugca5XAZwYOrbcxfnadxr9oQN/34bf2bF5cWlBKiDP8ztxBtMyc6hBWv8qHduZhTX0vlomgu+7dlGFvGTvqkhwjNnu1gbkdFQ76M3g1spQMEmabvp9qEzMeh9DEEkOGeEqdZdV5DgDW4w7pw7guW6PUQwTxWOGV1pGWYpCzlDpFdfBw7pOpwmgcp6MkIpUbi1LX1oQSwuIlxRiBgWFRWMBZkWIrCDXnmxSuZNJeoYzxKVGUWRoQhnr9gmYCErOm49PV0TpN3L1qoqjQ+UAHRp2LMkCnq+dPusuA9N2T+AqerbQGl8Vgl1xbxxfjBbcbuRNFOYCj0IqvUvFv8bv09isajSYiPPGSNYSWg455nEsKXhRrHZL0zQyAo1ca+B4WtrdKG1fFvXnUMCkvGcN0BNESYjygordXs3mvPXU8HVuSX71hE2Qo49QD7Cq4fMMQxpwtdTkqT++Xld9VAGufUN7Yybt5LjVIiOAW3vDNWbESi8st0joFut0QgNQxCkc+Epu9fLXI+iGnQw2MnP+jQc/qM1tOslTtV+tk/su0JCtiflB35uqtIwW3wgN5HtnGI76Wt4Vk21/i73W5T+DNW6Tw0tPymliSdyFavh9r8ZKPXFX3G/SNYaQIrXs2hDF3ljlstd4BJo7Z+7PNRhYyHc4hKlQfUmlrAX9E7KChM+Bs9c5tIYKvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(36756003)(52116002)(1076003)(8936002)(2906002)(6512007)(478600001)(6486002)(6506007)(7416002)(316002)(66556008)(66476007)(83380400001)(5660300002)(66946007)(38100700002)(38350700002)(4326008)(186003)(8676002)(86362001)(44832011)(54906003)(2616005)(956004)(66574015)(110136005)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gmtGl8ydcG2/TnBNSZTCqCq6uGvud/cREWUmA9FVyDRzImb6pyniPdJT8Aqu?=
 =?us-ascii?Q?nnjzmV9ApIEY7n7Lhw+f7Nq3J/c/ioAdQST+A1jUl5nyI8nv1zPVwxf1FKEp?=
 =?us-ascii?Q?WMOax+jTrHuZl0pu93cB5DamM5GyEWEnFqUBGwDwW2NMYJXGRF6jEZNReUMF?=
 =?us-ascii?Q?ExIWB9hvFPy2EvZi0fTk+Y7esXBd6DJ45kRnOqduAUecpg4Q/9hkjGq/QPTX?=
 =?us-ascii?Q?7vmwvqPD7egOq0QMhaVV34fhrxYsj2g9Kl5E/iUVy33LoLIEVWG6r2fkMgqi?=
 =?us-ascii?Q?+4s57ih9vki8zOH4IGrs/rw1U3zVqTRa2k62ti3t8sDalx6OcFhdN6IiFZ66?=
 =?us-ascii?Q?bOYu+2AtI+cFqyKc/lSi+KZLvcaAZ1GPMWdT3OWh2QlLtflXIjzecalE1DJs?=
 =?us-ascii?Q?yIxZDCGSZgAq/USt3l+sUsWN0cXxH9361T+mLpsT2FdagsejDWu2Td7xYWmZ?=
 =?us-ascii?Q?drIoeCISnM0cLpQEB7IF3SDly1zXKvttoB2Yu8u/DJekS5Anuh6w+v4tV9JE?=
 =?us-ascii?Q?ljP5NFjkwSFsAdnBgFU5Hk0qygca6dHUG2d7so4AhHIMvAqE9Z4nadz3WwDS?=
 =?us-ascii?Q?IDLnQZty6uGzzVahM1sCWfWX+vjXQJipnKigxgldmTfKcT7nWuqpARb85fBH?=
 =?us-ascii?Q?omBi1y8oQBO8Lnr5iEXwnggGla4cTLAajU2eNLUlS/F4k1s9UD5LM3EPUjVV?=
 =?us-ascii?Q?aCl9wrfzStm4HAjROcajkFL/FPFUp2M/JEj16bpT4LU1wt42sk6RThS7/ySA?=
 =?us-ascii?Q?HYGNEmon9Pe/DHQKEeRFL1PCAQbYalPLf4kvnXgYbloDllpRyDByZN4yl5FB?=
 =?us-ascii?Q?p2oDZGwefdMsrcwizDOH/9zOhPsaQxUvvdJhirgqMnNyx+D4vyhfsV0kQ8sg?=
 =?us-ascii?Q?5NxLrO9RQ3n5878DO7ko64I+yRb/q5ILz1bC8vjrRQywGDHd2APInbviWmRD?=
 =?us-ascii?Q?+TWNWGey+byW+ClszjgffAZliTTrjvWdiwDthxaJ6OjtIlazP1m1TrWoSf8z?=
 =?us-ascii?Q?zLG3a9y8QjCU+HIvy6NHfcv5wbHINQgmDY6qNkBPbjUAjVvA1Hh3VBe4RsTz?=
 =?us-ascii?Q?i2XQ+w6UmeV6PCSl37iKen3kh8p9fk0EAB2bE4szzokNWrxYVo8Y2f8tne8K?=
 =?us-ascii?Q?PXGyWpQnod7gUUvqvxttiF1Gs28x+KOBpJ9z2ImTo5xE6aNLLXN3Qr+oLbCB?=
 =?us-ascii?Q?OS/HdAbx04Yj/DMgfTwCU05jPel9COQDGBZ5Xk/mXshZ6z+5h6l6iSAywE98?=
 =?us-ascii?Q?FFJC43+f/XNzE8gqynAS7jbp5tU0xGRew6DppwWDgQ9OSDE97NSdctPZSMy4?=
 =?us-ascii?Q?fCNoweqMp2XT0VWLkBl960AW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8a5b3f-a985-4f3b-0621-08d95d8b256c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 12:17:26.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GK3GbkJVzkJ+3LY3YlFCf/lDIUdJP6z3/5ABcyCZrHbWzEfqUlBsWUUOxB4NFZbVbSyudOOhPLG4vmup+uxvKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is useful for a user to see whether a bridge port is offloaded or
not, and sometimes this may depend on hardware capability.

For example, a switchdev driver might be able to offload bonding/team
interfaces as bridge ports, but only for certain xmit hash policies.
When running into that situation, DSA for example prints a warning
extack that the interface is not offloaded, but not all drivers do that.
In fact, since the recent bridge switchdev explicit offloading API, all
switchdev drivers should be able to fall back to software LAGs being
bridge ports without having any explicit code to handle them. So they
don't have the warning extack printed anywhere.

Or alternatively, we might want in the future to patch individual
switchdev drivers to implement something like:

	ethtool -K sw0p2 l2-fwd-offload off

since that is now possible and easy (the driver just needs to not call
switchdev_bridge_port_offload). This might be helpful when installing
deep packet inspection firewall rules on a bridge port which must be
executed in software, so the port should not forward the packets
autonomously but send them to the CPU.

With this change, the "hardware domain" concept becomes UAPI. It is a
read-only link attribute which is zero for non-offloaded bridge ports,
and has a non-zero value that is unique per bridge otherwise (i.e. two
different bridge ports, in two different bridges, might have a hwdom of
1 and they are still different hardware domains).

./ip -d link
13: sw1p3@swp2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br0
		state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:04:9f:0a:0b:0c brd ff:ff:ff:ff:ff:ff promiscuity 1 minmtu 68
    maxmtu 2021 bridge_slave state disabled priority 32 cost 100 hairpin off guard off
    root_block off fastleave off learning on flood on port_id 0x8007 port_no 0x7
    designated_port 32775 designated_cost 0 designated_bridge 8000.0:4:9f:a:b:c
    designated_root 8000.0:4:9f:a:b:c hold_timer    0.00 message_age_timer    0.00
    forward_delay_timer    0.00 topology_change_ack 0 config_pending 0 proxy_arp off
    proxy_arp_wifi off mcast_router 1 mcast_fast_leave off mcast_flood on
    mcast_to_unicast off neigh_suppress off group_fwd_mask 0 group_fwd_mask_str 0x0
    vlan_tunnel off isolated off hwdom 2 addrgenmode none numtxqueues 8 numrxqueues 1
    gso_max_size 65536 gso_max_segs 65535 portname p3 switchid 02000000 parentbus spi
    parentdev spi2.1

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/uapi/linux/if_link.h | 1 +
 net/bridge/br_netlink.c      | 5 +++++
 net/bridge/br_private.h      | 6 ++++++
 net/bridge/br_switchdev.c    | 5 +++++
 4 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5310003523ce..498041ffd65f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -534,6 +534,7 @@ enum {
 	IFLA_BRPORT_MRP_IN_OPEN,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
+	IFLA_BRPORT_HWDOM,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 8ae026fa2ad7..4299625f52dc 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -203,6 +203,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_IN_OPEN */
 		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT */
 		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_EHT_HOSTS_CNT */
+		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_HWDOM */
 		+ 0;
 }
 
@@ -295,6 +296,9 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 		return -EMSGSIZE;
 #endif
 
+	if (nla_put_u32(skb, IFLA_BRPORT_HWDOM, nbp_switchdev_get_hwdom(p)))
+		return -EMSGSIZE;
+
 	/* we might be called only with br->lock */
 	rcu_read_lock();
 	backup_p = rcu_dereference(p->backup_port);
@@ -829,6 +833,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_ISOLATED]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
+	[IFLA_BRPORT_HWDOM] = { .type = NLA_U32 },
 };
 
 /* Change the state of the port and notify spanning tree */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 32c218aa3f36..c3f0a44abc14 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1969,6 +1969,7 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb);
+int nbp_switchdev_get_hwdom(const struct net_bridge_port *p);
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
 			       unsigned long mask,
@@ -2035,6 +2036,11 @@ static inline bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 	return true;
 }
 
+static inline int nbp_switchdev_get_hwdom(const struct net_bridge_port *p)
+{
+	return 0;
+}
+
 static inline int br_switchdev_set_port_flag(struct net_bridge_port *p,
 					     unsigned long flags,
 					     unsigned long mask,
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bf518d78f02..01858607c7e4 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -60,6 +60,11 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 		BR_INPUT_SKB_CB(skb)->src_hwdom = p->hwdom;
 }
 
+int nbp_switchdev_get_hwdom(const struct net_bridge_port *p)
+{
+	return p->hwdom;
+}
+
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb)
 {
-- 
2.25.1

