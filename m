Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C767D5E7267
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 05:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiIWDXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 23:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIWDX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 23:23:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B2BDDD91
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 20:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663903406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1IRk6b4TEIr0H8pxTzKQQyD2CfOO6YgFYFYApNwO/k=;
        b=N8obzfJAgW8X8oNtL0imH34+3i4VR/mW377e/0n9j9LVhhRwZd09YBJEdKX3xrzHCAhIkB
        Vfp5mwOdB2a+kdMurkc4MUKvG59kGMhkMMeO+i4wssiFZuqvUk5LbLRqBTYAklm94flk4B
        1kIJgRCJ227u+/NVofZPH5BpLVTpNfw=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-464-vYzfH704Oj-NJK3sB-asWg-1; Thu, 22 Sep 2022 23:23:25 -0400
X-MC-Unique: vYzfH704Oj-NJK3sB-asWg-1
Received: by mail-ot1-f72.google.com with SMTP id z37-20020a9d24a8000000b006540be16ff4so5431019ota.22
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 20:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Q1IRk6b4TEIr0H8pxTzKQQyD2CfOO6YgFYFYApNwO/k=;
        b=Y3dUuFiCosJlwtEFD1uVcb6j4sy4SmtvixI3HgR630AR52w4p7iGFcbvOFMJszcB0G
         u60VcwMY0Cl7fJW7JnvuHY7Dkro2u1nsLV++qZuk3jU/r+YVtBYUx6WDXPNSppdprBvK
         SZmf7XaOvo98iC8bsULxPlx9DYTYjZP7gzAbrcCXhIt+VneCtLnfLdCy/3xzdW4NBFkq
         wEvfebXcbp4Y+JqFnznsm0mPqOiY95IRB43dxstIrJiaXWyLsaXwzd/LgLvJyOIR/82M
         1G6xd0tTvBBoJOLPFQHaYfqsWHXu7/UOU0t9ucdoeep0Fd3e5wcbzGqnQYA3j513VwC4
         ndvQ==
X-Gm-Message-State: ACrzQf2KyQ4cADC9mivdhP9/22y+WoNmwbCwNEibfFSbB7FV/eEjlgdn
        U1RZs65PS+fgeT392mz0HZ19/zyKzgLpfDd8yytYG/j5dwOVjhRxfsX++B4fIYHxGY2pi84ZjgS
        Go+YUW+ym3TSHpeanGXMGfDgmQazBj2wd
X-Received: by 2002:a05:6870:73cd:b0:12a:dff3:790a with SMTP id a13-20020a05687073cd00b0012adff3790amr9951035oan.35.1663903404403;
        Thu, 22 Sep 2022 20:23:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6hJM+8RTSpJHUWSIzMR/yBUGz1OdJdJ4wN954waxUc/38CRVxDOxobxVAU9SLcgChubSNB19yipsCNCtTxVI8=
X-Received: by 2002:a05:6870:73cd:b0:12a:dff3:790a with SMTP id
 a13-20020a05687073cd00b0012adff3790amr9951025oan.35.1663903404222; Thu, 22
 Sep 2022 20:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220915123539.35956-1-liujian56@huawei.com> <CACGkMEsXYAHTb40jbtr35=O2NgJHHNkC_E2b8bqxygrmLOtRbQ@mail.gmail.com>
 <f84ae6bae3904c04bca70b915be54db9@huawei.com>
In-Reply-To: <f84ae6bae3904c04bca70b915be54db9@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 23 Sep 2022 11:23:13 +0800
Message-ID: <CACGkMEtZRgs5Ou9qNGJ2aQt9yUxywL4Ob0WkpHPXHq=Sxqi3mw@mail.gmail.com>
Subject: Re: [PATCH net v2] tun: Check tun device queue status in tun_chr_write_iter
To:     "liujian (CE)" <liujian56@huawei.com>
Cc:     "me@jibi.io" <me@jibi.io>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 9:45 PM liujian (CE) <liujian56@huawei.com> wrote:
>
>
>
> > -----Original Message-----
> > From: liujian (CE)
> > Sent: Friday, September 16, 2022 3:05 PM
> > To: 'Jason Wang' <jasowang@redhat.com>
> > Cc: davem <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel
> > Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
> > <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>; netdev
> > <netdev@vger.kernel.org>
> > Subject: RE: [PATCH net v2] tun: Check tun device queue status in
> > tun_chr_write_iter
> >
> >
> >
> > > -----Original Message-----
> > > From: Jason Wang [mailto:jasowang@redhat.com]
> > > Sent: Friday, September 16, 2022 9:57 AM
> > > To: liujian (CE) <liujian56@huawei.com>
> > > Cc: davem <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>;
> > > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > > Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> > > <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>;
> > John
> > > Fastabend <john.fastabend@gmail.com>; netdev
> > <netdev@vger.kernel.org>
> > > Subject: Re: [PATCH net v2] tun: Check tun device queue status in
> > > tun_chr_write_iter
> > >
> > > On Thu, Sep 15, 2022 at 8:34 PM Liu Jian <liujian56@huawei.com> wrote=
:
> > > >
> > > > syzbot found below warning:
> > > >
> > > > ------------[ cut here ]------------
> > > > geneve0 received packet on queue 3, but number of RX queues is 3
> > > > WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611 netif_get_rxqueue
> > > > net/core/dev.c:4611 [inline]
> > > > WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611
> > > > netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683 Modules
> > > linked in:
> > > > CPU: 1 PID: 29734 Comm: syz-executor.0 Not tainted 5.10.0 #5
> > > > Hardware
> > > > name: linux,dummy-virt (DT)
> > > > pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=3D--) pc :
> > > > netif_get_rxqueue net/core/dev.c:4611 [inline] pc :
> > > > netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683 lr :
> > > > netif_get_rxqueue net/core/dev.c:4611 [inline] lr :
> > > > netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683 sp :
> > > > ffffa00016127770
> > > > x29: ffffa00016127770 x28: ffff3f4607d6acb4
> > > > x27: ffff3f4607d6acb0 x26: ffff3f4607d6ad20
> > > > x25: ffff3f461de3c000 x24: ffff3f4607d6ad28
> > > > x23: ffffa00010059000 x22: ffff3f4608719100
> > > > x21: 0000000000000003 x20: ffffa000161278a0
> > > > x19: ffff3f4607d6ac40 x18: 0000000000000000
> > > > x17: 0000000000000000 x16: 00000000f2f2f204
> > > > x15: 00000000f2f20000 x14: 6465766965636572
> > > > x13: 20306576656e6567 x12: ffff98b8ed3b924d
> > > > x11: 1ffff8b8ed3b924c x10: ffff98b8ed3b924c
> > > > x9 : ffffc5c76525c9c4 x8 : 0000000000000000
> > > > x7 : 0000000000000001 x6 : ffff98b8ed3b924c
> > > > x5 : ffff3f460f3b29c0 x4 : dfffa00000000000
> > > > x3 : ffffc5c765000000 x2 : 0000000000000000
> > > > x1 : 0000000000000000 x0 : ffff3f460f3b29c0 Call trace:
> > > >  netif_get_rxqueue net/core/dev.c:4611 [inline]
> > > >  netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
> > > > do_xdp_generic net/core/dev.c:4777 [inline]
> > > >  do_xdp_generic+0x9c/0x190 net/core/dev.c:4770
> > > >  tun_get_user+0xd94/0x2010 drivers/net/tun.c:1938
> > > >  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
> > > > call_write_iter
> > > > include/linux/fs.h:1960 [inline]
> > > >  new_sync_write+0x260/0x370 fs/read_write.c:515
> > > > vfs_write+0x51c/0x61c
> > > > fs/read_write.c:602
> > > >  ksys_write+0xfc/0x200 fs/read_write.c:655  __do_sys_write
> > > > fs/read_write.c:667 [inline]  __se_sys_write fs/read_write.c:664
> > > > [inline]
> > > >  __arm64_sys_write+0x50/0x60 fs/read_write.c:664  __invoke_syscall
> > > > arch/arm64/kernel/syscall.c:36 [inline]  invoke_syscall
> > > > arch/arm64/kernel/syscall.c:48 [inline]
> > > >  el0_svc_common.constprop.0+0xf4/0x414
> > > > arch/arm64/kernel/syscall.c:155 do_el0_svc+0x50/0x11c
> > > > arch/arm64/kernel/syscall.c:217
> > > >  el0_svc+0x20/0x30 arch/arm64/kernel/entry-common.c:353
> > > >  el0_sync_handler+0xe4/0x1e0 arch/arm64/kernel/entry-common.c:369
> > > >  el0_sync+0x148/0x180 arch/arm64/kernel/entry.S:683
> > > >
> > > > This is because the detached queue is used to send data. Therefore,
> > > > we need to check the queue status in the tun_chr_write_iter functio=
n.
> > > >
> > > > Fixes: cde8b15f1aab ("tuntap: add ioctl to attach or detach a file
> > > > form tuntap device")
> > >
> Hello,
> Sorry, fixes tag is wrong. The warning should be introduced by commit 3fe=
260e00cd0 (" net: tun: record RX queue in skb before do_xdp_generic() "). B=
efore this, do_xdp_generic always uses queue0. Therefore, when the warning =
is generated due to detached, queue0 is used and is printed only once, whic=
h is harmless. So it's not a problem.
> What do you think about  this warning?

I tend to keep this warning (it might be too late to fix).

Thanks

>
> > > Not sure this deserves a stable.
> > >
> > > > Signed-off-by: Liu Jian <liujian56@huawei.com>
> > > > ---
> > > > v1->v2: add fixes tag
> > > >  drivers/net/tun.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c index
> > > > 259b2b84b2b3..261411c1a6bb 100644
> > > > --- a/drivers/net/tun.c
> > > > +++ b/drivers/net/tun.c
> > > > @@ -2019,6 +2019,11 @@ static ssize_t tun_chr_write_iter(struct
> > > > kiocb
> > > *iocb, struct iov_iter *from)
> > > >         if (!tun)
> > > >                 return -EBADFD;
> > > >
> > > > +       if (tfile->detached) {
> > >
> > > tfile->detached is synchronized through rtnl_lock which is probably
> > > not suitable for the datapath. We probably need to rcuify this.
> > >
> > > > +               tun_put(tun);
> > > > +               return -ENETDOWN;
> > >
> > > Another question is that can some user space depend on this behaviour=
?
> > > I wonder if it's more safe to pretend the packet was received here?
> > >
> > Thanks for your review. I don't know whether there was any depend on th=
is
> > behavior.
> > If that's the case, I think it's better to keep this warning.
> > What is your opinion on this warning?
> >
> > > Thanks
> > >
> > > > +       }
> > > > +
> > > >         if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_=
NOWAIT))
> > > >                 noblock =3D 1;
> > > >
> > > > --
> > > > 2.17.1
> > > >
>

