Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5265C14C06E
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 19:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgA1Sy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 13:54:29 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:53250 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgA1SyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 13:54:25 -0500
Received: by mail-pf1-f202.google.com with SMTP id c17so963099pfi.20
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 10:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LbDTiPWVh2Qq5foi37sJFb+KsRGTnNFnk1CotalxKRA=;
        b=DohQe0ejifkTBADJN4Db02nIq6lRvM4Xw8JkruUg/Tj+3D5xGSsK6mod4Bi+4BtDSL
         EWf0oJVtWdlFQ0HhnKjvr2dqNXKyreI4Mc0sBUTawJmL0phIQobqIdHU/XPRJqHF2YP3
         4eXyvvgIw37R5WtSFYV9/tXX6LbhmeE1Z4i6UcFo3C7DuvURoxo7jLD3ug1xtaFK/03W
         M3nYESFnsxWbVng/xDoujrQWQwO7qmLWyuVGOfw+8+Ipbyz4Gqt04T09m5TScDSTAgvP
         vOvSh0HqzbMDSz/Q53Z/okCmOt9FvziDMxBeas6L9XL120tGmSitCzDmRx4QLiFVtd8W
         8p6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LbDTiPWVh2Qq5foi37sJFb+KsRGTnNFnk1CotalxKRA=;
        b=atheDweYEa+3rImJGn2ZEJJ2SfLQjFu7xUF+7x+RqKemDM1BFMhzosQzqDkW0uNZSA
         D/1UIfXJZ7RUhYYznCblADDuIYyUZpEKbmMcCear1k2J7wq7ba8K2qy+JXqlHTiyt2Us
         nXRj3zGCnQyufUUQ1WkQD7C2kqs04RTDtfiAO8Hil7TxYaOWrvhYQ1nwNh9M+vNVD+r2
         DAmXVRsqEyLT5Hl/Vbw7YZlG2f3GTZVfZSWoK00M2ZkM0RhK4R0q6mIjvvfyGGiylCUP
         NQOYgKm5sCV30Rj3gFwK8UK7ZpIBodv4rOTat/uU+pVMhlrrgd7u+9U9sLMU+XD9XTL9
         SjSA==
X-Gm-Message-State: APjAAAU0uTbFUslxO39ttSRo5mOkrPR9ApyXitrBxPx7kEiGlp8KfLU9
        jcfwT1BPVTvzHeg09Mqu9TIIA/EPJOMYhg==
X-Google-Smtp-Source: APXvYqyK/6wCT/mTPrR4EawFmZoRdscXKvoE+wJYU6Idai+Lw83amCiJ4RuwIEoVmYywqquXhHt8NZy7BkOb3Q==
X-Received: by 2002:a65:578e:: with SMTP id b14mr26340514pgr.444.1580237664492;
 Tue, 28 Jan 2020 10:54:24 -0800 (PST)
Date:   Tue, 28 Jan 2020 10:54:14 -0800
In-Reply-To: <20200128185414.158541-1-mmandlik@google.com>
Message-Id: <20200128105322.1.If741898c727a5d948cbb10fdf9225b84efd443c8@changeid>
Mime-Version: 1.0
References: <20200128185414.158541-1-mmandlik@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH 1/1] Bluetooth: Fix refcount use-after-free issue
From:   Manish Mandlik <mmandlik@google.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Yoni Shavit <yshavit@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        Alain Michaud <alainmichaud@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

 net/bluetooth/l2cap_core.c | 26 +++++++++++++++-----------
 net/bluetooth/l2cap_sock.c | 16 +++++++++++++---
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 195459a1e53e..dd2021270b8a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -419,6 +419,9 @@ static void l2cap_chan_timeout(struct work_struct *work)
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
 	mutex_lock(&conn->chan_lock);
+	/* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling
+	 * this work. No need to call l2cap_chan_hold(chan) here again.
+	 */
 	l2cap_chan_lock(chan);
 
 	if (chan->state == BT_CONNECTED || chan->state == BT_CONFIG)
@@ -431,12 +434,12 @@ static void l2cap_chan_timeout(struct work_struct *work)
 
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
@@ -1737,9 +1740,9 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 
 		l2cap_chan_del(chan, err);
 
-		l2cap_chan_unlock(chan);
-
 		chan->ops->close(chan);
+
+		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
 	}
 
@@ -4405,6 +4408,7 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 		return 0;
 	}
 
+	l2cap_chan_hold(chan);
 	l2cap_chan_lock(chan);
 
 	rsp.dcid = cpu_to_le16(chan->scid);
@@ -4413,12 +4417,11 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
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
@@ -4450,20 +4453,21 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
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
index a7be8b59b3c2..ab65304f3f63 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1042,7 +1042,7 @@ static int l2cap_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 
 /* Kill socket (only if zapped and orphan)
- * Must be called on unlocked socket.
+ * Must be called on unlocked socket, with l2cap channel lock.
  */
 static void l2cap_sock_kill(struct sock *sk)
 {
@@ -1203,8 +1203,15 @@ static int l2cap_sock_release(struct socket *sock)
 
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
 
@@ -1222,12 +1229,15 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
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
2.25.0.341.g760bfbb309-goog

