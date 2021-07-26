Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6528D3D64FD
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238709AbhGZQSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:18 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:42242
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241492AbhGZQQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPxe7FvaE4Gow1/AHG9u3cdfj08hK7d8j+5nOS5NczmEUtK0slYcFdjttwFE1tPrqfTs12rejmJmcsGhBfWRYmVkfloCv5f9fkZf3E3EOJV8KbjFlsmgfnl7XgviC8jssSn8DLZ4Zr1aVWXbhWSB+BGd9n+Ifg2aTuCSrcLIx4dKk2UcLCzuUjpc73/ecVw3hlFcPU81XHUCkUIW5v8kf1TNM2u/iGMrl3p5Byqxet19qOEdgCB3yiuFMA39OPJHJeYSQ7qzaS4DKFMPKi7vW9H81Fr0XOeISNClS/VGocNxL9+z48qktZjFM/IlWoz1mpbwrsr0o7AAuOd8JBg1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJ652nFcpKASwREPHINgDOEi7xS8/6zCliKqHMFy1h4=;
 b=M+5T/3HannKvS+Y8vNqYvjmkRoFX9lsjI+gBRg3DMsSkOkDWNKD3Oy+H3x/mO8YZY++HLOKkprQ6EWw2h9MV98UlULhfCalJUljIL0WJrQiCVyph2d4YZNcHWU0F/mx9ERGsi6+OLSsn/TUVWoZY8T89rTd1jSbZEMGUfUGZ/He4YphDJQrjgceDS+sm6X5cYpKTO9qL917uSQo62T+SRjnZZsreiCj7L5ss8JHrOoNc4ONqbO58skUnVSQ7fdTp4nhPmR19jOmXqrwEtWYdj/CsFlLGctWEz5l3tR7nw2ggnwAGnuJCtU5pRcmwGP7zFcOq4Xh1EZV/QuHIww9jGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJ652nFcpKASwREPHINgDOEi7xS8/6zCliKqHMFy1h4=;
 b=sR7im0U/A1ucq9HKfo1fPdk0tcPC9wnciJEbt+Ybx/2J82kROjqM/g1X/20Tozg/HS02UQd25p4Zevol+l66hjxK/Cw/mDiak3VaMxkw8zq+xPaVMo4llxWoRgqS7HiLwg1bu8KWDOfX04+tcuTYbgm4+1FljnqCyMMdIKDh4aY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/9] net: bridge: add a helper for retrieving port VLANs from the data path
Date:   Mon, 26 Jul 2021 19:55:29 +0300
Message-Id: <20210726165536.1338471-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e3254ab-d919-4ffb-25dc-08d950563f39
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328219F6DDC3EC086C92A08E0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngSJKZEYOz4vNkKNFy+OCpFHQdUb/1YM6h4UHT1Jvhl71YhHHrxKVXNdZGSBRShFGXUE403T8/+GySNNQOcsMO+YUS1LpXPkjRbfCGcLNqInsHjPJnGPGnUeywHkJOczWqLx0S6oBl3ArZAaJDAY/MMDKGwr/L81+C4Gkkmy6GcjDMMqbj2kj4MFe8o7NWn2KNJHPeaxmtsQLm0+l3I0hXJq9wMNoKY5CZGG5bRYywrExpfxemfOQsjmjmtAr+NWaRxC7HC6YBU0yDVYmQ/YSZxCqPKd5p2aYl+9nCfWsSWGOlpCfyWQqslfPok9mjDFeqXvyT2jz6xLOlW94qOb+F8ROUItyqYl8ciUVEzOsnFPu5hiHKz8eOvXSM7QeUlG+eMH22am8cYt25PoaScfHJH5Qq6wVz5hosvjlf5IaOshuMlWGvavI3jFA6Fce/kuK8I8XjTsob1D33Ttz35zAXYoz6P07JhRItUr5KzpsAHb4ODf4tPuGSYwbpojDLJr3iy1tZ/PgBjUr1SBKAmBUjZ/fBWqVLZmT8xMnnAchFvfFXka4eachDNZ+9AZrcDLgtUox7MVJUi4akdpmv/Ift1rR105G5j/jJ0zAgTxApY7BdUpCCF2ohbjmO6TYFhGT8aACl3xfotJmWPIm7R4WF33vndcswWn5siwbl5m3Dq8a9wnw+7k8PHd+N5eWpU90qAQdb/WOgQZuGB/eICDgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(7416002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D8xwHb67UmJ0kZ/IeV+GPhO53d9FFaxN+Rir/Vpix1QNXJ4AAdXbMBDBi7vO?=
 =?us-ascii?Q?++Ds7ympiIRc+JlG+ytbHZl6zjj33+O3lgYOb5KPEegc3p6p6MHx/QZ/AvcW?=
 =?us-ascii?Q?vIkS6pzqxYHI/HGql6pHKW2LP6d3WeNFxFvyYWTcKnNmeDs69eXwgdN+Zzn9?=
 =?us-ascii?Q?OBQSvtmzw6wbwpR7P4fu0enQcP2YZusvvkyJ4jcL/wcxuv6OT5DN+wngoMBl?=
 =?us-ascii?Q?1/ZU9yPjs0achn+aLCJMDXed/W296LU4X22ofRzfozO03a8wnDfERmU3Onqi?=
 =?us-ascii?Q?AVtMqDqR3iJZsmTScMUT4nMMZnOjz+UI+6td7NPbbNtgK8CmGCNdAXw/6xL0?=
 =?us-ascii?Q?SyFdPeClvQ1YHnADaYLXdJjeE1Bt9Yf9Vd6U0pQmoJ0xtkdmgzatBGVghPNi?=
 =?us-ascii?Q?Bvxny+qpeQwSwjk3VUZHe7P7TseyuVDM2nx9Z4f3M5I+7TRQPaZdlfMnJjUK?=
 =?us-ascii?Q?T91ap4ovqVVUx4r5y3RLdiDXmdX2Cl1W9IHQe0WDvOhHSpDr2hPLK6+TXibK?=
 =?us-ascii?Q?I7HaMnGn7iJEsVj3e5fZ1Bs3oJHSBZaKmtl52RtVC+w6IKCshDRdexes6I0P?=
 =?us-ascii?Q?j3UVTZiuyGPMnxV01M3nrPLdNRgPe6v6Ok7+PDIeX8RV9TcxA0LW1/LBCw2Q?=
 =?us-ascii?Q?7HfgPhszU2CR+lLXTz59mQpaX9KZh9/l//EQF9YVCGUyI5tz5o/dpfM4MRq7?=
 =?us-ascii?Q?8H70PNrLPEORny4KgRVpEtZuPGUsZ7ppQ7w0X5EfqHGepaW7c3RcW8VdQLmO?=
 =?us-ascii?Q?095q1TgkmrPYJB8h9pl786zilotBsCgA3xUWUZ53o9BTO47IRTcSeqXOzcGT?=
 =?us-ascii?Q?vpMsgvDenZgg1FF2j5zhC1lw27oK/C22rJt7z4tvHvvppOdLIBX1h2DdpHQf?=
 =?us-ascii?Q?RbdYoAmzS/ei1DYgF2tOVHL5P2OltEK8qecZsJaYpGHMGZungngxA9eepxSn?=
 =?us-ascii?Q?MDaCRjNnaFhXCb+4dj7Od4FAnVFu9o74d++6/cF1T0dYVJMQHPX8lNXfNUIN?=
 =?us-ascii?Q?kNYLKexMrXzdZEnsKBD2SchURHHdnckzPfojQ1AybkXYuPGFGyagDUY/A+DQ?=
 =?us-ascii?Q?H8yIM0SOMr2k4z/XBQrOJgUKUqAzDEIA+tdBhie9e5uSZ4uAIBJIaehl3zBZ?=
 =?us-ascii?Q?CzYrk2crATUw03ntCJfi24Kem1w0Kkvo6koyROB3u+++U2esryzgukkQzqdE?=
 =?us-ascii?Q?Vd8Xoy4KKU+Lg30nrouCa0OGo6akQeLxvOEPh0PFfQde5oxJRC6sOdv6AX2x?=
 =?us-ascii?Q?H9zeChcQFFuTIUvUsMmS8HuN+jn1zeXmN2/sWsmCFVfvRy80OOl/NAc6TbhI?=
 =?us-ascii?Q?HECAv8up9RHcRn9ujhMDGFHS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e3254ab-d919-4ffb-25dc-08d950563f39
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:00.9754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGW5j3V40TOi41mPeH4L/FGEeAUqN7AZBt97S6X9i8Q8yq9/XE6GVLwigcYhNr+mwc6esZtErsNND42kHRvFig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a brother of br_vlan_get_info() which is protected by the RCU
mechanism, as opposed to br_vlan_get_info() which relies on taking the
write-side rtnl_mutex.

This is needed for drivers which need to find out whether a bridge port
has a VLAN configured or not. For example, certain DSA switches might
not offer complete source port identification to the CPU on RX, just the
VLAN in which the packet was received. Based on this VLAN, we cannot set
an accurate skb->dev ingress port, but at least we can configure one
that behaves the same as the correct one would (this is possible because
DSA sets skb->offload_fwd_mark = 1).

When we look at the bridge RX handler (br_handle_frame), we see that
what matters regarding skb->dev is the VLAN ID and the port STP state.
So we need to select an skb->dev that has the same bridge VLAN as the
packet we're receiving, and is in the LEARNING or FORWARDING STP state.
The latter is easy, but for the former, we should somehow keep a shadow
list of the bridge VLANs on each port, and a lookup table between VLAN
ID and the 'designated port for imprecise RX'. That is rather
complicated to keep in sync properly (the designated port per VLAN needs
to be updated on the addition and removal of a VLAN, as well as on the
join/leave events of the bridge on that port).

So, to avoid all that complexity, let's just iterate through our finite
number of ports and ask the bridge, for each packet: "do you have this
VLAN configured on this port?".

Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |  8 ++++++++
 net/bridge/br_vlan.c      | 27 +++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index f0b4ffbd8582..b73b4ff749e1 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -111,6 +111,8 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
 int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
+int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
+			 struct bridge_vlan_info *p_vinfo);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -137,6 +139,12 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 {
 	return -EINVAL;
 }
+
+static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
+				       struct bridge_vlan_info *p_vinfo)
+{
+	return -EINVAL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 805206f31795..8cfd035bbaf9 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1449,6 +1449,33 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_info);
 
+int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
+			 struct bridge_vlan_info *p_vinfo)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+	struct net_bridge_port *p;
+
+	p = br_port_get_check_rcu(dev);
+	if (p)
+		vg = nbp_vlan_group_rcu(p);
+	else if (netif_is_bridge_master(dev))
+		vg = br_vlan_group_rcu(netdev_priv(dev));
+	else
+		return -EINVAL;
+
+	v = br_vlan_find(vg, vid);
+	if (!v)
+		return -ENOENT;
+
+	p_vinfo->vid = vid;
+	p_vinfo->flags = v->flags;
+	if (vid == br_get_pvid(vg))
+		p_vinfo->flags |= BRIDGE_VLAN_INFO_PVID;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(br_vlan_get_info_rcu);
+
 static int br_vlan_is_bind_vlan_dev(const struct net_device *dev)
 {
 	return is_vlan_dev(dev) &&
-- 
2.25.1

