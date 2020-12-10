Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF772D541C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 07:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgLJGnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 01:43:22 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:37165 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729230AbgLJGnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 01:43:22 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1knFdr-0000oM-2R; Thu, 10 Dec 2020 07:41:31 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1knFdq-0000nx-0q; Thu, 10 Dec 2020 07:41:30 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 483F8240041;
        Thu, 10 Dec 2020 07:41:29 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id C642C240040;
        Thu, 10 Dec 2020 07:41:28 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 5611D202DE;
        Thu, 10 Dec 2020 07:41:28 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Dec 2020 07:41:28 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: lapbether: Consider it successful if
 (dis)connecting when already (dis)connected
Organization: TDT AG
In-Reply-To: <20201208225044.5522-1-xie.he.0141@gmail.com>
References: <20201208225044.5522-1-xie.he.0141@gmail.com>
Message-ID: <15c1ad7b52562e2ca37d8084a90197d8@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1607582490-000013A4-C9E28885/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-08 23:50, Xie He wrote:
> When the upper layer instruct us to connect (or disconnect), but we 
> have
> already connected (or disconnected), consider this operation successful
> rather than failed.
> 
> This can help the upper layer to correct its record about whether we 
> are
> connected or not here in layer 2.
> 
> The upper layer may not have the correct information about whether we 
> are
> connected or not. This can happen if this driver has already been 
> running
> for some time when the "x25" module gets loaded.
> 
> Another X.25 driver (hdlc_x25) is already doing this, so we make this
> driver do this, too.

Looks good to me.

Acked-by: Martin Schiller <ms@dev.tdt.de>

> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/lapbether.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
> index b6be2454b8bd..605fe555e157 100644
> --- a/drivers/net/wan/lapbether.c
> +++ b/drivers/net/wan/lapbether.c
> @@ -55,6 +55,9 @@ struct lapbethdev {
> 
>  static LIST_HEAD(lapbeth_devices);
> 
> +static void lapbeth_connected(struct net_device *dev, int reason);
> +static void lapbeth_disconnected(struct net_device *dev, int reason);
> +
>  /* 
> ------------------------------------------------------------------------ 
> */
> 
>  /*
> @@ -167,11 +170,17 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff 
> *skb,
>  	case X25_IFACE_DATA:
>  		break;
>  	case X25_IFACE_CONNECT:
> -		if ((err = lapb_connect_request(dev)) != LAPB_OK)
> +		err = lapb_connect_request(dev);
> +		if (err == LAPB_CONNECTED)
> +			lapbeth_connected(dev, LAPB_OK);
> +		else if (err != LAPB_OK)
>  			pr_err("lapb_connect_request error: %d\n", err);
>  		goto drop;
>  	case X25_IFACE_DISCONNECT:
> -		if ((err = lapb_disconnect_request(dev)) != LAPB_OK)
> +		err = lapb_disconnect_request(dev);
> +		if (err == LAPB_NOTCONNECTED)
> +			lapbeth_disconnected(dev, LAPB_OK);
> +		else if (err != LAPB_OK)
>  			pr_err("lapb_disconnect_request err: %d\n", err);
>  		fallthrough;
>  	default:
