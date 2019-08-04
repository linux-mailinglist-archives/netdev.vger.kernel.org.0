Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF0580ABF
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 13:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfHDL73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 07:59:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:50580 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbfHDL73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 07:59:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Aug 2019 04:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,345,1559545200"; 
   d="scan'208";a="178602019"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 04 Aug 2019 04:59:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/8] fm10k: remove needless assignment of err local variable
Date:   Sun,  4 Aug 2019 04:59:20 -0700
Message-Id: <20190804115926.31944-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
References: <20190804115926.31944-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The local variable err in several functions in the fm10k_netdev.c file
is initialized with a value that is never used. The err value is
immediately re-assigned in all cases where it will be checked. Remove
the unnecessary initializers.

This was detected by cppcheck and resolves the following warnings
produced by that tool:

[fm10k_netdev.c:999] -> [fm10k_netdev.c:1004]: (style) Variable 'err' is
reassigned a value before the old one has been used.

[fm10k_netdev.c:1019] -> [fm10k_netdev.c:1024]: (style) Variable 'err'
is reassigned a value before the old one has been used.

[fm10k_netdev.c:64]: (style) Variable 'err' is assigned a value that is
never used.

[fm10k_netdev.c:131]: (style) Variable 'err' is assigned a value that
is never used.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 259da075093f..4704395c0f66 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2013 - 2018 Intel Corporation. */
+/* Copyright(c) 2013 - 2019 Intel Corporation. */
 
 #include "fm10k.h"
 #include <linux/vmalloc.h>
@@ -54,7 +54,7 @@ int fm10k_setup_tx_resources(struct fm10k_ring *tx_ring)
  **/
 static int fm10k_setup_all_tx_resources(struct fm10k_intfc *interface)
 {
-	int i, err = 0;
+	int i, err;
 
 	for (i = 0; i < interface->num_tx_queues; i++) {
 		err = fm10k_setup_tx_resources(interface->tx_ring[i]);
@@ -121,7 +121,7 @@ int fm10k_setup_rx_resources(struct fm10k_ring *rx_ring)
  **/
 static int fm10k_setup_all_rx_resources(struct fm10k_intfc *interface)
 {
-	int i, err = 0;
+	int i, err;
 
 	for (i = 0; i < interface->num_rx_queues; i++) {
 		err = fm10k_setup_rx_resources(interface->rx_ring[i]);
@@ -871,7 +871,7 @@ static int fm10k_uc_vlan_unsync(struct net_device *netdev,
 	u16 glort = interface->glort;
 	u16 vid = interface->vid;
 	bool set = !!(vid / VLAN_N_VID);
-	int err = -EHOSTDOWN;
+	int err;
 
 	/* drop any leading bits on the VLAN ID */
 	vid &= VLAN_N_VID - 1;
@@ -891,7 +891,7 @@ static int fm10k_mc_vlan_unsync(struct net_device *netdev,
 	u16 glort = interface->glort;
 	u16 vid = interface->vid;
 	bool set = !!(vid / VLAN_N_VID);
-	int err = -EHOSTDOWN;
+	int err;
 
 	/* drop any leading bits on the VLAN ID */
 	vid &= VLAN_N_VID - 1;
-- 
2.21.0

