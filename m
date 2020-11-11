Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932FB2AEFD4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKKLl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:41:27 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:48917 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgKKLlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:41:23 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kcoV2-000Arb-Tv; Wed, 11 Nov 2020 12:41:16 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kcoV1-0005Zg-SM; Wed, 11 Nov 2020 12:41:15 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1BEEB24004B;
        Wed, 11 Nov 2020 12:41:15 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id A25BD240049;
        Wed, 11 Nov 2020 12:41:14 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id EC805200AE;
        Wed, 11 Nov 2020 12:41:13 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 Nov 2020 12:41:13 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: x25: Fix kernel crashes due to x25_disconnect
 releasing x25_neigh
Organization: TDT AG
In-Reply-To: <20201111100424.3989-1-xie.he.0141@gmail.com>
References: <20201111100424.3989-1-xie.he.0141@gmail.com>
Message-ID: <89483cb5fbf9e06edf3108fa4def6eef@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1605094876-0000CF01-6FFAE7B9/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-11 11:04, Xie He wrote:
> The x25_disconnect function in x25_subr.c would decrease the refcount 
> of
> "x25->neighbour" (struct x25_neigh) and reset this pointer to NULL.
> 
> However:
> 
> 1) When we receive a connection, the x25_rx_call_request function in
> af_x25.c does not increase the refcount when it assigns the pointer.
> When we disconnect, x25_disconnect is called and the struct's refcount
> is decreased without being increased in the first place.

Yes, this is a problem and should be fixed. As an alternative to your
approach, you could also go the way to prevent the call of
x25_neigh_put(nb) in x25_lapb_receive_frame() in case of a Call Request.
However, this would require more effort.

> 
> This causes frequent kernel crashes when using AF_X25 sockets.
> 
> 2) When we initiate a connection but the connection is refused by the
> remote side, x25_disconnect is called which decreases the refcount and
> resets the pointer to NULL. But the x25_connect function in af_x25.c,
> which is waiting for the connection to be established, notices the
> failure and then tries to decrease the refcount again, resulting in a
> NULL-pointer-dereference error.
> 
> This crashes the kernel every time a connection is refused by the 
> remote
> side.

For this bug I already sent a fix some time ago (last time I sent a
RESEND yesterday), but unfortunately it was not merged yet:
https://lore.kernel.org/patchwork/patch/1334917/

> 
> Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 
> disconnect")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  net/x25/af_x25.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index 0bbb283f23c9..8e59f9ecbeab 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
> @@ -826,10 +826,12 @@ static int x25_connect(struct socket *sock,
> struct sockaddr *uaddr,
>  	rc = 0;
>  out_put_neigh:
>  	if (rc) {
> -		read_lock_bh(&x25_list_lock);
> -		x25_neigh_put(x25->neighbour);
> -		x25->neighbour = NULL;
> -		read_unlock_bh(&x25_list_lock);
> +		if (x25->neighbour) {
> +			read_lock_bh(&x25_list_lock);
> +			x25_neigh_put(x25->neighbour);
> +			x25->neighbour = NULL;
> +			read_unlock_bh(&x25_list_lock);
> +		}
>  		x25->state = X25_STATE_0;
>  	}
>  out_put_route:
> @@ -1050,6 +1052,7 @@ int x25_rx_call_request(struct sk_buff *skb,
> struct x25_neigh *nb,
>  	makex25->lci           = lci;
>  	makex25->dest_addr     = dest_addr;
>  	makex25->source_addr   = source_addr;
> +	x25_neigh_hold(nb);
>  	makex25->neighbour     = nb;
>  	makex25->facilities    = facilities;
>  	makex25->dte_facilities= dte_facilities;
