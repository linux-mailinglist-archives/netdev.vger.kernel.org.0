Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFF14AC728
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383519AbiBGRSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378622AbiBGRN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:13:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6A3C0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 445F560FC4
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 17:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F45C004E1;
        Mon,  7 Feb 2022 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644254005;
        bh=VDDO+foV3TK2cHCK8eXPS1Yzlk3UQhjEB/c6SY7m18k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+txThXsbZOE3ik4OMPVt9ckgeYBcNvfeVT8jNX70k2mls/UeosS2IJDTfcIYnE+f
         cM0QexSd1uTX7ZjKwwxT8lE8/fIvUSX0C7dJj22H639kcLUTAKKeK23gmFZhNRbj7H
         3ZC/3gtE7PxCPX4d8BphxJv6ylmqZGhOfuiZmjZYgf9S6H37QaG2XwWKVzbH6pgIjs
         sm8zrYOtpKfRASST5ETV/5SI0roH6kvt4vwQHE6zSI4/HbpUO0H/pMxhhOAPspUQlo
         2GsQQCT0HeZ4A9Epd49iQf/3rQr2qC9OrYhFsd6rV2/Z9pg1dky+usppBOaNYlPqTG
         EjJ8IxXLlTJLg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        vladbu@nvidia.com, pabeni@redhat.com, pshelar@ovn.org,
        daniel@iogearbox.net
Subject: [PATCH net v2 1/2] net: do not keep the dst cache when uncloning an skb dst and its metadata
Date:   Mon,  7 Feb 2022 18:13:18 +0100
Message-Id: <20220207171319.157775-2-atenart@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207171319.157775-1-atenart@kernel.org>
References: <20220207171319.157775-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 include/net/dst_metadata.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 14efa0ded75d..b997e0c1e362 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -123,6 +123,19 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 
 	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
 	       sizeof(struct ip_tunnel_info) + md_size);
+#ifdef CONFIG_DST_CACHE
+	/* Unclone the dst cache if there is one */
+	if (new_md->u.tun_info.dst_cache.cache) {
+		int ret;
+
+		ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
+		if (ret) {
+			metadata_dst_free(new_md);
+			return ERR_PTR(ret);
+		}
+	}
+#endif
+
 	skb_dst_drop(skb);
 	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
-- 
2.34.1

