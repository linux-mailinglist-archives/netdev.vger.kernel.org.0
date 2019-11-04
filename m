Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB2EEB0E
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbfKDVXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:23:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:13954 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbfKDVXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:23:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:23:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219715313"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:23:50 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Manjunath Patil <manjunath.b.patil@oracle.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 5/7] ixgbe: protect TX timestamping from API misuse
Date:   Mon,  4 Nov 2019 13:23:46 -0800
Message-Id: <20191104212348.9625-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
References: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manjunath Patil <manjunath.b.patil@oracle.com>

HW timestamping can only be requested for a packet if the NIC is first
setup via ioctl(SIOCSHWTSTAMP). If this step was skipped, then the ixgbe
driver still allowed TX packets to request HW timestamping. In this
situation, we see 'clearing Tx Timestamp hang' noise in the log.

Fix this by checking that the NIC is configured for HW TX timestamping
before accepting a HW TX timestamping request.

Similar-to:
   commit 26bd4e2db06b ("igb: protect TX timestamping from API misuse")
   commit 0a6f2f05a2f5 ("igb: Fix a test with HWTSTAMP_TX_ON")

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index b22baea9d39b..1129ae70d5fb 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8649,7 +8649,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 	    adapter->ptp_clock) {
-		if (!test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
+		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
+		    !test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
 					   &adapter->state)) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
-- 
2.21.0

