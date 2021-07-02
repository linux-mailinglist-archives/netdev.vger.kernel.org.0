Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B39D3B9BAB
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 06:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhGBEyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 00:54:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49545 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbhGBEyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 00:54:19 -0400
Received: from [222.129.38.159] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <aaron.ma@canonical.com>)
        id 1lzB9S-0005Ri-QI; Fri, 02 Jul 2021 04:51:43 +0000
From:   Aaron Ma <aaron.ma@canonical.com>
To:     jesse.brandeburg@intel.com, aaron.ma@canonical.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] igc: wait for the MAC copy when enabled MAC passthrough
Date:   Fri,  2 Jul 2021 12:51:20 +0800
Message-Id: <20210702045120.22855-2-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210702045120.22855-1-aaron.ma@canonical.com>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Such as dock hot plug event when runtime, for hardware implementation,
the MAC copy takes less than one second when BIOS enabled MAC passthrough.
After test on Lenovo TBT4 dock, 600ms is enough to update the
MAC address.
Otherwise ethernet fails to work.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 606b72cb6193..c8bc5f089255 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5468,6 +5468,9 @@ static int igc_probe(struct pci_dev *pdev,
 	memcpy(&hw->mac.ops, ei->mac_ops, sizeof(hw->mac.ops));
 	memcpy(&hw->phy.ops, ei->phy_ops, sizeof(hw->phy.ops));
 
+	if (pci_is_thunderbolt_attached(pdev))
+		msleep(600);
+
 	/* Initialize skew-specific constants */
 	err = ei->get_invariants(hw);
 	if (err)
-- 
2.30.2

