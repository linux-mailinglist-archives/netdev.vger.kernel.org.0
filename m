Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5581D56B9
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEOQxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:53:20 -0400
Received: from inva020.nxp.com ([92.121.34.13]:38084 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEOQxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 12:53:19 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A4A151A072C;
        Fri, 15 May 2020 18:53:17 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 98D4E1A0725;
        Fri, 15 May 2020 18:53:17 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3820520328;
        Fri, 15 May 2020 18:53:17 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/7] dpaa2-eth: Trim debugfs FQ stats
Date:   Fri, 15 May 2020 19:52:55 +0300
Message-Id: <20200515165300.16125-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200515165300.16125-1-ioana.ciornei@nxp.com>
References: <20200515165300.16125-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
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
2.17.1

