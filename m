Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E6F6A9877
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 14:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjCCNdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 08:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCCNdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 08:33:42 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72904125B9;
        Fri,  3 Mar 2023 05:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677850421; x=1709386421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WV2QgxuHT3p8j+KGI77slUqYCqNGD1cnP+Xz71qqoTc=;
  b=AKpmQbjXCc8Rar4jKAXmEZimQ+DCo29uvDBo9gbeQdFr+v9QZLeQYUvq
   P5/M4wUxJlC7uRDaTSNjXQA+7EWPZJhK32EWTspcyUGtKCty8gCQbVoHg
   LIpInb8p8zRXQsI6g85IqE7puRgRNdiyrM9bEppBDcYbzuhksT8lTnZnL
   ysafeQd0o3hpvOeur+E4z+3v9PG60a93kD1z7vrILxEw5SPVV9J+7LY4j
   i9KL74Ca4qYp0cROGa33SiNO05X1A2wZlAGI8Ch3VC8BunVFl5FgE6YId
   UDr6v2EQvmV6jjHHxdSS4d4m28U1rwsv+eq+zwL0PlJTk/LYWBNXt16h3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="421314280"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="421314280"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 05:33:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="625347429"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="625347429"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2023 05:33:36 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 6E9E4365A0;
        Fri,  3 Mar 2023 13:33:35 +0000 (GMT)
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
        Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/3] xdp: recycle Page Pool backed skbs built from XDP frames
Date:   Fri,  3 Mar 2023 14:32:31 +0100
Message-Id: <20230303133232.2546004-3-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
References: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
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

__xdp_build_skb_from_frame() state(d):

/* Until page_pool get SKB return path, release DMA here */

Page Pool got skb pages recycling in April 2021, but missed this
function.

xdp_release_frame() is relevant only for Page Pool backed frames and it
detaches the page from the corresponding page_pool in order to make it
freeable via page_frag_free(). It can instead just mark the output skb
as eligible for recycling if the frame is backed by a pp. No change for
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

