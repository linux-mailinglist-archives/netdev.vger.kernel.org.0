Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956DB479802
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 02:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhLRB2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 20:28:25 -0500
Received: from mx1.riseup.net ([198.252.153.129]:40694 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhLRB2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 20:28:24 -0500
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4JG7XS46HszF4d2;
        Fri, 17 Dec 2021 17:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1639790904; bh=sGTr6obOiPwUb55pZLDeGEKYKWp66GSzbpAA1hjiy0w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GTRZDjIaAgtnAbe7wjpQRCOaOfjkELStZoY6eB9OXhhgZmH5C/WdrZzWe5CVPA9tL
         H8FiASYtsC0vjq8ZyQl+PhCfqHUBT36kMqcEzqB7ZWr107jgmmfFgZpp4K0NLqqqYJ
         Kac6sRTKJzlyFFm2VLy+pEuOYCLwLPmSseaWaUNQ=
X-Riseup-User-ID: 6305AD1D2BF108F7F8AC6E0FE7531ECFFBC5AEC75267C8948976617B7222B140
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4JG7XR6YF5z5vfh;
        Fri, 17 Dec 2021 17:28:23 -0800 (PST)
Message-ID: <f70ec480-f224-d90c-8f96-53b5692e1494@riseup.net>
Date:   Sat, 18 Dec 2021 02:28:22 +0100
MIME-Version: 1.0
Subject: Re: [PATCH net] bonding: fix ad_actor_system option setting to
 default
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
References: <20211217182846.6910-1-ffmancera@riseup.net>
 <14022.1639779760@famine>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <14022.1639779760@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/21 23:22, Jay Vosburgh wrote:
> Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> 
>> When 802.3ad bond mode is configured the ad_actor_system option is set
>> to "00:00:00:00:00:00". But when trying to set the default value
>> manually it was failing with EINVAL.
>>
>> A zero ethernet address is valid, only multicast addresses are not valid
>> values.
> 
> 	Your intent here by setting ad_actor_system to all zeroes is to
> induce bonding to actually set ad_actor_system to the MAC of the bond
> itself?

Yes, as the user should be able to set it back to the MAC of the bond 
itself. Basically, restore it to the default value.

> 
> 	If so, please also update Documentation/networking/bonding.rst,
> as the current text says
> 
>          In an AD system, this specifies the mac-address for the actor in
>          protocol packet exchanges (LACPDUs). The value cannot be NULL or
>          multicast. It is preferred to have the local-admin bit set for this
>          mac but driver does not enforce it. If the value is not given then
>          system defaults to using the masters' mac address as actors' system
>          address.
> 
> 	I'd suggest something like "The value cannot be a multicast
> address.  If the all-zeroes MAC is specified, bonding will internally
> use the MAC of the bond itself."

Sure, that would be good. I will do it. Thank you!

> 
> 	-J
> 
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>> drivers/net/bonding/bond_options.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>> index a8fde3bc458f..b93337b5a721 100644
>> --- a/drivers/net/bonding/bond_options.c
>> +++ b/drivers/net/bonding/bond_options.c
>> @@ -1526,7 +1526,7 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
>> 		mac = (u8 *)&newval->value;
>> 	}
>>
>> -	if (!is_valid_ether_addr(mac))
>> +	if (is_multicast_ether_addr(mac))
>> 		goto err;
>>
>> 	netdev_dbg(bond->dev, "Setting ad_actor_system to %pM\n", mac);
>> -- 
>> 2.30.2
>>
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> 

