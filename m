Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF07AEFA6
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436851AbfIJQeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:34:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:21112 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436833AbfIJQel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 12:34:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 09:34:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="184223782"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 10 Sep 2019 09:34:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/14] iavf: fix MAC address setting for VFs when filter is rejected
Date:   Tue, 10 Sep 2019 09:34:32 -0700
Message-Id: <20190910163434.2449-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
References: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

Currently iavf unconditionally applies MAC address change requests. This
brings the VF in a state where it is no longer able to pass traffic if
the PF rejects a MAC filter change for the VF.
A typical scenario for a rejected MAC filter is for an untrusted VF to
request to change the MAC address when an administratively set MAC is
present.

To keep iavf working in this scenario the MAC filter handling in iavf
needs to act on the PF reply regarding the MAC filter change. In the
case of an ack the new MAC address gets set, whereas in the case of a
nack the previous MAC address needs to stay in place.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 1 -
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 07f5541a0f01..8f310e520b06 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -804,7 +804,6 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 
 	if (f) {
 		ether_addr_copy(hw->mac.addr, addr->sa_data);
-		ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
 	}
 
 	return (f == NULL) ? -ENOMEM : 0;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index d49d58a6de80..c46770eba320 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1252,6 +1252,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		case VIRTCHNL_OP_ADD_ETH_ADDR:
 			dev_err(&adapter->pdev->dev, "Failed to add MAC filter, error %s\n",
 				iavf_stat_str(&adapter->hw, v_retval));
+			/* restore administratively set MAC address */
+			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 			break;
 		case VIRTCHNL_OP_DEL_VLAN:
 			dev_err(&adapter->pdev->dev, "Failed to delete VLAN filter, error %s\n",
@@ -1319,6 +1321,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 	}
 	switch (v_opcode) {
+	case VIRTCHNL_OP_ADD_ETH_ADDR: {
+		if (!ether_addr_equal(netdev->dev_addr, adapter->hw.mac.addr))
+			ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
+		}
+		break;
 	case VIRTCHNL_OP_GET_STATS: {
 		struct iavf_eth_stats *stats =
 			(struct iavf_eth_stats *)msg;
-- 
2.21.0

