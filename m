Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C2347ADD4
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 15:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbhLTOz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 09:55:57 -0500
Received: from mx1.riseup.net ([198.252.153.129]:60268 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238354AbhLTOxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 09:53:31 -0500
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4JHjJV2s6JzDxcd;
        Mon, 20 Dec 2021 06:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1640012010; bh=vSeIyAkhO0ZOW1WcxnogAz9c4X/ngALpMtGZbM94rGM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=apFSa2DQ2uIoSzKaUdmEGaDd3wr/9bahPD0jPKjDW9p5jkNm/7UY8lb96C9RHOyJA
         K2DWDwtdZlUM9gJvQzuvc9ZWWttPENA4E/Sr8nqBcFMkx1GsUcPnoYL9fNELfF2b+X
         U7jaUb1levF0lSdb+H+51AVGC2Jqfuh7F/d8lCIA=
X-Riseup-User-ID: DA881FE705E4AAF6BA1647C148B3DD7865ACFF5133E6C066DFDEB45BF6FC08B4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4JHjJT5PYfz1y53;
        Mon, 20 Dec 2021 06:53:29 -0800 (PST)
Message-ID: <43648ff4-90f0-37d8-24c9-50f9b198a3bd@riseup.net>
Date:   Mon, 20 Dec 2021 15:53:27 +0100
MIME-Version: 1.0
Subject: Re: [PATCH net v3] bonding: fix ad_actor_system option setting to
 default
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
References: <20211218015001.1740-1-ffmancera@riseup.net>
 <1323.1639794889@famine>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <1323.1639794889@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/21 03:34, Jay Vosburgh wrote:
> Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> 
>> When 802.3ad bond mode is configured the ad_actor_system option is set to
>> "00:00:00:00:00:00". But when trying to set the all-zeroes MAC as actors'
>> system address it was failing with EINVAL.
>>
>> An all-zeroes ethernet address is valid, only multicast addresses are not
>> valid values.
>>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
>> ---
>> v2: added documentation changes and modified commit message
>> v3: fixed format warning on commit message
>> ---
>> Documentation/networking/bonding.rst | 11 ++++++-----
>> drivers/net/bonding/bond_options.c   |  2 +-
>> 2 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
>> index 31cfd7d674a6..c0a789b00806 100644
>> --- a/Documentation/networking/bonding.rst
>> +++ b/Documentation/networking/bonding.rst
>> @@ -196,11 +196,12 @@ ad_actor_sys_prio
>> ad_actor_system
>>
>> 	In an AD system, this specifies the mac-address for the actor in
>> -	protocol packet exchanges (LACPDUs). The value cannot be NULL or
>> -	multicast. It is preferred to have the local-admin bit set for this
>> -	mac but driver does not enforce it. If the value is not given then
>> -	system defaults to using the masters' mac address as actors' system
>> -	address.
>> +	protocol packet exchanges (LACPDUs). The value cannot be a multicast
>> +	address. If the all-zeroes MAC is specified, bonding will internally
>> +	use the MAC of the bond itself. It is preferred to have the
>> +	local-admin bit set for this mac but driver does not enforce it. If
>> +	the value is not given then system defaults to using the masters'
>> +	mac address as actors' system address.
>>
>> 	This parameter has effect only in 802.3ad mode and is available through
>> 	SysFs interface.
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

I noticed this patch state in patchwork is "changes requested"[1]. But I 
didn't get any reply or request. Is the state wrong? Should I ignore it? 
If not, what is missing?

Thanks,
Fernando.

[1] 
https://patchwork.kernel.org/project/netdevbpf/patch/20211218015001.1740-1-ffmancera@riseup.net/
