Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71AE5D2B3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfGBPWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:22:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43380 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfGBPWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:22:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id f25so7838644pgv.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OTooTgEhQAK4FduwMrWljdVsJmNV8yuHFVRNMLNKIZs=;
        b=jCpX9ldFN/30zujBAlYrruVmZH5LVz9b+ppsnrDn1xydJsxJ8U2nowOdxKe8N7ZXbk
         l1r6vPkGQ0isTm1b/JTsQ8HDvG6KMBgeK9LQ4ZQ+eIb0P62cF89vK9yqcS2cEP55IuTm
         d+5EVuvEuX5vObFwsN5Lbmnx1gZEGWrOsXm806VwQefYa7HfAzHWdhdQrZglVndw2qaA
         CHEnMLX2RTuJsy7VtH49N2MRSwxh23Z6mljsXIeeiJgkQoGANO6Xl7LIsdDdLZ0I3IiF
         s5swiZkqcfFuehRKTsdnCoZR3HDDKWIpzs6nuaaUGQd5glBo7qJ7lPdxfXLT29BYAEA/
         fvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OTooTgEhQAK4FduwMrWljdVsJmNV8yuHFVRNMLNKIZs=;
        b=ZsJHz67GzYsWLcsaviABFc+eZamFMU5wNYhiSizbyS2nsRJ460r7+d1/jDuuRLUi5i
         7H3+1lYUREJgrSGfz1WGeNeZzeB4Livu91Cv+QwYV2kx4zHM3VrhhEzIYyWtRnASbyWD
         wECFqXz5H/T4qHMe4qbmVExHzuEjbe/GWxt8uUVQoNyXgdDnZAou2oKIylfI1EE743/T
         mUIVkRmeC7RKJrNh3yQL4+aR5wZ0R1Y+6smEhlnJl/g/wCs5nJzz1MTsHfkmhoSITpL1
         hGOjxYvX9adn07nAKPwiZNQatIPhtn6iCmRJbL7BRU+LnaayoGL0ZgtsEv87ZGsiZNN7
         OBBg==
X-Gm-Message-State: APjAAAU/5Y+oSaDO8fdnmXqpSfAXm6oFSB1i6zR0jilMPJkXN79chx46
        aOIy48VN4fqjdxNEMG1oR1Ru8b8LYNw=
X-Google-Smtp-Source: APXvYqxBfXDOhSil+lRxZWfQg1fbCbWO3ONCk3Xarl7SkYcAcNxx7SMTU7pGGO3WvAEPqGTp7/Y49w==
X-Received: by 2002:a17:90a:9a83:: with SMTP id e3mr6098537pjp.105.1562080952404;
        Tue, 02 Jul 2019 08:22:32 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id q19sm17486968pfc.62.2019.07.02.08.22.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 08:22:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/6] gtp: fix use-after-free in gtp_encap_destroy()
Date:   Wed,  3 Jul 2019 00:22:25 +0900
Message-Id: <20190702152225.22764-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gtp_encap_destroy() is called twice.
1. When interface is deleted.
2. When udp socket is destroyed.
either gtp->sk0 or gtp->sk1u could be freed by sock_put() in
gtp_encap_destroy(). so, when gtp_encap_destroy() is called again,
it would uses freed sk pointer.

patch makes gtp_encap_destroy() to set either gtp->sk0 or gtp->sk1u to
null. in addition, both gtp->sk0 and gtp->sk1u pointer are protected
by rtnl_lock. so, rtnl_lock() is added.

Test command:
   gtp-link add gtp1 &
   killall gtp-link
   ip link del gtp1

Splat looks like:
[   83.182767] BUG: KASAN: use-after-free in __lock_acquire+0x3a20/0x46a0
[   83.184128] Read of size 8 at addr ffff8880cc7d5360 by task ip/1008
[   83.185567] CPU: 1 PID: 1008 Comm: ip Not tainted 5.2.0-rc6+ #50
[   83.188469] Call Trace:
[ ... ]
[   83.200126]  lock_acquire+0x141/0x380
[   83.200575]  ? lock_sock_nested+0x3a/0xf0
[   83.201069]  _raw_spin_lock_bh+0x38/0x70
[   83.201551]  ? lock_sock_nested+0x3a/0xf0
[   83.202044]  lock_sock_nested+0x3a/0xf0
[   83.202520]  gtp_encap_destroy+0x18/0xe0 [gtp]
[   83.203065]  gtp_encap_disable.isra.14+0x13/0x50 [gtp]
[   83.203687]  gtp_dellink+0x56/0x170 [gtp]
[   83.204190]  rtnl_delete_link+0xb4/0x100
[ ... ]
[   83.236513] Allocated by task 976:
[   83.236925]  save_stack+0x19/0x80
[   83.237332]  __kasan_kmalloc.constprop.3+0xa0/0xd0
[   83.237894]  kmem_cache_alloc+0xd8/0x280
[   83.238360]  sk_prot_alloc.isra.42+0x50/0x200
[   83.238874]  sk_alloc+0x32/0x940
[   83.239264]  inet_create+0x283/0xc20
[   83.239684]  __sock_create+0x2dd/0x540
[   83.240136]  __sys_socket+0xca/0x1a0
[   83.240550]  __x64_sys_socket+0x6f/0xb0
[   83.240998]  do_syscall_64+0x9c/0x450
[   83.241466]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   83.242061]
[   83.242249] Freed by task 0:
[   83.242616]  save_stack+0x19/0x80
[   83.243013]  __kasan_slab_free+0x111/0x150
[   83.243498]  kmem_cache_free+0x89/0x250
[   83.244444]  __sk_destruct+0x38f/0x5a0
[   83.245366]  rcu_core+0x7e9/0x1c20
[   83.245766]  __do_softirq+0x213/0x8fa

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 939da5442f65..5101f8c3c99c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -285,13 +285,17 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	return gtp_rx(pctx, skb, hdrlen, gtp->role);
 }
 
-static void gtp_encap_destroy(struct sock *sk)
+static void __gtp_encap_destroy(struct sock *sk)
 {
 	struct gtp_dev *gtp;
 
 	lock_sock(sk);
 	gtp = sk->sk_user_data;
 	if (gtp) {
+		if (gtp->sk0 == sk)
+			gtp->sk0 = NULL;
+		else
+			gtp->sk1u = NULL;
 		udp_sk(sk)->encap_type = 0;
 		rcu_assign_sk_user_data(sk, NULL);
 		sock_put(sk);
@@ -299,12 +303,19 @@ static void gtp_encap_destroy(struct sock *sk)
 	release_sock(sk);
 }
 
+static void gtp_encap_destroy(struct sock *sk)
+{
+	rtnl_lock();
+	__gtp_encap_destroy(sk);
+	rtnl_unlock();
+}
+
 static void gtp_encap_disable_sock(struct sock *sk)
 {
 	if (!sk)
 		return;
 
-	gtp_encap_destroy(sk);
+	__gtp_encap_destroy(sk);
 }
 
 static void gtp_encap_disable(struct gtp_dev *gtp)
@@ -1038,6 +1049,7 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	rtnl_lock();
 	rcu_read_lock();
 
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
@@ -1062,6 +1074,7 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
 out_unlock:
 	rcu_read_unlock();
+	rtnl_unlock();
 	return err;
 }
 
-- 
2.17.1

