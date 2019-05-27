Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E20C2B4FA
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 14:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfE0MYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 08:24:13 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38466 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbfE0MYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 08:24:11 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B6895200B7F;
        Mon, 27 May 2019 14:24:08 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A82B2200089;
        Mon, 27 May 2019 14:24:08 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 681052060A;
        Mon, 27 May 2019 14:24:08 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH] dpaa_eth: use only online CPU portals
Date:   Mon, 27 May 2019 15:24:05 +0300
Message-Id: <1558959845-30758-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure only the portals for the online CPUs are used.
Without this change, there are issues when someone boots with
maxcpus=n, with n < actual number of cores available as frames
either received or corresponding to the transmit confirmation
path would be offered for dequeue to the offline CPU portals,
getting lost.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     | 9 ++++-----
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d3f2408dc9e8..f38c3fa7d705 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -780,7 +780,7 @@ static void dpaa_eth_add_channel(u16 channel)
 	struct qman_portal *portal;
 	int cpu;
 
-	for_each_cpu(cpu, cpus) {
+	for_each_cpu_and(cpu, cpus, cpu_online_mask) {
 		portal = qman_get_affine_portal(cpu);
 		qman_p_static_dequeue_add(portal, pool);
 	}
@@ -896,7 +896,7 @@ static void dpaa_fq_setup(struct dpaa_priv *priv,
 	u16 channels[NR_CPUS];
 	struct dpaa_fq *fq;
 
-	for_each_cpu(cpu, affine_cpus)
+	for_each_cpu_and(cpu, affine_cpus, cpu_online_mask)
 		channels[num_portals++] = qman_affine_channel(cpu);
 
 	if (num_portals == 0)
@@ -2174,7 +2174,6 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
-
 	} else if (np->down) {
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
 	}
@@ -2448,7 +2447,7 @@ static void dpaa_eth_napi_enable(struct dpaa_priv *priv)
 	struct dpaa_percpu_priv *percpu_priv;
 	int i;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, i);
 
 		percpu_priv->np.down = 0;
@@ -2461,7 +2460,7 @@ static void dpaa_eth_napi_disable(struct dpaa_priv *priv)
 	struct dpaa_percpu_priv *percpu_priv;
 	int i;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, i);
 
 		percpu_priv->np.down = 1;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index bdee441bc3b7..7ce2e99b594d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -569,7 +569,7 @@ static int dpaa_set_coalesce(struct net_device *dev,
 	qman_dqrr_get_ithresh(portal, &prev_thresh);
 
 	/* set new values */
-	for_each_cpu(cpu, cpus) {
+	for_each_cpu_and(cpu, cpus, cpu_online_mask) {
 		portal = qman_get_affine_portal(cpu);
 		res = qman_portal_set_iperiod(portal, period);
 		if (res)
@@ -586,7 +586,7 @@ static int dpaa_set_coalesce(struct net_device *dev,
 
 revert_values:
 	/* restore previous values */
-	for_each_cpu(cpu, cpus) {
+	for_each_cpu_and(cpu, cpus, cpu_online_mask) {
 		if (!needs_revert[cpu])
 			continue;
 		portal = qman_get_affine_portal(cpu);
-- 
2.1.0

