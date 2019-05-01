Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E824510BE3
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfEARSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:18:02 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.119]:27368 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbfEARSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 13:18:01 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id A6BB449CC
        for <netdev@vger.kernel.org>; Wed,  1 May 2019 12:18:00 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id LsrohDbm84FKpLsrohe825; Wed, 01 May 2019 12:18:00 -0500
X-Authority-Reason: nr=8
Received: from [189.250.119.203] (port=40648 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hLsrn-002LT6-NG; Wed, 01 May 2019 12:17:59 -0500
Date:   Wed, 1 May 2019 12:17:59 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] iavf: use struct_size() helper
Message-ID: <20190501171759.GA3494@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.119.203
X-Source-L: No
X-Exim-ID: 1hLsrn-002LT6-NG
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.119.203]:40648
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace code of the following form:

sizeof(struct virtchnl_ether_addr_list) + (count * sizeof(struct virtchnl_ether_addr))

with:

struct_size(veal, list, count)

and so on...

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 37 ++++++++-----------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index e64751da0921..9c80bf972b90 100644
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
@@ -351,7 +351,8 @@ void iavf_map_queues(struct iavf_adapter *adapter)
 {
 	struct virtchnl_irq_map_info *vimi;
 	struct virtchnl_vector_map *vecmap;
-	int v_idx, q_vectors, len;
+	int v_idx, q_vectors;
+	size_t len;
 	struct iavf_q_vector *q_vector;
 
 	if (adapter->current_op != VIRTCHNL_OP_UNKNOWN) {
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
+	int i = 0, count = 0;
 	struct iavf_mac_filter *f;
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
 
-	len = (adapter->num_tc * sizeof(struct virtchnl_channel_info)) +
-	       sizeof(struct virtchnl_tc_info);
-
+	len = struct_size(vti, list, adapter->num_tc);
 	vti = kzalloc(len, GFP_KERNEL);
 	if (!vti)
 		return;
-- 
2.21.0

