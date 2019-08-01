Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCE17DAA1
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 13:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731207AbfHALxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 07:53:03 -0400
Received: from inva020.nxp.com ([92.121.34.13]:53382 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730826AbfHALw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 07:52:57 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7E3FD1A02A9;
        Thu,  1 Aug 2019 13:52:55 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 715C61A01FC;
        Thu,  1 Aug 2019 13:52:55 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0C39C205E3;
        Thu,  1 Aug 2019 13:52:55 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 2/5] enetc: Clean up makefile
Date:   Thu,  1 Aug 2019 14:52:50 +0300
Message-Id: <1564660373-4607-3-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564660373-4607-1-git-send-email-claudiu.manoil@nxp.com>
References: <1564660373-4607-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up overcomplicated makefile to make it more maintainable.
Basically, there's a set of common objects shared between
the PF and VF driver modules.  This can be implemented in a
simpler way, without conditionals, less repetition, allowing
also for easier updates in the future.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v5 - added this patch

 drivers/net/ethernet/freescale/enetc/Makefile | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index 7139e414dccf..164453a5dc1d 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -1,19 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
+
+common-objs := enetc.o enetc_cbdr.o enetc_ethtool.o
+
 obj-$(CONFIG_FSL_ENETC) += fsl-enetc.o
-fsl-enetc-$(CONFIG_FSL_ENETC) += enetc.o enetc_cbdr.o enetc_ethtool.o \
-				 enetc_mdio.o
+fsl-enetc-y := enetc_pf.o enetc_mdio.o $(common-objs)
 fsl-enetc-$(CONFIG_PCI_IOV) += enetc_msg.o
-fsl-enetc-objs := enetc_pf.o $(fsl-enetc-y)
 
 obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
-
-ifeq ($(CONFIG_FSL_ENETC)$(CONFIG_FSL_ENETC_VF), yy)
-fsl-enetc-vf-objs := enetc_vf.o
-else
-fsl-enetc-vf-$(CONFIG_FSL_ENETC_VF) += enetc.o enetc_cbdr.o \
-				       enetc_ethtool.o
-fsl-enetc-vf-objs := enetc_vf.o $(fsl-enetc-vf-y)
-endif
+fsl-enetc-vf-y := enetc_vf.o $(common-objs)
 
 obj-$(CONFIG_FSL_ENETC_PTP_CLOCK) += fsl-enetc-ptp.o
-fsl-enetc-ptp-$(CONFIG_FSL_ENETC_PTP_CLOCK) += enetc_ptp.o
+fsl-enetc-ptp-y := enetc_ptp.o
-- 
2.17.1

