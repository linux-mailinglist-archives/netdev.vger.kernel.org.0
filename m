Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7106F6B2CB6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 19:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCISNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 13:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCISNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 13:13:17 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FE13755E;
        Thu,  9 Mar 2023 10:13:15 -0800 (PST)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.5])
        by mail.ispras.ru (Postfix) with ESMTPSA id A9A3B4077AEF;
        Thu,  9 Mar 2023 18:13:13 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru A9A3B4077AEF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678385593;
        bh=Pt4ZvSVepTY4Qap6N4dhqvj205nwIIhb0xhp8AbBKag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjyX6FZGRXfAV1eJ7w2xkT1M7eVutjP0juq8E83h/RKgXRajAquMlxAE5WJaPuTZX
         zrOWplieWwRHjjNBGi7akWI60MLLavNT7Q2lqzz4qZkKJlXInlwRZ5aFWbxIRlwrDk
         owqavSuUHRgs6gN+quTzlCRgdIjVFtxQwvf5bOdo=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Marcel Holtmann <marcel@holtmann.org>,
        Nguyen Dinh Phi <phind.uet@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Subject: [PATCH 4.14/4.19/5.4/5.10/5.15 1/1] Bluetooth: hci_sock: purge socket queues in the destruct() callback
Date:   Thu,  9 Mar 2023 21:12:51 +0300
Message-Id: <20230309181251.479447-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230309181251.479447-1-pchelkin@ispras.ru>
References: <20230309181251.479447-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>

commit 709fca500067524381e28a5f481882930eebac88 upstream.

The receive path may take the socket right before hci_sock_release(),
but it may enqueue the packets to the socket queues after the call to
skb_queue_purge(), therefore the socket can be destroyed without clear
its queues completely.

Moving these skb_queue_purge() to the hci_sock_destruct() will fix this
issue, because nothing is referencing the socket at this point.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/bluetooth/hci_sock.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index f1128c2134f0..3f92a21cabe8 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -888,10 +888,6 @@ static int hci_sock_release(struct socket *sock)
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -2012,6 +2008,12 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
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
@@ -2065,6 +2067,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;
-- 
2.34.1

