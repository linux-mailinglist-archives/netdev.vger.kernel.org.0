Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2910A6D0C50
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjC3RJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjC3RJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:09:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78E7526F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680196091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bSAIg+VQz7pDyr1tmWltn+wlC+zEEhL6e8qNwdj8hqQ=;
        b=GEw23ABvziKARlmsuiX9vQX1rEGsVeScAfJRQQ8stNAt7xSeMOz7B4qkEL5YnelU9walI6
        n8pw3WOZLsyoX3nU9Mp99JqF+x1zdGE6HbEwbsWdbAbH/J8y6rfBR/onHHO4MKg5U6awZH
        lzkqNBOwb8KeVF8nzs5X0J8THH/m0dg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-7dlY1MtQN3CqUPOVkfBPlA-1; Thu, 30 Mar 2023 13:08:09 -0400
X-MC-Unique: 7dlY1MtQN3CqUPOVkfBPlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5895B3811F21;
        Thu, 30 Mar 2023 17:08:07 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA01A14171C3;
        Thu, 30 Mar 2023 17:08:06 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 0CC0A30736C72;
        Thu, 30 Mar 2023 19:08:06 +0200 (CEST)
Subject: [PATCH bpf RFC-V3 5/5] selftests/bpf: Adjust bpf_xdp_metadata_rx_hash
 for new arg
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Date:   Thu, 30 Mar 2023 19:08:06 +0200
Message-ID: <168019608600.3557870.7120119859607204078.stgit@firesoul>
In-Reply-To: <168019602958.3557870.9960387532660882277.stgit@firesoul>
References: <168019602958.3557870.9960387532660882277.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../selftests/bpf/prog_tests/xdp_metadata.c        |    2 ++
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   14 +++++++++-----
 tools/testing/selftests/bpf/progs/xdp_metadata.c   |    6 +++---
 tools/testing/selftests/bpf/progs/xdp_metadata2.c  |    7 ++++---
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |    2 +-
 tools/testing/selftests/bpf/xdp_metadata.h         |    1 +
 6 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
index aa4beae99f4f..8c5e98da9ae9 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -273,6 +273,8 @@ static int verify_xsk_metadata(struct xsk *xsk)
 	if (!ASSERT_NEQ(meta->rx_hash, 0, "rx_hash"))
 		return -1;
 
+	ASSERT_EQ(meta->rx_hash_type, 0, "rx_hash_type");
+
 	xsk_ring_cons__release(&xsk->rx, 1);
 	refill_rx(xsk, comp_addr);
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index 4c55b4d79d3d..7b3fc12e96d6 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -14,8 +14,8 @@ struct {
 
 extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
 					 __u64 *timestamp) __ksym;
-extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
-				    __u32 *hash) __ksym;
+extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, __u32 *hash,
+				    enum xdp_rss_hash_type *rss_type) __ksym;
 
 SEC("xdp")
 int rx(struct xdp_md *ctx)
@@ -74,10 +74,14 @@ int rx(struct xdp_md *ctx)
 	else
 		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
 
-	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
-		bpf_printk("populated rx_hash with %u", meta->rx_hash);
-	else
+	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash, &meta->rx_hash_type)) {
+		bpf_printk("populated rx_hash:0x%X type:0x%X",
+			   meta->rx_hash, meta->rx_hash_type);
+		if (!(meta->rx_hash_type & XDP_RSS_L4))
+			bpf_printk("rx_hash low quality L3 hash type");
+	} else {
 		meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
+	}
 
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
diff --git a/tools/testing/selftests/bpf/progs/xdp_metadata.c b/tools/testing/selftests/bpf/progs/xdp_metadata.c
index 77678b034389..d151d406a123 100644
--- a/tools/testing/selftests/bpf/progs/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_metadata.c
@@ -21,8 +21,8 @@ struct {
 
 extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
 					 __u64 *timestamp) __ksym;
-extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
-				    __u32 *hash) __ksym;
+extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, __u32 *hash,
+				    enum xdp_rss_hash_type *rss_type) __ksym;
 
 SEC("xdp")
 int rx(struct xdp_md *ctx)
@@ -56,7 +56,7 @@ int rx(struct xdp_md *ctx)
 	if (timestamp == 0)
 		meta->rx_timestamp = 1;
 
-	bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
+	bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash, &meta->rx_hash_type);
 
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
diff --git a/tools/testing/selftests/bpf/progs/xdp_metadata2.c b/tools/testing/selftests/bpf/progs/xdp_metadata2.c
index cf69d05451c3..85f88d9d7a78 100644
--- a/tools/testing/selftests/bpf/progs/xdp_metadata2.c
+++ b/tools/testing/selftests/bpf/progs/xdp_metadata2.c
@@ -5,17 +5,18 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
-extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
-				    __u32 *hash) __ksym;
+extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, __u32 *hash,
+				    enum xdp_rss_hash_type *rss_type) __ksym;
 
 int called;
 
 SEC("freplace/rx")
 int freplace_rx(struct xdp_md *ctx)
 {
+	enum xdp_rss_hash_type type = 0;
 	u32 hash = 0;
 	/* Call _any_ metadata function to make sure we don't crash. */
-	bpf_xdp_metadata_rx_hash(ctx, &hash);
+	bpf_xdp_metadata_rx_hash(ctx, &hash, &type);
 	called++;
 	return XDP_PASS;
 }
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 1c8acb68b977..4ca29e0c9646 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -141,7 +141,7 @@ static void verify_xdp_metadata(void *data)
 	meta = data - sizeof(*meta);
 
 	printf("rx_timestamp: %llu\n", meta->rx_timestamp);
-	printf("rx_hash: %u\n", meta->rx_hash);
+	printf("rx_hash: 0x%X RSS type:0x%X\n", meta->rx_hash, meta->rx_hash_type);
 }
 
 static void verify_skb_metadata(int fd)
diff --git a/tools/testing/selftests/bpf/xdp_metadata.h b/tools/testing/selftests/bpf/xdp_metadata.h
index f6780fbb0a21..899da872fee1 100644
--- a/tools/testing/selftests/bpf/xdp_metadata.h
+++ b/tools/testing/selftests/bpf/xdp_metadata.h
@@ -12,4 +12,5 @@
 struct xdp_meta {
 	__u64 rx_timestamp;
 	__u32 rx_hash;
+	__u32 rx_hash_type;
 };


