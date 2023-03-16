Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD046BD78B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjCPRxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjCPRw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:52:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DAC1EFC1;
        Thu, 16 Mar 2023 10:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678989171; x=1710525171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QRih3njZUr377Ux29J6E8DuVOV2jEWZRLenNqTC3HQw=;
  b=FNIx2AaUemVDBoHyq/v0YRfT15JHboRqBlN9pCf3Msmv7k2dsZeQ1MIC
   icHyBHo/V7/sY3LqCg7H/DAkjSnCp3hwdxn3kNkE/PTh2n55gFJtQ3WzW
   Rhp5Jyww7AJbCKc95r3Y6AgEcGzwNHR4F7Y7DVZBa5IWblO7XHfBnnMMh
   rDBrEDGRsU0trqPgRQ4JeL8BTbKBuXhXTa4H54nIqyJu2SGMUM+ewcMvc
   8mNZ0BdpmxfZiBvoUrOftPtIxrwipqz42z5vv3N0fs/zFeEboMxU5gzgN
   YF4fT8UcDVlmi7T4wSNpTe7m5Y6gYFys3Pf+zVd+jkcLLKn8054zmvrsy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317721473"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317721473"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 10:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="823351351"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823351351"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 10:52:09 -0700
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/2] selftests/bpf: fix "metadata marker" getting overwritten by the netstack
Date:   Thu, 16 Mar 2023 18:50:51 +0100
Message-Id: <20230316175051.922550-3-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316175051.922550-1-aleksander.lobakin@intel.com>
References: <20230316175051.922550-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei noticed xdp_do_redirect test on BPF CI started failing on
BE systems after skb PP recycling was enabled:

test_xdp_do_redirect:PASS:prog_run 0 nsec
test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc: actual
220 != expected 9998
test_max_pkt_size:PASS:prog_run_max_size 0 nsec
test_max_pkt_size:PASS:prog_run_too_big 0 nsec
close_netns:PASS:setns 0 nsec
 #289 xdp_do_redirect:FAIL
Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED

and it doesn't happen on LE systems.
Ilya then hunted it down to:

 #0  0x0000000000aaeee6 in neigh_hh_output (hh=0x83258df0,
skb=0x88142200) at linux/include/net/neighbour.h:503
 #1  0x0000000000ab2cda in neigh_output (skip_cache=false,
skb=0x88142200, n=<optimized out>) at linux/include/net/neighbour.h:544
 #2  ip6_finish_output2 (net=net@entry=0x88edba00, sk=sk@entry=0x0,
skb=skb@entry=0x88142200) at linux/net/ipv6/ip6_output.c:134
 #3  0x0000000000ab4cbc in __ip6_finish_output (skb=0x88142200, sk=0x0,
net=0x88edba00) at linux/net/ipv6/ip6_output.c:195
 #4  ip6_finish_output (net=0x88edba00, sk=0x0, skb=0x88142200) at
linux/net/ipv6/ip6_output.c:206

xdp_do_redirect test places a u32 marker (0x42) right before the Ethernet
header to check it then in the XDP program and return %XDP_ABORTED if it's
not there. Neigh xmit code likes to round up hard header length to speed
up copying the header, so it overwrites two bytes in front of the Eth
header. On LE systems, 0x42 is one byte at `data - 4`, while on BE it's
`data - 1`, what explains why it happens only there.
It didn't happen previously due to that %XDP_PASS meant the page will be
discarded and replaced by a new one, but now it can be recycled as well,
while bpf_test_run code doesn't reinitialize the content of recycled
pages. This mark is limited to this particular test and its setup though,
so there's no need to predict 1000 different possible cases. Just move
it 4 bytes to the left, still keeping it 32 bit to match on more bytes.

Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from XDP frames")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com
Reported-by: Ilya Leoshkevich <iii@linux.ibm.com> # + debugging
Link: https://lore.kernel.org/bpf/8341c1d9f935f410438e79d3bd8a9cc50aefe105.camel@linux.ibm.com
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c | 7 ++++---
 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index 856cbc29e6a1..4eaa3dcaebc8 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -86,12 +86,12 @@ static void test_max_pkt_size(int fd)
 void test_xdp_do_redirect(void)
 {
 	int err, xdp_prog_fd, tc_prog_fd, ifindex_src, ifindex_dst;
-	char data[sizeof(pkt_udp) + sizeof(__u32)];
+	char data[sizeof(pkt_udp) + sizeof(__u64)];
 	struct test_xdp_do_redirect *skel = NULL;
 	struct nstoken *nstoken = NULL;
 	struct bpf_link *link;
 	LIBBPF_OPTS(bpf_xdp_query_opts, query_opts);
-	struct xdp_md ctx_in = { .data = sizeof(__u32),
+	struct xdp_md ctx_in = { .data = sizeof(__u64),
 				 .data_end = sizeof(data) };
 	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
 			    .data_in = &data,
@@ -105,8 +105,9 @@ void test_xdp_do_redirect(void)
 	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
 			    .attach_point = BPF_TC_INGRESS);
 
-	memcpy(&data[sizeof(__u32)], &pkt_udp, sizeof(pkt_udp));
+	memcpy(&data[sizeof(__u64)], &pkt_udp, sizeof(pkt_udp));
 	*((__u32 *)data) = 0x42; /* metadata test value */
+	*((__u32 *)data + 4) = 0;
 
 	skel = test_xdp_do_redirect__open();
 	if (!ASSERT_OK_PTR(skel, "skel"))
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
index cd2d4e3258b8..5baaafed0d2d 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -52,7 +52,7 @@ int xdp_redirect(struct xdp_md *xdp)
 
 	*payload = MARK_IN;
 
-	if (bpf_xdp_adjust_meta(xdp, 4))
+	if (bpf_xdp_adjust_meta(xdp, sizeof(__u64)))
 		return XDP_ABORTED;
 
 	if (retcode > XDP_PASS)
-- 
2.39.2

