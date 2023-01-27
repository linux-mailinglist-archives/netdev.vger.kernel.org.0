Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7179467E70E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbjA0Nt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbjA0Nt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:49:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46807E6F0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674827349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2mijN+EWYNjnWmPokVgVVtaxLmwBhQgigUaUVnjPuDI=;
        b=G+t+8TstZfoiECG0ObEPlW79YJAPDF4r7VQXI+KXHOfUnlRZfvflEifuphoWvaOa6VvRr7
        h5jimSDxcRVlkw0Zvgas0XDqRpJwIubOZXBP0ZzUwwLMbqgUiO3pLVTtv9A3d2cWKcCAL4
        4YS9fGgzgsG7EZrryRytTiu31MMfnOM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-oDiHbX6kOhKyt3kG0xO3vw-1; Fri, 27 Jan 2023 08:49:04 -0500
X-MC-Unique: oDiHbX6kOhKyt3kG0xO3vw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC21A858F0E;
        Fri, 27 Jan 2023 13:49:03 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80DB1C15BA0;
        Fri, 27 Jan 2023 13:49:03 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 836A1300003E0;
        Fri, 27 Jan 2023 14:49:02 +0100 (CET)
Subject: [PATCH bpf-next RFC V1] selftests/bpf: xdp_hw_metadata clear metadata
 when -EOPNOTSUPP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Date:   Fri, 27 Jan 2023 14:49:02 +0100
Message-ID: <167482734243.892262.18210955230092032606.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AF_XDP userspace part of xdp_hw_metadata see non-zero as a signal of
the availability of rx_timestamp and rx_hash in data_meta area. The
kernel-side BPF-prog code doesn't initialize these members when kernel
returns an error e.g. -EOPNOTSUPP.  This memory area is not guaranteed to
be zeroed, and can contain garbage/previous values, which will be read
and interpreted by AF_XDP userspace side.

Tested this on different drivers. The experiences are that for most
packets they will have zeroed this data_meta area, but occasionally it
will contain garbage data.

Example of failure tested on ixgbe:
 poll: 1 (0)
 xsk_ring_cons__peek: 1
 0x18ec788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
 rx_hash: 3697961069
 rx_timestamp:  9024981991734834796 (sec:9024981991.7348)
 0x18ec788: complete idx=8 addr=8000

Converting to date:
 date -d @9024981991
 2255-12-28T20:26:31 CET

I choose a simple fix in this patch. When kfunc fails or isn't supported
assign zero to the corresponding struct meta value.

It's up to the individual BPF-programmer to do something smarter e.g.
that fits their use-case, like getting a software timestamp and marking
a flag that gives the type of timestamp.

Another possibility is for the behavior of kfunc's
bpf_xdp_metadata_rx_timestamp and bpf_xdp_metadata_rx_hash to require
clearing return value pointer.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/xdp.c                                     |    2 ++
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index a5a7ecf6391c..5ea13554c080 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -724,6 +724,7 @@ __diag_ignore_all("-Wmissing-prototypes",
  */
 int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 {
+	// XXX: Question: Should we clear mem pointed to by @timestamp ?
 	return -EOPNOTSUPP;
 }
 
@@ -736,6 +737,7 @@ int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
  */
 int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
 {
+	// XXX: Question: Should we clear mem pointed to by @hash ?
 	return -EOPNOTSUPP;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index 25b8178735ee..4c55b4d79d3d 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -70,10 +70,14 @@ int rx(struct xdp_md *ctx)
 	}
 
 	if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
-		bpf_printk("populated rx_timestamp with %u", meta->rx_timestamp);
+		bpf_printk("populated rx_timestamp with %llu", meta->rx_timestamp);
+	else
+		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
 
 	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
 		bpf_printk("populated rx_hash with %u", meta->rx_hash);
+	else
+		meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
 
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }


