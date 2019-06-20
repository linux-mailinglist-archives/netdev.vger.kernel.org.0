Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1CE4CC13
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFTKjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:39:37 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45791 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfFTKjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 06:39:37 -0400
Received: by mail-pl1-f195.google.com with SMTP id bi6so1215427plb.12
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 03:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=G56EJR4CDaOVipFaGpOmwgcg3yfaZR33njgvmNZYV7k=;
        b=F9myMm4Alh7g1D2pSmZChyGaOcXDuYyHJ9vr9xCmtEKS41LRFMxdEYaq3IRG+ViL5s
         7XKH74gsZGdn4u7RqJenR7rfjBFJgCbhoFCEU6NaNz1e3D0xW5fPO2tLcwLPdG9Cch7a
         OGxfrUmCRV2wUQhvRlmXUxBd80ZDkP2ny/6r7KgkxOyKt/Wte8q4sl7bLI44qaz2Hyf8
         e11E7PYk1jbqbcaJ8S8pLa0mxB19snPvJu8OKjxucDEEOhl274BRqbyto/Bk7bivvhK1
         3Yp8gltNgJwpu8hRV0ciry7zj7j6ClQrieQxqFw7vg+h05KiBEWOnuL0qP4Mm3i5xjLk
         ttnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G56EJR4CDaOVipFaGpOmwgcg3yfaZR33njgvmNZYV7k=;
        b=aODjNlUSyy43BTSupZeTVBhKDJVPcrrpia/PVx3nUqesBoLF5wGxyW7tFZ1tGLCeB1
         ldBC4oqsThS6FnJNzXlRsGpiKsTpWfLR3xGb2OJizOFwrZKTeQCTpnMc/CJrD0sZS3nC
         3YZpDNB1eOqRWU46wMeJxVI8wwsuV3zSLR2zI/NdubslRCYw5qiAwpdUmtjTZN8bVUQy
         4Z9nWpJn5PdSDqauzZS4tIEEr1nHzlbw8YZFMLhtE9vADDHK2W9eXCzKSO3+rNN1kh9R
         SWKS273eXfj4S1I7DAeFR+mFGTJdtJLIYqDPJLuC7GR3p2TOtI4ntLmjwf40qrnI+V7e
         r4HQ==
X-Gm-Message-State: APjAAAXh8+B+5EbNfr7gm7WY3FgDBePTljvyUgPSW1D6PDML7IMu3Wac
        FXZ6K9JQ5OUpB2G5D9RLsTNY7hln
X-Google-Smtp-Source: APXvYqzTbfbFvY06aMG3VNEI+CCG/8vkmBEXkuPmkD/YRGYTnbWYxACbRhQ6+RZHjyVRarssLRI/0w==
X-Received: by 2002:a17:902:8205:: with SMTP id x5mr26029583pln.279.1561027176254;
        Thu, 20 Jun 2019 03:39:36 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s64sm21850566pfb.160.2019.06.20.03.39.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 03:39:35 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH net] tipc: change to use register_pernet_device
Date:   Thu, 20 Jun 2019 18:39:28 +0800
Message-Id: <1a8f3ada3e0a65b6e9250c4580a7c420b4ddddac.1561027168.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix a dst defcnt leak, which can be reproduced by doing:

  # ip net a c; ip net a s; modprobe tipc
  # ip net e s ip l a n eth1 type veth peer n eth1 netns c
  # ip net e c ip l s lo up; ip net e c ip l s eth1 up
  # ip net e s ip l s lo up; ip net e s ip l s eth1 up
  # ip net e c ip a a 1.1.1.2/8 dev eth1
  # ip net e s ip a a 1.1.1.1/8 dev eth1
  # ip net e c tipc b e m udp n u1 localip 1.1.1.2
  # ip net e s tipc b e m udp n u1 localip 1.1.1.1
  # ip net d c; ip net d s; rmmod tipc

and it will get stuck and keep logging the error:

  unregister_netdevice: waiting for lo to become free. Usage count = 1

The cause is that a dst is held by the udp sock's sk_rx_dst set on udp rx
path with udp_early_demux == 1, and this dst (eventually holding lo dev)
can't be released as bearer's removal in tipc pernet .exit happens after
lo dev's removal, default_device pernet .exit.

 "There are two distinct types of pernet_operations recognized: subsys and
  device.  At creation all subsys init functions are called before device
  init functions, and at destruction all device exit functions are called
  before subsys exit function."

So by calling register_pernet_device instead to register tipc_net_ops, the
pernet .exit() will be invoked earlier than loopback dev's removal when a
netns is being destroyed, as fou/gue does.

Note that vxlan and geneve udp tunnels don't have this issue, as the udp
sock is released in their device ndo_stop().

This fix is also necessary for tipc dst_cache, which will hold dsts on tx
path and I will introduce in my next patch.

Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index ed536c0..c837072 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -134,7 +134,7 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_sysctl;
 
-	err = register_pernet_subsys(&tipc_net_ops);
+	err = register_pernet_device(&tipc_net_ops);
 	if (err)
 		goto out_pernet;
 
@@ -142,7 +142,7 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_socket;
 
-	err = register_pernet_subsys(&tipc_topsrv_net_ops);
+	err = register_pernet_device(&tipc_topsrv_net_ops);
 	if (err)
 		goto out_pernet_topsrv;
 
@@ -153,11 +153,11 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
-	unregister_pernet_subsys(&tipc_topsrv_net_ops);
+	unregister_pernet_device(&tipc_topsrv_net_ops);
 out_pernet_topsrv:
 	tipc_socket_stop();
 out_socket:
-	unregister_pernet_subsys(&tipc_net_ops);
+	unregister_pernet_device(&tipc_net_ops);
 out_pernet:
 	tipc_unregister_sysctl();
 out_sysctl:
@@ -172,9 +172,9 @@ static int __init tipc_init(void)
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
-	unregister_pernet_subsys(&tipc_topsrv_net_ops);
+	unregister_pernet_device(&tipc_topsrv_net_ops);
 	tipc_socket_stop();
-	unregister_pernet_subsys(&tipc_net_ops);
+	unregister_pernet_device(&tipc_net_ops);
 	tipc_netlink_stop();
 	tipc_netlink_compat_stop();
 	tipc_unregister_sysctl();
-- 
2.1.0

