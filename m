Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B65409BCF
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 20:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346533AbhIMSJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 14:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346508AbhIMSJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 14:09:56 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB4DC061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 11:08:40 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 5so6377037plo.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 11:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rc7hIuppL6cvx8tvXc+DIAlI+K6MbZyPBOAeXSifZP8=;
        b=o4NYcDASsZWPGU5r01O+7Z5wcPDAa6V+KCv23zC424xAMUle4+WmF9aBhoepMgX5aW
         otgn+1tE55j/NeTyreIwy0DXVfcGinJHnqpZAsdNBZ4IUyExPz18Xvssw6OJ2OCaOa43
         boNRdMzuE9am+aDlOF4XgO4z+C6AvpoD3X/eUJ5q4F1bSlNDnQ8bumuY6qNoAbkhgTwY
         CdYRj3Epe7pSbMAIrMVIq7FQCETMhPr8ySDt3kU7y8IqAT92aCeJDPXwILqGYHHc+Fi7
         QYtmRErtlapIissGkKo8qdjbbNR8Doc762TpcYuEA6UygNnMmrM9GOKTCYhwk/0KH9Bm
         4E3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rc7hIuppL6cvx8tvXc+DIAlI+K6MbZyPBOAeXSifZP8=;
        b=qsxQY7PeovAPvue7L3/dvvBOTVnoFjMx7MNsQqKYRZBox8xbyRKdpMNJ5W3NVlA26h
         zLV1Vsuxbp+/AzdPH2jfggYegEp9HH6zxw0ulFhysjz7CxuScLQFffjy8Fs3ngybLjfQ
         2vroJ7PA9fTPHPk0l/PCvro/ImZnvGNYXymOUT51ZZUWKG5zJ4sM2gDVboMxWSlh1qSl
         W61K3Cx4fVZ/jzxDsPX8TdM+IoJcohJ2/h1Y9nvn/eneGYudDm/p2fuXl3uF0f33ecqH
         Og2gIk1kN3FuznoHgekpQ3UsAogKL7Bp8/pynaLKeHZhXdRV2D6uS0/mKbVbhZtYEBj4
         EFWg==
X-Gm-Message-State: AOAM5325z73t5vA4Bp8ZWQ3T64Ih+VYUqG7IEzhtbrQuKU9/Bkr15w3P
        rSEeoaRUwAO++RUI86EkcVM=
X-Google-Smtp-Source: ABdhPJzN3hKRrSPk4GZolyvUDMYTe6hjTb3bT9MxrosuHyvdGQFM2hmzdpGsyWgITa+1TmtL7W73zw==
X-Received: by 2002:a17:90a:cf0d:: with SMTP id h13mr787501pju.61.1631556519918;
        Mon, 13 Sep 2021 11:08:39 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:77da:7605:5a70:a0cd])
        by smtp.gmail.com with ESMTPSA id l22sm9395955pgo.45.2021.09.13.11.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 11:08:39 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] net-caif: avoid user-triggerable WARN_ON(1)
Date:   Mon, 13 Sep 2021 11:08:36 -0700
Message-Id: <20210913180836.3943779-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syszbot triggers this warning, which looks something
we can easily prevent.

If we initialize priv->list_field in chnl_net_init(),
then always use list_del_init(), we can remove robust_list_del()
completely.

WARNING: CPU: 0 PID: 3233 at net/caif/chnl_net.c:67 robust_list_del net/caif/chnl_net.c:67 [inline]
WARNING: CPU: 0 PID: 3233 at net/caif/chnl_net.c:67 chnl_net_uninit+0xc9/0x2e0 net/caif/chnl_net.c:375
Modules linked in:
CPU: 0 PID: 3233 Comm: syz-executor.3 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:robust_list_del net/caif/chnl_net.c:67 [inline]
RIP: 0010:chnl_net_uninit+0xc9/0x2e0 net/caif/chnl_net.c:375
Code: 89 eb e8 3a a3 ba f8 48 89 d8 48 c1 e8 03 42 80 3c 28 00 0f 85 bf 01 00 00 48 81 fb 00 14 4e 8d 48 8b 2b 75 d0 e8 17 a3 ba f8 <0f> 0b 5b 5d 41 5c 41 5d e9 0a a3 ba f8 4c 89 e3 e8 02 a3 ba f8 4c
RSP: 0018:ffffc90009067248 EFLAGS: 00010202
RAX: 0000000000008780 RBX: ffffffff8d4e1400 RCX: ffffc9000fd34000
RDX: 0000000000040000 RSI: ffffffff88bb6e49 RDI: 0000000000000003
RBP: ffff88802cd9ee08 R08: 0000000000000000 R09: ffffffff8d0e6647
R10: ffffffff88bb6dc2 R11: 0000000000000000 R12: ffff88803791ae08
R13: dffffc0000000000 R14: 00000000e600ffce R15: ffff888073ed3480
FS:  00007fed10fa0700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2c322000 CR3: 00000000164a6000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 register_netdevice+0xadf/0x1500 net/core/dev.c:10347
 ipcaif_newlink+0x4c/0x260 net/caif/chnl_net.c:468
 __rtnl_newlink+0x106d/0x1750 net/core/rtnetlink.c:3458
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 __sys_sendto+0x21c/0x320 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: cc36a070b590 ("net-caif: add CAIF netdevice")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/caif/chnl_net.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 37b67194c0dfe412d51b92d9b5f8513e5b2db34a..414dc5671c45edb447342b934683b0eaf1695b39 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -53,20 +53,6 @@ struct chnl_net {
 	enum caif_states state;
 };
 
-static void robust_list_del(struct list_head *delete_node)
-{
-	struct list_head *list_node;
-	struct list_head *n;
-	ASSERT_RTNL();
-	list_for_each_safe(list_node, n, &chnl_net_list) {
-		if (list_node == delete_node) {
-			list_del(list_node);
-			return;
-		}
-	}
-	WARN_ON(1);
-}
-
 static int chnl_recv_cb(struct cflayer *layr, struct cfpkt *pkt)
 {
 	struct sk_buff *skb;
@@ -364,6 +350,7 @@ static int chnl_net_init(struct net_device *dev)
 	ASSERT_RTNL();
 	priv = netdev_priv(dev);
 	strncpy(priv->name, dev->name, sizeof(priv->name));
+	INIT_LIST_HEAD(&priv->list_field);
 	return 0;
 }
 
@@ -372,7 +359,7 @@ static void chnl_net_uninit(struct net_device *dev)
 	struct chnl_net *priv;
 	ASSERT_RTNL();
 	priv = netdev_priv(dev);
-	robust_list_del(&priv->list_field);
+	list_del_init(&priv->list_field);
 }
 
 static const struct net_device_ops netdev_ops = {
@@ -537,7 +524,7 @@ static void __exit chnl_exit_module(void)
 	rtnl_lock();
 	list_for_each_safe(list_node, _tmp, &chnl_net_list) {
 		dev = list_entry(list_node, struct chnl_net, list_field);
-		list_del(list_node);
+		list_del_init(list_node);
 		delete_device(dev);
 	}
 	rtnl_unlock();
-- 
2.33.0.309.g3052b89438-goog

