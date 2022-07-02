Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B95B563EEC
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 09:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiGBHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 03:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiGBHgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 03:36:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94591C132
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 00:36:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ego1OOavlPkAXghcFG+Ax9NH4Oc6HLyhZ/lK6zitNw8TezXs72QVM83XD6mzVt9PfjQ1Kec8lP9BACgjMPmEdRHHI8oxclGNVUo6FWuedLmzP9yoJgrUsBq+Eih7rocpGTl3Z1g/WhsXpWIvqh5uWgPaaPBzOkJws/OaFeF/PPR7d5XWa1jUbHf1QX/o03IrSSEEvV0/BBY7SXb0JLEcM1vANCo845YebL1wrDRnwN9zeFFbLWy6dImaoKXLzchLs+W+SiiQEeE4JUsHjExgBJh/BgFMiltKSZpLD4iCFBXM8dBxIF8RCaw3MJafMhy3r7lZz7wfhxCeKvjDGSFg/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YD7MYS5Qh6cRYiFNyQBCyUHt03UeKV/T8EOacK+8wrs=;
 b=V2SOMQGOeG0rTezG5aLEllA33AEUcGAD2jBg7oecICIR8FPfG/SzrTgv9bDFVJw1f6kQ2SMXPKkrjnYS5bUw3apEuBayPFfiT4Os4+JzRVwlpg28q73mXyNw+vTdV+ax3v9V5i1i0u9fnpK5jYGnv+k+GYzACZJxd86FIQimUsXzZM1mcnivifRgNPYvQdmGT4OUDeIDdcC48f6zqKfD5iQDeIo6Tq9MhbvkwnLnXvvcsHSu/F+SMXMm8CTJk/WlO0uxMwRUUAS1xk+U3Mg9GIGOtKV/SCn5JiRR7uJs913tW4rJiFmXGrcv4lWSEeMNB2VLYighQMjOYDdHKE9zow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD7MYS5Qh6cRYiFNyQBCyUHt03UeKV/T8EOacK+8wrs=;
 b=CCPob6KEVq+0nhvKYZdAMnfRDszR7Y1hAQAK3ldof2F42KgfyIzMqtP4bR3V7XVWTlXUqiGyH+k1WpVWjGCJFnSeEGe2CFblkCb9VHL8nCE564fe6TpyvmozHw+nuUJGgVbibBd3b2Jf3xf/szfJDXkpvxBt1PyfAxZ+ChI8BjA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1068.namprd13.prod.outlook.com (2603:10b6:3:71::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.8; Sat, 2 Jul 2022 07:36:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.011; Sat, 2 Jul 2022
 07:36:08 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>
Subject: [PATCH net-next 1/2] nfp: support RX VLAN ctag/stag strip
Date:   Sat,  2 Jul 2022 09:35:50 +0200
Message-Id: <20220702073551.610012-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220702073551.610012-1-simon.horman@corigine.com>
References: <20220702073551.610012-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3c4c4d9-ff9b-47e9-286a-08da5bfd8778
X-MS-TrafficTypeDiagnostic: DM5PR13MB1068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqy1CGmmg4W2yOSWs/dhMwcq5djtQwB4m3Ire4KVqfYH3p9KaIH/5JeAML+8Z7LQivNtSDwB8dlzZ9wnrG6bJzGEy08Eq9pYhT72N+JHazeu+c7ABHKkU3vjvl7OcLuXiOurNfqsnRZLtnbWggCQbWhn+t9XZbFdoVGPVSfj47uPN0lOtH8C1I0+oQsbSiYHlGT1qb1J0ghiAmFaoBVUH4hRco/19Iyfex3opxxajdVBaNaiE/n8g0ns2cltWGSbF6VFp6iyKdcm8eywAcLiW3VJwyZAJFSmuLu72mBmzJuHMLiGQD3p8fY4OJajSFMfni0VwSQZgXTeRKyDhY4erhvsbtmWoyUajUhY6J4PgmhejRgAuZM9qkw3sKuVgzRsuvpeMkYtv3NRQXtERGi9axEL+dRSjNARLNg4Uire/U7NCPbiJS7QYLXpyCjTSQ/MZJ4+g8CabOXY34/9B9wJpIP8FNHzAneYRxsuF06xGzCdUplvUWfGg84691ZscvAfSNMD8Pzatcyj/T3CDKB+XWyZMOycpMV8kMMGrykJezYLcBCrqMcBRsLOKGR/Yopb2Gqs5UMvz5UcBfUmpEUD8wESA5W+/JaZX3vjxHfwZwbvs0z9Vq44PRxYu4+J85+8BHtAiaCro/H/4uxJb0wwyKEcawo0AzhP2ZE0Q9PZ7FEgJXBaY79mO1lKASdp8hKu28oJRIzgG955ili0Byhu8uWDTIvbygKPRaqloCZDXIjCrQOU01VKpuQ2TWqoHe5QPE0sDRO/B+6+VmsBGeD5RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39830400003)(376002)(366004)(136003)(346002)(38100700002)(478600001)(6506007)(83380400001)(2616005)(186003)(110136005)(1076003)(52116002)(6666004)(6512007)(6486002)(41300700001)(316002)(44832011)(2906002)(8676002)(4326008)(86362001)(107886003)(5660300002)(66476007)(30864003)(66556008)(8936002)(36756003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L1KaAnwnjr/21SxcHVK+4j2EkgSfFxTweAh9soDZUH9lN9X7FvdIw/FOEWn+?=
 =?us-ascii?Q?zNW16Rmz63s+xK/obInC8/70iXpLCHrJaud3mTOrD3F7a/Use2F8oCvvz2R3?=
 =?us-ascii?Q?rgwoHynWaGmKUgiZ/z/BcTIuKm4zDPjJX4q+YizzmMmG+jbYX4ZsYTVmHjtX?=
 =?us-ascii?Q?7jKCe7e0uRlDoxQeJr1czvtdpj5DCeaX2UhsdDVXRiQwf9iWmKIgfkKOdZhF?=
 =?us-ascii?Q?1pLYqJeNtVaxQ0Om3gkfga1yObMDmmebRONqDl8rc46uy5R9hcavdDqNvYbz?=
 =?us-ascii?Q?xcSY7l7rJpAkSPIpTNz063iWWKURadm1lpO2QEsyzXEm9Dd4RGOZicwrcBT9?=
 =?us-ascii?Q?7US2YHwrFXutiIguf7uziSnPEQ/GSiKacHKMTQr83Jg/0Q26ntDqND6dIxsG?=
 =?us-ascii?Q?6R/w+g3d6JJ1h0fEY3zrGXxt3ak1Gm1onAag7/2w7pjUrV1NrUGjVjvoVSZj?=
 =?us-ascii?Q?DR3Jc6iJGJl0SXYrncZHiG0J+52pmdNcBzAuCYXv0+srEFp6qhO9w2xw45fU?=
 =?us-ascii?Q?4d2b6tsegNA270Jz3bsDnc1fWwHdEss7HqkeINhDMKE1kGoCrsYXqpMgImHu?=
 =?us-ascii?Q?kzPx7GIt7P3DgQKfeBIYLOg9/OCTfk1zz/siiG4a0cwrfrh6IYdFym4Bxrvd?=
 =?us-ascii?Q?0SyfOUxPiwL8hAjGiRMjYyneLPMCFrw4paFp9V3ozy9M79wwH2S8a7TT4mNV?=
 =?us-ascii?Q?kw8iHzI5QL3qebZIedDXDoOVsV/aoz8MPq59jYnzerS6Gn4hegE0CarqMDIm?=
 =?us-ascii?Q?vr32tb+rKpthj6MVcnz4etscOFcNtV6Lb2TESphDXF4CPumd1fLhhEF+D9Q2?=
 =?us-ascii?Q?T18DfXuS4Qf9/13o+vjoO8X9G1yOOyLJvyW6oR8+MfqN5oAVQyu11zZdz8Fb?=
 =?us-ascii?Q?i8GcRiFUIf4eP8NAMVNXzb3RTdQBJ8eNKiIxMqV/1aILz8QIrTNzh2jCbxiL?=
 =?us-ascii?Q?K20RUN8AxhOMuEe70j3IbYYzTEA0Kx9p8axL2E3rvz45/RnFOCbpayOaBF/b?=
 =?us-ascii?Q?2NlWVTU52NjjCChQaqwJ4tZ98RFnF8kf9J0UdFtB3wcfXIh+JC1eMiH870UL?=
 =?us-ascii?Q?PzQDUKcGCSh6Z0C+09GBkLfrmc0OS7DLJSZYWI93DE4bceLn67iTiSTJL64l?=
 =?us-ascii?Q?+0k1arXV+XpkuMtuTk1leCYq+91VpcAkjap+96TSoPnmHi1+TdKzxZH5KyiW?=
 =?us-ascii?Q?ZvlLZmvJ9svvwVD1v6e2gHdDt0vZsYz3Bpc5YE8dmTTscC+sEgeyWyoTnIdG?=
 =?us-ascii?Q?LXWHwpf9KdkkhZ3QX31IkO0uEPasViFIC5xxL5jkai0XtW6X+OySSFd50FEU?=
 =?us-ascii?Q?Po4d3EEruz6N17BHsU1G5SSBFY+jFun/Y2EkJr0R7gy7FzEDTTBqJ++G9zV1?=
 =?us-ascii?Q?42N2df58p+v80zN+YfAHTPH7gbVTXow003GyAqv4QXdHT5tDWA1s/I6LaOfa?=
 =?us-ascii?Q?GJIeHX1vjgxPz2IxLDREPa4E3IbDi54fICGR8MvuQTkxx8wCNKQl0lbYoDFC?=
 =?us-ascii?Q?X0WSep32X9znaB9W5ARYpot2BVtv0ZC/xQinyiJZumX8MTU/s+MNizpzVnYw?=
 =?us-ascii?Q?njpAwuYjlhpA8KNfG/qCn11Z1YBcwFa4QMWgyzkXUuNJywUXZ9Q+Y9Xl5hS9?=
 =?us-ascii?Q?SOKa9beCrwL7lPWxFeG4geYTH96EeIZqE25hMHbDgg9+08nrYmu8AEqb9dYx?=
 =?us-ascii?Q?RTCNKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c4c4d9-ff9b-47e9-286a-08da5bfd8778
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 07:36:08.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MA2sJx0a40Va2DoQn3ud0HKu+Czfp8rdj18pwSua4ccP2uyQEzmL32Oblnp99kpZTs0x16PaPz0pYAGl+PX83U1AQuQA4KkNCUWm8amZ11Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1068
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

Add support for RX VLAN ctag/stag strip
which may be configured via ethtool.

e.g.
     # ethtool -K $DEV rx-vlan-offload on
     # ethtool -K $DEV rx-vlan-stag-hw-parse on

Ctag-stripped and stag-stripped cannot be enabled at the same time
because currently the kernel supports only one layer of VLAN stripping.

The NIC supplies VLAN strip information as packet metadata.
The fields of this VLAN metadata are:

* strip flag: 1 for stripped; 0 for unstripped
* tci: VLAN TCI ID
* tpid: 1 for ETH_P_8021AD; 0 for ETH_P_8021Q

Configuration control bits NFP_NET_CFG_CTRL_RXVLAN_V2 and
NFP_NET_CFG_CTRL_RXQINQ are to signal availability of
ctag-strip and stag-strip features of the firmware.

Signed-off-by: Diana Wang <na.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 22 +++++--
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  1 +
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  9 ++-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 21 +++++--
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  7 +++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 57 ++++++++++++++++---
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 10 ++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   | 24 ++++++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |  2 +
 .../net/ethernet/netronome/nfp/nfp_net_repr.c | 11 +++-
 11 files changed, 143 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index f9410d59146d..c207581ed00a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -3,6 +3,7 @@
 
 #include <linux/bpf_trace.h>
 #include <linux/netdevice.h>
+#include <linux/bitfield.h>
 
 #include "../nfp_app.h"
 #include "../nfp_net.h"
@@ -704,7 +705,7 @@ bool
 nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		    void *data, void *pkt, unsigned int pkt_len, int meta_len)
 {
-	u32 meta_info;
+	u32 meta_info, vlan_info;
 
 	meta_info = get_unaligned_be32(data);
 	data += 4;
@@ -722,6 +723,17 @@ nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 			meta->mark = get_unaligned_be32(data);
 			data += 4;
 			break;
+		case NFP_NET_META_VLAN:
+			vlan_info = get_unaligned_be32(data);
+			if (FIELD_GET(NFP_NET_META_VLAN_STRIP, vlan_info)) {
+				meta->vlan.stripped = true;
+				meta->vlan.tpid = FIELD_GET(NFP_NET_META_VLAN_TPID_MASK,
+							    vlan_info);
+				meta->vlan.tci = FIELD_GET(NFP_NET_META_VLAN_TCI_MASK,
+							   vlan_info);
+			}
+			data += 4;
+			break;
 		case NFP_NET_META_PORTID:
 			meta->portid = get_unaligned_be32(data);
 			data += 4;
@@ -1050,9 +1062,11 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 		}
 #endif
 
-		if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
-			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-					       le16_to_cpu(rxd->rxd.vlan));
+		if (unlikely(!nfp_net_vlan_strip(skb, rxd, &meta))) {
+			nfp_nfd3_rx_drop(dp, r_vec, rx_ring, NULL, skb);
+			continue;
+		}
+
 		if (meta_len_xdp)
 			skb_metadata_set(skb, meta_len_xdp);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index f65851ed5b50..0390b754a399 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -247,6 +247,7 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 	 NFP_NET_CFG_CTRL_L2BC | NFP_NET_CFG_CTRL_L2MC |		\
 	 NFP_NET_CFG_CTRL_RXCSUM | NFP_NET_CFG_CTRL_TXCSUM |		\
 	 NFP_NET_CFG_CTRL_RXVLAN | NFP_NET_CFG_CTRL_TXVLAN |		\
+	 NFP_NET_CFG_CTRL_RXVLAN_V2 | NFP_NET_CFG_CTRL_RXQINQ |		\
 	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
 	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
 	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_RSS |		\
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
index 454fea4c8be2..65e243168765 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
@@ -94,9 +94,12 @@ static void nfp_nfd3_xsk_rx_skb(struct nfp_net_rx_ring *rx_ring,
 
 	nfp_nfd3_rx_csum(dp, r_vec, rxd, meta, skb);
 
-	if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-				       le16_to_cpu(rxd->rxd.vlan));
+	if (unlikely(!nfp_net_vlan_strip(skb, rxd, meta))) {
+		dev_kfree_skb_any(skb);
+		nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+		return;
+	}
+
 	if (meta_xdp)
 		skb_metadata_set(skb,
 				 xrxbuf->xdp->data - xrxbuf->xdp->data_meta);
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 300637e576a8..49c9a78fcc5f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -717,7 +717,7 @@ static bool
 nfp_nfdk_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		    void *data, void *pkt, unsigned int pkt_len, int meta_len)
 {
-	u32 meta_info;
+	u32 meta_info, vlan_info;
 
 	meta_info = get_unaligned_be32(data);
 	data += 4;
@@ -735,6 +735,17 @@ nfp_nfdk_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 			meta->mark = get_unaligned_be32(data);
 			data += 4;
 			break;
+		case NFP_NET_META_VLAN:
+			vlan_info = get_unaligned_be32(data);
+			if (FIELD_GET(NFP_NET_META_VLAN_STRIP, vlan_info)) {
+				meta->vlan.stripped = true;
+				meta->vlan.tpid = FIELD_GET(NFP_NET_META_VLAN_TPID_MASK,
+							    vlan_info);
+				meta->vlan.tci = FIELD_GET(NFP_NET_META_VLAN_TCI_MASK,
+							   vlan_info);
+			}
+			data += 4;
+			break;
 		case NFP_NET_META_PORTID:
 			meta->portid = get_unaligned_be32(data);
 			data += 4;
@@ -1170,9 +1181,11 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 
 		nfp_nfdk_rx_csum(dp, r_vec, rxd, &meta, skb);
 
-		if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
-			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-					       le16_to_cpu(rxd->rxd.vlan));
+		if (unlikely(!nfp_net_vlan_strip(skb, rxd, &meta))) {
+			nfp_nfdk_rx_drop(dp, r_vec, rx_ring, NULL, skb);
+			continue;
+		}
+
 		if (meta_len_xdp)
 			skb_metadata_set(skb, meta_len_xdp);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
index 222ee0e5302f..6cd895d3b571 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
@@ -168,6 +168,7 @@ nfp_nfdk_print_tx_descs(struct seq_file *file,
 	 NFP_NET_CFG_CTRL_L2BC | NFP_NET_CFG_CTRL_L2MC |		\
 	 NFP_NET_CFG_CTRL_RXCSUM | NFP_NET_CFG_CTRL_TXCSUM |		\
 	 NFP_NET_CFG_CTRL_RXVLAN |					\
+	 NFP_NET_CFG_CTRL_RXVLAN_V2 | NFP_NET_CFG_CTRL_RXQINQ |		\
 	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
 	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
 	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_IRQMOD |		\
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index b07cea8e354c..a101ff30a1ae 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -248,6 +248,8 @@ struct nfp_net_rx_desc {
 };
 
 #define NFP_NET_META_FIELD_MASK GENMASK(NFP_NET_META_FIELD_SIZE - 1, 0)
+#define NFP_NET_VLAN_CTAG	0
+#define NFP_NET_VLAN_STAG	1
 
 struct nfp_meta_parsed {
 	u8 hash_type;
@@ -256,6 +258,11 @@ struct nfp_meta_parsed {
 	u32 mark;
 	u32 portid;
 	__wsum csum;
+	struct {
+		bool stripped;
+		u8 tpid;
+		u16 tci;
+	} vlan;
 };
 
 struct nfp_net_rx_hash {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index bcdd5ab0da5a..a8b877a5e438 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1695,9 +1695,10 @@ static int nfp_net_set_features(struct net_device *netdev,
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
 		if (features & NETIF_F_HW_VLAN_CTAG_RX)
-			new_ctrl |= NFP_NET_CFG_CTRL_RXVLAN;
+			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ?:
+				    NFP_NET_CFG_CTRL_RXVLAN;
 		else
-			new_ctrl &= ~NFP_NET_CFG_CTRL_RXVLAN;
+			new_ctrl &= ~NFP_NET_CFG_CTRL_RXVLAN_ANY;
 	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_TX) {
@@ -1714,6 +1715,13 @@ static int nfp_net_set_features(struct net_device *netdev,
 			new_ctrl &= ~NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
 
+	if (changed & NETIF_F_HW_VLAN_STAG_RX) {
+		if (features & NETIF_F_HW_VLAN_STAG_RX)
+			new_ctrl |= NFP_NET_CFG_CTRL_RXQINQ;
+		else
+			new_ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
+	}
+
 	if (changed & NETIF_F_SG) {
 		if (features & NETIF_F_SG)
 			new_ctrl |= NFP_NET_CFG_CTRL_GATHER;
@@ -1742,6 +1750,27 @@ static int nfp_net_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static netdev_features_t
+nfp_net_fix_features(struct net_device *netdev,
+		     netdev_features_t features)
+{
+	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    (features & NETIF_F_HW_VLAN_STAG_RX)) {
+		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+			features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev->wanted_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_warn(netdev,
+				    "S-tag and C-tag stripping can't be enabled at the same time. Enabling S-tag stripping and disabling C-tag stripping\n");
+		} else if (netdev->features & NETIF_F_HW_VLAN_STAG_RX) {
+			features &= ~NETIF_F_HW_VLAN_STAG_RX;
+			netdev->wanted_features &= ~NETIF_F_HW_VLAN_STAG_RX;
+			netdev_warn(netdev,
+				    "S-tag and C-tag stripping can't be enabled at the same time. Enabling C-tag stripping and disabling S-tag stripping\n");
+		}
+	}
+	return features;
+}
+
 static netdev_features_t
 nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		       netdev_features_t features)
@@ -1978,6 +2007,7 @@ const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_change_mtu		= nfp_net_change_mtu,
 	.ndo_set_mac_address	= nfp_net_set_mac_address,
 	.ndo_set_features	= nfp_net_set_features,
+	.ndo_fix_features	= nfp_net_fix_features,
 	.ndo_features_check	= nfp_net_features_check,
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
 	.ndo_bpf		= nfp_net_xdp,
@@ -2009,6 +2039,7 @@ const struct net_device_ops nfp_nfdk_netdev_ops = {
 	.ndo_change_mtu		= nfp_net_change_mtu,
 	.ndo_set_mac_address	= nfp_net_set_mac_address,
 	.ndo_set_features	= nfp_net_set_features,
+	.ndo_fix_features	= nfp_net_fix_features,
 	.ndo_features_check	= nfp_net_features_check,
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
 	.ndo_bpf		= nfp_net_xdp,
@@ -2062,7 +2093,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->fw_ver.extend, nn->fw_ver.class,
 		nn->fw_ver.major, nn->fw_ver.minor,
 		nn->max_mtu);
-	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		nn->cap,
 		nn->cap & NFP_NET_CFG_CTRL_PROMISC  ? "PROMISC "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_L2BC     ? "L2BCFILT " : "",
@@ -2071,6 +2102,8 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->cap & NFP_NET_CFG_CTRL_TXCSUM   ? "TXCSUM "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_RXVLAN   ? "RXVLAN "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_TXVLAN   ? "TXVLAN "   : "",
+		nn->cap & NFP_NET_CFG_CTRL_RXQINQ   ? "RXQINQ "   : "",
+		nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ? "RXVLANv2 "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_SCATTER  ? "SCATTER "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_GATHER   ? "GATHER "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_LSO      ? "TSO1 "     : "",
@@ -2358,9 +2391,10 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 
 	netdev->vlan_features = netdev->hw_features;
 
-	if (nn->cap & NFP_NET_CFG_CTRL_RXVLAN) {
+	if (nn->cap & NFP_NET_CFG_CTRL_RXVLAN_ANY) {
 		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
-		nn->dp.ctrl |= NFP_NET_CFG_CTRL_RXVLAN;
+		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ?:
+			       NFP_NET_CFG_CTRL_RXVLAN;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXVLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO2) {
@@ -2374,15 +2408,22 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
+	if (nn->cap & NFP_NET_CFG_CTRL_RXQINQ) {
+		netdev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
+		nn->dp.ctrl |= NFP_NET_CFG_CTRL_RXQINQ;
+	}
 
 	netdev->features = netdev->hw_features;
 
 	if (nfp_app_has_tc(nn->app) && nn->port)
 		netdev->hw_features |= NETIF_F_HW_TC;
 
-	/* Advertise but disable TSO by default. */
-	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
-	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_LSO_ANY;
+	/* Advertise but disable TSO by default.
+	 * C-Tag strip and S-Tag strip can't be supported simultaneously,
+	 * so enable C-Tag strip and disable S-Tag strip by default.
+	 */
+	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_STAG_RX);
+	nn->dp.ctrl &= ~(NFP_NET_CFG_CTRL_LSO_ANY | NFP_NET_CFG_CTRL_RXQINQ);
 
 	/* Finalise the netdev setup */
 	switch (nn->dp.ops->version) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 9007675db67f..e03234fc9475 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -31,10 +31,16 @@
 #define NFP_NET_LSO_MAX_HDR_SZ		255
 #define NFP_NET_LSO_MAX_SEGS		64
 
+/* working with metadata vlan api (NFD version >= 2.0) */
+#define NFP_NET_META_VLAN_STRIP			BIT(31)
+#define NFP_NET_META_VLAN_TPID_MASK		GENMASK(19, 16)
+#define NFP_NET_META_VLAN_TCI_MASK		GENMASK(15, 0)
+
 /* Prepend field types */
 #define NFP_NET_META_FIELD_SIZE		4
 #define NFP_NET_META_HASH		1 /* next field carries hash type */
 #define NFP_NET_META_MARK		2
+#define NFP_NET_META_VLAN		4 /* ctag or stag type */
 #define NFP_NET_META_PORTID		5
 #define NFP_NET_META_CSUM		6 /* checksum complete type */
 #define NFP_NET_META_CONN_HANDLE	7
@@ -89,6 +95,8 @@
 #define   NFP_NET_CFG_CTRL_LSO		  (0x1 << 10) /* LSO/TSO (version 1) */
 #define   NFP_NET_CFG_CTRL_CTAG_FILTER	  (0x1 << 11) /* VLAN CTAG filtering */
 #define   NFP_NET_CFG_CTRL_CMSG_DATA	  (0x1 << 12) /* RX cmsgs on data Qs */
+#define   NFP_NET_CFG_CTRL_RXQINQ	  (0x1 << 13) /* Enable S-tag strip */
+#define   NFP_NET_CFG_CTRL_RXVLAN_V2	  (0x1 << 15) /* Enable C-tag strip */
 #define   NFP_NET_CFG_CTRL_RINGCFG	  (0x1 << 16) /* Ring runtime changes */
 #define   NFP_NET_CFG_CTRL_RSS		  (0x1 << 17) /* RSS (version 1) */
 #define   NFP_NET_CFG_CTRL_IRQMOD	  (0x1 << 18) /* Interrupt moderation */
@@ -111,6 +119,8 @@
 					 NFP_NET_CFG_CTRL_CSUM_COMPLETE)
 #define NFP_NET_CFG_CTRL_CHAIN_META	(NFP_NET_CFG_CTRL_RSS2 | \
 					 NFP_NET_CFG_CTRL_CSUM_COMPLETE)
+#define NFP_NET_CFG_CTRL_RXVLAN_ANY	(NFP_NET_CFG_CTRL_RXVLAN | \
+					 NFP_NET_CFG_CTRL_RXVLAN_V2)
 
 #define NFP_NET_CFG_UPDATE		0x0004
 #define   NFP_NET_CFG_UPDATE_GEN	  (0x1 <<  0) /* General update */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
index 34dd94811df3..550df83b798c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
@@ -440,3 +440,27 @@ bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
 
 	return ret;
 }
+
+bool nfp_net_vlan_strip(struct sk_buff *skb, const struct nfp_net_rx_desc *rxd,
+			const struct nfp_meta_parsed *meta)
+{
+	u16 tpid = 0, tci = 0;
+
+	if (rxd->rxd.flags & PCIE_DESC_RX_VLAN) {
+		tpid = ETH_P_8021Q;
+		tci = le16_to_cpu(rxd->rxd.vlan);
+	} else if (meta->vlan.stripped) {
+		if (meta->vlan.tpid == NFP_NET_VLAN_CTAG)
+			tpid = ETH_P_8021Q;
+		else if (meta->vlan.tpid == NFP_NET_VLAN_STAG)
+			tpid = ETH_P_8021AD;
+		else
+			return false;
+
+		tci = meta->vlan.tci;
+	}
+	if (tpid)
+		__vlan_hwaccel_put_tag(skb, htons(tpid), tci);
+
+	return true;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 83becb338478..831c83ce0d3d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -106,6 +106,8 @@ int nfp_net_tx_rings_prepare(struct nfp_net *nn, struct nfp_net_dp *dp);
 void nfp_net_rx_rings_free(struct nfp_net_dp *dp);
 void nfp_net_tx_rings_free(struct nfp_net_dp *dp);
 void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring);
+bool nfp_net_vlan_strip(struct sk_buff *skb, const struct nfp_net_rx_desc *rxd,
+			const struct nfp_meta_parsed *meta);
 
 enum nfp_nfd_version {
 	NFP_NFD_VER_NFD3,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 75b5018f2e1b..066cce1db85d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -365,7 +365,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 
 	netdev->vlan_features = netdev->hw_features;
 
-	if (repr_cap & NFP_NET_CFG_CTRL_RXVLAN)
+	if (repr_cap & NFP_NET_CFG_CTRL_RXVLAN_ANY)
 		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 	if (repr_cap & NFP_NET_CFG_CTRL_TXVLAN) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO2)
@@ -375,11 +375,16 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	}
 	if (repr_cap & NFP_NET_CFG_CTRL_CTAG_FILTER)
 		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	if (repr_cap & NFP_NET_CFG_CTRL_RXQINQ)
+		netdev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
 
 	netdev->features = netdev->hw_features;
 
-	/* Advertise but disable TSO by default. */
-	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+	/* Advertise but disable TSO by default.
+	 * C-Tag strip and S-Tag strip can't be supported simultaneously,
+	 * so enable C-Tag strip and disable S-Tag strip by default.
+	 */
+	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_STAG_RX);
 	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
-- 
2.30.2

