Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972BB630EE5
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 14:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiKSNDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 08:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKSNDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 08:03:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3072FA2882
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 05:03:21 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v17so10570529edc.8
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 05:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YirbBe7liB29y8DE+THToZHUgBBshKfL45ZDZPfSEOI=;
        b=yTqnQEZblAXTi5HYrtcFB37XY4qeGc1MQl5UQsw1pqpBu/ngcDwepkB/coorVBCpHR
         qksz9lw1kGLbj/V4g6fV/okBQULeHnBmSvxm+xSzZ5bYsa01FxWVzy8pxno90ipZLGIA
         Nh4QEXw1EwuHe1/DJHKP9KNIBBRaZ4/qxtkgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YirbBe7liB29y8DE+THToZHUgBBshKfL45ZDZPfSEOI=;
        b=tyXtestvnJOhggBMn/9hV4DzWXE2TI4WGzpaCbtaSgCmjP1FmEHeRe0Ap/7/+YBFf2
         2KtjInis7HnsoPBrYA/eTNLZprZYC2a10z4F/fbgR/VotgVEHYurMjj90U7tTvftNK/L
         9rPJ3yJBQnMxPfJMLPUYW30eaqRz5iwM63Gltc6jMOv1GNaHXwvnDKZt8TpltKDYQNsa
         erE9amvZgCe46nkDoh6dEmENs0FJQZJ50BM4RYPyyJS7LR7zxRPHNwVStZvtf6+H0uU/
         XUtDa2BCV4z8JJYmGYXC5YpLg2KN+MzMUA5fLLLClalflXHG+YP6/I9oACaOhkfAH+Cw
         KzzQ==
X-Gm-Message-State: ANoB5pmpg+KQRHVhJO/0VZag4n1TaN+sgyRWZGzHIY0GLnh955A3wjKt
        6DJwz4symYAqbu6W2jZUWIkeWVhFGs/Lrw==
X-Google-Smtp-Source: AA0mqf5dFvnyVUfh3MqQNrG2KBW6Ke2fpkHawuu1sOJlvId3DZPCD9r5cZ+bXd+q4XLu3roNLzVhfA==
X-Received: by 2002:a05:6402:5299:b0:461:7291:79c1 with SMTP id en25-20020a056402529900b00461729179c1mr9835536edb.68.1668862999462;
        Sat, 19 Nov 2022 05:03:19 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id kk18-20020a170907767200b007aed2057eaesm2815216ejc.161.2022.11.19.05.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 05:03:18 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Subject: [PATCH net] l2tp: Don't sleep and disable BH under writer-side sk_callback_lock
Date:   Sat, 19 Nov 2022 14:03:17 +0100
Message-Id: <20221119130317.39158-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When holding a reader-writer spin lock we cannot sleep. Calling
setup_udp_tunnel_sock() with write lock held violates this rule, because we
end up calling percpu_down_read(), which might sleep, as syzbot reports
[1]:

 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
 percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
 cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
 static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
 udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
 setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
 l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
 pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723

Trim the writer-side critical section for sk_callback_lock down to the
minimum, so that it covers only operations on sk_user_data.

Also, when grabbing the sk_callback_lock, we always need to disable BH, as
Eric points out. Failing to do so leads to deadlocks because we acquire
sk_callback_lock in softirq context, which can get stuck waiting on us if:

1) it runs on the same CPU, or

       CPU0
       ----
  lock(clock-AF_INET6);
  <Interrupt>
    lock(clock-AF_INET6);

2) lock ordering leads to priority inversion

       CPU0                    CPU1
       ----                    ----
  lock(clock-AF_INET6);
                               local_irq_disable();
                               lock(&tcp_hashinfo.bhash[i].lock);
                               lock(clock-AF_INET6);
  <Interrupt>
    lock(&tcp_hashinfo.bhash[i].lock);

... as syzbot reports [2,3]. Use the _bh variants for write_(un)lock.

[1] https://lore.kernel.org/netdev/0000000000004e78ec05eda79749@google.com/
[2] https://lore.kernel.org/netdev/000000000000e38b6605eda76f98@google.com/
[3] https://lore.kernel.org/netdev/000000000000dfa31e05eda76f75@google.com/

Cc: Tom Parkin <tparkin@katalix.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Fixes: b68777d54fac ("l2tp: Serialize access to sk_user_data with sk_callback_lock")
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com
Reported-by: syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com
Reported-by: syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/l2tp/l2tp_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 754fdda8a5f5..100d17908196 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1474,11 +1474,20 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
-	write_lock(&sk->sk_callback_lock);
-
+	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
 	if (ret < 0)
-		goto err_sock;
+		goto err_inval_sock;
+
+	switch (tunnel->encap) {
+	case L2TP_ENCAPTYPE_IP:
+		rcu_assign_sk_user_data(sk, tunnel);
+		break;
+	case L2TP_ENCAPTYPE_UDP:
+		/* nothing to do */
+		break;
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
@@ -1507,8 +1516,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		};
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
-	} else {
-		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1522,16 +1529,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
-	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_sk_user_data(sk, NULL);
+err_inval_sock:
+	write_unlock_bh(&sk->sk_callback_lock);
+
 	if (tunnel->fd < 0)
 		sock_release(sock);
 	else
 		sockfd_put(sock);
-
-	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }
-- 
2.38.1

