Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874D1278AF5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgIYOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:36:00 -0400
Received: from inva020.nxp.com ([92.121.34.13]:33830 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgIYOgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 10:36:00 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 672801A092B;
        Fri, 25 Sep 2020 16:35:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5A9131A0921;
        Fri, 25 Sep 2020 16:35:59 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2E0462030E;
        Fri, 25 Sep 2020 16:35:59 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: fix command version for Tx shaping
Date:   Fri, 25 Sep 2020 17:35:30 +0300
Message-Id: <20200925143530.6673-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding the support for TBF offload, the improper command version
was added even though the command format is for the V2 of
dpni_set_tx_shaping(). This does not affect the functionality of TBF
since the only change between these two versions is the addition of the
exceeded parameters which are not used in TBF. Still, fix the bug so
that we keep things in sync.

Fixes: 39344a89623d ("dpaa2-eth: add API for Tx shaping")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 1222a4ea9c71..90453dc7baef 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -12,9 +12,11 @@
 #define DPNI_VER_MAJOR				7
 #define DPNI_VER_MINOR				0
 #define DPNI_CMD_BASE_VERSION			1
+#define DPNI_CMD_2ND_VERSION			2
 #define DPNI_CMD_ID_OFFSET			4
 
 #define DPNI_CMD(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_BASE_VERSION)
+#define DPNI_CMD_V2(id)	(((id) << DPNI_CMD_ID_OFFSET) | DPNI_CMD_2ND_VERSION)
 
 #define DPNI_CMDID_OPEN					DPNI_CMD(0x801)
 #define DPNI_CMDID_CLOSE				DPNI_CMD(0x800)
@@ -46,7 +48,7 @@
 #define DPNI_CMDID_SET_MAX_FRAME_LENGTH			DPNI_CMD(0x216)
 #define DPNI_CMDID_GET_MAX_FRAME_LENGTH			DPNI_CMD(0x217)
 #define DPNI_CMDID_SET_LINK_CFG				DPNI_CMD(0x21A)
-#define DPNI_CMDID_SET_TX_SHAPING			DPNI_CMD(0x21B)
+#define DPNI_CMDID_SET_TX_SHAPING			DPNI_CMD_V2(0x21B)
 
 #define DPNI_CMDID_SET_MCAST_PROMISC			DPNI_CMD(0x220)
 #define DPNI_CMDID_GET_MCAST_PROMISC			DPNI_CMD(0x221)
-- 
2.25.1

