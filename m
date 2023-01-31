Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE786837CB
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjAaUqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjAaUqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:46:45 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D1F5A378;
        Tue, 31 Jan 2023 12:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197975; x=1706733975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zuXDR2goHILHeYo/VC77mXekbgvxaavn5dGa6cEHTrI=;
  b=BILYcLaMkSqvatnIRQINEUj0BOBP/ePsR+5g8C5Ical5PToAlsjtAV3X
   IDBVxVlLs0eUDi1lZuJo09ozP89hzGTZj5YcFD36SJQbLRwodd6HjBKYH
   f1zv9yF0qIvIvHH9Lvw3ZtAfXENeMcdxMSwZI+1sbKC6CT+o9PESjrjCC
   9Vb4V5w3UKuV/uHzfSdinFB21jxAzXQnCLJ0Av6U2NeJK1A1cjavaCycT
   j8jyWwv5vGvQ4PrEZg7R6c8sMSFgbwn9my6wnaVmKhQuZRKd2dbUrj9Xp
   2fWDz5w10/MZTX2fVKmxjiM2ShRNVEDXqpixmmjwzw0Ldck5EFzoqIfjA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167436"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167436"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595450"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595450"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:29 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 08/13] ice: do not call ice_finalize_xdp_rx() unnecessarily
Date:   Tue, 31 Jan 2023 21:45:01 +0100
Message-Id: <20230131204506.219292-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
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

Currently ice_finalize_xdp_rx() is called only when xdp_prog is present
on VSI, which is a good thing. However, this optimization can be
enhanced and check only if any of the XDP_TX/XDP_REDIRECT took place in
current Rx processing. Non-zero value of @xdp_xmit indicates that
xdp_prog is present on VSI. This way XDP_DROP-based workloads will not
suffer from unnecessary calls to external function.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 661a66c3d0b5..3a8639608f0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1252,7 +1252,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	/* return up to cleaned_count buffers to hardware */
 	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
 
-	if (xdp_prog)
+	if (xdp_xmit)
 		ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	rx_ring->skb = skb;
 
-- 
2.34.1

