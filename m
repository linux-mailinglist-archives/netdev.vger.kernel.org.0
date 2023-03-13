Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D616BCE78
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCPLht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjCPLhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:37:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9199AC97EC;
        Thu, 16 Mar 2023 04:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678966649; x=1710502649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WV2QgxuHT3p8j+KGI77slUqYCqNGD1cnP+Xz71qqoTc=;
  b=Otm2s84OErW0iKOjKSIe6M9UL+nG1SZrgGSwBn7v4PfzVofNvFRnjhWo
   qtbbsJBrhUdvcdWkgEFy0/TmUwhTnkCCTPvZlsu0lDEdOvkIM5/2Q7bSO
   nB99rIUxMk9ylnBfNrFxMh609Nc4SemvZoPbEAoqB0jmV+57R776a3N6d
   ScLm5YYTxWwFJpvQRcLNeCqZZbYIVYxJlomIG8UfblWhP+NlJHzK5wLZH
   N2OxIivH6CjCD+UAVEIH3CRqICO+IaBWlGHoByEEIxocnU6aTda4cH7wN
   Gw7gNRvmw7Rm867aoeYv4IgkQXCf+q1mYkSS/EbbKbzTDQyuyusPsqNSi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="340320628"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="340320628"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 04:37:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="1009190204"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009190204"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 04:37:22 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id A35364FEA3;
        Mon, 13 Mar 2023 21:44:02 +0000 (GMT)
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
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 3/4] xdp: recycle Page Pool backed skbs built from XDP frames
Date:   Mon, 13 Mar 2023 22:42:59 +0100
Message-Id: <20230313214300.1043280-4-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313214300.1043280-1-aleksander.lobakin@intel.com>
References: <20230313214300.1043280-1-aleksander.lobakin@intel.com>
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

