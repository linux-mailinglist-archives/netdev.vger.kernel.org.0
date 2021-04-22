Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0293685E6
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbhDVRaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:60039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236058AbhDVRaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:11 -0400
IronPort-SDR: H6rlNYOpcfR6S1lmCnRoy2E0hKbRRNdqK5KWcfaYVfd9ARkWX9w7QLX0Fz87K0ej8LVtsrMPaD
 pq968JwUJ0HQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991480"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991480"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:35 -0700
IronPort-SDR: dYO2ufIPwYwPNr58RsyhkVv2fBAq+hzOLSOmAZIU1zRipYYj9CUTE+QDAaQYXp88HSjaFHRZY/
 tp2W1kRSwYuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286270"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 04/12] iavf: add support for UDP Segmentation Offload
Date:   Thu, 22 Apr 2021 10:31:22 -0700
Message-Id: <20210422173130.1143082-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Add code to support UDP segmentation offload (USO) for
hardware that supports it.

Suggested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     |  2 ++
 drivers/net/ethernet/intel/iavf/iavf_txrx.c     | 15 +++++++++++----
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c |  1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a3268c894d85..6cd6b9dfe5d4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3542,6 +3542,8 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	/* Enable cloud filter if ADQ is supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ)
 		hw_features |= NETIF_F_HW_TC;
+	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
+		hw_features |= NETIF_F_GSO_UDP_L4;
 
 	netdev->hw_features |= hw_features;
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index d6cba53a3a21..3525eab8e9f9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1905,13 +1905,20 @@ static int iavf_tso(struct iavf_tx_buffer *first, u8 *hdr_len,
 
 	/* determine offset of inner transport header */
 	l4_offset = l4.hdr - skb->data;
-
 	/* remove payload length from inner checksum */
 	paylen = skb->len - l4_offset;
-	csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
 
-	/* compute length of segmentation header */
-	*hdr_len = (l4.tcp->doff * 4) + l4_offset;
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+		csum_replace_by_diff(&l4.udp->check,
+				     (__force __wsum)htonl(paylen));
+		/* compute length of UDP segmentation header */
+		*hdr_len = (u8)sizeof(l4.udp) + l4_offset;
+	} else {
+		csum_replace_by_diff(&l4.tcp->check,
+				     (__force __wsum)htonl(paylen));
+		/* compute length of TCP segmentation header */
+		*hdr_len = (u8)((l4.tcp->doff * 4) + l4_offset);
+	}
 
 	/* pull values out of skb_shinfo */
 	gso_size = skb_shinfo(skb)->gso_size;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 3069092468b2..9aaade0aae4c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -140,6 +140,7 @@ int iavf_send_vf_config_msg(struct iavf_adapter *adapter)
 	       VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM |
 	       VIRTCHNL_VF_OFFLOAD_REQ_QUEUES |
 	       VIRTCHNL_VF_OFFLOAD_ADQ |
+	       VIRTCHNL_VF_OFFLOAD_USO |
 	       VIRTCHNL_VF_OFFLOAD_FDIR_PF |
 	       VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
-- 
2.26.2

