Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42F43E06
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbfFMPq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:46:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48466 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731771AbfFMJd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lH95QDBu3WX8kdNvVLm8TNXGj4gft8us1GpfjIszCYo=; b=SVS9YERrgSCIMXtUf8Jwx8ivf
        9OumC65a7EXEOXw4g2YElyLy8o5qvIzHQCBxTZ5FrcUvx+Zvt4aGfQCPAlgBg0LlUrITOytrN3C9y
        UkBkMaCiJ3K4qVp9MIEspB17yKrKTkAsstsWacvKcUq4PA3tdnL5vfWitdN0EdtG4kxnp3Tfd9Jtz
        +KhWVA9Pkau7MQNr0vyCFqk4yA3J8pkcSuMe3taNerIYuw8nlXthCootn3EV3A9GTftMkQVN53gIE
        TwK9TTrsA0FKbsPtfBw5QPKmIHaSMmulBeb0fB8gw+JCm+O/QxX0SDWpFxJVCIbGzqseo6QiBcI5i
        15fgUMBpA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbM78-00015h-DW; Thu, 13 Jun 2019 09:33:46 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 372B5209C844F; Thu, 13 Jun 2019 11:33:45 +0200 (CEST)
Date:   Thu, 13 Jun 2019 11:33:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] locking/static_key: always define
 static_branch_deferred_inc
Message-ID: <20190613093345.GQ3402@hirez.programming.kicks-ass.net>
References: <20190612194409.197461-1-willemdebruijn.kernel@gmail.com>
 <20190612125911.509d79f2@cakuba.netronome.com>
 <CAF=yD-JAZfEG5JoNEQn60gnucJB1gsrFeT38DieG12NQb9DFnQ@mail.gmail.com>
 <20190612135627.5eac995d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612135627.5eac995d@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 01:56:27PM -0700, Jakub Kicinski wrote:
> On Wed, 12 Jun 2019 16:25:16 -0400, Willem de Bruijn wrote:
> > On Wed, Jun 12, 2019 at 3:59 PM Jakub Kicinski
> > <jakub.kicinski@netronome.com> wrote:
> > >
> > > On Wed, 12 Jun 2019 15:44:09 -0400, Willem de Bruijn wrote:  
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > This interface is currently only defined if CONFIG_JUMP_LABEL. Make it
> > > > available also when jump labels are disabled.
> > > >
> > > > Fixes: ad282a8117d50 ("locking/static_key: Add support for deferred static branches")
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > >
> > > > ---
> > > >
> > > > The original patch went into 5.2-rc1, but this interface is not yet
> > > > used, so this could target either 5.2 or 5.3.  
> > >
> > > Can we drop the Fixes tag?  It's an ugly omission but not a bug fix.
> > >
> > > Are you planning to switch clean_acked_data_enable() to the helper once
> > > merged?  
> > 
> > Definitely, can do.
> > 
> > Perhaps it's easiest to send both as a single patch set through net-next, then?
> 
> I'd think so too, perhaps we can get a blessing from Peter for that :)

Sure that works, I don't think there's anything else pending for this
file to conflict with.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
