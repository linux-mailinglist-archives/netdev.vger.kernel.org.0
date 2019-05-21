Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C660824669
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 05:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfEUDlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 23:41:01 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:18413 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEUDlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 23:41:01 -0400
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x4L3epeA019931;
        Mon, 20 May 2019 20:40:52 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, indranil@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next] cxgb4: Enable hash filter with offload
Date:   Tue, 21 May 2019 09:10:37 +0530
Message-Id: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables hash filter along with offload

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h        |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 38 +++++++++++------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 52 +++++++++++++++++++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c        | 32 ++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h      |  4 ++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h     |  2 +
 8 files changed, 110 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index a8fe080..a707a65 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -600,6 +600,7 @@ struct port_info {
 	u8 vin;
 	u8 vivld;
 	u8 smt_idx;
+	u8 rx_cchan;
 };
 
 struct dentry;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 4107007..0f0b3f4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1041,7 +1041,7 @@ static void mk_act_open_req6(struct filter_entry *f, struct sk_buff *skb,
 			    RSS_QUEUE_V(f->fs.iq) |
 			    TX_QUEUE_V(f->fs.nat_mode) |
 			    T5_OPT_2_VALID_F |
-			    RX_CHANNEL_F |
+			    RX_CHANNEL_V(cxgb4_port_e2cchan(f->dev)) |
 			    CONG_CNTRL_V((f->fs.action == FILTER_DROP) |
 					 (f->fs.dirsteer << 1)) |
 			    PACE_V((f->fs.maskhash) |
@@ -1081,7 +1081,7 @@ static void mk_act_open_req(struct filter_entry *f, struct sk_buff *skb,
 			    RSS_QUEUE_V(f->fs.iq) |
 			    TX_QUEUE_V(f->fs.nat_mode) |
 			    T5_OPT_2_VALID_F |
-			    RX_CHANNEL_F |
+			    RX_CHANNEL_V(cxgb4_port_e2cchan(f->dev)) |
 			    CONG_CNTRL_V((f->fs.action == FILTER_DROP) |
 					 (f->fs.dirsteer << 1)) |
 			    PACE_V((f->fs.maskhash) |
@@ -1833,24 +1833,38 @@ void filter_rpl(struct adapter *adap, const struct cpl_set_tcb_rpl *rpl)
 	}
 }
 
-int init_hash_filter(struct adapter *adap)
+void init_hash_filter(struct adapter *adap)
 {
+	u32 reg;
+
 	/* On T6, verify the necessary register configs and warn the user in
 	 * case of improper config
 	 */
 	if (is_t6(adap->params.chip)) {
-		if (TCAM_ACTV_HIT_G(t4_read_reg(adap, LE_DB_RSP_CODE_0_A)) != 4)
-			goto err;
+		if (is_offload(adap)) {
+			if (!(t4_read_reg(adap, TP_GLOBAL_CONFIG_A)
+			   & ACTIVEFILTERCOUNTS_F)) {
+				dev_err(adap->pdev_dev, "Invalid hash filter + ofld config\n");
+				return;
+			}
+		} else {
+			reg = t4_read_reg(adap, LE_DB_RSP_CODE_0_A);
+			if (TCAM_ACTV_HIT_G(reg) != 4) {
+				dev_err(adap->pdev_dev, "Invalid hash filter config\n");
+				return;
+			}
+
+			reg = t4_read_reg(adap, LE_DB_RSP_CODE_1_A);
+			if (HASH_ACTV_HIT_G(reg) != 4) {
+				dev_err(adap->pdev_dev, "Invalid hash filter config\n");
+				return;
+			}
+		}
 
-		if (HASH_ACTV_HIT_G(t4_read_reg(adap, LE_DB_RSP_CODE_1_A)) != 4)
-			goto err;
 	} else {
 		dev_err(adap->pdev_dev, "Hash filter supported only on T6\n");
-		return -EINVAL;
+		return;
 	}
+
 	adap->params.hash_filter = 1;
-	return 0;
-err:
-	dev_warn(adap->pdev_dev, "Invalid hash filter config!\n");
-	return -EINVAL;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
index 8db5fca..b0751c0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
@@ -50,7 +50,7 @@ void hash_del_filter_rpl(struct adapter *adap,
 
 int writable_filter(struct filter_entry *f);
 void clear_all_filters(struct adapter *adapter);
-int init_hash_filter(struct adapter *adap);
+void init_hash_filter(struct adapter *adap);
 bool is_filter_exact_match(struct adapter *adap,
 			   struct ch_filter_specification *fs);
 #endif /* __CXGB4_FILTER_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7487852..7a56b2b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1646,6 +1646,18 @@ unsigned int cxgb4_port_chan(const struct net_device *dev)
 }
 EXPORT_SYMBOL(cxgb4_port_chan);
 
+/**
+ *      cxgb4_port_e2cchan - get the HW c-channel of a port
+ *      @dev: the net device for the port
+ *
+ *      Return the HW RX c-channel of the given port.
+ */
+unsigned int cxgb4_port_e2cchan(const struct net_device *dev)
+{
+	return netdev2pinfo(dev)->rx_cchan;
+}
+EXPORT_SYMBOL(cxgb4_port_e2cchan);
+
 unsigned int cxgb4_dbfifo_count(const struct net_device *dev, int lpfifo)
 {
 	struct adapter *adap = netdev2adap(dev);
@@ -3905,14 +3917,14 @@ static int adap_init0_phy(struct adapter *adap)
  */
 static int adap_init0_config(struct adapter *adapter, int reset)
 {
+	char *fw_config_file, fw_config_file_path[256];
+	u32 finiver, finicsum, cfcsum, param, val;
 	struct fw_caps_config_cmd caps_cmd;
-	const struct firmware *cf;
 	unsigned long mtype = 0, maddr = 0;
-	u32 finiver, finicsum, cfcsum;
-	int ret;
-	int config_issued = 0;
-	char *fw_config_file, fw_config_file_path[256];
+	const struct firmware *cf;
 	char *config_name = NULL;
+	int config_issued = 0;
+	int ret;
 
 	/*
 	 * Reset device if necessary.
@@ -4020,6 +4032,24 @@ static int adap_init0_config(struct adapter *adapter, int reset)
 			goto bye;
 	}
 
+	val = 0;
+
+	/* Ofld + Hash filter is supported. Older fw will fail this request and
+	 * it is fine.
+	 */
+	param = (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
+		 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_HASHFILTER_WITH_OFLD));
+	ret = t4_set_params(adapter, adapter->mbox, adapter->pf, 0,
+			    1, &param, &val);
+
+	/* FW doesn't know about Hash filter + ofld support,
+	 * it's not a problem, don't return an error.
+	 */
+	if (ret < 0) {
+		dev_warn(adapter->pdev_dev,
+			 "Hash filter with ofld is not supported by FW\n");
+	}
+
 	/*
 	 * Issue a Capability Configuration command to the firmware to get it
 	 * to parse the Configuration File.  We don't use t4_fw_config_file()
@@ -4580,6 +4610,13 @@ static int adap_init0(struct adapter *adap)
 	if (ret < 0)
 		goto bye;
 
+	/* hash filter has some mandatory register settings to be tested and for
+	 * that it needs to test whether offload is enabled or not, hence
+	 * checking and setting it here.
+	 */
+	if (caps_cmd.ofldcaps)
+		adap->params.offload = 1;
+
 	if (caps_cmd.ofldcaps ||
 	    (caps_cmd.niccaps & htons(FW_CAPS_CONFIG_NIC_HASHFILTER))) {
 		/* query offload-related parameters */
@@ -4619,11 +4656,8 @@ static int adap_init0(struct adapter *adap)
 		adap->params.ofldq_wr_cred = val[5];
 
 		if (caps_cmd.niccaps & htons(FW_CAPS_CONFIG_NIC_HASHFILTER)) {
-			ret = init_hash_filter(adap);
-			if (ret < 0)
-				goto bye;
+			init_hash_filter(adap);
 		} else {
-			adap->params.offload = 1;
 			adap->num_ofld_uld += 1;
 		}
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 21da34a..42ae28d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -393,6 +393,7 @@ int cxgb4_immdata_send(struct net_device *dev, unsigned int idx,
 int cxgb4_crypto_send(struct net_device *dev, struct sk_buff *skb);
 unsigned int cxgb4_dbfifo_count(const struct net_device *dev, int lpfifo);
 unsigned int cxgb4_port_chan(const struct net_device *dev);
+unsigned int cxgb4_port_e2cchan(const struct net_device *dev);
 unsigned int cxgb4_port_viid(const struct net_device *dev);
 unsigned int cxgb4_tp_smt_idx(enum chip_type chip, unsigned int viid);
 unsigned int cxgb4_port_idx(const struct net_device *dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 93feb25..c36cb6a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -6209,6 +6209,37 @@ unsigned int t4_get_mps_bg_map(struct adapter *adapter, int pidx)
 }
 
 /**
+ *      t4_get_tp_e2c_map - return the E2C channel map associated with a port
+ *      @adapter: the adapter
+ *      @pidx: the port index
+ */
+unsigned int t4_get_tp_e2c_map(struct adapter *adapter, int pidx)
+{
+	unsigned int nports;
+	u32 param, val = 0;
+	int ret;
+
+	nports = 1 << NUMPORTS_G(t4_read_reg(adapter, MPS_CMN_CTL_A));
+	if (pidx >= nports) {
+		CH_WARN(adapter, "TP E2C Channel Port Index %d >= Nports %d\n",
+			pidx, nports);
+		return 0;
+	}
+
+	/* FW version >= 1.16.44.0 can determine E2C channel map using
+	 * FW_PARAMS_PARAM_DEV_TPCHMAP API.
+	 */
+	param = (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
+		 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_TPCHMAP));
+	ret = t4_query_params_ns(adapter, adapter->mbox, adapter->pf,
+				 0, 1, &param, &val);
+	if (!ret)
+		return (val >> (8 * pidx)) & 0xff;
+
+	return 0;
+}
+
+/**
  *	t4_get_tp_ch_map - return TP ingress channels associated with a port
  *	@adapter: the adapter
  *	@pidx: the port index
@@ -9594,6 +9625,7 @@ int t4_init_portinfo(struct port_info *pi, int mbox,
 	pi->tx_chan = port;
 	pi->lport = port;
 	pi->rss_size = rss_size;
+	pi->rx_cchan = t4_get_tp_e2c_map(pi->adapter, port);
 
 	/* If fw supports returning the VIN as part of FW_VI_CMD,
 	 * save the returned values.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index eb222d4..a957a6e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -1334,6 +1334,10 @@
 #define TP_OUT_CONFIG_A		0x7d04
 #define TP_GLOBAL_CONFIG_A	0x7d08
 
+#define ACTIVEFILTERCOUNTS_S    22
+#define ACTIVEFILTERCOUNTS_V(x) ((x) << ACTIVEFILTERCOUNTS_S)
+#define ACTIVEFILTERCOUNTS_F    ACTIVEFILTERCOUNTS_V(1U)
+
 #define TP_CMM_TCB_BASE_A 0x7d10
 #define TP_CMM_MM_BASE_A 0x7d14
 #define TP_CMM_TIMER_BASE_A 0x7d18
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index b2a618e..6a10e95 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -1250,10 +1250,12 @@ enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_RI_FR_NSMR_TPTE_WR	= 0x1C,
 	FW_PARAMS_PARAM_DEV_FILTER2_WR  = 0x1D,
 	FW_PARAMS_PARAM_DEV_MPSBGMAP	= 0x1E,
+	FW_PARAMS_PARAM_DEV_TPCHMAP     = 0x1F,
 	FW_PARAMS_PARAM_DEV_HMA_SIZE	= 0x20,
 	FW_PARAMS_PARAM_DEV_RDMA_WRITE_WITH_IMM = 0x21,
 	FW_PARAMS_PARAM_DEV_RI_WRITE_CMPL_WR    = 0x24,
 	FW_PARAMS_PARAM_DEV_OPAQUE_VIID_SMT_EXTN = 0x27,
+	FW_PARAMS_PARAM_DEV_HASHFILTER_WITH_OFLD = 0x28,
 	FW_PARAMS_PARAM_DEV_DBQ_TIMER	= 0x29,
 	FW_PARAMS_PARAM_DEV_DBQ_TIMERTICK = 0x2A,
 };
-- 
1.8.3.1

