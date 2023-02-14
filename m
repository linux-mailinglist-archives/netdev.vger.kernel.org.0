Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3316963BE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjBNMo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjBNMot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:44:49 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC45D227AC;
        Tue, 14 Feb 2023 04:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676378687; x=1707914687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4pFUgogt9bqox2rhMdnsKjEOVqWd0AEf78XAdhv5ZaE=;
  b=mJ8IY9A1ZrxaZ25CTvZCE6t8zc8ofjF4phspaFfF6UmlRn7W8eSec1yn
   5KatjOqoY1bfq229ff9NMrJH7y8RFuF99DEBYO0i9Fy0jdk/38Bi/rhPT
   HqoaCipx3xe1MrR5C6BFFAeT2gokMVkKu9Xz6ZGXVGsmvhaMMMJT2CwN0
   IfMveryEhb3Mxuq14sXLjm9k648jpmzpEqyMiQrRdKXAVEOwpCsUxcRn2
   pECxUyOXcoK05eDrt5MoBPPpXCPMLT6k8iDOmpaIkxU6GUHbiGKyQY3Qq
   bMy3pbnYlPvUk+uH4MFSyg0RBs8U4FTUSLJnv+9ajVRTmQAYGr0EM/sHZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="417371201"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="417371201"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 04:44:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="778308612"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="778308612"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 04:44:46 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH intel-next v3 5/8] i40e: use frame_sz instead of recalculating truesize for building skb
Date:   Tue, 14 Feb 2023 18:00:15 +0530
Message-Id: <20230214123018.54386-6-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214123018.54386-1-tirthendu.sarkar@intel.com>
References: <20230214123018.54386-1-tirthendu.sarkar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In skb path truesize is calculated while building skb. This is now
avoided and xdp->frame_is used instead for both i40e_build_skb() and
i40e_construct_skb().

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 019abd7273a2..01340f620d96 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2113,11 +2113,6 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 					  struct xdp_buff *xdp)
 {
 	unsigned int size = xdp->data_end - xdp->data;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(size);
-#endif
 	unsigned int headlen;
 	struct sk_buff *skb;
 
@@ -2162,10 +2157,10 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	if (size) {
 		skb_add_rx_frag(skb, 0, rx_buffer->page,
 				rx_buffer->page_offset + headlen,
-				size, truesize);
+				size, xdp->frame_sz);
 
 		/* buffer is used by skb, update page_offset */
-		i40e_rx_buffer_flip(rx_buffer, truesize);
+		i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
 	} else {
 		/* buffer is unused, reset bias back to rx_buffer */
 		rx_buffer->pagecnt_bias++;
@@ -2188,13 +2183,6 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 				      struct xdp_buff *xdp)
 {
 	unsigned int metasize = xdp->data - xdp->data_meta;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-				SKB_DATA_ALIGN(xdp->data_end -
-					       xdp->data_hard_start);
-#endif
 	struct sk_buff *skb;
 
 	/* Prefetch first cache line of first page. If xdp->data_meta
@@ -2205,7 +2193,7 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 	net_prefetch(xdp->data_meta);
 
 	/* build an skb around the page buffer */
-	skb = napi_build_skb(xdp->data_hard_start, truesize);
+	skb = napi_build_skb(xdp->data_hard_start, xdp->frame_sz);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -2216,7 +2204,7 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 		skb_metadata_set(skb, metasize);
 
 	/* buffer is used by skb, update page_offset */
-	i40e_rx_buffer_flip(rx_buffer, truesize);
+	i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
 
 	return skb;
 }
-- 
2.34.1

