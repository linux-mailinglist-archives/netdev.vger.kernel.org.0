Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952B96C3339
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjCUNsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjCUNsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:48:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0219E36FFF
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679406444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xk9luJqFYKnZQu1b5EgBEL83xZfiHrJUDu5Ocv07fK8=;
        b=MPjti2PgWTaCMazFswC+dfpxQ4sW4ADnbTk44jkFdSrfmqbzzzTIYbZGE90gYT9yaJwe2z
        JW8GSPjAZTrMVD8neCx09O8JjhURn+D6+fg9ELQCCV2Sj4zlfbCfE6MoyK6KtDbZoUJ7N5
        vCaRWsZQ78yEhsFyIndzSjbf53nuwQY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-Ki3F_Mj-MZixEcfecLybrQ-1; Tue, 21 Mar 2023 09:47:20 -0400
X-MC-Unique: Ki3F_Mj-MZixEcfecLybrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C188385C06C;
        Tue, 21 Mar 2023 13:47:17 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87DA540C20FA;
        Tue, 21 Mar 2023 13:47:17 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B369930721A6C;
        Tue, 21 Mar 2023 14:47:16 +0100 (CET)
Subject: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash return
 code info
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Date:   Tue, 21 Mar 2023 14:47:16 +0100
Message-ID: <167940643669.2718137.4624187727245854475.stgit@firesoul>
In-Reply-To: <167940634187.2718137.10209374282891218398.stgit@firesoul>
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When driver developers add XDP-hints kfuncs for RX hash it is
practical to print the return code in bpf_printk trace pipe log.

Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
as this makes it easier to spot poor quality hashes.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index 40c17adbf483..ce07010e4d48 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
 		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
 	}
 
-	if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
-		bpf_printk("populated rx_hash with %u", meta->rx_hash);
-	else
+	ret = bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
+	if (ret >= 0) {
+		bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash);
+	} else {
+		bpf_printk("rx_hash not-avail errno:%d", ret);
 		meta->rx_hash = 0; /* Used by AF_XDP as not avail signal */
+	}
 
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 400bfe19abfe..f3ec07ccdc95 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -3,6 +3,9 @@
 /* Reference program for verifying XDP metadata on real HW. Functional test
  * only, doesn't test the performance.
  *
+ * BPF-prog bpf_printk info outout can be access via
+ * /sys/kernel/debug/tracing/trace_pipe
+ *
  * RX:
  * - UDP 9091 packets are diverted into AF_XDP
  * - Metadata verified:
@@ -156,7 +159,7 @@ static void verify_xdp_metadata(void *data, clockid_t clock_id)
 
 	meta = data - sizeof(*meta);
 
-	printf("rx_hash: %u\n", meta->rx_hash);
+	printf("rx_hash: 0x%08X\n", meta->rx_hash);
 	printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
 	       (double)meta->rx_timestamp / NANOSEC_PER_SEC);
 	if (meta->rx_timestamp) {


