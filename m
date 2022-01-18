Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEEE4913FC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244329AbiARCTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiARCTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:19:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF981C061574;
        Mon, 17 Jan 2022 18:19:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 360E6612BE;
        Tue, 18 Jan 2022 02:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55668C36AEB;
        Tue, 18 Jan 2022 02:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472383;
        bh=ePBaW9YD9SIwvLA46ELgC5rC7fjkynIpw6UKXVSMxew=;
        h=From:To:Cc:Subject:Date:From;
        b=PYHkxLtkipoa2E6HucbExx9mFwwJ951fWgG9pgCl9/kpovqMGWqAVlHVSoiX5VtPA
         E5T/8wYB6K0BSkB3Pb4iSS61UcxjnRppneHNS7ztptpZPT8/Tkd5C0GVNHv72nHulN
         Ot61ANhQomBsuFxv24JbiHpKrl3PupMPrjlsxcyjbFCuqpTaLxPJZWvPm4WUXt30qR
         07sYJW7oTFlJ5jV1UEFLyTHT/4HWfz0L0plpmZnt2V4X3G/6pT1MZ7HnQZbyTBWG/P
         oG5tO/ZiYv0cZ1qUm4WnUMvUohAPNu4sBaB/hOMIPbCNhaBAFjrxbfjwB/zRTGxJHX
         +dehexyopM7Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>,
        syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 001/217] Bluetooth: hci_sock: purge socket queues in the destruct() callback
Date:   Mon, 17 Jan 2022 21:16:04 -0500
Message-Id: <20220118021940.1942199-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>

[ Upstream commit 709fca500067524381e28a5f481882930eebac88 ]

The receive path may take the socket right before hci_sock_release(),
but it may enqueue the packets to the socket queues after the call to
skb_queue_purge(), therefore the socket can be destroyed without clear
its queues completely.

Moving these skb_queue_purge() to the hci_sock_destruct() will fix this
issue, because nothing is referencing the socket at this point.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sock.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d0dad1fafe079..446573a125711 100644
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
2.34.1

