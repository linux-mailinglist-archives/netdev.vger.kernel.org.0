Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3693C215A13
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgGFO4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:56:07 -0400
Received: from inva021.nxp.com ([92.121.34.21]:32962 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgGFO4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 10:56:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0AB3E2006C3;
        Mon,  6 Jul 2020 16:56:06 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F31AA2006B1;
        Mon,  6 Jul 2020 16:56:05 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B4399203C3;
        Mon,  6 Jul 2020 16:56:05 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] dpaa2-eth: fix draining of S/G cache
Date:   Mon,  6 Jul 2020 17:55:54 +0300
Message-Id: <20200706145554.29439-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On link down, the draining of the S/G cache should be done on all
_possible_ CPUs not just the ones that are online in that moment.
Fix this by changing the iterator.

Fixes: d70446ee1f40 ("dpaa2-eth: send a scatter-gather FD instead of realloc-ing")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index bc1f1e0117b6..d0cc1dc49aaa 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1261,7 +1261,7 @@ static void dpaa2_eth_sgt_cache_drain(struct dpaa2_eth_priv *priv)
 	u16 count;
 	int k, i;
 
-	for_each_online_cpu(k) {
+	for_each_possible_cpu(k) {
 		sgt_cache = per_cpu_ptr(priv->sgt_cache, k);
 		count = sgt_cache->count;
 
-- 
2.25.1

