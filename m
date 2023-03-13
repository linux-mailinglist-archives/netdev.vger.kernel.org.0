Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47CE6B8452
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 22:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCMV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 17:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCMV5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 17:57:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F344B8F530;
        Mon, 13 Mar 2023 14:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678744627; x=1710280627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WV2QgxuHT3p8j+KGI77slUqYCqNGD1cnP+Xz71qqoTc=;
  b=MyGi+7i6tdmk2MU1rQoilOIcb3i+ftu+R7cev1k6nvB9N8j/eiX/7ikb
   TiPcIU7Ig5DuB++0TdD9NV3UN6ccz22Wb8klZRgFHW6YcEGV+OmLLLH40
   2l785/t4u6TOCdwYywj1pqhFuvMVovd5kBqEcTgw01qRx0ZiHsJtco/9M
   ZF4PnY9aMGL/ezotL0/DNKOrTlMThy0MXAQZEpJy6cOuYW9sB6r/H6/VE
   MdtqaIoF0PI9XBylFd5uazqtjXDQL0nWu1VhZxC2fGqQ/YCd8YLoj5jVg
   vmszJNbLngkz84v1cFJJgQGRiSv7HHkxKyN0Ku2eY7oy7cGAS+L3DmFsj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364928655"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="364928655"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 14:57:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747750981"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="747750981"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 14:57:03 -0700
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
Date:   Mon, 13 Mar 2023 22:55:52 +0100
Message-Id: <20230313215553.1045175-4-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
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

