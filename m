Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6343A1090
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhFIJxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:53:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37622 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbhFIJxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:53:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lqure-0004oT-5A; Wed, 09 Jun 2021 09:51:10 +0000
Subject: Re: [PATCH 2/2][next] net: usb: asix: ax88772: net: Fix less than
 zero comparison of a u16
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210608152249.160333-1-colin.king@canonical.com>
 <20210608152249.160333-2-colin.king@canonical.com>
 <20210608181129.7mnuba6dcaemslul@pengutronix.de>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <a289d8fa-3cfd-6b85-20ec-fe0f5b682383@canonical.com>
Date:   Wed, 9 Jun 2021 10:51:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608181129.7mnuba6dcaemslul@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/06/2021 19:11, Oleksij Rempel wrote:
> On Tue, Jun 08, 2021 at 04:22:49PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The comparison of the u16 priv->phy_addr < 0 is always false because
>> phy_addr is unsigned. Fix this by assigning the return from the call
>> to function asix_read_phy_addr to int ret and using this for the
>> less than zero error check comparison.
>>
>> Addresses-Coverity: ("Unsigned compared against 0")
>> Fixes: 7e88b11a862a ("net: usb: asix: refactor asix_read_phy_addr() and handle errors on return")
> 
> Here is wrong Fixes tag. This assignment was bogus before this patch.

I'm not sure that's correct, that commit has the following change in it:

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index b404c9462dce..c8ca5187eece 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -220,6 +220,11 @@ static int ax88172a_bind(struct usbnet *dev, struct
usb_interface *intf)
        }

        priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
+       if (priv->phy_addr < 0) {
+               ret = priv->phy_addr;
+               goto free;
+       }
+


> 
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/net/usb/ax88172a.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
>> index 2e2081346740..e24773bb9398 100644
>> --- a/drivers/net/usb/ax88172a.c
>> +++ b/drivers/net/usb/ax88172a.c
>> @@ -205,7 +205,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
>>  		goto free;
>>  	}
>>  
>> -	priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
>> +	ret = asix_read_phy_addr(dev, priv->use_embdphy);
>> +	priv->phy_addr = ret;
> 
> Ah.. it is same bug in different color :)
> You probably wonted to do:
> 	if (ret < 0)
> 		goto free;
> 
> 	priv->phy_addr = ret;

Doh, brain failure of mine. I'll send a V2 later today.

> 
>>  	if (priv->phy_addr < 0) {
>>  		ret = priv->phy_addr;
>>  		goto free;
>> -- 
>> 2.31.1
>>
>>
> 

