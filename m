Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAB06C13AC
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjCTNlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCTNlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:41:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F9DC16D;
        Mon, 20 Mar 2023 06:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1267B80E95;
        Mon, 20 Mar 2023 13:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA6DC433EF;
        Mon, 20 Mar 2023 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679319663;
        bh=m4Ctj4kIFOL0/XkcpQrCPJp8I1gfPrht8FQ7ZHbdmEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hm2LGu0FCwJJUNOp614eorFKh/KuFSCDhHYOLcD+709GFWFbl3CxYcNzVzHzyvLCu
         hh45PpkT1rgw0+SFWev5nWm5IUhDMpkxFpXVS6n11mhC8FMpjX9wgE04U6NDXOMy4p
         smjXnBHgSGlRtVnWVMQ8xDjxNzP3pwrFFTCR3iz33q+tpE1VSz0xsef9a3hrEOfr+j
         igE9ldBWgT6+DkMdexO0tyzIpNsq21qY2MNKSpK9rT+ocmp6/Ltz/KpqWPFFYcmk8o
         z9jLO03YODXnlTx2mQ6kcFOzDQJf4W6VJM28bL2g+KU3HfweyKkiU3i/Gxj7eV6KDG
         NUHrHoPv3ZT4Q==
Date:   Mon, 20 Mar 2023 15:40:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Nuno =?iso-8859-1?Q?Gon=E7alves?= <nunog@fr24.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] xsk: allow remap of fill and/or completion rings
Message-ID: <20230320134058.GM36557@unreal>
References: <20230320105323.187307-1-nunog@fr24.com>
 <20230320110314.GJ36557@unreal>
 <CAJ8uoz1kbFsttvWNTUdtYcwEa=hQvky2z0Jfn0=9b5v6m_FVXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ8uoz1kbFsttvWNTUdtYcwEa=hQvky2z0Jfn0=9b5v6m_FVXg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 01:27:18PM +0100, Magnus Karlsson wrote:
> On Mon, 20 Mar 2023 at 12:09, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Mar 20, 2023 at 10:53:23AM +0000, Nuno Gonçalves wrote:
> > > The remap of fill and completion rings was frowned upon as they
> > > control the usage of UMEM which does not support concurrent use.
> > > At the same time this would disallow the remap of this rings
> > > into another process.
> > >
> > > A possible use case is that the user wants to transfer the socket/
> > > UMEM ownerwhip to another process (via SYS_pidfd_getfd) and so
> 
> nit: ownership
> 
> > > would need to also remap this rings.
> > >
> > > This will have no impact on current usages and just relaxes the
> > > remap limitation.
> > >
> > > Signed-off-by: Nuno Gonçalves <nunog@fr24.com>
> > > ---
> > >  net/xdp/xsk.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index 2ac58b282b5eb..2af4ff64b22bd 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -1300,10 +1300,11 @@ static int xsk_mmap(struct file *file, struct socket *sock,
> > >  {
> > >       loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> > >       unsigned long size = vma->vm_end - vma->vm_start;
> > > +     int state = READ_ONCE(xs->state);
> 
> Reverse Christmas Tree notation here please. Move it one line down to
> after the *xs declaration.
> 
> > >       struct xdp_sock *xs = xdp_sk(sock->sk);
> > >       struct xsk_queue *q = NULL;
> > >
> > > -     if (READ_ONCE(xs->state) != XSK_READY)
> > > +     if (!(state == XSK_READY || state == XSK_BOUND))
> >
> > This if(..) is actually:
> >  if (state != XSK_READY && state != XSK_BOUND)
> 
> Nuno had it like that to start with when he sent the patch privately
> to me, but I responded that I prefered the current one. It is easier
> to understand if read out aloud IMO. 

"Not equal" is much easier to understand than "not" of whole expression.

> Do not have any strong feelings either way since the statements are equivalent.
> 
> > Thanks
