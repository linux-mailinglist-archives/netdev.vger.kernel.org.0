Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1757E488
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388992AbfHAUwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:52:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:8390 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfHAUvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 16:51:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:51:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="163734545"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2019 13:51:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/9] i40e: make visible changed vf mac on host
Date:   Thu,  1 Aug 2019 13:51:42 -0700
Message-Id: <20190801205149.4114-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

This patch makes changed VM mac address visible on host via
ip link show command. This problem is fixed by copying last
unicast mac filter to vf->default_lan_addr.addr. Without
this patch if VF MAC was not set from host side and
if you run ip link show $pf, on host side you'd always
see a zero MAC, not the real VF MAC that VF assigned to
itself.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 02b09a8ad54c..21f7ac514d1f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2629,6 +2629,9 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 			} else {
 				vf->num_mac++;
 			}
+			if (is_valid_ether_addr(al->list[i].addr))
+				ether_addr_copy(vf->default_lan_addr.addr,
+						al->list[i].addr);
 		}
 	}
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
-- 
2.21.0

