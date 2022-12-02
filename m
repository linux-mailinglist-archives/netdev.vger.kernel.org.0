Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66946640388
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiLBJmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbiLBJmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:42:40 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2131.outbound.protection.outlook.com [40.107.223.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66661C1B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 01:42:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDCFQG4hkzjyrgpl1L7OCoGXUMKYj0H0wr0bGMg7uI3UBrl4tNpuXEDLmHjibdL6uLIM8J7YrLjk0+bHKywYqDSeDqKzrAqFB+nqnWsWyH8HeT5L5hLmltiWtzKimRI+6nyFB1TSDafsoyOLspGwnZ5lyn/Y7CD/jQDuErqnReGZUahLKzNyQmxiWpePqL/7PBgjh5bAZToLwNwO2o7hTnZeap/LvRdVKKvv8yRZQ76aUUkVfTfym44jnm1uGldWQhPYQVT0rPvYina501B/SRVG0+efd9FtD3AXMGL65JKt/699qtjt3WLMLSU0sL53ndI6rC5sPeuKkcIuZZFjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAzCyE0g2e6E0dq4FSmMywJw+YYJ34O+pM3s2rd+Z3E=;
 b=V/Jr9j4pxFlCG0W3cLn1MNCd5EkRUt584+amfJDaY0Si+UMoacnUvsAv84MCCNUbe9xf6G2Zrm42JUMarg4y0xxayZ9QqZ3S5yf7ZSYcIuIdsbKh6FhT6L3qfKZhNmVBPhk8F7j+8Db6hUnXF3PFrsrlFEMrggSD2aexLjMpD5g7jwNedsklxSLoD+pqt280ypSkqmRIUONTQYYjkXq+8zHPxM2K0VuIE98dCyaPI+gEMbevSV+VIQiGj+7NGa5LG5XdavEVwgy2lCVI0RyEdbrdYTLnpQ+Q4msAyOoI3pAP0bQk2eSIT2ASbvXgOGSuCcLKNor32Kk32EZ5O+pIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAzCyE0g2e6E0dq4FSmMywJw+YYJ34O+pM3s2rd+Z3E=;
 b=GosiKGWNtTZ5kSiNco+/Myaxquyw03LZPB+roLbQTh7AC6d9LEhKpbjtodv7oQ8dIYIR2ggnVjQx4QMzM3mZovynwujXOwRGH//tsqsad9x/G0k5COX3AgMjdWPjcX71xlheBmTwx7Dzm6DUvRG/+F4s1boHS3DOSabSHAxjscQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3669.namprd13.prod.outlook.com (2603:10b6:610:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 09:42:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 09:42:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: add support for multicast filter
Date:   Fri,  2 Dec 2022 10:42:14 +0100
Message-Id: <20221202094214.284673-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0014.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3669:EE_
X-MS-Office365-Filtering-Correlation-Id: 9164b6d3-c6de-426a-8fb6-08dad4498b90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPd62f6/DMcTBnydWTBJ8Fk/olDd1HFw7oKXF4MHLq8jfS/WsrBPIuMR68dMYhgIyRSkHblW7t3v9pZC8lW4lJH2n9PrTDjEXTI+iQPLyaEASD2dMhIOvzYIMeDAzClh+G+4zUpxg8A5/JP+hKXfEAMRlRLR9X2AEBFDGIYUc5137NZWzWmRBm2GLDt9dlm20JtMLJeKMOfqZx2K5/J8Ew6U/u6+KingDxQqnIVftnRKKau4q++x3piC7LcgNmEVyD0yW/m52mLdme/6dOjLrBAMZj7dZDeUCo3sP88XKawHDkaqHkArht3HP85rDvo8uh3SpEmD9AyzS7M6+mgWDfkCpY/6arSGAF3l3S9xoFtl6ZjGYIJX0q/0L7MW1OvnwHVCEh97vJoHdrYKxlfCZ5Em046k2pt8qyoMmngqWMrlAxDduFQGYnF2l4kZRLn3O/Wr/RvS9rq/0+PomYmveSudUgnpKVStHcFSrgXn+MsOAH017B85Wamrkya/+kZxRgeu1v3GKtVSloA3rnXIJaDpUpJVOpMsZLRZz2Tp9S4i8+mgGRLm4zyhjs2F4KE3k12t4qCx16CMOgS/r7+Ghf18h8LPdjUwxLnQwuKfcBLguASkINcOoNN9M/VggiMSOr1D9vq0ITGiqT3+HYi64w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39830400003)(346002)(366004)(376002)(136003)(396003)(451199015)(44832011)(8936002)(5660300002)(41300700001)(2906002)(66556008)(36756003)(66946007)(4326008)(8676002)(66476007)(110136005)(316002)(54906003)(38100700002)(6486002)(6506007)(478600001)(6666004)(52116002)(107886003)(6512007)(2616005)(186003)(86362001)(1076003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Ztqf5wLBb58WmtUTC+czux18dfs4APZIk/uaR3MboVsVX8mTuug+kKD01DB?=
 =?us-ascii?Q?Sq5y8OG7Hzqy8ML994QBU6n5r+Cc7sYAivjVsOoysCtqNQVi6Kl9whWcmDMg?=
 =?us-ascii?Q?OAn7aDKLOZpJmkB7GAuXgi/39uveTsN2tnv9jGAZt0TBBILNYDN5uyfu9nU2?=
 =?us-ascii?Q?8BBxzUkLlTQeGVcthoylj66umrwque+fRGJDyGfnKZRTW3gXrOLAP+GRix7V?=
 =?us-ascii?Q?I5BEITp4Xzzr/tnUIvaGeGQ24x73/qXgxFS0i3XYciYmLlP891qN1KxS1Lsk?=
 =?us-ascii?Q?9qOvRHxECVxIjepVEg8xEJA/BIGLLNfM7yrX16ZUdU7HRgIaZMM0ebi+y643?=
 =?us-ascii?Q?yWNa3wCIkvwEuXNc551GjwXkYEAjCt4ZM56OdtML+1TUlmYJycBDUpqddDfq?=
 =?us-ascii?Q?EKoDUPSH52CGet2giVTwZCA8e1C6L8dm6/QYPEnGwbXChIfTekkJir8j5kC8?=
 =?us-ascii?Q?GFSsYlQ3ga40wSYsQjKKw6zvs28SmEpQNa2Uni+y2JUXp+jCiI5o/H6TZOKv?=
 =?us-ascii?Q?ZfhMAO/wcbzubO7AlXmtjuFSlxYFnRp2oO3rDwUZg6WoFx7qnRhNS7RZ9ctg?=
 =?us-ascii?Q?Swo/FyK+p5RD0n0wmAsOKgzAhmWrAvfulPep0kqNSDKN09oF46gTUbb6LEEC?=
 =?us-ascii?Q?zgrPIND1m9hQxrSitxkTL1yQvqFaHjeB/CmqKzxLBQ/Cda8H5RP8R7VkqUUC?=
 =?us-ascii?Q?MUQLwTu3xQB7XVHq9R+IxTgIpE3BaJNtHM3sTmaLyXmGLsIVwowI4KvhswMC?=
 =?us-ascii?Q?uGEj7JD670Xoup3rgoU21b3pkcaZJ3zUMnd5TXMKmq4TCqT+f+x6mJuF+mqs?=
 =?us-ascii?Q?SSdZCeVIVJJPHisMbiluBITsSLOMpjaLnuQTqdTgH/y8C+tqrs/Z1iWVZJNA?=
 =?us-ascii?Q?nmsruLVCFYK/uxMOp+nzU3YEEc+v4mX44Mop0iD7bpzuADFWBfV3EqWh95FV?=
 =?us-ascii?Q?JJwle0w1Sb4uLCE45U2uUbqIGmp3OfwbumZdM/Fa+CIagpLWF95KqVXvYxr9?=
 =?us-ascii?Q?qmffBpcnpxNJ3EIxXQ2eoUj/jxO0et9imC+xzPRon/dA++Wu5ARcTZMk5EiF?=
 =?us-ascii?Q?P4s/ioTOYO1+Y+mdVlaIvWaKSBVuA7TjobymJxrrpQFkwWDGCJK88FTcDjVo?=
 =?us-ascii?Q?kHsgknaidoeLm7VcSoayOgByN8RauaY0VFgPqKUuFPBXbl/J6nO9OHwS6sIj?=
 =?us-ascii?Q?TWQl4za9cEEiB5TpEFVhixoBAHR+L2un1+Zr0Qu5X1zoizKEMXw7yuOMx71H?=
 =?us-ascii?Q?t0Uv2oOuBRWZFy6yEyROrr3OMLHjriYbaBFnvDlWb2f4PQOVQwMDVpzIJOdU?=
 =?us-ascii?Q?E+1MNlSbHQUYuWbsHDL1my3hSCZBQmWda2qHhWNTQ+laF/BIjl72JK5VrJNU?=
 =?us-ascii?Q?uLcE2gN2VxBWexYnYR2uti7QWWgUD8CJrehif4PVnc62+MwokNlC3KzwapIw?=
 =?us-ascii?Q?EYEB/wptNWb5T7ufsNf/pERQ9aSD40ogxzROR0AkrKmWnNa6I2oiolHkhulx?=
 =?us-ascii?Q?VEKirWMZrZlXXTiULa4Y4Apx0AJ9V7wUc9qI/N9Hwcas7zTDDzA3Zpq6ELoi?=
 =?us-ascii?Q?zKQ9Del4ddE/BntCaJNeNrimr0sbjD4B/f/bcEttaKsKOkR2YmcyogJYpNuM?=
 =?us-ascii?Q?omCY3JLRXmq+vtfj26MKga4W6MjvAYiVUg6kBZwqgZVepU020EgjQoB838N3?=
 =?us-ascii?Q?BiGNpw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9164b6d3-c6de-426a-8fb6-08dad4498b90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 09:42:36.6804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Guu0TToAJOztLEs66WtNPRRKT0WCpeGmj/lIOQa0JRx2erd9nQtpq9g/4Vwad5otFr7fkQAw+dMGQ26g/Swu1vFNnc4hO8uSd555hn9MMRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

Rewrite nfp_net_set_rx_mode() to implement interface to delivery
mc address and operations to firmware by using general mailbox
for filtering multicast packets.

The operations include add mc address and delete mc address.
And the limitation of mc addresses number is 1024 for each net
device.

User triggers adding mc address by using command below:
ip maddress add <mc address> dev <interface name>

User triggers deleting mc address by using command below:
ip maddress del <mc address> dev <interface name>

Signed-off-by: Diana Wang <na.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  5 ++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 63 +++++++++++++++++--
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 15 +++++
 3 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 6c83e47d8b3d..da33f09facb9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -88,6 +88,9 @@
 #define NFP_NET_FL_BATCH	16	/* Add freelist in this Batch size */
 #define NFP_NET_XDP_MAX_COMPLETE 2048	/* XDP bufs to reclaim in NAPI poll */
 
+/* MC definitions */
+#define NFP_NET_CFG_MAC_MC_MAX	1024	/* The maximum number of MC address per port*/
+
 /* Offload definitions */
 #define NFP_NET_N_VXLAN_PORTS	(NFP_NET_CFG_VXLAN_SZ / sizeof(__be16))
 
@@ -476,6 +479,7 @@ struct nfp_stat_pair {
  * @rx_dma_off:		Offset at which DMA packets (for XDP headroom)
  * @rx_offset:		Offset in the RX buffers where packet data starts
  * @ctrl:		Local copy of the control register/word.
+ * @ctrl_w1:		Local copy of the control register/word1.
  * @fl_bufsz:		Currently configured size of the freelist buffers
  * @xdp_prog:		Installed XDP program
  * @tx_rings:		Array of pre-allocated TX ring structures
@@ -508,6 +512,7 @@ struct nfp_net_dp {
 	u32 rx_dma_off;
 
 	u32 ctrl;
+	u32 ctrl_w1;
 	u32 fl_bufsz;
 
 	struct bpf_prog *xdp_prog;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 682a9198fb54..2314cf55e821 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1007,6 +1007,7 @@ static int nfp_net_set_config_and_enable(struct nfp_net *nn)
 		new_ctrl |= NFP_NET_CFG_CTRL_RINGCFG;
 
 	nn_writel(nn, NFP_NET_CFG_CTRL, new_ctrl);
+	nn_writel(nn, NFP_NET_CFG_CTRL_WORD1, nn->dp.ctrl_w1);
 	err = nfp_net_reconfig(nn, update);
 	if (err) {
 		nfp_net_clear_config_and_disable(nn);
@@ -1333,18 +1334,59 @@ int nfp_ctrl_open(struct nfp_net *nn)
 	return err;
 }
 
+static int nfp_net_mc_cfg(struct net_device *netdev, const unsigned char *addr, const u32 cmd)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	int ret;
+
+	ret = nfp_net_mbox_lock(nn, NFP_NET_CFG_MULTICAST_SZ);
+	if (ret)
+		return ret;
+
+	nn_writel(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MULTICAST_MAC_HI,
+		  get_unaligned_be32(addr));
+	nn_writew(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MULTICAST_MAC_LO,
+		  get_unaligned_be16(addr + 4));
+
+	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
+}
+
+static int nfp_net_mc_sync(struct net_device *netdev, const unsigned char *addr)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+
+	if (netdev_mc_count(netdev) > NFP_NET_CFG_MAC_MC_MAX) {
+		nn_err(nn, "Requested number of MC addresses (%d) exceeds maximum (%d).\n",
+		       netdev_mc_count(netdev), NFP_NET_CFG_MAC_MC_MAX);
+		return -EINVAL;
+	}
+
+	return nfp_net_mc_cfg(netdev, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD);
+}
+
+static int nfp_net_mc_unsync(struct net_device *netdev, const unsigned char *addr)
+{
+	return nfp_net_mc_cfg(netdev, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL);
+}
+
 static void nfp_net_set_rx_mode(struct net_device *netdev)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
-	u32 new_ctrl;
+	u32 new_ctrl, new_ctrl_w1;
 
 	new_ctrl = nn->dp.ctrl;
+	new_ctrl_w1 = nn->dp.ctrl_w1;
 
 	if (!netdev_mc_empty(netdev) || netdev->flags & IFF_ALLMULTI)
 		new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_L2MC;
 	else
 		new_ctrl &= ~NFP_NET_CFG_CTRL_L2MC;
 
+	if (netdev->flags & IFF_ALLMULTI)
+		new_ctrl_w1 &= ~NFP_NET_CFG_CTRL_MCAST_FILTER;
+	else
+		new_ctrl_w1 |= nn->cap_w1 & NFP_NET_CFG_CTRL_MCAST_FILTER;
+
 	if (netdev->flags & IFF_PROMISC) {
 		if (nn->cap & NFP_NET_CFG_CTRL_PROMISC)
 			new_ctrl |= NFP_NET_CFG_CTRL_PROMISC;
@@ -1354,13 +1396,21 @@ static void nfp_net_set_rx_mode(struct net_device *netdev)
 		new_ctrl &= ~NFP_NET_CFG_CTRL_PROMISC;
 	}
 
-	if (new_ctrl == nn->dp.ctrl)
+	if ((nn->cap_w1 & NFP_NET_CFG_CTRL_MCAST_FILTER) &&
+	    __dev_mc_sync(netdev, nfp_net_mc_sync, nfp_net_mc_unsync))
+		netdev_err(netdev, "Sync mc address failed\n");
+
+	if (new_ctrl == nn->dp.ctrl && new_ctrl_w1 == nn->dp.ctrl_w1)
 		return;
 
-	nn_writel(nn, NFP_NET_CFG_CTRL, new_ctrl);
+	if (new_ctrl != nn->dp.ctrl)
+		nn_writel(nn, NFP_NET_CFG_CTRL, new_ctrl);
+	if (new_ctrl_w1 != nn->dp.ctrl_w1)
+		nn_writel(nn, NFP_NET_CFG_CTRL_WORD1, new_ctrl_w1);
 	nfp_net_reconfig_post(nn, NFP_NET_CFG_UPDATE_GEN);
 
 	nn->dp.ctrl = new_ctrl;
+	nn->dp.ctrl_w1 = new_ctrl_w1;
 }
 
 static void nfp_net_rss_init_itbl(struct nfp_net *nn)
@@ -2092,7 +2142,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->fw_ver.extend, nn->fw_ver.class,
 		nn->fw_ver.major, nn->fw_ver.minor,
 		nn->max_mtu);
-	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		nn->cap,
 		nn->cap & NFP_NET_CFG_CTRL_PROMISC  ? "PROMISC "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_L2BC     ? "L2BCFILT " : "",
@@ -2120,6 +2170,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->cap & NFP_NET_CFG_CTRL_CSUM_COMPLETE ?
 						      "RXCSUM_COMPLETE " : "",
 		nn->cap & NFP_NET_CFG_CTRL_LIVE_ADDR ? "LIVE_ADDR " : "",
+		nn->cap_w1 & NFP_NET_CFG_CTRL_MCAST_FILTER ? "MULTICAST_FILTER " : "",
 		nfp_app_extra_cap(nn->app, nn));
 }
 
@@ -2548,6 +2599,9 @@ int nfp_net_init(struct nfp_net *nn)
 	if (nn->cap & NFP_NET_CFG_CTRL_TXRWB)
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXRWB;
 
+	if (nn->cap_w1 & NFP_NET_CFG_CTRL_MCAST_FILTER)
+		nn->dp.ctrl_w1 |= NFP_NET_CFG_CTRL_MCAST_FILTER;
+
 	/* Stash the re-configuration queue away.  First odd queue in TX Bar */
 	nn->qcp_cfg = nn->tx_bar + NFP_QCP_QUEUE_ADDR_SZ;
 
@@ -2555,6 +2609,7 @@ int nfp_net_init(struct nfp_net *nn)
 	nn_writel(nn, NFP_NET_CFG_CTRL, 0);
 	nn_writeq(nn, NFP_NET_CFG_TXRS_ENABLE, 0);
 	nn_writeq(nn, NFP_NET_CFG_RXRS_ENABLE, 0);
+	nn_writel(nn, NFP_NET_CFG_CTRL_WORD1, 0);
 	err = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_RING |
 				   NFP_NET_CFG_UPDATE_GEN);
 	if (err)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index cc11b3dc1252..51124309ae1f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -267,6 +267,7 @@
 #define NFP_NET_CFG_CTRL_WORD1		0x0098
 #define   NFP_NET_CFG_CTRL_PKT_TYPE	  (0x1 << 0) /* Pkttype offload */
 #define   NFP_NET_CFG_CTRL_IPSEC	  (0x1 << 1) /* IPsec offload */
+#define   NFP_NET_CFG_CTRL_MCAST_FILTER	  (0x1 << 2) /* Multicast Filter */
 
 #define NFP_NET_CFG_CAP_WORD1		0x00a4
 
@@ -413,6 +414,9 @@
 #define NFP_NET_CFG_MBOX_CMD_PCI_DSCP_PRIOMAP_SET	5
 #define NFP_NET_CFG_MBOX_CMD_TLV_CMSG			6
 
+#define NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD		8
+#define NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL		9
+
 /* VLAN filtering using general use mailbox
  * %NFP_NET_CFG_VLAN_FILTER:		Base address of VLAN filter mailbox
  * %NFP_NET_CFG_VLAN_FILTER_VID:	VLAN ID to filter
@@ -424,6 +428,17 @@
 #define  NFP_NET_CFG_VLAN_FILTER_PROTO	 (NFP_NET_CFG_VLAN_FILTER + 2)
 #define NFP_NET_CFG_VLAN_FILTER_SZ	 0x0004
 
+/* Multicast filtering using general use mailbox
+ * %NFP_NET_CFG_MULTICAST:		Base address of Multicast filter mailbox
+ * %NFP_NET_CFG_MULTICAST_MAC_HI:	High 32-bits of Multicast MAC address
+ * %NFP_NET_CFG_MULTICAST_MAC_LO:	Low 16-bits of Multicast MAC address
+ * %NFP_NET_CFG_MULTICAST_SZ:		Size of the Multicast filter mailbox in bytes
+ */
+#define NFP_NET_CFG_MULTICAST		NFP_NET_CFG_MBOX_SIMPLE_VAL
+#define NFP_NET_CFG_MULTICAST_MAC_HI	NFP_NET_CFG_MULTICAST
+#define NFP_NET_CFG_MULTICAST_MAC_LO	(NFP_NET_CFG_MULTICAST + 6)
+#define NFP_NET_CFG_MULTICAST_SZ	0x0006
+
 /* TLV capabilities
  * %NFP_NET_CFG_TLV_TYPE:	Offset of type within the TLV
  * %NFP_NET_CFG_TLV_TYPE_REQUIRED: Driver must be able to parse the TLV
-- 
2.30.2

