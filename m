Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEDB374224
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhEEQph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235511AbhEEQmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:42:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9063061627;
        Wed,  5 May 2021 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232493;
        bh=1Tj8L1ZaYES/mLH5ILY14A6ccbafPhdoBV0lV+yee9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Civs3S6ozlZwbd7eJ5q0tm4gUAJ/QtaPv/VSMWw7wfI5c3qXHBsK2gSAvRxSDWQ9y
         PowPXPNJ8AyaSz1VVSFXL0WCbDeAyUY0//AN61CR+aCg/Y+J1AelFkrqnCpIafSSsG
         MY0Ex53eRgeqTyraJgDq2RPOVj4Jo38GaI/S2epcuGDtcyIGfpPqiRB5xiYcjfmFBh
         kakwZLR+ny+gMOo/vQtTdxxWAXX9lM60OJfhx0p8+i9sLFl5oBisKxYek7hyT4BLc8
         tYgkY74pLPD1yrraYWUFYUzwu71lZ91+ZxVnZE1UJpFy38eS4/rITg7SmCJrrEkY2j
         c2e3o3DUteQ7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Archie Pusaka <apusaka@chromium.org>,
        syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 028/104] Bluetooth: check for zapped sk before connecting
Date:   Wed,  5 May 2021 12:32:57 -0400
Message-Id: <20210505163413.3461611-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 3af70b39fa2d415dc86c370e5b24ddb9fdacbd6f ]

There is a possibility of receiving a zapped sock on
l2cap_sock_connect(). This could lead to interesting crashes, one
such case is tearing down an already tore l2cap_sock as is happened
with this call trace:

__dump_stack lib/dump_stack.c:15 [inline]
dump_stack+0xc4/0x118 lib/dump_stack.c:56
register_lock_class kernel/locking/lockdep.c:792 [inline]
register_lock_class+0x239/0x6f6 kernel/locking/lockdep.c:742
__lock_acquire+0x209/0x1e27 kernel/locking/lockdep.c:3105
lock_acquire+0x29c/0x2fb kernel/locking/lockdep.c:3599
__raw_spin_lock_bh include/linux/spinlock_api_smp.h:137 [inline]
_raw_spin_lock_bh+0x38/0x47 kernel/locking/spinlock.c:175
spin_lock_bh include/linux/spinlock.h:307 [inline]
lock_sock_nested+0x44/0xfa net/core/sock.c:2518
l2cap_sock_teardown_cb+0x88/0x2fb net/bluetooth/l2cap_sock.c:1345
l2cap_chan_del+0xa3/0x383 net/bluetooth/l2cap_core.c:598
l2cap_chan_close+0x537/0x5dd net/bluetooth/l2cap_core.c:756
l2cap_chan_timeout+0x104/0x17e net/bluetooth/l2cap_core.c:429
process_one_work+0x7e3/0xcb0 kernel/workqueue.c:2064
worker_thread+0x5a5/0x773 kernel/workqueue.c:2196
kthread+0x291/0x2a6 kernel/kthread.c:211
ret_from_fork+0x4e/0x80 arch/x86/entry/entry_64.S:604

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reported-by: syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index f1b1edd0b697..c99d65ef13b1 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -179,9 +179,17 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	struct sockaddr_l2 la;
 	int len, err = 0;
+	bool zapped;
 
 	BT_DBG("sk %p", sk);
 
+	lock_sock(sk);
+	zapped = sock_flag(sk, SOCK_ZAPPED);
+	release_sock(sk);
+
+	if (zapped)
+		return -EINVAL;
+
 	if (!addr || alen < offsetofend(struct sockaddr, sa_family) ||
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
-- 
2.30.2

