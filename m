Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D95344A02
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhCVP7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:59:44 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50658 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhCVP7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:08 -0400
Received: from marcel-macbook.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id 06AC3CECB0;
        Mon, 22 Mar 2021 17:06:42 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210322140154.1.I2ce9acd6cc6766e6789fc5742951b21b7ab27067@changeid>
Date:   Mon, 22 Mar 2021 16:59:02 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        syzbot+338f014a98367a08a114@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9776B816-4396-49C8-95AA-85F231B06A0E@holtmann.org>
References: <20210322140154.1.I2ce9acd6cc6766e6789fc5742951b21b7ab27067@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Currently l2cap_chan_set_defaults() reset chan->conf_state to zero.
> However, there is a flag CONF_NOT_COMPLETE which is set when
> creating the l2cap_chan. It is suggested that the flag should be
> cleared when l2cap_chan is ready, but when l2cap_chan_set_defaults()
> is called, l2cap_chan is not yet ready. Therefore, we must set this
> flag as the default.
> 
> Example crash call trace:
> __dump_stack lib/dump_stack.c:15 [inline]
> dump_stack+0xc4/0x118 lib/dump_stack.c:56
> panic+0x1c6/0x38b kernel/panic.c:117
> __warn+0x170/0x1b9 kernel/panic.c:471
> warn_slowpath_fmt+0xc7/0xf8 kernel/panic.c:494
> debug_print_object+0x175/0x193 lib/debugobjects.c:260
> debug_object_assert_init+0x171/0x1bf lib/debugobjects.c:614
> debug_timer_assert_init kernel/time/timer.c:629 [inline]
> debug_assert_init kernel/time/timer.c:677 [inline]
> del_timer+0x7c/0x179 kernel/time/timer.c:1034
> try_to_grab_pending+0x81/0x2e5 kernel/workqueue.c:1230
> cancel_delayed_work+0x7c/0x1c4 kernel/workqueue.c:2929
> l2cap_clear_timer+0x1e/0x41 include/net/bluetooth/l2cap.h:834
> l2cap_chan_del+0x2d8/0x37e net/bluetooth/l2cap_core.c:640
> l2cap_chan_close+0x532/0x5d8 net/bluetooth/l2cap_core.c:756
> l2cap_sock_shutdown+0x806/0x969 net/bluetooth/l2cap_sock.c:1174
> l2cap_sock_release+0x64/0x14d net/bluetooth/l2cap_sock.c:1217
> __sock_release+0xda/0x217 net/socket.c:580
> sock_close+0x1b/0x1f net/socket.c:1039
> __fput+0x322/0x55c fs/file_table.c:208
> ____fput+0x17/0x19 fs/file_table.c:244
> task_work_run+0x19b/0x1d3 kernel/task_work.c:115
> exit_task_work include/linux/task_work.h:21 [inline]
> do_exit+0xe4c/0x204a kernel/exit.c:766
> do_group_exit+0x291/0x291 kernel/exit.c:891
> get_signal+0x749/0x1093 kernel/signal.c:2396
> do_signal+0xa5/0xcdb arch/x86/kernel/signal.c:737
> exit_to_usermode_loop arch/x86/entry/common.c:243 [inline]
> prepare_exit_to_usermode+0xed/0x235 arch/x86/entry/common.c:277
> syscall_return_slowpath+0x3a7/0x3b3 arch/x86/entry/common.c:348
> int_ret_from_sys_call+0x25/0xa3
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reported-by: syzbot+338f014a98367a08a114@syzkaller.appspotmail.com
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Guenter Roeck <groeck@chromium.org>
> ---
> 
> net/bluetooth/l2cap_core.c | 2 ++
> 1 file changed, 2 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

