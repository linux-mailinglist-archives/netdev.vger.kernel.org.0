Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7604041FE
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244633AbhIIABn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241339AbhIIABm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 20:01:42 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED889C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 17:00:33 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 8so4298708pga.7
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 17:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5d6bbt6S1JRjYLjDkhQ4Mo7VS1AW4UrFmiuHXZgYoSw=;
        b=gKoCjWxEs+CXVPJ9VaN1E9yZoT76y9vffyvBeKnJVsd0N68oK7wgeqTeEIZLm9g5l8
         magKAzjL5Rn5rNyYgLM+EtRurtYAQurtlFNwLlFi449PJz4v9p9pDMh29+HLlrfGf99m
         c/pxGwRUtK9PoEtCAtTgu9FzyXBbH7EDUz1WwFeS8mkpyNJU5Flcg0AfINnW/ktbBeBC
         TbFmVBwDl/e/IVpjIsRSH+wLix1gyaZKHY9RqgGRxhRNbod6qMcRHTUeFcayDyPgeuwu
         Bk8w6oIZavGZRKETzjUeKY9y4uqaucRypvz9JPbo+WGjzTvUhBEZ9nYbRjwEbEJOhetY
         MSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5d6bbt6S1JRjYLjDkhQ4Mo7VS1AW4UrFmiuHXZgYoSw=;
        b=sr0jLnLSh69kfUK7UeDcWo456gBCsngqGAumya5bVOSvKrGvKmjrrN2trVKSbd/Dup
         de3lsLgNfULBMLJxmfjaCWc/w3ZYdaF6NU25IJcNcvVGYYDZ1oRTxCsgYbFdOTUkj6C8
         gbTcAVLOnj/AXXdR3txFYOKDmVMe6nT7OKUTv55zZU2wRNip49/mgZPWOAdvKSPcvEKh
         tkZBe7IOqNl/vG7zulCEHU0qgqT/WtmpGwa+BXpme3Nw7xf164EWUivMC9LN29hBX1GL
         dXU2Pp1gMT2FhpigDshnUcoQdb9qNTsYN3LBPFZrB5AezbyoMWVz+R8p8X8tHgeOsqEC
         Q0xg==
X-Gm-Message-State: AOAM531Dx999KWRmp1rnyysPaHXPX1hFVGOoYBNfFcvVOUaX3ijZgxJj
        HqJkQyxO4B8Kp7pyWhEjDwg=
X-Google-Smtp-Source: ABdhPJyYg/YFlf8uQSxOKFyAQr5exN37VBb8jCoP19XNEIA5fmj9bnbDhx9JKbfIb9q7K0mh3qlupA==
X-Received: by 2002:a63:f84f:: with SMTP id v15mr31215pgj.204.1631145633415;
        Wed, 08 Sep 2021 17:00:33 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:af86:2ee7:e519:ad66])
        by smtp.gmail.com with ESMTPSA id v13sm41010pfm.16.2021.09.08.17.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 17:00:32 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Qian Cai <cai@lca.pw>
Subject: [PATCH net] net/af_unix: fix a data-race in unix_dgram_poll
Date:   Wed,  8 Sep 2021 17:00:29 -0700
Message-Id: <20210909000029.1751608-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reported another data-race in af_unix [1]

Lets change __skb_insert() to use WRITE_ONCE() when changing
skb head qlen.

Also, change unix_dgram_poll() to use lockless version
of unix_recvq_full()

It is verry possible we can switch all/most unix_recvq_full()
to the lockless version, this will be done in a future kernel version.

[1] HEAD commit: 8596e589b787732c8346f0482919e83cc9362db1

BUG: KCSAN: data-race in skb_queue_tail / unix_dgram_poll

write to 0xffff88814eeb24e0 of 4 bytes by task 25815 on cpu 0:
 __skb_insert include/linux/skbuff.h:1938 [inline]
 __skb_queue_before include/linux/skbuff.h:2043 [inline]
 __skb_queue_tail include/linux/skbuff.h:2076 [inline]
 skb_queue_tail+0x80/0xa0 net/core/skbuff.c:3264
 unix_dgram_sendmsg+0xff2/0x1600 net/unix/af_unix.c:1850
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
 ___sys_sendmsg net/socket.c:2446 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2532
 __do_sys_sendmmsg net/socket.c:2561 [inline]
 __se_sys_sendmmsg net/socket.c:2558 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2558
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88814eeb24e0 of 4 bytes by task 25834 on cpu 1:
 skb_queue_len include/linux/skbuff.h:1869 [inline]
 unix_recvq_full net/unix/af_unix.c:194 [inline]
 unix_dgram_poll+0x2bc/0x3e0 net/unix/af_unix.c:2777
 sock_poll+0x23e/0x260 net/socket.c:1288
 vfs_poll include/linux/poll.h:90 [inline]
 ep_item_poll fs/eventpoll.c:846 [inline]
 ep_send_events fs/eventpoll.c:1683 [inline]
 ep_poll fs/eventpoll.c:1798 [inline]
 do_epoll_wait+0x6ad/0xf00 fs/eventpoll.c:2226
 __do_sys_epoll_wait fs/eventpoll.c:2238 [inline]
 __se_sys_epoll_wait fs/eventpoll.c:2233 [inline]
 __x64_sys_epoll_wait+0xf6/0x120 fs/eventpoll.c:2233
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000001b -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 25834 Comm: syz-executor.1 Tainted: G        W         5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 86b18aaa2b5b ("skbuff: fix a data race in skb_queue_len()")
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 2 +-
 net/unix/af_unix.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6bdb0db3e8258ad2745705a9b046eb1c93e05840..841e2f0f5240ba9e210bb9a3fc1cbedc2162b2a8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1940,7 +1940,7 @@ static inline void __skb_insert(struct sk_buff *newsk,
 	WRITE_ONCE(newsk->prev, prev);
 	WRITE_ONCE(next->prev, newsk);
 	WRITE_ONCE(prev->next, newsk);
-	list->qlen++;
+	WRITE_ONCE(list->qlen, list->qlen + 1);
 }
 
 static inline void __skb_queue_splice(const struct sk_buff_head *list,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index eb47b9de23809ac9216aae46c2fb1eae4543c890..92345c9bb60cc3b469e7cf50effe122b81c7bb89 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3073,7 +3073,7 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 
 		other = unix_peer(sk);
 		if (other && unix_peer(other) != sk &&
-		    unix_recvq_full(other) &&
+		    unix_recvq_full_lockless(other) &&
 		    unix_dgram_peer_wake_me(sk, other))
 			writable = 0;
 
-- 
2.33.0.153.gba50c8fa24-goog

