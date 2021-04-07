Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FAD3573E9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355106AbhDGSHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355081AbhDGSHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D6461153;
        Wed,  7 Apr 2021 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617818843;
        bh=KQDUew2GlvDTG5qXa9bLXVU8UwDr5O44GktbMLs9Ihs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7DNkz6X0fIgBa1gqe0G8XVjij7Ew4m0fQzUlfvYRIdYSPFsqtmgkAdB1eO5s32Lg
         mMh8TRJpULgu+n7pTh7ATjEkyBOkbaBEaBpi+B2IBUqGCbMXRSJMe80IGGp0xmLgV+
         3YdLsn6QfAzTLp3RqTu7dL66G7RZsgsDc0XeXvtOzQC0aYxNQl6orY6GuwgJwN9KhE
         LOBb8x+cHWXkeV7j6OE9/6B+OHtiDjNtVOTazNr07otq8ielDfAhnJ0DpWO9aZHgY5
         YF4d6NyjDSY6MXxQIO6YsQ1/VDqD5xWfIKD1vcMlRe5aox5LmA8Wfk8ii82B20+H4K
         BALh+4SCJW/3w==
Date:   Wed, 7 Apr 2021 11:07:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
Message-ID: <20210407110722.1eb4ebf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0UfLLQycLsAZQ98ofBGYPwejA6zHbG6QsNrU92mizS7e0g@mail.gmail.com>
References: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
        <20210406114734.0e00cb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210407060053.wyo75mqwcva6w6ci@spock.localdomain>
        <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0UfLLQycLsAZQ98ofBGYPwejA6zHbG6QsNrU92mizS7e0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 09:25:28 -0700 Alexander Duyck wrote:
> On Wed, Apr 7, 2021 at 8:37 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 7 Apr 2021 08:00:53 +0200 Oleksandr Natalenko wrote:  
> > > Thanks for the effort, but reportedly [1] it made no difference,
> > > unfortunately.
> > >
> > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=212573#c8  
> >
> > The only other option I see is that somehow the NAPI has no rings.
> >
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > index a45cd2b416c8..24568adc2fb1 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -7980,7 +7980,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
> >         struct igb_q_vector *q_vector = container_of(napi,
> >                                                      struct igb_q_vector,
> >                                                      napi);
> > -       bool clean_complete = true;
> > +       bool clean_complete = q_vector->tx.ring || q_vector->rx.ring;
> >         int work_done = 0;
> >
> >  #ifdef CONFIG_IGB_DCA  
> 
> It might make sense to just cast the work_done as a unsigned int, and
> then on the end of igb_poll use:
>   return min_t(unsigned int, work_done, budget - 1);

Sure, that's simplest. I wasn't sure something is supposed to prevent
this condition or if it's okay to cover it up.
