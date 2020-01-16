Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69713EE99
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395089AbgAPSJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393263AbgAPRiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F178246D6;
        Thu, 16 Jan 2020 17:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196283;
        bh=N5aaNo4Zng70FBypG1Qc1xi1L5HJFoomh2aZrmH0VRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+4rR/2mBD6cC4s7Isc3n+RfMzMNCc+ePVtFi9JeFvktbrGFpvzI60lYxC3JGKR1L
         VjAR2E1fGLz7KGO9gwiSjITzcbPExk+qsCVecah3B2HgYxNNMGoM7si7E12njYDuGV
         5uc/Hp8HjNskDxa+D+NnP4WdS8q2Wdw6K0pEBG68=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Maloy <jon.maloy@ericsson.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 102/251] tipc: tipc clang warning
Date:   Thu, 16 Jan 2020 12:34:11 -0500
Message-Id: <20200116173641.22137-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>

[ Upstream commit 737889efe9713a0f20a75fd0de952841d9275e6b ]

When checking the code with clang -Wsometimes-uninitialized we get the
following warning:

if (!tipc_link_is_establishing(l)) {
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/tipc/node.c:847:46: note: uninitialized use occurs here
      tipc_bearer_xmit(n->net, bearer_id, &xmitq, maddr);

net/tipc/node.c:831:2: note: remove the 'if' if its condition is always
true
if (!tipc_link_is_establishing(l)) {
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/tipc/node.c:821:31: note: initialize the variable 'maddr' to silence
this warning
struct tipc_media_addr *maddr;

We fix this by initializing 'maddr' to NULL. For the matter of clarity,
we also test if 'xmitq' is non-empty before we use it and 'maddr'
further down in the  function. It will never happen that 'xmitq' is non-
empty at the same time as 'maddr' is NULL, so this is a sufficient test.

Fixes: 598411d70f85 ("tipc: make resetting of links non-atomic")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/node.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index db8fbc076e1a..fe7b0ad1d6f3 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -688,10 +688,10 @@ static void __tipc_node_link_down(struct tipc_node *n, int *bearer_id,
 static void tipc_node_link_down(struct tipc_node *n, int bearer_id, bool delete)
 {
 	struct tipc_link_entry *le = &n->links[bearer_id];
+	struct tipc_media_addr *maddr = NULL;
 	struct tipc_link *l = le->link;
-	struct tipc_media_addr *maddr;
-	struct sk_buff_head xmitq;
 	int old_bearer_id = bearer_id;
+	struct sk_buff_head xmitq;
 
 	if (!l)
 		return;
@@ -713,7 +713,8 @@ static void tipc_node_link_down(struct tipc_node *n, int bearer_id, bool delete)
 	tipc_node_write_unlock(n);
 	if (delete)
 		tipc_mon_remove_peer(n->net, n->addr, old_bearer_id);
-	tipc_bearer_xmit(n->net, bearer_id, &xmitq, maddr);
+	if (!skb_queue_empty(&xmitq))
+		tipc_bearer_xmit(n->net, bearer_id, &xmitq, maddr);
 	tipc_sk_rcv(n->net, &le->inputq);
 }
 
-- 
2.20.1

