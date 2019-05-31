Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB23312A2
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfEaQoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:44:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49748 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfEaQn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:43:59 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hWkd8-0003pv-Az; Fri, 31 May 2019 12:43:52 -0400
Date:   Fri, 31 May 2019 12:43:19 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190531164319.GB3828@hmswarspite.think-freely.org>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
 <20190529190709.GE31099@hmswarspite.think-freely.org>
 <20190529233757.GC3713@localhost.localdomain>
 <20190530142011.GC1966@hmswarspite.think-freely.org>
 <20190530151705.GD3713@localhost.localdomain>
 <20190530195634.GD1966@hmswarspite.think-freely.org>
 <20190531124242.GE3713@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531124242.GE3713@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 09:42:42AM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, May 30, 2019 at 03:56:34PM -0400, Neil Horman wrote:
> > On Thu, May 30, 2019 at 12:17:05PM -0300, Marcelo Ricardo Leitner wrote:
> ...
> > > --- a/net/sctp/sm_sideeffect.c
> > > +++ b/net/sctp/sm_sideeffect.c
> > > @@ -898,6 +898,11 @@ static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
> > >  						asoc->rto_initial;
> > >  	}
> > >  
> > > +	if (sctp_state(asoc, ESTABLISHED)) {
> > > +		kfree(asoc->peer.cookie);
> > > +		asoc->peer.cookie = NULL;
> > > +	}
> > > +
> > Not sure I follow why this is needed.  It doesn't hurt anything of course, but
> > if we're freeing in sctp_association_free, we don't need to duplicate the
> > operation here, do we?
> 
> This one would be to avoid storing the cookie throughout the entire
> association lifetime, as the cookie is only needed during the
> handshake.
> While the free in sctp_association_free will handle the freeing in
> case the association never enters established state.
> 

Ok, I see we do that with the peer_random and other allocated values as well
when they are no longer needed, but ew, I hate freeing in multiple places like
that.  I'll fix this up on monday, but I wonder if we can't consolidate that
somehow

Neil

> > >  	if (sctp_state(asoc, ESTABLISHED) ||
> > >  	    sctp_state(asoc, CLOSED) ||
> > >  	    sctp_state(asoc, SHUTDOWN_RECEIVED)) {
> > > 
> > > Also untested, just sharing the idea.
> > > 
> > >   Marcelo
> > > 
> 
