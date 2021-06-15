Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7279A3A7D5B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFOLip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:38:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21008 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229869AbhFOLil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:38:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FBUACW022086;
        Tue, 15 Jun 2021 04:34:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8zpR38NUMi6jIpllaOsgrSX+uT07qeuxAkqUyZn1xjo=;
 b=FVdv2/Blsjj4m3qRZ6KSNU+NaqL6Xkdz3wyzp+3RLL5GZE1iTgKqnPVe5e6FhVnfQSYb
 8SEKDDr9GuFrDsyfzsZvZUUT1Dx7hE/3yDlUFAHVcqq3KPh/9ESyBrGIBm0WHx69fdOy
 7zvXiZK7teiO9+FMjZOXJRryP/LcLj2lDaY/DECgdvrKISnNHLK+CbUnZg1PWS0/IR/J
 /zGc4Ke/h1X9DgucMg115spbXh+tiaA8g1pi+DQ0A1sjhyGO7fFTkoybLxaZOlqUftTJ
 PR9pwi5FINP/bsXoz2lSOEpiA305j+j8fz06MgPZd7lm8U4Ox6sHLGy0dW7F9CdqJoh0 QA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 396m0uj1ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 04:34:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 04:34:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Jun 2021 04:34:51 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id DE9313F7094;
        Tue, 15 Jun 2021 04:34:47 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 3/5] octeontx2-pf: TC_MATCHALL ingress ratelimiting offload
Date:   Tue, 15 Jun 2021 17:04:29 +0530
Message-ID: <1623756871-12524-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: PwbqRoeZ_gfBio5l5M634g2tE8G0PrZn
X-Proofpoint-ORIG-GUID: PwbqRoeZ_gfBio5l5M634g2tE8G0PrZn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Add TC_MATCHALL ingress ratelimiting offload support with POLICE
action for entire traffic coming into the interface.

Eg: To ratelimit ingress traffic to 100Mbps

$ ethtool -K eth0 hw-tc-offload on
$ tc qdisc add dev eth0 clsact
$ tc filter add dev eth0 ingress matchall skip_sw \
                action police rate 100Mbit burst 32Kbit

To support this, a leaf level bandwidth profile is allocated and all
RQs' contexts used by this interface are updated to point to it.
And the leaf level bandwidth profile is configured with user specified
rate and burst sizes.

Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 323 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |  11 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |  84 ++++++
 5 files changed, 423 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 9ec0313..1b08896 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -179,3 +179,326 @@ void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx)
 	sq->head++;
 	sq->head &= (sq->sqe_cnt - 1);
 }
+
+int cn10k_free_all_ipolicers(struct otx2_nic *pfvf)
+{
+	struct nix_bandprof_free_req *req;
+	int rc;
+
+	if (is_dev_otx2(pfvf->pdev))
+		return 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_nix_bandprof_free(&pfvf->mbox);
+	if (!req) {
+		rc =  -ENOMEM;
+		goto out;
+	}
+
+	/* Free all bandwidth profiles allocated */
+	req->free_all = true;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
+int cn10k_alloc_leaf_profile(struct otx2_nic *pfvf, u16 *leaf)
+{
+	struct nix_bandprof_alloc_req *req;
+	struct nix_bandprof_alloc_rsp *rsp;
+	int rc;
+
+	req = otx2_mbox_alloc_msg_nix_bandprof_alloc(&pfvf->mbox);
+	if (!req)
+		return  -ENOMEM;
+
+	req->prof_count[BAND_PROF_LEAF_LAYER] = 1;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		goto out;
+
+	rsp = (struct  nix_bandprof_alloc_rsp *)
+	       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (!rsp->prof_count[BAND_PROF_LEAF_LAYER]) {
+		rc = -EIO;
+		goto out;
+	}
+
+	*leaf = rsp->prof_idx[BAND_PROF_LEAF_LAYER][0];
+out:
+	if (rc) {
+		dev_warn(pfvf->dev,
+			 "Failed to allocate ingress bandwidth policer\n");
+	}
+
+	return rc;
+}
+
+int cn10k_alloc_matchall_ipolicer(struct otx2_nic *pfvf)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	int ret;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	ret = cn10k_alloc_leaf_profile(pfvf, &hw->matchall_ipolicer);
+
+	mutex_unlock(&pfvf->mbox.lock);
+
+	return ret;
+}
+
+#define POLICER_TIMESTAMP	  1  /* 1 second */
+#define MAX_RATE_EXP		  22 /* Valid rate exponent range: 0 - 22 */
+
+static void cn10k_get_ingress_burst_cfg(u32 burst, u32 *burst_exp,
+					u32 *burst_mantissa)
+{
+	int tmp;
+
+	/* Burst is calculated as
+	 * (1+[BURST_MANTISSA]/256)*2^[BURST_EXPONENT]
+	 * This is the upper limit on number tokens (bytes) that
+	 * can be accumulated in the bucket.
+	 */
+	*burst_exp = ilog2(burst);
+	if (burst < 256) {
+		/* No float: can't express mantissa in this case */
+		*burst_mantissa = 0;
+		return;
+	}
+
+	if (*burst_exp > MAX_RATE_EXP)
+		*burst_exp = MAX_RATE_EXP;
+
+	/* Calculate mantissa
+	 * Find remaining bytes 'burst - 2^burst_exp'
+	 * mantissa = (remaining bytes) / 2^ (burst_exp - 8)
+	 */
+	tmp = burst - rounddown_pow_of_two(burst);
+	*burst_mantissa = tmp / (1UL << (*burst_exp - 8));
+}
+
+static void cn10k_get_ingress_rate_cfg(u64 rate, u32 *rate_exp,
+				       u32 *rate_mantissa, u32 *rdiv)
+{
+	u32 div = 0;
+	u32 exp = 0;
+	u64 tmp;
+
+	/* Figure out mantissa, exponent and divider from given max pkt rate
+	 *
+	 * To achieve desired rate HW adds
+	 * (1+[RATE_MANTISSA]/256)*2^[RATE_EXPONENT] tokens (bytes) at every
+	 * policer timeunit * 2^rdiv ie 2 * 2^rdiv usecs, to the token bucket.
+	 * Here policer timeunit is 2 usecs and rate is in bits per sec.
+	 * Since floating point cannot be used below algorithm uses 1000000
+	 * scale factor to support rates upto 100Gbps.
+	 */
+	tmp = rate * 32 * 2;
+	if (tmp < 256000000) {
+		while (tmp < 256000000) {
+			tmp = tmp * 2;
+			div++;
+		}
+	} else {
+		for (exp = 0; tmp >= 512000000 && exp <= MAX_RATE_EXP; exp++)
+			tmp = tmp / 2;
+
+		if (exp > MAX_RATE_EXP)
+			exp = MAX_RATE_EXP;
+	}
+
+	*rate_mantissa = (tmp - 256000000) / 1000000;
+	*rate_exp = exp;
+	*rdiv = div;
+}
+
+int cn10k_map_unmap_rq_policer(struct otx2_nic *pfvf, int rq_idx,
+			       u16 policer, bool map)
+{
+	struct nix_cn10k_aq_enq_req *aq;
+
+	aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	/* Enable policing and set the bandwidth profile (policer) index */
+	if (map)
+		aq->rq.policer_ena = 1;
+	else
+		aq->rq.policer_ena = 0;
+	aq->rq_mask.policer_ena = 1;
+
+	aq->rq.band_prof_id = policer;
+	aq->rq_mask.band_prof_id = GENMASK(9, 0);
+
+	/* Fill AQ info */
+	aq->qidx = rq_idx;
+	aq->ctype = NIX_AQ_CTYPE_RQ;
+	aq->op = NIX_AQ_INSTOP_WRITE;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+int cn10k_free_leaf_profile(struct otx2_nic *pfvf, u16 leaf)
+{
+	struct nix_bandprof_free_req *req;
+
+	req = otx2_mbox_alloc_msg_nix_bandprof_free(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->prof_count[BAND_PROF_LEAF_LAYER] = 1;
+	req->prof_idx[BAND_PROF_LEAF_LAYER][0] = leaf;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+int cn10k_free_matchall_ipolicer(struct otx2_nic *pfvf)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	int qidx, rc;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	/* Remove RQ's policer mapping */
+	for (qidx = 0; qidx < hw->rx_queues; qidx++)
+		cn10k_map_unmap_rq_policer(pfvf, qidx,
+					   hw->matchall_ipolicer, false);
+
+	rc = cn10k_free_leaf_profile(pfvf, hw->matchall_ipolicer);
+
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
+int cn10k_set_ipolicer_rate(struct otx2_nic *pfvf, u16 profile,
+			    u32 burst, u64 rate, bool pps)
+{
+	struct nix_cn10k_aq_enq_req *aq;
+	u32 burst_exp, burst_mantissa;
+	u32 rate_exp, rate_mantissa;
+	u32 rdiv;
+
+	/* Get exponent and mantissa values for the desired rate */
+	cn10k_get_ingress_burst_cfg(burst, &burst_exp, &burst_mantissa);
+	cn10k_get_ingress_rate_cfg(rate, &rate_exp, &rate_mantissa, &rdiv);
+
+	/* Init bandwidth profile */
+	aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	/* Set initial color mode to blind */
+	aq->prof.icolor = 0x03;
+	aq->prof_mask.icolor = 0x03;
+
+	/* Set rate and burst values */
+	aq->prof.cir_exponent = rate_exp;
+	aq->prof_mask.cir_exponent = 0x1F;
+
+	aq->prof.cir_mantissa = rate_mantissa;
+	aq->prof_mask.cir_mantissa = 0xFF;
+
+	aq->prof.cbs_exponent = burst_exp;
+	aq->prof_mask.cbs_exponent = 0x1F;
+
+	aq->prof.cbs_mantissa = burst_mantissa;
+	aq->prof_mask.cbs_mantissa = 0xFF;
+
+	aq->prof.rdiv = rdiv;
+	aq->prof_mask.rdiv = 0xF;
+
+	if (pps) {
+		/* The amount of decremented tokens is calculated according to
+		 * the following equation:
+		 * max([ LMODE ? 0 : (packet_length - LXPTR)] +
+		 *	     ([ADJUST_MANTISSA]/256 - 1) * 2^[ADJUST_EXPONENT],
+		 *	1/256)
+		 * if LMODE is 1 then rate limiting will be based on
+		 * PPS otherwise bps.
+		 * The aim of the ADJUST value is to specify a token cost per
+		 * packet in contrary to the packet length that specifies a
+		 * cost per byte. To rate limit based on PPS adjust mantissa
+		 * is set as 384 and exponent as 1 so that number of tokens
+		 * decremented becomes 1 i.e, 1 token per packeet.
+		 */
+		aq->prof.adjust_exponent = 1;
+		aq->prof_mask.adjust_exponent = 0x1F;
+
+		aq->prof.adjust_mantissa = 384;
+		aq->prof_mask.adjust_mantissa = 0x1FF;
+
+		aq->prof.lmode = 0x1;
+		aq->prof_mask.lmode = 0x1;
+	}
+
+	/* Two rate three color marker
+	 * With PEIR/EIR set to zero, color will be either green or red
+	 */
+	aq->prof.meter_algo = 2;
+	aq->prof_mask.meter_algo = 0x3;
+
+	aq->prof.rc_action = NIX_RX_BAND_PROF_ACTIONRESULT_DROP;
+	aq->prof_mask.rc_action = 0x3;
+
+	aq->prof.yc_action = NIX_RX_BAND_PROF_ACTIONRESULT_PASS;
+	aq->prof_mask.yc_action = 0x3;
+
+	aq->prof.gc_action = NIX_RX_BAND_PROF_ACTIONRESULT_PASS;
+	aq->prof_mask.gc_action = 0x3;
+
+	/* Setting exponent value as 24 and mantissa as 0 configures
+	 * the bucket with zero values making bucket unused. Peak
+	 * information rate and Excess information rate buckets are
+	 * unused here.
+	 */
+	aq->prof.peir_exponent = 24;
+	aq->prof_mask.peir_exponent = 0x1F;
+
+	aq->prof.peir_mantissa = 0;
+	aq->prof_mask.peir_mantissa = 0xFF;
+
+	aq->prof.pebs_exponent = 24;
+	aq->prof_mask.pebs_exponent = 0x1F;
+
+	aq->prof.pebs_mantissa = 0;
+	aq->prof_mask.pebs_mantissa = 0xFF;
+
+	/* Fill AQ info */
+	aq->qidx = profile;
+	aq->ctype = NIX_AQ_CTYPE_BANDPROF;
+	aq->op = NIX_AQ_INSTOP_WRITE;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+int cn10k_set_matchall_ipolicer_rate(struct otx2_nic *pfvf,
+				     u32 burst, u64 rate)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	int qidx, rc;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	rc = cn10k_set_ipolicer_rate(pfvf, hw->matchall_ipolicer, burst,
+				     rate, false);
+	if (rc)
+		goto out;
+
+	for (qidx = 0; qidx < hw->rx_queues; qidx++) {
+		rc = cn10k_map_unmap_rq_policer(pfvf, qidx,
+						hw->matchall_ipolicer, true);
+		if (rc)
+			break;
+	}
+
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
index e0bc595..71292a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
@@ -14,4 +14,15 @@ void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx);
 int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
 int cn10k_pf_lmtst_init(struct otx2_nic *pf);
 int cn10k_vf_lmtst_init(struct otx2_nic *vf);
+int cn10k_free_all_ipolicers(struct otx2_nic *pfvf);
+int cn10k_alloc_matchall_ipolicer(struct otx2_nic *pfvf);
+int cn10k_free_matchall_ipolicer(struct otx2_nic *pfvf);
+int cn10k_set_matchall_ipolicer_rate(struct otx2_nic *pfvf,
+				     u32 burst, u64 rate);
+int cn10k_map_unmap_rq_policer(struct otx2_nic *pfvf, int rq_idx,
+			       u16 policer, bool map);
+int cn10k_alloc_leaf_profile(struct otx2_nic *pfvf, u16 *leaf);
+int cn10k_set_ipolicer_rate(struct otx2_nic *pfvf, u16 profile,
+			    u32 burst, u64 rate, bool pps);
+int cn10k_free_leaf_profile(struct otx2_nic *pfvf, u16 leaf);
 #endif /* CN10K_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 543aee7..8ade5af 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -180,6 +180,7 @@ struct otx2_hw {
 
 	/* NIX */
 	u16		txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
+	u16			matchall_ipolicer;
 
 	/* HW settings, coalescing etc */
 	u16			rx_chan_base;
@@ -325,6 +326,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 #define OTX2_FLAG_TC_FLOWER_SUPPORT		BIT_ULL(11)
 #define OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED	BIT_ULL(12)
+#define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
 	u64			flags;
 
 	struct otx2_qset	qset;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 82b53e72..23618b9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1461,6 +1461,9 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 
 	otx2_free_cq_res(pf);
 
+	/* Free all ingress bandwidth profiles allocated */
+	cn10k_free_all_ipolicers(pf);
+
 	mutex_lock(&mbox->lock);
 	/* Reset NIX LF */
 	free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 51157b2..af288e4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -15,6 +15,7 @@
 #include <net/tc_act/tc_vlan.h>
 #include <net/ipv6.h>
 
+#include "cn10k.h"
 #include "otx2_common.h"
 
 /* Egress rate limiting definitions */
@@ -675,6 +676,87 @@ static int otx2_setup_tc_cls_flower(struct otx2_nic *nic,
 	}
 }
 
+static int otx2_tc_ingress_matchall_install(struct otx2_nic *nic,
+					    struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct flow_action *actions = &cls->rule->action;
+	struct flow_action_entry *entry;
+	u64 rate;
+	int err;
+
+	err = otx2_tc_validate_flow(nic, actions, extack);
+	if (err)
+		return err;
+
+	if (nic->flags & OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only one ingress MATCHALL ratelimitter can be offloaded");
+		return -ENOMEM;
+	}
+
+	entry = &cls->rule->action.entries[0];
+	switch (entry->id) {
+	case FLOW_ACTION_POLICE:
+		/* Ingress ratelimiting is not supported on OcteonTx2 */
+		if (is_dev_otx2(nic->pdev)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Ingress policing not supported on this platform");
+			return -EOPNOTSUPP;
+		}
+
+		err = cn10k_alloc_matchall_ipolicer(nic);
+		if (err)
+			return err;
+
+		/* Convert to bits per second */
+		rate = entry->police.rate_bytes_ps * 8;
+		err = cn10k_set_matchall_ipolicer_rate(nic, entry->police.burst, rate);
+		if (err)
+			return err;
+		nic->flags |= OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only police action supported with Ingress MATCHALL offload");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int otx2_tc_ingress_matchall_delete(struct otx2_nic *nic,
+					   struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	int err;
+
+	if (nic->flags & OTX2_FLAG_INTF_DOWN) {
+		NL_SET_ERR_MSG_MOD(extack, "Interface not initialized");
+		return -EINVAL;
+	}
+
+	err = cn10k_free_matchall_ipolicer(nic);
+	nic->flags &= ~OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED;
+	return err;
+}
+
+static int otx2_setup_tc_ingress_matchall(struct otx2_nic *nic,
+					  struct tc_cls_matchall_offload *cls_matchall)
+{
+	switch (cls_matchall->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return otx2_tc_ingress_matchall_install(nic, cls_matchall);
+	case TC_CLSMATCHALL_DESTROY:
+		return otx2_tc_ingress_matchall_delete(nic, cls_matchall);
+	case TC_CLSMATCHALL_STATS:
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int otx2_setup_tc_block_ingress_cb(enum tc_setup_type type,
 					  void *type_data, void *cb_priv)
 {
@@ -686,6 +768,8 @@ static int otx2_setup_tc_block_ingress_cb(enum tc_setup_type type,
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return otx2_setup_tc_cls_flower(nic, type_data);
+	case TC_SETUP_CLSMATCHALL:
+		return otx2_setup_tc_ingress_matchall(nic, type_data);
 	default:
 		break;
 	}
-- 
2.7.4

