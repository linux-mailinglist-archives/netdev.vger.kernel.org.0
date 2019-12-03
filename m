Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF551105E6
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 21:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfLCUXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 15:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfLCUXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 15:23:40 -0500
Received: from localhost (unknown [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2B7206DF;
        Tue,  3 Dec 2019 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575404619;
        bh=vDly8YxF//Ih8pOGDzMUZMzO1IEy4IRZGxS7lQhxWgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FmB8v1mwLOfhIaRIGvggEffzlPcugaQlSS6BdY0c0t9trnOhquORxZug0MqLtYIqh
         wcMs7VsyirUUob5q8s7Wk2lWw3cpCIhjrOcYJDbez38/vfPw0TWqB6m7Ylt47EUtNz
         Q2ttFqL43y5bs8FrySVqBGYDG7Bt0rv0RUGYm7YI=
Date:   Tue, 3 Dec 2019 21:23:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
Message-ID: <20191203202328.GA3183510@kroah.com>
References: <20191203160552.31071-1-edumazet@google.com>
 <20191203191314.GA2734645@kroah.com>
 <CANn89i+LK6wHWStHTn3swgx8KDGQ2VMULk59JaRWi599=yx2pw@mail.gmail.com>
 <20191203192234.GA2735936@kroah.com>
 <CANn89iLWjbVMw_UhR0wGC9iA3DoWYz7XtuTTgMmvq8x3zA2H4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLWjbVMw_UhR0wGC9iA3DoWYz7XtuTTgMmvq8x3zA2H4w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 11:30:29AM -0800, Eric Dumazet wrote:
> On Tue, Dec 3, 2019 at 11:22 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Dec 03, 2019 at 11:15:31AM -0800, Eric Dumazet wrote:
> > > On Tue, Dec 3, 2019 at 11:13 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Dec 03, 2019 at 08:05:52AM -0800, Eric Dumazet wrote:
> > > > > It appears linux-4.14 stable needs a backport of commit
> > > > > 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
> > > > >
> > > > > Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
> > > > > let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
> > > >
> > > > So does that mean that 4.19.y should get 88f8598d0a30 ("tcp: exit if
> > > > nothing to retransmit on RTO timeout") as-is?
> > > >
> > >
> > > Yes indeed. All stable versions need it.
> >
> > So 4.4.y and 4.9.y as well?
> 
> They should be fine, since they do not have yet :
> 
> ba2ddb43f270e6492ccce4fc42fc32c611de8f68 tcp: Don't dequeue
> SYN/FIN-segments from write-queue
> f1dcc5ed4bea3f2d63b74ad86617ec12b1e5e9d4 tcp: Reset send_head when
> removing skb from write-queue
> 8e6521f6404e704fac313ab2479923be1f741f73 tcp: remove empty skb from
> write queue in error cases
> 
> I would leave them untouched, to limit further problems :/

Great, thanks for letting me know.

greg k-h
