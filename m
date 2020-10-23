Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84C9296E1A
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 13:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463317AbgJWL7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 07:59:12 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26732 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463312AbgJWL7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 07:59:12 -0400
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09NBx7Ve018990;
        Fri, 23 Oct 2020 04:59:08 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com, rajur@chelsio.com
Subject: [PATCH net] cxgb4: set up filter action after rewrites
Date:   Fri, 23 Oct 2020 17:28:52 +0530
Message-Id: <20201023115852.18262-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code sets up the filter action field before
rewrites are set up. When the action 'switch' is used
with rewrites, this may result in initial few packets
that get switched out don't have rewrites applied
on them.

So, make sure filter action is set up along with rewrites
or only after everything else is set up for rewrites.

Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 56 +++++++++++------------
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h       |  4 ++
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 6ec5f2f26f05..4e55f7081644 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -145,13 +145,13 @@ static int configure_filter_smac(struct adapter *adap, struct filter_entry *f)
 	int err;
 
 	/* do a set-tcb for smac-sel and CWR bit.. */
-	err = set_tcb_tflag(adap, f, f->tid, TF_CCTRL_CWR_S, 1, 1);
-	if (err)
-		goto smac_err;
-
 	err = set_tcb_field(adap, f, f->tid, TCB_SMAC_SEL_W,
 			    TCB_SMAC_SEL_V(TCB_SMAC_SEL_M),
 			    TCB_SMAC_SEL_V(f->smt->idx), 1);
+	if (err)
+		goto smac_err;
+
+	err = set_tcb_tflag(adap, f, f->tid, TF_CCTRL_CWR_S, 1, 1);
 	if (!err)
 		return 0;
 
@@ -862,6 +862,7 @@ int set_filter_wr(struct adapter *adapter, int fidx)
 		      FW_FILTER_WR_DIRSTEERHASH_V(f->fs.dirsteerhash) |
 		      FW_FILTER_WR_LPBK_V(f->fs.action == FILTER_SWITCH) |
 		      FW_FILTER_WR_DMAC_V(f->fs.newdmac) |
+		      FW_FILTER_WR_SMAC_V(f->fs.newsmac) |
 		      FW_FILTER_WR_INSVLAN_V(f->fs.newvlan == VLAN_INSERT ||
 					     f->fs.newvlan == VLAN_REWRITE) |
 		      FW_FILTER_WR_RMVLAN_V(f->fs.newvlan == VLAN_REMOVE ||
@@ -879,7 +880,7 @@ int set_filter_wr(struct adapter *adapter, int fidx)
 		 FW_FILTER_WR_OVLAN_VLD_V(f->fs.val.ovlan_vld) |
 		 FW_FILTER_WR_IVLAN_VLDM_V(f->fs.mask.ivlan_vld) |
 		 FW_FILTER_WR_OVLAN_VLDM_V(f->fs.mask.ovlan_vld));
-	fwr->smac_sel = 0;
+	fwr->smac_sel = f->smt->idx;
 	fwr->rx_chan_rx_rpl_iq =
 		htons(FW_FILTER_WR_RX_CHAN_V(0) |
 		      FW_FILTER_WR_RX_RPL_IQ_V(adapter->sge.fw_evtq.abs_id));
@@ -1323,11 +1324,8 @@ static void mk_act_open_req6(struct filter_entry *f, struct sk_buff *skb,
 			    TX_QUEUE_V(f->fs.nat_mode) |
 			    T5_OPT_2_VALID_F |
 			    RX_CHANNEL_V(cxgb4_port_e2cchan(f->dev)) |
-			    CONG_CNTRL_V((f->fs.action == FILTER_DROP) |
-					 (f->fs.dirsteer << 1)) |
 			    PACE_V((f->fs.maskhash) |
-				   ((f->fs.dirsteerhash) << 1)) |
-			    CCTRL_ECN_V(f->fs.action == FILTER_SWITCH));
+				   ((f->fs.dirsteerhash) << 1)));
 }
 
 static void mk_act_open_req(struct filter_entry *f, struct sk_buff *skb,
@@ -1363,11 +1361,8 @@ static void mk_act_open_req(struct filter_entry *f, struct sk_buff *skb,
 			    TX_QUEUE_V(f->fs.nat_mode) |
 			    T5_OPT_2_VALID_F |
 			    RX_CHANNEL_V(cxgb4_port_e2cchan(f->dev)) |
-			    CONG_CNTRL_V((f->fs.action == FILTER_DROP) |
-					 (f->fs.dirsteer << 1)) |
 			    PACE_V((f->fs.maskhash) |
-				   ((f->fs.dirsteerhash) << 1)) |
-			    CCTRL_ECN_V(f->fs.action == FILTER_SWITCH));
+				   ((f->fs.dirsteerhash) << 1)));
 }
 
 static int cxgb4_set_hash_filter(struct net_device *dev,
@@ -2039,6 +2034,20 @@ void hash_filter_rpl(struct adapter *adap, const struct cpl_act_open_rpl *rpl)
 			}
 			return;
 		}
+		switch (f->fs.action) {
+		case FILTER_PASS:
+			if (f->fs.dirsteer)
+				set_tcb_tflag(adap, f, tid,
+					      TF_DIRECT_STEER_S, 1, 1);
+			break;
+		case FILTER_DROP:
+			set_tcb_tflag(adap, f, tid, TF_DROP_S, 1, 1);
+			break;
+		case FILTER_SWITCH:
+			set_tcb_tflag(adap, f, tid, TF_LPBK_S, 1, 1);
+			break;
+		}
+
 		break;
 
 	default:
@@ -2106,22 +2115,11 @@ void filter_rpl(struct adapter *adap, const struct cpl_set_tcb_rpl *rpl)
 			if (ctx)
 				ctx->result = 0;
 		} else if (ret == FW_FILTER_WR_FLT_ADDED) {
-			int err = 0;
-
-			if (f->fs.newsmac)
-				err = configure_filter_smac(adap, f);
-
-			if (!err) {
-				f->pending = 0;  /* async setup completed */
-				f->valid = 1;
-				if (ctx) {
-					ctx->result = 0;
-					ctx->tid = idx;
-				}
-			} else {
-				clear_filter(adap, f);
-				if (ctx)
-					ctx->result = err;
+			f->pending = 0;  /* async setup completed */
+			f->valid = 1;
+			if (ctx) {
+				ctx->result = 0;
+				ctx->tid = idx;
 			}
 		} else {
 			/* Something went wrong.  Issue a warning about the
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
index 50232e063f49..92473dda55d9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h
@@ -50,6 +50,10 @@
 #define TCB_T_FLAGS_M		0xffffffffffffffffULL
 #define TCB_T_FLAGS_V(x)	((__u64)(x) << TCB_T_FLAGS_S)
 
+#define TF_DROP_S		22
+#define TF_DIRECT_STEER_S	23
+#define TF_LPBK_S		59
+
 #define TF_CCTRL_ECE_S		60
 #define TF_CCTRL_CWR_S		61
 #define TF_CCTRL_RFR_S		62
-- 
2.9.5

