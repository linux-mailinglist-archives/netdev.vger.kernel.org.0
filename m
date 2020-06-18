Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E911FE83B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387915AbgFRCrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbgFRBK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7CFC2089D;
        Thu, 18 Jun 2020 01:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442625;
        bh=/GQEdGujnbIHnkLHzej4D5czD149ccqynnLQLOD0wVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T53g89eUx2kZYZiGC3ivVVjTq9ekRaI1fB13lk3LVW5Gio7IA5+1AAyXXjCF5oLNG
         vIgffQW63lmxq+oOF7XBiNsg0Q+56rexnOIsE23pmDl13PLSDxDd3q2fqmqYXNslcr
         dnnMbtI19UNy/0HSe8/h8DmKbQnIgr61008bQ/NM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 104/388] bpf, sockhash: Fix memory leak when unlinking sockets in sock_hash_free
Date:   Wed, 17 Jun 2020 21:03:21 -0400
Message-Id: <20200618010805.600873-104-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 33a7c831565c43a7ee2f38c7df4c4a40e1dfdfed ]

When sockhash gets destroyed while sockets are still linked to it, we will
walk the bucket lists and delete the links. However, we are not freeing the
list elements after processing them, leaking the memory.

The leak can be triggered by close()'ing a sockhash map when it still
contains sockets, and observed with kmemleak:

  unreferenced object 0xffff888116e86f00 (size 64):
    comm "race_sock_unlin", pid 223, jiffies 4294731063 (age 217.404s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      81 de e8 41 00 00 00 00 c0 69 2f 15 81 88 ff ff  ...A.....i/.....
    backtrace:
      [<00000000dd089ebb>] sock_hash_update_common+0x4ca/0x760
      [<00000000b8219bd5>] sock_hash_update_elem+0x1d2/0x200
      [<000000005e2c23de>] __do_sys_bpf+0x2046/0x2990
      [<00000000d0084618>] do_syscall_64+0xad/0x9a0
      [<000000000d96f263>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fix it by freeing the list element when we're done with it.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200607205229.2389672-2-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index b08dfae10f88..7edbf1e92457 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1024,6 +1024,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_map_unref(elem->sk, elem);
 			rcu_read_unlock();
 			release_sock(elem->sk);
+			sock_hash_free_elem(htab, elem);
 		}
 	}
 
-- 
2.25.1

