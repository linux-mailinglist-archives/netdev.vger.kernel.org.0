Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219E46D237F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjCaPEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjCaPEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:04:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0951A1B34F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 08:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680275003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NTHm0roWAf7TQFvInPD+g2gqpP2BBJVAUuG4X2BR8/k=;
        b=WpRQTFCdLn64x4dWwtFBm8kcKgexBTbHHim3L6OcZdoCjrgv4me0gNhxsR/f7sy9Y/40rM
        A8vUk+VSKhBdx1kSZHzO8WgWCt/IBFs3HwgZ7phGSFE34h0LpnQYczJ3sXPejAGsCa9K1d
        iibNnQvBxYLndTaPEj2XWuntfVnLjt0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-FDIny1NROJGiQI5iw8F-Iw-1; Fri, 31 Mar 2023 11:03:19 -0400
X-MC-Unique: FDIny1NROJGiQI5iw8F-Iw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E46029ABA03;
        Fri, 31 Mar 2023 15:03:18 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 036B0492C3E;
        Fri, 31 Mar 2023 15:03:18 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1A22830736C72;
        Fri, 31 Mar 2023 17:03:17 +0200 (CEST)
Subject: [PATCH bpf V4 3/5] veth: bpf_xdp_metadata_rx_hash add xdp rss hash
 type
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
        davem@davemloft.net, tariqt@nvidia.com
Date:   Fri, 31 Mar 2023 17:03:17 +0200
Message-ID: <168027499706.3941176.15786196864241739433.stgit@firesoul>
In-Reply-To: <168027495947.3941176.6690238098903275241.stgit@firesoul>
References: <168027495947.3941176.6690238098903275241.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

Update API for bpf_xdp_metadata_rx_hash() with arg for xdp rss hash type.

The veth driver currently only support XDP-hints based on SKB code path.
The SKB have lost information about the RSS hash type, by compressing
the information down to a single bitfield skb->l4_hash, that only knows
if this was a L4 hash value.

In preparation for veth, the xdp_rss_hash_type have an L4 indication
bit that allow us to return a meaningful L4 indication when working
with SKB based packets.

Fixes: 306531f0249f ("veth: Support RX XDP metadata")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/veth.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index c1178915496d..f5381e7c9310 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1648,14 +1648,19 @@ static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 	return 0;
 }
 
-static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
+static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
+			    enum xdp_rss_hash_type *rss_type)
+
 {
 	struct veth_xdp_buff *_ctx = (void *)ctx;
+	struct sk_buff *skb = _ctx->skb;
 
-	if (!_ctx->skb)
+	if (!skb)
 		return -ENODATA;
 
-	*hash = skb_get_hash(_ctx->skb);
+	*hash = skb_get_hash(skb);
+	*rss_type = skb->l4_hash ? XDP_RSS_TYPE_L4_ANY : XDP_RSS_TYPE_NONE;
+
 	return 0;
 }
 


