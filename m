Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AC26DFDB7
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 20:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjDLSh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 14:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjDLShh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 14:37:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8064486
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681324538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMxLHr1nEJDBRCg1B8L488/y3xeAF5pIZJtw2W0lrWE=;
        b=SVHTqnwJuMrczY9I6lOsMP3bOhzCEjErPLUWrB6fXJPAh8y7er2HAw2mGLL0HAc4NffB40
        3bBOIvfiiktBQadsVbRnti9mfkWI1NUijU6rTJvl4xiNiSRWL0CcrnRfIt4OLD6dZT0lvp
        ZdVNGXjSvm2Iy4yRxwh2wP7hz0LOAn0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-uEA3gRpPPjCm-pRWtlW3OA-1; Wed, 12 Apr 2023 14:35:34 -0400
X-MC-Unique: uEA3gRpPPjCm-pRWtlW3OA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80EE21C0690C;
        Wed, 12 Apr 2023 18:35:33 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A28347CD0;
        Wed, 12 Apr 2023 18:35:33 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 55231307372E8;
        Wed, 12 Apr 2023 20:35:32 +0200 (CEST)
Subject: [PATCH bpf V9 4/6] veth: bpf_xdp_metadata_rx_hash add xdp rss hash
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
        davem@davemloft.net, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, linux-rdma@vger.kernel.org
Date:   Wed, 12 Apr 2023 20:35:32 +0200
Message-ID: <168132453230.317773.15764647167518530046.stgit@firesoul>
In-Reply-To: <168132448251.317773.2526885806604122764.stgit@firesoul>
References: <168132448251.317773.2526885806604122764.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
Acked-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/veth.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 424e8876a16b..e1b38fbf1dd9 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1652,11 +1652,14 @@ static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
 			    enum xdp_rss_hash_type *rss_type)
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
 


