Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A569A368185
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhDVNgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhDVNgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 09:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 704D26145F;
        Thu, 22 Apr 2021 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619098525;
        bh=gOyTabmowIFk54R1lQAVx74C3qCSRMhM7PYqCD3X3DY=;
        h=From:To:Cc:Subject:Date:From;
        b=MsFRvZxPEo6o3ZIQbldBpWYg/Q9p/qhguiVdKYrA/SqYvnWr06qsXpc7WwkczdRu4
         9sBb0nCScFrZ0SOPmtnzWj/zcUjZ3l2+tNOUSlXu2wPX1g0sY7NZkCa1Xo8Pr7zgAp
         CfznyywFEXOCZVcZfTxOdCRVMsPVe1SOm+oXfM85TvA1I4ZG/yUhfWVBrwEx0pSeOO
         LTCu8yiL5SqBH9JHS1RnOCJw0lhNPJAK3GhInsA4Qf6zGdb5IHW20vqLLncvVt2byQ
         B42f3hmQy7GV9o9rg0x+xVOcv7LaGkOZ8W/gngGy5IedY+lkf71YMJslRkhN/M7pgO
         kF1WCJR3SZTtA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] net: enetc: fix link error again
Date:   Thu, 22 Apr 2021 15:35:11 +0200
Message-Id: <20210422133518.1835403-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A link time bug that I had fixed before has come back now that
another sub-module was added to the enetc driver:

ERROR: modpost: "enetc_ierb_register_pf" [drivers/net/ethernet/freescale/enetc/fsl-enetc.ko] undefined!

The problem is that the enetc Makefile is not actually used for
the ierb module if that is the only built-in driver in there
and everything else is a loadable module.

Fix it by always entering the directory this time, regardless
of which symbols are configured. This should reliably fix the
problem and prevent it from coming back another time.

Fixes: 112463ddbe82 ("net: dsa: felix: fix link error")
Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/freescale/Makefile | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index 67c436400352..de7b31842233 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -24,6 +24,4 @@ obj-$(CONFIG_FSL_DPAA_ETH) += dpaa/
 
 obj-$(CONFIG_FSL_DPAA2_ETH) += dpaa2/
 
-obj-$(CONFIG_FSL_ENETC) += enetc/
-obj-$(CONFIG_FSL_ENETC_MDIO) += enetc/
-obj-$(CONFIG_FSL_ENETC_VF) += enetc/
+obj-y += enetc/
-- 
2.29.2

