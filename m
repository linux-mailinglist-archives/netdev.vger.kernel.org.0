Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9624C28D35
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbfEWWdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:19075 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388577AbfEWWdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Silence semantic parser warnings
Date:   Thu, 23 May 2019 15:33:40 -0700
Message-Id: <20190523223340.13449-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Recent versions of sparse warn about casting pointers to/from restricted
endian types in the Linux driver.  Silence those with the compiler
attribute __force macro from the Linux kernel to force casts to/from
restricted endian types.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c    | 4 ++--
 drivers/net/ethernet/intel/ice/ice_switch.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 62571d33d0d6..6d4adaed5810 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -119,7 +119,7 @@ ice_read_sr_word_aq(struct ice_hw *hw, u16 offset, u16 *data)
 
 	status = ice_read_sr_aq(hw, offset, 1, data, true);
 	if (!status)
-		*data = le16_to_cpu(*(__le16 *)data);
+		*data = le16_to_cpu(*(__force __le16 *)data);
 
 	return status;
 }
@@ -174,7 +174,7 @@ ice_read_sr_buf_aq(struct ice_hw *hw, u16 offset, u16 *words, u16 *data)
 	} while (words_read < *words);
 
 	for (i = 0; i < *words; i++)
-		data[i] = le16_to_cpu(((__le16 *)data)[i]);
+		data[i] = le16_to_cpu(((__force __le16 *)data)[i]);
 
 read_nvm_buf_aq_exit:
 	*words = words_read;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9f1f595ae7e6..5b82a7280783 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -799,7 +799,7 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		daddr = f_info->l_data.ethertype_mac.mac_addr;
 		/* fall-through */
 	case ICE_SW_LKUP_ETHERTYPE:
-		off = (__be16 *)(eth_hdr + ICE_ETH_ETHTYPE_OFFSET);
+		off = (__force __be16 *)(eth_hdr + ICE_ETH_ETHTYPE_OFFSET);
 		*off = cpu_to_be16(f_info->l_data.ethertype_mac.ethertype);
 		break;
 	case ICE_SW_LKUP_MAC_VLAN:
@@ -829,7 +829,7 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		ether_addr_copy(eth_hdr + ICE_ETH_DA_OFFSET, daddr);
 
 	if (!(vlan_id > ICE_MAX_VLAN_ID)) {
-		off = (__be16 *)(eth_hdr + ICE_ETH_VLAN_TCI_OFFSET);
+		off = (__force __be16 *)(eth_hdr + ICE_ETH_VLAN_TCI_OFFSET);
 		*off = cpu_to_be16(vlan_id);
 	}
 
-- 
2.21.0

