Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6536AEB3B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbjCGRll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjCGRlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:41:22 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B214198E
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 09:37:23 -0800 (PST)
Received: from quatroqueijos.. (unknown [179.93.161.98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 18D103F26A;
        Tue,  7 Mar 2023 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678210641;
        bh=TFGnfRlNBORSZQCNwdZZschf12fOVSxVe8vkm0BAM0I=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=OQPclInLk4moBsRZ4jYbTz1uZ5izv6J54mpqQHOOPpKVk8+/rPc5/Zla+pUukqs9S
         tAJv9S9l1eKnwUppgHlqJaUdk3lIdppk6rgqfzZcPctxUFHQxbF8osTCvQ3F7ZF7ve
         X6t48jpJjOxI54kyYUKkal791RoPidQIhs9L8lN+ZMFYxQXHootqnkz/HNd5qEuKc+
         nG5M5IhD45TCxXUB74Y/3s5TBuy2YBTRXncAANJis4G7Q05wc9o7Doaw0Z1mmD7lzT
         RIyK3svzrpciHyNlBfUMJ8x/ppL5vmziFzB+cSj4zsojUJxyFqjGhM8n8erwLylou9
         vod/YipobwSQg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH] net: avoid double iput when sock_alloc_file fails
Date:   Tue,  7 Mar 2023 14:37:07 -0300
Message-Id: <20230307173707.468744-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sock_alloc_file fails to allocate a file, it will call sock_release.
__sys_socket_file should then not call sock_release again, otherwise there
will be a double free.

[   89.319884] ------------[ cut here ]------------
[   89.320286] kernel BUG at fs/inode.c:1764!
[   89.320656] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   89.321051] CPU: 7 PID: 125 Comm: iou-sqp-124 Not tainted 6.2.0+ #361
[   89.321535] RIP: 0010:iput+0x1ff/0x240
[   89.321808] Code: d1 83 e1 03 48 83 f9 02 75 09 48 81 fa 00 10 00 00 77 05 83 e2 01 75 1f 4c 89 ef e8 fb d2 ba 00 e9 80 fe ff ff c3 cc cc cc cc <0f> 0b 0f 0b e9 d0 fe ff ff 0f 0b eb 8d 49 8d b4 24 08 01 00 00 48
[   89.322760] RSP: 0018:ffffbdd60068bd50 EFLAGS: 00010202
[   89.323036] RAX: 0000000000000000 RBX: ffff9d7ad3cacac0 RCX: 0000000000001107
[   89.323412] RDX: 000000000003af00 RSI: 0000000000000000 RDI: ffff9d7ad3cacb40
[   89.323785] RBP: ffffbdd60068bd68 R08: ffffffffffffffff R09: ffffffffab606438
[   89.324157] R10: ffffffffacb3dfa0 R11: 6465686361657256 R12: ffff9d7ad3cacb40
[   89.324529] R13: 0000000080000001 R14: 0000000080000001 R15: 0000000000000002
[   89.324904] FS:  00007f7b28516740(0000) GS:ffff9d7aeb1c0000(0000) knlGS:0000000000000000
[   89.325328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.325629] CR2: 00007f0af52e96c0 CR3: 0000000002a02006 CR4: 0000000000770ee0
[   89.326004] PKRU: 55555554
[   89.326161] Call Trace:
[   89.326298]  <TASK>
[   89.326419]  __sock_release+0xb5/0xc0
[   89.326632]  __sys_socket_file+0xb2/0xd0
[   89.326844]  io_socket+0x88/0x100
[   89.327039]  ? io_issue_sqe+0x6a/0x430
[   89.327258]  io_issue_sqe+0x67/0x430
[   89.327450]  io_submit_sqes+0x1fe/0x670
[   89.327661]  io_sq_thread+0x2e6/0x530
[   89.327859]  ? __pfx_autoremove_wake_function+0x10/0x10
[   89.328145]  ? __pfx_io_sq_thread+0x10/0x10
[   89.328367]  ret_from_fork+0x29/0x50
[   89.328576] RIP: 0033:0x0
[   89.328732] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[   89.329073] RSP: 002b:0000000000000000 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
[   89.329477] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f7b28637a3d
[   89.329845] RDX: 00007fff4e4318a8 RSI: 00007fff4e4318b0 RDI: 0000000000000400
[   89.330216] RBP: 00007fff4e431830 R08: 00007fff4e431711 R09: 00007fff4e4318b0
[   89.330584] R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff4e441b38
[   89.330950] R13: 0000563835e3e725 R14: 0000563835e40d10 R15: 00007f7b28784040
[   89.331318]  </TASK>
[   89.331441] Modules linked in:
[   89.331617] ---[ end trace 0000000000000000 ]---

Fixes: da214a475f8b ("net: add __sys_socket_file()")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/socket.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 6bae8ce7059e..9c92c0e6c4da 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -450,7 +450,9 @@ static struct file_system_type sock_fs_type = {
  *
  *	Returns the &file bound with @sock, implicitly storing it
  *	in sock->file. If dname is %NULL, sets to "".
- *	On failure the return is a ERR pointer (see linux/err.h).
+ *
+ *	On failure @sock is released, and an ERR pointer is returned.
+ *
  *	This function uses GFP_KERNEL internally.
  */
 
@@ -1638,7 +1640,6 @@ static struct socket *__sys_socket_create(int family, int type, int protocol)
 struct file *__sys_socket_file(int family, int type, int protocol)
 {
 	struct socket *sock;
-	struct file *file;
 	int flags;
 
 	sock = __sys_socket_create(family, type, protocol);
@@ -1649,11 +1650,7 @@ struct file *__sys_socket_file(int family, int type, int protocol)
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
-	file = sock_alloc_file(sock, flags, NULL);
-	if (IS_ERR(file))
-		sock_release(sock);
-
-	return file;
+	return sock_alloc_file(sock, flags, NULL);
 }
 
 int __sys_socket(int family, int type, int protocol)
-- 
2.34.1

