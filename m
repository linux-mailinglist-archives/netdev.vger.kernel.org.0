Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A94F3CC99E
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhGROnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 10:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhGROnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 10:43:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF895C061762;
        Sun, 18 Jul 2021 07:40:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cu14so9725821pjb.0;
        Sun, 18 Jul 2021 07:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5h/ouo57VgfmtTZNOxTlKh2p8kwjX4qlWDpeGeXNCSw=;
        b=I9+3sBMGCL2qvqLsDeceKsdItH6nNFMc79nKsZ0pwFBLBwJD/DD3RL+oL1Ce9El/+s
         qvU32SB4myxSHRnKqD6bafj8buTU5ezQtRy2Fyp+PeCsmguSpZCQLIrN/8qd99dnJ2K7
         AOaYe2aWcd7wPsIAA5epz1Bh41TxllTtZJoz6aWYJlBqyz/Fx8mSdejrlGg0b4HoEhBT
         MbJOEudVjEwZMNAjZ7l/6mjqP3GRnzriOdqLvbLR1+h/x4PpH79DtUtozA+S9sTJfhG1
         0ojhriragwCFkMaa1nEsOsOC/cH8JIb4tuYoNDsXe9ojYVcVeGZTGVtqnawVWVPC98kj
         sNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5h/ouo57VgfmtTZNOxTlKh2p8kwjX4qlWDpeGeXNCSw=;
        b=FNcC6Op1Dq0Jts2tx8aRYURS9aWjt5Qt+FPaXyg/vvPQCLvAd+0+iySMpJ3uSkAjld
         aYvq5u/RO7PNbeN5DXDwcjVHf1pTFo59Ay4KylGFeW1q2dcedmIfUwm0DLx6j+yzNwRo
         gg+hwAihPxEeqELsUAlWkU6wIQFxDf69NCjiZvEQAgUHp8Zf3WGq8jSy9ZqpKagKTllz
         2xHmESgLUy3TDBc73pB+lB4KccNb4EOywDNhDTJ/TlVE+n9C5nHW7gMCiTaltLKZIvTL
         3CJGGd0ruQcQZKnoemuSXQLJRi8TuSdjOwii7MClyolBKwVTohQePvDAHQxAIqOLfFi9
         6I7g==
X-Gm-Message-State: AOAM530Y3Pzq1p0Nf5CaLpdSYEpRv8kYVp70SjNdi+h88FaWeawqggIJ
        xqrJ9l2BTJu0fr2GpH0thTQ=
X-Google-Smtp-Source: ABdhPJxAC6fn/DP+PNyKXtUIZlqSaYt9k7413pykYoIs1F02KyvnCjQEDOYB4qFjkob/vbIs+8QZyg==
X-Received: by 2002:a17:90b:3652:: with SMTP id nh18mr20777647pjb.127.1626619231296;
        Sun, 18 Jul 2021 07:40:31 -0700 (PDT)
Received: from localhost.localdomain (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id 144sm18740439pgg.4.2021.07.18.07.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 07:40:30 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+10f1194569953b72f1ae@syzkaller.appspotmail.com
Subject: [PATCH] netrom: Decrease sock refcount when sock timers expire
Date:   Sun, 18 Jul 2021 22:40:13 +0800
Message-Id: <20210718144013.753774-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 63346650c1a9 ("netrom: switch to sock timer API") switched to use
sock timer API. It replaces mod_timer() by sk_reset_timer(), and
del_timer() by sk_stop_timer().

Function sk_reset_timer() will increase the refcount of sock if it is
called on an inactive timer, hence, in case the timer expires, we need to
decrease the refcount ourselves in the handler, otherwise, the sock
refcount will be unbalanced and the sock will never be freed.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+10f1194569953b72f1ae@syzkaller.appspotmail.com
Fixes: 63346650c1a9 ("netrom: switch to sock timer API")
---
 net/netrom/nr_timer.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index 9115f8a7dd45..a8da88db7893 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -121,11 +121,9 @@ static void nr_heartbeat_expiry(struct timer_list *t)
 		   is accepted() it isn't 'dead' so doesn't get removed. */
 		if (sock_flag(sk, SOCK_DESTROY) ||
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
-			sock_hold(sk);
 			bh_unlock_sock(sk);
 			nr_destroy_socket(sk);
-			sock_put(sk);
-			return;
+			goto out;
 		}
 		break;

@@ -146,6 +144,8 @@ static void nr_heartbeat_expiry(struct timer_list *t)

 	nr_start_heartbeat(sk);
 	bh_unlock_sock(sk);
+out:
+	sock_put(sk);
 }

 static void nr_t2timer_expiry(struct timer_list *t)
@@ -159,6 +159,7 @@ static void nr_t2timer_expiry(struct timer_list *t)
 		nr_enquiry_response(sk);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }

 static void nr_t4timer_expiry(struct timer_list *t)
@@ -169,6 +170,7 @@ static void nr_t4timer_expiry(struct timer_list *t)
 	bh_lock_sock(sk);
 	nr_sk(sk)->condition &= ~NR_COND_PEER_RX_BUSY;
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }

 static void nr_idletimer_expiry(struct timer_list *t)
@@ -197,6 +199,7 @@ static void nr_idletimer_expiry(struct timer_list *t)
 		sock_set_flag(sk, SOCK_DEAD);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }

 static void nr_t1timer_expiry(struct timer_list *t)
@@ -209,8 +212,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	case NR_STATE_1:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_CONNREQ);
@@ -220,8 +222,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	case NR_STATE_2:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_write_internal(sk, NR_DISCREQ);
@@ -231,8 +232,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	case NR_STATE_3:
 		if (nr->n2count == nr->n2) {
 			nr_disconnect(sk, ETIMEDOUT);
-			bh_unlock_sock(sk);
-			return;
+			goto out;
 		} else {
 			nr->n2count++;
 			nr_requeue_frames(sk);
@@ -241,5 +241,7 @@ static void nr_t1timer_expiry(struct timer_list *t)
 	}

 	nr_start_t1timer(sk);
+out:
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
--
2.25.1

