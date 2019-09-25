Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6D9BE8E1
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfIYXVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 19:21:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45666 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbfIYXVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 19:21:17 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDGau-0005we-VZ; Wed, 25 Sep 2019 23:21:13 +0000
Date:   Thu, 26 Sep 2019 00:21:12 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: fix memory leak in qrtr_tun_read_iter
Message-ID: <20190925232112.GR26530@ZenIV.linux.org.uk>
References: <20190925230416.20126-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925230416.20126-1-navid.emamdoost@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 06:04:13PM -0500, Navid Emamdoost wrote:
> In qrtr_tun_read_iter we need an error handling path to appropriately
> release skb in cases of error.

Release _what_ skb?

> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  net/qrtr/tun.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> index e35869e81766..0f6e6d1d2901 100644
> --- a/net/qrtr/tun.c
> +++ b/net/qrtr/tun.c
> @@ -54,19 +54,24 @@ static ssize_t qrtr_tun_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	int count;
>  
>  	while (!(skb = skb_dequeue(&tun->queue))) {

The body of the loop is entered only if the loop condition has
evaluated true.  In this case, it means that the value of
	!(skb = skb_dequeue(&tun->queue))
had been true, i.e. the value of
	skb = skb_dequeue(&tun->queue)
has been NULL, i.e. that skb_dequeue() has returned NULL, which had
been copied into skb.

In other words, in the body of that loop we have skb equal to NULL.

> -		if (filp->f_flags & O_NONBLOCK)
> -			return -EAGAIN;
> +		if (filp->f_flags & O_NONBLOCK) {
> +			count = -EAGAIN;
> +			goto out;
> +		}
>  
>  		/* Wait until we get data or the endpoint goes away */
>  		if (wait_event_interruptible(tun->readq,
> -					     !skb_queue_empty(&tun->queue)))
> -			return -ERESTARTSYS;
> +					     !skb_queue_empty(&tun->queue))) {
> +			count = -ERESTARTSYS;
> +			goto out;
> +		}
>  	}

The meaning of that loop is fairly clear, isn't it?  Keep looking int
tun->queue until an skb shows up there.  If it's not immediately there,
fail with -EAGAIN for non-blocking files and wait on tun->readq until
some skb arrives.
