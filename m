Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62854575A3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfF0AbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfF0AbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:01 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B861217F4;
        Thu, 27 Jun 2019 00:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595460;
        bh=TX5449Bxly9CAVEiVBJslEWtUYm3dHGwcXI7s6qoS0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHK9HhSWjh14ZP0uLaD98RCel1GSZmkpFmkcfZQ1u/7tpr/X1TMCIYwrtC1xyWtGS
         cBlCvOb26gY9ChyahPugexbcRUSUz8S/eXVOAQGaaeSBA7hAgkBm495xdSc4+jQSZ1
         vE11IYs71bmDQzW+7jFz9O+j8pH42MsfCn1Fyjyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 12/95] bpf: sockmap, restore sk_write_space when psock gets dropped
Date:   Wed, 26 Jun 2019 20:28:57 -0400
Message-Id: <20190627003021.19867-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 186bcc3dcd106dc52d706117f912054b616666e1 ]

Once psock gets unlinked from its sock (sk_psock_drop), user-space can
still trigger a call to sk->sk_write_space by setting TCP_NOTSENT_LOWAT
socket option. This causes a null-ptr-deref because we try to read
psock->saved_write_space from sk_psock_write_space:

==================================================================
BUG: KASAN: null-ptr-deref in sk_psock_write_space+0x69/0x80
Read of size 8 at addr 00000000000001a0 by task sockmap-echo/131

CPU: 0 PID: 131 Comm: sockmap-echo Not tainted 5.2.0-rc1-00094-gf49aa1de9836 #81
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29 04/01/2014
Call Trace:
 ? sk_psock_write_space+0x69/0x80
 __kasan_report.cold.2+0x5/0x3f
 ? sk_psock_write_space+0x69/0x80
 kasan_report+0xe/0x20
 sk_psock_write_space+0x69/0x80
 tcp_setsockopt+0x69a/0xfc0
 ? tcp_shutdown+0x70/0x70
 ? fsnotify+0x5b0/0x5f0
 ? remove_wait_queue+0x90/0x90
 ? __fget_light+0xa5/0xf0
 __sys_setsockopt+0xe6/0x180
 ? sockfd_lookup_light+0xb0/0xb0
 ? vfs_write+0x195/0x210
 ? ksys_write+0xc9/0x150
 ? __x64_sys_read+0x50/0x50
 ? __bpf_trace_x86_fpu+0x10/0x10
 __x64_sys_setsockopt+0x61/0x70
 do_syscall_64+0xc5/0x520
 ? vmacache_find+0xc0/0x110
 ? syscall_return_slowpath+0x110/0x110
 ? handle_mm_fault+0xb4/0x110
 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
 ? trace_hardirqs_off_caller+0x4b/0x120
 ? trace_hardirqs_off_thunk+0x1a/0x3a
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f2e5e7cdcce
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b1 66 2e 0f 1f 84 00 00 00 00 00
0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff
ff 73 01 c3 48 8b 0d 8a 11 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffed011b778 EFLAGS: 00000206 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2e5e7cdcce
RDX: 0000000000000019 RSI: 0000000000000006 RDI: 0000000000000007
RBP: 00007ffed011b790 R08: 0000000000000004 R09: 00007f2e5e84ee80
R10: 00007ffed011b788 R11: 0000000000000206 R12: 00007ffed011b78c
R13: 00007ffed011b788 R14: 0000000000000007 R15: 0000000000000068
==================================================================

Restore the saved sk_write_space callback when psock is being dropped to
fix the crash.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 178a3933a71b..50ced8aba9db 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -351,6 +351,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
+	sk->sk_write_space = psock->saved_write_space;
+
 	if (psock->sk_proto) {
 		sk->sk_prot = psock->sk_proto;
 		psock->sk_proto = NULL;
-- 
2.20.1

