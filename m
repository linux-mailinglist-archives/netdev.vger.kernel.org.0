Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A129C4A6F53
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343628AbiBBLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:01:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56864 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiBBLBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:01:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C41761652
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 11:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33C6C004E1;
        Wed,  2 Feb 2022 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643799707;
        bh=KZY92ogNcgCGz2j9fi7V1cmGq9PcGbFsjtfUKccxt48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNxWjXU5H8btlpm3mMl1sT/OSnn49nX5s9OgiqU6nv5zmf/m1aN4tBAc7A9WKGJ+S
         0qZ9IA7zkoMdgqOWckmoFWemF/ZIGpFEMPMLfCuLXrj9JgQLvldkMi/OaRa2ctgeHF
         Z7KcemsKlGmagIZlfulirhjWrqLuB0h3ReIEhmKMw62VsEVmFzbeF+7kUZgfm6YLa4
         a8F01bXFV8w58gnZcdzzv67EJ8kSmkYK1Hmce5keXNjNPqJsfh2l+5fE/Iqth4SVvL
         ShVGmvEVhRB6wIvhz0P0DZrcmHukSIduHiaZQL7MA+Lna8QYhXjHZFn+l0zT8KCiIH
         8kuGYeceRH+3Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        vladbu@nvidia.com, pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net 2/2] net: fix a memleak when uncloning an skb dst and its metadata
Date:   Wed,  2 Feb 2022 12:01:37 +0100
Message-Id: <20220202110137.470850-3-atenart@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202110137.470850-1-atenart@kernel.org>
References: <20220202110137.470850-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When uncloning an skb dst and its associated metadata, a new
dst+metadata is allocated and later replaces the old one in the skb.
This is helpful to have a non-shared dst+metadata attached to a specific
skb.

The issue is the uncloned dst+metadata is initialized with a refcount of
1, which is increased to 2 before attaching it to the skb. When
tun_dst_unclone returns, the dst+metadata is only referenced from a
single place (the skb) while its refcount is 2. Its refcount will never
drop to 0 (when the skb is consumed), leading to a memory leak.

Fix this by removing the call to dst_hold in tun_dst_unclone, as the
dst+metadata refcount is already 1.

Fixes: fc4099f17240 ("openvswitch: Fix egress tunnel info.")
Cc: Pravin B Shelar <pshelar@ovn.org>
Reported-by: Vlad Buslov <vladbu@nvidia.com>
Tested-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/net/dst_metadata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index c8f8b7b56bba..edd75c89222d 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -135,7 +135,6 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 #endif
 
 	skb_dst_drop(skb);
-	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
 	return new_md;
 }
-- 
2.34.1

