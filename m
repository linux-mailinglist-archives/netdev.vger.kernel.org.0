Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C669A357AA2
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhDHDG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhDHDGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:06:25 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECFCC061760;
        Wed,  7 Apr 2021 20:06:14 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id h7so402906qtx.3;
        Wed, 07 Apr 2021 20:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kV0fkH+tuk7thGUnaNovelgFzYfqN5NPv9y1kh3GkuU=;
        b=t0gt8oBYwmZcXDBhth+EapAgjSpD0d6ChTyncfMWP5brgOXnnr1bvv6GDzMXmGYb9h
         j1gmX3xyA22wKhpLI2lKPkjz5joSakLN6EV5YUf3ICkmbXfvcgOTSbOqvkpXGwtMtIDJ
         +C6RqtbHRBC9UjXlZkA2+XEwpd3QasOPFiFKqIv2E0jBvr+00YLoh2kEP5+hEG8nQr1t
         hho4pK6KOfyFNUXkRxj8UkCFfwZpE5oXT20usWn5plI2IQJfmBCEhjKSnMA9Su6ap173
         L4zvtBtfihGgUb3Tgk4yVAVoPRrCDTdfAhkZHlnBfJBtn1X0okLYc1jBYRSEmI99LZjK
         vmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kV0fkH+tuk7thGUnaNovelgFzYfqN5NPv9y1kh3GkuU=;
        b=kbDjHtLJ77gHcAI5EXQ9tf5e7WLn4AYXJYE+FZSq7vYWHjn3v8aaMHHJhqNWJXaQWI
         l2dTtGl9Ff2kVd5W7U6n3QteTNkwuCObViacIoQq0iZgEWRkWWehbVo2ErKCijQd/EpS
         NYqsIR4+Do0xaGTDE3R/u6FJwGlIoFefQmcWU/ZQlVfsCFY2roBX358psXSnZys9q+Au
         C9sBDWPinkZOos008HhEvNJ1JM4Ij2Z4VyK+AtJTtYf0vxgdd0VjuL9sWgjjS9730yjf
         jLQ6m5TxcsCO7hFWfXcUDJq3in24SquLlT0ZXR1lUvhG26GvNR2GLgPPHpNBrz1uoD6h
         of8A==
X-Gm-Message-State: AOAM5330iaab8xzQLk8wFKapaUngwWfTPolWzh4O9OaW6ksMIA/Txv9g
        RLErtYDNFVaWLb3is5lNXkPft28vPDrAKA==
X-Google-Smtp-Source: ABdhPJys3egiMmXF300pe9M1d0Q0W/W9K0ikKJjb1MlhpvtiUvJKa9ZFdP5h1MuzohYby99iZJ0s0g==
X-Received: by 2002:ac8:7d42:: with SMTP id h2mr5554717qtb.182.1617851174086;
        Wed, 07 Apr 2021 20:06:14 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9119:981:e03d:47f0])
        by smtp.gmail.com with ESMTPSA id z6sm29026qkc.73.2021.04.07.20.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 20:06:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next] sock_map: fix a potential use-after-free in sock_map_close()
Date:   Wed,  7 Apr 2021 20:05:56 -0700
Message-Id: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

The last refcnt of the psock can be gone right after
sock_map_remove_links(), so sk_psock_stop() could trigger a UAF.
The reason why I placed sk_psock_stop() there is to avoid RCU read
critical section, and more importantly, some callee of
sock_map_remove_links() is supposed to be called with RCU read lock,
we can not simply get rid of RCU read lock here. Therefore, the only
choice we have is to grab an additional refcnt with sk_psock_get()
and put it back after sk_psock_stop().

Reported-by: syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com
Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index f473c51cbc4b..6f1b82b8ad49 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1521,7 +1521,7 @@ void sock_map_close(struct sock *sk, long timeout)
 
 	lock_sock(sk);
 	rcu_read_lock();
-	psock = sk_psock(sk);
+	psock = sk_psock_get(sk);
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
 		release_sock(sk);
@@ -1532,6 +1532,7 @@ void sock_map_close(struct sock *sk, long timeout)
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
 	sk_psock_stop(psock, true);
+	sk_psock_put(sk, psock);
 	release_sock(sk);
 	saved_close(sk, timeout);
 }
-- 
2.25.1

