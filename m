Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075274C3180
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiBXQdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiBXQds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:33:48 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC322150416;
        Thu, 24 Feb 2022 08:33:15 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z2so2183481plg.8;
        Thu, 24 Feb 2022 08:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=St3DkxwrtpDynxdKgulzwMdbf/rIv6teB1kfRG4Yz44=;
        b=oGZn/YxcnOlfTimMstWcs4/msrkCux3tRuNscLqfK6y+LyO+zLsjUbZ4em0nkehv/7
         EHD2LMHsnKopw76Dr8EnuyceZozBQaLzwjX0iPl3Sjl54vx3n+uGdbHgyyo7Nx+m65K4
         x/u6WWOvuPlBTU02avd+5vS+/N39+EJV/oISXGcAFCDy1yNPuleBf+yx5pjCN8svYwt5
         lu9BXca78W91DWW9WKFbEWClCa3uQlAYlzAfTfhx91N79/a3ffVDwGVrjzf2osAIBPVb
         ozasDJIEua9jqAmzYFBMa+SHBF7PVRVMeC0mPwT9IDm9aUsu7W2jyF3mzHlHJAtDAUnS
         jyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=St3DkxwrtpDynxdKgulzwMdbf/rIv6teB1kfRG4Yz44=;
        b=jsyoB5fhIOmHqssmP3eAgMvMPxCoFxO//V2FP6u8mumjWNQxqP7qGAXRmmI6sRHSPF
         G4F11ktP87/g+uo8d3RrArohoTzLzNLd33XnefsjEjpwvrfMbEnRLgy78OwFGbjSeJxs
         oIKIdLRQZGjlbA+5znNeHepbeyIWFfvZRedHd9Sa4F5idf9vzMMa/PabD33Rlau6z98u
         D/noO2TdCAbfrYDH5F3cIa3kX7Mrz458LuE6rQ1JAuNRenNVPZhsuQReU5wK6D+qOlbz
         y0bziLhaIyyfrLZwSWCK8K87y9y2Vm8ojbj2iUQ5yxfAI/TeqKo9NpIswXQl83wP6Ur6
         b+fg==
X-Gm-Message-State: AOAM533XxLm9OGhbcVa3zkcG9kq/xyCM6Ox9MMnWl97osSzXK2Fin3ii
        vQsioyBCYDHp6euUCsfaOthlbV0MiOa/nFqel5U=
X-Google-Smtp-Source: ABdhPJwI3aZH12V49BN2JsmpMd4cgi7c9wKR8xp8CjJw2at3kGkAQ06NkTDgZv1XOy5bEbgo0PJr7YVrpPolFvX/prA=
X-Received: by 2002:a17:902:ecc1:b0:14f:1c91:7e65 with SMTP id
 a1-20020a170902ecc100b0014f1c917e65mr3434069plh.142.1645720395224; Thu, 24
 Feb 2022 08:33:15 -0800 (PST)
MIME-Version: 1.0
References: <20220222094347.6010-1-magnus.karlsson@gmail.com> <Yhex9EuXMVS+wZhq@boxer>
In-Reply-To: <Yhex9EuXMVS+wZhq@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 24 Feb 2022 17:33:03 +0100
Message-ID: <CAJ8uoz1avYrq=EreCi_N4HLC2ugO3XxNvdP53cE0dJKHnwfzrg@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix race at socket teardown
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Elza Mathew <elza.mathew@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 5:27 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Feb 22, 2022 at 10:43:47AM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a race in the xsk socket teardown code that can lead to a null
> > pointer dereference splat. The current xsk unbind code in
> > xsk_unbind_dev() starts by setting xs->state to XSK_UNBOUND, sets
> > xs->dev to NULL and then waits for any NAPI processing to terminate
> > using synchronize_net(). After that, the release code starts to tear
> > down the socket state and free allocated memory.
> >
> > BUG: kernel NULL pointer dereference, address: 00000000000000c0
> > PGD 8000000932469067 P4D 8000000932469067 PUD 0
> > Oops: 0000 [#1] PREEMPT SMP PTI
> > CPU: 25 PID: 69132 Comm: grpcpp_sync_ser Tainted: G          I       5.16.0+ #2
> > Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.2.10 03/09/2015
> > RIP: 0010:__xsk_sendmsg+0x2c/0x690
> > Code: 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 38 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 48 8b 87 08 03 00 00 <f6> 80 c0 00 00 00 01 >
> > RSP: 0018:ffffa2348bd13d50 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: 0000000000000040 RCX: ffff8d5fc632d258
> > RDX: 0000000000400000 RSI: ffffa2348bd13e10 RDI: ffff8d5fc5489800
> > RBP: ffffa2348bd13db0 R08: 0000000000000000 R09: 00007ffffffff000
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff8d5fc5489800
> > R13: ffff8d5fcb0f5140 R14: ffff8d5fcb0f5140 R15: 0000000000000000
> > FS:  00007f991cff9400(0000) GS:ffff8d6f1f700000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000000000c0 CR3: 0000000114888005 CR4: 00000000001706e0
> > Call Trace:
> > <TASK>
> > ? aa_sk_perm+0x43/0x1b0
> > xsk_sendmsg+0xf0/0x110
> > sock_sendmsg+0x65/0x70
> > __sys_sendto+0x113/0x190
> > ? debug_smp_processor_id+0x17/0x20
> > ? fpregs_assert_state_consistent+0x23/0x50
> > ? exit_to_user_mode_prepare+0xa5/0x1d0
> > __x64_sys_sendto+0x29/0x30
> > do_syscall_64+0x3b/0xc0
> > entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > There are two problems with the current code. First, setting xs->dev
> > to NULL before waiting for all users to stop using the socket is not
> > correct. The entry to the data plane functions xsk_poll(),
> > xsk_sendmsg(), and xsk_recvmsg() are all guarded by a test that
> > xs->state is in the state XSK_BOUND and if not, it returns right
> > away. But one process might have passed this test but still have not
> > gotten to the point in which it uses xs->dev in the code. In this
> > interim, a second process executing xsk_unbind_dev() might have set
> > xs->dev to NULL which will lead to a crash for the first process. The
> > solution here is just to get rid of this NULL assignment since it is
> > not used anymore. Before commit 42fddcc7c64b ("xsk: use state member
> > for socket synchronization"), xs->dev was the gatekeeper to admit
> > processes into the data plane functions, but it was replaced with the
> > state variable xs->state in the aforementioned commit.
> >
> > The second problem is that synchronize_net() does not wait for any
> > process in xsk_poll(), xsk_sendmsg(), or xsk_recvmsg() to complete,
> > which means that the state they rely on might be cleaned up
> > prematurely. This can happen when the notifier gets called (at driver
> > unload for example) as it uses xsk_unbind_dev(). Solve this by
> > extending the RCU critical region from just the ndo_xsk_wakeup to the
> > whole functions mentioned above, so that both the test of xs->state ==
> > XSK_BOUND and the last use of any member of xs is covered by the RCU
> > critical section. This will guarantee that when synchronize_net()
> > completes, there will be no processes left executing xsk_poll(),
> > xsk_sendmsg(), or xsk_recvmsg() and state can be cleaned up
> > safely. Note that we need to drop the RCU lock for the SKB xmit path
> > as it uses functions that might sleep. Due to this, we have to retest
> > the xs->state after we grab the mutex that protects the SKB xmit code
> > from, among a number of things, an xsk_unbind_dev() being executed
> > from the notifier at the same time.
> >
> > Fixes: 42fddcc7c64b ("xsk: use state member for socket synchronization")
> > Reported-by: Elza Mathew <elza.mathew@intel.com>
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  net/xdp/xsk.c | 75 ++++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 53 insertions(+), 22 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 28ef3f4465ae..e506635b1981 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -400,21 +400,11 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
> >  }
> >  EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
> >
> > -static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
> > +static int xsk_zc_xmit(struct xdp_sock *xs, u8 flags)
> >  {
> >       struct net_device *dev = xs->dev;
> > -     int err;
> > -
> > -     rcu_read_lock();
> > -     err = dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
> > -     rcu_read_unlock();
> > -
> > -     return err;
> > -}
> >
> > -static int xsk_zc_xmit(struct xdp_sock *xs)
> > -{
> > -     return xsk_wakeup(xs, XDP_WAKEUP_TX);
> > +     return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
> >  }
> >
> >  static void xsk_destruct_skb(struct sk_buff *skb)
> > @@ -533,6 +523,12 @@ static int xsk_generic_xmit(struct sock *sk)
> >
> >       mutex_lock(&xs->mutex);
> >
> > +     /* Since we dropped the RCU read lock, the socket state might have changed. */
> > +     if (unlikely(!xsk_is_bound(xs))) {
> > +             err = -ENXIO;
> > +             goto out;
> > +     }
> > +
> >       if (xs->queue_id >= xs->dev->real_num_tx_queues)
> >               goto out;
> >
> > @@ -596,16 +592,26 @@ static int xsk_generic_xmit(struct sock *sk)
> >       return err;
> >  }
> >
> > -static int __xsk_sendmsg(struct sock *sk)
> > +static int xsk_xmit(struct sock *sk)
> >  {
> >       struct xdp_sock *xs = xdp_sk(sk);
> > +     int ret;
> >
> >       if (unlikely(!(xs->dev->flags & IFF_UP)))
> >               return -ENETDOWN;
> >       if (unlikely(!xs->tx))
> >               return -ENOBUFS;
> >
> > -     return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
> > +     if (xs->zc)
> > +             return xsk_zc_xmit(xs, XDP_WAKEUP_TX);
> > +
> > +     /* Drop the RCU lock since the SKB path might sleep. */
> > +     rcu_read_unlock();
> > +     ret = xsk_generic_xmit(sk);
> > +     /* Reaquire RCU lock before going into common code. */
> > +     rcu_read_lock();
> > +
> > +     return ret;
> >  }
> >
> >  static bool xsk_no_wakeup(struct sock *sk)
> > @@ -619,7 +625,7 @@ static bool xsk_no_wakeup(struct sock *sk)
> >  #endif
> >  }
> >
> > -static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> > +static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> >  {
> >       bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
> >       struct sock *sk = sock->sk;
> > @@ -639,11 +645,22 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> >
> >       pool = xs->pool;
> >       if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
> > -             return __xsk_sendmsg(sk);
> > +             return xsk_xmit(sk);
> >       return 0;
> >  }
> >
> > -static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
> > +static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> > +{
> > +     int ret;
> > +
> > +     rcu_read_lock();
> > +     ret = __xsk_sendmsg(sock, m, total_len);
> > +     rcu_read_unlock();
> > +
> > +     return ret;
> > +}
> > +
> > +static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
> >  {
> >       bool need_wait = !(flags & MSG_DONTWAIT);
> >       struct sock *sk = sock->sk;
> > @@ -665,10 +682,21 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
> >               return 0;
> >
> >       if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
> > -             return xsk_wakeup(xs, XDP_WAKEUP_RX);
> > +             return xsk_zc_xmit(xs, XDP_WAKEUP_RX);
>
> Feels a bit contradictory to have xmit func with rx flag, no?
> Could we keep it as xsk_wakeup instead?

Agree with that, but on the other hand I thought it was good that the
functions are called xsk_zc_xmit and xsk_generic_xmit. It tells me
that they are doing the same thing but one is for the zero-copy path
and the other one for the generic/skb path. But yes, I can change it
or try to find a better name. Xmit and RX in the same name/function is
kind of confusing.

> >       return 0;
> >  }
> >
> > +static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
> > +{
> > +     int ret;
> > +
> > +     rcu_read_lock();
> > +     ret = __xsk_recvmsg(sock, m, len, flags);
> > +     rcu_read_unlock();
> > +
> > +     return ret;
> > +}
> > +
> >  static __poll_t xsk_poll(struct file *file, struct socket *sock,
> >                            struct poll_table_struct *wait)
> >  {
> > @@ -679,17 +707,20 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
> >
> >       sock_poll_wait(file, sock, wait);
> >
> > -     if (unlikely(!xsk_is_bound(xs)))
> > +     rcu_read_lock();
> > +     if (unlikely(!xsk_is_bound(xs))) {
> > +             rcu_read_unlock();
> >               return mask;
> > +     }
> >
> >       pool = xs->pool;
> >
> >       if (pool->cached_need_wakeup) {
> >               if (xs->zc)
> > -                     xsk_wakeup(xs, pool->cached_need_wakeup);
> > +                     xsk_zc_xmit(xs, pool->cached_need_wakeup);
> >               else
> >                       /* Poll needs to drive Tx also in copy mode */
> > -                     __xsk_sendmsg(sk);
> > +                     xsk_xmit(sk);
> >       }
> >
> >       if (xs->rx && !xskq_prod_is_empty(xs->rx))
> > @@ -697,6 +728,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
> >       if (xs->tx && xsk_tx_writeable(xs))
> >               mask |= EPOLLOUT | EPOLLWRNORM;
> >
> > +     rcu_read_unlock();
> >       return mask;
> >  }
> >
> > @@ -728,7 +760,6 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
> >
> >       /* Wait for driver to stop using the xdp socket. */
> >       xp_del_xsk(xs->pool, xs);
> > -     xs->dev = NULL;
> >       synchronize_net();
> >       dev_put(dev);
> >  }
> >
> > base-commit: 8940e6b669ca1196ce0a0549c819078096390f76
> > --
> > 2.34.1
> >
