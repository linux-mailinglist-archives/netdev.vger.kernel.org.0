Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F480373716
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 11:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhEEJUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 05:20:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhEEJUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 05:20:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A2FAEB25F;
        Wed,  5 May 2021 09:19:33 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 13/35] tty: cumulate and document tty_struct::ctrl* members
Date:   Wed,  5 May 2021 11:19:06 +0200
Message-Id: <20210505091928.22010-14-jslaby@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505091928.22010-1-jslaby@suse.cz>
References: <20210505091928.22010-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Group the ctrl members under a single struct called ctrl. The new struct
contains 'pgrp', 'session', 'pktstatus', and 'packet'. 'pktstatus' and
'packet' used to be bits in a bitfield. The struct also contains the
lock protecting them to share the same cache line.

Note that commit c545b66c6922b (tty: Serialize tcflow() with other tty
flow control changes) added a padding to the original bitfield. It was
for the bitfield to occupy a whole 64b word to avoid interferring stores
on Alpha (cannot we evaporate this arch with weird implications to C
code yet?). But it doesn't work as expected as the padding
(tty_struct::ctrl_unused) is aligned to a 8B boundary too and occupies
some bytes from the next word.

So make it reliable by:
1) setting __aligned of the struct -- that aligns the start, and
2) making 'unsigned long unused[0]' as the last member of the struct --
   pads the end.

Add a kerneldoc comment for this grouped members.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/caif/caif_serial.c |  2 +-
 drivers/tty/n_tty.c            | 30 ++++++------
 drivers/tty/pty.c              | 62 ++++++++++++-------------
 drivers/tty/tty_io.c           | 44 +++++++++---------
 drivers/tty/tty_jobctrl.c      | 84 +++++++++++++++++-----------------
 drivers/tty/vt/vt.c            |  4 +-
 include/linux/tty.h            | 26 +++++++----
 7 files changed, 130 insertions(+), 122 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 3996cf7dc9ba..b0566588ce33 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -89,7 +89,7 @@ static inline void update_tty_status(struct ser_device *ser)
 	ser->tty_status =
 		ser->tty->flow.stopped << 5 |
 		ser->tty->flow.tco_stopped << 3 |
-		ser->tty->packet << 2;
+		ser->tty->ctrl.packet << 2;
 }
 static inline void debugfs_init(struct ser_device *ser, struct tty_struct *tty)
 {
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3566bb577eb0..8ce712eec026 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -342,10 +342,10 @@ static void n_tty_packet_mode_flush(struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	if (tty->link->packet) {
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
-		tty->ctrl_status |= TIOCPKT_FLUSHREAD;
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	if (tty->link->ctrl.packet) {
+		spin_lock_irqsave(&tty->ctrl.lock, flags);
+		tty->ctrl.pktstatus |= TIOCPKT_FLUSHREAD;
+		spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 		wake_up_interruptible(&tty->link->read_wait);
 	}
 }
@@ -361,7 +361,7 @@ static void n_tty_packet_mode_flush(struct tty_struct *tty)
  *	Holds termios_rwsem to exclude producer/consumer while
  *	buffer indices are reset.
  *
- *	Locking: ctrl_lock, exclusive termios_rwsem
+ *	Locking: ctrl.lock, exclusive termios_rwsem
  */
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
@@ -1103,7 +1103,7 @@ static void eraser(unsigned char c, struct tty_struct *tty)
  *	buffer is 'output'. The signal is processed first to alert any current
  *	readers or writers to discontinue and exit their i/o loops.
  *
- *	Locking: ctrl_lock
+ *	Locking: ctrl.lock
  */
 
 static void __isig(int sig, struct tty_struct *tty)
@@ -2025,7 +2025,7 @@ static bool canon_copy_from_read_buf(struct tty_struct *tty,
  *
  *	Locking: redirected write test is safe
  *		 current->signal->tty check is safe
- *		 ctrl_lock to safely reference tty->pgrp
+ *		 ctrl.lock to safely reference tty->ctrl.pgrp
  */
 
 static int job_control(struct tty_struct *tty, struct file *file)
@@ -2072,7 +2072,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	int minimum, time;
 	ssize_t retval = 0;
 	long timeout;
-	int packet;
+	bool packet;
 	size_t tail;
 
 	/*
@@ -2128,20 +2128,20 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		}
 	}
 
-	packet = tty->packet;
+	packet = tty->ctrl.packet;
 	tail = ldata->read_tail;
 
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
 		/* First test for status change. */
-		if (packet && tty->link->ctrl_status) {
+		if (packet && tty->link->ctrl.pktstatus) {
 			unsigned char cs;
 			if (kb != kbuf)
 				break;
-			spin_lock_irq(&tty->link->ctrl_lock);
-			cs = tty->link->ctrl_status;
-			tty->link->ctrl_status = 0;
-			spin_unlock_irq(&tty->link->ctrl_lock);
+			spin_lock_irq(&tty->link->ctrl.lock);
+			cs = tty->link->ctrl.pktstatus;
+			tty->link->ctrl.pktstatus = 0;
+			spin_unlock_irq(&tty->link->ctrl.lock);
 			*kb++ = cs;
 			nr--;
 			break;
@@ -2368,7 +2368,7 @@ static __poll_t n_tty_poll(struct tty_struct *tty, struct file *file,
 		if (input_available_p(tty, 1))
 			mask |= EPOLLIN | EPOLLRDNORM;
 	}
-	if (tty->packet && tty->link->ctrl_status)
+	if (tty->ctrl.packet && tty->link->ctrl.pktstatus)
 		mask |= EPOLLPRI | EPOLLIN | EPOLLRDNORM;
 	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
 		mask |= EPOLLHUP;
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 017f28150a32..3e7b5c811f9b 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -57,9 +57,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	set_bit(TTY_IO_ERROR, &tty->flags);
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
-	spin_lock_irq(&tty->ctrl_lock);
-	tty->packet = 0;
-	spin_unlock_irq(&tty->ctrl_lock);
+	spin_lock_irq(&tty->ctrl.lock);
+	tty->ctrl.packet = false;
+	spin_unlock_irq(&tty->ctrl.lock);
 	/* Review - krefs on tty_link ?? */
 	if (!tty->link)
 		return;
@@ -185,16 +185,16 @@ static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
 	if (get_user(pktmode, arg))
 		return -EFAULT;
 
-	spin_lock_irq(&tty->ctrl_lock);
+	spin_lock_irq(&tty->ctrl.lock);
 	if (pktmode) {
-		if (!tty->packet) {
-			tty->link->ctrl_status = 0;
+		if (!tty->ctrl.packet) {
+			tty->link->ctrl.pktstatus = 0;
 			smp_mb();
-			tty->packet = 1;
+			tty->ctrl.packet = true;
 		}
 	} else
-		tty->packet = 0;
-	spin_unlock_irq(&tty->ctrl_lock);
+		tty->ctrl.packet = false;
+	spin_unlock_irq(&tty->ctrl.lock);
 
 	return 0;
 }
@@ -202,7 +202,7 @@ static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
 /* Get the packet mode of a pty */
 static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
 {
-	int pktmode = tty->packet;
+	int pktmode = tty->ctrl.packet;
 
 	return put_user(pktmode, arg);
 }
@@ -232,11 +232,11 @@ static void pty_flush_buffer(struct tty_struct *tty)
 		return;
 
 	tty_buffer_flush(to, NULL);
-	if (to->packet) {
-		spin_lock_irq(&tty->ctrl_lock);
-		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
+	if (to->ctrl.packet) {
+		spin_lock_irq(&tty->ctrl.lock);
+		tty->ctrl.pktstatus |= TIOCPKT_FLUSHWRITE;
 		wake_up_interruptible(&to->read_wait);
-		spin_unlock_irq(&tty->ctrl_lock);
+		spin_unlock_irq(&tty->ctrl.lock);
 	}
 }
 
@@ -266,7 +266,7 @@ static void pty_set_termios(struct tty_struct *tty,
 					struct ktermios *old_termios)
 {
 	/* See if packet mode change of state. */
-	if (tty->link && tty->link->packet) {
+	if (tty->link && tty->link->ctrl.packet) {
 		int extproc = (old_termios->c_lflag & EXTPROC) | L_EXTPROC(tty);
 		int old_flow = ((old_termios->c_iflag & IXON) &&
 				(old_termios->c_cc[VSTOP] == '\023') &&
@@ -275,17 +275,17 @@ static void pty_set_termios(struct tty_struct *tty,
 				STOP_CHAR(tty) == '\023' &&
 				START_CHAR(tty) == '\021');
 		if ((old_flow != new_flow) || extproc) {
-			spin_lock_irq(&tty->ctrl_lock);
+			spin_lock_irq(&tty->ctrl.lock);
 			if (old_flow != new_flow) {
-				tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
+				tty->ctrl.pktstatus &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
 				if (new_flow)
-					tty->ctrl_status |= TIOCPKT_DOSTOP;
+					tty->ctrl.pktstatus |= TIOCPKT_DOSTOP;
 				else
-					tty->ctrl_status |= TIOCPKT_NOSTOP;
+					tty->ctrl.pktstatus |= TIOCPKT_NOSTOP;
 			}
 			if (extproc)
-				tty->ctrl_status |= TIOCPKT_IOCTL;
-			spin_unlock_irq(&tty->ctrl_lock);
+				tty->ctrl.pktstatus |= TIOCPKT_IOCTL;
+			spin_unlock_irq(&tty->ctrl.lock);
 			wake_up_interruptible(&tty->link->read_wait);
 		}
 	}
@@ -346,11 +346,11 @@ static void pty_start(struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	if (tty->link && tty->link->packet) {
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
-		tty->ctrl_status &= ~TIOCPKT_STOP;
-		tty->ctrl_status |= TIOCPKT_START;
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	if (tty->link && tty->link->ctrl.packet) {
+		spin_lock_irqsave(&tty->ctrl.lock, flags);
+		tty->ctrl.pktstatus &= ~TIOCPKT_STOP;
+		tty->ctrl.pktstatus |= TIOCPKT_START;
+		spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 		wake_up_interruptible_poll(&tty->link->read_wait, EPOLLIN);
 	}
 }
@@ -359,11 +359,11 @@ static void pty_stop(struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	if (tty->link && tty->link->packet) {
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
-		tty->ctrl_status &= ~TIOCPKT_START;
-		tty->ctrl_status |= TIOCPKT_STOP;
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	if (tty->link && tty->link->ctrl.packet) {
+		spin_lock_irqsave(&tty->ctrl.lock, flags);
+		tty->ctrl.pktstatus &= ~TIOCPKT_START;
+		tty->ctrl.pktstatus |= TIOCPKT_STOP;
+		spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 		wake_up_interruptible_poll(&tty->link->read_wait, EPOLLIN);
 	}
 }
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 9734be2eb00e..362845dc1c19 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -638,15 +638,15 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 
 	tty_ldisc_hangup(tty, cons_filp != NULL);
 
-	spin_lock_irq(&tty->ctrl_lock);
+	spin_lock_irq(&tty->ctrl.lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	put_pid(tty->session);
-	put_pid(tty->pgrp);
-	tty->session = NULL;
-	tty->pgrp = NULL;
-	tty->ctrl_status = 0;
-	spin_unlock_irq(&tty->ctrl_lock);
+	put_pid(tty->ctrl.session);
+	put_pid(tty->ctrl.pgrp);
+	tty->ctrl.session = NULL;
+	tty->ctrl.pgrp = NULL;
+	tty->ctrl.pktstatus = 0;
+	spin_unlock_irq(&tty->ctrl.lock);
 
 	/*
 	 * If one of the devices matches a console pointer, we
@@ -1559,8 +1559,8 @@ static void release_one_tty(struct work_struct *work)
 	list_del_init(&tty->tty_files);
 	spin_unlock(&tty->files_lock);
 
-	put_pid(tty->pgrp);
-	put_pid(tty->session);
+	put_pid(tty->ctrl.pgrp);
+	put_pid(tty->ctrl.session);
 	free_tty_struct(tty);
 }
 
@@ -1861,9 +1861,9 @@ int tty_release(struct inode *inode, struct file *filp)
 	 */
 	if (!tty->count) {
 		read_lock(&tasklist_lock);
-		session_clear_tty(tty->session);
+		session_clear_tty(tty->ctrl.session);
 		if (o_tty)
-			session_clear_tty(o_tty->session);
+			session_clear_tty(o_tty->ctrl.session);
 		read_unlock(&tasklist_lock);
 	}
 
@@ -2250,16 +2250,16 @@ static int __tty_fasync(int fd, struct file *filp, int on)
 		enum pid_type type;
 		struct pid *pid;
 
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
-		if (tty->pgrp) {
-			pid = tty->pgrp;
+		spin_lock_irqsave(&tty->ctrl.lock, flags);
+		if (tty->ctrl.pgrp) {
+			pid = tty->ctrl.pgrp;
 			type = PIDTYPE_PGID;
 		} else {
 			pid = task_pid(current);
 			type = PIDTYPE_TGID;
 		}
 		get_pid(pid);
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 		__f_setown(filp, pid, type, 0);
 		put_pid(pid);
 		retval = 0;
@@ -2381,7 +2381,7 @@ EXPORT_SYMBOL(tty_do_resize);
  *
  *	Locking:
  *		Driver dependent. The default do_resize method takes the
- *	tty termios mutex and ctrl_lock. The console takes its own lock
+ *	tty termios mutex and ctrl.lock. The console takes its own lock
  *	then calls into the default method.
  */
 
@@ -3039,9 +3039,9 @@ void __do_SAK(struct tty_struct *tty)
 	if (!tty)
 		return;
 
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	session = get_pid(tty->session);
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	spin_lock_irqsave(&tty->ctrl.lock, flags);
+	session = get_pid(tty->ctrl.session);
+	spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 
 	tty_ldisc_flush(tty);
 
@@ -3129,8 +3129,8 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
 		kfree(tty);
 		return NULL;
 	}
-	tty->session = NULL;
-	tty->pgrp = NULL;
+	tty->ctrl.session = NULL;
+	tty->ctrl.pgrp = NULL;
 	mutex_init(&tty->legacy_mutex);
 	mutex_init(&tty->throttle_mutex);
 	init_rwsem(&tty->termios_rwsem);
@@ -3140,7 +3140,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
 	init_waitqueue_head(&tty->read_wait);
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_write_lock);
-	spin_lock_init(&tty->ctrl_lock);
+	spin_lock_init(&tty->ctrl.lock);
 	spin_lock_init(&tty->flow.lock);
 	spin_lock_init(&tty->files_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
diff --git a/drivers/tty/tty_jobctrl.c b/drivers/tty/tty_jobctrl.c
index 7813dc910a19..6119b5e48610 100644
--- a/drivers/tty/tty_jobctrl.c
+++ b/drivers/tty/tty_jobctrl.c
@@ -28,7 +28,7 @@ static int is_ignored(int sig)
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
  *
- *	Locking: ctrl_lock
+ *	Locking: ctrl.lock
  */
 int __tty_check_change(struct tty_struct *tty, int sig)
 {
@@ -42,9 +42,9 @@ int __tty_check_change(struct tty_struct *tty, int sig)
 	rcu_read_lock();
 	pgrp = task_pgrp(current);
 
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	tty_pgrp = tty->pgrp;
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	spin_lock_irqsave(&tty->ctrl.lock, flags);
+	tty_pgrp = tty->ctrl.pgrp;
+	spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 
 	if (tty_pgrp && pgrp != tty_pgrp) {
 		if (is_ignored(sig)) {
@@ -99,16 +99,16 @@ static void __proc_set_tty(struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	spin_lock_irqsave(&tty->ctrl.lock, flags);
 	/*
 	 * The session and fg pgrp references will be non-NULL if
 	 * tiocsctty() is stealing the controlling tty
 	 */
-	put_pid(tty->session);
-	put_pid(tty->pgrp);
-	tty->pgrp = get_pid(task_pgrp(current));
-	tty->session = get_pid(task_session(current));
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	put_pid(tty->ctrl.session);
+	put_pid(tty->ctrl.pgrp);
+	tty->ctrl.pgrp = get_pid(task_pgrp(current));
+	tty->ctrl.session = get_pid(task_session(current));
+	spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 	if (current->signal->tty) {
 		tty_debug(tty, "current tty %s not NULL!!\n",
 			  current->signal->tty->name);
@@ -135,7 +135,7 @@ void tty_open_proc_set_tty(struct file *filp, struct tty_struct *tty)
 	spin_lock_irq(&current->sighand->siglock);
 	if (current->signal->leader &&
 	    !current->signal->tty &&
-	    tty->session == NULL) {
+	    tty->ctrl.session == NULL) {
 		/*
 		 * Don't let a process that only has write access to the tty
 		 * obtain the privileges associated with having a tty as
@@ -200,8 +200,8 @@ int tty_signal_session_leader(struct tty_struct *tty, int exit_session)
 	struct pid *tty_pgrp = NULL;
 
 	read_lock(&tasklist_lock);
-	if (tty->session) {
-		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
+	if (tty->ctrl.session) {
+		do_each_pid_task(tty->ctrl.session, PIDTYPE_SID, p) {
 			spin_lock_irq(&p->sighand->siglock);
 			if (p->signal->tty == tty) {
 				p->signal->tty = NULL;
@@ -218,13 +218,14 @@ int tty_signal_session_leader(struct tty_struct *tty, int exit_session)
 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
-			spin_lock(&tty->ctrl_lock);
-			tty_pgrp = get_pid(tty->pgrp);
-			if (tty->pgrp)
-				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
-			spin_unlock(&tty->ctrl_lock);
+			spin_lock(&tty->ctrl.lock);
+			tty_pgrp = get_pid(tty->ctrl.pgrp);
+			if (tty->ctrl.pgrp)
+				p->signal->tty_old_pgrp =
+					get_pid(tty->ctrl.pgrp);
+			spin_unlock(&tty->ctrl.lock);
 			spin_unlock_irq(&p->sighand->siglock);
-		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
+		} while_each_pid_task(tty->ctrl.session, PIDTYPE_SID, p);
 	}
 	read_unlock(&tasklist_lock);
 
@@ -309,12 +310,12 @@ void disassociate_ctty(int on_exit)
 		unsigned long flags;
 
 		tty_lock(tty);
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
-		put_pid(tty->session);
-		put_pid(tty->pgrp);
-		tty->session = NULL;
-		tty->pgrp = NULL;
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		spin_lock_irqsave(&tty->ctrl.lock, flags);
+		put_pid(tty->ctrl.session);
+		put_pid(tty->ctrl.pgrp);
+		tty->ctrl.session = NULL;
+		tty->ctrl.pgrp = NULL;
+		spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 		tty_unlock(tty);
 		tty_kref_put(tty);
 	}
@@ -363,7 +364,8 @@ static int tiocsctty(struct tty_struct *tty, struct file *file, int arg)
 	tty_lock(tty);
 	read_lock(&tasklist_lock);
 
-	if (current->signal->leader && (task_session(current) == tty->session))
+	if (current->signal->leader &&
+			task_session(current) == tty->ctrl.session)
 		goto unlock;
 
 	/*
@@ -375,7 +377,7 @@ static int tiocsctty(struct tty_struct *tty, struct file *file, int arg)
 		goto unlock;
 	}
 
-	if (tty->session) {
+	if (tty->ctrl.session) {
 		/*
 		 * This tty is already the controlling
 		 * tty for another session group!
@@ -384,7 +386,7 @@ static int tiocsctty(struct tty_struct *tty, struct file *file, int arg)
 			/*
 			 * Steal it away
 			 */
-			session_clear_tty(tty->session);
+			session_clear_tty(tty->ctrl.session);
 		} else {
 			ret = -EPERM;
 			goto unlock;
@@ -416,9 +418,9 @@ struct pid *tty_get_pgrp(struct tty_struct *tty)
 	unsigned long flags;
 	struct pid *pgrp;
 
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	pgrp = get_pid(tty->pgrp);
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	spin_lock_irqsave(&tty->ctrl.lock, flags);
+	pgrp = get_pid(tty->ctrl.pgrp);
+	spin_unlock_irqrestore(&tty->ctrl.lock, flags);
 
 	return pgrp;
 }
@@ -499,10 +501,10 @@ static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t
 	if (pgrp_nr < 0)
 		return -EINVAL;
 
-	spin_lock_irq(&real_tty->ctrl_lock);
+	spin_lock_irq(&real_tty->ctrl.lock);
 	if (!current->signal->tty ||
 	    (current->signal->tty != real_tty) ||
-	    (real_tty->session != task_session(current))) {
+	    (real_tty->ctrl.session != task_session(current))) {
 		retval = -ENOTTY;
 		goto out_unlock_ctrl;
 	}
@@ -515,12 +517,12 @@ static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t
 	if (session_of_pgrp(pgrp) != task_session(current))
 		goto out_unlock;
 	retval = 0;
-	put_pid(real_tty->pgrp);
-	real_tty->pgrp = get_pid(pgrp);
+	put_pid(real_tty->ctrl.pgrp);
+	real_tty->ctrl.pgrp = get_pid(pgrp);
 out_unlock:
 	rcu_read_unlock();
 out_unlock_ctrl:
-	spin_unlock_irq(&real_tty->ctrl_lock);
+	spin_unlock_irq(&real_tty->ctrl.lock);
 	return retval;
 }
 
@@ -545,16 +547,16 @@ static int tiocgsid(struct tty_struct *tty, struct tty_struct *real_tty, pid_t _
 	if (tty == real_tty && current->signal->tty != real_tty)
 		return -ENOTTY;
 
-	spin_lock_irqsave(&real_tty->ctrl_lock, flags);
-	if (!real_tty->session)
+	spin_lock_irqsave(&real_tty->ctrl.lock, flags);
+	if (!real_tty->ctrl.session)
 		goto err;
-	sid = pid_vnr(real_tty->session);
-	spin_unlock_irqrestore(&real_tty->ctrl_lock, flags);
+	sid = pid_vnr(real_tty->ctrl.session);
+	spin_unlock_irqrestore(&real_tty->ctrl.lock, flags);
 
 	return put_user(sid, p);
 
 err:
-	spin_unlock_irqrestore(&real_tty->ctrl_lock, flags);
+	spin_unlock_irqrestore(&real_tty->ctrl.lock, flags);
 	return -ENOTTY;
 }
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 38c677fb6505..706f066eb711 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1189,7 +1189,7 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
  *	information and perform any necessary signal handling.
  *
  *	Caller must hold the console semaphore. Takes the termios rwsem and
- *	ctrl_lock of the tty IFF a tty is passed.
+ *	ctrl.lock of the tty IFF a tty is passed.
  */
 
 static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
@@ -1355,7 +1355,7 @@ int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int rows)
  *	the actual work.
  *
  *	Takes the console sem and the called methods then take the tty
- *	termios_rwsem and the tty ctrl_lock in that order.
+ *	termios_rwsem and the tty ctrl.lock in that order.
  */
 static int vt_resize(struct tty_struct *tty, struct winsize *ws)
 {
diff --git a/include/linux/tty.h b/include/linux/tty.h
index df3a69b2e1ea..283ac5f29052 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -255,6 +255,13 @@ struct tty_operations;
  * @flow.unused: alignment for Alpha, so that no members other than @flow.* are
  *		 modified by the same 64b word store. The @flow's __aligned is
  *		 there for the very same reason.
+ * @ctrl.lock: lock for ctrl members
+ * @ctrl.pgrp: process group of this tty (setpgrp(2))
+ * @ctrl.session: session of this tty (setsid(2)). Writes are protected by both
+ *		  @ctrl.lock and legacy mutex, readers must use at least one of
+ *		  them.
+ * @ctrl.pktstatus: packet mode status (bitwise OR of TIOCPKT_* constants)
+ * @ctrl.packet: packet mode enabled
  *
  * All of the state associated with a tty while the tty is open. Persistent
  * storage for tty devices is referenced here as @port in struct tty_port.
@@ -276,16 +283,9 @@ struct tty_struct {
 	struct mutex throttle_mutex;
 	struct rw_semaphore termios_rwsem;
 	struct mutex winsize_mutex;
-	spinlock_t ctrl_lock;
 	/* Termios values are protected by the termios rwsem */
 	struct ktermios termios, termios_locked;
 	char name[64];
-	struct pid *pgrp;		/* Protected by ctrl lock */
-	/*
-	 * Writes protected by both ctrl lock and legacy mutex, readers must use
-	 * at least one of them.
-	 */
-	struct pid *session;
 	unsigned long flags;
 	int count;
 	struct winsize winsize;		/* winsize_mutex */
@@ -297,10 +297,16 @@ struct tty_struct {
 		unsigned long unused[0];
 	} __aligned(sizeof(unsigned long)) flow;
 
+	struct {
+		spinlock_t lock;
+		struct pid *pgrp;
+		struct pid *session;
+		unsigned char pktstatus;
+		bool packet;
+		unsigned long unused[0];
+	} __aligned(sizeof(unsigned long)) ctrl;
+
 	int hw_stopped;
-	unsigned long ctrl_status:8,	/* ctrl_lock */
-		      packet:1,
-		      unused_ctrl:BITS_PER_LONG - 9;
 	unsigned int receive_room;	/* Bytes free for queue */
 	int flow_change;
 
-- 
2.31.1

