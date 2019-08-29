Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA11A25CB
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfH2SN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728646AbfH2SN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD78223426;
        Thu, 29 Aug 2019 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102436;
        bh=S/uUICgvSilsGtYuYVeoMlz2yDoqpI2JswWuw36fMiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNIEK5jCHnPc2kiXXSaoETxgnmNt9gMqhUtQNgi+Go1EBKZkOnUyYeByiiytqtFOM
         p2PfbMwEtx5tFF98LD4iFy69U9qMmHzOXj4sq2JYGSEPBHDVJ2zQVPlE20cvf31Fs0
         fxAdq6vhezm1eVIXzWuhtS+SK7BpM37/MVyiZvE8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 25/76] rxrpc: Fix local endpoint replacement
Date:   Thu, 29 Aug 2019 14:12:20 -0400
Message-Id: <20190829181311.7562-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit b00df840fb4004b7087940ac5f68801562d0d2de ]

When a local endpoint (struct rxrpc_local) ceases to be in use by any
AF_RXRPC sockets, it starts the process of being destroyed, but this
doesn't cause it to be removed from the namespace endpoint list immediately
as tearing it down isn't trivial and can't be done in softirq context, so
it gets deferred.

If a new socket comes along that wants to bind to the same endpoint, a new
rxrpc_local object will be allocated and rxrpc_lookup_local() will use
list_replace() to substitute the new one for the old.

Then, when the dying object gets to rxrpc_local_destroyer(), it is removed
unconditionally from whatever list it is on by calling list_del_init().

However, list_replace() doesn't reset the pointers in the replaced
list_head and so the list_del_init() will likely corrupt the local
endpoints list.

Fix this by using list_replace_init() instead.

Fixes: 730c5fd42c1e ("rxrpc: Fix local endpoint refcounting")
Reported-by: syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/local_object.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 9798159ee65fa..918bffca3ddb6 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -283,7 +283,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		goto sock_error;
 
 	if (cursor != &rxnet->local_endpoints)
-		list_replace(cursor, &local->link);
+		list_replace_init(cursor, &local->link);
 	else
 		list_add_tail(&local->link, cursor);
 	age = "new";
-- 
2.20.1

