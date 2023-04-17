Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811886E4C33
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjDQO7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjDQO7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E317EEB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681743448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2nb5rOxu+eMXePB1Z1jNJCBWthAXG1RZhUzsVUyexss=;
        b=KQCNCMNLKLK7qyP9MNDRFf9jameXC6/uyPwqWJeHQ7lisOWQvbxm3Yi5ksjObpOFNMNm9Y
        uduuvrOYgx47cM1Ptku5CIK0Foq5i3OrKlL1X03FRarhyzeyoZwEQHrz8RGJ5EnPlbb6rT
        t3HkODVVvailzTS4qBYznJcUB1JpV34=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-zmQGtHdnOa2694jj_kLFiA-1; Mon, 17 Apr 2023 10:57:25 -0400
X-MC-Unique: zmQGtHdnOa2694jj_kLFiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04676857F81;
        Mon, 17 Apr 2023 14:57:24 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA4DC1121318;
        Mon, 17 Apr 2023 14:57:23 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1CFD9307372E8;
        Mon, 17 Apr 2023 16:57:23 +0200 (CEST)
Subject: [PATCH bpf-next V1 4/5] igc: add XDP hints kfuncs for RX hash
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, yoong.siang.song@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Date:   Mon, 17 Apr 2023 16:57:23 +0200
Message-ID: <168174344307.593471.11961012266841546530.stgit@firesoul>
In-Reply-To: <168174338054.593471.8312147519616671551.stgit@firesoul>
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements XDP hints kfunc for RX-hash (xmo_rx_hash).
The HW rss hash type is handled via mapping table.

This igc driver driver (default config) does L3 hashing for UDP packets
(excludes UDP src/dest ports in hash calc).  Meaning RSS hash type is
L3 based.  Tested that the igc_rss_type_num for UDP is either
IGC_RSS_TYPE_HASH_IPV4 or IGC_RSS_TYPE_HASH_IPV6.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |   35 +++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 862768d5d134..27f448d0ae94 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6507,8 +6507,43 @@ static int igc_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
 	return -ENODATA;
 }
 
+/* Mapping HW RSS Type to enum xdp_rss_hash_type */
+enum xdp_rss_hash_type igc_xdp_rss_type[IGC_RSS_TYPE_MAX_TABLE] = {
+	[IGC_RSS_TYPE_NO_HASH]		= XDP_RSS_TYPE_L2,
+	[IGC_RSS_TYPE_HASH_TCP_IPV4]	= XDP_RSS_TYPE_L4_IPV4_TCP,
+	[IGC_RSS_TYPE_HASH_IPV4]	= XDP_RSS_TYPE_L3_IPV4,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6]	= XDP_RSS_TYPE_L4_IPV6_TCP,
+	[IGC_RSS_TYPE_HASH_IPV6_EX]	= XDP_RSS_TYPE_L3_IPV6_EX,
+	[IGC_RSS_TYPE_HASH_IPV6]	= XDP_RSS_TYPE_L3_IPV6,
+	[IGC_RSS_TYPE_HASH_TCP_IPV6_EX] = XDP_RSS_TYPE_L4_IPV6_TCP_EX,
+	[IGC_RSS_TYPE_HASH_UDP_IPV4]	= XDP_RSS_TYPE_L4_IPV4_UDP,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6]	= XDP_RSS_TYPE_L4_IPV6_UDP,
+	[IGC_RSS_TYPE_HASH_UDP_IPV6_EX] = XDP_RSS_TYPE_L4_IPV6_UDP_EX,
+	[10] = XDP_RSS_TYPE_NONE, /* RSS Type above 9 "Reserved" by HW  */
+	[11] = XDP_RSS_TYPE_NONE, /* keep array sized for SW bit-mask   */
+	[12] = XDP_RSS_TYPE_NONE, /* to handle future HW revisons       */
+	[13] = XDP_RSS_TYPE_NONE,
+	[14] = XDP_RSS_TYPE_NONE,
+	[15] = XDP_RSS_TYPE_NONE,
+};
+
+static int igc_xdp_rx_hash(const struct xdp_md *_ctx, u32 *hash,
+			   enum xdp_rss_hash_type *rss_type)
+{
+	const struct igc_xdp_buff *ctx = (void *)_ctx;
+
+	if (!(ctx->xdp.rxq->dev->features & NETIF_F_RXHASH))
+		return -ENODATA;
+
+	*hash = le32_to_cpu(ctx->rx_desc->wb.lower.hi_dword.rss);
+	*rss_type = igc_xdp_rss_type[igc_rss_type(ctx->rx_desc)];
+
+	return 0;
+}
+
 const struct xdp_metadata_ops igc_xdp_metadata_ops = {
 	.xmo_rx_timestamp		= igc_xdp_rx_timestamp,
+	.xmo_rx_hash			= igc_xdp_rx_hash,
 };
 
 /**


