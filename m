Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5046FAE129
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389212AbfIIWsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:48:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:40891 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbfIIWsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 18:48:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 15:48:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,487,1559545200"; 
   d="scan'208";a="175121713"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 09 Sep 2019 15:48:07 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 02/15] ixgbevf: Link lost in VM on ixgbevf when restoring from freeze or suspend
Date:   Mon,  9 Sep 2019 15:47:49 -0700
Message-Id: <20190909224802.29595-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
References: <20190909224802.29595-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

This patch fixed issue in VM which shows no link when hypervisor is
restored from low-power state. The driver is responsible for re-enabling
any features of the device that had been disabled during suspend calls,
such as IRQs and bus mastering.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 8c011d4ce7a9..75e849a64db7 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2517,6 +2517,7 @@ void ixgbevf_reinit_locked(struct ixgbevf_adapter *adapter)
 		msleep(1);
 
 	ixgbevf_down(adapter);
+	pci_set_master(adapter->pdev);
 	ixgbevf_up(adapter);
 
 	clear_bit(__IXGBEVF_RESETTING, &adapter->state);
-- 
2.21.0

