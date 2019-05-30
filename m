Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDDD2FD8D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfE3OUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:20:46 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37906 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfE3OUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 10:20:45 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hWLv4-0007yH-Bt; Thu, 30 May 2019 10:20:40 -0400
Date:   Thu, 30 May 2019 10:20:11 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     syzbot <syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_process_init
Message-ID: <20190530142011.GC1966@hmswarspite.think-freely.org>
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
>   Marcelo
> 

Still untested, but something like this?


diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d2c7d0d2abc1..718b9917844e 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -393,6 +393,7 @@ void sctp_association_free(struct sctp_association *asoc)
 	kfree(asoc->peer.peer_random);
 	kfree(asoc->peer.peer_chunks);
 	kfree(asoc->peer.peer_hmacs);
+	kfree(asoc->peer.cookie);
 
 	/* Release the transport structures. */
 	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 72e74503f9fc..ff365f22a3c1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2431,14 +2431,6 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 	/* Peer Rwnd   : Current calculated value of the peer's rwnd.  */
 	asoc->peer.rwnd = asoc->peer.i.a_rwnd;
 
-	/* Copy cookie in case we need to resend COOKIE-ECHO. */
-	cookie = asoc->peer.cookie;
-	if (cookie) {
-		asoc->peer.cookie = kmemdup(cookie, asoc->peer.cookie_len, gfp);
-		if (!asoc->peer.cookie)
-			goto clean_up;
-	}
-
 	/* RFC 2960 7.2.1 The initial value of ssthresh MAY be arbitrarily
 	 * high (for example, implementations MAY use the size of the receiver
 	 * advertised window).
@@ -2607,7 +2599,9 @@ static int sctp_process_param(struct sctp_association *asoc,
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len =
 			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
-		asoc->peer.cookie = param.cookie->body;
+		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
+		if (!asoc->peer.cookie)
+			retval = 0;
 		break;
 
 	case SCTP_PARAM_HEARTBEAT_INFO:
