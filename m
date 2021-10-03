Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC742044B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 00:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhJCWZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 18:25:26 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:35009
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231799AbhJCWZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 18:25:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvV0seZvyA/aHqlvvJSh0XfwMCicG3sXm3KeVmxucqBV0DqWJ+1yYZ8/n+jVBw8h9z112Deg98aIugGJHfhK4ATk4zXoeWlhsq2nYsSUiD2Romehs/T0zVyfU1ovxBdrpCzRCdQ09PPg+l3h7EzIX797F64jVa7EuweBF81I8DgshWjwEWOaONngunkBPytfjxHLKL7N2uFwiqhQjSP0lJm8DXGv037qhTFgSOc6uUdQhjZqJ6TYlkJ56uUV27QrtkTxPTxvO+Ivj+l2IUYs5UMcE+E+YF23XtoZITwpLvgqOKemWAK6VqAHrJcSK+06EB9JXS0m9ZSUqfAUc3G3Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHgUuch1y82MAqGQx2mMphOZBfpBFdWzwFZ//B+BjIU=;
 b=f+GVVCL9v98sqJByt+CgiHXqY06tSAXLcnSipXP2l6nPMdoaCjhkiMexogHxmd5VZMHi1CET5OpvfuUus5GQIjExJb+18HoNtQhtcbJH32n5b5DXfPJivp9CtQQCqkH/A1lCA4E3aD8HbOakkD2k1B07rkMA47Cg/erZsa5pKmy5TRBNN/nqhY/UkEQxK8644+jQmaEZ/FxYBwBDl5GsHholRj8RctGhc0LbiqoEiA86OmJjdM1K/dkhZuAS7FKwGiQbpLXSy1LIbOhqJa2jOO7tXWCkzfa/mVX+1SHYfjRZvM0E0KxSmyqvMIjaLPbsUaObOmKZTP4mtDJCeTyYOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHgUuch1y82MAqGQx2mMphOZBfpBFdWzwFZ//B+BjIU=;
 b=FNx6fscu30epyjrVay6s0WZpMul8vx+YaVrpyc2GYa4lICtMo0pJNQppZMoW8Sfn3gsjIvuf3I0cUPH0xW24EFUbzyAI6MOouze8TJjFCBSYbWEz8YrSV2ExQaHEZYjEn1kQSK6ZKva1iVqrvpuessD0FBE/P3NIEdvZZOlWkoA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Sun, 3 Oct
 2021 22:23:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 22:23:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net 1/2] net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware bridges using VID 0
Date:   Mon,  4 Oct 2021 01:23:11 +0300
Message-Id: <20211003222312.284175-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003222312.284175-1-vladimir.oltean@nxp.com>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0502CA0068.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::45) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6PR0502CA0068.eurprd05.prod.outlook.com (2603:10a6:20b:56::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Sun, 3 Oct 2021 22:23:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5e2f62c-97e2-4186-5d22-08d986bc6f94
X-MS-TrafficTypeDiagnostic: VI1PR04MB4814:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481473BD775245608B77FECDE0AD9@VI1PR04MB4814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ePKOf+qsLL9og+oy62clGGdtjwi5T1qAzX/AyvMCIzhXa5JMhWoBPzXRb/OIhVmlvnpnpZ2Za5oNzCkofaOTzyEZNPrNuhPOBL2jvNkGmF6WTKals6ZxmyCD1Rg4WSdtqk2gAmXepGpLJO2EwaTXa9lEx86OB3ZpA0AGG2jbf5lgzSUxES5W+2Prm3cthxUg9tTECyqg4dZp8xMi975JUMvRFJSsdoqhkcp4VIoSZkd7bIuqYYll/AbaH7HRgoWO0sCUNN56K2wMHgOk2XPxcAVurUDFBmoIXfy/McsIREXqrpXO9xydqc2HTYE5YjmbdoN9bxHc0u6BFI+0UWqe9auN1ob5jmyjc/wdKzA5wsQOXT8Ze1VkWC4M3W2L04Cg/I+uon/Ja1Jwv9PMDutumSR1HmiBUzvIlGl9dKKTHXsQW9KIUZFtGHA7HDtBjum7CaTP88cVWuPjdEtsEaiGvpiIuO4HdlAemvo+wKakgAGGb4thXhy6YWZaraDPOdU1uBW0Vdn6CRAowst79xdJ4tsll3YMGDhZyu6bSc2AhOvBjAb0TbmH6nV0G1bkpZ1pmm7x14L/zF2gf4fF2yF2WSheDs/lYPBnJXZUG19405yXK3LVimYlQNaOL7DuaqrMOgf8xqbkhHVsBFQSvnk2+rXhVdltS00Z0yaS75EN/AK/nplgIbYteVTqtSVqHllJVm/cif690C9bI/ciDbPM9c6/a2txf+Ft+/V43OMalpJee2GQd69k2GYY9d+RSFMHC2Gm1k7W4HqQ2f3VWOvxMe7JxkEXsia8D6j0iG+AmP3AqQ9zvSPRcs34iREhD4VzKh8I7Q0EdvTiRfwPC2O+NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(38350700002)(1076003)(8676002)(966005)(38100700002)(44832011)(54906003)(316002)(508600001)(6666004)(8936002)(36756003)(66476007)(66556008)(186003)(6506007)(956004)(83380400001)(4326008)(2906002)(26005)(6486002)(110136005)(86362001)(2616005)(52116002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RR/HtBWarN4ZBUbbEqFCtWaPkxtyPAwsiazrKbkzD8V3VyTrgCtf/lVbbc4h?=
 =?us-ascii?Q?x7AXfE75Xbwp8GEvIbgpd/dVMyMT4kVBIsDv6cR9ZB6J2DCxRCtxwuPH4rH1?=
 =?us-ascii?Q?EOv6WJS0g/hl1c6FJvJ1bS9Nx8tRVl3mq0daSPbGGIihfT8VMzc8CmF41L5G?=
 =?us-ascii?Q?QrJBmH/5Kqsdi9hnks4MPoFZ5Pa7SlDSyV6o7rJ3lpoWmlwsvY9rsO/onrjA?=
 =?us-ascii?Q?ZdvljrtFT6etY6hfTpDkg72vl1j6cHfYJdjoCpO3XfFAGFfUCi8CjC+fIVMK?=
 =?us-ascii?Q?67V4L2By3vOY3UHUb/9JXy6apCuk7ntmK/emX7bhAYxe7EOrrWX4xHDIJ61R?=
 =?us-ascii?Q?3yKH0mauH8ydmgzq19UcUGsCxylxrDHJmuuDJnX0IuP9SY8uPkc/SivX/Jlh?=
 =?us-ascii?Q?Df0ElCOrm7ILYB8R+qrAw/PsEME18UYgUfEwbDKGL2CilImplQBBVtm/5gp1?=
 =?us-ascii?Q?lnQ1b4B/lEoiyu84h34jXmkwej33NftBs7j6iPag7RqFqcJyWAEycUq9v6J+?=
 =?us-ascii?Q?hQbfmz9590Tk5/ZRh5XrSNk9pKfAck8c1UJRt2HWTXCgEDpD+AA63JiOiL6N?=
 =?us-ascii?Q?KdQSznrehWxkls9JC9YMSynvh0GgH2rUJIDCqbSHc4vSCLAhZuUMt/50YDED?=
 =?us-ascii?Q?5Hdd44wDGurAsYxjyi1hndgqph6oRvkW6jC/GBygRKnt3CwKmRkwL9xxhfTp?=
 =?us-ascii?Q?fdMQIAOCnchbuZlhGx8FE29A6hwAFmrV+OrxLsnIKOJO2hf7mbZn1DLV4DKl?=
 =?us-ascii?Q?o/ujObLruYJTc/zqbmxapIDTVu/ASXsNxhcCExo23ee7lJLfK63hPiW5FdpS?=
 =?us-ascii?Q?o8R4E4SD4YdWspL1PFVy1RjeCTTUJNJMbc3ZziUy3K/25Ou+3UjmkaT9uHxK?=
 =?us-ascii?Q?xZuhk0jq/y/VZNTvg/MFT+3AtF3N25iwyNxtnOnkmm/mBHeBxvuFgstRcRgf?=
 =?us-ascii?Q?N/f7sGo8p/gKaoeai1IbBg46ciU/ep3zMdnggOquaqjNwEqJtA9Bi6lTgcns?=
 =?us-ascii?Q?hn03s/94UiAHRqGUvWrTpq+lSufJy2JXzEJtlwBy6JC5eVwx6bjbTVQZMRKH?=
 =?us-ascii?Q?vi+K3OC7kcAAxoxNo+L3JfPB/2uSpSPewswJC3LH15Nec8K//XMfdBfhrcv0?=
 =?us-ascii?Q?Na9NVwGcuqjLSPW9k3y7dCNRhh71knxDDLuJz8vIWKahtJUvV7AnTWK9vTg1?=
 =?us-ascii?Q?pMVZ9ELAW4YzR9Aq2mcWB1C6gba5a7EXyZaKhtZI1cIaqseOUZp+DNwFzSe0?=
 =?us-ascii?Q?bh364Ktrbvzkd2El4b1zn6cx0cXYByhs/2wbikiyCDgB+DqMfMw6Rcd+w8JM?=
 =?us-ascii?Q?/uIPNKsHa62DwRJkkBiCceEY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e2f62c-97e2-4186-5d22-08d986bc6f94
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2021 22:23:33.5422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6CdnU17FK8ohjaf03gt1bWU2a0WlRp9knJcPbclLXiJaTeILo0OkBDAGGJ627yOR7dGoD6ytBelRF4/I7Njo0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The present code is structured this way due to an incomplete thought
process. In Documentation/networking/switchdev.rst we document that if a
bridge is VLAN-unaware, then the presence or lack of a pvid on a bridge
port (or on the bridge itself, for that matter) should not affect the
ability to receive and transmit tagged or untagged packets.

If the bridge on behalf of which we are sending this packet is
VLAN-aware, then the TX forwarding offload API ensures that the skb will
be VLAN-tagged (if the packet was sent by user space as untagged, it
will get transmitted town to the driver as tagged with the bridge
device's pvid). But if the bridge is VLAN-unaware, it may or may not be
VLAN-tagged. In fact the logic to insert the bridge's PVID came from the
idea that we should emulate what is being done in the VLAN-aware case.
But we shouldn't.

It appears that injecting packets using a VLAN ID of 0 serves the
purpose of forwarding the packets to the egress port with no VLAN tag
added or stripped by the hardware, and no filtering being performed.
So we can simply remove the superfluous logic.

There are in fact two independent reasons why having this logic is broken:

(1) When CONFIG_BRIDGE_VLAN_FILTERING=n, we call br_vlan_get_pvid_rcu()
    but that returns an error and we do error out, dropping all packets
    on xmit. Not really smart. This is also an issue when the user
    deletes the bridge pvid:

    $ bridge vlan del dev br0 vid 1 self

    As mentioned, in both cases, packets should still flow freely, and
    they do just that on any net device where the bridge is not offloaded,
    but on mv88e6xxx they don't.

(2) that code actually triggers a lockdep warning due to the fact that
    it dereferences bridge private data that assumes rcu_preempt protection
    (rcu_read_lock), but rcu_read_lock is not actually held during
    .ndo_start_xmit, but rather rcu_read_lock_bh (rcu_bh), which has its
    own lockdep keys.

The solution to both problems is the same: delete the broken code.

Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20211003155141.2241314-1-andrew@lunn.ch/
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210928233708.1246774-1-vladimir.oltean@nxp.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_dsa.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 77d0ce89ab77..7e35bcda91c9 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -129,12 +129,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 	u8 tag_dev, tag_port;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
-	u16 pvid = 0;
-	int err;
 
 	if (skb->offload_fwd_mark) {
 		struct dsa_switch_tree *dst = dp->ds->dst;
-		struct net_device *br = dp->bridge_dev;
 
 		cmd = DSA_CMD_FORWARD;
 
@@ -144,19 +141,6 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 */
 		tag_dev = dst->last_switch + 1 + dp->bridge_num;
 		tag_port = 0;
-
-		/* If we are offloading forwarding for a VLAN-unaware bridge,
-		 * inject packets to hardware using the bridge's pvid, since
-		 * that's where the packets ingressed from.
-		 */
-		if (!br_vlan_enabled(br)) {
-			/* Safe because __dev_queue_xmit() runs under
-			 * rcu_read_lock_bh()
-			 */
-			err = br_vlan_get_pvid_rcu(br, &pvid);
-			if (err)
-				return NULL;
-		}
 	} else {
 		cmd = DSA_CMD_FROM_CPU;
 		tag_dev = dp->ds->index;
@@ -188,8 +172,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 
 		dsa_header[0] = (cmd << 6) | tag_dev;
 		dsa_header[1] = tag_port << 3;
-		dsa_header[2] = pvid >> 8;
-		dsa_header[3] = pvid & 0xff;
+		dsa_header[2] = 0;
+		dsa_header[3] = 0;
 	}
 
 	return skb;
-- 
2.25.1

