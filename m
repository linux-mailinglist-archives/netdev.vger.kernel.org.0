Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23FF421615
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbhJDSJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237204AbhJDSJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 14:09:38 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FC0C061749;
        Mon,  4 Oct 2021 11:07:48 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id o13so4759355qvm.4;
        Mon, 04 Oct 2021 11:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3QLRBnlfCqX2LvH6/cwNoAHr59KmaOODAsySygeibY=;
        b=OJ8PLEunSwPZKORkMuOpeW6CX38s1RDmYRB6ek1VKG291XcUuTsJqFT295cKpMsdhj
         QrDa6XDEjyk04XCU5ZXTFOsex++fngtsQ6EH8Fd4SwYVzfikiQ0YWsKXM1tYLyAbpYi5
         WOdVAl7Nlbl0xpI5GEy19TGFw1bzXGn1tSNmVbnjSd50/I5ZELMGwFKCRP19hM3rEPEa
         IemVyP2JrC9cZBg59gj3uJzy1GmsS3zNvCTPwsEjE9hOiRQ8Kr0LgXGgMbcDjGa4MFsw
         o6nBqXeOnKvTPvUc931G9rXZ7StBqvS9suaXK4ZlWlUtV4881q7Po9SjvQ2lkxaLhk2b
         vphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3QLRBnlfCqX2LvH6/cwNoAHr59KmaOODAsySygeibY=;
        b=rvskgCKdSjs+AzT39NIgG821bQYB6RHA1ewKPOaw0OyK+vDTglyu2WX3dqlxW0bb4j
         P1Vw/PPGTf1f/Vch9noKWOAGoBs5QBuBrmciUZEMwcL1J//0gA7fU1I+PjLa2TF+aTC3
         szQbsJuiRMwD2ieUfMsW/oAeSA8OebW5gLk9PIaXdsjwEaYgzX2kXBSn7/BXINf58Ke/
         DV6+uECyjDEk9Vp59Yy2qJtIBBItdhvn4FTBd1uQ58aJE4i4Px5l9SBMjF0ot7D7XdSJ
         9nYxfZE2PvLGnV0wm0RoCREfVoaBMgGBlBzLM1wg81hsqrBDxcY6VSwVwsedI+6wsPPH
         /bvA==
X-Gm-Message-State: AOAM531Gve2rs8G6N1DPN0YxNXcoLcNntAAz/27gByF2tGBak6eqwUP4
        2iX74yipTzoH8NQnBw1Vyok=
X-Google-Smtp-Source: ABdhPJwO7oUt//DyPGqhlw9Lv00Xp7novD3HSD8VKbiVvYnYmTQVNqVoUmTr3zJfo+NxkRTHaDCN9A==
X-Received: by 2002:ad4:4652:: with SMTP id y18mr24318380qvv.2.1633370867406;
        Mon, 04 Oct 2021 11:07:47 -0700 (PDT)
Received: from localhost.localdomain (pool-72-82-21-11.prvdri.fios.verizon.net. [72.82.21.11])
        by smtp.gmail.com with ESMTPSA id h2sm8078853qkk.10.2021.10.04.11.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 11:07:46 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>
Subject: [PATCH] Bluetooth: fix deadlock for RFCOMM sk state change
Date:   Mon,  4 Oct 2021 14:07:34 -0400
Message-Id: <20211004180734.434511-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reports the following task hang [1]:

INFO: task syz-executor255:8499 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc7-syzkaller #0

Call Trace:
 context_switch kernel/sched/core.c:4681 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5938
 schedule+0xd3/0x270 kernel/sched/core.c:6017
 __lock_sock+0x13d/0x260 net/core/sock.c:2644
 lock_sock_nested+0xf6/0x120 net/core/sock.c:3185
 lock_sock include/net/sock.h:1612 [inline]
 rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73
 __rfcomm_dlc_close+0x1b6/0x8a0 net/bluetooth/rfcomm/core.c:489
 rfcomm_dlc_close+0x1ea/0x240 net/bluetooth/rfcomm/core.c:520
 __rfcomm_sock_close+0xac/0x260 net/bluetooth/rfcomm/sock.c:220
 rfcomm_sock_shutdown+0xe9/0x210 net/bluetooth/rfcomm/sock.c:931
 rfcomm_sock_release+0x5f/0x140 net/bluetooth/rfcomm/sock.c:951
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbd4/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Showing all locks held in the system:
1 lock held by khungtaskd/1653:
 #0: ffffffff8b97c280 (rcu_read_lock){....}-{1:2}, at:
 debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by krfcommd/4781:
 #0: ffffffff8d306528 (rfcomm_mutex){+.+.}-{3:3}, at:
 rfcomm_process_sessions net/bluetooth/rfcomm/core.c:1979 [inline]
 #0: ffffffff8d306528 (rfcomm_mutex){+.+.}-{3:3}, at:
 rfcomm_run+0x2ed/0x4a20 net/bluetooth/rfcomm/core.c:2086
2 locks held by in:imklog/8206:
 #0: ffff8880182ce5f0 (&f->f_pos_lock){+.+.}-{3:3}, at:
 __fdget_pos+0xe9/0x100 fs/file.c:974
 #1: ffff8880b9c51a58 (&rq->__lock){-.-.}-{2:2}, at:
 raw_spin_rq_lock_nested kernel/sched/core.c:460 [inline]
 #1: ffff8880b9c51a58 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock
 kernel/sched/sched.h:1307 [inline]
 #1: ffff8880b9c51a58 (&rq->__lock){-.-.}-{2:2}, at: rq_lock
 kernel/sched/sched.h:1610 [inline]
 #1: ffff8880b9c51a58 (&rq->__lock){-.-.}-{2:2}, at:
 __schedule+0x233/0x26f0 kernel/sched/core.c:5852
4 locks held by syz-executor255/8499:
 #0: ffff888039a83690 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at:
 inode_lock include/linux/fs.h:774 [inline]
 #0: ffff888039a83690 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at:
 __sock_release+0x86/0x280 net/socket.c:648
 #1:
 ffff88802fa31120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0},
 at: lock_sock include/net/sock.h:1612 [inline]
 #1:
 ffff88802fa31120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0},
 at: rfcomm_sock_shutdown+0x54/0x210 net/bluetooth/rfcomm/sock.c:928
 #2: ffffffff8d306528 (rfcomm_mutex){+.+.}-{3:3}, at:
 rfcomm_dlc_close+0x34/0x240 net/bluetooth/rfcomm/core.c:507
 #3: ffff888141bd6d28 (&d->lock){+.+.}-{3:3}, at:
 __rfcomm_dlc_close+0x162/0x8a0 net/bluetooth/rfcomm/core.c:487
==================================================================

The task hangs because of a deadlock that occurs when lock_sock() is
called in rfcomm_sk_state_change(). One such call stack is:

  rfcomm_sock_shutdown():
    lock_sock();
    __rfcomm_sock_close():
      rfcomm_dlc_close():
        __rfcomm_dlc_close():
          rfcomm_dlc_lock();
          rfcomm_sk_state_change():
            lock_sock();

lock_sock() has to be called when the sk state is changed because the
lock is not always held when rfcomm_sk_state_change() is
called. However, besides the recursive deadlock, there is also an
issue of a lock hierarchy inversion between rfcomm_dlc_lock() and
lock_sock() if the socket is locked in rfcomm_sk_state_change().

To avoid these issues, we can instead schedule the sk state change in
the global workqueue. This is already the implicit assumption about
how sk state changes happen. For example, in rfcomm_sock_shutdown(),
the call to __rfcomm_sock_close() is followed by
bt_sock_wait_state().

Additionally, the call to rfcomm_sock_kill() inside
rfcomm_sk_state_change() should be removed. The socket shouldn't be
killed here because only rfcomm_sock_release() calls sock_orphan(),
which it already follows up with a call to rfcomm_sock_kill().

Fixes: b7ce436a5d79 ("Bluetooth: switch to lock_sock in RFCOMM")
Link: https://syzkaller.appspot.com/bug?extid=7d51f807c81b190a127d [1]
Reported-by: syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com
Tested-by: syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
---
 include/net/bluetooth/rfcomm.h |  3 +++
 net/bluetooth/rfcomm/core.c    |  2 ++
 net/bluetooth/rfcomm/sock.c    | 34 ++++++++++++++++++++++------------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 99d26879b02a..a92799fc5e74 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -171,6 +171,7 @@ struct rfcomm_dlc {
 	struct rfcomm_session *session;
 	struct sk_buff_head   tx_queue;
 	struct timer_list     timer;
+	struct work_struct    state_change_work;
 
 	struct mutex  lock;
 	unsigned long state;
@@ -186,6 +187,7 @@ struct rfcomm_dlc {
 	u8            sec_level;
 	u8            role_switch;
 	u32           defer_setup;
+	int           err;
 
 	uint          mtu;
 	uint          cfc;
@@ -310,6 +312,7 @@ struct rfcomm_pinfo {
 	u8     role_switch;
 };
 
+void __rfcomm_sk_state_change(struct work_struct *work);
 int  rfcomm_init_sockets(void);
 void rfcomm_cleanup_sockets(void);
 
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 7324764384b6..c6494e85cd68 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -289,6 +289,7 @@ static void rfcomm_dlc_clear_state(struct rfcomm_dlc *d)
 	d->flags      = 0;
 	d->mscex      = 0;
 	d->sec_level  = BT_SECURITY_LOW;
+	d->err        = 0;
 	d->mtu        = RFCOMM_DEFAULT_MTU;
 	d->v24_sig    = RFCOMM_V24_RTC | RFCOMM_V24_RTR | RFCOMM_V24_DV;
 
@@ -306,6 +307,7 @@ struct rfcomm_dlc *rfcomm_dlc_alloc(gfp_t prio)
 	timer_setup(&d->timer, rfcomm_dlc_timeout, 0);
 
 	skb_queue_head_init(&d->tx_queue);
+	INIT_WORK(&d->state_change_work, __rfcomm_sk_state_change);
 	mutex_init(&d->lock);
 	refcount_set(&d->refcnt, 1);
 
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4bf4ea6cbb5e..4850dafbaa05 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -61,19 +61,22 @@ static void rfcomm_sk_data_ready(struct rfcomm_dlc *d, struct sk_buff *skb)
 		rfcomm_dlc_throttle(d);
 }
 
-static void rfcomm_sk_state_change(struct rfcomm_dlc *d, int err)
+void __rfcomm_sk_state_change(struct work_struct *work)
 {
+	struct rfcomm_dlc *d = container_of(work, struct rfcomm_dlc,
+					    state_change_work);
 	struct sock *sk = d->owner, *parent;
 
 	if (!sk)
 		return;
 
-	BT_DBG("dlc %p state %ld err %d", d, d->state, err);
-
 	lock_sock(sk);
+	rfcomm_dlc_lock(d);
 
-	if (err)
-		sk->sk_err = err;
+	BT_DBG("dlc %p state %ld err %d", d, d->state, d->err);
+
+	if (d->err)
+		sk->sk_err = d->err;
 
 	sk->sk_state = d->state;
 
@@ -91,15 +94,22 @@ static void rfcomm_sk_state_change(struct rfcomm_dlc *d, int err)
 		sk->sk_state_change(sk);
 	}
 
+	rfcomm_dlc_unlock(d);
 	release_sock(sk);
+	sock_put(sk);
+}
 
-	if (parent && sock_flag(sk, SOCK_ZAPPED)) {
-		/* We have to drop DLC lock here, otherwise
-		 * rfcomm_sock_destruct() will dead lock. */
-		rfcomm_dlc_unlock(d);
-		rfcomm_sock_kill(sk);
-		rfcomm_dlc_lock(d);
-	}
+static void rfcomm_sk_state_change(struct rfcomm_dlc *d, int err)
+{
+	struct sock *sk = d->owner;
+
+	if (!sk)
+		return;
+
+	d->err = err;
+	sock_hold(sk);
+	if (!schedule_work(&d->state_change_work))
+		sock_put(sk);
 }
 
 /* ---- Socket functions ---- */
-- 
2.25.1

