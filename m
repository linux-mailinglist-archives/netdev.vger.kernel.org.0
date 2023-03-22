Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96E46C4FEF
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjCVQCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjCVQCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:02:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6D966D37
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679500911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNzfne+ehiwMF7uvGVh6OwjGKWcTNK9/K/phIg4/2Ik=;
        b=Aw8/mMZZ+TazQlvre2qT6hA4GE/db3FzlOiLzMWiSiht5zPKwng/8IY7HzpFHAI0ebBp1d
        E1O/Sv2vVA9q+00wm+JR2CzasKw0NEQeIp1fbxC/AKy7FaEJpsvde7c6D2RDO+atnp5ooX
        yklI5yTEsI3uU+t7foBHdKJ22tEWOgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-NzuDCQ_WOh65JIZpGjR3LA-1; Wed, 22 Mar 2023 12:01:47 -0400
X-MC-Unique: NzuDCQ_WOh65JIZpGjR3LA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C877A80348E;
        Wed, 22 Mar 2023 16:01:43 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E4004021B1;
        Wed, 22 Mar 2023 16:01:43 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B8A6030736C72;
        Wed, 22 Mar 2023 17:01:42 +0100 (CET)
Subject: [PATCH bpf-next V3 6/6] igc: add XDP hints kfuncs for RX hash
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
Date:   Wed, 22 Mar 2023 17:01:42 +0100
Message-ID: <167950090270.2796265.5629516764329442733.stgit@firesoul>
In-Reply-To: <167950085059.2796265.16405349421776056766.stgit@firesoul>
References: <167950085059.2796265.16405349421776056766.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements XDP hints kfunc for RX-hash (xmo_rx_hash) straightforward
by returning the u32 hash value.

The associated RSS-type for the hash value isn't available to the BPF-prog
caller. This is problematic if BPF-prog tries to do L4 load-balancing with
the hardware hash, but the RSS hash type is L3 based.

For this driver this issue occurs for UDP packets, as driver (default
config) does L3 hashing for UDP packets (excludes UDP src/dest ports in
hash calc). Tested that the igc_rss_type_num for UDP is either
IGC_RSS_TYPE_HASH_IPV4 or IGC_RSS_TYPE_HASH_IPV6.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f66285c85444..846041119fd4 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6496,8 +6496,21 @@ static int igc_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
 	return -ENODATA;
 }
 
+static int igc_xdp_rx_hash(const struct xdp_md *_ctx, u32 *hash)
+{
+	const struct igc_xdp_buff *ctx = (void *)_ctx;
+
+	if (!(ctx->xdp.rxq->dev->features & NETIF_F_RXHASH))
+		return -ENODATA;
+
+	*hash = le32_to_cpu(ctx->rx_desc->wb.lower.hi_dword.rss);
+
+	return 0;
+}
+
 const struct xdp_metadata_ops igc_xdp_metadata_ops = {
 	.xmo_rx_timestamp		= igc_xdp_rx_timestamp,
+	.xmo_rx_hash			= igc_xdp_rx_hash,
 };
 
 /**


