Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B952049D6F6
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiA0AvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiA0AvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:51:20 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1EFC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:51:20 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i65so1181769pfc.9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=28/XJDkLaNUkghsjlTsMhlW+sN+ycel3+pdzc8QNj/4=;
        b=KaHL7LW0HLt/RnzX670Rg1x6WmU44XY/Lf4L4om4NHkrroLK4pZRFABNhalBgdJJpx
         zc4F0sTlqusv0El7TIp4AbMFRMrMZGSPWFSM3TGCokWvq4e7UtLVVLt9QtwcBdlduc2x
         kfQSMRJlHr2yVPQk0zKrhGNqsN9gNMA2RD3ghRFldBzopvRqAHx3e5WICMayUTGcXkdV
         PVcl5/GhTmIYk/K5vk+wHUa0eYgRmm5hJcul1diirHiUmC1r2wLBGObY2yjtq64C24RC
         pEOpBMfuffwJxNCSPvKiOK4BqXe8RLlOCBa6sb4xBINvbFa8wneE1OsDNUTBiyajK8CW
         3OHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=28/XJDkLaNUkghsjlTsMhlW+sN+ycel3+pdzc8QNj/4=;
        b=h9+L/E+JZLbkfJwh3R81csd03TJVPKaR8WyrDzkFrQO3LPJmLufAnhVzAfamCeiDoB
         IFMvEJ2tfEiB8xN04K23sI1WeQqSc7sPVNk+ELnZm925ZNYbqXRqbbM9jNpIt67Y77wP
         /8hU5KIeRXlxYVrY9vxXDaABwJaj5Z/HXccNFZMacXd9xyLyCogFpLKYcSz3bZi8NPbs
         NyauQXugKlpQVesroOvDhHLVaBaS+3TDEYG57DVmYwzENP5+bqWX5hYn3Bx3csLrCSfK
         YTtyQkBeE3tZtbe0JAjlBo0S5GOl4vz0ZCC7Cbs26Wkimc1xRCiFuDJyTti4U9MypyT7
         6G/w==
X-Gm-Message-State: AOAM533AlxYypQmAGUIEdIK3ALifQ89HEIue063DJ9IA26bRQ2ccWbWf
        CyBJPYTa5fI42myky4HN3mI=
X-Google-Smtp-Source: ABdhPJz/4j68olSYTB3upyB9smyAAtrzRQjQqaryoNx3hoz48OsXJzrJryCw71mwThuIvW7xC0jlVA==
X-Received: by 2002:a05:6a00:228e:: with SMTP id f14mr813896pfe.33.1643244679897;
        Wed, 26 Jan 2022 16:51:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id w12sm18130310pgj.40.2022.01.26.16.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:51:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ipv4: raw: lock the socket in raw_bind()
Date:   Wed, 26 Jan 2022 16:51:16 -0800
Message-Id: <20220127005116.1268532-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For some reason, raw_bind() forgot to lock the socket.

BUG: KCSAN: data-race in __ip4_datagram_connect / raw_bind

write to 0xffff8881170d4308 of 4 bytes by task 5466 on cpu 0:
 raw_bind+0x1b0/0x250 net/ipv4/raw.c:739
 inet_bind+0x56/0xa0 net/ipv4/af_inet.c:443
 __sys_bind+0x14b/0x1b0 net/socket.c:1697
 __do_sys_bind net/socket.c:1708 [inline]
 __se_sys_bind net/socket.c:1706 [inline]
 __x64_sys_bind+0x3d/0x50 net/socket.c:1706
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881170d4308 of 4 bytes by task 5468 on cpu 1:
 __ip4_datagram_connect+0xb7/0x7b0 net/ipv4/datagram.c:39
 ip4_datagram_connect+0x2a/0x40 net/ipv4/datagram.c:89
 inet_dgram_connect+0x107/0x190 net/ipv4/af_inet.c:576
 __sys_connect_file net/socket.c:1900 [inline]
 __sys_connect+0x197/0x1b0 net/socket.c:1917
 __do_sys_connect net/socket.c:1927 [inline]
 __se_sys_connect net/socket.c:1924 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x0003007f

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 5468 Comm: syz-executor.5 Not tainted 5.17.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/raw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index a53f256bf9d39157021f84ce395fa1a0b9fb46ab..0505935b6b8c6c66d0df677b1d95c2cbe3ffb12d 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -722,6 +722,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	int ret = -EINVAL;
 	int chk_addr_ret;
 
+	lock_sock(sk);
 	if (sk->sk_state != TCP_CLOSE || addr_len < sizeof(struct sockaddr_in))
 		goto out;
 
@@ -741,7 +742,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		inet->inet_saddr = 0;  /* Use device */
 	sk_dst_reset(sk);
 	ret = 0;
-out:	return ret;
+out:
+	release_sock(sk);
+	return ret;
 }
 
 /*
-- 
2.35.0.rc0.227.g00780c9af4-goog

