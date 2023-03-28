Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71AB6CCB55
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjC1URH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjC1UQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:16:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ED33C22
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680034573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5g4mrXl41+GFKanErFDMONuv//RKV9fef6DjptIgCzo=;
        b=H1U+kIPp3t3sKDkwVhIMQeX4TkvLy1Y+wYp5i5Ut+4K7ijH+QsVXnuN/HHKJrRD4XoCsVT
        Y1RoT7iuAEcQ3UdsFUMIO2Oii5mkWpS356p1hamGR9hpdhwQbcnDxjGWfSfDlapXZbXaph
        bR2mml65N0r4l0msJugIBuHZ9lNCMkc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-6nCBLlI-NnamgUygy5UhhA-1; Tue, 28 Mar 2023 16:16:10 -0400
X-MC-Unique: 6nCBLlI-NnamgUygy5UhhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82363280BF64;
        Tue, 28 Mar 2023 20:16:09 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30AC8C15BA0;
        Tue, 28 Mar 2023 20:16:09 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 530E130736C72;
        Tue, 28 Mar 2023 22:16:08 +0200 (CEST)
Subject: [PATCH bpf RFC 3/4] veth: bpf_xdp_metadata_rx_hash return xdp rss
 hash type
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
Date:   Tue, 28 Mar 2023 22:16:08 +0200
Message-ID: <168003456829.3027256.12371018603759735483.stgit@firesoul>
In-Reply-To: <168003451121.3027256.13000250073816770554.stgit@firesoul>
References: <168003451121.3027256.13000250073816770554.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update API for bpf_xdp_metadata_rx_hash() by returning xdp rss hash type.

The veth driver currently only support XDP-hints based on SKB code path.
The SKB have lost information about the RSS hash type, by compressing
the information down to a single bitfield skb->l4_hash, that only knows
if this was a L4 hash value.

In preparation for veth, the xdp_rss_hash_type have an L4 indication
bit that allow us to return a meaningful L4 indication when working
with SKB based packets.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/veth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 046461ee42ea..6b1084e39b25 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1624,7 +1624,7 @@ static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
 		return -ENODATA;
 
 	*hash = skb_get_hash(_ctx->skb);
-	return 0;
+	return _ctx->skb->l4_hash ? XDP_RSS_TYPE_L4_BIT : XDP_RSS_TYPE_NONE;
 }
 
 static const struct net_device_ops veth_netdev_ops = {


