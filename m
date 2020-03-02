Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93702175B7F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgCBNYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:24:38 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:54998 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgCBNYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 08:24:38 -0500
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 022DOYUR014145;
        Mon, 2 Mar 2020 05:24:35 -0800
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net] cxgb4: fix checks for max queues to allocate
Date:   Mon,  2 Mar 2020 10:54:13 +0530
Message-Id: <1583126653-12859-1-git-send-email-vishal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware can support more than 8 queues currently limited by
netif_get_num_default_rss_queues(). So, rework and fix checks for max
number of queues to allocate. The checks should be based on how many are
actually supported by hardware, OR the number of online cpus; whichever
is lower.

Fixes: 5952dde72307 ("cxgb4: set maximal number of default RSS queues")
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>"
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 49 ++++++++++---------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 649842a8aa28..97f90edbc068 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5381,12 +5381,11 @@ static inline bool is_x_10g_port(const struct link_config *lc)
 static int cfg_queues(struct adapter *adap)
 {
 	u32 avail_qsets, avail_eth_qsets, avail_uld_qsets;
+	u32 i, n10g = 0, qidx = 0, n1g = 0;
+	u32 ncpus = num_online_cpus();
 	u32 niqflint, neq, num_ulds;
 	struct sge *s = &adap->sge;
-	u32 i, n10g = 0, qidx = 0;
-#ifndef CONFIG_CHELSIO_T4_DCB
-	int q10g = 0;
-#endif
+	u32 q10g = 0, q1g;
 
 	/* Reduce memory usage in kdump environment, disable all offload. */
 	if (is_kdump_kernel() || (is_uld(adap) && t4_uld_mem_alloc(adap))) {
@@ -5424,44 +5423,50 @@ static int cfg_queues(struct adapter *adap)
 		n10g += is_x_10g_port(&adap2pinfo(adap, i)->link_cfg);
 
 	avail_eth_qsets = min_t(u32, avail_qsets, MAX_ETH_QSETS);
+
+	/* We default to 1 queue per non-10G port and up to # of cores queues
+	 * per 10G port.
+	 */
+	if (n10g)
+		q10g = (avail_eth_qsets - (adap->params.nports - n10g)) / n10g;
+
+	n1g = adap->params.nports - n10g;
 #ifdef CONFIG_CHELSIO_T4_DCB
 	/* For Data Center Bridging support we need to be able to support up
 	 * to 8 Traffic Priorities; each of which will be assigned to its
 	 * own TX Queue in order to prevent Head-Of-Line Blocking.
 	 */
+	q1g = 8;
 	if (adap->params.nports * 8 > avail_eth_qsets) {
 		dev_err(adap->pdev_dev, "DCB avail_eth_qsets=%d < %d!\n",
 			avail_eth_qsets, adap->params.nports * 8);
 		return -ENOMEM;
 	}
 
-	for_each_port(adap, i) {
-		struct port_info *pi = adap2pinfo(adap, i);
+	if (adap->params.nports * ncpus < avail_eth_qsets)
+		q10g = max(8U, ncpus);
+	else
+		q10g = max(8U, q10g);
 
-		pi->first_qset = qidx;
-		pi->nqsets = is_kdump_kernel() ? 1 : 8;
-		qidx += pi->nqsets;
-	}
-#else /* !CONFIG_CHELSIO_T4_DCB */
-	/* We default to 1 queue per non-10G port and up to # of cores queues
-	 * per 10G port.
-	 */
-	if (n10g)
-		q10g = (avail_eth_qsets - (adap->params.nports - n10g)) / n10g;
-	if (q10g > netif_get_num_default_rss_queues())
-		q10g = netif_get_num_default_rss_queues();
+	while ((q10g * n10g) > (avail_eth_qsets - n1g * q1g))
+		q10g--;
 
-	if (is_kdump_kernel())
+#else /* !CONFIG_CHELSIO_T4_DCB */
+	q1g = 1;
+	q10g = min(q10g, ncpus);
+#endif /* !CONFIG_CHELSIO_T4_DCB */
+	if (is_kdump_kernel()) {
 		q10g = 1;
+		q1g = 1;
+	}
 
 	for_each_port(adap, i) {
 		struct port_info *pi = adap2pinfo(adap, i);
 
 		pi->first_qset = qidx;
-		pi->nqsets = is_x_10g_port(&pi->link_cfg) ? q10g : 1;
+		pi->nqsets = is_x_10g_port(&pi->link_cfg) ? q10g : q1g;
 		qidx += pi->nqsets;
 	}
-#endif /* !CONFIG_CHELSIO_T4_DCB */
 
 	s->ethqsets = qidx;
 	s->max_ethqsets = qidx;   /* MSI-X may lower it later */
@@ -5473,7 +5478,7 @@ static int cfg_queues(struct adapter *adap)
 		 * capped by the number of available cores.
 		 */
 		num_ulds = adap->num_uld + adap->num_ofld_uld;
-		i = min_t(u32, MAX_OFLD_QSETS, num_online_cpus());
+		i = min_t(u32, MAX_OFLD_QSETS, ncpus);
 		avail_uld_qsets = roundup(i, adap->params.nports);
 		if (avail_qsets < num_ulds * adap->params.nports) {
 			adap->params.offload = 0;
-- 
2.21.0

