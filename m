Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B676F27FED
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfEWOiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:38:25 -0400
Received: from inva020.nxp.com ([92.121.34.13]:55546 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730860AbfEWOiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 10:38:24 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B627B1A0091;
        Thu, 23 May 2019 16:38:22 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A96501A0072;
        Thu, 23 May 2019 16:38:22 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5D62F205D5;
        Thu, 23 May 2019 16:38:22 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next] Revert "dpaa2-eth: configure the cache stashing amount on a queue"
Date:   Thu, 23 May 2019 17:38:22 +0300
Message-Id: <1558622302-6931-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit f8b995853444aba9c16c1ccdccdd397527fde96d.

The reverted change instructed the QMan hardware block to fetch
RX frame annotation and beginning of frame data to cache before
the core would read them.

It turns out that in rare cases, it's possible that a QMan
stashing transaction is delayed long enough such that, by the time
it gets executed, the frame in question had already been dequeued
by the core and software processing began on it. If the core
manages to unmap the frame buffer _before_ the stashing transaction
is executed, an SMMU exception will be raised.

Unfortunately there is no easy way to work around this while keeping
the performance advantages brought by QMan stashing, so disable
it altogether.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 63b1ecc1..28a6faa 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2479,14 +2479,9 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 	queue.destination.type = DPNI_DEST_DPCON;
 	queue.destination.priority = 1;
 	queue.user_context = (u64)(uintptr_t)fq;
-	queue.flc.stash_control = 1;
-	queue.flc.value &= 0xFFFFFFFFFFFFFFC0;
-	/* 01 01 00 - data, annotation, flow context */
-	queue.flc.value |= 0x14;
 	err = dpni_set_queue(priv->mc_io, 0, priv->mc_token,
 			     DPNI_QUEUE_RX, 0, fq->flowid,
-			     DPNI_QUEUE_OPT_USER_CTX | DPNI_QUEUE_OPT_DEST |
-			     DPNI_QUEUE_OPT_FLC,
+			     DPNI_QUEUE_OPT_USER_CTX | DPNI_QUEUE_OPT_DEST,
 			     &queue);
 	if (err) {
 		dev_err(dev, "dpni_set_queue(RX) failed\n");
-- 
2.7.4

