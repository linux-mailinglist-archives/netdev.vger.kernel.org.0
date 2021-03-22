Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEDE3449D1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhCVPxV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Mar 2021 11:53:21 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41776 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhCVPxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:53:16 -0400
Received: from marcel-macbook.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id BD42DCECB0;
        Mon, 22 Mar 2021 17:00:52 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Bluetooth: check for zapped sk before connecting
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210322140046.1.I6c4306f6e8ba3ccc9106067d4eb70092f8cb2a49@changeid>
Date:   Mon, 22 Mar 2021 16:53:08 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <559FCF7C-A929-4291-956C-EF776EFAA47D@holtmann.org>
References: <20210322140046.1.I6c4306f6e8ba3ccc9106067d4eb70092f8cb2a49@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> There is a possibility of receiving a zapped sock on
> l2cap_sock_connect(). This could lead to interesting crashes, one
> such case is tearing down an already tore l2cap_sock as is happened
> with this call trace:
> 
> __dump_stack lib/dump_stack.c:15 [inline]
> dump_stack+0xc4/0x118 lib/dump_stack.c:56
> register_lock_class kernel/locking/lockdep.c:792 [inline]
> register_lock_class+0x239/0x6f6 kernel/locking/lockdep.c:742
> __lock_acquire+0x209/0x1e27 kernel/locking/lockdep.c:3105
> lock_acquire+0x29c/0x2fb kernel/locking/lockdep.c:3599
> __raw_spin_lock_bh include/linux/spinlock_api_smp.h:137 [inline]
> _raw_spin_lock_bh+0x38/0x47 kernel/locking/spinlock.c:175
> spin_lock_bh include/linux/spinlock.h:307 [inline]
> lock_sock_nested+0x44/0xfa net/core/sock.c:2518
> l2cap_sock_teardown_cb+0x88/0x2fb net/bluetooth/l2cap_sock.c:1345
> l2cap_chan_del+0xa3/0x383 net/bluetooth/l2cap_core.c:598
> l2cap_chan_close+0x537/0x5dd net/bluetooth/l2cap_core.c:756
> l2cap_chan_timeout+0x104/0x17e net/bluetooth/l2cap_core.c:429
> process_one_work+0x7e3/0xcb0 kernel/workqueue.c:2064
> worker_thread+0x5a5/0x773 kernel/workqueue.c:2196
> kthread+0x291/0x2a6 kernel/kthread.c:211
> ret_from_fork+0x4e/0x80 arch/x86/entry/entry_64.S:604
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reported-by: syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Guenter Roeck <groeck@chromium.org>
> ---
> 
> net/bluetooth/l2cap_sock.c | 7 +++++++
> 1 file changed, 7 insertions(+)
> 
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index f1b1edd0b697..b86fd8cc4dc1 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -182,6 +182,13 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
> 
> 	BT_DBG("sk %p", sk);
> 
> +	lock_sock(sk);
> +	if (sock_flag(sk, SOCK_ZAPPED)) {
> +		release_sock(sk);
> +		return -EINVAL;
> +	}
> +	release_sock(sk);
> +

hmmm. I wonder if this would look better and easy to see that the locking is done correctly.

	lock_sock(sk);
	zapped = sock_flag(sk, SOCK_ZAPPED);
	release_sock(sk);

	if (zapped)
		return -EINVAL;

Regards

Marcel

