Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A2EA9AB7
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 08:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbfIEGeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 02:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbfIEGeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 02:34:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9C0AC05E740;
        Thu,  5 Sep 2019 06:34:36 +0000 (UTC)
Received: from p50.redhat.com (ovpn-117-224.ams2.redhat.com [10.36.117.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25D296060D;
        Thu,  5 Sep 2019 06:34:34 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, lihong.yang@intel.com,
        sassmann@kpanic.de
Subject: [PATCH] iavf: fix MAC address setting for VFs when filter is rejected
Date:   Thu,  5 Sep 2019 08:34:22 +0200
Message-Id: <20190905063422.28743-1-sassmann@kpanic.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 05 Sep 2019 06:34:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 1 -
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 39cc67cde89e..9e571a657fe7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -826,7 +826,6 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 
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

