Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2D641F100
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355024AbhJAPRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:17:35 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:29755
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355001AbhJAPRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:17:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rj1Q1pD4HU3P5RIRcgF/A8bAbKytNUL/ayqfwSyalYSj5RgYKgbk1PaAb4UpeXmnSLWVJ/3dqWu1CAzv9PRJSmepMf+TZFFl1Up4uwJ7d4YVgcJjnuBnNdhBqyB8Y/zuttXs6lsgOIfmVg4bPARWrVNu5C1xX+XUxal/BpA+gjoU9iTA+oeLS3cpKhMcfIqfh69dXvn0rqfBX6twr64ghzgGjAERK5UETnfRJR4sjt3HXmHWskv8P0Lca8mn4l910PG85k94CNhrGVRgciV+Ky7hFZZ3t5BPDoLsuxYgKEtXCpYAIQhtf1y1fE9T4Xu1VcwNacPE0rTXHU8v2py2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2rTKjsHkohK/eAc107f03ujoC3S+tGPKzaIGR+QkXg=;
 b=Dahs4eRsgY4w99KJtZFeG1E1LhoEiUmq/9ZcmlhMxijS2tXDyRQj9j7tLhp7OtaoPqenqVBy4SUyOJyOxvPW0cVcdxzm8+K72zoN51FYNzan0Nv4cnM6PwB9bevLzxP9VKTIX+DPE2uO3PC/zJDO+wFle71+5MM4nDlgJuf0//Mno9Oxzri2h21GyhbMd+zcbqyJ07dOjCwdMBURU7Ktda6E7w3IqIQUThseVDkAoC3dluhPMMnHCIRGZbxAG9mfQdV7Iu5h24NvhIKMxJGBnUGu6CJBx/wo7yTkUiZ5azdTp46Ei0Aa8ouoc+Iw+wmQjVueRdFdG5gniqCA9iJlxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2rTKjsHkohK/eAc107f03ujoC3S+tGPKzaIGR+QkXg=;
 b=c6N45mzxdahwlfMSMo47VDHpqj2BePliWNOEpBcunnPiYJpulGiP+xvAtvRKQrV2zo9iZ5Bvb5B0Gc/D/9n9y0RBeRYebobXpYCvptnGsX9t96xPGSz3GFysgipOldMjyI1U0Ux/R94nDchfOwNHrQFQLS8sI38z+7KhynFEvh0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:15:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:15:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next 3/6] net: dsa: tag_ocelot: set the classified VLAN during xmit
Date:   Fri,  1 Oct 2021 18:15:28 +0300
Message-Id: <20211001151531.2840873-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
References: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0001.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:208:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:15:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c120328-3ff0-4fc2-4fa9-08d984ee57c7
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB422496D512FE552CADE736FEE0AB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3oagpZkNSzYz2hrHcKQBCe/NwfV/Lx8vsv/+imqv88pt+whX0rcUJcdNDxbGIptxKOMHfSep5fSKpL1HJiWOIfXOddw1mupNXYVZRTBhBlBkgeK4Sh1AKgSr7LteZopjwAUu2z8vS5Qeo/RaH4BTFjuo4g+FmiPT4E8prNpobpfGNPpxll1UGtZp3wTEfxDWaw6rZMDQSGgYNdhg0JXxEEyi8xNB7TZZADtU3S40cVDYHrXDqZjv/bNLwXuf4fy1XCvCQTnoAQvCVMZ4sgyzFFFPMmL+pG272sHStYCcAvbSKk800JJ5pDaSpnH8XBYJVG33HjHzA+ZtRgKbtQpjDK1LLGyK98n7YhB4r3pqQWBsCUMpmTk7Qj78oQ1rAfXaAzy1u/QX+8tb+90uPCZHcZ/QmvONa1/msx+UQ/eIC4Vm30R8LWcTNuRCD8taMLXmL3dmKek8LDW5QNTkCbXoQ1PUeHAtMoxjVfsn5d7bu+XxNyy30SSUdJ16tnJERAixbE/rDbfJxW9xXAsKAUI+YYF1myRiAthMzgpDzY7zl435zRjVcoVZ3HVe+q+gbABPpI1quI7LMEguzXgXZLzQDe/lIJHI1JQ6plHqwAGQH464baAUz5fGF1CvbyqTcUvM/COQfQmdQd9+71PZ3bd+6dwewno0DeP9aJ0gdByaLJHrNK5/HpLTK28bXp3yZE5rnbW5voG526gTBuedwlSOPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(1076003)(5660300002)(6512007)(26005)(38350700002)(38100700002)(956004)(110136005)(66574015)(8676002)(2616005)(36756003)(54906003)(52116002)(6506007)(8936002)(66946007)(508600001)(4326008)(83380400001)(186003)(2906002)(6486002)(66556008)(86362001)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hMpTrpCPGDThSc9AovUGBLT1G1ptRoV0OA/m3FmPE+b/ShIS3VfCUo2LzEgw?=
 =?us-ascii?Q?QSjzA0e8mEZKTpykldYwDR/rF8egCqRCwEZoMw6FZtnkLk1l6KrIeTcQeV8I?=
 =?us-ascii?Q?NYnBw00oMe1fNcPYltxUz/NjALAmeOTKlZGtlxMoTg0AJJSB00HYJIZyuNQa?=
 =?us-ascii?Q?ThNmtw3/epS0+bPke0UmfGmjlUDNaMwWaFI+Bk6RZxh7y/U4455d6NSKkz/j?=
 =?us-ascii?Q?bcxLVIlNHDHQCirZQ/uZRYImQOcO1oGZidnUzo0ecSxH+vQ0yiWSZ45O2oq8?=
 =?us-ascii?Q?p6vRm22BlgJiLgA0fRyfCrIIZVyXuPf5W4XtX0duPlQDi7os0flZn8AsDk7H?=
 =?us-ascii?Q?Um66T5wOL/qo6GpBoFnc0KeJCPniIqRExgDmI83JuQ5mXRqhLLd5VtFRSN9A?=
 =?us-ascii?Q?XkBupu+v12ZfsquS8xObPGE736cGiTel57APYYqBDjY4+9eYuZZhJh/m+34s?=
 =?us-ascii?Q?Lnua1afgGHIluxPxooh7IDJZ4nR2oz6V+aoY3UCyvDGzRV+562Kd2vxfbxjU?=
 =?us-ascii?Q?rtVWRhspUqkYW9COHjBNCZ25XxHFQfTT+AyNzqr5gMzCMhr4ccqGEKxJ0U4k?=
 =?us-ascii?Q?hzkQ0muUOOdpnh0WcoOfXVjoWmbVJzGtcjOl+JnwwPYoljLuIZpsV+dN+kg0?=
 =?us-ascii?Q?9o3l2n7r8Zxl0bVqX9RuiP9b5XyV0zKuDR4zWG7tI7sOkfKYNp/HQAdjEEeJ?=
 =?us-ascii?Q?G1ZXelwZZfL18CTekr5H+G0xEvPtDFYd94usDU3XiWPYlzG3JlmvJr+Yqbgi?=
 =?us-ascii?Q?1FW2cogrTS18AZU5d1ePM4DdA+5i4yCIfkllupc0ifj7BMqyJgk49usCApU8?=
 =?us-ascii?Q?Aoz6SdF3QhU1h3GPQvAbS2xwi6zmx95DHEvSSI85fOPh/iu0Ac0B7B/cQYUD?=
 =?us-ascii?Q?YXtIBlwG0JQV/o0wBzj95KbdtMMVLQ+ntzd0/XhI63zlJgv2LOUuqwcJsuso?=
 =?us-ascii?Q?4wJrDb3SVvvbgCbcMN8FjJFrbnXE2az+VPOUhM5xjps41yFfOh3qBm7S/jcE?=
 =?us-ascii?Q?37lcfXuoVlCkclNDaY0o+EWcrADaJhHC6UGciYHetNV2K6gDvL7zjqeXaxva?=
 =?us-ascii?Q?6ut5ybSsyGaENywedEVfBuWKz42B9Myk0ZkhZe20LOUgo8j/u9byZbSzXqDn?=
 =?us-ascii?Q?zwnPlv4ZJ+GhGzVe4lel4TB5Dc+IEG1KtocfSStOo7sObVFtLaRGJf6HPRdT?=
 =?us-ascii?Q?15lQJo6gI+X7eI2f5vTAY07CZPvPYhW18B8HtjG8Km2Vaa26rcw78HorEqfa?=
 =?us-ascii?Q?94/lEmf+2ij0mgHh+HRtTvATWglUNoALiKSufJhWXgLCTvJIo7prc1DUJvbC?=
 =?us-ascii?Q?J9LwzStrZckzBeQy6EnR/tcm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c120328-3ff0-4fc2-4fa9-08d984ee57c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:15:46.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fweLGXKRylv+j31JdokaJhWqAnNq2gP73DyBc8PEZ6mu9cwbndbn51hgPAd+6TzahjJlqo8yqQDnUUDV4VvTCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, all packets injected into Ocelot switches are classified to
VLAN 0, regardless of whether they are VLAN-tagged or not. This is
because the switch only looks at the VLAN TCI from the DSA tag.

VLAN 0 is then stripped on egress due to REW_TAG_CFG_TAG_CFG. There are
2 cases really, below is the explanation for ocelot_port_set_native_vlan:

- Port is VLAN-aware, we set REW_TAG_CFG_TAG_CFG to 1 (egress-tag all
  frames except VID 0 and the native VLAN) if a native VLAN exists, or
  to 3 otherwise (tag all frames, including VID 0).

- Port is VLAN-unaware, we set REW_TAG_CFG_TAG_CFG to 0 (port tagging
  disabled, classified VLAN never appears in the packet).

One can already see an inconsistency: when a native VLAN exists, VID 0
is egress-untagged, but when it doesn't, VID 0 is egress-tagged.

So when we do this:
ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master br0
bridge vlan del dev swp0 vid 1
bridge vlan add dev swp0 vid 1 pvid # but not untagged

and we ping through swp0, packets will look like this:

MAC > 33:33:00:00:00:02, ethertype 802.1Q (0x8100): vlan 0, p 0,
	ethertype 802.1Q (0x8100), vlan 1, p 0, ethertype IPv6 (0x86dd),
	ICMP6, router solicitation, length 16

So VID 1 frames (sent that way by the Linux bridge) are encapsulated in
a VID 0 header - the classified VLAN of the packets as far as the hw is
concerned. To avoid that, what we really need to do is stop injecting
packets using the classified VLAN of 0.

This patch strips the VLAN header from the skb payload, if that VLAN
exists and if the port is under a VLAN-aware bridge. Then it copies that
VLAN header into the DSA injection frame header.

A positive side effect is that VCAP ES0 VLAN rewriting rules now work
for packets injected from the CPU into a port that's under a VLAN-aware
bridge, and we are able to match those packets by the VLAN ID that was
sent by the network stack, and not by VLAN ID 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ocelot.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 8025ed778d33..d1d070523ea3 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -5,15 +5,52 @@
 #include <soc/mscc/ocelot.h>
 #include "dsa_priv.h"
 
+/* If the port is under a VLAN-aware bridge, remove the VLAN header from the
+ * payload and move it into the DSA tag, which will make the switch classify
+ * the packet to the bridge VLAN. Otherwise, leave the classified VLAN at zero,
+ * which is the pvid of standalone and VLAN-unaware bridge ports.
+ */
+static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
+				      u64 *vlan_tci, u64 *tag_type)
+{
+	struct net_device *br = READ_ONCE(dp->bridge_dev);
+	struct vlan_ethhdr *hdr;
+	u16 proto, tci;
+
+	if (!br || !br_vlan_enabled(br)) {
+		*vlan_tci = 0;
+		*tag_type = IFH_TAG_TYPE_C;
+		return;
+	}
+
+	hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	br_vlan_get_proto(br, &proto);
+
+	if (ntohs(hdr->h_vlan_proto) == proto) {
+		__skb_vlan_pop(skb, &tci);
+		*vlan_tci = tci;
+	} else {
+		rcu_read_lock();
+		br_vlan_get_pvid_rcu(br, &tci);
+		rcu_read_unlock();
+		*vlan_tci = tci;
+	}
+
+	*tag_type = (proto != ETH_P_8021Q) ? IFH_TAG_TYPE_S : IFH_TAG_TYPE_C;
+}
+
 static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 			       __be32 ifh_prefix, void **ifh)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
 	struct dsa_switch *ds = dp->ds;
+	u64 vlan_tci, tag_type;
 	void *injection;
 	__be32 *prefix;
 	u32 rew_op = 0;
 
+	ocelot_xmit_get_vlan_info(skb, dp, &vlan_tci, &tag_type);
+
 	injection = skb_push(skb, OCELOT_TAG_LEN);
 	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
 
@@ -22,6 +59,8 @@ static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
 	ocelot_ifh_set_bypass(injection, 1);
 	ocelot_ifh_set_src(injection, ds->num_ports);
 	ocelot_ifh_set_qos_class(injection, skb->priority);
+	ocelot_ifh_set_vlan_tci(injection, vlan_tci);
+	ocelot_ifh_set_tag_type(injection, tag_type);
 
 	rew_op = ocelot_ptp_rew_op(skb);
 	if (rew_op)
-- 
2.25.1

