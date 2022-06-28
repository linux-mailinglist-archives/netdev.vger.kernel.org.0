Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E36455EE9C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiF1Tyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiF1Tuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:55 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6193AA;
        Tue, 28 Jun 2022 12:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445779; x=1687981779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=djZbQklvKIuE0rRB8nAV8RBPw505lomk91c2ko+Lmfs=;
  b=ijzIzJDX3lpWoiW/Gqse/gdACdmupLkPtKLcsi+u4rXDVaqxnZnC0DnE
   sxb44cZZ4KD4Xd6oiHXwef4Nd0Gf6x/KbDz8YMnCwjKTsRXDaY6K1rmzB
   oy7Df2ibie4iy4L07ifrOCG1ewePAptL1fWvgcJgwGWF9nyGHZJnA1QVq
   dpCrtLxpSTEoyXumpMJDS3DcO/EBSlnyZyYx6tPekB+lXKKUAkAJkHngo
   Rbw/HQTY+A5VeBmSFsurg8Okuq5bcuX/Fksf9gPTb2KFXGkwQmOmhYEt0
   qa7RhM1PUvQj4rLG9o32dPcRmbqTX702XmIMqhfAS7JDC0H6+GfQfNvg6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="270596039"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="270596039"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="693251043"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2022 12:49:34 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9T022013;
        Tue, 28 Jun 2022 20:49:32 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 29/52] net, xdp: try to fill skb fields when converting from an &xdp_frame
Date:   Tue, 28 Jun 2022 21:47:49 +0200
Message-Id: <20220628194812.1453059-30-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __xdp_build_skb_from_frame(), if there's a metadata in front of
the data, check if it's a generic-compatible metadata and try to
populate the HW-originated skb fields: checksum status, hash etc.
As xdp_populate_skb_meta_generic() requires the skb->mac_header
to be set and valid, call the skb_reset_mac_header() first, as
skb->data at this point is pointing (sic!) to the MAC header.
The two most obvious users are cpumap and veth.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 net/bpf/core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/bpf/core.c b/net/bpf/core.c
index 775f9648e8cf..d2d01b8e6441 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -659,8 +659,11 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 
 	skb_reserve(skb, headroom);
 	__skb_put(skb, xdpf->len);
-	if (metasize)
+	if (metasize) {
+		skb_reset_mac_header(skb);
 		skb_metadata_set(skb, metasize);
+		xdp_populate_skb_meta_generic(skb);
+	}
 
 	if (unlikely(xdp_frame_has_frags(xdpf)))
 		xdp_update_skb_shared_info(skb, nr_frags,
@@ -671,12 +674,6 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	/* Essential SKB info: protocol and skb->dev */
 	skb->protocol = eth_type_trans(skb, dev);
 
-	/* Optional SKB info, currently missing:
-	 * - HW checksum info		(skb->ip_summed)
-	 * - HW RX hash			(skb_set_hash)
-	 * - RX ring dev queue index	(skb_record_rx_queue)
-	 */
-
 	/* Until page_pool get SKB return path, release DMA here */
 	xdp_release_frame(xdpf);
 
-- 
2.36.1

