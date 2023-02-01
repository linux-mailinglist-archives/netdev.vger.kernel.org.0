Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95696686D2C
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBARgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjBARgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:36:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C6CB741
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675272910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4dv67rjWbB8phkwR88pNNn9RFMxdY5vO814eYDknDc=;
        b=Jz6/zZGy50+iKGSgH0qkQXoBT1fmNMzRvd2MHuJi/bYcDCDRAUl+9irmFoOUGHXQXYTI8v
        ej7m9CDeGmnuAWN55dPWYMjVnh/ifypvY1VbJ/JZUaSGLwFdEBNNOGCcL1rVTLXIVjow4j
        FhvwOAi0wfeRJEyv3IncmW/XXYEhOfg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-OfAtXXwYOJegtnh4WYXY2w-1; Wed, 01 Feb 2023 12:31:54 -0500
X-MC-Unique: OfAtXXwYOJegtnh4WYXY2w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 898563C0F68C;
        Wed,  1 Feb 2023 17:31:51 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45037492B05;
        Wed,  1 Feb 2023 17:31:51 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4F142300005EE;
        Wed,  1 Feb 2023 18:31:50 +0100 (CET)
Subject: [PATCH bpf-next V2 1/4] selftests/bpf: xdp_hw_metadata clear metadata
 when -EOPNOTSUPP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Date:   Wed, 01 Feb 2023 18:31:50 +0100
Message-ID: <167527271027.937063.5177725618616476592.stgit@firesoul>
In-Reply-To: <167527267453.937063.6000918625343592629.stgit@firesoul>
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

Fixes: 297a3f124155 ("selftests/bpf: Simple program to dump XDP RX metadata")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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


