Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BDF6A7073
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjCAQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCAQES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:04:18 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9167392AD;
        Wed,  1 Mar 2023 08:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677686658; x=1709222658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7yX/2MWa8HFobhzC8fLR29+A0vGAbF/zFcR/r79lMZo=;
  b=Pvdlb2x9hASV9XkK5grxk7vJnZa2qqmsyeh9Rtpk09dQaPTwj+yrMuqj
   pdX/YY3ouFj3nCmsGkD3HKy8Q81gjVBfr83gFpmpw/Dfmu8CtJl/0dvhZ
   pCro3ne5OzCJowbbflEP86HEQkaqEdFs/EFb5X83oQlDiE8pGjon6+TrH
   /ymHZFP8nd8HBDJrxcsN+NyNSN7pdRORpGQVjJ/HwEpglneKvKIkXghmz
   Aw6SxDVX0QJLY0jNqTyfEWBbjdtYolRWJLv/V6EsqXoLU+nsX54iDcyEK
   pus2SpGyX1giEC+8mf6gdHWAdoF3SOsm7N3CSBaOMnlK/h5Tb0iQEkc+0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="322709885"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="322709885"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:04:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="848686060"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="848686060"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga005.jf.intel.com with ESMTP; 01 Mar 2023 08:04:12 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 0844B36C08;
        Wed,  1 Mar 2023 16:04:11 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built from XDP frames
Date:   Wed,  1 Mar 2023 17:03:14 +0100
Message-Id: <20230301160315.1022488-2-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__xdp_build_skb_from_frame() state(d):

/* Until page_pool get SKB return path, release DMA here */

Page Pool got skb pages recycling in April 2021, but missed this
function.

xdp_release_frame() is relevant only for Page Pool backed frames and it
detaches the page from the corresponding Pool in order to make it
freeable via page_frag_free(). It can instead just mark the output skb
as eligible for recycling if the frame is backed by a PP. No change for
other memory model types (the same condition check as before).
cpumap redirect and veth on Page Pool drivers now become zero-alloc (or
almost).

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 net/core/xdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 8c92fc553317..a2237cfca8e9 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -658,8 +658,8 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	 * - RX ring dev queue index	(skb_record_rx_queue)
 	 */
 
-	/* Until page_pool get SKB return path, release DMA here */
-	xdp_release_frame(xdpf);
+	if (xdpf->mem.type == MEM_TYPE_PAGE_POOL)
+		skb_mark_for_recycle(skb);
 
 	/* Allow SKB to reuse area used by xdp_frame */
 	xdp_scrub_frame(xdpf);
-- 
2.39.2

