Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85BC2C4E9F
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 07:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387947AbgKZGOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 01:14:33 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:44423 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732176AbgKZGOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 01:14:32 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kiAXz-0006mg-Bn; Thu, 26 Nov 2020 07:14:27 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kiAXy-0006qs-BY; Thu, 26 Nov 2020 07:14:26 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 5CBA7240041;
        Thu, 26 Nov 2020 07:14:25 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id CD144240040;
        Thu, 26 Nov 2020 07:14:24 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 88FC4200F6;
        Thu, 26 Nov 2020 07:14:24 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 07:14:24 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/5] net/lapb: support netdev events
Organization: TDT AG
In-Reply-To: <20201126000814.12108-1-xie.he.0141@gmail.com>
References: <20201124093938.22012-3-ms@dev.tdt.de>
 <20201126000814.12108-1-xie.he.0141@gmail.com>
Message-ID: <5c74d51e4cd3ee0aae47c84988dbbf91@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1606371267-00000FB8-A5135790/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-26 01:08, Xie He wrote:
> Hi Martin,
> 
> Since we are going to assume lapb->state would remain in LAPB_STATE_0 
> when
> the carrier is down (as understood by me. Right?), could we add a check 
> in
> lapb_connect_request to reject the upper layer's "connect" instruction 
> when
> the carrier is down? Like this:

No, because this will break the considered "on demand" calling feature.

> 
> diff --git a/include/linux/lapb.h b/include/linux/lapb.h
> index eb56472f23b2..7923b1c6fc6a 100644
> --- a/include/linux/lapb.h
> +++ b/include/linux/lapb.h
> @@ -14,6 +14,7 @@
>  #define	LAPB_REFUSED		5
>  #define	LAPB_TIMEDOUT		6
>  #define	LAPB_NOMEM		7
> +#define	LAPB_NOCARRIER		8
> 
>  #define	LAPB_STANDARD		0x00
>  #define	LAPB_EXTENDED		0x01
> diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
> index 3c03f6512c5f..c909d8db1bef 100644
> --- a/net/lapb/lapb_iface.c
> +++ b/net/lapb/lapb_iface.c
> @@ -270,6 +270,10 @@ int lapb_connect_request(struct net_device *dev)
>  	if (!lapb)
>  		goto out;
> 
> +	rc = LAPB_NOCARRIER;
> +	if (!netif_carrier_ok(dev))
> +		goto out_put;
> +
>  	rc = LAPB_OK;
>  	if (lapb->state == LAPB_STATE_1)
>  		goto out_put;
> 
> Also, since we are going to assume the lapb->state would remain in
> LAPB_STATE_0 when the carrier is down, are the
> "lapb->state == LAPB_STATE_0" checks in carrier-up/device-up event
> handling necessary? If they are not necessary, it might be better to
> remove them because it may confuse people reading the code.

They are still necessary, because if the link setup is initiated by
upper layers, we've already entered the respective state by
lapb_connect_request().


Every suggestion for improvement is really welcome, but please let this
patch set pass now, if you don't find any more gross errors.

Martin
