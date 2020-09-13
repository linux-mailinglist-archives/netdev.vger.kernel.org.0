Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9BA267E6A
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 09:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgIMHq7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Sep 2020 03:46:59 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:47646 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgIMHq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 03:46:58 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5C168CECC4;
        Sun, 13 Sep 2020 09:53:50 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [RESEND PATCH] Bluetooth: Only mark socket zapped after unlocking
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200911153256.RESEND.1.Ic1b9d93cf2d393e3efda4c2977639c095d276311@changeid>
Date:   Sun, 13 Sep 2020 09:46:53 +0200
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6C5505B2-3C70-4484-9A1A-4425AE397640@holtmann.org>
References: <20200911153256.RESEND.1.Ic1b9d93cf2d393e3efda4c2977639c095d276311@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Since l2cap_sock_teardown_cb doesn't acquire the channel lock before
> setting the socket as zapped, it could potentially race with
> l2cap_sock_release which frees the socket. Thus, wait until the cleanup
> is complete before marking the socket as zapped.
> 
> This race was reproduced on a JBL GO speaker after the remote device
> rejected L2CAP connection due to resource unavailability.
> 
> Here is a dmesg log with debug logs from a repro of this bug:
> [ 3465.424086] Bluetooth: hci_core.c:hci_acldata_packet() hci0 len 16 handle 0x0003 flags 0x0002
> [ 3465.424090] Bluetooth: hci_conn.c:hci_conn_enter_active_mode() hcon 00000000cfedd07d mode 0
> [ 3465.424094] Bluetooth: l2cap_core.c:l2cap_recv_acldata() conn 000000007eae8952 len 16 flags 0x2
> [ 3465.424098] Bluetooth: l2cap_core.c:l2cap_recv_frame() len 12, cid 0x0001
> [ 3465.424102] Bluetooth: l2cap_core.c:l2cap_raw_recv() conn 000000007eae8952
> [ 3465.424175] Bluetooth: l2cap_core.c:l2cap_sig_channel() code 0x03 len 8 id 0x0c
> [ 3465.424180] Bluetooth: l2cap_core.c:l2cap_connect_create_rsp() dcid 0x0045 scid 0x0000 result 0x02 status 0x00
> [ 3465.424189] Bluetooth: l2cap_core.c:l2cap_chan_put() chan 000000006acf9bff orig refcnt 4
> [ 3465.424196] Bluetooth: l2cap_core.c:l2cap_chan_del() chan 000000006acf9bff, conn 000000007eae8952, err 111, state BT_CONNECT
> [ 3465.424203] Bluetooth: l2cap_sock.c:l2cap_sock_teardown_cb() chan 000000006acf9bff state BT_CONNECT
> [ 3465.424221] Bluetooth: l2cap_core.c:l2cap_chan_put() chan 000000006acf9bff orig refcnt 3
> [ 3465.424226] Bluetooth: hci_core.h:hci_conn_drop() hcon 00000000cfedd07d orig refcnt 6
> [ 3465.424234] BUG: spinlock bad magic on CPU#2, kworker/u17:0/159
> [ 3465.425626] Bluetooth: hci_sock.c:hci_sock_sendmsg() sock 000000002bb0cb64 sk 00000000a7964053
> [ 3465.430330]  lock: 0xffffff804410aac0, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> [ 3465.430332] Causing a watchdog bite!
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reported-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> ---
> We had some more data available (outside of dmesg and oops) that led us
> to suspect a race between l2cap_sock_teardown_cb and l2cap_sock_release.
> I've left this out of the commit message since it's not an oops or dmesg
> logs.
> 
> Crash stack from CPU4:
> --
> -24 |spin_bug(
>    |    [X19] lock = 0xFFFFFF810BDB1EC0,
>    |    [X20] msg = 0xFFFFFFD143FD7960)
> -25 |debug_spin_lock_before(inline)
>    |  [X19] lock = 0xFFFFFF810BDB1EC0
> -25 |do_raw_spin_lock(
>    |    [X19] lock = 0xFFFFFF810BDB1EC0)
> -26 |raw_spin_lock_irqsave(
>    |    [X19] lock = 0xFFFFFF810BDB1EC0)
> -27 |skb_peek(inline)
> -27 |__skb_dequeue(inline)
> -27 |skb_dequeue(
>    |    [X20] list = 0xFFFFFF810BDB1EA8)
>    |  [locdesc] flags = 12297829382473034410
> -28 |skb_queue_purge(
>    |    [X19] list = 0xFFFFFF810BDB1EA8 -> (
>    |      [D:0xFFFFFF810BDB1EA8] next = 0x0,
>    |      [D:0xFFFFFF810BDB1EB0] prev = 0x0,
>    |      [D:0xFFFFFF810BDB1EB8] qlen = 0,
>    |      [D:0xFFFFFF810BDB1EC0] lock = ([D:0xFFFFFF810BDB1EC0] rlock = ([D:0xFFFFFF810BDB1EC0] raw_lock
>    |  [X0] skb = ???
> -29 |l2cap_seq_list_free(inline)
>    |  [locdesc] seq_list = 0xFFFFFF810BDB1ED8 -> (
>    |    [D:0xFFFFFF810BDB1ED8] head = 0,
>    |    [D:0xFFFFFF810BDB1EDA] tail = 0,
>    |    [D:0xFFFFFF810BDB1EDC] mask = 0,
>    |    [D:0xFFFFFF810BDB1EE0] list = 0x0)
> -29 |l2cap_chan_del(
>    |    [X19] chan = 0xFFFFFF810BDB1C00,
>    |  ?)
> -30 |l2cap_chan_unlock(inline)
> -30 |l2cap_connect_create_rsp(inline)
>    |  [X20] conn = 0xFFFFFF81231F2600
>    |  [locdesc] err = 0
>    |  [X27] chan = 0xFFFFFF810BDB1C00
> -30 |l2cap_bredr_sig_cmd(inline)
>    |  [X20] conn = 0xFFFFFF81231F2600
>    |  [locdesc] err = 0
> -30 |l2cap_sig_channel(inline)
>    |  [X20] conn = 0xFFFFFF81231F2600
>    |  [X19] skb = 0xFFFFFF813DE4C040
>    |  [X28] data = 0xFFFFFF8131582014
>    |  [locdesc] cmd_len = 43690
> -30 |l2cap_recv_frame(
>    |    [X20] conn = 0xFFFFFF81231F2600,
>    |    [X19] skb = 0xFFFFFF813DE4C040)
>    |  [locdesc] psm = 43690
> -31 |l2cap_recv_acldata(
>    |  ?,
>    |    [X19] skb = 0xFFFFFF813DE4C040,
>    |  ?)
>    |  [X21] len = 16
> -32 |hci_rx_work(
>    |  ?)
>    |  [X21] hdev = 0xFFFFFF8133A02000
> -33 |__read_once_size(inline)
>    |  [locdesc] size = 4
> -33 |atomic_read(inline)
>    |  [locdesc] __u = ([locdesc] __val = -1431655766, [locdesc] __c = (170))
> -33 |static_key_count(inline)
> -33 |static_key_false(inline)
> -33 |trace_workqueue_execute_end(inline)
>    |  [X22] work = 0xFFFFFF8133A02838
> -33 |process_one_work(
>    |    [X19] worker = 0xFFFFFF8133FE4500,
>    |    [X22] work = 0xFFFFFF8133A02838)
>    |  [locdesc] work_color = -1431655766
> -34 |__read_once_size(inline)
>    |  [locdesc] size = 8
> -34 |list_empty(inline)
>    |  [locdesc] __u = ([locdesc] __val = 0xAAAAAAAAAAAAAAAA, [locdesc] __c = (170))
> -34 |worker_thread(
>    |    [X19] __worker = 0xFFFFFF8133FE4500)
>    |  [X19] worker = 0xFFFFFF8133FE4500
> -35 |kthread(
>    |    [X20] _create = 0xFFFFFF8133FB3A00)
>    |  [X20] create = 0xFFFFFF8133FB3A00
>    |  [X0] ret = ???
> -36 |ret_from_fork(asm)
> 
> net/bluetooth/l2cap_sock.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

