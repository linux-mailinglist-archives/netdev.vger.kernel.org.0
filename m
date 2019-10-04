Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC08CC24C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 20:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfJDSIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 14:08:39 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:49853 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbfJDSIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 14:08:38 -0400
Received: by mail-qt1-f202.google.com with SMTP id m20so7217028qtq.16
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 11:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tUvu07k6rt75A65iFrjuyK4ZZuO4U8d0OkG1CpZG8ks=;
        b=Axi3rM7eAlU66oBaSdvvh5iX47Iptfd9gsfF1/0dz/TVfFdHQf5yl3CbJE7zWXcyEZ
         +xDK8uasjAxhdf6NNlKqguPgNk514sPh8NxaFBpl7p47sx19t7dZ6ABqr5ztk/a3g1fY
         o+FgOoNRudlBbJa/JUr9s0/dGkVF7V3FuoKAq1Y2RfO2+y9a6qs5vDKba+BPX+P7iEXQ
         IrpHZOG7oUmiZLHslxilUiexU08mwkQi16Yg//0awl5W0a3luYg1YNUuUmvDz+DLDZUO
         IRXgtmBsuSNYXJSeV5aZwV1AllCmKvbNtTySBfaNCj1i3ghylDyOZM2tNh1ljUfKfrTI
         E26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tUvu07k6rt75A65iFrjuyK4ZZuO4U8d0OkG1CpZG8ks=;
        b=hONUQKuA1qu/ccYvluq5sZQiViCd/WRVGItIiJKJfIQJWEHqERNOcRXR6kFOds+P7m
         05PNiiDNizHhGxJkLv8CrMitoP+JQch0tRGf3ot2zgQtpMfkmnQ61q6oGlRG/0tb1iwx
         uxymWGEoVkMVXU7GWcGMjwzDqIRKTnrCSUYXtSe4CtQCCm7+JDK6lxJw0iaMP5CT9RgG
         kUhqItM4clqSpDA5TxmeKMnvnh0JexPJ2WydAHJaFDC9Cn5EDWCu+0G2cFf1ykwdA7Bk
         KfdyENBuYpsg/j7LLwd9SVQ1FyRzNtzOx+8fu8cHpYGYkY9+Hg2/sDxMS+LqEKqjAjyl
         9Wpg==
X-Gm-Message-State: APjAAAVn2UPCLePPiAllxK/ufiA0l1vhaRWLNT0PYOJcbZYW/HDx4eyW
        Bd7KHjA2x8Bhj7+7NFbFaujurv/l7y0onA==
X-Google-Smtp-Source: APXvYqw4i2fJ+ZuHeIHL/pFw75VRKZuyT9BywNJf5pZGHjdndD0Dn5FeU/dg2LNBCIfX1B/W9+5n0iz9blJ9mg==
X-Received: by 2002:ac8:2dd8:: with SMTP id q24mr17574210qta.118.1570212517657;
 Fri, 04 Oct 2019 11:08:37 -0700 (PDT)
Date:   Fri,  4 Oct 2019 11:08:34 -0700
Message-Id: <20191004180834.108250-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] nfc: fix memory leak in llcp_sock_bind()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysbot reported a memory leak after a bind() has failed.

While we are at it, abort the operation if kmemdup() has failed.

BUG: memory leak
unreferenced object 0xffff888105d83ec0 (size 32):
  comm "syz-executor067", pid 7207, jiffies 4294956228 (age 19.430s)
  hex dump (first 32 bytes):
    00 69 6c 65 20 72 65 61 64 00 6e 65 74 3a 5b 34  .ile read.net:[4
    30 32 36 35 33 33 30 39 37 5d 00 00 00 00 00 00  026533097]......
  backtrace:
    [<0000000036bac473>] kmemleak_alloc_recursive /./include/linux/kmemleak.h:43 [inline]
    [<0000000036bac473>] slab_post_alloc_hook /mm/slab.h:522 [inline]
    [<0000000036bac473>] slab_alloc /mm/slab.c:3319 [inline]
    [<0000000036bac473>] __do_kmalloc /mm/slab.c:3653 [inline]
    [<0000000036bac473>] __kmalloc_track_caller+0x169/0x2d0 /mm/slab.c:3670
    [<000000000cd39d07>] kmemdup+0x27/0x60 /mm/util.c:120
    [<000000008e57e5fc>] kmemdup /./include/linux/string.h:432 [inline]
    [<000000008e57e5fc>] llcp_sock_bind+0x1b3/0x230 /net/nfc/llcp_sock.c:107
    [<000000009cb0b5d3>] __sys_bind+0x11c/0x140 /net/socket.c:1647
    [<00000000492c3bbc>] __do_sys_bind /net/socket.c:1658 [inline]
    [<00000000492c3bbc>] __se_sys_bind /net/socket.c:1656 [inline]
    [<00000000492c3bbc>] __x64_sys_bind+0x1e/0x30 /net/socket.c:1656
    [<0000000008704b2a>] do_syscall_64+0x76/0x1a0 /arch/x86/entry/common.c:296
    [<000000009f4c57a4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 30cc4587659e ("NFC: Move LLCP code to the NFC top level diirectory")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/nfc/llcp_sock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 8dfea26536c9d42a6bd9f7b64e3001737dbc4d89..ccdd790e163a81d0be5c69842fb3d25a57c743c4 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -107,9 +107,14 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	llcp_sock->service_name = kmemdup(llcp_addr.service_name,
 					  llcp_sock->service_name_len,
 					  GFP_KERNEL);
-
+	if (!llcp_sock->service_name) {
+		ret = -ENOMEM;
+		goto put_dev;
+	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
+		kfree(llcp_sock->service_name);
+		llcp_sock->service_name = NULL;
 		ret = -EADDRINUSE;
 		goto put_dev;
 	}
-- 
2.23.0.581.g78d2f28ef7-goog

