Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C11C2FADA
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfE3LY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 07:24:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36507 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3LY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 07:24:58 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hWJAr-0006YK-LB; Thu, 30 May 2019 07:24:52 -0400
Date:   Thu, 30 May 2019 07:24:18 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190530112418.GB1966@hmswarspite.think-freely.org>
References: <00000000000097abb90589e804fd@google.com>
 <20190528013600.GM5506@localhost.localdomain>
 <20190528111550.GA4658@hmswarspite.think-freely.org>
 <20190529190709.GE31099@hmswarspite.think-freely.org>
 <20190529233757.GC3713@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529233757.GC3713@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 08:37:57PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, May 29, 2019 at 03:07:09PM -0400, Neil Horman wrote:
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
> > @@ -2419,9 +2419,12 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
> >  	/* Copy cookie in case we need to resend COOKIE-ECHO. */
> >  	cookie = asoc->peer.cookie;
> >  	if (cookie) {
> > +		if (asoc->peer.cookie_allocated)
> > +			kfree(cookie);
> >  		asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
> >  		if (!asoc->peer.cookie)
> >  			goto clean_up;
> > +		asoc->peer.cookie_allocated=1;
> >  	}
> >  
> >  	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily
> 
> What if we kmemdup directly at sctp_process_param(), as it's done for
> others already? Like SCTP_PARAM_RANDOM and SCTP_PARAM_HMAC_ALGO. I
> don't see a reason for SCTP_PARAM_STATE_COOKIE to be different
> here. This way it would be always allocated, and ready to be kfreed.
> 
> We still need to free it after the handshake, btw.
> 
Yeah, that makes sense, I'll give that a shot.
Neil

>   Marcelo
> 
