Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14667618F09
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiKDD1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiKDD0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:13 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E88237
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:50 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h16-20020a170902f55000b001871b770a83so2615438plf.9
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r4JpR16+tuxaqATGwqLht6317RQRMwdPquwFUdUGcE0=;
        b=KgBZp53ORsmoHMHeKkqIUp3Z4DKNb8PsjQD7Fr/0TVyAW8OicfTdIvcZ71SSXcKdWW
         otvZaT5RXe5W4zLZLjdPLmN90+UKobEJzT7nfDPmOnzoE2/GJ+53KO1opPO9hIwlHttB
         n+iXsBEc0R1Wm4OXFiT4DBPQV8BI6hSy15JDRfXLZQLfz/UeBf9nm0qDADEkSi8WIpaB
         MwoXY6dbeiE6W3cY7MDtI+osaVi40U2pxlqcHjMAJlCO7etxFvowbfjWXvrxw8caT+k8
         HMbOT5npxxs5WWbwANAxoH62eS3vtez63xcB5Hp/7GXee6n6SXiUtEInNsxoPYmzcyuN
         nGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4JpR16+tuxaqATGwqLht6317RQRMwdPquwFUdUGcE0=;
        b=uUVYduDuQ6dO8bYxXKWqWjj5+8Tdj4fasy3ePDjiQxOf/4f62F2MYW2zWXhTlMmscz
         wSLnLYpv9cRzUDS+ZzHWW9wCoLUUKsTMC3VgahPCw4lCuGx1y69tBbSvGUxTHYviXTPm
         0IWsoyJ9pQmhPhjj/uZ5SRDAqwwbv6KuTC0y5+1NbXPC+0keuYlRqUosMdIxt0JU+U2w
         bGzBDKz6Y03JaL4W+l9rT6TILreDiQUoZZoOFORz6zFPm84WQgyDfDqlnc14tGLbO450
         Qs+wdNMBqQ20d+kLAlt+nsXnxJWy3bDEnOF3vFFD7Q1PIkntaNHzJJrtuw3u2PUQFrLy
         B1Rg==
X-Gm-Message-State: ACrzQf1YvZqIwwqFhjPRut/b0P3I1luxLpOocK+vxlqd3Z9MFCPXIBVK
        clkhT+xgyuQJ1ahNFjll+kuT+uc=
X-Google-Smtp-Source: AMsMyM7Dz43l6fUcBOSij/8tA745Rndz167891pfCCKpGvaPbvZP68PJFws6sSm7DbpGTaWH/ocIEZ4=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:419a:b0:56c:3696:ad5f with SMTP id
 ca26-20020a056a00419a00b0056c3696ad5fmr245016pfb.30.1667532349728; Thu, 03
 Nov 2022 20:25:49 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:27 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-10-sdf@google.com>
Subject: [RFC bpf-next v2 09/14] ice: Introduce ice_xdp_buff wrapper for xdp_buff
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes. Boilerplate to allow stuffing more data after xdp_buff.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 30 +++++++++++++----------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dbe80e5053a8..1b6afa168501 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1096,6 +1096,10 @@ ice_is_non_eop(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
 	return true;
 }
 
+struct ice_xdp_buff {
+	struct xdp_buff xdp;
+};
+
 /**
  * ice_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: Rx descriptor ring to transact packets on
@@ -1117,14 +1121,14 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
-	struct xdp_buff xdp;
+	struct ice_xdp_buff ixbuf;
 	bool failure;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
 	frame_sz = ice_rx_frame_truesize(rx_ring, 0);
 #endif
-	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
+	xdp_init_buff(&ixbuf.xdp, frame_sz, &rx_ring->xdp_rxq);
 
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	if (xdp_prog)
@@ -1178,30 +1182,30 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		rx_buf = ice_get_rx_buf(rx_ring, size, &rx_buf_pgcnt);
 
 		if (!size) {
-			xdp.data = NULL;
-			xdp.data_end = NULL;
-			xdp.data_hard_start = NULL;
-			xdp.data_meta = NULL;
+			ixbuf.xdp.data = NULL;
+			ixbuf.xdp.data_end = NULL;
+			ixbuf.xdp.data_hard_start = NULL;
+			ixbuf.xdp.data_meta = NULL;
 			goto construct_skb;
 		}
 
 		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
 			     offset;
-		xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+		xdp_prepare_buff(&ixbuf.xdp, hard_start, offset, size, true);
 #if (PAGE_SIZE > 4096)
 		/* At larger PAGE_SIZE, frame_sz depend on len size */
-		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
+		ixbuf.xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
 
 		if (!xdp_prog)
 			goto construct_skb;
 
-		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog, xdp_ring);
+		xdp_res = ice_run_xdp(rx_ring, &ixbuf.xdp, xdp_prog, xdp_ring);
 		if (!xdp_res)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
 			xdp_xmit |= xdp_res;
-			ice_rx_buf_adjust_pg_offset(rx_buf, xdp.frame_sz);
+			ice_rx_buf_adjust_pg_offset(rx_buf, ixbuf.xdp.frame_sz);
 		} else {
 			rx_buf->pagecnt_bias++;
 		}
@@ -1214,11 +1218,11 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 construct_skb:
 		if (skb) {
 			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
-		} else if (likely(xdp.data)) {
+		} else if (likely(ixbuf.xdp.data)) {
 			if (ice_ring_uses_build_skb(rx_ring))
-				skb = ice_build_skb(rx_ring, rx_buf, &xdp);
+				skb = ice_build_skb(rx_ring, rx_buf, &ixbuf.xdp);
 			else
-				skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
+				skb = ice_construct_skb(rx_ring, rx_buf, &ixbuf.xdp);
 		}
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
-- 
2.38.1.431.g37b22c650d-goog

