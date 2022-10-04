Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425BB5F493A
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 20:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJDSZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 14:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJDSZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 14:25:07 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D892193FE;
        Tue,  4 Oct 2022 11:25:05 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j16so10666876wrh.5;
        Tue, 04 Oct 2022 11:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=Jan5nRCDQ+UR8GUN4PVwltNHXCiDhEcP4Tx6bA2+fr0=;
        b=T7WFtlznvUmwtjzmPKgxj2SAodXHYvT3m6bfi2VIEfR8fy2GtKORycxF4ZNottdYtB
         N/PIuOvAfOojuQRKiwFscEkFxw63EVYSyu5TNtdqdX3wVGq4KTyEq8LWNsgtaPyxiqzj
         fA7M7WeB41CxWeHK1ATnQSsVsWYOOcQBaZlka818I13ybk1AFzGijmy2j4yFL1B7pNNR
         sRz2SjFrlnGqKAoYgTXiwBZHJHF0f2lFS8HxZUBZss/xRavezTmHes+KtQjAnZpujTxX
         eo3xMoen3DAkvboufKP32GG+x95lvdBLLlHZrzUqQCiW0dyCoooAjuR5VSFiOfl6vKYC
         c33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Jan5nRCDQ+UR8GUN4PVwltNHXCiDhEcP4Tx6bA2+fr0=;
        b=zVhZsJ17AfNRYGiYiZQsH1WDcBaqZhav8Vx5/rml8J0YCAxaUrUkBmsM49e6F+HaxK
         TqnimkWL6rrKlsp19PIz7MxrzdoeXNkWe7a6lJmIO2DHZ8Ey61Mp6XO+P15kQcz4M5bl
         VfXbOBDtAPWhLENTFC8bz3N4hWvVpXN80AcLeKA/AuiqmgzUeoO/PyV97YXBeOWIeblc
         wKqJBuxRpFclp60QPjanu02FwiU4KTsVZPBS22xngyV4gkozaoy2hX7hzonUwewri2XA
         kJLVqo4/Y2aT+fzC/5kWqyeRwLfn1XvuYfJZstl9w/4sBivjMD/DgvSedaSOm0YJ5BKD
         hvRw==
X-Gm-Message-State: ACrzQf1YWfbuNkJD8g1RsKhJoOPIa4rvFIgozrJ9zzPzlz+IQrcMNhTA
        KZ3RnUl5KAYZR6tBBXNrb4c/j0YapM38ZOpl+cI=
X-Google-Smtp-Source: AMsMyM4Rw6xDO1YJlI/owKU2hFIxhWEPWJoa0sSvH9WVrBZ1rjMHEQJ7xEaLyao513hLlTqrcsMnDBfCvtdkPE1K7zA=
X-Received: by 2002:a5d:6181:0:b0:22e:3db0:67a2 with SMTP id
 j1-20020a5d6181000000b0022e3db067a2mr7202331wru.257.1664907903565; Tue, 04
 Oct 2022 11:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221003172506.479790-1-maxtram95@gmail.com> <CABBYNZKuRvUWQ0OdUfk35qnHoUgFzdq2dN4+N+RHR+01_PM2Xw@mail.gmail.com>
In-Reply-To: <CABBYNZKuRvUWQ0OdUfk35qnHoUgFzdq2dN4+N+RHR+01_PM2Xw@mail.gmail.com>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Tue, 4 Oct 2022 21:24:37 +0300
Message-ID: <CAKErNvpfAYGPSNmsWx7CQmPEYvfEhC_ab43rTSP2qHNitr0MFQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
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
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 3, 2022 at 10:13 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Maxim,
>
> On Mon, Oct 3, 2022 at 10:25 AM Maxim Mikityanskiy <maxtram95@gmail.com> =
wrote:
> >
> > Fix the race condition between the following two flows that run in
> > parallel:
> >
> > 1. l2cap_reassemble_sdu -> chan->ops->recv -> l2cap_sock_recv_cb ->
> >    __sock_queue_rcv_skb.
> >
> > 2. bt_sock_recvmsg -> skb_recv_datagram, skb_free_datagram.
> >
> > An SKB can be queued by the first flow and immediately dequeued and
> > freed by the second flow, therefore the callers of l2cap_reassemble_sdu
> > can't use the SKB after that function returns. However, some places
> > continue accessing struct l2cap_ctrl that resides in the SKB's CB for a
> > short time after l2cap_reassemble_sdu returns, leading to a
> > use-after-free condition (the stack trace is below, line numbers for
> > kernel 5.19.8).
> >
> > Fix it by keeping a local copy of struct l2cap_ctrl.
> >
> > BUG: KASAN: use-after-free in l2cap_rx_state_recv (net/bluetooth/l2cap_=
core.c:6906) bluetooth
> > Read of size 1 at addr ffff88812025f2f0 by task kworker/u17:3/43169
> >
> > Workqueue: hci0 hci_rx_work [bluetooth]
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
> >  print_report.cold (mm/kasan/report.c:314 mm/kasan/report.c:429)
> >  ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
> >  kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:493)
> >  ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
> >  l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:6906) bluetooth
> >  l2cap_rx (net/bluetooth/l2cap_core.c:7236 net/bluetooth/l2cap_core.c:7=
271) bluetooth
> >  ? sk_filter_trim_cap (net/core/filter.c:123)
> >  ? l2cap_chan_hold_unless_zero (./arch/x86/include/asm/atomic.h:202 ./i=
nclude/linux/atomic/atomic-instrumented.h:560 ./include/linux/refcount.h:15=
7 ./include/linux/refcount.h:227 ./include/linux/refcount.h:245 ./include/l=
inux/kref.h:111 net/bluetooth/l2cap_core.c:517) bluetooth
> >  ? l2cap_rx_state_recv (net/bluetooth/l2cap_core.c:7252) bluetooth
> >  l2cap_recv_frame (net/bluetooth/l2cap_core.c:7405 net/bluetooth/l2cap_=
core.c:7620 net/bluetooth/l2cap_core.c:7723) bluetooth
> >  ? lock_release (./include/trace/events/lock.h:69 kernel/locking/lockde=
p.c:5677)
> >  ? hci_rx_work (net/bluetooth/hci_core.c:3637 net/bluetooth/hci_core.c:=
3832) bluetooth
> >  ? reacquire_held_locks (kernel/locking/lockdep.c:5674)
> >  ? trace_contention_end (./include/trace/events/lock.h:122 ./include/tr=
ace/events/lock.h:122)
> >  ? l2cap_config_rsp.isra.0 (net/bluetooth/l2cap_core.c:7674) bluetooth
> >  ? hci_rx_work (./include/net/bluetooth/hci_core.h:1024 net/bluetooth/h=
ci_core.c:3634 net/bluetooth/hci_core.c:3832) bluetooth
> >  ? lock_acquire (./include/trace/events/lock.h:24 kernel/locking/lockde=
p.c:5637)
> >  ? __mutex_unlock_slowpath (./arch/x86/include/asm/atomic64_64.h:190 ./=
include/linux/atomic/atomic-long.h:449 ./include/linux/atomic/atomic-instru=
mented.h:1790 kernel/locking/mutex.c:924)
> >  ? rcu_read_lock_sched_held (kernel/rcu/update.c:104 kernel/rcu/update.=
c:123)
> >  ? memcpy (mm/kasan/shadow.c:65 (discriminator 1))
> >  ? l2cap_recv_frag (net/bluetooth/l2cap_core.c:8340) bluetooth
> >  l2cap_recv_acldata (net/bluetooth/l2cap_core.c:8486) bluetooth
> >  hci_rx_work (net/bluetooth/hci_core.c:3642 net/bluetooth/hci_core.c:38=
32) bluetooth
> >  process_one_work (kernel/workqueue.c:2289)
> >  ? lock_downgrade (kernel/locking/lockdep.c:5634)
> >  ? pwq_dec_nr_in_flight (kernel/workqueue.c:2184)
> >  ? rwlock_bug.part.0 (kernel/locking/spinlock_debug.c:113)
> >  worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
> >  ? __kthread_parkme (./arch/x86/include/asm/bitops.h:207 (discriminator=
 4) ./include/asm-generic/bitops/instrumented-non-atomic.h:135 (discriminat=
or 4) kernel/kthread.c:270 (discriminator 4))
> >  ? process_one_work (kernel/workqueue.c:2379)
> >  kthread (kernel/kthread.c:376)
> >  ? kthread_complete_and_exit (kernel/kthread.c:331)
> >  ret_from_fork (arch/x86/entry/entry_64.S:306)
> >  </TASK>
> >
> > Allocated by task 43169:
> >  kasan_save_stack (mm/kasan/common.c:39)
> >  __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasa=
n/common.c:469)
> >  kmem_cache_alloc_node (mm/slab.h:750 mm/slub.c:3243 mm/slub.c:3293)
> >  __alloc_skb (net/core/skbuff.c:414)
> >  l2cap_recv_frag (./include/net/bluetooth/bluetooth.h:425 net/bluetooth=
/l2cap_core.c:8329) bluetooth
> >  l2cap_recv_acldata (net/bluetooth/l2cap_core.c:8442) bluetooth
> >  hci_rx_work (net/bluetooth/hci_core.c:3642 net/bluetooth/hci_core.c:38=
32) bluetooth
> >  process_one_work (kernel/workqueue.c:2289)
> >  worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
> >  kthread (kernel/kthread.c:376)
> >  ret_from_fork (arch/x86/entry/entry_64.S:306)
> >
> > Freed by task 27920:
> >  kasan_save_stack (mm/kasan/common.c:39)
> >  kasan_set_track (mm/kasan/common.c:45)
> >  kasan_set_free_info (mm/kasan/generic.c:372)
> >  ____kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328)
> >  slab_free_freelist_hook (mm/slub.c:1780)
> >  kmem_cache_free (mm/slub.c:3536 mm/slub.c:3553)
> >  skb_free_datagram (./include/net/sock.h:1578 ./include/net/sock.h:1639=
 net/core/datagram.c:323)
> >  bt_sock_recvmsg (net/bluetooth/af_bluetooth.c:295) bluetooth
> >  l2cap_sock_recvmsg (net/bluetooth/l2cap_sock.c:1212) bluetooth
> >  sock_read_iter (net/socket.c:1087)
> >  new_sync_read (./include/linux/fs.h:2052 fs/read_write.c:401)
> >  vfs_read (fs/read_write.c:482)
> >  ksys_read (fs/read_write.c:620)
> >  do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> >  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> >
> > Link: https://lore.kernel.org/linux-bluetooth/CAKErNvoqga1WcmoR3-0875es=
Y6TVWFQDandbVZncSiuGPBQXLA@mail.gmail.com/T/#u
> > Fixes: d2a7ac5d5d3a ("Bluetooth: Add the ERTM receive state machine")
> > Fixes: 4b51dae96731 ("Bluetooth: Add streaming mode receive and incomin=
g packet classifier")
> > Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> > ---
> >  net/bluetooth/l2cap_core.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > index 2c9de67daadc..6bdce147d2fe 100644
> > --- a/net/bluetooth/l2cap_core.c
> > +++ b/net/bluetooth/l2cap_core.c
> > @@ -6876,6 +6876,7 @@ static int l2cap_rx_state_recv(struct l2cap_chan =
*chan,
> >                                struct l2cap_ctrl *control,
> >                                struct sk_buff *skb, u8 event)
> >  {
> > +       struct l2cap_ctrl local_control;
> >         int err =3D 0;
> >         bool skb_in_use =3D false;
> >
> > @@ -6900,15 +6901,16 @@ static int l2cap_rx_state_recv(struct l2cap_cha=
n *chan,
> >                         chan->buffer_seq =3D chan->expected_tx_seq;
> >                         skb_in_use =3D true;
> >
> > +                       local_control =3D *control;
>
> Have a comment on why we are creating a local copy,

OK, I'll add a comment.

> btw should we pass the copy to l2cap_reassemble_sdu?

No need, l2cap_reassemble_sdu only reads control->sar in the very
beginning and never accesses control afterwards.

>
> >                         err =3D l2cap_reassemble_sdu(chan, skb, control=
);
> >                         if (err)
> >                                 break;
> >
> > -                       if (control->final) {
> > +                       if (local_control.final) {
> >                                 if (!test_and_clear_bit(CONN_REJ_ACT,
> >                                                         &chan->conn_sta=
te)) {
> > -                                       control->final =3D 0;
> > -                                       l2cap_retransmit_all(chan, cont=
rol);
> > +                                       local_control.final =3D 0;
> > +                                       l2cap_retransmit_all(chan, &loc=
al_control);
> >                                         l2cap_ertm_send(chan);
> >                                 }
> >                         }
> > @@ -7288,11 +7290,12 @@ static int l2cap_rx(struct l2cap_chan *chan, st=
ruct l2cap_ctrl *control,
> >  static int l2cap_stream_rx(struct l2cap_chan *chan, struct l2cap_ctrl =
*control,
> >                            struct sk_buff *skb)
> >  {
> > +       u16 txseq =3D control->txseq;
> > +
> >         BT_DBG("chan %p, control %p, skb %p, state %d", chan, control, =
skb,
> >                chan->rx_state);
> >
> > -       if (l2cap_classify_txseq(chan, control->txseq) =3D=3D
> > -           L2CAP_TXSEQ_EXPECTED) {
> > +       if (l2cap_classify_txseq(chan, txseq) =3D=3D L2CAP_TXSEQ_EXPECT=
ED) {
> >                 l2cap_pass_to_tx(chan, control);
> >
> >                 BT_DBG("buffer_seq %u->%u", chan->buffer_seq,
> > @@ -7315,8 +7318,8 @@ static int l2cap_stream_rx(struct l2cap_chan *cha=
n, struct l2cap_ctrl *control,
> >                 }
> >         }
> >
> > -       chan->last_acked_seq =3D control->txseq;
> > -       chan->expected_tx_seq =3D __next_seq(chan, control->txseq);
> > +       chan->last_acked_seq =3D txseq;
> > +       chan->expected_tx_seq =3D __next_seq(chan, txseq);
> >
> >         return 0;
> >  }
> > --
> > 2.37.3
> >
>
>
> --
> Luiz Augusto von Dentz
