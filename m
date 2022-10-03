Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8C5F3625
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 21:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiJCTN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 15:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJCTN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 15:13:26 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4173426126;
        Mon,  3 Oct 2022 12:13:25 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id o7so10717258lfk.7;
        Mon, 03 Oct 2022 12:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=pcG/AXvAr0nSG9oHNQHRid2TENtJO2V1KhXwduHAQh4=;
        b=ekblUOgFXoVJj0lGdQze7tH7MimhKe9lViNLPBny3ZMMdw/v56OWIBXhX3OOPfmg2T
         6/gIbq9KLoxMrTpduMyVO9Il5RDirebV2VaussXkUvm1ySbxRxbRhfiLHGTcwz5R9vqC
         uD8iFCkEgmE/8gBDuzC9sW8ftHvfb0KeDHALEKpqrYEve/GKthp1GMAAfiV3KJIuU2Zi
         vv0DtYFiBe47bP3dFFxRQcHRNOuqJEbNxzqFpFVT4IY26LSiZiI0BHrAEU97Zj5wnAtS
         ZHns6CFy/uT98dzJzf0kvXeLoKErfhACxW1mQtbmOMRkHYAw0FNcDaSrvpZDYBWbPyYu
         jz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pcG/AXvAr0nSG9oHNQHRid2TENtJO2V1KhXwduHAQh4=;
        b=bOhu9Y420x3TL8jPyRv33sA2xmGllxEJ+J6W+ttdQWA4ai3gZ0IRt8HKNImY9rgOLY
         h7DXRyjZg++h2y/XJtodDx8vfzg6hMlQUcBbOX8J3c0IlUFQEKf2gsiFHzS/MeaREJaR
         +RWTZrovTdlFPnLQIGeXaR4XRjSy9E25aTBGZ5o549zCMApkE9O7NfbvPrNj7U7PuR8N
         yy0AqRCpSJV9WxHATGgDQkibmHK5lSstCA76XICrwL4W4wN6oa0EjD2gTSLcGVa9TLAp
         HMNik+4D35W5tBR4xXss6Kb4yCmSyEG8r8kMWSWh4rteeGXFcIfJmrH0Qlqm5kXCQv22
         3yLg==
X-Gm-Message-State: ACrzQf3NMbltHAEcsGwCDMgc1PY+plJ9QfCk1h9L1TyV2OLuBGLFVZBc
        AZZMCWWv9ofvgBaJsywHKLImZd638AGalmjwhOk=
X-Google-Smtp-Source: AMsMyM4GQ54uYv365oVaXgy+EilJx2YDlzEnKs25IcpGBIkQP0KWKF8a0qiaLFgJF93DK9NtVRVpnXMhMHfFGCob19s=
X-Received: by 2002:ac2:5f56:0:b0:4a2:40f6:266c with SMTP id
 22-20020ac25f56000000b004a240f6266cmr1704334lfz.564.1664824403195; Mon, 03
 Oct 2022 12:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221003172506.479790-1-maxtram95@gmail.com>
In-Reply-To: <20221003172506.479790-1-maxtram95@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 3 Oct 2022 12:13:10 -0700
Message-ID: <CABBYNZKuRvUWQ0OdUfk35qnHoUgFzdq2dN4+N+RHR+01_PM2Xw@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

On Mon, Oct 3, 2022 at 10:25 AM Maxim Mikityanskiy <maxtram95@gmail.com> wr=
ote:
>
> Fix the race condition between the following two flows that run in
> parallel:
>
> 1. l2cap_reassemble_sdu -> chan->ops->recv -> l2cap_sock_recv_cb ->
>    __sock_queue_rcv_skb.
>
> 2. bt_sock_recvmsg -> skb_recv_datagram, skb_free_datagram.
>
> An SKB can be queued by the first flow and immediately dequeued and
> freed by the second flow, therefore the callers of l2cap_reassemble_sdu
> can't use the SKB after that function returns. However, some places
> continue accessing struct l2cap_ctrl that resides in the SKB's CB for a
> short time after l2cap_reassemble_sdu returns, leading to a
> use-after-free condition (the stack trace is below, line numbers for
> kernel 5.19.8).
>
> Fix it by keeping a local copy of struct l2cap_ctrl.
>
> BUG: KASAN: use-after-free in l2cap_rx_state_recv (net/bluetooth/l2cap_co=
re.c:6906) bluetooth
> Read of size 1 at addr ffff88812025f2f0 by task kworker/u17:3/43169
>
> Workqueue: hci0 hci_rx_work [bluetooth]
> Call Trace:
>  <TASK>
>  dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
>  print_report.cold (mm/kasan/report.c:314 mm/kasan/report.c:429)
>  ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
>  kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:493)
>  ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
>  l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
>  l2cap_rx (net/bluetooth/l2cap_core.c:7236 net/bluetooth/l2cap_core.c:727=
1) bluetooth
>  ? sk_filter_trim_cap (net/core/filter.c:123)
>  ? l2cap_chan_hold_unless_zero (./arch/x86/include/asm/atomic.h:202 ./inc=
lude/linux/atomic/atomic-instrumented.h:560 ./include/linux/refcount.h:157 =
./include/linux/refcount.h:227 ./include/linux/refcount.h:245 ./include/lin=
ux/kref.h:111 net/bluetooth/l2cap_core.c:517) bluetooth
>  ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:7252) bluetooth
>  l2cap_recv_frame (net/bluetooth/l2cap_core.c:7405 net/bluetooth/l2cap_co=
re.c:7620 net/bluetooth/l2cap_core.c:7723) bluetooth
>  ? lock_release (./include/trace/events/lock.h:69 kernel/locking/lockdep.=
c:5677)
>  ? hci_rx_work (net/bluetooth/hci_core.c:3637 net/bluetooth/hci_core.c:38=
32) bluetooth
>  ? reacquire_held_locks (kernel/locking/lockdep.c:5674)
>  ? trace_contention_end (./include/trace/events/lock.h:122 ./include/trac=
e/events/lock.h:122)
>  ? l2cap_config_rsp.isra.0 (net/bluetooth/l2cap_core.c:7674) bluetooth
>  ? hci_rx_work (./include/net/bluetooth/hci_core.h:1024 net/bluetooth/hci=
_core.c:3634 net/bluetooth/hci_core.c:3832) bluetooth
>  ? lock_acquire (./include/trace/events/lock.h:24 kernel/locking/lockdep.=
c:5637)
>  ? __mutex_unlock_slowpath (./arch/x86/include/asm/atomic64_64.h:190 ./in=
clude/linux/atomic/atomic-long.h:449 ./include/linux/atomic/atomic-instrume=
nted.h:1790 kernel/locking/mutex.c:924)
>  ? rcu_read_lock_sched_held (kernel/rcu/update.c:104 kernel/rcu/update.c:=
123)
>  ? memcpy (mm/kasan/shadow.c:65 (discriminator 1))
>  ? l2cap_recv_frag (net/bluetooth/l2cap_core.c:8340) bluetooth
>  l2cap_recv_acldata (net/bluetooth/l2cap_core.c:8486) bluetooth
>  hci_rx_work (net/bluetooth/hci_core.c:3642 net/bluetooth/hci_core.c:3832=
) bluetooth
>  process_one_work (kernel/workqueue.c:2289)
>  ? lock_downgrade (kernel/locking/lockdep.c:5634)
>  ? pwq_dec_nr_in_flight (kernel/workqueue.c:2184)
>  ? rwlock_bug.part.0 (kernel/locking/spinlock_debug.c:113)
>  worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
>  ? __kthread_parkme (./arch/x86/include/asm/bitops.h:207 (discriminator 4=
) ./include/asm-generic/bitops/instrumented-non-atomic.h:135 (discriminator=
 4) kernel/kthread.c:270 (discriminator 4))
>  ? process_one_work (kernel/workqueue.c:2379)
>  kthread (kernel/kthread.c:376)
>  ? kthread_complete_and_exit (kernel/kthread.c:331)
>  ret_from_fork (arch/x86/entry/entry_64.S:306)
>  </TASK>
>
> Allocated by task 43169:
>  kasan_save_stack (mm/kasan/common.c:39)
>  __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/=
common.c:469)
>  kmem_cache_alloc_node (mm/slab.h:750 mm/slub.c:3243 mm/slub.c:3293)
>  __alloc_skb (net/core/skbuff.c:414)
>  l2cap_recv_frag (./include/net/bluetooth/bluetooth.h:425 net/bluetooth/l=
2cap_core.c:8329) bluetooth
>  l2cap_recv_acldata (net/bluetooth/l2cap_core.c:8442) bluetooth
>  hci_rx_work (net/bluetooth/hci_core.c:3642 net/bluetooth/hci_core.c:3832=
) bluetooth
>  process_one_work (kernel/workqueue.c:2289)
>  worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
>  kthread (kernel/kthread.c:376)
>  ret_from_fork (arch/x86/entry/entry_64.S:306)
>
> Freed by task 27920:
>  kasan_save_stack (mm/kasan/common.c:39)
>  kasan_set_track (mm/kasan/common.c:45)
>  kasan_set_free_info (mm/kasan/generic.c:372)
>  ____kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328)
>  slab_free_freelist_hook (mm/slub.c:1780)
>  kmem_cache_free (mm/slub.c:3536 mm/slub.c:3553)
>  skb_free_datagram (./include/net/sock.h:1578 ./include/net/sock.h:1639 n=
et/core/datagram.c:323)
>  bt_sock_recvmsg (net/bluetooth/af_bluetooth.c:295) bluetooth
>  l2cap_sock_recvmsg (net/bluetooth/l2cap_sock.c:1212) bluetooth
>  sock_read_iter (net/socket.c:1087)
>  new_sync_read (./include/linux/fs.h:2052 fs/read_write.c:401)
>  vfs_read (fs/read_write.c:482)
>  ksys_read (fs/read_write.c:620)
>  do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
>  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
>
> Link: https://lore.kernel.org/linux-bluetooth/CAKErNvoqga1WcmoR3-0875esY6=
TVWFQDandbVZncSiuGPBQXLA@mail.gmail.com/T/#u
> Fixes: d2a7ac5d5d3a ("Bluetooth: Add the ERTM receive state machine")
> Fixes: 4b51dae96731 ("Bluetooth: Add streaming mode receive and incoming =
packet classifier")
> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> ---
>  net/bluetooth/l2cap_core.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 2c9de67daadc..6bdce147d2fe 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -6876,6 +6876,7 @@ static int l2cap_rx_state_recv(struct l2cap_chan *c=
han,
>                                struct l2cap_ctrl *control,
>                                struct sk_buff *skb, u8 event)
>  {
> +       struct l2cap_ctrl local_control;
>         int err =3D 0;
>         bool skb_in_use =3D false;
>
> @@ -6900,15 +6901,16 @@ static int l2cap_rx_state_recv(struct l2cap_chan =
*chan,
>                         chan->buffer_seq =3D chan->expected_tx_seq;
>                         skb_in_use =3D true;
>
> +                       local_control =3D *control;

Have a comment on why we are creating a local copy, btw should we pass
the copy to l2cap_reassemble_sdu?

>                         err =3D l2cap_reassemble_sdu(chan, skb, control);
>                         if (err)
>                                 break;
>
> -                       if (control->final) {
> +                       if (local_control.final) {
>                                 if (!test_and_clear_bit(CONN_REJ_ACT,
>                                                         &chan->conn_state=
)) {
> -                                       control->final =3D 0;
> -                                       l2cap_retransmit_all(chan, contro=
l);
> +                                       local_control.final =3D 0;
> +                                       l2cap_retransmit_all(chan, &local=
_control);
>                                         l2cap_ertm_send(chan);
>                                 }
>                         }
> @@ -7288,11 +7290,12 @@ static int l2cap_rx(struct l2cap_chan *chan, stru=
ct l2cap_ctrl *control,
>  static int l2cap_stream_rx(struct l2cap_chan *chan, struct l2cap_ctrl *c=
ontrol,
>                            struct sk_buff *skb)
>  {
> +       u16 txseq =3D control->txseq;
> +
>         BT_DBG("chan %p, control %p, skb %p, state %d", chan, control, sk=
b,
>                chan->rx_state);
>
> -       if (l2cap_classify_txseq(chan, control->txseq) =3D=3D
> -           L2CAP_TXSEQ_EXPECTED) {
> +       if (l2cap_classify_txseq(chan, txseq) =3D=3D L2CAP_TXSEQ_EXPECTED=
) {
>                 l2cap_pass_to_tx(chan, control);
>
>                 BT_DBG("buffer_seq %u->%u", chan->buffer_seq,
> @@ -7315,8 +7318,8 @@ static int l2cap_stream_rx(struct l2cap_chan *chan,=
 struct l2cap_ctrl *control,
>                 }
>         }
>
> -       chan->last_acked_seq =3D control->txseq;
> -       chan->expected_tx_seq =3D __next_seq(chan, control->txseq);
> +       chan->last_acked_seq =3D txseq;
> +       chan->expected_tx_seq =3D __next_seq(chan, txseq);
>
>         return 0;
>  }
> --
> 2.37.3
>


--=20
Luiz Augusto von Dentz
