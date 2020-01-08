Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93D2134EA7
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgAHVOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:14:36 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:41332 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:14:36 -0500
Received: by mail-io1-f44.google.com with SMTP id c16so4784097ioo.8;
        Wed, 08 Jan 2020 13:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XO2r01lOBNDBiQXSDfixnJ606GokxgdaQBqmQyr/bDs=;
        b=GU2OoX1zol0xRDr+Sntblx5PC4N0fXQk0lICdSZo2Qs6EGUqZfE1bcP6WfkEglPxk0
         VFlz4NAi8CbEiw2x1gpjeHvtuDvBfxJzXGxlkPshGx6H5d4UswrN/V+E2JMNemqU+wZc
         2RRwNHJxfE2h1vts7OeouIbswjA1Dqi/KJ6yhTrSdvYTn9DIy4ej5KOLIGRjmokl9QTd
         qFtmOFsiaEe//fKBgMO7QuiRSKkrDq/1fLBBGQLHD274AS972XIW6aO/BWUTsHFuXyBG
         oWUSa7VYenusLF9mLkYb9T8/rd9Y3OfdGzGinVuvB4qiGsGlvY/gUIhL4mS6QAefh8qc
         gI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XO2r01lOBNDBiQXSDfixnJ606GokxgdaQBqmQyr/bDs=;
        b=e1pZjSxf599Z3mLBsl/s93NPQ0hlK7POWQDcP5dy+JZlFMYzPQiKM+5KsnVZfzfL6Q
         O7OivLPKOjBWgdV9xdqtvtleZ/fEHGTcBjFDxApXsnARHJhX0AkBZ1GRllbGxLLaTE+x
         NZb8iTlXyNFAvlAjmC1l4eohsJY2AtM1mavRhZNbTnvu1rDSf49rpIIj3CjOWsrjMMVC
         2zeddw1rLad8PSJJbZZfH2BrHHWH81yLhxClJjLQfvJtLU7v43AL1kXGCRxNGavETtw9
         5FX+pylmOJEVfLP5WlI7w804gW8EP5d41N6ThliPtzkRMunDZMqdb9c4DvyPKXEJ9o/p
         aNKg==
X-Gm-Message-State: APjAAAXGHlrduZr5nkty/V3ffwTB+F5zHHjDaWbL0AEK8P81x/vAHf22
        Qcm5rJ4HR7UyKiYRLULh2MD7Jvzo
X-Google-Smtp-Source: APXvYqxWsuNbq+D+y5zzDCTdrZ5TpAb6lZSV2uJ9ICG89wthJmqK7P1335uf7Nmw5baqZgHZ490cfQ==
X-Received: by 2002:a6b:ed15:: with SMTP id n21mr4840178iog.128.1578518074544;
        Wed, 08 Jan 2020 13:14:34 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h6sm911558iom.43.2020.01.08.13.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:14:34 -0800 (PST)
Subject: [bpf PATCH 2/9] bpf: sockmap, ensure sock lock held during tear down
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:14:23 +0000
Message-ID: <157851806382.1732.8320375873100251133.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sock_map_free() and sock_hash_free() paths used to delete sockmap
and sockhash maps walk the maps and destroy psock and bpf state associated
with the socks in the map. When done the socks no longer have BPF programs
attached and will function normally. This can happen while the socks in
the map are still "live" meaning data may be sent/received during the walk.

Currently, though we don't take the sock_lock when the psock and bpf state
is removed through this path. Specifically, this means we can be writing
into the ops structure pointers such as sendmsg, sendpage, recvmsg, etc.
while they are also being called from the networking side. This is not
safe, we never used proper READ_ONCE/WRITE_ONCE semantics here if we
believed it was safe. Further its not clear to me its even a good idea
to try and do this on "live" sockets while networking side might also
be using the socket. Instead of trying to reason about using the socks
from both sides lets realize that every use case I'm aware of rarely
deletes maps, in fact kubernetes/Cilium case builds map at init and
never tears it down except on errors. So lets do the simple fix and
grab sock lock.

This patch wraps sock deletes from maps in sock lock and adds some
annotations so we catch any other cases easier.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c    |    2 ++
 net/core/sock_map.c |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ded2d5227678..3866d7e20c07 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -594,6 +594,8 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
+	sock_owned_by_me(sk);
+
 	sk_psock_cork_free(psock);
 	sk_psock_zap_ingress(psock);
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index eb114ee419b6..8998e356f423 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -241,8 +241,11 @@ static void sock_map_free(struct bpf_map *map)
 		struct sock *sk;
 
 		sk = xchg(psk, NULL);
-		if (sk)
+		if (sk) {
+			lock_sock(sk);
 			sock_map_unref(sk, psk);
+			release_sock(sk);
+		}
 	}
 	raw_spin_unlock_bh(&stab->lock);
 	rcu_read_unlock();
@@ -862,7 +865,9 @@ static void sock_hash_free(struct bpf_map *map)
 		raw_spin_lock_bh(&bucket->lock);
 		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
 			hlist_del_rcu(&elem->node);
+			lock_sock(elem->sk);
 			sock_map_unref(elem->sk, elem);
+			release_sock(elem->sk);
 		}
 		raw_spin_unlock_bh(&bucket->lock);
 	}

