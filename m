Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405DD425B4D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243861AbhJGTGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbhJGTGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:06:23 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B948C061570;
        Thu,  7 Oct 2021 12:04:29 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s75so699238pgs.5;
        Thu, 07 Oct 2021 12:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mOdDUK0yJ3uQFwhSQJDO4d6YpI2NOJDULvWFd8/xqZY=;
        b=GkoBh4jHzExfAoI2V8vm59ZJ5Z9aLcMgolxvOnW+rm8JECz817t83MuEYgfDe+lAyt
         C0whHGQ30eX0BFyj3sJl78AdyrJ8TUpzVm0aQ8bUxFiPONoDDuKqAHDGpeLdvrauipRb
         S3Ex+eKYknMsL8syMwQAmPnaoWsy7e9RYMj+d4j9MNZaB2tr4bou3joYgY8AA6MNiCz9
         lazUxjvJw2Qu3t8WdglF9pD6U/uQdYSp/uW53VD9AGkV6Ez9BQvGwqWn+2wUcNMY5M/l
         Paz0/ivEX7NJZ5jwhRY+X5frNsX6Azdz9ohkPk+Uja9RyC0zjJQu7hUBPwf1jnebmZL+
         Ug3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mOdDUK0yJ3uQFwhSQJDO4d6YpI2NOJDULvWFd8/xqZY=;
        b=chinJ/0d3tc0qeoDkkoSEnxu0ED263a0TglNL7uo9JdrLm9Qx0jAFjbcujHiqfOCM9
         qY97f4dl4+YMF3cyNJT/YZj6hfcFcHFFjafb4fBiv4aczm2bjlyL4puKyiBZd9xeHvQg
         gBpl07NIo4eiznqkYuul8+pb3vDmOEzlKgaZt8eUcvBua49YRuEzpUalAAzQaM7Dtf4L
         pXUEs8RzZ7ZZioYNRDL3xyCqGQYlOa0YgJkfvylZd9I65lUWb1noP9pPAnZh0/ChBPAo
         1bx5dK1JSwczMWULQUWdsZKIOb1qPrFBsZW73Fl8Wo328U2ma+wkGwsupCpVvgJLw/kX
         7gfw==
X-Gm-Message-State: AOAM533lanLu7r9UehwJOwvLBHXeJ+xkRSHBVj3M3eCnBxnf+7GOBkOG
        XOAkV09TY4Lvo2k3A7/q8bU=
X-Google-Smtp-Source: ABdhPJy4Z/2SFAtOCnw2xD5a1CT70zeopUGODXNuEOeu0pDOEGOOfA3IR+mf/iA/Rq6Zd2KlPDwvsg==
X-Received: by 2002:a63:2b8c:: with SMTP id r134mr1049130pgr.420.1633633469149;
        Thu, 07 Oct 2021 12:04:29 -0700 (PDT)
Received: from localhost.localdomain (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id k190sm164396pfd.211.2021.10.07.12.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:04:28 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Subject: [PATCH] Bluetooth: hci_sock: purge socket queues in the destruct() callback
Date:   Fri,  8 Oct 2021 03:04:24 +0800
Message-Id: <20211007190424.196281-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The receive path may take the socket right before hci_sock_release(),
but it may enqueue the packets to the socket queues after the call to
skb_queue_purge(), therefore the socket can be destroyed without clear
its queues completely.

Moving these skb_queue_purge() to the hci_sock_destruct() will fix this
issue, because nothing is referencing the socket at this point.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
---
 net/bluetooth/hci_sock.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d0dad1fafe07..446573a12571 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -889,10 +889,6 @@ static int hci_sock_release(struct socket *sock)
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -2058,6 +2054,12 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
 	return err;
 }
 
+static void hci_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_write_queue);
+}
+
 static const struct proto_ops hci_sock_ops = {
 	.family		= PF_BLUETOOTH,
 	.owner		= THIS_MODULE,
@@ -2111,6 +2113,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;
-- 
2.25.1

