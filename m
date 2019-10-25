Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B084AE4E88
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503091AbfJYOHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504980AbfJYNzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B96EA21D7F;
        Fri, 25 Oct 2019 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011713;
        bh=i6OBQan2kKE6S0mHWye64Z4OOzcnSu3pGuUf59jIpnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTMRv6yq+fSN0QAS6EgWgiunXXw4Zs6YEPEukiQMf/aJpwR5RxBrAeJvvdL4aidqu
         hXxVKR9PQuO0FlzzZgwxp93ggrs6Z8K/4LcSNNkSDUqC1GgJ6VmneVRhjYQRCI+Bvi
         rdXKBBZmXYLDT3S5MtA/NRLi/i2002CqjaiXj8/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 06/33] rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record
Date:   Fri, 25 Oct 2019 09:54:38 -0400
Message-Id: <20191025135505.24762-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9ebeddef58c41bd700419cdcece24cf64ce32276 ]

The rxrpc_peer record needs to hold a reference on the rxrpc_local record
it points as the peer is used as a base to access information in the
rxrpc_local record.

This can cause problems in __rxrpc_put_peer(), where we need the network
namespace pointer, and in rxrpc_send_keepalive(), where we need to access
the UDP socket, leading to symptoms like:

    BUG: KASAN: use-after-free in __rxrpc_put_peer net/rxrpc/peer_object.c:411
    [inline]
    BUG: KASAN: use-after-free in rxrpc_put_peer+0x685/0x6a0
    net/rxrpc/peer_object.c:435
    Read of size 8 at addr ffff888097ec0058 by task syz-executor823/24216

Fix this by taking a ref on the local record for the peer record.

Fixes: ace45bec6d77 ("rxrpc: Fix firewall route keepalive")
Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")
Reported-by: syzbot+b9be979c55f2bea8ed30@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/peer_object.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index b700b7ecaa3d8..64830d8c1fdb5 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -216,7 +216,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 	peer = kzalloc(sizeof(struct rxrpc_peer), gfp);
 	if (peer) {
 		atomic_set(&peer->usage, 1);
-		peer->local = local;
+		peer->local = rxrpc_get_local(local);
 		INIT_HLIST_HEAD(&peer->error_targets);
 		peer->service_conns = RB_ROOT;
 		seqlock_init(&peer->service_conn_lock);
@@ -307,7 +307,6 @@ void rxrpc_new_incoming_peer(struct rxrpc_sock *rx, struct rxrpc_local *local,
 	unsigned long hash_key;
 
 	hash_key = rxrpc_peer_hash_key(local, &peer->srx);
-	peer->local = local;
 	rxrpc_init_peer(rx, peer, hash_key);
 
 	spin_lock(&rxnet->peer_hash_lock);
@@ -417,6 +416,7 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
 	list_del_init(&peer->keepalive_link);
 	spin_unlock_bh(&rxnet->peer_hash_lock);
 
+	rxrpc_put_local(peer->local);
 	kfree_rcu(peer, rcu);
 }
 
@@ -453,6 +453,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
 	if (n == 0) {
 		hash_del_rcu(&peer->hash_link);
 		list_del_init(&peer->keepalive_link);
+		rxrpc_put_local(peer->local);
 		kfree_rcu(peer, rcu);
 	}
 }
-- 
2.20.1

