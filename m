Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856BCE95CE
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfJ3Egk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:36:40 -0400
Received: from mga17.intel.com ([192.55.52.151]:15159 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfJ3Egg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 00:36:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 21:36:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="211979448"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 29 Oct 2019 21:36:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        kbuild test robot <lpk@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 8/8] e1000e: Fix compiler warning when CONFIG_PM_SLEEP is not set
Date:   Tue, 29 Oct 2019 21:36:33 -0700
Message-Id: <20191030043633.26249-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030043633.26249-1-jeffrey.t.kirsher@intel.com>
References: <20191030043633.26249-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

When CONFIG_PM_SLEEP is not defined compiler complain as follow:
CC [M]  drivers/net/ethernet/intel/e1000e/netdev.o
drivers/net/ethernet/intel/e1000e/netdev.c:6302:12: warning: ‘e1000e_s0ix_entry_flow’ defined but not used [-Wunused-function]
static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
drivers/net/ethernet/intel/e1000e/netdev.c:6411:12: warning: ‘e1000e_s0ix_exit_flow’ defined but not used [-Wunused-function]
static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
LD [M]  drivers/net/ethernet/intel/e1000e/e1000e.o

Add wrap to fix these warnings.

Reported-by: kbuild test robot <lpk@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 20965b5d9780..032b88619054 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6297,6 +6297,7 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 	pm_runtime_put_sync(netdev->dev.parent);
 }
 
+#ifdef CONFIG_PM_SLEEP
 /* S0ix implementation */
 static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 {
@@ -6464,6 +6465,7 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
 	ew32(CTRL_EXT, mac_data);
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static int e1000e_pm_freeze(struct device *dev)
 {
-- 
2.21.0

