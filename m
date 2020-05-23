Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA71DF437
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgEWCvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387544AbgEWCvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:14 -0400
IronPort-SDR: 3NBTSpWkWt0Qq5p3BL30taOupdrx0Mep2O9Dy9xw+fGCGSUb64IvQ0dwSJKPFb+yaTeu0+YeH3
 4b9tx1Qwm50Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:12 -0700
IronPort-SDR: l+tYJj6SFL/bm/vPRggU0Qphs9Ga7htawdqszoeo2rChuJnYIZ9vArkJE9NqAbdBevvKUMJtKM
 Q6JlsWiLxz4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291076"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/17] igc: Fix NFC rules with multicast addresses
Date:   Fri, 22 May 2020 19:50:57 -0700
Message-Id: <20200523025109.3313635-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Multicast MAC addresses are valid address for NFC rules but
igc_add_mac_filter() is currently rejecting them. In fact, the I225
controller doesn't impose any constraint on the address value so this
patch gets rid of the address validation check in MAC filter APIs.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f48d6127a220..acb8dfdf275f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2249,9 +2249,6 @@ int igc_add_mac_filter(struct igc_adapter *adapter,
 	struct net_device *dev = adapter->netdev;
 	int index;
 
-	if (!is_valid_ether_addr(addr))
-		return -EINVAL;
-
 	index = igc_find_mac_filter(adapter, type, addr);
 	if (index >= 0)
 		goto update_filter;
@@ -2283,9 +2280,6 @@ int igc_del_mac_filter(struct igc_adapter *adapter,
 	struct net_device *dev = adapter->netdev;
 	int index;
 
-	if (!is_valid_ether_addr(addr))
-		return -EINVAL;
-
 	index = igc_find_mac_filter(adapter, type, addr);
 	if (index < 0)
 		return -ENOENT;
-- 
2.26.2

