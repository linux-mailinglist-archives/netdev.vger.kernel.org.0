Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788EA30EC6B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 07:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhBDGWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 01:22:21 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:16352 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhBDGWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 01:22:20 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1l7Y0A-000RV0-7O; Thu, 04 Feb 2021 07:20:26 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1l7Y09-000UEa-BK; Thu, 04 Feb 2021 07:20:25 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 9D5DD240041;
        Thu,  4 Feb 2021 07:20:24 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 1C8A0240040;
        Thu,  4 Feb 2021 07:20:24 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 75B34207B3;
        Thu,  4 Feb 2021 07:20:23 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Feb 2021 07:20:23 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] net: hdlc_x25: Return meaningful error code in
 x25_open
Organization: TDT AG
In-Reply-To: <20210203071541.86138-1-xie.he.0141@gmail.com>
References: <20210203071541.86138-1-xie.he.0141@gmail.com>
Message-ID: <352fd651d4fd98e46f7c58fc05eea4e7@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1612419625-0001A85E-BA6645A4/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-03 08:15, Xie He wrote:
> It's not meaningful to pass on LAPB error codes to HDLC code or other
> parts of the system, because they will not understand the error codes.
> 
> Instead, use system-wide recognizable error codes.
> 
> Fixes: f362e5fe0f1f ("wan/hdlc_x25: make lapb params configurable")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/hdlc_x25.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
> index bb164805804e..4aaa6388b9ee 100644
> --- a/drivers/net/wan/hdlc_x25.c
> +++ b/drivers/net/wan/hdlc_x25.c
> @@ -169,11 +169,11 @@ static int x25_open(struct net_device *dev)
> 
>  	result = lapb_register(dev, &cb);
>  	if (result != LAPB_OK)
> -		return result;
> +		return -ENOMEM;
> 
>  	result = lapb_getparms(dev, &params);
>  	if (result != LAPB_OK)
> -		return result;
> +		return -EINVAL;
> 
>  	if (state(hdlc)->settings.dce)
>  		params.mode = params.mode | LAPB_DCE;
> @@ -188,7 +188,7 @@ static int x25_open(struct net_device *dev)
> 
>  	result = lapb_setparms(dev, &params);
>  	if (result != LAPB_OK)
> -		return result;
> +		return -EINVAL;
> 
>  	return 0;
>  }

Thanks for fixing this.

Acked-by: Martin Schiller <ms@dev.tdt.de>
