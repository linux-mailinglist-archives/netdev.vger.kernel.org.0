Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B36631C22
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiKUI4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiKUIzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:55:53 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01ABE83EBB
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 00:54:29 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e13so15247955edj.7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 00:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XjtF5z2ZdT7plrxbz2Xm/nf25ihuLirLtbLBhiX5yHA=;
        b=pNDXar6I42RDLmKCxCX/OBINCpTiegxaDqyAZRGwVxhCTqeLRUbfuVhcAMtrCVfy69
         kj+/9BBEN9PpO1BTKCqbQRtqPeDDF1cLi4Cw0sXCio39w2kXQ9a0A0uOnGMakeSpkFXK
         ESpk1/TN5aQavTGNuLEw1cX5x4P8ler6ghG4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XjtF5z2ZdT7plrxbz2Xm/nf25ihuLirLtbLBhiX5yHA=;
        b=1j8EDRxz+lP1STUEZdacKSEfet1WzmPOui96HORc/1/jygNFvtX0hZtEUenotAPoVL
         /zG2wUzGmEc6Rpu7AmUUNqtj5EX1rAbOm6G1o4FwE1J5fVvQs3g6yMIz34zSueLYrAjG
         TfuA9Hva7zSuxjPvh5NSuW/QMRDdWe7sFSNOtIf4yz98Kk63nDSxNJt7JHyTHZGRv8vQ
         j4/F87LHLhxEXsL2zNAxToKijmhcBpNL1d3I7nxOt7o046KXgGFMU/fZPp43cu0njUyA
         r4hEstrUHrLNDpqyKTD1y6r6xU1Ah7ZJQDZzaRLxtSLa82Ix8MUeE8SGKkZZF0DnwQDc
         IMSQ==
X-Gm-Message-State: ANoB5pmXj3hiH+uKgihhDsnqnp7dCBhVKa6EWFpy2HQpIOZwAP5udKuD
        WnkgEhubTi85+v7rJlgJn1oo4NnqClDPWw==
X-Google-Smtp-Source: AA0mqf4u3PX5/x2vzWq5VJYszAokK6FAd1pkMBhqP1R0ORiA6OBJo6QHL0M8Cxkr+Siat76h9cc4CA==
X-Received: by 2002:a05:6402:248e:b0:461:e2ab:912d with SMTP id q14-20020a056402248e00b00461e2ab912dmr15712610eda.93.1669020868262;
        Mon, 21 Nov 2022 00:54:28 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id kv7-20020a17090778c700b007ad9028d684sm4706945ejc.104.2022.11.21.00.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 00:54:27 -0800 (PST)
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
Subject: [PATCH net v2] l2tp: Don't sleep and disable BH under writer-side sk_callback_lock
Date:   Mon, 21 Nov 2022 09:54:26 +0100
Message-Id: <20221121085426.21315-1-jakub@cloudflare.com>
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

v2:
- Check and set sk_user_data while holding sk_callback_lock for both
  L2TP encapsulation types (IP and UDP) (Tetsuo)

Cc: Tom Parkin <tparkin@katalix.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Fixes: b68777d54fac ("l2tp: Serialize access to sk_user_data with sk_callback_lock")
Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com
Reported-by: syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com
Reported-by: syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/l2tp/l2tp_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 754fdda8a5f5..9a1415fe3fa7 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1474,11 +1474,12 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
-	write_lock(&sk->sk_callback_lock);
-
+	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
 	if (ret < 0)
-		goto err_sock;
+		goto err_inval_sock;
+	rcu_assign_sk_user_data(sk, tunnel);
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
@@ -1507,8 +1508,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		};
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
-	} else {
-		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1522,16 +1521,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
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

