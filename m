Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24AF3D9F5A
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhG2IUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:20:40 -0400
Received: from out0.migadu.com ([94.23.1.103]:38521 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234256AbhG2IUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 04:20:39 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627546835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UsthJwMeSd4cOe5jnYdApLzz5rYNZWHrQmxAg4ixt6Q=;
        b=ud4zSj5nHpvOHFMmprz6tgWap+YmB6dBJTGT/jTfzKtHa4UrwvFgljQiWNqut9kdaSdFaB
        +ygnQDsVSch5bAW56IzLm71yyXvWysDISEQyCFcy9rwzFbcU6Ue12tyiqxSVbbDv1hkUep
        E9pyHMLpELVhNu+4VptgSiQoJtL1pgc=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH v3] netfilter: nf_conntrack_bridge: Fix memory leak when error
Date:   Thu, 29 Jul 2021 16:20:21 +0800
Message-Id: <20210729082021.14407-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be added kfree_skb_list() when err is not equal to zero
in nf_br_ip_fragment().

v2: keep this aligned with IPv6.
v3: modify iter.frag_list to iter.frag.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8d033a75a766..d184306e1ba8 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -88,6 +88,11 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 			skb = ip_fraglist_next(&iter);
 		}
+
+		if (!err)
+			return 0;
+
+		kfree_skb_list(iter.frag);
 		return err;
 	}
 slow_path:
-- 
2.32.0

