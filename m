Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D3B2819C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbfEWPse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:48:34 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36420 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbfEWPse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:48:34 -0400
Received: by mail-io1-f68.google.com with SMTP id e19so5252579iob.3;
        Thu, 23 May 2019 08:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=ONiQDH1voXY7RQXU091BwLFVqf2ZURndBabVQc1a4B0=;
        b=IiRO04DHCDyWLJdH1wId/mptP7GMrhGCqrTFqzoJK19xrkUnS2rxuJQicu6++ybzWJ
         CnCoD+G0n9FSFQsNeLIlrVSQcAG1Xd4h+5VKMBSs5igR2rSa29hAxDgZnljyS7ldUmdZ
         RAwmu359Sde6opJxLB1ckkZlTdWcMbFNvqy+x+CK7WXuJdPhhKOoUeXHQ4LkEMWFiqB1
         2alC11V3xJbkxY+pxdb/15yRVco5DcGuVI1VwYGhjbWFXV9G3klWIsfBXcsWULOdiG/5
         doSXzerJxLNIkcsKY+fE+Uwh30CeuOdKtEIClZoPO1VLmEl2AiI3/x8DDXNdNr6FolRw
         fScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=ONiQDH1voXY7RQXU091BwLFVqf2ZURndBabVQc1a4B0=;
        b=L5eSD9u2mdQWsNND+yc9vElpvIU8fUPGpxIEcFjtVLS2+uPo6btlkHhRchflNpt5+3
         2NXM3higlXGzTIPr7frTNUIT5LjG0W5NrMNl9wXiuY/yaSCbrlNZh3L/RBk48hM0z5Du
         jGdSKHxjFaOF2F5L+Npuyg+VRUuRmE6JswjY1SwqB6RVZJz3i9HPRPbBKQE7AOD1zjqR
         shK8LTp6CNxflzBSJfmlcbvPxQZoPG67PGdHq870bgK9x+ouaC5Sfidt4Gj5HuvUR3Ul
         7dOLJjZbrgFkhMZULk0dm5Tfqzq6rvDlvR3FmwQRImKTz6nlbgnUTt2fiP0sm/QlnT/T
         29IQ==
X-Gm-Message-State: APjAAAXpHSPNgLwR5Xh7r33UCA/Gm8pakn7wd9nis6u2bhYR2UO94pWk
        aimTHeETZG7JLTVmjpalrKhm+CdJogs=
X-Google-Smtp-Source: APXvYqyUPYZFpkj4LIp/XiXpnqH8quYL8S/fy7jdO6yxAKXhqHKzGjEbXQ4ksvePE/Leb/5YqwGELA==
X-Received: by 2002:a5e:9411:: with SMTP id q17mr19288559ioj.65.1558626513193;
        Thu, 23 May 2019 08:48:33 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j125sm2433263itb.27.2019.05.23.08.48.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:48:32 -0700 (PDT)
Subject: [PATCH] bpf: sockmap,
 fix use after free from sleep in psock backlog workqueue
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, jakub@cloudflare.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, marek@cloudflare
Date:   Thu, 23 May 2019 08:48:20 -0700
Message-ID: <155862650069.11403.15148410261691250447.stgit@john-Precision-5820-Tower>
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
index e89be62..c3b03c5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2337,6 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		kv.iov_base = skb->data + offset;
 		kv.iov_len = slen;
 		memset(&msg, 0, sizeof(msg));
+		msg.flags = MSG_DONTWAIT;
 
 		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
 		if (ret <= 0)

