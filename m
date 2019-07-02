Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C725D2A6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGBPVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:21:00 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43647 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfGBPU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:20:59 -0400
Received: by mail-pl1-f193.google.com with SMTP id cl9so533843plb.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DKzdEoM6Lmp9JUgVQf/KSYmgH23uDbw/uvQ6/6yRYvE=;
        b=GmIKtRK6eBgpW5N6NyYg5FQ7yd4ziypLbZ19nbjkIC/TlCkSwMh48b5t2KcNwX+0rF
         v3bVNYU7zWO8qSuZXKajUO6fXaFM1qJGnpYK0kMkXc9ef00sfHd9ZNs3MyRYVvxku8GV
         HLfPtbCzApNK+XFkSp+iK+jKCxlo3etsWIiOBBRtOsL568M9yzaQPp7il1nI4Gb7jSOO
         JFV52hVcu/Jyo0oLeQ4NWaYUuJW7R9kJF9mdfE08FWRmJO2wXlIKcVtw2LeaaqkFGUw2
         FYiwdOuglOymndWBooZbskwof6ET/SjwgR8zm3pgRk4StJUi7IudT/1vazp/f2FQDMnt
         OsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DKzdEoM6Lmp9JUgVQf/KSYmgH23uDbw/uvQ6/6yRYvE=;
        b=ICmeTXXJ7Fd9ok9hvhBSRazKLF449p1OLtXVLUF2Pf4bXMnJgsTB6uKI2fXCJNXo3o
         nw/z3k4M+NNa96gKui6twxn+3wvfFHhyD6ePqdVY2a+22ICd384BVhXa5pGB4JIrnWIF
         1fJ3fQmzinLU0u7r4uZ88ZGmB0CcGGa/UGqeeQM7MwuqeGDKn7oS2ftu3LbND67sF1h5
         L0/TKMCd0FXroZwJPqnq4YMmWbE0jNEukk2sqwzblX9XD9ytv6eV2VcswYNr2ZEfxm2j
         H9S9TFyUm8bH03kqmquKYh7/kBomYHiYJz93KWWjcfA0f9rTOeKKWGNqCu18K7O/EhaN
         QZmw==
X-Gm-Message-State: APjAAAXAQnybIm7FM2gvkp2PSB1KhhzZupxlprXF3/nEScWcyOHY1WBT
        ykPZ0WIIThUTIeOSXhFCCSI=
X-Google-Smtp-Source: APXvYqzF0cQ+/VJDorqycm3dfNF/lUqKXl/HB8dDHfxrLrzA/xgiZGFxu9LQhnzDpZ2b94QWbbUYow==
X-Received: by 2002:a17:902:9a49:: with SMTP id x9mr24556514plv.282.1562080859248;
        Tue, 02 Jul 2019 08:20:59 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id e10sm14683769pfi.173.2019.07.02.08.20.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 08:20:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/6] gtp: fix suspicious RCU usage
Date:   Wed,  3 Jul 2019 00:20:51 +0900
Message-Id: <20190702152051.22513-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gtp_encap_enable_socket() and gtp_encap_destroy() are not protected
by rcu_read_lock(). and it's not safe to write sk->sk_user_data.
This patch make these functions to use lock_sock() instead of
rcu_dereference_sk_user_data().

Test commands:
    gtp-link add gtp1

Splat looks like:
[   83.238315] =============================
[   83.239127] WARNING: suspicious RCU usage
[   83.239702] 5.2.0-rc6+ #49 Not tainted
[   83.240268] -----------------------------
[   83.241205] drivers/net/gtp.c:799 suspicious rcu_dereference_check() usage!
[   83.243828]
[   83.243828] other info that might help us debug this:
[   83.243828]
[   83.246325]
[   83.246325] rcu_scheduler_active = 2, debug_locks = 1
[   83.247314] 1 lock held by gtp-link/1008:
[   83.248523]  #0: 0000000017772c7f (rtnl_mutex){+.+.}, at: __rtnl_newlink+0x5f5/0x11b0
[   83.251503]
[   83.251503] stack backtrace:
[   83.252173] CPU: 0 PID: 1008 Comm: gtp-link Not tainted 5.2.0-rc6+ #49
[   83.253271] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   83.254562] Call Trace:
[   83.254995]  dump_stack+0x7c/0xbb
[   83.255567]  gtp_encap_enable_socket+0x2df/0x360 [gtp]
[   83.256415]  ? gtp_find_dev+0x1a0/0x1a0 [gtp]
[   83.257161]  ? memset+0x1f/0x40
[   83.257843]  gtp_newlink+0x90/0xa21 [gtp]
[   83.258497]  ? __netlink_ns_capable+0xc3/0xf0
[   83.259260]  __rtnl_newlink+0xb9f/0x11b0
[   83.260022]  ? rtnl_link_unregister+0x230/0x230
[ ... ]

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index fc45b749db46..939da5442f65 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -289,12 +289,14 @@ static void gtp_encap_destroy(struct sock *sk)
 {
 	struct gtp_dev *gtp;
 
-	gtp = rcu_dereference_sk_user_data(sk);
+	lock_sock(sk);
+	gtp = sk->sk_user_data;
 	if (gtp) {
 		udp_sk(sk)->encap_type = 0;
 		rcu_assign_sk_user_data(sk, NULL);
 		sock_put(sk);
 	}
+	release_sock(sk);
 }
 
 static void gtp_encap_disable_sock(struct sock *sk)
@@ -796,7 +798,8 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 		goto out_sock;
 	}
 
-	if (rcu_dereference_sk_user_data(sock->sk)) {
+	lock_sock(sock->sk);
+	if (sock->sk->sk_user_data) {
 		sk = ERR_PTR(-EBUSY);
 		goto out_sock;
 	}
@@ -812,6 +815,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
 
 out_sock:
+	release_sock(sock->sk);
 	sockfd_put(sock);
 	return sk;
 }
-- 
2.17.1

