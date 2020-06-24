Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE56520722C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390658AbgFXLey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:34:54 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36690 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388939AbgFXLew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 07:34:52 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5DD112010B8;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 516412001A8;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 130B32047A;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/5] dpaa2-eth: trim debugfs FQ stats
Date:   Wed, 24 Jun 2020 14:34:17 +0300
Message-Id: <20200624113421.17360-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624113421.17360-1-ioana.ciornei@nxp.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

With the addition of multiple traffic classes support, the number
of available frame queues grew significantly, overly inflating the
debugfs FQ statistics entry. Update it to only show the queues
which are actually in use (i.e. have a non-zero frame counter).

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index c453a23045c1..2880ca02d7e7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -90,6 +90,10 @@ static int dpaa2_dbg_fqs_show(struct seq_file *file, void *offset)
 		if (err)
 			fcnt = 0;
 
+		/* Skip FQs with no traffic */
+		if (!fq->stats.frames && !fcnt)
+			continue;
+
 		seq_printf(file, "%5d%16d%16d%16s%16llu%16u\n",
 			   fq->fqid,
 			   fq->target_cpu,
-- 
2.25.1

