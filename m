Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225676DFF09
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjDLTth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjDLTtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:49:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9E34EDA
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 12:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681328924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lfDGD9RcxJ2qdgcYebzeDAtUwxX7ZOftORqmzBm8cuY=;
        b=U25Xpd+PGTQ9PqkmFqGiqbQFl3GllPwsQjD1AxFW/tyKDjEfzrLcWHvhIqiQ7eGBLBkbQ/
        sOf+4uwowmRet+V8AA7Y/eJLDb4SovKaZE4EO7OoJhz3M0H3ighzz4K0vCHVb4D/ap6U+N
        xPLnDY0QfqS218zrrZxKDdKVjaSEUZw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-gt3IM4NpNXaLCyXGbVZZGw-1; Wed, 12 Apr 2023 15:48:37 -0400
X-MC-Unique: gt3IM4NpNXaLCyXGbVZZGw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 959503C025C1;
        Wed, 12 Apr 2023 19:48:36 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D05CFD6E;
        Wed, 12 Apr 2023 19:48:36 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 61D45307372E8;
        Wed, 12 Apr 2023 21:48:35 +0200 (CEST)
Subject: [PATCH bpf V10 1/6] selftests/bpf: xdp_hw_metadata remove bpf_printk
 and add counters
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, linux-rdma@vger.kernel.org
Date:   Wed, 12 Apr 2023 21:48:35 +0200
Message-ID: <168132891533.340624.7313781245316405141.stgit@firesoul>
In-Reply-To: <168132888942.340624.2449617439220153267.stgit@firesoul>
References: <168132888942.340624.2449617439220153267.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tool xdp_hw_metadata can be used by driver developers
implementing XDP-hints metadata kfuncs.

Remove all bpf_printk calls, as the tool already transfers all the
XDP-hints related information via metadata area to AF_XDP
userspace process.

Add counters for providing remaining information about failure and
skipped packet events.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
---
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   36 ++++++++++++--------
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |    4 ++
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index 4c55b4d79d3d..0687d11162f6 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -12,6 +12,10 @@ struct {
 	__type(value, __u32);
 } xsk SEC(".maps");
 
+__u64 pkts_skip = 0;
+__u64 pkts_fail = 0;
+__u64 pkts_redir = 0;
+
 extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
 					 __u64 *timestamp) __ksym;
 extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
@@ -26,7 +30,7 @@ int rx(struct xdp_md *ctx)
 	struct udphdr *udp = NULL;
 	struct iphdr *iph = NULL;
 	struct xdp_meta *meta;
-	int ret;
+	int err;
 
 	data = (void *)(long)ctx->data;
 	data_end = (void *)(long)ctx->data_end;
@@ -46,17 +50,20 @@ int rx(struct xdp_md *ctx)
 			udp = NULL;
 	}
 
-	if (!udp)
+	if (!udp) {
+		__sync_add_and_fetch(&pkts_skip, 1);
 		return XDP_PASS;
+	}
 
-	if (udp->dest != bpf_htons(9091))
+	/* Forwarding UDP:9091 to AF_XDP */
+	if (udp->dest != bpf_htons(9091)) {
+		__sync_add_and_fetch(&pkts_skip, 1);
 		return XDP_PASS;
+	}
 
-	bpf_printk("forwarding UDP:9091 to AF_XDP");
-
-	ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
-	if (ret != 0) {
-		bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
+	err = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
+	if (err) {
+		__sync_add_and_fetch(&pkts_fail, 1);
 		return XDP_PASS;
 	}
 
@@ -65,20 +72,19 @@ int rx(struct xdp_md *ctx)
 	meta = data_meta;
 
 	if (meta + 1 > data) {
-		bpf_printk("bpf_xdp_adjust_meta doesn't appear to work");
+		__sync_add_and_fetch(&pkts_fail, 1);
 		return XDP_PASS;
 	}
 
-	if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
-		bpf_printk("populated rx_timestamp with %llu", meta->rx_timestamp);
-	else
+	err = bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp);
+	if (err)
 		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
 
-	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
-		bpf_printk("populated rx_hash with %u", meta->rx_hash);
-	else
+	err = bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
+	if (err)
 		meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
 
+	__sync_add_and_fetch(&pkts_redir, 1);
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
 
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 1c8acb68b977..3b942ef7297b 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -212,7 +212,9 @@ static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd)
 	while (true) {
 		errno = 0;
 		ret = poll(fds, rxq + 1, 1000);
-		printf("poll: %d (%d)\n", ret, errno);
+		printf("poll: %d (%d) skip=%llu fail=%llu redir=%llu\n",
+		       ret, errno, bpf_obj->bss->pkts_skip,
+		       bpf_obj->bss->pkts_fail, bpf_obj->bss->pkts_redir);
 		if (ret < 0)
 			break;
 		if (ret == 0)


