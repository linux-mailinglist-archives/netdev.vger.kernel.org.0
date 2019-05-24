Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B018029AC5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389870AbfEXPPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:15:20 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57776 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389350AbfEXPPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 11:15:20 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B164A1A04AE;
        Fri, 24 May 2019 17:15:18 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A27FD1A04AD;
        Fri, 24 May 2019 17:15:18 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4BCF7205EF;
        Fri, 24 May 2019 17:15:18 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net 1/3] dpaa2-eth: Fix potential spectre issue
Date:   Fri, 24 May 2019 18:15:15 +0300
Message-Id: <1558710917-4555-2-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch reports a potential spectre vulnerability in the dpaa2-eth
driver, where the value of rxnfc->fs.location (which is provided
from user-space) is used as index in an array.

Add a call to array_index_nospec() to sanitize the access.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 76bd8d2..7b182f4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/net_tstamp.h>
+#include <linux/nospec.h>
 
 #include "dpni.h"	/* DPNI_LINK_OPT_* */
 #include "dpaa2-eth.h"
@@ -648,6 +649,8 @@ static int dpaa2_eth_get_rxnfc(struct net_device *net_dev,
 	case ETHTOOL_GRXCLSRULE:
 		if (rxnfc->fs.location >= max_rules)
 			return -EINVAL;
+		rxnfc->fs.location = array_index_nospec(rxnfc->fs.location,
+							max_rules);
 		if (!priv->cls_rules[rxnfc->fs.location].in_use)
 			return -EINVAL;
 		rxnfc->fs = priv->cls_rules[rxnfc->fs.location].fs;
-- 
2.7.4

