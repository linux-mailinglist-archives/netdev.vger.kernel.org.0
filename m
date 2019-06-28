Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AD55A730
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfF1Wt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:51493 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbfF1WtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039138"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] iavf: use struct_size() helper
Date:   Fri, 28 Jun 2019 15:49:23 -0700
Message-Id: <20190628224932.3389-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace code of the following form:

sizeof(struct virtchnl_ether_addr_list) + (count * sizeof(struct virtchnl_ether_addr))

with:

struct_size(veal, list, count)

and so on...

This code was detected with the help of Coccinelle.

Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 37 ++++++++-----------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index cb7c56c5afe6..d49d58a6de80 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -242,7 +242,8 @@ void iavf_configure_queues(struct iavf_adapter *adapter)
 	struct virtchnl_vsi_queue_config_info *vqci;
 	struct virtchnl_queue_pair_info *vqpi;
 	int pairs = adapter->num_active_queues;
-	int i, len, max_frame = IAVF_MAX_RXBUFFER;
+	int i, max_frame = IAVF_MAX_RXBUFFER;
+	size_t len;
 
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
@@ -251,8 +252,7 @@ void iavf_configure_queues(struct iavf_adapter *adapter)
 		return;
 	}
 	adapter->current_op = VIRTCHNL_OP_CONFIG_VSI_QUEUES;
-	len = sizeof(struct virtchnl_vsi_queue_config_info) +
-		       (sizeof(struct virtchnl_queue_pair_info) * pairs);
+	len = struct_size(vqci, qpair, pairs);
 	vqci = kzalloc(len, GFP_KERNEL);
 	if (!vqci)
 		return;
@@ -351,8 +351,9 @@ void iavf_map_queues(struct iavf_adapter *adapter)
 {
 	struct virtchnl_irq_map_info *vimi;
 	struct virtchnl_vector_map *vecmap;
-	int v_idx, q_vectors, len;
 	struct iavf_q_vector *q_vector;
+	int v_idx, q_vectors;
+	size_t len;
 
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
@@ -364,9 +365,7 @@ void iavf_map_queues(struct iavf_adapter *adapter)
 
 	q_vectors = adapter->num_msix_vectors - NONQ_VECS;
 
-	len = sizeof(struct virtchnl_irq_map_info) +
-	      (adapter->num_msix_vectors *
-		sizeof(struct virtchnl_vector_map));
+	len = struct_size(vimi, vecmap, adapter->num_msix_vectors);
 	vimi = kzalloc(len, GFP_KERNEL);
 	if (!vimi)
 		return;
@@ -433,9 +432,10 @@ int iavf_request_queues(struct iavf_adapter *adapter, int num)
 void iavf_add_ether_addrs(struct iavf_adapter *adapter)
 {
 	struct virtchnl_ether_addr_list *veal;
-	int len, i = 0, count = 0;
 	struct iavf_mac_filter *f;
+	int i = 0, count = 0;
 	bool more = false;
+	size_t len;
 
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
@@ -457,15 +457,13 @@ void iavf_add_ether_addrs(struct iavf_adapter *adapter)
 	}
 	adapter->current_op = VIRTCHNL_OP_ADD_ETH_ADDR;
 
-	len = sizeof(struct virtchnl_ether_addr_list) +
-	      (count * sizeof(struct virtchnl_ether_addr));
+	len = struct_size(veal, list, count);
 	if (len > IAVF_MAX_AQ_BUF_SIZE) {
 		dev_warn(&adapter->pdev->dev, "Too many add MAC changes in one request\n");
 		count = (IAVF_MAX_AQ_BUF_SIZE -
 			 sizeof(struct virtchnl_ether_addr_list)) /
 			sizeof(struct virtchnl_ether_addr);
-		len = sizeof(struct virtchnl_ether_addr_list) +
-		      (count * sizeof(struct virtchnl_ether_addr));
+		len = struct_size(veal, list, count);
 		more = true;
 	}
 
@@ -505,8 +503,9 @@ void iavf_del_ether_addrs(struct iavf_adapter *adapter)
 {
 	struct virtchnl_ether_addr_list *veal;
 	struct iavf_mac_filter *f, *ftmp;
-	int len, i = 0, count = 0;
+	int i = 0, count = 0;
 	bool more = false;
+	size_t len;
 
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
 		/* bail because we already have a command pending */
@@ -528,15 +527,13 @@ void iavf_del_ether_addrs(struct iavf_adapter *adapter)
 	}
 	adapter->current_op = VIRTCHNL_OP_DEL_ETH_ADDR;
 
-	len = sizeof(struct virtchnl_ether_addr_list) +
-	      (count * sizeof(struct virtchnl_ether_addr));
+	len = struct_size(veal, list, count);
 	if (len > IAVF_MAX_AQ_BUF_SIZE) {
 		dev_warn(&adapter->pdev->dev, "Too many delete MAC changes in one request\n");
 		count = (IAVF_MAX_AQ_BUF_SIZE -
 			 sizeof(struct virtchnl_ether_addr_list)) /
 			sizeof(struct virtchnl_ether_addr);
-		len = sizeof(struct virtchnl_ether_addr_list) +
-		      (count * sizeof(struct virtchnl_ether_addr));
+		len = struct_size(veal, list, count);
 		more = true;
 	}
 	veal = kzalloc(len, GFP_ATOMIC);
@@ -973,7 +970,7 @@ static void iavf_print_link_message(struct iavf_adapter *adapter)
 void iavf_enable_channels(struct iavf_adapter *adapter)
 {
 	struct virtchnl_tc_info *vti = NULL;
-	u16 len;
+	size_t len;
 	int i;
 
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
@@ -983,9 +980,7 @@ void iavf_enable_channels(struct iavf_adapter *adapter)
 		return;
 	}
 
-	len = ((adapter->num_tc - 1) * sizeof(struct virtchnl_channel_info)) +
-	       sizeof(struct virtchnl_tc_info);
-
+	len = struct_size(vti, list, adapter->num_tc - 1);
 	vti = kzalloc(len, GFP_KERNEL);
 	if (!vti)
 		return;
-- 
2.21.0

