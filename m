Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4A31F8429
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgFMP7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 11:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgFMP6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 11:58:22 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 464A0C08C5C1;
        Sat, 13 Jun 2020 08:58:22 -0700 (PDT)
Received: from 2606-a000-111b-4634-0000-0000-0000-1bf2.inf6.spectrum.com ([2606:a000:111b:4634::1bf2] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1jk8XY-0002Cu-MZ; Sat, 13 Jun 2020 11:57:55 -0400
Date:   Sat, 13 Jun 2020 11:57:51 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] sctp: Fix sk_buff leak when receiving a datagram
Message-ID: <20200613155751.GA161691@hmswarspite.think-freely.org>
References: <1592051965-94731-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592051965-94731-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 13, 2020 at 08:39:25PM +0800, Xiyu Yang wrote:
> In sctp_skb_recv_datagram(), the function fetch a sk_buff object from
> the receiving queue to "skb" by calling skb_peek() or __skb_dequeue()
> and return its reference to the caller.
> 
> However, when calling __skb_dequeue() successfully, the function forgets
> to hold a reference count of the "skb" object and directly return it,
> causing a potential memory leak in the caller function.
> 
> Fix this issue by calling refcount_inc after __skb_dequeue()
> successfully executed.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  net/sctp/socket.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index d57e1a002ffc..4c8f0b83efd0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -8990,6 +8990,8 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
>  				refcount_inc(&skb->users);
>  		} else {
>  			skb = __skb_dequeue(&sk->sk_receive_queue);
> +			if (skb)
> +				refcount_inc(&skb->users);
For completeness, you should probably use skb_get here, rather than refcount_inc
directly.

Also, I'm not entirely sure I see how a memory leak can happen here.  we take an
extra reference in the skb_peek clause of this code area because if we return an
skb that continues to exist on the sk_receive_queue list, we legitimately have
two users for the skb (the user who called sctp_skb_recv_datagram(...,MSG_PEEK),
and the potential next caller who will actually dequeue the skb.

In the else clause however, that condition doesn't exist.  the user count for
the skb should alreday be 1, if the caller is the only user of the skb), or more
than 1, if 1 or more callers have gotten a reference to the message using
MSG_PEEK.

I don't think this code is needed, and in fact will actually cause memory leaks,
because theres no subsequent skb_unref call to drop refcount that you are adding
here.

Neil

>  		}
>  
>  		if (skb)
> -- 
> 2.7.4
> 
> 
