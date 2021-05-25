Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE178390CBA
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhEYXGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230375AbhEYXGq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:06:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63C7361284;
        Tue, 25 May 2021 23:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983916;
        bh=b1HbG9gO/n2Kw+qzIDWeTSUI5+koRLkUNAVzcuTYL5U=;
        h=Date:From:To:Cc:Subject:From;
        b=Kn7LShhbWAVTlmkXyoU0yBVi7DfQxowhMUXT4K+fnxG4VIVFaP6Y6gmyOuprBzdpl
         RXL3gcFYKOxpF5zcvk6hfwDNYgdFZkANHbdLpYYKLMyLGMSKG+44zAJ3hvfdXqxPhH
         5LyY/5SPRk8iwfE/e5Lv16zU1eOjs+raoWj0l+NN4Nrz1zcRxvtmebykdStxPPm58+
         /ywvXD7XXXdVzeb9lmByy2itxQiz6fqlLQ2+olkp84SgypjmqgVnHT798GLZsBg/o3
         xPV+l86+0yrRm0Vd5+xbhGsG1Qq0iEutk52gg/Ih+aVmWsPvR2EzrQopLwuhbhE+fD
         3WmeQo4QfY5LQ==
Date:   Tue, 25 May 2021 18:06:12 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] iavf: Replace one-element array in struct
 virtchnl_vlan_filter_list
Message-ID: <20210525230612.GA175718@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in struct
virtchnl_vlan_filter_list instead of one-element array, and use the
struct_size() and flex_array_size() helpers.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 12 ++++--------
 include/linux/avf/virtchnl.h                    |  7 ++++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index b2392af4e048..167955094170 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -573,15 +573,13 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 	}
 	adapter->current_op = VIRTCHNL_OP_ADD_VLAN;
 
-	len = sizeof(struct virtchnl_vlan_filter_list) +
-	      (count * sizeof(u16));
+	len = struct_size(vvfl, vlan_id, count);
 	if (len > IAVF_MAX_AQ_BUF_SIZE) {
 		dev_warn(&adapter->pdev->dev, "Too many add VLAN changes in one request\n");
 		count = (IAVF_MAX_AQ_BUF_SIZE -
 			 sizeof(struct virtchnl_vlan_filter_list)) /
 			sizeof(u16);
-		len = sizeof(struct virtchnl_vlan_filter_list) +
-		      (count * sizeof(u16));
+		len = struct_size(vvfl, vlan_id, count);
 		more = true;
 	}
 	vvfl = kzalloc(len, GFP_ATOMIC);
@@ -643,15 +641,13 @@ void iavf_del_vlans(struct iavf_adapter *adapter)
 	}
 	adapter->current_op = VIRTCHNL_OP_DEL_VLAN;
 
-	len = sizeof(struct virtchnl_vlan_filter_list) +
-	      (count * sizeof(u16));
+	len = struct_size(vvfl, vlan_id, count);
 	if (len > IAVF_MAX_AQ_BUF_SIZE) {
 		dev_warn(&adapter->pdev->dev, "Too many delete VLAN changes in one request\n");
 		count = (IAVF_MAX_AQ_BUF_SIZE -
 			 sizeof(struct virtchnl_vlan_filter_list)) /
 			sizeof(u16);
-		len = sizeof(struct virtchnl_vlan_filter_list) +
-		      (count * sizeof(u16));
+		len = struct_size(vvfl, vlan_id, count);
 		more = true;
 	}
 	vvfl = kzalloc(len, GFP_ATOMIC);
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 15b982911321..9b9d79c270b1 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -444,10 +444,10 @@ VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_ether_addr_list);
 struct virtchnl_vlan_filter_list {
 	u16 vsi_id;
 	u16 num_elements;
-	u16 vlan_id[1];
+	u16 vlan_id[];
 };
 
-VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_vlan_filter_list);
+VIRTCHNL_CHECK_STRUCT_LEN(4, virtchnl_vlan_filter_list);
 
 /* VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE
  * VF sends VSI id and flags.
@@ -1037,7 +1037,8 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 		if (msglen >= valid_len) {
 			struct virtchnl_vlan_filter_list *vfl =
 			    (struct virtchnl_vlan_filter_list *)msg;
-			valid_len += vfl->num_elements * sizeof(u16);
+			valid_len += flex_array_size(vfl, vlan_id,
+						     vfl->num_elements);
 			if (vfl->num_elements == 0)
 				err_msg_format = true;
 		}
-- 
2.27.0

