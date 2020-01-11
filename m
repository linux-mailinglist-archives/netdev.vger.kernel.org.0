Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4353A137BC5
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgAKGMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:12:42 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33913 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAKGMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:12:41 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so4440404iof.1;
        Fri, 10 Jan 2020 22:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2YO/NNWKM5qMXT2mbSvtSSJzyxAWg0hu0wdxBaM9JKk=;
        b=sJmBlUuHXvYYtxlbwOOVZBx67VJgtR0LUlzlDcqPJgs0+lvWDTRBkr8bSybEBEGTy2
         lmNZHQOy3X1WaUv3HyZ7RIHUKYPOSdJAI0FpMxT+GuV9TFwgwcJwnFLBtsS9raZsbmQl
         DMaHbmPKopLgE5mXrtCUmpFrNU8H9e1rapHLFO+7rHYHUPZ7KLGos4t0BrCJ2McF/kKS
         Le2GCynm9eSa8T3M3kEq/aGkksAuRnZ7av5Xo/FsmtiGdC3at8yLJcVBUz0m3NMi387e
         YpxtsODBFmoAA5S9mw5+TvkxcaK4THIZVgf5AGd80/XiP75ZQv4zqDS7RLQ4ShV4HNPn
         FFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2YO/NNWKM5qMXT2mbSvtSSJzyxAWg0hu0wdxBaM9JKk=;
        b=EHgxTmjUdrlhIDDHel1gojHkAv0YrbOzy8tJ4q3xVYPaD+EB3iI47NS5qvudRoXS+x
         CdMJ2xdtYLk6P8KDpvYAw3131vgyiL2KyLGODYDavcTx8SpN9Ef3yzco3xYQZpsjnfWl
         b3CFld+TUisOhVzJdCRmvga8k7hADJ0mvobB7A/rox6FruLAkhzSJW8Z5QD9ncW7Osll
         q8j1ptBE7P5bPbniYt3DzDhhk/BSMS2hZoHXbusjp8h2piNHYEY+i9Rw5tD13jVr7JCc
         5yDoHC0nQxw6WrQu5AqARj+eHCZ0M3lsKdks0IsdHEAnsgcxn+BfCH9Sbtzw6tbFUULq
         zRvA==
X-Gm-Message-State: APjAAAWcOjogE74J+M6Nti0gwahL5E29KyvGERd5Pp1QZAix+POUl3be
        E16lPtCYlcJrbsxj1hETHqySI40K
X-Google-Smtp-Source: APXvYqxJ8ZGh0Q7/VcVr2PoAr6Qa0ThQYX3jaGtsJih9yJdXn1w+bPzc4LP/g4qB8e0u/44m6YXqdg==
X-Received: by 2002:a02:c951:: with SMTP id u17mr6361541jao.27.1578723161110;
        Fri, 10 Jan 2020 22:12:41 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:12:40 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 2/8] bpf: sockmap, ensure sock lock held during tear down
Date:   Sat, 11 Jan 2020 06:12:00 +0000
Message-Id: <20200111061206.8028-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
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
Cc: stable@vger.kernel.org
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c    | 2 ++
 net/core/sock_map.c | 7 ++++++-
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
-- 
2.17.1

