Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59F4577FB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbfF0Agm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbfF0Agl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:36:41 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF64B2184E;
        Thu, 27 Jun 2019 00:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595800;
        bh=XFYiE9MedCa4sXuYZFi1aez0mCZUFAa4CvgZKWaa98k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSXX6fN0iPoGiOIpDetF2gKUz5YB1h9yLXw2ezSOSXkrNw+H1lK3h9MCJQ5ItaNtI
         qySiyVU1n+ShJOn1JxqB7/8G0nEA7P1GW9U033C1DoRmWF6eZfh+A1uWza4D3yGCjx
         f5PxaS/BMm5wVooC2HEIXAcDRlTBrdlxJ63/ITJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/60] bpf: sockmap, fix use after free from sleep in psock backlog workqueue
Date:   Wed, 26 Jun 2019 20:35:22 -0400
Message-Id: <20190627003616.20767-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit bd95e678e0f6e18351ecdc147ca819145db9ed7b ]

Backlog work for psock (sk_psock_backlog) might sleep while waiting
for memory to free up when sending packets. However, while sleeping
the socket may be closed and removed from the map by the user space
side.

This breaks an assumption in sk_stream_wait_memory, which expects the
wait queue to be still there when it wakes up resulting in a
use-after-free shown below. To fix his mark sendmsg as MSG_DONTWAIT
to avoid the sleep altogether. We already set the flag for the
sendpage case but we missed the case were sendmsg is used.
Sockmap is currently the only user of skb_send_sock_locked() so only
the sockmap paths should be impacted.

==================================================================
BUG: KASAN: use-after-free in remove_wait_queue+0x31/0x70
Write of size 8 at addr ffff888069a0c4e8 by task kworker/0:2/110

CPU: 0 PID: 110 Comm: kworker/0:2 Not tainted 5.0.0-rc2-00335-g28f9d1a3d4fe-dirty #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
Workqueue: events sk_psock_backlog
Call Trace:
 print_address_description+0x6e/0x2b0
 ? remove_wait_queue+0x31/0x70
 kasan_report+0xfd/0x177
 ? remove_wait_queue+0x31/0x70
 ? remove_wait_queue+0x31/0x70
 remove_wait_queue+0x31/0x70
 sk_stream_wait_memory+0x4dd/0x5f0
 ? sk_stream_wait_close+0x1b0/0x1b0
 ? wait_woken+0xc0/0xc0
 ? tcp_current_mss+0xc5/0x110
 tcp_sendmsg_locked+0x634/0x15d0
 ? tcp_set_state+0x2e0/0x2e0
 ? __kasan_slab_free+0x1d1/0x230
 ? kmem_cache_free+0x70/0x140
 ? sk_psock_backlog+0x40c/0x4b0
 ? process_one_work+0x40b/0x660
 ? worker_thread+0x82/0x680
 ? kthread+0x1b9/0x1e0
 ? ret_from_fork+0x1f/0x30
 ? check_preempt_curr+0xaf/0x130
 ? iov_iter_kvec+0x5f/0x70
 ? kernel_sendmsg_locked+0xa0/0xe0
 skb_send_sock_locked+0x273/0x3c0
 ? skb_splice_bits+0x180/0x180
 ? start_thread+0xe0/0xe0
 ? update_min_vruntime.constprop.27+0x88/0xc0
 sk_psock_backlog+0xb3/0x4b0
 ? strscpy+0xbf/0x1e0
 process_one_work+0x40b/0x660
 worker_thread+0x82/0x680
 ? process_one_work+0x660/0x660
 kthread+0x1b9/0x1e0
 ? __kthread_create_on_node+0x250/0x250
 ret_from_fork+0x1f/0x30

Fixes: 20bf50de3028c ("skbuff: Function to send an skbuf on a socket")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8b5768113acd..9b9f696281a9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2302,6 +2302,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		kv.iov_base = skb->data + offset;
 		kv.iov_len = slen;
 		memset(&msg, 0, sizeof(msg));
+		msg.msg_flags = MSG_DONTWAIT;
 
 		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
 		if (ret <= 0)
-- 
2.20.1

