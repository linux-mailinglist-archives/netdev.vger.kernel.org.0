Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3F3D51F3
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 05:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhGZDQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 23:16:57 -0400
Received: from out0.migadu.com ([94.23.1.103]:26221 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230321AbhGZDQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 23:16:55 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627271839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=42/x3cunuNFrK5WXYNzv0PumgHH417h+iX4VfozjEqg=;
        b=TTEDvxwLws0uMFv8PMZ4WRAA59G66FCBFtiLFTvnsFeltMxFuQk7l7cp4tACqzT9nHNY5g
        M2zbbPyGukGSDcBtLh3VIHQ8lk+cSHfB5YjoJ9enWMDamCcWT0AnAWDS7+WhLFcSTcjQg0
        5KGfiyhcz2rKOta51MylqUExs8RZlTY=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] netfilter: nf_conntrack_bridge: Fix not free when error
Date:   Mon, 26 Jul 2021 11:57:02 +0800
Message-Id: <20210726035702.11964-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be added kfree_skb_list() when err is not equal to zero
in nf_br_ip_fragment().

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8d033a75a766..059f53903eda 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -83,12 +83,16 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 			skb->tstamp = tstamp;
 			err = output(net, sk, data, skb);
-			if (err || !iter.frag)
-				break;
-
+			if (err) {
+				kfree_skb_list(iter.frag);
+				return err;
+			}
+
+			if (!iter.frag)
+				return 0;
+
 			skb = ip_fraglist_next(&iter);
 		}
-		return err;
 	}
 slow_path:
 	/* This is a linearized skbuff, the original geometry is lost for us.
-- 
2.32.0

