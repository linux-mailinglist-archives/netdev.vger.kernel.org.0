Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122ED1AE505
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgDQSm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:42:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:31356 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbgDQSm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:57 -0400
IronPort-SDR: LEjf07CuYmMqyxK7LiFd6wksh1K8lkWnpgPlAl8Ws8vbrKjmjTAdH5PzZ71pCVuAeuK7gc3oLb
 UyJ+TRnud16Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:53 -0700
IronPort-SDR: W1bKCYokqAo7vvC8vGbg9M1g6XmyTb4lRzHyS/KM7aRGYCZKf/umyvejB+GyHCRXpbPilc9S3c
 nHW0fG60erCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294396"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/14] igc: Fix default MAC address filter override
Date:   Fri, 17 Apr 2020 11:42:51 -0700
Message-Id: <20200417184251.1962762-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch fixes a bug when the user adds the first MAC address filter
via ethtool NFC mechanism.

When the first MAC address filter is added, it overwrites the default
MAC address filter configured at RAL[0] and RAH[0]. As consequence,
frames addressed to the interface MAC address are not sent to host
anymore.

This patch fixes the bug by calling igc_set_default_mac_filter() during
adapter init so the position 0 of adapter->mac_table[] is assigned to
the default MAC address.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6acb85842d0a..9d1792e80e2e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2354,7 +2354,9 @@ static void igc_configure(struct igc_adapter *adapter)
 	igc_setup_mrqc(adapter);
 	igc_setup_rctl(adapter);
 
+	igc_set_default_mac_filter(adapter);
 	igc_nfc_filter_restore(adapter);
+
 	igc_configure_tx(adapter);
 	igc_configure_rx(adapter);
 
-- 
2.25.2

