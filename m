Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8605F4A6F52
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343622AbiBBLBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiBBLBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:01:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5C0C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 03:01:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE1BA61628
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 11:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEE9C004E1;
        Wed,  2 Feb 2022 11:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643799704;
        bh=d6Zfn/ZzWXR8lIrY3qP3byNcmi6vomfJoZT+kC/blws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b072MaVxu2ZBV1tXKaOGwBNP9O1stFVkUwbIMPBRQ17F2dQya5wPGx9KcYnUFjm4k
         kR833WAJ3v9vfBZn2JFg3sgL+WEn+m7/iwJOnaX78Awrkw4nXmHd8Gk0MXCeWrWOq0
         96Fwh8U0e2ou3NIPLcemSRw+OebqXiSfjE0z19K9qlVh7q/EIaus5fHFMTFvgU6GKV
         KAG8iKNjxUygH7+JuTH0YYAgzUfhC2TnW3NkX6+mBoit/t7owRJK8M1qX6WSuTmP0f
         AcJnzZTo2uIeEPGkQU4K3Y0G2ZHuFnOLLD9ad3r5zrPjCooxYw/8Fo3yDxLj5k0BV/
         GROFUn+uT0q3Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        vladbu@nvidia.com, pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net 1/2] net: do not keep the dst cache when uncloning an skb dst and its metadata
Date:   Wed,  2 Feb 2022 12:01:36 +0100
Message-Id: <20220202110137.470850-2-atenart@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202110137.470850-1-atenart@kernel.org>
References: <20220202110137.470850-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When uncloning an skb dst and its associated metadata a new dst+metadata
is allocated and the tunnel information from the old metadata is copied
over there.

The issue is the tunnel metadata has references to cached dst, which are
copied along the way. When a dst+metadata refcount drops to 0 the
metadata is freed including the cached dst entries. As they are also
referenced in the initial dst+metadata, this ends up in UaFs.

In practice the above did not happen because of another issue, the
dst+metadata was never freed because its refcount never dropped to 0
(this will be fixed in a subsequent patch).

Fix this by initializing the dst cache after copying the tunnel
information from the old metadata to also unshare the dst cache.

Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
Cc: Paolo Abeni <pabeni@redhat.com>
Reported-by: Vlad Buslov <vladbu@nvidia.com>
Tested-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/net/dst_metadata.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 14efa0ded75d..c8f8b7b56bba 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
 static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
-	int md_size;
 	struct metadata_dst *new_md;
+	int md_size, ret;
 
 	if (!md_dst || md_dst->type != METADATA_IP_TUNNEL)
 		return ERR_PTR(-EINVAL);
@@ -123,6 +123,17 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 
 	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
 	       sizeof(struct ip_tunnel_info) + md_size);
+#ifdef CONFIG_DST_CACHE
+	ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
+	if (ret) {
+		/* We can't call metadata_dst_free directly as the still shared
+		 * dst cache would be released.
+		 */
+		kfree(new_md);
+		return ERR_PTR(ret);
+	}
+#endif
+
 	skb_dst_drop(skb);
 	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
-- 
2.34.1

