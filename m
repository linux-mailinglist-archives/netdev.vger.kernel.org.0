Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB152F706B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbhAOCNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbhAOCNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:13:11 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F26AC061795
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:12:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ke15so3495600ejc.12
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qZ+bZw+8fYFb5/fPfIdHqgH9un4+DxI85xMeIOG6tZ0=;
        b=XtvxIuTuzrAFIShGPFzGhOs5d7W7gMQKzZv6z63gJYJpWJxLH8oCb7L+5qHTjZWe0t
         uDLdzZDGWj0NrkjBKsYXDu3LzGItImgPhTCs/GGMrZnovVTmJIjoTM2Tu+dx/Q7K3ikP
         gJOwNzBiGVqihIyEo2zWq/jENMjyCt0ETxbGbgWv5IYvrpTp5oaJ4KxTUBjmSOgxtMfg
         EZUCKYpag14q4gcUgUcBc9YAe0KFwrDW28D52NwwsQZIIeThx2I91KwHt5eN9Pn3IiO0
         ebiplUeHUgh6+y6YVG2b5vu2SCMu9GHDqN5uYUGAi+wcizrGaNU5yFN6LDtewAlbsXQq
         K8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qZ+bZw+8fYFb5/fPfIdHqgH9un4+DxI85xMeIOG6tZ0=;
        b=pgHrBgm1eBp7Ce2zb/CACX+IOcSB95lDEkaJvojzOE7K7qdreA39Lyl9d2HEPA7+5j
         PE27RHapQvmkXGApeLd10yzQa9uvkuEhA/8LoJRLYGihjxC6DGEIB7W/GO8Nu+ddunZ9
         c/F+dXlXTLGnNjfSnNjiu3TtHKgcM4M2BsfvjJTQEVgGuXv2VpQ/DOeRRzOYOauHdQD2
         7QwPO+vmBjN1xzUuWQEKBKoQ78+Ef2NOEQB7cuEGprganYAktrko+EUBkZ0i7QWRmuLM
         wHfEREYyjSGcgRwufasv7Z381lrIBoOe//rEJmCWw2T2vMrMe8AxBXQfW1xMbdyyFWZx
         zKoQ==
X-Gm-Message-State: AOAM532JNtVTaZCbzbosxzgraW//7t+uEasv8WEKsTWin3HzTRLpKJiM
        ehM1NZLrwkqpDhmlUE/j4BakraE6mnQ=
X-Google-Smtp-Source: ABdhPJxGNn5cQvND26NaVn2BAc4gMQLjdu8hqYOWOURJ52h9dBo4Q22inkF+On8bBG9yGwpv1YArGg==
X-Received: by 2002:a17:906:8152:: with SMTP id z18mr7492080ejw.317.1610676719169;
        Thu, 14 Jan 2021 18:11:59 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id oq27sm2596494ejb.108.2021.01.14.18.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:11:58 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 10/10] net: mscc: ocelot: configure watermarks using devlink-sb
Date:   Fri, 15 Jan 2021 04:11:20 +0200
Message-Id: <20210115021120.3055988-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115021120.3055988-1-olteanv@gmail.com>
References: <20210115021120.3055988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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
	size 129840 thtype static

Since by default there is no buffer reservation, the above command has
maxed out BUF_COL_SHR_I(dp=0).

Configuring the per-port reservation watermark (P_RSRV) is done in the
following way:

devlink sb port pool set pci/0000:00:00.5/0 sb $SB_BUF \
	pool $POOL_ING th 1000

The above command sets BUF_P_RSRV_I(port 0) to 1000 bytes. After this
command, the sharing watermarks are internally reconfigured with 1000
bytes less, i.e. from 129840 bytes to 128840 bytes.

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
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
Created some helper functions: devlink_to_ocelot, devlink_port_to_ocelot
and devlink_port_to_port.

Changes in v3:
None.

Changes in v2:
- Calling ocelot_watermark_init from ocelot_devlink_sb_register, since
  there was a bug in v1 where ocelot_watermark_init would use an
  uninitialized value from ocelot->pool_size, so we need to ensure that
  ocelot_watermark_init is called after ocelot_devlink_sb_register
  actually initializes the pool sizes.
- Deleted the "detected N bytes and M frame references" message since
  that information is now available through devlink-sb.

 drivers/net/dsa/ocelot/felix.c             | 118 ++++++
 drivers/net/ethernet/mscc/ocelot.c         |   5 -
 drivers/net/ethernet/mscc/ocelot.h         |   1 -
 drivers/net/ethernet/mscc/ocelot_devlink.c | 453 ++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_net.c     | 140 +++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   8 +
 include/soc/mscc/ocelot.h                  |  47 +++
 7 files changed, 761 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6c584496abc6..2c6ac2b137ec 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -427,6 +427,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->ops		= felix->info->ops;
 	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->devlink		= felix->ds->devlink;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
 				 GFP_KERNEL);
@@ -588,6 +589,10 @@ static int felix_setup(struct dsa_switch *ds)
 		felix_port_qos_map_init(ocelot, port);
 	}
 
+	err = ocelot_devlink_sb_register(ocelot);
+	if (err)
+		return err;
+
 	/* Include the CPU port module in the forwarding mask for unknown
 	 * unicast - the hardware default value for ANA_FLOODING_FLD_UNICAST
 	 * excludes BIT(ocelot->num_phys_ports), and so does ocelot_init, since
@@ -610,6 +615,7 @@ static void felix_teardown(struct dsa_switch *ds)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
+	ocelot_devlink_sb_unregister(ocelot);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_deinit(ocelot);
 
@@ -751,6 +757,108 @@ static int felix_port_setup_tc(struct dsa_switch *ds, int port,
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
@@ -789,6 +897,16 @@ const struct dsa_switch_ops felix_switch_ops = {
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
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 474ea5e59f89..a560d6be2a44 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1480,10 +1480,6 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 
 	eq_ctrl = ocelot_read(ocelot, QSYS_EQ_CTRL);
 	ocelot->num_frame_refs = QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(eq_ctrl);
-
-	dev_info(ocelot->dev,
-		 "Detected %d bytes of packet buffer and %d frame references\n",
-		 ocelot->packet_buffer_size, ocelot->num_frame_refs);
 }
 
 int ocelot_init(struct ocelot *ocelot)
@@ -1624,7 +1620,6 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
-	ocelot_watermark_init(ocelot);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 48faa4dc893c..e8621dbc14f7 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -126,7 +126,6 @@ void ocelot_devlink_teardown(struct ocelot *ocelot);
 int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 			     enum devlink_port_flavour flavour);
 void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
-void ocelot_watermark_init(struct ocelot *ocelot);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index c58315b62841..edafbd37d12c 100644
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
@@ -427,7 +473,7 @@ static void ocelot_setup_sharing_watermarks(struct ocelot *ocelot)
  * reservations by default, let sharing use all resources) and disables the
  * unused watermarks.
  */
-void ocelot_watermark_init(struct ocelot *ocelot)
+static void ocelot_watermark_init(struct ocelot *ocelot)
 {
 	int all_tcs = GENMASK(OCELOT_NUM_TC - 1, 0);
 	int port;
@@ -440,3 +486,400 @@ void ocelot_watermark_init(struct ocelot *ocelot)
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
+	ocelot_watermark_init(ocelot);
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
index 4485faefc2b1..a520fd485912 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1,14 +1,154 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Microsemi Ocelot Switch driver
+ *
+ * This contains glue logic between the switchdev driver operations and the
+ * mscc_ocelot_switch_lib.
  *
  * Copyright (c) 2017, 2019 Microsemi Corporation
+ * Copyright 2020-2021 NXP Semiconductors
  */
 
 #include <linux/if_bridge.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
+static struct ocelot *devlink_port_to_ocelot(struct devlink_port *dlp)
+{
+	return devlink_priv(dlp->devlink);
+}
+
+static int devlink_port_to_port(struct devlink_port *dlp)
+{
+	struct ocelot *ocelot = devlink_port_to_ocelot(dlp);
+
+	return dlp - ocelot->devlink_ports;
+}
+
+static int ocelot_devlink_sb_pool_get(struct devlink *dl,
+				      unsigned int sb_index, u16 pool_index,
+				      struct devlink_sb_pool_info *pool_info)
+{
+	struct ocelot *ocelot = devlink_priv(dl);
+
+	return ocelot_sb_pool_get(ocelot, sb_index, pool_index, pool_info);
+}
+
+static int ocelot_devlink_sb_pool_set(struct devlink *dl, unsigned int sb_index,
+				      u16 pool_index, u32 size,
+				      enum devlink_sb_threshold_type threshold_type,
+				      struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = devlink_priv(dl);
+
+	return ocelot_sb_pool_set(ocelot, sb_index, pool_index, size,
+				  threshold_type, extack);
+}
+
+static int ocelot_devlink_sb_port_pool_get(struct devlink_port *dlp,
+					   unsigned int sb_index, u16 pool_index,
+					   u32 *p_threshold)
+{
+	struct ocelot *ocelot = devlink_port_to_ocelot(dlp);
+	int port = devlink_port_to_port(dlp);
+
+	return ocelot_sb_port_pool_get(ocelot, port, sb_index, pool_index,
+				       p_threshold);
+}
+
+static int ocelot_devlink_sb_port_pool_set(struct devlink_port *dlp,
+					   unsigned int sb_index, u16 pool_index,
+					   u32 threshold,
+					   struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = devlink_port_to_ocelot(dlp);
+	int port = devlink_port_to_port(dlp);
+
+	return ocelot_sb_port_pool_set(ocelot, port, sb_index, pool_index,
+				       threshold, extack);
+}
+
+static int
+ocelot_devlink_sb_tc_pool_bind_get(struct devlink_port *dlp,
+				   unsigned int sb_index, u16 tc_index,
+				   enum devlink_sb_pool_type pool_type,
+				   u16 *p_pool_index, u32 *p_threshold)
+{
+	struct ocelot *ocelot = devlink_port_to_ocelot(dlp);
+	int port = devlink_port_to_port(dlp);
+
+	return ocelot_sb_tc_pool_bind_get(ocelot, port, sb_index, tc_index,
+					  pool_type, p_pool_index,
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
+	struct ocelot *ocelot = devlink_port_to_ocelot(dlp);
+	int port = devlink_port_to_port(dlp);
+
+	return ocelot_sb_tc_pool_bind_set(ocelot, port, sb_index, tc_index,
+					  pool_type, pool_index, threshold,
+					  extack);
+}
+
+static int ocelot_devlink_sb_occ_snapshot(struct devlink *dl,
+					  unsigned int sb_index)
+{
+	struct ocelot *ocelot = devlink_priv(dl);
+
+	return ocelot_sb_occ_snapshot(ocelot, sb_index);
+}
+
+static int ocelot_devlink_sb_occ_max_clear(struct devlink *dl,
+					   unsigned int sb_index)
+{
+	struct ocelot *ocelot = devlink_priv(dl);
+
+	return ocelot_sb_occ_max_clear(ocelot, sb_index);
+}
+
+static int ocelot_devlink_sb_occ_port_pool_get(struct devlink_port *dlp,
+					       unsigned int sb_index,
+					       u16 pool_index, u32 *p_cur,
+					       u32 *p_max)
+{
+	struct ocelot *ocelot = devlink_port_to_ocelot(dlp);
+	int port = devlink_port_to_port(dlp);
+
+	return ocelot_sb_occ_port_pool_get(ocelot, port, sb_index, pool_index,
+					   p_cur, p_max);
+}
+
+static int
+ocelot_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
+				       unsigned int sb_index, u16 tc_index,
+				       enum devlink_sb_pool_type pool_type,
+				       u32 *p_cur, u32 *p_max)
+{
+	struct ocelot *ocelot = devlink_port_to_ocelot(dlp);
+	int port = devlink_port_to_port(dlp);
+
+	return ocelot_sb_occ_tc_port_bind_get(ocelot, port, sb_index,
+					      tc_index, pool_type,
+					      p_cur, p_max);
+}
+
 const struct devlink_ops ocelot_devlink_ops = {
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
 
 int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 28617023cd85..30a38df08a21 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1363,6 +1363,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_ocelot_devlink_unregister;
 
+	err = ocelot_devlink_sb_register(ocelot);
+	if (err)
+		goto out_ocelot_release_ports;
+
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
 		if (err) {
@@ -1382,6 +1386,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	return 0;
 
+out_ocelot_release_ports:
+	mscc_ocelot_release_ports(ocelot);
+	mscc_ocelot_teardown_devlink_ports(ocelot);
 out_ocelot_devlink_unregister:
 	devlink_unregister(devlink);
 out_ocelot_deinit:
@@ -1398,6 +1405,7 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
 	ocelot_deinit_timestamp(ocelot);
+	ocelot_devlink_sb_unregister(ocelot);
 	mscc_ocelot_release_ports(ocelot);
 	mscc_ocelot_teardown_devlink_ports(ocelot);
 	devlink_unregister(ocelot->devlink);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index fc7dc6679739..cdc33fa05660 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -579,6 +579,18 @@ struct ocelot_vlan {
 	u16 vid;
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
 
@@ -612,6 +624,7 @@ struct ocelot {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 
+	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
 	int				packet_buffer_size;
 	int				num_frame_refs;
 	int				num_mact_rows;
@@ -783,4 +796,38 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
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

