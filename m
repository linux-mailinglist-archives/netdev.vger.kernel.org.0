Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B4563A72E
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiK1L0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiK1LZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:25:43 -0500
Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 08F2E6478;
        Mon, 28 Nov 2022 03:25:40 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltADXxwySmoRjSUsAAA--.450S3;
        Mon, 28 Nov 2022 19:25:17 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf v2 1/4] bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
Date:   Mon, 28 Nov 2022 19:24:42 +0800
Message-Id: <1669634685-1717-2-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669634685-1717-1-git-send-email-yangpc@wangsu.com>
References: <1669634685-1717-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: SyJltADXxwySmoRjSUsAAA--.450S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4DXFWkJr4rAryruryrCrg_yoW8tFy3pF
        W5Gw1akr43JrW7Cw4rtFWvvF18u3yrGFn0krZaqr1fAFZ3JFyUJF1jgryFka4FgrWxCw13
        Zryqgr1UA3ZrZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tcp_bpf_send_verdict() redirection, the eval variable is assigned to
__SK_REDIRECT after the apply_bytes data is sent, if msg has more_data,
sock_put() will be called multiple times.
We should reset the eval variable to __SK_NONE every time more_data
starts.

This causes:

IPv4: Attempt to release TCP socket in state 1 00000000b4c925d7
------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 5 PID: 4482 at lib/refcount.c:25 refcount_warn_saturate+0x7d/0x110
Modules linked in:
CPU: 5 PID: 4482 Comm: sockhash_bypass Kdump: loaded Not tainted 6.0.0 #1
Hardware name: Red Hat KVM, BIOS 1.11.0-2.el7 04/01/2014
Call Trace:
 <TASK>
 __tcp_transmit_skb+0xa1b/0xb90
 ? __alloc_skb+0x8c/0x1a0
 ? __kmalloc_node_track_caller+0x184/0x320
 tcp_write_xmit+0x22a/0x1110
 __tcp_push_pending_frames+0x32/0xf0
 do_tcp_sendpages+0x62d/0x640
 tcp_bpf_push+0xae/0x2c0
 tcp_bpf_sendmsg_redir+0x260/0x410
 ? preempt_count_add+0x70/0xa0
 tcp_bpf_send_verdict+0x386/0x4b0
 tcp_bpf_sendmsg+0x21b/0x3b0
 sock_sendmsg+0x58/0x70
 __sys_sendto+0xfa/0x170
 ? xfd_validate_state+0x1d/0x80
 ? switch_fpu_return+0x59/0xe0
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x37/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: cd9733f5d75c ("tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f8b12b9..ef5de4f 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -279,7 +279,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, origsize, sent, delta = 0;
-	u32 eval = __SK_NONE;
+	u32 eval;
 	int ret;
 
 more_data:
@@ -310,6 +310,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	tosend = msg->sg.size;
 	if (psock->apply_bytes && psock->apply_bytes < tosend)
 		tosend = psock->apply_bytes;
+	eval = __SK_NONE;
 
 	switch (psock->eval) {
 	case __SK_PASS:
-- 
1.8.3.1

