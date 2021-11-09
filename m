Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8344A319
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbhKIBZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243189AbhKIBVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59FC861381;
        Tue,  9 Nov 2021 01:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420090;
        bh=F3dmZxdvQ2jpzrZHz4xGkd3iVO1+ehXqGikQQadSO3s=;
        h=From:To:Cc:Subject:Date:From;
        b=pk7qwIG5U+vvRXld++/R9E3QXuPrZeKEZ4cr62l1IvJVoDgciuXhsbjCZfVgjKI5E
         kQUhm1GyhBw19i9rJ5uPk1u5NzIOseKfHYBRVshky3aioMXQ+I3f4+H2n/EohwU1r4
         k6fOp+AkLTTejXmp8zJVCD+9E9h49o4Zv83H6c6NucuVixPfVE40YyzfHf1NgJufRy
         jLRz5vS0Ql+Dr6GhjJHQqKRjnN9y7Apqv0ivoLvdDX/CauHPF1x8b9ZRjfihGoPbDu
         EYdf/616FfAdFsNvA/MaMA0JLwsncLsaMjFawxbZDQwY6LyKfIPdMFXVizi0sZ7/3e
         J4suoHFHzSxPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/33] Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()
Date:   Mon,  8 Nov 2021 20:07:35 -0500
Message-Id: <20211109010807.1191567-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 99c23da0eed4fd20cae8243f2b51e10e66aa0951 ]

The sco_send_frame() also takes lock_sock() during memcpy_from_msg()
call that may be endlessly blocked by a task with userfaultd
technique, and this will result in a hung task watchdog trigger.

Just like the similar fix for hci_sock_sendmsg() in commit
92c685dc5de0 ("Bluetooth: reorganize functions..."), this patch moves
the  memcpy_from_msg() out of lock_sock() for addressing the hang.

This should be the last piece for fixing CVE-2021-3640 after a few
already queued fixes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 77f88c7df6053..b3b4ffaa394f6 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -254,7 +254,8 @@ static int sco_connect(struct hci_dev *hdev, struct sock *sk)
 	return err;
 }
 
-static int sco_send_frame(struct sock *sk, struct msghdr *msg, int len)
+static int sco_send_frame(struct sock *sk, void *buf, int len,
+			  unsigned int msg_flags)
 {
 	struct sco_conn *conn = sco_pi(sk)->conn;
 	struct sk_buff *skb;
@@ -266,15 +267,11 @@ static int sco_send_frame(struct sock *sk, struct msghdr *msg, int len)
 
 	BT_DBG("sk %p len %d", sk, len);
 
-	skb = bt_skb_send_alloc(sk, len, msg->msg_flags & MSG_DONTWAIT, &err);
+	skb = bt_skb_send_alloc(sk, len, msg_flags & MSG_DONTWAIT, &err);
 	if (!skb)
 		return err;
 
-	if (memcpy_from_msg(skb_put(skb, len), msg, len)) {
-		kfree_skb(skb);
-		return -EFAULT;
-	}
-
+	memcpy(skb_put(skb, len), buf, len);
 	hci_send_sco(conn->hcon, skb);
 
 	return len;
@@ -693,6 +690,7 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len)
 {
 	struct sock *sk = sock->sk;
+	void *buf;
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -704,14 +702,24 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (memcpy_from_msg(buf, msg, len)) {
+		kfree(buf);
+		return -EFAULT;
+	}
+
 	lock_sock(sk);
 
 	if (sk->sk_state == BT_CONNECTED)
-		err = sco_send_frame(sk, msg, len);
+		err = sco_send_frame(sk, buf, len, msg->msg_flags);
 	else
 		err = -ENOTCONN;
 
 	release_sock(sk);
+	kfree(buf);
 	return err;
 }
 
-- 
2.33.0

