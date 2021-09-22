Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555EB414B9B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbhIVOSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:18:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55912 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbhIVOSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 10:18:10 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632320200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XvyHaTGz7xjft1AZd1iLkPTxrlYErPr+mjlqSrCr8k0=;
        b=b2Gp5N6YQ+hxvxz5It1ORdW7z36nMlV3aBe3zO7BCD86M7ZnjY59+qbjhQdj0+EK65RLjD
        xHCIzywk4kzMvn7NPRaDQdTgTMOx7oaBhCTHznDgC3OHxCsC9Zti+FmzOPeLssj/1loSM4
        VOqIKuzhMeD43GFD79YX/prPGoNShbs3ZS3gPTX0J+L2/JRsdf/VBIzpA7nTr5FFP2uviG
        9CLqnn/MIDRgSPHk/qau8zG+m6AFvnw4br+lbOrevI0CrwgCXj+gdX8GYIFVwF0h/Jy/ww
        J2BFSuhrVYmfmV5d1nJlyvh2/3aUhcdEl3xKKCWdqAXm1VMoNb/g0txixIXn2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632320200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XvyHaTGz7xjft1AZd1iLkPTxrlYErPr+mjlqSrCr8k0=;
        b=QjWU9EKTL8mkpU0lH81Bk8G1XP7HCzE7aM7SqL+WSCeGkWZuVV+2T87KhQg9kQXrfEUBNa
        hcUSO0PJfi/iOGDQ==
To:     syzbot <syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com>,
        desmondcheongzx@gmail.com, edumazet@google.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] INFO: task can't die in __lock_sock
In-Reply-To: <000000000000307a5205cc6f3c02@google.com>
References: <000000000000307a5205cc6f3c02@google.com>
Date:   Wed, 22 Sep 2021 16:16:39 +0200
Message-ID: <874kacu248.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20 2021 at 08:50, syzbot wrote:
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> possible deadlock in rfcomm_sk_state_change
>
> ============================================
> WARNING: possible recursive locking detected
> 5.15.0-rc2-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor.0/9050 is trying to acquire lock:
> ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
> ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73
>
> but task is already holding lock:
> ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
> ffff88807ce5d120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sock_shutdown+0x54/0x210 net/bluetooth/rfcomm/sock.c:928

it's not only possible recursion. It's real. Same lock instance and the
stack trace tells how this happens

 lock_sock_nested+0x4e/0x140 net/core/sock.c:3183
 lock_sock include/net/sock.h:1612 [inline]

Lock is already held. See below.

 rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73
 __rfcomm_dlc_close+0x1b6/0x8a0 net/bluetooth/rfcomm/core.c:489
 rfcomm_dlc_close+0x1ea/0x240 net/bluetooth/rfcomm/core.c:520
 __rfcomm_sock_close+0xac/0x260 net/bluetooth/rfcomm/sock.c:220

sock lock is held from here.

 rfcomm_sock_shutdown+0xe9/0x210 net/bluetooth/rfcomm/sock.c:931
 rfcomm_sock_release+0x5f/0x140 net/bluetooth/rfcomm/sock.c:951
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164

I assume that the lock_sock*() lockdep change was applied on top of
Linus tree. The previous reports were showing lockups IIRC because
lockdep had no chance to see that due to the placement of the acquire
annotation.

Thanks,

        tglx

