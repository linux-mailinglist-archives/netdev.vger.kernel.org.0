Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B911C61CB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgEEUPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:15:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:52032 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgEEUPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 16:15:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BCCE41A0908;
        Tue,  5 May 2020 22:15:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B04251A08F2;
        Tue,  5 May 2020 22:15:34 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 620E2205D4;
        Tue,  5 May 2020 22:15:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] soc: fsl: dpio: properly compute the consumer index
Date:   Tue,  5 May 2020 23:14:29 +0300
Message-Id: <20200505201429.24360-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mask the consumer index before using it. Without this, we would be
writing frame descriptors beyond the ring size supported by the QBMAN
block.

Fixes: 3b2abda7d28c ("soc: fsl: dpio: Replace QMAN array mode with ring mode enqueue")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

I am sending this fix through the net tree since the bug manifests
itself only on net-next and not the soc trees. This way it would be
easier to integrate this sooner rather than later.

 drivers/soc/fsl/dpio/qbman-portal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/fsl/dpio/qbman-portal.c b/drivers/soc/fsl/dpio/qbman-portal.c
index 804b8ba9bf5c..23a1377971f4 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.c
+++ b/drivers/soc/fsl/dpio/qbman-portal.c
@@ -669,6 +669,7 @@ int qbman_swp_enqueue_multiple_direct(struct qbman_swp *s,
 		eqcr_ci = s->eqcr.ci;
 		p = s->addr_cena + QBMAN_CENA_SWP_EQCR_CI;
 		s->eqcr.ci = qbman_read_register(s, QBMAN_CINH_SWP_EQCR_CI);
+		s->eqcr.ci &= full_mask;
 
 		s->eqcr.available = qm_cyc_diff(s->eqcr.pi_ring_size,
 					eqcr_ci, s->eqcr.ci);
-- 
2.17.1

