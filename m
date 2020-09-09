Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B954E263036
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgIIPHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:07:52 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:44203 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730108AbgIIL7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 07:59:47 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 95377b77;
        Wed, 9 Sep 2020 11:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=WW7WTo+4ZuqjauDDxeTu5QNSG
        m8=; b=scWw2wrECL47SQ9w+IMlWrHSFf0Yns2mnBP10l9R59+s6Iz3M3juB6gPg
        APjjwdvcWFRO5nHIHcf8qt5BunZe9AtzbEavJM/bv9z/ZW63W1iecdAhdoKgn+GE
        os3mglNAx3uqtJNZQS0WPtdcPwrrmg6HxgCYdpad3xCrj0ZMPv4tqjGqDsVqSHus
        74eJaL7dQvKB8QL/RyBHcCM4+tOfIBSqarsb7v0blqjUBXwOlUCwCzucruRL4mZ0
        TpNtf+H17CiXOHeGSpJ5zXLHKHQADf1lUbkKZg9KAO7d2iDReSox+73waEsrkM+a
        u1U7k8EACiH8DWNZXhI+SucTq6v5g==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 81b3e82f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 9 Sep 2020 11:29:31 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 2/2] wireguard: peerlookup: take lock before checking hash in replace operation
Date:   Wed,  9 Sep 2020 13:58:15 +0200
Message-Id: <20200909115815.522168-3-Jason@zx2c4.com>
In-Reply-To: <20200909115815.522168-1-Jason@zx2c4.com>
References: <20200909115815.522168-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric's suggested fix for the previous commit's mentioned race condition
was to simply take the table->lock in wg_index_hashtable_replace(). The
table->lock of the hash table is supposed to protect the bucket heads,
not the entires, but actually, since all the mutator functions are
already taking it, it makes sense to take it too for the test to
hlist_unhashed, as a defense in depth measure, so that it no longer
races with deletions, regardless of what other locks are protecting
individual entries. This is sensible from a performance perspective
because, as Eric pointed out, the case of being unhashed is already the
unlikely case, so this won't add common contention. And comparing
instructions, this basically doesn't make much of a difference other
than pushing and popping %r13, used by the new `bool ret`. More
generally, I like the idea of locking consistency across table mutator
functions, and this might let me rest slightly easier at night.

Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/wireguard/20200908145911.4090480-1-edumazet@google.com/
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/peerlookup.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/peerlookup.c b/drivers/net/wireguard/peerlookup.c
index e4deb331476b..f2783aa7a88f 100644
--- a/drivers/net/wireguard/peerlookup.c
+++ b/drivers/net/wireguard/peerlookup.c
@@ -167,9 +167,13 @@ bool wg_index_hashtable_replace(struct index_hashtable *table,
 				struct index_hashtable_entry *old,
 				struct index_hashtable_entry *new)
 {
-	if (unlikely(hlist_unhashed(&old->index_hash)))
-		return false;
+	bool ret;
+
 	spin_lock_bh(&table->lock);
+	ret = !hlist_unhashed(&old->index_hash);
+	if (unlikely(!ret))
+		goto out;
+
 	new->index = old->index;
 	hlist_replace_rcu(&old->index_hash, &new->index_hash);
 
@@ -180,8 +184,9 @@ bool wg_index_hashtable_replace(struct index_hashtable *table,
 	 * simply gets dropped, which isn't terrible.
 	 */
 	INIT_HLIST_NODE(&old->index_hash);
+out:
 	spin_unlock_bh(&table->lock);
-	return true;
+	return ret;
 }
 
 void wg_index_hashtable_remove(struct index_hashtable *table,
-- 
2.28.0

