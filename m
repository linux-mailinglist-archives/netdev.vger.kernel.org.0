Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC74AC729
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243235AbiBGRSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbiBGRNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:13:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFAEC0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A895CCE1189
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 17:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B146C004E1;
        Mon,  7 Feb 2022 17:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644254009;
        bh=6ZGM40P2SsVBWWyd3LNjeReC73h//VpV7MUdg9dXnY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aF1QCbakuB/WKqPnxejm/LeRtCWl64V3IJOkXltyU+XyLrSqCwEzSAHupaxnHENez
         R2nmDoYKbC1Ou/dl4YMwrwlugdf5GzFiZYMwdTSeBdmrtAKOyWT7bsoA+mjaMfeame
         qorGLA6WSUK0Qo8ZSspLIngycHb/kf26eSDLy71/ABSvSGVSAKonVhHtVSIlF2oZjr
         ar0QKgw/gXDqFslFERXVq97zs4id5uoJ/u3/9LU4VFdREh9jtN9j6J6EBUyd/F5gHf
         KVKTJcx/CwrOn7mPBXWhR9ZK0hMhQdIO5QHGyUVofNjyqpXgcWDWr0oJnvpdrzLqwD
         LOf+lhoXxnI0Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        vladbu@nvidia.com, pabeni@redhat.com, pshelar@ovn.org,
        daniel@iogearbox.net
Subject: [PATCH net v2 2/2] net: fix a memleak when uncloning an skb dst and its metadata
Date:   Mon,  7 Feb 2022 18:13:19 +0100
Message-Id: <20220207171319.157775-3-atenart@kernel.org>
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
index b997e0c1e362..adab27ba1ecb 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -137,7 +137,6 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 #endif
 
 	skb_dst_drop(skb);
-	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
 	return new_md;
 }
-- 
2.34.1

