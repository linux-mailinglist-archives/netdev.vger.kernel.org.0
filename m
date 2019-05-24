Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9AD29A87
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389125AbfEXPBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:01:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46407 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389060AbfEXPBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:01:14 -0400
Received: by mail-pl1-f193.google.com with SMTP id r18so4269995pls.13;
        Fri, 24 May 2019 08:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=b5yK+mZDp/Hujrm74lvJegWtKN3RJ00n+oCHVxd7ITI=;
        b=SPOH6zkCb8LRGXvbT43xu6HbGHmry2uM+kJhJqNz089cXDnTfN93jE5A1Gue5soBPJ
         05Q56blOjWgqU5vuCObeSs4nSbp592yuqpvX7JzaHfUh/aXpNGx1mJalTKU/wcOTLQav
         YtxbUfyDb7dcEcC6kVN8y9lm5C+Qg0GwbLKQRfbV7ejv6wyCn6WWZF4HK018yBvy3FgT
         8pTdcEAMDwmeJEytuJ50GV7C8VoJoUL0Q8Kd8RpcBsqvhwEeJiVHf2XsrjW6G5+7JvKY
         d5wjjbY5HcNdml/hjJccNoimF06ce1+J375cqjVahpopwDa2S2dG7G9vDK7M/lr1m+6k
         0s4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=b5yK+mZDp/Hujrm74lvJegWtKN3RJ00n+oCHVxd7ITI=;
        b=pL0wV2YzHNSe30cDJwMZUiL4C6AnCTUCHOvk6LEtiXdazbr8ySEMs4+qpXIPuDJ8Hi
         fP40nDuWm/MHSHYnk+vla3fAE9NDAzYmw2HLhPx9ckaydRzgzwP33qBbjpHRuA92c8QN
         Uuvh9BEkVAY2REo+W3RqD7mSXpNBPwySUYPEakmHfb3G19MoZyes7wE+Gmtv/xN410uE
         xLAMSbK9zbHBLyI+C8Y8Iu5rjMujvTkc3bKDYz6g9SjEBraQm6Ou8aadTHCJxc/921A2
         mJ6zuhJgpwa+RqQ7oxgjo5YYf6L3Q3+78CWYSDulNFKMq5vemDfeAgPryjY+O9upuFi0
         UeaQ==
X-Gm-Message-State: APjAAAVD4xrTLdjaZRwhvBUxhwM8jenJTnJh/wcV7CW6uYKXjqBxq2P4
        BacNW1nTymNvt48XkWgE32a9pmmS82g=
X-Google-Smtp-Source: APXvYqzFBzHYKF0Nnt/mVhvwP99i7i7X65SajBv0LIMoX2wLkTJTLRh2GWHDC4WyVFrhCAx2nk5L0A==
X-Received: by 2002:a17:902:9698:: with SMTP id n24mr22689628plp.118.1558710073768;
        Fri, 24 May 2019 08:01:13 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x17sm2332176pgh.47.2019.05.24.08.01.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 08:01:12 -0700 (PDT)
Subject: [PATCH v2] bpf: sockmap,
 fix use after free from sleep in psock backlog workqueue
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, jakub@cloudflare.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org
Date:   Fri, 24 May 2019 08:01:00 -0700
Message-ID: <155871006055.18695.17031102947214023468.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/core/skbuff.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e89be62..4a7c656 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2337,6 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		kv.iov_base = skb->data + offset;
 		kv.iov_len = slen;
 		memset(&msg, 0, sizeof(msg));
+		msg.msg_flags = MSG_DONTWAIT;
 
 		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
 		if (ret <= 0)

