Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D3B44A21D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbhKIBQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242074AbhKIBMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:12:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B71DC61AA3;
        Tue,  9 Nov 2021 01:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419918;
        bh=/JONvfffwfTk4znqBZLojPu9y4SkBe2Q02WP+DlTd9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjrUYEU4G7ByDytU7tIBCu955b5l2Dbl9fHdr8vzaSiEttruK9s8T0zWTB+nZwgfg
         HT1bJTfhn1d3mBH+2tVDvUjQyYicdf9PHyzlAi5pj8NROsEZJ4G3JCI/3T6fFtcY8U
         173rHgFCZJRpTaBgeksObyUst5bKX8UetCs4XWY4mZ3zm1h2stTmdMau7D3Lk+ku/q
         Ro5OYW6f4R3k+AHr1hqz4O0959Hi/Ol6TcJEr5NR5Tl+ZI5QI56SXGJCbaj/Bg9GmC
         TyDH2tu3CDqBBYLSFCQ4rMa7traFI1EwcwQKs+idTBL0KHmsDjya3oScFVYZ7Ymkje
         gz9pe6gRIEUKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/47] Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()
Date:   Mon,  8 Nov 2021 12:49:46 -0500
Message-Id: <20211108175031.1190422-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index 007a01b08dbe9..d052b454dc4e1 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -280,7 +280,8 @@ static int sco_connect(struct hci_dev *hdev, struct sock *sk)
 	return err;
 }
 
-static int sco_send_frame(struct sock *sk, struct msghdr *msg, int len)
+static int sco_send_frame(struct sock *sk, void *buf, int len,
+			  unsigned int msg_flags)
 {
 	struct sco_conn *conn = sco_pi(sk)->conn;
 	struct sk_buff *skb;
@@ -292,15 +293,11 @@ static int sco_send_frame(struct sock *sk, struct msghdr *msg, int len)
 
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
@@ -714,6 +711,7 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len)
 {
 	struct sock *sk = sock->sk;
+	void *buf;
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -725,14 +723,24 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
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

