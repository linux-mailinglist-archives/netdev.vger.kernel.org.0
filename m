Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C2342BC5
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCTLMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhCTLMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:12:12 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CBAC0610D3
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 03:57:41 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id j2so1030174ybj.8
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 03:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lZGSyLhVISic5NIlVXr8fasNNFW8/T/a/U9VdScG2yk=;
        b=hX0qM8nMiQNGUKqXBU9VcnNlxIm7mIrpi8xb64HY0bWm4DmQ8hSVpi/MLnOF2zibOU
         3IPSgTrByBjRBkGFGih4dLmb1B/Pzv4iYYxOekpfqhSPA5CPOK3juug8/cWrRddYMNUJ
         omcwsLmn/LbfR8zJLhobc09A+oSfoeJISIFXkb3OiCoQqUKYVtfqxh+b85qPEb30ajVp
         MN+jqT1LOU+yT08dkkvcScw718alJ1io96K5WTCLoAF8yhtXLASRfpKcEuwNLIYLIHjA
         r6eyJi4WF/TIc/31btpwIl3OitBltPBfo7IQq50mHZFl+DNoC41/58zphhFXzXKAoJA9
         Rmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lZGSyLhVISic5NIlVXr8fasNNFW8/T/a/U9VdScG2yk=;
        b=ktxLbiS8/N9+PYOejwy8eCUmae2El2Ns12kjTLyEbMCNOj/DCGFZbhVBVQmF3ulcYm
         d5re11TzT7h59dnMT9UpZX1DIaaQSFzB3ZECB4w/9YWCWJZWUH7zkhXibRdQ7H4aKcY6
         cHsm9rU3gCqyCqgDVOsvQwIFZAQfLZ7J+go5DzTwQEQvYVIhCIxNVhBMn+mRKcu37WvE
         BdKxI5KbPicluBkPAdeEWhh0L9m5rxlLkh+J7o41aH87tElQR0QHsvYzfbWeIAgHvj2z
         WBOKXHpanmXd01Tvk/7ZftF+5rKjXGZVjCHdB55xjYgh2+/ZRuQYs7UO/FLITrG2gNrA
         +N7g==
X-Gm-Message-State: AOAM5318T0QqOsS1HylK7LXrGa2rM/xmQhF7T0+gSrnAvIhV3qjJSXPv
        1oJli0nT3KE57+3N0OjV3YAZsPa0xD66kmSaO9lPUTT0QSA=
X-Google-Smtp-Source: ABdhPJx84zY7crfdeTqFgteJgzxFAD0r81tApZCNvB06fvqH1UDEaJjqk6fU18yG6/wYHiXhtv+t+T/PejG3eHDzJW0=
X-Received: by 2002:a05:6902:708:: with SMTP id k8mr4154711ybt.234.1616234167022;
 Sat, 20 Mar 2021 02:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210316223647.4080796-1-weiwan@google.com> <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
In-Reply-To: <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 20 Mar 2021 10:55:55 +0100
Message-ID: <CANn89iJxXOZktXv6Arh82OAGOpn523NuOcWFDaSmJriOaXQMRw@mail.gmail.com>
Subject: Re: [PATCH net v4] net: fix race between napi kthread mode and busy poll
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 9:45 AM Martin Zaharinov <micron10@gmail.com> wrote=
:
>
> Hi Wei
> Check this:
>
> [   39.706567] ------------[ cut here ]------------
> [   39.706568] RTNL: assertion failed at net/ipv4/udp_tunnel_nic.c (557)
> [   39.706585] WARNING: CPU: 0 PID: 429 at net/ipv4/udp_tunnel_nic.c:557 =
__udp_tunnel_nic_reset_ntf+0xea/0x100

Probably more relevant to Intel maintainers than Wei :/

> [   39.706594] Modules linked in: i40e(+) nf_nat_sip nf_conntrack_sip nf_=
nat_pptp nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp nf_conn=
track_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_=
si ipmi_devintf ipmi_msghandler rtc_cmos megaraid_sas
> [   39.706614] CPU: 0 PID: 429 Comm: kworker/0:2 Tainted: G           O  =
    5.11.7 #1
> [   39.706618] Hardware name: Supermicro X11DPi-N(T)/X11DPi-NT, BIOS 3.4 =
11/23/2020
> [   39.706619] Workqueue: events work_for_cpu_fn
> [   39.706627] RIP: 0010:__udp_tunnel_nic_reset_ntf+0xea/0x100
> [   39.706631] Code: c0 79 f1 00 00 0f 85 4e ff ff ff ba 2d 02 00 00 48 c=
7 c6 45 3c 3a 93 48 c7 c7 40 de 39 93 c6 05 a0 79 f1 00 01 e8 f5 ad 0c 00 <=
0f> 0b e9 28 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00
> [   39.706634] RSP: 0018:ffffa8390d9b3b38 EFLAGS: 00010292
> [   39.706637] RAX: 0000000000000039 RBX: ffff8e02630b2768 RCX: 00000000f=
fdfffff
> [   39.706639] RDX: 00000000ffdfffff RSI: ffff8e80ad400000 RDI: 000000000=
0000001
> [   39.706641] RBP: ffff8e025df72000 R08: ffff8e80bb3fffe8 R09: 00000000f=
fffffea
> [   39.706643] R10: 00000000ffdfffff R11: 80000000ffe00000 R12: ffff8e026=
30b2008
> [   39.706645] R13: 0000000000000000 R14: ffff8e024a88ba00 R15: 000000000=
0000000
> [   39.706646] FS:  0000000000000000(0000) GS:ffff8e40bf800000(0000) knlG=
S:0000000000000000
> [   39.706649] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   39.706651] CR2: 00000000004d8f40 CR3: 0000002ca140a002 CR4: 000000000=
01706f0
> [   39.706652] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [   39.706654] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [   39.706656] Call Trace:
> [   39.706658]  i40e_setup_pf_switch+0x617/0xf80 [i40e]
> [   39.706683]  i40e_probe.part.0.cold+0x8dc/0x109e [i40e]
> [   39.706708]  ? acpi_ns_check_object_type+0xd4/0x193
> [   39.706713]  ? acpi_ns_check_package_list+0xfd/0x205
> [   39.706716]  ? __kmalloc+0x37/0x160
> [   39.706720]  ? kmem_cache_alloc+0xcb/0x120
> [   39.706723]  ? irq_get_irq_data+0x5/0x20
> [   39.706726]  ? mp_check_pin_attr+0xe/0xf0
> [   39.706729]  ? irq_get_irq_data+0x5/0x20
> [   39.706731]  ? mp_map_pin_to_irq+0xb7/0x2c0
> [   39.706735]  ? acpi_register_gsi_ioapic+0x86/0x150
> [   39.706739]  ? pci_conf1_read+0x9f/0xf0
> [   39.706743]  ? pci_bus_read_config_word+0x2e/0x40
> [   39.706746]  local_pci_probe+0x1b/0x40
> [   39.706750]  work_for_cpu_fn+0xb/0x20
> [   39.706754]  process_one_work+0x1ec/0x350
> [   39.706758]  worker_thread+0x24b/0x4d0
> [   39.706760]  ? process_one_work+0x350/0x350
> [   39.706762]  kthread+0xea/0x120
> [   39.706766]  ? kthread_park+0x80/0x80
> [   39.706770]  ret_from_fork+0x1f/0x30
> [   39.706774] ---[ end trace 7a203f3ec972a377 ]---
>
> Martin
>
>
> > On 17 Mar 2021, at 0:36, Wei Wang <weiwan@google.com> wrote:
> >
> > Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> > determine if the kthread owns this napi and could call napi->poll() on
> > it. However, if socket busy poll is enabled, it is possible that the
> > busy poll thread grabs this SCHED bit (after the previous napi->poll()
> > invokes napi_complete_done() and clears SCHED bit) and tries to poll
> > on the same napi. napi_disable() could grab the SCHED bit as well.
> > This patch tries to fix this race by adding a new bit
> > NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> > ____napi_schedule() if the threaded mode is enabled, and gets cleared
> > in napi_complete_done(), and we only poll the napi in kthread if this
> > bit is set. This helps distinguish the ownership of the napi between
> > kthread and other scenarios and fixes the race issue.
> >
> > Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop suppo=
rt")
> > Reported-by: Martin Zaharinov <micron10@gmail.com>
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > ---
> > Change since v3:
> >  - Add READ_ONCE() for thread->state and add comments in
> >    ____napi_schedule().
> >
> > include/linux/netdevice.h |  2 ++
> > net/core/dev.c            | 19 ++++++++++++++++++-
> > 2 files changed, 20 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 5b67ea89d5f2..87a5d186faff 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -360,6 +360,7 @@ enum {
> >       NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI =
*/
> >       NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softi=
rq processing*/
> >       NAPI_STATE_THREADED,            /* The poll is performed inside i=
ts own thread*/
> > +     NAPI_STATE_SCHED_THREADED,      /* Napi is currently scheduled in=
 threaded mode */
> > };
> >
> > enum {
> > @@ -372,6 +373,7 @@ enum {
> >       NAPIF_STATE_IN_BUSY_POLL        =3D BIT(NAPI_STATE_IN_BUSY_POLL),
> >       NAPIF_STATE_PREFER_BUSY_POLL    =3D BIT(NAPI_STATE_PREFER_BUSY_PO=
LL),
> >       NAPIF_STATE_THREADED            =3D BIT(NAPI_STATE_THREADED),
> > +     NAPIF_STATE_SCHED_THREADED      =3D BIT(NAPI_STATE_SCHED_THREADED=
),
> > };
> >
> > enum gro_result {
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 6c5967e80132..d3195a95f30e 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4294,6 +4294,13 @@ static inline void ____napi_schedule(struct soft=
net_data *sd,
> >                */
> >               thread =3D READ_ONCE(napi->thread);
> >               if (thread) {
> > +                     /* Avoid doing set_bit() if the thread is in
> > +                      * INTERRUPTIBLE state, cause napi_thread_wait()
> > +                      * makes sure to proceed with napi polling
> > +                      * if the thread is explicitly woken from here.
> > +                      */
> > +                     if (READ_ONCE(thread->state) !=3D TASK_INTERRUPTI=
BLE)
> > +                             set_bit(NAPI_STATE_SCHED_THREADED, &napi-=
>state);
> >                       wake_up_process(thread);
> >                       return;
> >               }
> > @@ -6486,6 +6493,7 @@ bool napi_complete_done(struct napi_struct *n, in=
t work_done)
> >               WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
> >
> >               new =3D val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> > +                           NAPIF_STATE_SCHED_THREADED |
> >                             NAPIF_STATE_PREFER_BUSY_POLL);
> >
> >               /* If STATE_MISSED was set, leave STATE_SCHED set,
> > @@ -6968,16 +6976,25 @@ static int napi_poll(struct napi_struct *n, str=
uct list_head *repoll)
> >
> > static int napi_thread_wait(struct napi_struct *napi)
> > {
> > +     bool woken =3D false;
> > +
> >       set_current_state(TASK_INTERRUPTIBLE);
> >
> >       while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> > -             if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> > +             /* Testing SCHED_THREADED bit here to make sure the curre=
nt
> > +              * kthread owns this napi and could poll on this napi.
> > +              * Testing SCHED bit is not enough because SCHED bit migh=
t be
> > +              * set by some other busy poll thread or by napi_disable(=
).
> > +              */
> > +             if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || =
woken) {
> >                       WARN_ON(!list_empty(&napi->poll_list));
> >                       __set_current_state(TASK_RUNNING);
> >                       return 0;
> >               }
> >
> >               schedule();
> > +             /* woken being true indicates this thread owns this napi.=
 */
> > +             woken =3D true;
> >               set_current_state(TASK_INTERRUPTIBLE);
> >       }
> >       __set_current_state(TASK_RUNNING);
> > --
> > 2.31.0.rc2.261.g7f71774620-goog
> >
>
