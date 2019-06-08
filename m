Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F1839D8C
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfFHLlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbfFHLlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:41:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0982214C6;
        Sat,  8 Jun 2019 11:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994071;
        bh=nvpqlCYyqw5KWyJSXPZb9sF0a9m5ho9uaVWVWhtfsWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOC/zUnNH9b8k6dv0WGd+/ZkXtHLyF1x/dOuhYj6qMuL8chXn+pJrOZmD2PmrYRir
         /EKUNECV6YOoiB3yJpOd1i9L9Zeg3ELqCchM8vB3eDpxJoe6v0OTcE2uiqhxiciC7u
         TayA4MyboCiF3u9z7pmr7NZC8wWtSLpII0Od8snA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 48/70] dpaa_eth: use only online CPU portals
Date:   Sat,  8 Jun 2019 07:39:27 -0400
Message-Id: <20190608113950.8033-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

[ Upstream commit 7aae703f8096d21e34ce5f34f16715587bc30902 ]

Make sure only the portals for the online CPUs are used.
Without this change, there are issues when someone boots with
maxcpus=n, with n < actual number of cores available as frames
either received or corresponding to the transmit confirmation
path would be offered for dequeue to the offline CPU portals,
getting lost.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.20.1

