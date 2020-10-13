Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA29228CF7B
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387997AbgJMNto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:44 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:3086
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387949AbgJMNtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkoXSRUg94FHw9iYPTqZS8my7lRimcKwtfX8KQOEe0yPo9dKlEPQ+tjwuR2WtHMV+5gXETK6mVvE6NssKYllCbDKMVCte19CUbW9biwR5cL4whlahFzeekSGCp027r6JMtCGHLv1FpUzmiWyau3yGMqO8WuWOpyUAwpy5KdZnZ2IGkQKAZq7qEgg2H1HJw+tKjwrulq7klN1idtAnGT111w2EW8TPiYfYVvnr4SwsRWWVhAI2wztn08UMyZ8Adg9Z6YSs9aygz6tR3wtA0si7dySfTwsCyKevydzdyHSusRv0px2c9AxlyoWo+upD10dpgvBqk7inUeVgNPVGIhM5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/f5ohCo9EmTFpLnHA117jOZaNpcvgl9AOLRIyh+6wI=;
 b=gpLWdw+FYDyt3qR0fLPKxjFbmhz23TNsU5yYDvcFHzakfCJKfjry7r9GVAxbQlHTKomMahyRlUwAQSnFDKiKijCO4NRMe1PANnR94GsMoYUZe6M8sVM+i0m45ZPwU1b+oO7ixWIuhyBbr7ycmvM3mki3gXtUG7anx6+MpxWSm75vryMTb2Q0MmDdUmdd0j807X4HnFFCa38ODXcdTFHtyFIx8z5tHujb5j+VKZ1mtg39aZX04nLh/DouqQMNEDlBtOII+zMsxcHjyi9JC5xvoXd5FqA+IclMxS4taupRkYhtH5HyDt6LS5gOAEHvoDeEcTHJu2UW1IGgyRz7e5VDeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/f5ohCo9EmTFpLnHA117jOZaNpcvgl9AOLRIyh+6wI=;
 b=GkTNRVoYENUTE8m1RG4uMMCmV2LWNpqWjqXkLvaUd2ReAhYP3Xo2vkisnTuHTz63lu3OnSKC6kFCmL9v2Ro/z4cSgB8b9fixKXGNt20KDXDVYMOmhgwhAyEqPXUUvugEQcxeFC1Khzwl7TbwECZU9svSee3mkWJUKPDRw+ZHGOI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Tue, 13 Oct
 2020 13:49:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 10/10] net: mscc: ocelot: configure watermarks using devlink-sb
Date:   Tue, 13 Oct 2020 16:48:49 +0300
Message-Id: <20201013134849.395986-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d17b014f-ee20-4770-0afa-08d86f7ecb97
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28632FAEFF6D871B578A1A63E0040@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 22zk5zGPAgdnJrFwnnB7RTSvy54PcCNb5b95of4PtH7bYPldvdnZ1R1qClis/M9n/8wHEhKJt9nE7Ow4LNT/jjry7BW9DU21NuyFED1nGp/RBerHA43kjGfWtuQXMcMxMucmE4Z9HkiT4mfQdiQvRBeqTzbfKcFWejAhyeEQIkYQxAvM04qnZE7lxmSiMhlHmsBi0QrfVSMk/igPH//+mEkT+0ynDKrWCduvOtuaNOScxV0TxSz9YnhtKvITiueV9cSa4kDFZjd9/bXtYKwhpodN/+4aZuPROswGe9x60Mf4Az2SE442pD88Kppp1RIiz+cKZFxQDN1jl8irav6fTniKIypboDdmhke5lXU0vMEhTLNvR0LjnYMTP3l8lAI3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(5660300002)(30864003)(86362001)(186003)(4326008)(8676002)(16526019)(66556008)(36756003)(6506007)(8936002)(66946007)(66476007)(478600001)(1076003)(44832011)(956004)(69590400008)(2616005)(6916009)(6512007)(6486002)(2906002)(83380400001)(316002)(26005)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +0NhDgn5sHZPqyhegzFG6z2Y61pNT3Sukw2qR+stTuyFFNVeXHp6+LC/v0afWErjQetnLIgogywG3aHYiUv91tr1CVai8Ak+RxNQiVnsDkTUjq/jPTCrin2NNOjcBuU65ZtQCfPshn6+pd+at3ghn5J5GAvw/aqHYNcwnhrVeqpSIft8+gpWGfWBizr67bjWx8ZQsDtrvqAM+6/knDgZr8Z3oFTWqbzlOMl4XClVjfCiLY4+HVsTDpzagfSm4pAWPNkfLjh0IZxWh6/weaGs+jGqpZV/EZP4j0RouNztg6sts6mfZUgZMmzdtQKCVf9p0Hd4MvknITbK/IL7HCXG+XkgnrbLhrWQtBx4b7tbTRpftsMjyV3ht/3HHpqjVNRRgkQFxELMFA1ssmzvGn7ryGwg4adOJ0Md7IXTmJ5TOz5MDBnPk+aoEcic/QuG604D0+yqv6AiTa8jr2BAGRfwDeXmwEtk9nJvjoTp6gpBum6KjRsZHqoeBw1wCZfo0LFpMJjNzfmSNti/XPhWNy0lbUGpq8QP8rO+F6qKICopjIW2n3/LJzf/5f/YEyLZAi8J37dholwGxRvdVQ+vGk3CXcaljJgcdnoeb2ChSunwyGcCbmkFN/GCzpEVI4/0FvMy0wGw12WosJcGmhpMGqGZWg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17b014f-ee20-4770-0afa-08d86f7ecb97
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:24.9698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VdtmEpTVSnbXl5ih9ZwWslUFgpuFeLeyqv+Z9GYDiBAoDJahVKa1ppj9wE4BTSgwGG9BposVmh010hT2mCpMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using devlink-sb, we can configure 12/16 (the important 75%) of the
switch's controlling watermarks for congestion drops, and we can monitor
50% of the watermark occupancies (we can monitor the reservation
watermarks, but not the sharing watermarks, which are exposed as pool
sizes).

The following definitions can be made:

SB_BUF=0 # The devlink-sb for frame buffers
SB_REF=1 # The devlink-sb for frame references
POOL_ING=0 # The pool for ingress traffic. Both devlink-sb instances
           # have one of these.
POOL_EGR=1 # The pool for egress traffic. Both devlink-sb instances
           # have one of these.

Editing the hardware watermarks is done in the following way:
BUF_xxxx_I is accessed when sb=$SB_BUF and pool=$POOL_ING
REF_xxxx_I is accessed when sb=$SB_REF and pool=$POOL_ING
BUF_xxxx_E is accessed when sb=$SB_BUF and pool=$POOL_EGR
REF_xxxx_E is accessed when sb=$SB_REF and pool=$POOL_EGR

Configuring the sharing watermarks for COL_SHR(dp=0) is done implicitly
by modifying the corresponding pool size. By default, the pool size has
maximum size, so this can be skipped.

devlink sb pool set pci/0000:00:00.5 sb $SB_BUF pool $POOL_ING \
	size 103872 thtype static

Since by default there is no buffer reservation, the above command has
maxed out BUF_COL_SHR_I(dp=0).

Configuring the per-port reservation watermark (P_RSRV) is done in the
following way:

devlink sb port pool set pci/0000:00:00.5/0 sb $SB_BUF \
	pool $POOL_ING th 1000

The above command sets BUF_P_RSRV_I(port 0) to 1000 bytes. After this
command, the sharing watermarks are internally reconfigured with 1000
bytes less, i.e. from 103872 bytes to 102872 bytes.

Configuring the per-port-tc reservation watermarks (Q_RSRV) is done in
the following way:

for tc in {0..7}; do
	devlink sb tc bind set pci/0000:00:00.5/0 sb 0 tc $tc \
		type ingress pool $POOL_ING \
		th 3000
done

The above command sets BUF_Q_RSRV_I(port 0, tc 0..7) to 3000 bytes.
The sharing watermarks are again reconfigured with 24000 bytes less.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c             | 118 ++++++
 drivers/net/ethernet/mscc/ocelot_devlink.c | 449 ++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_net.c     | 143 +++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  27 +-
 include/soc/mscc/ocelot.h                  |  47 +++
 5 files changed, 778 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ed2e00af8baa..f388c9cae5be 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -437,6 +437,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->ops		= felix->info->ops;
 	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->devlink		= felix->ds->devlink;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
 				 GFP_KERNEL);
@@ -599,6 +600,10 @@ static int felix_setup(struct dsa_switch *ds)
 		felix_port_qos_map_init(ocelot, port);
 	}
 
+	err = ocelot_devlink_sb_register(ocelot);
+	if (err)
+		return err;
+
 	/* Include the CPU port module in the forwarding mask for unknown
 	 * unicast - the hardware default value for ANA_FLOODING_FLD_UNICAST
 	 * excludes BIT(ocelot->num_phys_ports), and so does ocelot_init, since
@@ -626,6 +631,7 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
+	ocelot_devlink_sb_unregister(ocelot);
 	if (ocelot->ptp)
 		ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
@@ -766,6 +772,108 @@ static int felix_port_setup_tc(struct dsa_switch *ds, int port,
 		return -EOPNOTSUPP;
 }
 
+static int felix_sb_pool_get(struct dsa_switch *ds, unsigned int sb_index,
+			     u16 pool_index,
+			     struct devlink_sb_pool_info *pool_info)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_pool_get(ocelot, sb_index, pool_index, pool_info);
+}
+
+static int felix_sb_pool_set(struct dsa_switch *ds, unsigned int sb_index,
+			     u16 pool_index, u32 size,
+			     enum devlink_sb_threshold_type threshold_type,
+			     struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_pool_set(ocelot, sb_index, pool_index, size,
+				  threshold_type, extack);
+}
+
+static int felix_sb_port_pool_get(struct dsa_switch *ds, int port,
+				  unsigned int sb_index, u16 pool_index,
+				  u32 *p_threshold)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_port_pool_get(ocelot, port, sb_index, pool_index,
+				       p_threshold);
+}
+
+static int felix_sb_port_pool_set(struct dsa_switch *ds, int port,
+				  unsigned int sb_index, u16 pool_index,
+				  u32 threshold, struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_port_pool_set(ocelot, port, sb_index, pool_index,
+				       threshold, extack);
+}
+
+static int felix_sb_tc_pool_bind_get(struct dsa_switch *ds, int port,
+				     unsigned int sb_index, u16 tc_index,
+				     enum devlink_sb_pool_type pool_type,
+				     u16 *p_pool_index, u32 *p_threshold)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_tc_pool_bind_get(ocelot, port, sb_index, tc_index,
+					  pool_type, p_pool_index,
+					  p_threshold);
+}
+
+static int felix_sb_tc_pool_bind_set(struct dsa_switch *ds, int port,
+				     unsigned int sb_index, u16 tc_index,
+				     enum devlink_sb_pool_type pool_type,
+				     u16 pool_index, u32 threshold,
+				     struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_tc_pool_bind_set(ocelot, port, sb_index, tc_index,
+					  pool_type, pool_index, threshold,
+					  extack);
+}
+
+static int felix_sb_occ_snapshot(struct dsa_switch *ds,
+				 unsigned int sb_index)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_occ_snapshot(ocelot, sb_index);
+}
+
+static int felix_sb_occ_max_clear(struct dsa_switch *ds,
+				  unsigned int sb_index)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_occ_max_clear(ocelot, sb_index);
+}
+
+static int felix_sb_occ_port_pool_get(struct dsa_switch *ds, int port,
+				      unsigned int sb_index, u16 pool_index,
+				      u32 *p_cur, u32 *p_max)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_occ_port_pool_get(ocelot, port, sb_index, pool_index,
+					   p_cur, p_max);
+}
+
+static int felix_sb_occ_tc_port_bind_get(struct dsa_switch *ds, int port,
+					 unsigned int sb_index, u16 tc_index,
+					 enum devlink_sb_pool_type pool_type,
+					 u32 *p_cur, u32 *p_max)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_sb_occ_tc_port_bind_get(ocelot, port, sb_index, tc_index,
+					      pool_type, p_cur, p_max);
+}
+
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
 	.setup				= felix_setup,
@@ -806,6 +914,16 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_del			= felix_cls_flower_del,
 	.cls_flower_stats		= felix_cls_flower_stats,
 	.port_setup_tc			= felix_port_setup_tc,
+	.devlink_sb_pool_get		= felix_sb_pool_get,
+	.devlink_sb_pool_set		= felix_sb_pool_set,
+	.devlink_sb_port_pool_get	= felix_sb_port_pool_get,
+	.devlink_sb_port_pool_set	= felix_sb_port_pool_set,
+	.devlink_sb_tc_pool_bind_get	= felix_sb_tc_pool_bind_get,
+	.devlink_sb_tc_pool_bind_set	= felix_sb_tc_pool_bind_set,
+	.devlink_sb_occ_snapshot	= felix_sb_occ_snapshot,
+	.devlink_sb_occ_max_clear	= felix_sb_occ_max_clear,
+	.devlink_sb_occ_port_pool_get	= felix_sb_occ_port_pool_get,
+	.devlink_sb_occ_tc_port_bind_get= felix_sb_occ_tc_port_bind_get,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index c96309cde82d..ca83aac943b7 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -232,6 +232,14 @@ static void ocelot_wm_write(struct ocelot *ocelot, int index, u32 val)
 	ocelot_write_gix(ocelot, wm, QSYS_RES_CFG, index);
 }
 
+static void ocelot_wm_status(struct ocelot *ocelot, int index, u32 *inuse,
+			     u32 *maxuse)
+{
+	int res_stat = ocelot_read_gix(ocelot, QSYS_RES_STAT, index);
+
+	return ocelot->ops->wm_stat(res_stat, inuse, maxuse);
+}
+
 /* The hardware comes out of reset with strange defaults: the sum of all
  * reservations for frame memory is larger than the total buffer size.
  * One has to wonder how can the reservation watermarks still guarantee
@@ -348,10 +356,14 @@ static void ocelot_setup_sharing_watermarks(struct ocelot *ocelot)
 	ocelot_get_buf_rsrv(ocelot, &buf_rsrv_i, &buf_rsrv_e);
 	ocelot_get_ref_rsrv(ocelot, &ref_rsrv_i, &ref_rsrv_e);
 
-	buf_shr_i = ocelot->packet_buffer_size - buf_rsrv_i;
-	buf_shr_e = ocelot->packet_buffer_size - buf_rsrv_e;
-	ref_shr_i = ocelot->num_frame_refs - ref_rsrv_i;
-	ref_shr_e = ocelot->num_frame_refs - ref_rsrv_e;
+	buf_shr_i = ocelot->pool_size[OCELOT_SB_BUF][OCELOT_SB_POOL_ING] -
+		    buf_rsrv_i;
+	buf_shr_e = ocelot->pool_size[OCELOT_SB_BUF][OCELOT_SB_POOL_EGR] -
+		    buf_rsrv_e;
+	ref_shr_i = ocelot->pool_size[OCELOT_SB_REF][OCELOT_SB_POOL_ING] -
+		    ref_rsrv_i;
+	ref_shr_e = ocelot->pool_size[OCELOT_SB_REF][OCELOT_SB_POOL_EGR] -
+		    ref_rsrv_e;
 
 	buf_shr_i /= OCELOT_BUFFER_CELL_SZ;
 	buf_shr_e /= OCELOT_BUFFER_CELL_SZ;
@@ -366,6 +378,40 @@ static void ocelot_setup_sharing_watermarks(struct ocelot *ocelot)
 	ocelot_wm_write(ocelot, REF_COL_SHR_I(1), 0);
 }
 
+/* Ensure that all reservations can be enforced */
+static int ocelot_watermark_validate(struct ocelot *ocelot,
+				     struct netlink_ext_ack *extack)
+{
+	u32 buf_rsrv_i, buf_rsrv_e;
+	u32 ref_rsrv_i, ref_rsrv_e;
+
+	ocelot_get_buf_rsrv(ocelot, &buf_rsrv_i, &buf_rsrv_e);
+	ocelot_get_ref_rsrv(ocelot, &ref_rsrv_i, &ref_rsrv_e);
+
+	if (buf_rsrv_i > ocelot->pool_size[OCELOT_SB_BUF][OCELOT_SB_POOL_ING]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Ingress frame reservations exceed pool size");
+		return -ERANGE;
+	}
+	if (buf_rsrv_e > ocelot->pool_size[OCELOT_SB_BUF][OCELOT_SB_POOL_EGR]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Egress frame reservations exceed pool size");
+		return -ERANGE;
+	}
+	if (ref_rsrv_i > ocelot->pool_size[OCELOT_SB_REF][OCELOT_SB_POOL_ING]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Ingress reference reservations exceed pool size");
+		return -ERANGE;
+	}
+	if (ref_rsrv_e > ocelot->pool_size[OCELOT_SB_REF][OCELOT_SB_POOL_EGR]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Egress reference reservations exceed pool size");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
 /* The hardware works like this:
  *
  *                         Frame forwarding decision taken
@@ -440,3 +486,398 @@ void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_disable_tc_sharing_watermarks(ocelot);
 	ocelot_setup_sharing_watermarks(ocelot);
 }
+
+/* Pool size and type are fixed up at runtime. Keeping this structure to
+ * look up the cell size multipliers.
+ */
+static const struct devlink_sb_pool_info ocelot_sb_pool[] = {
+	[OCELOT_SB_BUF] = {
+		.cell_size = OCELOT_BUFFER_CELL_SZ,
+		.threshold_type = DEVLINK_SB_THRESHOLD_TYPE_STATIC,
+	},
+	[OCELOT_SB_REF] = {
+		.cell_size = 1,
+		.threshold_type = DEVLINK_SB_THRESHOLD_TYPE_STATIC,
+	},
+};
+
+/* Returns the pool size configured through ocelot_sb_pool_set */
+int ocelot_sb_pool_get(struct ocelot *ocelot, unsigned int sb_index,
+		       u16 pool_index,
+		       struct devlink_sb_pool_info *pool_info)
+{
+	if (sb_index >= OCELOT_SB_NUM)
+		return -ENODEV;
+	if (pool_index >= OCELOT_SB_POOL_NUM)
+		return -ENODEV;
+
+	*pool_info = ocelot_sb_pool[sb_index];
+	pool_info->size = ocelot->pool_size[sb_index][pool_index];
+	if (pool_index)
+		pool_info->pool_type = DEVLINK_SB_POOL_TYPE_INGRESS;
+	else
+		pool_info->pool_type = DEVLINK_SB_POOL_TYPE_EGRESS;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_pool_get);
+
+/* The pool size received here configures the total amount of resources used on
+ * ingress (or on egress, depending upon the pool index). The pool size, minus
+ * the values for the port and port-tc reservations, is written into the
+ * COL_SHR(dp=0) sharing watermark.
+ */
+int ocelot_sb_pool_set(struct ocelot *ocelot, unsigned int sb_index,
+		       u16 pool_index, u32 size,
+		       enum devlink_sb_threshold_type threshold_type,
+		       struct netlink_ext_ack *extack)
+{
+	u32 old_pool_size;
+	int err;
+
+	if (sb_index >= OCELOT_SB_NUM) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid sb, use 0 for buffers and 1 for frame references");
+		return -ENODEV;
+	}
+	if (pool_index >= OCELOT_SB_POOL_NUM) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid pool, use 0 for ingress and 1 for egress");
+		return -ENODEV;
+	}
+	if (threshold_type != DEVLINK_SB_THRESHOLD_TYPE_STATIC) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only static threshold supported");
+		return -EOPNOTSUPP;
+	}
+
+	old_pool_size = ocelot->pool_size[sb_index][pool_index];
+	ocelot->pool_size[sb_index][pool_index] = size;
+
+	err = ocelot_watermark_validate(ocelot, extack);
+	if (err) {
+		ocelot->pool_size[sb_index][pool_index] = old_pool_size;
+		return err;
+	}
+
+	ocelot_setup_sharing_watermarks(ocelot);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_pool_set);
+
+/* This retrieves the configuration made with ocelot_sb_port_pool_set */
+int ocelot_sb_port_pool_get(struct ocelot *ocelot, int port,
+			    unsigned int sb_index, u16 pool_index,
+			    u32 *p_threshold)
+{
+	int wm_index;
+
+	switch (sb_index) {
+	case OCELOT_SB_BUF:
+		if (pool_index == OCELOT_SB_POOL_ING)
+			wm_index = BUF_P_RSRV_I(port);
+		else
+			wm_index = BUF_P_RSRV_E(port);
+		break;
+	case OCELOT_SB_REF:
+		if (pool_index == OCELOT_SB_POOL_ING)
+			wm_index = REF_P_RSRV_I(port);
+		else
+			wm_index = REF_P_RSRV_E(port);
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	*p_threshold = ocelot_wm_read(ocelot, wm_index);
+	*p_threshold *= ocelot_sb_pool[sb_index].cell_size;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_port_pool_get);
+
+/* This configures the P_RSRV per-port reserved resource watermark */
+int ocelot_sb_port_pool_set(struct ocelot *ocelot, int port,
+			    unsigned int sb_index, u16 pool_index,
+			    u32 threshold, struct netlink_ext_ack *extack)
+{
+	int wm_index, err;
+	u32 old_thr;
+
+	switch (sb_index) {
+	case OCELOT_SB_BUF:
+		if (pool_index == OCELOT_SB_POOL_ING)
+			wm_index = BUF_P_RSRV_I(port);
+		else
+			wm_index = BUF_P_RSRV_E(port);
+		break;
+	case OCELOT_SB_REF:
+		if (pool_index == OCELOT_SB_POOL_ING)
+			wm_index = REF_P_RSRV_I(port);
+		else
+			wm_index = REF_P_RSRV_E(port);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Invalid shared buffer");
+		return -ENODEV;
+	}
+
+	threshold /= ocelot_sb_pool[sb_index].cell_size;
+
+	old_thr = ocelot_wm_read(ocelot, wm_index);
+	ocelot_wm_write(ocelot, wm_index, threshold);
+
+	err = ocelot_watermark_validate(ocelot, extack);
+	if (err) {
+		ocelot_wm_write(ocelot, wm_index, old_thr);
+		return err;
+	}
+
+	ocelot_setup_sharing_watermarks(ocelot);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_port_pool_set);
+
+/* This retrieves the configuration done by ocelot_sb_tc_pool_bind_set */
+int ocelot_sb_tc_pool_bind_get(struct ocelot *ocelot, int port,
+			       unsigned int sb_index, u16 tc_index,
+			       enum devlink_sb_pool_type pool_type,
+			       u16 *p_pool_index, u32 *p_threshold)
+{
+	int wm_index;
+
+	switch (sb_index) {
+	case OCELOT_SB_BUF:
+		if (pool_type == DEVLINK_SB_POOL_TYPE_INGRESS)
+			wm_index = BUF_Q_RSRV_I(port, tc_index);
+		else
+			wm_index = BUF_Q_RSRV_E(port, tc_index);
+		break;
+	case OCELOT_SB_REF:
+		if (pool_type == DEVLINK_SB_POOL_TYPE_INGRESS)
+			wm_index = REF_Q_RSRV_I(port, tc_index);
+		else
+			wm_index = REF_Q_RSRV_E(port, tc_index);
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	*p_threshold = ocelot_wm_read(ocelot, wm_index);
+	*p_threshold *= ocelot_sb_pool[sb_index].cell_size;
+
+	if (pool_type == DEVLINK_SB_POOL_TYPE_INGRESS)
+		*p_pool_index = 0;
+	else
+		*p_pool_index = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_tc_pool_bind_get);
+
+/* This configures the Q_RSRV per-port-tc reserved resource watermark */
+int ocelot_sb_tc_pool_bind_set(struct ocelot *ocelot, int port,
+			       unsigned int sb_index, u16 tc_index,
+			       enum devlink_sb_pool_type pool_type,
+			       u16 pool_index, u32 threshold,
+			       struct netlink_ext_ack *extack)
+{
+	int wm_index, err;
+	u32 old_thr;
+
+	/* Paranoid check? */
+	if (pool_index == OCELOT_SB_POOL_ING &&
+	    pool_type != DEVLINK_SB_POOL_TYPE_INGRESS)
+		return -EINVAL;
+	if (pool_index == OCELOT_SB_POOL_EGR &&
+	    pool_type != DEVLINK_SB_POOL_TYPE_EGRESS)
+		return -EINVAL;
+
+	switch (sb_index) {
+	case OCELOT_SB_BUF:
+		if (pool_type == DEVLINK_SB_POOL_TYPE_INGRESS)
+			wm_index = BUF_Q_RSRV_I(port, tc_index);
+		else
+			wm_index = BUF_Q_RSRV_E(port, tc_index);
+		break;
+	case OCELOT_SB_REF:
+		if (pool_type == DEVLINK_SB_POOL_TYPE_INGRESS)
+			wm_index = REF_Q_RSRV_I(port, tc_index);
+		else
+			wm_index = REF_Q_RSRV_E(port, tc_index);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Invalid shared buffer");
+		return -ENODEV;
+	}
+
+	threshold /= ocelot_sb_pool[sb_index].cell_size;
+
+	old_thr = ocelot_wm_read(ocelot, wm_index);
+	ocelot_wm_write(ocelot, wm_index, threshold);
+	err = ocelot_watermark_validate(ocelot, extack);
+	if (err) {
+		ocelot_wm_write(ocelot, wm_index, old_thr);
+		return err;
+	}
+
+	ocelot_setup_sharing_watermarks(ocelot);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_tc_pool_bind_set);
+
+/* The hardware does not support atomic snapshots, we'll read out the
+ * occupancy registers individually and have this as just a stub.
+ */
+int ocelot_sb_occ_snapshot(struct ocelot *ocelot, unsigned int sb_index)
+{
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_occ_snapshot);
+
+/* The watermark occupancy registers are cleared upon read,
+ * so let's read them.
+ */
+int ocelot_sb_occ_max_clear(struct ocelot *ocelot, unsigned int sb_index)
+{
+	u32 inuse, maxuse;
+	int port, prio;
+
+	switch (sb_index) {
+	case OCELOT_SB_BUF:
+		for (port = 0; port <= ocelot->num_phys_ports; port++) {
+			for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+				ocelot_wm_status(ocelot, BUF_Q_RSRV_I(port, prio),
+						 &inuse, &maxuse);
+				ocelot_wm_status(ocelot, BUF_Q_RSRV_E(port, prio),
+						 &inuse, &maxuse);
+			}
+			ocelot_wm_status(ocelot, BUF_P_RSRV_I(port),
+					 &inuse, &maxuse);
+			ocelot_wm_status(ocelot, BUF_P_RSRV_E(port),
+					 &inuse, &maxuse);
+		}
+		break;
+	case OCELOT_SB_REF:
+		for (port = 0; port <= ocelot->num_phys_ports; port++) {
+			for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+				ocelot_wm_status(ocelot, REF_Q_RSRV_I(port, prio),
+						 &inuse, &maxuse);
+				ocelot_wm_status(ocelot, REF_Q_RSRV_E(port, prio),
+						 &inuse, &maxuse);
+			}
+			ocelot_wm_status(ocelot, REF_P_RSRV_I(port),
+					 &inuse, &maxuse);
+			ocelot_wm_status(ocelot, REF_P_RSRV_E(port),
+					 &inuse, &maxuse);
+		}
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_occ_max_clear);
+
+/* This retrieves the watermark occupancy for per-port P_RSRV watermarks */
+int ocelot_sb_occ_port_pool_get(struct ocelot *ocelot, int port,
+				unsigned int sb_index, u16 pool_index,
+				u32 *p_cur, u32 *p_max)
+{
+	int wm_index;
+
+	switch (sb_index) {
+	case OCELOT_SB_BUF:
+		if (pool_index == OCELOT_SB_POOL_ING)
+			wm_index = BUF_P_RSRV_I(port);
+		else
+			wm_index = BUF_P_RSRV_E(port);
+		break;
+	case OCELOT_SB_REF:
+		if (pool_index == OCELOT_SB_POOL_ING)
+			wm_index = REF_P_RSRV_I(port);
+		else
+			wm_index = REF_P_RSRV_E(port);
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	ocelot_wm_status(ocelot, wm_index, p_cur, p_max);
+	*p_cur *= ocelot_sb_pool[sb_index].cell_size;
+	*p_max *= ocelot_sb_pool[sb_index].cell_size;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_occ_port_pool_get);
+
+/* This retrieves the watermark occupancy for per-port-tc Q_RSRV watermarks */
+int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
+				   unsigned int sb_index, u16 tc_index,
+				   enum devlink_sb_pool_type pool_type,
+				   u32 *p_cur, u32 *p_max)
+{
+	int wm_index;
+
+	switch (sb_index) {
+	case OCELOT_SB_BUF:
+		if (pool_type == DEVLINK_SB_POOL_TYPE_INGRESS)
+			wm_index = BUF_Q_RSRV_I(port, tc_index);
+		else
+			wm_index = BUF_Q_RSRV_E(port, tc_index);
+		break;
+	case OCELOT_SB_REF:
+		if (pool_type == DEVLINK_SB_POOL_TYPE_INGRESS)
+			wm_index = REF_Q_RSRV_I(port, tc_index);
+		else
+			wm_index = REF_Q_RSRV_E(port, tc_index);
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	ocelot_wm_status(ocelot, wm_index, p_cur, p_max);
+	*p_cur *= ocelot_sb_pool[sb_index].cell_size;
+	*p_max *= ocelot_sb_pool[sb_index].cell_size;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_sb_occ_tc_port_bind_get);
+
+int ocelot_devlink_sb_register(struct ocelot *ocelot)
+{
+	int err;
+
+	err = devlink_sb_register(ocelot->devlink, OCELOT_SB_BUF,
+				  ocelot->packet_buffer_size, 1, 1,
+				  OCELOT_NUM_TC, OCELOT_NUM_TC);
+	if (err)
+		return err;
+
+	err = devlink_sb_register(ocelot->devlink, OCELOT_SB_REF,
+				  ocelot->num_frame_refs, 1, 1,
+				  OCELOT_NUM_TC, OCELOT_NUM_TC);
+	if (err) {
+		devlink_sb_unregister(ocelot->devlink, OCELOT_SB_BUF);
+		return err;
+	}
+
+	ocelot->pool_size[OCELOT_SB_BUF][OCELOT_SB_POOL_ING] = ocelot->packet_buffer_size;
+	ocelot->pool_size[OCELOT_SB_BUF][OCELOT_SB_POOL_EGR] = ocelot->packet_buffer_size;
+	ocelot->pool_size[OCELOT_SB_REF][OCELOT_SB_POOL_ING] = ocelot->num_frame_refs;
+	ocelot->pool_size[OCELOT_SB_REF][OCELOT_SB_POOL_EGR] = ocelot->num_frame_refs;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_devlink_sb_register);
+
+void ocelot_devlink_sb_unregister(struct ocelot *ocelot)
+{
+	devlink_sb_unregister(ocelot->devlink, OCELOT_SB_BUF);
+	devlink_sb_unregister(ocelot->devlink, OCELOT_SB_REF);
+}
+EXPORT_SYMBOL(ocelot_devlink_sb_unregister);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index a11e5e7a0228..f5a2e59e6205 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1,7 +1,11 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Microsemi Ocelot Switch driver
+ *
+ * This contains glue logic between the switchdev driver operations and the
+ * mscc_ocelot_switch_lib.
  *
  * Copyright (c) 2017, 2019 Microsemi Corporation
+ * Copyright 2020 NXP Semiconductors
  */
 
 #include <linux/if_bridge.h>
@@ -12,7 +16,146 @@ struct ocelot_devlink_private {
 	struct ocelot *ocelot;
 };
 
+static struct ocelot_port_private *
+devlink_to_ocelot_port_priv(struct devlink_port *dlp)
+{
+	return container_of(dlp, struct ocelot_port_private, devlink_port);
+}
+
+static int ocelot_devlink_sb_pool_get(struct devlink *dl,
+				      unsigned int sb_index, u16 pool_index,
+				      struct devlink_sb_pool_info *pool_info)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dl);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_pool_get(ocelot, sb_index, pool_index, pool_info);
+}
+
+static int ocelot_devlink_sb_pool_set(struct devlink *dl, unsigned int sb_index,
+				      u16 pool_index, u32 size,
+				      enum devlink_sb_threshold_type threshold_type,
+				      struct netlink_ext_ack *extack)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dl);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_pool_set(ocelot, sb_index, pool_index, size,
+				  threshold_type, extack);
+}
+
+static int ocelot_devlink_sb_port_pool_get(struct devlink_port *dlp,
+					   unsigned int sb_index, u16 pool_index,
+					   u32 *p_threshold)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dlp->devlink);
+	struct ocelot_port_private *priv = devlink_to_ocelot_port_priv(dlp);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_port_pool_get(ocelot, priv->chip_port, sb_index,
+				       pool_index, p_threshold);
+}
+
+static int ocelot_devlink_sb_port_pool_set(struct devlink_port *dlp,
+					   unsigned int sb_index, u16 pool_index,
+					   u32 threshold,
+					   struct netlink_ext_ack *extack)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dlp->devlink);
+	struct ocelot_port_private *priv = devlink_to_ocelot_port_priv(dlp);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_port_pool_set(ocelot, priv->chip_port, sb_index,
+				       pool_index, threshold, extack);
+}
+
+static int
+ocelot_devlink_sb_tc_pool_bind_get(struct devlink_port *dlp,
+				   unsigned int sb_index, u16 tc_index,
+				   enum devlink_sb_pool_type pool_type,
+				   u16 *p_pool_index, u32 *p_threshold)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dlp->devlink);
+	struct ocelot_port_private *priv = devlink_to_ocelot_port_priv(dlp);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_tc_pool_bind_get(ocelot, priv->chip_port, sb_index,
+					  tc_index, pool_type, p_pool_index,
+					  p_threshold);
+}
+
+static int
+ocelot_devlink_sb_tc_pool_bind_set(struct devlink_port *dlp,
+				   unsigned int sb_index, u16 tc_index,
+				   enum devlink_sb_pool_type pool_type,
+				   u16 pool_index, u32 threshold,
+				   struct netlink_ext_ack *extack)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dlp->devlink);
+	struct ocelot_port_private *priv = devlink_to_ocelot_port_priv(dlp);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_tc_pool_bind_set(ocelot, priv->chip_port, sb_index,
+					  tc_index, pool_type, pool_index,
+					  threshold, extack);
+}
+
+static int ocelot_devlink_sb_occ_snapshot(struct devlink *dl,
+					  unsigned int sb_index)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dl);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_occ_snapshot(ocelot, sb_index);
+}
+
+static int ocelot_devlink_sb_occ_max_clear(struct devlink *dl,
+					   unsigned int sb_index)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dl);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_occ_max_clear(ocelot, sb_index);
+}
+
+static int ocelot_devlink_sb_occ_port_pool_get(struct devlink_port *dlp,
+					       unsigned int sb_index,
+					       u16 pool_index, u32 *p_cur,
+					       u32 *p_max)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dlp->devlink);
+	struct ocelot_port_private *priv = devlink_to_ocelot_port_priv(dlp);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_occ_port_pool_get(ocelot, priv->chip_port, sb_index,
+						     pool_index, p_cur, p_max);
+}
+
+static int
+ocelot_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
+				       unsigned int sb_index, u16 tc_index,
+				       enum devlink_sb_pool_type pool_type,
+				       u32 *p_cur, u32 *p_max)
+{
+	struct ocelot_devlink_private *dl_priv = devlink_priv(dlp->devlink);
+	struct ocelot_port_private *priv = devlink_to_ocelot_port_priv(dlp);
+	struct ocelot *ocelot = dl_priv->ocelot;
+
+	return ocelot_sb_occ_tc_port_bind_get(ocelot, priv->chip_port, sb_index,
+					      tc_index, pool_type, p_cur, p_max);
+}
+
 static const struct devlink_ops ocelot_devlink_ops = {
+	.sb_pool_get			= ocelot_devlink_sb_pool_get,
+	.sb_pool_set			= ocelot_devlink_sb_pool_set,
+	.sb_port_pool_get		= ocelot_devlink_sb_port_pool_get,
+	.sb_port_pool_set		= ocelot_devlink_sb_port_pool_set,
+	.sb_tc_pool_bind_get		= ocelot_devlink_sb_tc_pool_bind_get,
+	.sb_tc_pool_bind_set		= ocelot_devlink_sb_tc_pool_bind_set,
+	.sb_occ_snapshot		= ocelot_devlink_sb_occ_snapshot,
+	.sb_occ_max_clear		= ocelot_devlink_sb_occ_max_clear,
+	.sb_occ_port_pool_get		= ocelot_devlink_sb_occ_port_pool_get,
+	.sb_occ_tc_port_bind_get	= ocelot_devlink_sb_occ_tc_port_bind_get,
 };
 
 static int ocelot_port_devlink_init(struct ocelot *ocelot, int port)
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6512ddeafd50..e9d7cc68f570 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1173,6 +1173,29 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 	return 0;
 }
 
+static int mscc_ocelot_devlink_setup(struct ocelot *ocelot)
+{
+	int err;
+
+	err = ocelot_devlink_init(ocelot);
+	if (err)
+		return err;
+
+	err = ocelot_devlink_sb_register(ocelot);
+	if (err) {
+		ocelot_devlink_teardown(ocelot);
+		return err;
+	}
+
+	return 0;
+}
+
+static void mscc_ocelot_devlink_cleanup(struct ocelot *ocelot)
+{
+	ocelot_devlink_sb_unregister(ocelot);
+	ocelot_devlink_teardown(ocelot);
+}
+
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -1292,7 +1315,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		}
 	}
 
-	err = ocelot_devlink_init(ocelot);
+	err = mscc_ocelot_devlink_setup(ocelot);
 	if (err) {
 		mscc_ocelot_release_ports(ocelot);
 		goto out_put_ports;
@@ -1313,7 +1336,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
-	ocelot_devlink_teardown(ocelot);
+	mscc_ocelot_devlink_cleanup(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	mscc_ocelot_release_ports(ocelot);
 	ocelot_deinit(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 19ce7ea11163..deefbd88f0f7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -574,6 +574,18 @@ struct ocelot_vcap_block {
 	int pol_lpr;
 };
 
+enum ocelot_sb {
+	OCELOT_SB_BUF,
+	OCELOT_SB_REF,
+	OCELOT_SB_NUM,
+};
+
+enum ocelot_sb_pool {
+	OCELOT_SB_POOL_ING,
+	OCELOT_SB_POOL_EGR,
+	OCELOT_SB_POOL_NUM,
+};
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -608,6 +620,7 @@ struct ocelot {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 
+	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
 	int				packet_buffer_size;
 	int				num_frame_refs;
 	int				num_mact_rows;
@@ -772,4 +785,38 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
 
+int ocelot_devlink_sb_register(struct ocelot *ocelot);
+void ocelot_devlink_sb_unregister(struct ocelot *ocelot);
+int ocelot_sb_pool_get(struct ocelot *ocelot, unsigned int sb_index,
+		       u16 pool_index,
+		       struct devlink_sb_pool_info *pool_info);
+int ocelot_sb_pool_set(struct ocelot *ocelot, unsigned int sb_index,
+		       u16 pool_index, u32 size,
+		       enum devlink_sb_threshold_type threshold_type,
+		       struct netlink_ext_ack *extack);
+int ocelot_sb_port_pool_get(struct ocelot *ocelot, int port,
+			    unsigned int sb_index, u16 pool_index,
+			    u32 *p_threshold);
+int ocelot_sb_port_pool_set(struct ocelot *ocelot, int port,
+			    unsigned int sb_index, u16 pool_index,
+			    u32 threshold, struct netlink_ext_ack *extack);
+int ocelot_sb_tc_pool_bind_get(struct ocelot *ocelot, int port,
+			       unsigned int sb_index, u16 tc_index,
+			       enum devlink_sb_pool_type pool_type,
+			       u16 *p_pool_index, u32 *p_threshold);
+int ocelot_sb_tc_pool_bind_set(struct ocelot *ocelot, int port,
+			       unsigned int sb_index, u16 tc_index,
+			       enum devlink_sb_pool_type pool_type,
+			       u16 pool_index, u32 threshold,
+			       struct netlink_ext_ack *extack);
+int ocelot_sb_occ_snapshot(struct ocelot *ocelot, unsigned int sb_index);
+int ocelot_sb_occ_max_clear(struct ocelot *ocelot, unsigned int sb_index);
+int ocelot_sb_occ_port_pool_get(struct ocelot *ocelot, int port,
+				unsigned int sb_index, u16 pool_index,
+				u32 *p_cur, u32 *p_max);
+int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
+				   unsigned int sb_index, u16 tc_index,
+				   enum devlink_sb_pool_type pool_type,
+				   u32 *p_cur, u32 *p_max);
+
 #endif
-- 
2.25.1

