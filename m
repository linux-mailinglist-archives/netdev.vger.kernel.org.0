Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8723185B44
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 09:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgCOImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 04:42:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgCOImT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 04:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ouKmZUl+e2q5E4IgzjgssmMnbl6mov070Bx+7m6iGhM=; b=zvlRjYDuwmVXjJ65BXu2tZNuUN
        k+aUUPjeHXP+e0E5J9tGgPbfsbwqbJ5166NWztCRzIm1VMeL1gEle4np6j7nzzPduTeyLhaRO3pbu
        y5L12bk/iCuDWJTk/5SEpGyF3oTVfUl76IhfiPQeOoeNXJy/0yP7cg9GME++8pALkNXs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDOqd-00076K-M0; Sun, 15 Mar 2020 09:42:15 +0100
Date:   Sun, 15 Mar 2020 09:42:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Sunil Kovvuri <sunil.kovvuri@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 net-next 3/7] octeontx2-vf: Virtual function driver
 support
Message-ID: <20200315084215.GI8622@lunn.ch>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-4-git-send-email-sunil.kovvuri@gmail.com>
 <20200313181139.GC67638@unreal>
 <CA+sq2CeP3rfhBmxcs9Z6n7wVBmqP6upb8XFZF7nZ3R=QUtTF_g@mail.gmail.com>
 <20200314191258.GB3046@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314191258.GB3046@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +static int otx2vf_process_mbox_msg_up(struct otx2_nic *vf,
> > > > +                                   struct mbox_msghdr *req)
> > > > +{
> > > > +     /* Check if valid, if not reply with a invalid msg */
> > > > +     if (req->sig != OTX2_MBOX_REQ_SIG) {
> > > > +             otx2_reply_invalid_msg(&vf->mbox.mbox_up, 0, 0, req->id);
> > > > +             return -ENODEV;
> > > > +     }
> > > > +
> > > > +     switch (req->id) {
> > > > +#define M(_name, _id, _fn_name, _req_type, _rsp_type)                        \
> > > > +     case _id: {                                                     \
> > > > +             struct _rsp_type *rsp;                                  \
> > > > +             int err;                                                \
> > > > +                                                                     \
> > > > +             rsp = (struct _rsp_type *)otx2_mbox_alloc_msg(          \
> > > > +                     &vf->mbox.mbox_up, 0,                           \
> > > > +                     sizeof(struct _rsp_type));                      \
> > > > +             if (!rsp)                                               \
> > > > +                     return -ENOMEM;                                 \
> > > > +                                                                     \
> > > > +             rsp->hdr.id = _id;                                      \
> > > > +             rsp->hdr.sig = OTX2_MBOX_RSP_SIG;                       \
> > > > +             rsp->hdr.pcifunc = 0;                                   \
> > > > +             rsp->hdr.rc = 0;                                        \
> > > > +                                                                     \
> > > > +             err = otx2_mbox_up_handler_ ## _fn_name(                \
> > > > +                     vf, (struct _req_type *)req, rsp);              \
> > > > +             return err;                                             \
> > > > +     }
> > > > +MBOX_UP_CGX_MESSAGES
> > > > +#undef M
> > >
> > > "return ..." inside macro which is called by another macro is highly
> > > discouraged by the Linux kernel coding style.
> > >
> >
> > There are many mailbox messages to handle and adding each one of them
> > to switch case would be a
> > lot of duplicate code. Hence we choose to with these macros.
> 
> The coding style section 12.1 talks exactly about that pattern.
> https://elixir.bootlin.com/linux/latest/source/Documentation/process/coding-style.rst#L752
> Somehow all other drivers succeeded to write their code without such
> macros, I'm confident that you will success too. Please try your best.

Hi Sunil

It is easy to create locking bugs with returns in macros. I've
inherited code which did this, not realized where was a return hidden
in a macro, and as a result got locks wrong, resulting in a deadlock.

     Andrew
