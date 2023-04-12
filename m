Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18416DF5EA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjDLMpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjDLMoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:44:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22F9749
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 05:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681303374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ypBr1coCAU1Y3T7umg6mwMc5XwLDI0aKlHGieL5OTyE=;
        b=Gch+2H2CQK4cJwRZ7sH8qbY7nDHF4cCKh3V2Haf9EZQh8kvg5MUOAu0RPbmaTQVuLzvLFh
        vvY8D2XLcWID182T9SoZ96NP4GXcklU3b3KRAIo72gVFps74oq7EFLcvhUwDNkExaEuTJ9
        zCIJj810P3je4XmJV96OUQNzlMYVfJ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-Ebzb0_u_NReM0JjGLFWjcA-1; Wed, 12 Apr 2023 08:42:51 -0400
X-MC-Unique: Ebzb0_u_NReM0JjGLFWjcA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DA9D1C0950D;
        Wed, 12 Apr 2023 12:42:48 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36AE12166B26;
        Wed, 12 Apr 2023 12:42:48 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4B22B307372E8;
        Wed, 12 Apr 2023 14:42:47 +0200 (CEST)
Subject: [PATCH bpf V8 2/7] selftests/bpf: Add counters to xdp_hw_metadata
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
Date:   Wed, 12 Apr 2023 14:42:47 +0200
Message-ID: <168130336725.150247.12193228778654006957.stgit@firesoul>
In-Reply-To: <168130333143.150247.11159481574477358816.stgit@firesoul>
References: <168130333143.150247.11159481574477358816.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add counters for skipped, failed and redirected packets.
The xdp_hw_metadata program only redirects UDP port 9091.
This helps users to quickly identify then packets are
skipped and identify failures of bpf_xdp_adjust_meta.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   15 +++++++++++++--
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |    4 +++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index b0104763405a..a07ef7534013 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -25,6 +25,10 @@ struct {
 	__type(value, __u32);
 } xsk SEC(".maps");
 
+volatile __u64 pkts_skip = 0;
+volatile __u64 pkts_fail = 0;
+volatile __u64 pkts_redir = 0;
+
 extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
 					 __u64 *timestamp) __ksym;
 extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
@@ -59,16 +63,21 @@ int rx(struct xdp_md *ctx)
 			udp = NULL;
 	}
 
-	if (!udp)
+	if (!udp) {
+		pkts_skip++;
 		return XDP_PASS;
+	}
 
 	/* Forwarding UDP:9091 to AF_XDP */
-	if (udp->dest != bpf_htons(9091))
+	if (udp->dest != bpf_htons(9091)) {
+		pkts_skip++;
 		return XDP_PASS;
+	}
 
 	ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
 	if (ret != 0) {
 		bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
+		pkts_fail++;
 		return XDP_PASS;
 	}
 
@@ -78,6 +87,7 @@ int rx(struct xdp_md *ctx)
 
 	if (meta + 1 > data) {
 		bpf_printk("bpf_xdp_adjust_meta doesn't appear to work");
+		pkts_fail++;
 		return XDP_PASS;
 	}
 
@@ -91,6 +101,7 @@ int rx(struct xdp_md *ctx)
 	else
 		meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
 
+	pkts_redir++;
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


