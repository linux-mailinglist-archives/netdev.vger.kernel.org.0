Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B204C2EBA8D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 08:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbhAFHh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 02:37:26 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:45659 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAFHh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 02:37:26 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kx3Ly-0003xQ-Vq; Wed, 06 Jan 2021 08:35:35 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kx3Ly-0001dX-0y; Wed, 06 Jan 2021 08:35:34 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 5DCB3240041;
        Wed,  6 Jan 2021 08:35:33 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id DCBB2240040;
        Wed,  6 Jan 2021 08:35:32 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 68AAC20046;
        Wed,  6 Jan 2021 08:35:32 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 Jan 2021 08:35:32 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lapb: Decrease the refcount of "struct lapb_cb"
 in lapb_device_event
Organization: TDT AG
In-Reply-To: <20201231174331.64539-1-xie.he.0141@gmail.com>
References: <20201231174331.64539-1-xie.he.0141@gmail.com>
Message-ID: <4bba668b619e32e87e713b5b9d0876a7@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1609918534-0000A9C4-9CA950EE/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-31 18:43, Xie He wrote:
> In lapb_device_event, lapb_devtostruct is called to get a reference to
> an object of "struct lapb_cb". lapb_devtostruct increases the refcount
> of the object and returns a pointer to it. However, we didn't decrease
> the refcount after we finished using the pointer. This patch fixes this
> problem.
> 
> Fixes: a4989fa91110 ("net/lapb: support netdev events")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  net/lapb/lapb_iface.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
> index 213ea7abc9ab..40961889e9c0 100644
> --- a/net/lapb/lapb_iface.c
> +++ b/net/lapb/lapb_iface.c
> @@ -489,6 +489,7 @@ static int lapb_device_event(struct notifier_block
> *this, unsigned long event,
>  		break;
>  	}
> 
> +	lapb_put(lapb);
>  	return NOTIFY_DONE;
>  }

Well, I guess I missed that one. Thank you!

Acked-by: Martin Schiller <ms@dev.tdt.de>
