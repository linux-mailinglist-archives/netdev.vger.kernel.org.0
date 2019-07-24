Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9116972D5A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfGXLXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:23:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49804 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfGXLXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:23:11 -0400
Received: from cpe-2606-a000-111b-6140-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:6140::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hqFMN-0006Fm-3Y; Wed, 24 Jul 2019 07:23:09 -0400
Date:   Wed, 24 Jul 2019 07:22:35 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size
 in __sctp_setsockopt_connectx
Message-ID: <20190724112235.GA7212@hmswarspite.think-freely.org>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <20190723152449.GB8419@localhost.localdomain>
 <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_eiS26aMZcPrj2oNvZh_42phWiY71M7=UNvjEeB-B9bDQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 03:21:12PM +0800, Xin Long wrote:
> On Tue, Jul 23, 2019 at 11:25 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> > > Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> > > sctp_inet_connect(), the latter has done addr_size check with size
> > > of sa_family_t.
> > >
> > > In the next patch to clean up __sctp_connect(), we will remove
> > > addr_size check with size of sa_family_t from __sctp_connect()
> > > for the 1st address.
> > >
> > > So before doing that, __sctp_setsockopt_connectx() should do
> > > this check first, as sctp_inet_connect() does.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/sctp/socket.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > index aa80cda..5f92e4a 100644
> > > --- a/net/sctp/socket.c
> > > +++ b/net/sctp/socket.c
> > > @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
> > >       pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
> > >                __func__, sk, addrs, addrs_size);
> > >
> > > -     if (unlikely(addrs_size <= 0))
> > > +     if (unlikely(addrs_size < sizeof(sa_family_t)))
> > I don't think this is what you want to check for here.  sa_family_t is
> > an unsigned short, and addrs_size is the number of bytes in the addrs
> > array.  The addrs array should be at least the size of one struct
> > sockaddr (16 bytes iirc), and, if larger, should be a multiple of
> > sizeof(struct sockaddr)
> sizeof(struct sockaddr) is not the right value to check either.
> 
> The proper check will be done later in __sctp_connect():
> 
>         af = sctp_get_af_specific(daddr->sa.sa_family);
>         if (!af || af->sockaddr_len > addrs_size)
>                 return -EINVAL;
> 
> So the check 'addrs_size < sizeof(sa_family_t)' in this patch is
> just to make sure daddr->sa.sa_family is accessible. the same
> check is also done in sctp_inet_connect().
> 
That doesn't make much sense, if the proper check is done in __sctp_connect with
the size of the families sockaddr_len, then we don't need this check at all, we
can just let memdup_user take the fault on copy_to_user and return -EFAULT.  If
we get that from memdup_user, we know its not accessible, and can bail out.

About the only thing we need to check for here is that addr_len isn't some
absurdly high value (i.e. a negative value), so that we avoid trying to kmalloc
upwards of 2G in memdup_user.  Your change does that just fine, but its no
better or worse than checking for <=0

Neil

> >
> > Neil
> >
> > >               return -EINVAL;
> > >
> > >       kaddrs = memdup_user(addrs, addrs_size);
> > > --
> > > 2.1.0
> > >
> > >
> 
