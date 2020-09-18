Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAE426EE60
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgIRC2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgIRCP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F10AB235F7;
        Fri, 18 Sep 2020 02:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395327;
        bh=M1/GztjogkDW1sQaySry20+xtBUmFDGE9cLdO4u6RNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE3QN8pX3BIMXsME1BdpLFU+Vi3pVBK5xK5ZPWQcChLE3HyrQL3SSamQAjO+A5dbO
         3Ipe14jkys1pi/5hHKj07VFuM/COH2to2cunbhuORJWSu8BTvEuIus4XAMz7AeZsO2
         6dL0hmFW8V7cwox8lhW9Y/xXhAzFatdc9Pn5Ol2A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Mandlik <mmandlik@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 28/90] Bluetooth: Fix refcount use-after-free issue
Date:   Thu, 17 Sep 2020 22:13:53 -0400
Message-Id: <20200918021455.2067301-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Mandlik <mmandlik@google.com>

[ Upstream commit 6c08fc896b60893c5d673764b0668015d76df462 ]

There is no lock preventing both l2cap_sock_release() and
chan->ops->close() from running at the same time.

If we consider Thread A running l2cap_chan_timeout() and Thread B running
l2cap_sock_release(), expected behavior is:
  A::l2cap_chan_timeout()->l2cap_chan_close()->l2cap_sock_teardown_cb()
  A::l2cap_chan_timeout()->l2cap_sock_close_cb()->l2cap_sock_kill()
  B::l2cap_sock_release()->sock_orphan()
  B::l2cap_sock_release()->l2cap_sock_kill()

where,
sock_orphan() clears "sk->sk_socket" and l2cap_sock_teardown_cb() marks
socket as SOCK_ZAPPED.

In l2cap_sock_kill(), there is an "if-statement" that checks if both
sock_orphan() and sock_teardown() has been run i.e. sk->sk_socket is NULL
and socket is marked as SOCK_ZAPPED. Socket is killed if the condition is
satisfied.

In the race condition, following occurs:
  A::l2cap_chan_timeout()->l2cap_chan_close()->l2cap_sock_teardown_cb()
  B::l2cap_sock_release()->sock_orphan()
  B::l2cap_sock_release()->l2cap_sock_kill()
  A::l2cap_chan_timeout()->l2cap_sock_close_cb()->l2cap_sock_kill()

In this scenario, "if-statement" is true in both B::l2cap_sock_kill() and
A::l2cap_sock_kill() and we hit "refcount: underflow; use-after-free" bug.

Similar condition occurs at other places where teardown/sock_kill is
happening:
  l2cap_disconnect_rsp()->l2cap_chan_del()->l2cap_sock_teardown_cb()
  l2cap_disconnect_rsp()->l2cap_sock_close_cb()->l2cap_sock_kill()

  l2cap_conn_del()->l2cap_chan_del()->l2cap_sock_teardown_cb()
  l2cap_conn_del()->l2cap_sock_close_cb()->l2cap_sock_kill()

  l2cap_disconnect_req()->l2cap_chan_del()->l2cap_sock_teardown_cb()
  l2cap_disconnect_req()->l2cap_sock_close_cb()->l2cap_sock_kill()

  l2cap_sock_cleanup_listen()->l2cap_chan_close()->l2cap_sock_teardown_cb()
  l2cap_sock_cleanup_listen()->l2cap_sock_kill()

Protect teardown/sock_kill and orphan/sock_kill by adding hold_lock on
l2cap channel to ensure that the socket is killed only after marked as
zapped and orphan.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 26 +++++++++++++++-----------
 net/bluetooth/l2cap_sock.c | 16 +++++++++++++---
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 11012a5090708..de085947c19c2 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -414,6 +414,9 @@ static void l2cap_chan_timeout(struct work_struct *work)
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
 	mutex_lock(&conn->chan_lock);
+	/* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling
+	 * this work. No need to call l2cap_chan_hold(chan) here again.
+	 */
 	l2cap_chan_lock(chan);
 
 	if (chan->state == BT_CONNECTED || chan->state == BT_CONFIG)
@@ -426,12 +429,12 @@ static void l2cap_chan_timeout(struct work_struct *work)
 
 	l2cap_chan_close(chan, reason);
 
-	l2cap_chan_unlock(chan);
-
 	chan->ops->close(chan);
-	mutex_unlock(&conn->chan_lock);
 
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
+
+	mutex_unlock(&conn->chan_lock);
 }
 
 struct l2cap_chan *l2cap_chan_create(void)
@@ -1725,9 +1728,9 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 
 		l2cap_chan_del(chan, err);
 
-		l2cap_chan_unlock(chan);
-
 		chan->ops->close(chan);
+
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 	}
 
@@ -4327,6 +4330,7 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 		return 0;
 	}
 
+	l2cap_chan_hold(chan);
 	l2cap_chan_lock(chan);
 
 	rsp.dcid = cpu_to_le16(chan->scid);
@@ -4335,12 +4339,11 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
 	chan->ops->set_shutdown(chan);
 
-	l2cap_chan_hold(chan);
 	l2cap_chan_del(chan, ECONNRESET);
 
-	l2cap_chan_unlock(chan);
-
 	chan->ops->close(chan);
+
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
 	mutex_unlock(&conn->chan_lock);
@@ -4372,20 +4375,21 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 		return 0;
 	}
 
+	l2cap_chan_hold(chan);
 	l2cap_chan_lock(chan);
 
 	if (chan->state != BT_DISCONN) {
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
 	l2cap_chan_del(chan, 0);
 
-	l2cap_chan_unlock(chan);
-
 	chan->ops->close(chan);
+
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
 	mutex_unlock(&conn->chan_lock);
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index a8ba752732c98..3db8cfebd069a 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1038,7 +1038,7 @@ done:
 }
 
 /* Kill socket (only if zapped and orphan)
- * Must be called on unlocked socket.
+ * Must be called on unlocked socket, with l2cap channel lock.
  */
 static void l2cap_sock_kill(struct sock *sk)
 {
@@ -1199,8 +1199,15 @@ static int l2cap_sock_release(struct socket *sock)
 
 	err = l2cap_sock_shutdown(sock, 2);
 
+	l2cap_chan_hold(l2cap_pi(sk)->chan);
+	l2cap_chan_lock(l2cap_pi(sk)->chan);
+
 	sock_orphan(sk);
 	l2cap_sock_kill(sk);
+
+	l2cap_chan_unlock(l2cap_pi(sk)->chan);
+	l2cap_chan_put(l2cap_pi(sk)->chan);
+
 	return err;
 }
 
@@ -1218,12 +1225,15 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
 		BT_DBG("child chan %p state %s", chan,
 		       state_to_string(chan->state));
 
+		l2cap_chan_hold(chan);
 		l2cap_chan_lock(chan);
+
 		__clear_chan_timer(chan);
 		l2cap_chan_close(chan, ECONNRESET);
-		l2cap_chan_unlock(chan);
-
 		l2cap_sock_kill(sk);
+
+		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 }
 
-- 
2.25.1

