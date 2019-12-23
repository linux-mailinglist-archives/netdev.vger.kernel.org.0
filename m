Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6DF129B84
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 23:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLWWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 17:55:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45775 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfLWWzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 17:55:14 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1ijWbQ-0006Dg-2s; Mon, 23 Dec 2019 17:55:10 -0500
Date:   Mon, 23 Dec 2019 17:55:03 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: fix err handling of stream initialization
Message-ID: <20191223225503.GB30462@hmswarspite.think-freely.org>
References: <d41d8475f8485f571152b3f3716d7f474b5c0e79.1576864893.git.marcelo.leitner@gmail.com>
 <20191223124609.GA30462@hmswarspite.think-freely.org>
 <20191223125108.GK4444@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223125108.GK4444@localhost.localdomain>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 09:51:08AM -0300, Marcelo Ricardo Leitner wrote:
> On Mon, Dec 23, 2019 at 07:46:09AM -0500, Neil Horman wrote:
> > On Fri, Dec 20, 2019 at 03:03:44PM -0300, Marcelo Ricardo Leitner wrote:
> > > The fix on 951c6db954a1 fixed the issued reported there but introduced
> > > another. When the allocation fails within sctp_stream_init() it is
> > > okay/necessary to free the genradix. But it is also called when adding
> > > new streams, from sctp_send_add_streams() and
> > > sctp_process_strreset_addstrm_in() and in those situations it cannot
> > > just free the genradix because by then it is a fully operational
> > > association.
> > > 
> > > The fix here then is to only free the genradix in sctp_stream_init()
> > > and on those other call sites  move on with what it already had and let
> > > the subsequent error handling to handle it.
> > > 
> > > Tested with the reproducers from this report and the previous one,
> > > with lksctp-tools and sctp-tests.
> > > 
> > > Reported-by: syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com
> > > Fixes: 951c6db954a1 ("sctp: fix memleak on err handling of stream initialization")
> > > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > ---
> > >  net/sctp/stream.c | 30 +++++++++++++++---------------
> > >  1 file changed, 15 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > > index 6a30392068a04bfcefcb14c3d7f13fc092d59cd3..c1a100d2fed39c2d831487e05fcbf5e8d507d470 100644
> > > --- a/net/sctp/stream.c
> > > +++ b/net/sctp/stream.c
> > > @@ -84,10 +84,8 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> > >  		return 0;
> > >  
> > >  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
> > > -	if (ret) {
> > > -		genradix_free(&stream->out);
> > > +	if (ret)
> > >  		return ret;
> > > -	}
> > >  
> > >  	stream->outcnt = outcnt;
> > >  	return 0;
> > > @@ -102,10 +100,8 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
> > >  		return 0;
> > >  
> > >  	ret = genradix_prealloc(&stream->in, incnt, gfp);
> > > -	if (ret) {
> > > -		genradix_free(&stream->in);
> > > +	if (ret)
> > >  		return ret;
> > > -	}
> > >  
> > >  	stream->incnt = incnt;
> > >  	return 0;
> > > @@ -123,7 +119,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
> > >  	 * a new one with new outcnt to save memory if needed.
> > >  	 */
> > >  	if (outcnt == stream->outcnt)
> > > -		goto in;
> > > +		goto handle_in;
> > >  
> > >  	/* Filter out chunks queued on streams that won't exist anymore */
> > >  	sched->unsched_all(stream);
> > > @@ -132,24 +128,28 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
> > >  
> > >  	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
> > >  	if (ret)
> > > -		goto out;
> > > +		goto out_err;
> > >  
> > >  	for (i = 0; i < stream->outcnt; i++)
> > >  		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
> > >  
> > > -in:
> > > +handle_in:
> > >  	sctp_stream_interleave_init(stream);
> > >  	if (!incnt)
> > >  		goto out;
> > >  
> > >  	ret = sctp_stream_alloc_in(stream, incnt, gfp);
> > > -	if (ret) {
> > > -		sched->free(stream);
> > > -		genradix_free(&stream->out);
> > > -		stream->outcnt = 0;
> > > -		goto out;
> > > -	}
> > > +	if (ret)
> > > +		goto in_err;
> > > +
> > > +	goto out;
> > >  
> > > +in_err:
> > > +	sched->free(stream);
> > > +	genradix_free(&stream->in);
> > > +out_err:
> > > +	genradix_free(&stream->out);
> > Isn't this effectively a double free in the fall through case?
> 
> Hm, if you got you right, the line 3 lines above is freeing '->in' and
> the right above one, '->out', so no.
> No other calls to genradix_free() are left in this function, too.
> 
you're right, I missed the different streams in the free function
Neil

>   Marcelo
> 
> > Neil
> > 
> > > +	stream->outcnt = 0;
> > >  out:
> > >  	return ret;
> > >  }
> > > -- 
> > > 2.23.0
> > > 
> > > 
> 
