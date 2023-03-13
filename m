Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E436B844B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 22:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCMV5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 17:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCMV5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 17:57:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4231C8C976;
        Mon, 13 Mar 2023 14:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678744619; x=1710280619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q3tc4GYyiOU2uNgooS6P06z+EYUuo4vPnkgkpRpdBNI=;
  b=DUclESgiuLTHQw7iy0unlFUfdi5Jh6B3/z+y9D7Yo/eP3OcbU2SSsUi7
   gFcb1Jit9A6im0JWKEicjniCWmc7RuVuTrhvcr4QepGPV7OZwv3Yfw6bK
   38YE7UZxxj4CNPG2WnEURM5MRmjQ1TcC3oMa970x2hfYSTDEn4jXJ82j3
   Kc8d+QpMKPyPAosY3evjf8X0Q39iok/5CCV2Tnd7i36VCyRi2CLe8+R26
   dIbvOrzZWI9NmRMzj7EHfTXEdmFfOk2DGqMmAWVkPrPgwgS8BwOuspbig
   klfWNZYbAlbdvh4xLgBfxVIMGGddJewQKsiEDw/JzWv3xBe2xcfBKh8Rh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364928618"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="364928618"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 14:56:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747750970"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="747750970"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 14:56:54 -0700
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
Subject: [PATCH bpf-next v3 1/4] selftests/bpf: robustify test_xdp_do_redirect with more payload magics
Date:   Mon, 13 Mar 2023 22:55:50 +0100
Message-Id: <20230313215553.1045175-2-aleksander.lobakin@intel.com>
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

Currently, the test relies on that only dropped ("xmitted") frames will
be recycled and if a frame became an skb, it will be freed later by the
stack and never come back to its page_pool.
So, it easily gets broken by trying to recycle skbs[0]:

  test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
  test_xdp_do_redirect:FAIL:pkt_count_zero unexpected pkt_count_zero:
actual 9936 != expected 2
  test_xdp_do_redirect:PASS:pkt_count_tc 0 nsec

That huge mismatch happened because after the TC ingress hook zeroes the
magic, the page gets recycled when skb is freed, not returned to the MM
layer. "Live frames" mode initializes only new pages and keeps the
recycled ones as is by design, so they appear with zeroed magic on the
Rx path again.
Expand the possible magic values from two: 0 (was "xmitted"/dropped or
did hit the TC hook) and 0x42 (hit the input XDP prog) to three: the new
one will mark frames hit the TC hook, so that they will elide both
@pkt_count_zero and @pkt_count_xdp. They can then be recycled to their
page_pool or returned to the page allocator, this won't affect the
counters anyhow. Just make sure to mark them as "input" (0x42) when they
appear on the Rx path again.
Also make an enum from those magics, so that they will be always visible
and can be changed in just one place anytime. This also eases adding any
new marks later on.

Link: https://github.com/kernel-patches/bpf/actions/runs/4386538411/jobs/7681081789
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 .../bpf/progs/test_xdp_do_redirect.c          | 36 +++++++++++++------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
index 77a123071940..cd2d4e3258b8 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -4,6 +4,19 @@
 
 #define ETH_ALEN 6
 #define HDR_SZ (sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + sizeof(struct udphdr))
+
+/**
+ * enum frame_mark - magics to distinguish page/packet paths
+ * @MARK_XMIT: page was recycled due to the frame being "xmitted" by the NIC.
+ * @MARK_IN: frame is being processed by the input XDP prog.
+ * @MARK_SKB: frame did hit the TC ingress hook as an skb.
+ */
+enum frame_mark {
+	MARK_XMIT	= 0U,
+	MARK_IN		= 0x42,
+	MARK_SKB	= 0x45,
+};
+
 const volatile int ifindex_out;
 const volatile int ifindex_in;
 const volatile __u8 expect_dst[ETH_ALEN];
@@ -34,10 +47,10 @@ int xdp_redirect(struct xdp_md *xdp)
 	if (*metadata != 0x42)
 		return XDP_ABORTED;
 
-	if (*payload == 0) {
-		*payload = 0x42;
+	if (*payload == MARK_XMIT)
 		pkts_seen_zero++;
-	}
+
+	*payload = MARK_IN;
 
 	if (bpf_xdp_adjust_meta(xdp, 4))
 		return XDP_ABORTED;
@@ -51,7 +64,7 @@ int xdp_redirect(struct xdp_md *xdp)
 	return ret;
 }
 
-static bool check_pkt(void *data, void *data_end)
+static bool check_pkt(void *data, void *data_end, const __u32 mark)
 {
 	struct ipv6hdr *iph = data + sizeof(struct ethhdr);
 	__u8 *payload = data + HDR_SZ;
@@ -59,13 +72,13 @@ static bool check_pkt(void *data, void *data_end)
 	if (payload + 1 > data_end)
 		return false;
 
-	if (iph->nexthdr != IPPROTO_UDP || *payload != 0x42)
+	if (iph->nexthdr != IPPROTO_UDP || *payload != MARK_IN)
 		return false;
 
 	/* reset the payload so the same packet doesn't get counted twice when
 	 * it cycles back through the kernel path and out the dst veth
 	 */
-	*payload = 0;
+	*payload = mark;
 	return true;
 }
 
@@ -75,11 +88,11 @@ int xdp_count_pkts(struct xdp_md *xdp)
 	void *data = (void *)(long)xdp->data;
 	void *data_end = (void *)(long)xdp->data_end;
 
-	if (check_pkt(data, data_end))
+	if (check_pkt(data, data_end, MARK_XMIT))
 		pkts_seen_xdp++;
 
-	/* Return XDP_DROP to make sure the data page is recycled, like when it
-	 * exits a physical NIC. Recycled pages will be counted in the
+	/* Return %XDP_DROP to recycle the data page with %MARK_XMIT, like
+	 * it exited a physical NIC. Those pages will be counted in the
 	 * pkts_seen_zero counter above.
 	 */
 	return XDP_DROP;
@@ -91,9 +104,12 @@ int tc_count_pkts(struct __sk_buff *skb)
 	void *data = (void *)(long)skb->data;
 	void *data_end = (void *)(long)skb->data_end;
 
-	if (check_pkt(data, data_end))
+	if (check_pkt(data, data_end, MARK_SKB))
 		pkts_seen_tc++;
 
+	/* Will be either recycled or freed, %MARK_SKB makes sure it won't
+	 * hit any of the counters above.
+	 */
 	return 0;
 }
 
-- 
2.39.2

