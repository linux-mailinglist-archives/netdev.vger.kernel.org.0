Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B490F1F9B84
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbgFOPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFOPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:08:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCF3C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:08:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ga6so6963042pjb.1
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FZeA9UJwwLa5SWg2XkX4pcLkXrux9nlY8KoF84Uak6U=;
        b=uzB8fO2OiptjlpvD7fQ9jN7wZUNoJTSaxECeQth149lsK+dPZlQdK2hJw5sQ2ygVcN
         kjxiEsafPfBm7LBXM8yW59ZZIEPboNAzkg2uhU8TANNu7smQX/DVI1fB+hHi+THIhnQc
         /VrRH0XGnzfgDRHe4W6XkbigUjOYQHqgoPgF309AKXnEuKVZRilWrZyHEAAc56vjSnav
         1MkIMA5rpW3QrAWFgDvDAIK/QjUAdOI72UACswEThgU6axhqZY4g62Dd8nuKlQLcB1UZ
         BsNUClNp5LNWzk6MTx2TP8AIDHiriR6F1ABtPdZJyAxVo66zg0DflaWRXBVIxn4duN3v
         AHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FZeA9UJwwLa5SWg2XkX4pcLkXrux9nlY8KoF84Uak6U=;
        b=Qvv6AWUUn8jOvWWDga/LRqw/DxCQBIFDLgGWI0IxKextU1o0Q8K9MAUzucL27IHSl+
         hdZc+wUoUQNRr4msB575bYd4tN2UJ1x41FQIykTkanosnRTpZYTmTis2yGNXp2yfHlE6
         +y/H8BhczdobAkWJsZke1RjH9ZwziN02erO/8BrYStYqe8r4v8tUDoVNmtQi5n+ViUnM
         CFQEDOXA7ond7NNAYr3dwtP4Z8VOQ75ZyMxzD+G6ffe/HqfkwSPHEW2Bt/0WK+cFzrRA
         0ES4LcYODL/RXl9ebgxEE6R/oVnzTVCAtqDL7B1mSmRApZy4tc+A61DulHTbzpyaYSIG
         jArw==
X-Gm-Message-State: AOAM530yV0Ew5U4G0G1xxyXwNcnXteQcqpkgrsTqEJ8tZVu2r9slqu2I
        qLLT4DUeziQRJ5GbaENnzWnudIHCpKM=
X-Google-Smtp-Source: ABdhPJyPwYeEbCmgvnavlxbvEWLO1tUMoyJYlkAG9lyTGffUfFPae5icAoKi7hTzVL7t2ZZXrpOomw==
X-Received: by 2002:a17:90a:fa04:: with SMTP id cm4mr12501119pjb.218.1592233700131;
        Mon, 15 Jun 2020 08:08:20 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id g6sm14297240pfb.164.2020.06.15.08.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 08:08:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, xeb@mail.ru
Subject: [PATCH net] ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
Date:   Mon, 15 Jun 2020 15:07:51 +0000
Message-Id: <20200615150751.21813-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the datapath, the ip6gre_tunnel_lookup() is used and it internally uses
fallback tunnel device pointer, which is fb_tunnel_dev.
This pointer is protected by RTNL. It's not enough to be used
in the datapath.
So, this pointer would be used after an interface is deleted.
It eventually results in the use-after-free problem.

In order to avoid the problem, the new tunnel pointer variable is added,
which indicates a fallback tunnel device's tunnel pointer.
This is protected by both RTNL and RCU.
So, it's safe to be used in the datapath.

Test commands:
    ip netns add A
    ip netns add B
    ip link add eth0 type veth peer name eth1
    ip link set eth0 netns A
    ip link set eth1 netns B

    ip netns exec A ip link set lo up
    ip netns exec A ip link set eth0 up
    ip netns exec A ip link add ip6gre1 type ip6gre local fc:0::1 \
	    remote fc:0::2
    ip netns exec A ip -6 a a fc:100::1/64 dev ip6gre1
    ip netns exec A ip link set ip6gre1 up
    ip netns exec A ip -6 a a fc:0::1/64 dev eth0
    ip netns exec A ip link set ip6gre0 up

    ip netns exec B ip link set lo up
    ip netns exec B ip link set eth1 up
    ip netns exec B ip link add ip6gre1 type ip6gre local fc:0::2 \
	    remote fc:0::1
    ip netns exec B ip -6 a a fc:100::2/64 dev ip6gre1
    ip netns exec B ip link set ip6gre1 up
    ip netns exec B ip -6 a a fc:0::2/64 dev eth1
    ip netns exec B ip link set ip6gre0 up
    ip netns exec A ping fc:100::2 -s 60000 &
    ip netns del B

Splat looks like:
[   73.087285][    C1] BUG: KASAN: use-after-free in ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.088361][    C1] Read of size 4 at addr ffff888040559218 by task ping/1429
[   73.089317][    C1]
[   73.089638][    C1] CPU: 1 PID: 1429 Comm: ping Not tainted 5.7.0+ #602
[   73.090531][    C1] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   73.091725][    C1] Call Trace:
[   73.092160][    C1]  <IRQ>
[   73.092556][    C1]  dump_stack+0x96/0xdb
[   73.093122][    C1]  print_address_description.constprop.6+0x2cc/0x450
[   73.094016][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.094894][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.095767][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.096619][    C1]  kasan_report+0x154/0x190
[   73.097209][    C1]  ? ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.097989][    C1]  ip6gre_tunnel_lookup+0x1064/0x13f0 [ip6_gre]
[   73.098750][    C1]  ? gre_del_protocol+0x60/0x60 [gre]
[   73.099500][    C1]  gre_rcv+0x1c5/0x1450 [ip6_gre]
[   73.100199][    C1]  ? ip6gre_header+0xf00/0xf00 [ip6_gre]
[   73.100985][    C1]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   73.101830][    C1]  ? ip6_input_finish+0x5/0xf0
[   73.102483][    C1]  ip6_protocol_deliver_rcu+0xcbb/0x1510
[   73.103296][    C1]  ip6_input_finish+0x5b/0xf0
[   73.103920][    C1]  ip6_input+0xcd/0x2c0
[   73.104473][    C1]  ? ip6_input_finish+0xf0/0xf0
[   73.105115][    C1]  ? rcu_read_lock_held+0x90/0xa0
[   73.105783][    C1]  ? rcu_read_lock_sched_held+0xc0/0xc0
[   73.106548][    C1]  ipv6_rcv+0x1f1/0x300
[ ... ]

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/ip6_gre.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 781ca8c07a0d..6506ade70f3f 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -67,6 +67,7 @@ struct ip6gre_net {
 
 	struct ip6_tnl __rcu *collect_md_tun;
 	struct ip6_tnl __rcu *collect_md_tun_erspan;
+	struct ip6_tnl __rcu *fb_tun;
 	struct net_device *fb_tunnel_dev;
 };
 
@@ -238,9 +239,9 @@ static struct ip6_tnl *ip6gre_tunnel_lookup(struct net_device *dev,
 	if (t && t->dev->flags & IFF_UP)
 		return t;
 
-	dev = ign->fb_tunnel_dev;
-	if (dev && dev->flags & IFF_UP)
-		return netdev_priv(dev);
+	t = rcu_dereference(ign->fb_tun);
+	if (t && t->dev->flags & IFF_UP)
+		return t;
 
 	return NULL;
 }
@@ -411,8 +412,12 @@ static void ip6gre_tunnel_uninit(struct net_device *dev)
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct ip6gre_net *ign = net_generic(t->net, ip6gre_net_id);
 
-	ip6gre_tunnel_unlink_md(ign, t);
-	ip6gre_tunnel_unlink(ign, t);
+	if (dev == ign->fb_tunnel_dev) {
+		RCU_INIT_POINTER(ign->fb_tun, NULL);
+	} else {
+		ip6gre_tunnel_unlink_md(ign, t);
+		ip6gre_tunnel_unlink(ign, t);
+	}
 	dst_cache_reset(&t->dst_cache);
 	dev_put(dev);
 }
@@ -1584,7 +1589,7 @@ static int __net_init ip6gre_init_net(struct net *net)
 	if (err)
 		goto err_reg_dev;
 
-	rcu_assign_pointer(ign->tunnels_wc[0],
+	rcu_assign_pointer(ign->fb_tun,
 			   netdev_priv(ign->fb_tunnel_dev));
 	return 0;
 
-- 
2.17.1

