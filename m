Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD41858E9
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgCOCYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgCOCYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 22:24:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6797020785;
        Sat, 14 Mar 2020 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584208759;
        bh=HKJHEd0b4HXcP2CUqYh2rJjJcwSlu6+U4wh/p3NkG6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PNn6Btzqr/Jg8hQ1G3JCPwCgXizF0XyfHudD2V9hHnQHtIFuy65wVfm+6eyXQiCN1
         yxT1Qkzh+l/Gg+fgzXPxqvmAQjylM+xveVMZZz/MUBKcTn6p4CCCIeTIvonUS9wEIE
         68FyJYNcakkhsvqQ+hWvDlCTqURiXnGs7DONFFg8=
Date:   Sat, 14 Mar 2020 19:59:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 net-next 3/7] octeontx2-vf: Virtual function driver
 support
Message-ID: <20200314175913.GG67638@unreal>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-4-git-send-email-sunil.kovvuri@gmail.com>
 <20200313181139.GC67638@unreal>
 <CA+sq2CeP3rfhBmxcs9Z6n7wVBmqP6upb8XFZF7nZ3R=QUtTF_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CeP3rfhBmxcs9Z6n7wVBmqP6upb8XFZF7nZ3R=QUtTF_g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 09:10:28PM +0530, Sunil Kovvuri wrote:
> On Fri, Mar 13, 2020 at 11:41 PM Leon Romanovsky <leon@kernel.org> wrote:
>  > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > > new file mode 100644
> > > index 0000000..cf366dc
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > > @@ -0,0 +1,659 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/* Marvell OcteonTx2 RVU Virtual Function ethernet driver
> > > + *
> > > + * Copyright (C) 2020 Marvell International Ltd.
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> >
> > Please don't add license text, the SPDX line is enough.
> >
>
> Can you please point me to where this is written.

It is in nutshell of SPDX tags. They already include proper LICENSE text.
https://elixir.bootlin.com/linux/latest/source/Documentation/process/howto.rst#L59
https://elixir.bootlin.com/linux/latest/source/Documentation/process/license-rules.rst

> It would be great if these are made rules and written somewhere so
> that everyone can go through and follow.
> I see that there are so many patches being submitted with copyright text.
> So this is very confusing.

This is a mistake, new files should carry SPDX tags only.

>
> > > +
> > > +static int otx2vf_process_mbox_msg_up(struct otx2_nic *vf,
> > > +                                   struct mbox_msghdr *req)
> > > +{
> > > +     /* Check if valid, if not reply with a invalid msg */
> > > +     if (req->sig != OTX2_MBOX_REQ_SIG) {
> > > +             otx2_reply_invalid_msg(&vf->mbox.mbox_up, 0, 0, req->id);
> > > +             return -ENODEV;
> > > +     }
> > > +
> > > +     switch (req->id) {
> > > +#define M(_name, _id, _fn_name, _req_type, _rsp_type)                        \
> > > +     case _id: {                                                     \
> > > +             struct _rsp_type *rsp;                                  \
> > > +             int err;                                                \
> > > +                                                                     \
> > > +             rsp = (struct _rsp_type *)otx2_mbox_alloc_msg(          \
> > > +                     &vf->mbox.mbox_up, 0,                           \
> > > +                     sizeof(struct _rsp_type));                      \
> > > +             if (!rsp)                                               \
> > > +                     return -ENOMEM;                                 \
> > > +                                                                     \
> > > +             rsp->hdr.id = _id;                                      \
> > > +             rsp->hdr.sig = OTX2_MBOX_RSP_SIG;                       \
> > > +             rsp->hdr.pcifunc = 0;                                   \
> > > +             rsp->hdr.rc = 0;                                        \
> > > +                                                                     \
> > > +             err = otx2_mbox_up_handler_ ## _fn_name(                \
> > > +                     vf, (struct _req_type *)req, rsp);              \
> > > +             return err;                                             \
> > > +     }
> > > +MBOX_UP_CGX_MESSAGES
> > > +#undef M
> >
> > "return ..." inside macro which is called by another macro is highly
> > discouraged by the Linux kernel coding style.
> >
>
> There are many mailbox messages to handle and adding each one of them
> to switch case would be a
> lot of duplicate code. Hence we choose to with these macros.

Somehow other drivers succeeded to do it without such macros, I'm
confident that you will success too. Please try your best to rewrite it.

Section 12.1 talks exactly about this case and why it is **bad** idea.
https://elixir.bootlin.com/linux/latest/source/Documentation/process/coding-style.rst#L752

Thanks

>
> Thanks,
> Sunil.
