Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8B461024A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiJ0UBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiJ0UAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:00:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9ED4BD39
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso1333447pjb.6
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RjiCuwRFNlnGD8cnL4JM+H69C0y0ToQ/JKpjmpN3Aww=;
        b=jGx0jWs2Us6GuLLv8OMPFZo7n/PLLGK+RS0ZV9NHlxhQBnPqEaZIA9yny72qQpnfs7
         JCsUSvAGkqy6csSiTBDbUEOoxXR6o5VHlrxAwYufPXhV5/wiFx2K0Xc3zDkLYbn2XGmk
         E6CZsWMAcjDmZip6+OU8Dsz+akRInE1cyGzwzX8ng4TdrkTymJ1ezTDxnsRd7mLTwbFY
         3xX/HPdGQvnVStHGRwIF8rU3BBdt5JdkKdhDaru8R5HCtHepzlHAFXo3gKhQM5PV04ak
         Khj/Wx1Isy9+6KRqDxKWFJz4A73xF2TXYQwVjq5zluD7i68b/6LTGTxZ+BPqDlRFFICH
         Z80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RjiCuwRFNlnGD8cnL4JM+H69C0y0ToQ/JKpjmpN3Aww=;
        b=cJd05fE/ffCut9StobaVBiUhEnUIXae9XNj4phSLqMr7wdSfYUxeXP3hEYLsvOrCN8
         INvdiNFJfY8oKujOlB81JuJtfBV5pmcKtbhS1JP/O/Y3amnDEmZNyIlItN9QkY2g0niR
         oWRAIgBKlhPoWzL0GotXdAzbCFTRLe8VYEbnuY4OKPIlgwnaHOdL65t1kSRU0ZqbEzAP
         J6GipSsZ8us70sz5AMHORiHTom7KktCbagpvjkVnG4oncdAV3oxGwKOL92mvvFCTLid6
         fjD2UbeSQ84k/RQ9QLkF65/Zzd3jIUqZVYailPK+ARcrs9u4DnQPkn0w/mR1M5HqO75C
         bVFA==
X-Gm-Message-State: ACrzQf0u+jd8EFuIVkAvVWaJ6yxq+5wYQxEuTp9oZ9imdVuwHCkDfinu
        4DXjaQoH/O77KDEzFMQ5MgTU9Nc=
X-Google-Smtp-Source: AMsMyM6KG2YeGD9M6kECN/tEJXXjlRxeLzwKqwkdyna5gTM1eaGl/2VGJS2wxfP9b/OFY45/cystJms=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1687:b0:565:a932:f05a with SMTP id
 k7-20020a056a00168700b00565a932f05amr50614703pfc.21.1666900830534; Thu, 27
 Oct 2022 13:00:30 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:00:19 -0700
In-Reply-To: <20221027200019.4106375-1-sdf@google.com>
Mime-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027200019.4106375-6-sdf@google.com>
Subject: [RFC bpf-next 5/5] selftests/bpf: Test rx_timestamp metadata in xskxceiver
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Example on how the metadata is prepared from the BPF context
and consumed by AF_XDP:

- bpf_xdp_metadata_have_rx_timestamp to test whether it's supported;
  if not, I'm assuming verifier will remove this "if (0)" branch
- bpf_xdp_metadata_rx_timestamp returns a _copy_ of metadata;
  the program has to bpf_xdp_adjust_meta+memcpy it;
  maybe returning a pointer is better?
- af_xdp consumer grabs it from data-<expected_metadata_offset> and
  makes sure timestamp is not empty
- when loading the program, we pass BPF_F_XDP_HAS_METADATA+prog_ifindex

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
 .../testing/selftests/bpf/progs/xskxceiver.c  | 22 ++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.c      | 23 ++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/xskxceiver.c b/tools/testing/selftests/bpf/progs/xskxceiver.c
index b135daddad3a..83c879aa3581 100644
--- a/tools/testing/selftests/bpf/progs/xskxceiver.c
+++ b/tools/testing/selftests/bpf/progs/xskxceiver.c
@@ -12,9 +12,31 @@ struct {
 	__type(value, __u32);
 } xsk SEC(".maps");
 
+extern int bpf_xdp_metadata_have_rx_timestamp(struct xdp_md *ctx) __ksym;
+extern __u32 bpf_xdp_metadata_rx_timestamp(struct xdp_md *ctx) __ksym;
+
 SEC("xdp")
 int rx(struct xdp_md *ctx)
 {
+	void *data, *data_meta;
+	__u32 rx_timestamp;
+	int ret;
+
+	if (bpf_xdp_metadata_have_rx_timestamp(ctx)) {
+		ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(__u32));
+		if (ret != 0)
+			return XDP_DROP;
+
+		data = (void *)(long)ctx->data;
+		data_meta = (void *)(long)ctx->data_meta;
+
+		if (data_meta + sizeof(__u32) > data)
+			return XDP_DROP;
+
+		rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
+		__builtin_memcpy(data_meta, &rx_timestamp, sizeof(__u32));
+	}
+
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 066bd691db13..ce82c89a432e 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -871,7 +871,9 @@ static bool is_offset_correct(struct xsk_umem_info *umem, struct pkt_stream *pkt
 static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 {
 	void *data = xsk_umem__get_data(buffer, addr);
+	void *data_meta = data - sizeof(__u32);
 	struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
+	__u32 rx_timestamp = 0;
 
 	if (!pkt) {
 		ksft_print_msg("[%s] too many packets received\n", __func__);
@@ -907,6 +909,13 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 		return false;
 	}
 
+	memcpy(&rx_timestamp, data_meta, sizeof(rx_timestamp));
+	if (rx_timestamp == 0) {
+		ksft_print_msg("Invalid metadata received: ");
+		ksft_print_msg("got %08x, expected != 0\n", rx_timestamp);
+		return false;
+	}
+
 	return true;
 }
 
@@ -1331,6 +1340,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
+	LIBBPF_OPTS(bpf_object_open_opts, open_opts);
 	int ret, ifindex;
 	void *bufs;
 
@@ -1340,10 +1350,21 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifindex)
 		exit_with_error(errno);
 
-	ifobject->bpf_obj = xskxceiver__open_and_load();
+	open_opts.prog_ifindex = ifindex;
+
+	ifobject->bpf_obj = xskxceiver__open_opts(&open_opts);
 	if (libbpf_get_error(ifobject->bpf_obj))
 		exit_with_error(libbpf_get_error(ifobject->bpf_obj));
 
+	ret = bpf_program__set_flags(bpf_object__find_program_by_name(ifobject->bpf_obj->obj, "rx"),
+				     BPF_F_XDP_HAS_METADATA);
+	if (ret < 0)
+		exit_with_error(ret);
+
+	ret = xskxceiver__load(ifobject->bpf_obj);
+	if (ret < 0)
+		exit_with_error(ret);
+
 	if (ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
 
-- 
2.38.1.273.g43a17bfeac-goog

