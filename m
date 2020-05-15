Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9611D57A4
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEORX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:28 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:32088 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgEORX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:27 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04FHNOLw028039;
        Fri, 15 May 2020 10:23:25 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 2/3] cxgb4: tune burst buffer size for TC-MQPRIO offload
Date:   Fri, 15 May 2020 22:41:04 +0530
Message-Id: <fd864e8b953b0e8179bc61cc1935a2599f3cf0ba.1589562017.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
References: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
References: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each traffic class, firmware handles up to 4 * MTU amount of data
per burst cycle. Under heavy load, this small buffer size is a
bottleneck when buffering large TSO packets in <= 1500 MTU case.
Increase the burst buffer size to 8 * MTU when supported.

Also, keep the driver's traffic class configuration API similar to
the firmware API counterpart.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    | 30 ++++++++++---------
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |  7 +++++
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |  3 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  8 +++--
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 30d25a37fc3b..fc1405a8ed74 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1125,19 +1125,20 @@ struct adapter {
  * programmed with various parameters.
  */
 struct ch_sched_params {
-	s8   type;                     /* packet or flow */
+	u8   type;                     /* packet or flow */
 	union {
 		struct {
-			s8   level;    /* scheduler hierarchy level */
-			s8   mode;     /* per-class or per-flow */
-			s8   rateunit; /* bit or packet rate */
-			s8   ratemode; /* %port relative or kbps absolute */
-			s8   channel;  /* scheduler channel [0..N] */
-			s8   class;    /* scheduler class [0..N] */
-			s32  minrate;  /* minimum rate */
-			s32  maxrate;  /* maximum rate */
-			s16  weight;   /* percent weight */
-			s16  pktsize;  /* average packet size */
+			u8   level;    /* scheduler hierarchy level */
+			u8   mode;     /* per-class or per-flow */
+			u8   rateunit; /* bit or packet rate */
+			u8   ratemode; /* %port relative or kbps absolute */
+			u8   channel;  /* scheduler channel [0..N] */
+			u8   class;    /* scheduler class [0..N] */
+			u32  minrate;  /* minimum rate */
+			u32  maxrate;  /* maximum rate */
+			u16  weight;   /* percent weight */
+			u16  pktsize;  /* average packet size */
+			u16  burstsize;  /* burst buffer size */
 		} params;
 	} u;
 };
@@ -1952,9 +1953,10 @@ int t4_sge_ctxt_rd(struct adapter *adap, unsigned int mbox, unsigned int cid,
 		   enum ctxt_type ctype, u32 *data);
 int t4_sge_ctxt_rd_bd(struct adapter *adap, unsigned int cid,
 		      enum ctxt_type ctype, u32 *data);
-int t4_sched_params(struct adapter *adapter, int type, int level, int mode,
-		    int rateunit, int ratemode, int channel, int class,
-		    int minrate, int maxrate, int weight, int pktsize);
+int t4_sched_params(struct adapter *adapter, u8 type, u8 level, u8 mode,
+		    u8 rateunit, u8 ratemode, u8 channel, u8 class,
+		    u32 minrate, u32 maxrate, u16 weight, u16 pktsize,
+		    u16 burstsize);
 void t4_sge_decode_idma_state(struct adapter *adapter, int state);
 void t4_idma_monitor_init(struct adapter *adapter,
 			  struct sge_idma_monitor_state *idma);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a70018f067aa..196451f8006f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3021,7 +3021,7 @@ static int cxgb4_mgmt_set_vf_rate(struct net_device *dev, int vf,
 			      SCHED_CLASS_RATEUNIT_BITS,
 			      SCHED_CLASS_RATEMODE_ABS,
 			      pi->tx_chan, class_id, 0,
-			      max_tx_rate * 1000, 0, pktsize);
+			      max_tx_rate * 1000, 0, pktsize, 0);
 	if (ret) {
 		dev_err(adap->pdev_dev, "Err %d for Traffic Class config\n",
 			ret);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index e6af4906d674..56079c9937db 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -342,6 +342,13 @@ static int cxgb4_mqprio_alloc_tc(struct net_device *dev,
 		p.u.params.minrate = div_u64(mqprio->min_rate[i] * 8, 1000);
 		p.u.params.maxrate = div_u64(mqprio->max_rate[i] * 8, 1000);
 
+		/* Request larger burst buffer for smaller MTU, so
+		 * that hardware can work on more data per burst
+		 * cycle.
+		 */
+		if (dev->mtu <= ETH_DATA_LEN)
+			p.u.params.burstsize = 8 * dev->mtu;
+
 		e = cxgb4_sched_class_alloc(dev, &p);
 		if (!e) {
 			ret = -ENOMEM;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index cebe1412d960..fde93c50cfec 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -57,7 +57,8 @@ static int t4_sched_class_fw_cmd(struct port_info *pi,
 				      p->u.params.ratemode,
 				      p->u.params.channel, e->idx,
 				      p->u.params.minrate, p->u.params.maxrate,
-				      p->u.params.weight, p->u.params.pktsize);
+				      p->u.params.weight, p->u.params.pktsize,
+				      p->u.params.burstsize);
 		break;
 	default:
 		err = -ENOTSUPP;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 2a3480fc1d91..1c8068c02728 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -10361,9 +10361,10 @@ int t4_sge_ctxt_rd_bd(struct adapter *adap, unsigned int cid,
 	return ret;
 }
 
-int t4_sched_params(struct adapter *adapter, int type, int level, int mode,
-		    int rateunit, int ratemode, int channel, int class,
-		    int minrate, int maxrate, int weight, int pktsize)
+int t4_sched_params(struct adapter *adapter, u8 type, u8 level, u8 mode,
+		    u8 rateunit, u8 ratemode, u8 channel, u8 class,
+		    u32 minrate, u32 maxrate, u16 weight, u16 pktsize,
+		    u16 burstsize)
 {
 	struct fw_sched_cmd cmd;
 
@@ -10385,6 +10386,7 @@ int t4_sched_params(struct adapter *adapter, int type, int level, int mode,
 	cmd.u.params.max = cpu_to_be32(maxrate);
 	cmd.u.params.weight = cpu_to_be16(weight);
 	cmd.u.params.pktsize = cpu_to_be16(pktsize);
+	cmd.u.params.burstsize = cpu_to_be16(burstsize);
 
 	return t4_wr_mbox_meat(adapter, adapter->mbox, &cmd, sizeof(cmd),
 			       NULL, 1);
-- 
2.24.0

