Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70915EE40
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389441AbgBNQEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:04:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389923AbgBNQEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF6A24676;
        Fri, 14 Feb 2020 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696262;
        bh=JrHjtwzZrIE4QpB3v0AizW6puXMwCqlkDOToOFzYGYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyY04pnYxXWAK8ru0vk3cIZqUYNjSiJwr8ilJWYr4Dm7+daiLfQqWxxVJP2DPmLBh
         ASGD+YkelSWoyyYOOjmifw5lTEbuve+B83GX9Uv4tQMBYJWNWwHEDEmBnOenVC7nw/
         ThPbA3F7b8SNt+xNCDQV3RqBd4JoE0uzIOjR9nm8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 115/459] bpf, sockhash: Synchronize_rcu before free'ing map
Date:   Fri, 14 Feb 2020 10:56:05 -0500
Message-Id: <20200214160149.11681-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 0b2dc83906cf1e694e48003eae5df8fa63f76fd9 ]

We need to have a synchronize_rcu before free'ing the sockhash because any
outstanding psock references will have a pointer to the map and when they
use it, this could trigger a use after free.

This is a sister fix for sockhash, following commit 2bb90e5cc90e ("bpf:
sockmap, synchronize_rcu before free'ing map") which addressed sockmap,
which comes from a manual audit.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200206111652.694507-3-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 8998e356f4232..058422b932607 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -250,6 +250,7 @@ static void sock_map_free(struct bpf_map *map)
 	raw_spin_unlock_bh(&stab->lock);
 	rcu_read_unlock();
 
+	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
 
 	bpf_map_area_free(stab->sks);
@@ -873,6 +874,9 @@ static void sock_hash_free(struct bpf_map *map)
 	}
 	rcu_read_unlock();
 
+	/* wait for psock readers accessing its map link */
+	synchronize_rcu();
+
 	bpf_map_area_free(htab->buckets);
 	kfree(htab);
 }
-- 
2.20.1

