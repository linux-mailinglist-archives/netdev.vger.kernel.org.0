Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9606C55EE43
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiF1TyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiF1TvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267F223BDD;
        Tue, 28 Jun 2022 12:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445807; x=1687981807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eOg3zMPpNLqDqX1LA+Vo6P9BOiKuNyiBlLVUYpXAOWM=;
  b=kgxjR3sdwXfLJGLiu8tYjtt8oiQHgeKUfgwQlQBdPLpH06jYSeU4E66g
   i5LCuF8I4RsS0cpQqPX4wDeMJQfB7khCelCpFNdv5mwG287jKJFtU5IWQ
   CX435i+8A0IwBR+3gEW9rT4oWZbgBhudgaUsz2IyZGPPvlvRWIilMsO3G
   0W2v9Ezba4hYyldSkUYu8GryNYW9dGb3zQhZWMFFuJtJ23IrZxWUL8Ssa
   2ZbcICTArJFpiH2FV0PjwakymEjZVOYzEXoyUTI13z4Lmm0+qh6OGu6Ah
   FbQp7SNvRpc4UeVRIMSbKLtdBVKQQaPpnTBzCDXi5GGWtsAkV91mkwVG8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="261635781"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="261635781"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="658257636"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2022 12:50:02 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9o022013;
        Tue, 28 Jun 2022 20:50:00 +0100
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
Subject: [PATCH RFC bpf-next 50/52] libbpf: introduce a couple memory access helpers
Date:   Tue, 28 Jun 2022 21:48:10 +0200
Message-Id: <20220628194812.1453059-51-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larysa Zaremba <larysa.zaremba@intel.com>

In BPF programs, it is a common thing to declare that we're going
to do a memory access via such snippet:

	if (data + ETH_HLEN > data_end)
		// bail out

Offsets can be variable:

	if (VLAN_HLEN * vlan_count > SOME_ARBITRARY_MAX_OFFSET ||
	    ctx->data + VLAN_HLEN * vlan_count > data_end)
		//

Or even calculated from the end:

	if (ctx->data_end - ctx->data - ETH_FCS_LEN > SOME_ARB_MAX_OFF ||
	    ctx->data_end - ETH_FCS_LEN < ctx->data)
		//

As a bonus, LLVM sometimes has a hard time compiling sane C code
the way that it would pass the in-kernel verifier.
Add two new functions to sanitize memory accesses and get pointers
to the requested ranges: one taking an offset from the start and one
from the end (useful for metadata and different integrity check
headers). They are written in Asm, so the offset can be variable and
the code will pass the verifier. There are checks for the maximum
offset (backed by the original verifier value), going out of bounds
etc., so the pointer they return is ready to use (if it's
non-%NULL).
So now all is needed is:

	iphdr = bpf_access_mem(ctx->data, ctx->data_end, ETH_HLEN,
			       sizeof(*iphdr));
	if (!iphdr)
		// bail out

or

	some_meta_struct = bpf_access_mem_end(ctx->data_meta, ctx->data,
					      sizeof(*some_meta_struct),
					      sizeof(*some_meta_struct));
	if (!some_meta_struct)
		//

The Asm code was happily stolen from the Cilium project repo[0] and
then reworked.

[0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/ctx/xdp.h#L43

Suggested-by: Daniel Borkmann <daniel@iogearbox.net> # original helper
Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Co-developed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/bpf_helpers.h | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index fb04eaf367f1..cd16e3c9cd85 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -285,4 +285,68 @@ enum libbpf_tristate {
 /* Helper macro to print out debug messages */
 #define bpf_printk(fmt, args...) ___bpf_pick_printk(args)(fmt, ##args)
 
+/* Max offset as per kernel verifier */
+#define MAX_PACKET_OFF		0xffff
+
+/**
+ * bpf_access_mem - sanitize memory access to a range
+ * @mem: start of the memory segment
+ * @mem_end: end of the memory segment
+ * @off: offset from the start of the memory segment
+ * @len: length of the range to give access to
+ *
+ * Verifies that the memory operations we want to perform are sane and within
+ * bounds and gives pointer to the requested range. The checks are done in Asm,
+ * so that it is safe to pass variable offset (verifier might reject such code
+ * written in plain C).
+ * The intended way of using it is as follows:
+ *
+ * iphdr = bpf_access_mem(ctx->data, ctx->data_end, ETH_HLEN, sizeof(*iphdr));
+ *
+ * Returns pointer to the beginning of the range or %NULL.
+ */
+static __always_inline void *
+bpf_access_mem(__u64 mem, __u64 mem_end, __u64 off, const __u64 len)
+{
+	void *ret;
+
+	asm volatile("r1 = %[start]\n\t"
+		     "r2 = %[end]\n\t"
+		     "r3 = %[offmax] - %[len]\n\t"
+		     "if %[off] > r3 goto +5\n\t"
+		     "r1 += %[off]\n\t"
+		     "%[ret] = r1\n\t"
+		     "r1 += %[len]\n\t"
+		     "if r1 > r2 goto +1\n\t"
+		     "goto +1\n\t"
+		     "%[ret] = %[null]\n\t"
+		     : [ret]"=r"(ret)
+		     : [start]"r"(mem), [end]"r"(mem_end), [off]"r"(off),
+		       [len]"ri"(len), [offmax]"i"(MAX_PACKET_OFF),
+		       [null]"i"(NULL)
+		     : "r1", "r2", "r3");
+
+	return ret;
+}
+
+/**
+ * bpf_access_mem_end - sanitize memory access to a range at the end of segment
+ * @mem: start of the memory segment
+ * @mem_end: end of the memory segment
+ * @offend: offset from the end of the memory segment
+ * @len: length of the range to give access to
+ *
+ * Version of bpf_access_mem() which performs all needed calculations to
+ * access a memory segment from the end. E.g., to access FCS (if provided):
+ *
+ * cp = bpf_access_mem_end(ctx->data, ctx->data_end, ETH_FCS_LEN, ETH_FCS_LEN);
+ *
+ * Returns pointer to the beginning of the range or %NULL.
+ */
+static __always_inline void *
+bpf_access_mem_end(__u64 mem, __u64 mem_end, __u64 offend, const __u64 len)
+{
+	return bpf_access_mem(mem, mem_end, mem_end - mem - offend, len);
+}
+
 #endif
-- 
2.36.1

