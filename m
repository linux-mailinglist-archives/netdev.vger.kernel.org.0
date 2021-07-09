Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE663C2766
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 18:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhGIQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 12:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhGIQS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 12:18:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BBE2613B7;
        Fri,  9 Jul 2021 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625847372;
        bh=2viy1JTRy7MEKbMDXn87kM0r6tBhfBuE9EgicvkOKYE=;
        h=From:To:Cc:Subject:Date:From;
        b=PBbAk8jj8lfVJkI+7huaSkNp2e24zBsb49yVZDFjoWdtw5Wg8uQV6YmL77wkdQeaI
         H6RY6mihL+JVGHicxb6AJOtIDDmiRprbmUCblx3mAdVTZ2SfTmzqcqyENC/KVxa9BI
         NSE4WCzcFR4PfXFWbYDBkynsonIT0Rb8M3rOY2p6sfxf2m5673k9f0tf8O0o61aHFo
         0Bsn+4bkJ+HY0oZeaoh666w8KvDvyHTIAkYNqZ9ZOeAw6TTuzpFM5mJJNzeikihzkj
         rYbtD6cPZ0H6h/S7NlWFiZ5PTKYkgbGxGPq31vH3uW4n8M/+OTMoLVsWmXSKdUrntR
         m/ZHh6aJccA2w==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com, Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net] net: do not reuse skbuff allocated from skbuff_fclone_cache in the skb cache
Date:   Fri,  9 Jul 2021 18:16:09 +0200
Message-Id: <20210709161609.725717-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some socket buffers allocated in the fclone cache (in __alloc_skb) can
end-up in the following path[1]:

napi_skb_finish
  __kfree_skb_defer
    napi_skb_cache_put

The issue is napi_skb_cache_put is not fclone friendly and will put
those skbuff in the skb cache to be reused later, although this cache
only expects skbuff allocated from skbuff_head_cache. When this happens
the skbuff is eventually freed using the wrong origin cache, and we can
see traces similar to:

[ 1223.947534] cache_from_obj: Wrong slab cache. skbuff_head_cache but object is from skbuff_fclone_cache
[ 1223.948895] WARNING: CPU: 3 PID: 0 at mm/slab.h:442 kmem_cache_free+0x251/0x3e0
[ 1223.950211] Modules linked in:
[ 1223.950680] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.13.0+ #474
[ 1223.951587] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-3.fc34 04/01/2014
[ 1223.953060] RIP: 0010:kmem_cache_free+0x251/0x3e0

Leading sometimes to other memory related issues.

Fix this by using __kfree_skb for fclone skbuff, similar to what is done
the other place __kfree_skb_defer is called.

[1] At least in setups using veth pairs and tunnels. Building a kernel
    with KASAN we can for example see packets allocated in
    sk_stream_alloc_skb hit the above path and later the issue arises
    when the skbuff is reused.

Fixes: 9243adfc311a ("skbuff: queue NAPI_MERGED_FREE skbs into NAPI cache instead of freeing")
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 03c95a0867bb..64b21f0a2048 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6234,6 +6234,8 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
 	case GRO_MERGED_FREE:
 		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
 			napi_skb_free_stolen_head(skb);
+		else if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
+			__kfree_skb(skb);
 		else
 			__kfree_skb_defer(skb);
 		break;
-- 
2.31.1

