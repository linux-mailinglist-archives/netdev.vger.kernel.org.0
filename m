Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DB43AEBCB
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhFUO4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 10:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFUO4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 10:56:08 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE16C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 07:53:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id h26so2743749pfo.5
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 07:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lblZbJRzEIebHtJHGjYWOmpSpIH7XLxKFkYAK4IWmjw=;
        b=si4I4hUpE9cgtD31sEy8X+KXMpSn3sbDgtdMIjQ95PO0q+5wDemZsjswWjXQ56SV98
         xYWuzwF4KhIbR+Rj0bgWbjc7uzvL+oyK0SP9JAW65KVxxs24SKFveafT2QPDGgdruphD
         jthSqqaekdSoTfXRVgxmrz6DV1aEgMiS06VGHnzNVCD2WZt3o73TXIWkAc0ZskflADiK
         eEYRWweMhZMc1QXB5/eznA0EM6HG/nxttISlU883NSZHWFZjmp/yGaYNNmmzFt8l5hLj
         f6RueZB+9QeGxEELVYjSK1OXEPYOVlWkxw0vDDJV+3nW06ldaUXWFPXI+/1ZU4wlyW1E
         Om2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lblZbJRzEIebHtJHGjYWOmpSpIH7XLxKFkYAK4IWmjw=;
        b=bCdCpB1SNkNeTFvJq0GyVLFQ+eHK6+21jw6qlRfpnYspyobfGwcnikPWz1LkXvLjLx
         xU9VhKs/ueUZBEIIPiJtnwYjeCQ9iGur0xyhbsZ1TssVZG0XE0aVi+oNzSIRhO3eZItx
         cmGVDci4AyJqw7b8vncnA86m3TTheB3g02xxutspknrfYq1Fzr4Nhsbv5OE/g6+Tc+qa
         W9rtsOnLJxViJJRd1FJm1CKcLoL6GRRjzrmphGtmsyvY+OqaO5MFmIT8EgYSmWggMI9/
         SlHTYxXFFskg6WFaB6rCTO0LoFmXFB7iSR6V2ew1NB0kJ0gC2Nf11fCk/JG6R/g2U8pI
         UeqQ==
X-Gm-Message-State: AOAM533dnY0zGcD9j9YxsutE0AKhkseXB2UcthVnxTc0XEfW2rzpUD0T
        RXge7F0AO8b56wXK7QHOuyU=
X-Google-Smtp-Source: ABdhPJzDcJPk4rcy579JyjWD/PCCQdi6VhX8pdXphyOwI/8oyiB+C8zvpbjiwsl9zmoLYOyvu9KWeA==
X-Received: by 2002:a63:170e:: with SMTP id x14mr24156367pgl.452.1624287232677;
        Mon, 21 Jun 2021 07:53:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:21de:f864:55d7:2d0])
        by smtp.gmail.com with ESMTPSA id r10sm17816738pga.48.2021.06.21.07.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 07:53:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] virtio/vsock: avoid NULL deref in virtio_transport_seqpacket_allow()
Date:   Mon, 21 Jun 2021 07:53:48 -0700
Message-Id: <20210621145348.695341-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Make sure the_virtio_vsock is not NULL before dereferencing it.

general protection fault, probably for non-canonical address 0xdffffc0000000071: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000388-0x000000000000038f]
CPU: 0 PID: 8452 Comm: syz-executor406 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:virtio_transport_seqpacket_allow+0xbf/0x210 net/vmw_vsock/virtio_transport.c:503
Code: e8 c6 d9 ab f8 84 db 0f 84 0f 01 00 00 e8 09 d3 ab f8 48 8d bd 88 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 2a 01 00 00 44 0f b6 a5 88 03 00 00
RSP: 0018:ffffc90003757c18 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000071 RSI: ffffffff88c908e7 RDI: 0000000000000388
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff88c90a06 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff88c90840 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000001bee300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000082 CR3: 000000002847e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 vsock_assign_transport+0x575/0x700 net/vmw_vsock/af_vsock.c:490
 vsock_connect+0x200/0xc00 net/vmw_vsock/af_vsock.c:1337
 __sys_connect_file+0x155/0x1a0 net/socket.c:1824
 __sys_connect+0x161/0x190 net/socket.c:1841
 __do_sys_connect net/socket.c:1851 [inline]
 __se_sys_connect net/socket.c:1848 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1848
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ee69
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd49e7c788 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee69
RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 0000000000402e50 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ee0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

Fixes: 53efbba12cc7 ("virtio/vsock: enable SEQPACKET for transport")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/vmw_vsock/virtio_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e73ce652bf3c3c291a12e95d26cdbd24747a7467..ed1664e7bd88840c4e336628efa76048e55f37c0 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -498,9 +498,11 @@ static bool virtio_transport_seqpacket_allow(u32 remote_cid)
 	struct virtio_vsock *vsock;
 	bool seqpacket_allow;
 
+	seqpacket_allow = false;
 	rcu_read_lock();
 	vsock = rcu_dereference(the_virtio_vsock);
-	seqpacket_allow = vsock->seqpacket_allow;
+	if (vsock)
+		seqpacket_allow = vsock->seqpacket_allow;
 	rcu_read_unlock();
 
 	return seqpacket_allow;
-- 
2.32.0.288.g62a8d224e6-goog

