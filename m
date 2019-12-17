Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D602F122AAB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfLQLyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:54:12 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50113 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLQLyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:54:11 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1ihBQN-0008M7-17; Tue, 17 Dec 2019 06:54:05 -0500
Date:   Tue, 17 Dec 2019 06:53:58 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     syzbot <syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: memory leak in sctp_stream_init
Message-ID: <20191217115358.GA730@hmswarspite.think-freely.org>
References: <000000000000f531080599c4073c@google.com>
 <20191216114828.GA20281@hmswarspite.think-freely.org>
 <20191216145638.GB5058@localhost.localdomain>
 <20191217003716.GC5058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217003716.GC5058@localhost.localdomain>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 09:37:16PM -0300, Marcelo Ricardo Leitner wrote:
> On Mon, Dec 16, 2019 at 11:56:38AM -0300, Marcelo Ricardo Leitner wrote:
> ...
> > Considering that genradix_prealloc() failure is not fatal, seems the
> > fix here is to just ignore the failure in sctp_stream_alloc_out() and
> > let genradix try again later on.
> 
> Better yet, this fixes it here:
> 
> ---8<---
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index df60b5ef24cb..e0b01bf912b3 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
>  		return 0;
>  
>  	ret = genradix_prealloc(&stream->out, outcnt, gfp);
> -	if (ret)
> +	if (ret) {
> +		genradix_free(&stream->out);
>  		return ret;
> +	}
>  
>  	stream->outcnt = outcnt;
>  	return 0;
> @@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
>  		return 0;
>  
>  	ret = genradix_prealloc(&stream->in, incnt, gfp);
> -	if (ret)
> +	if (ret) {
> +		genradix_free(&stream->in);
>  		return ret;
> +	}
>  
>  	stream->incnt = incnt;
>  	return 0;
> 
I get how that fixes this, but that doesn't really seem like the right fix in my
mind.  Shouldn't genradix_prealloc internally free any memory its allocated if
it fails part way through its operation?

Neil
