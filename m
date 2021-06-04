Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504FA39B9D7
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhFDN3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFDN3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 09:29:38 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4173C061740;
        Fri,  4 Jun 2021 06:27:51 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A2C2222236;
        Fri,  4 Jun 2021 15:27:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1622813268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ZjZ/byVkXGSw+O6l13Rn+fjw8dkV3sOkTd2A/W0i54=;
        b=MLmf/xp7b4YHnZoE2WvlCSHDfXoQV3VvD9B2yj4v7Z4vEwD3tdrFxcUJtz9mknmLVIO9cG
        6vrFLUToHmU+uEr11SJy3BRprSvKLCpBfNcL1WjDCyynavAGU0VpLnk9GcC7LfYAFfJuCm
        DcHAyebEU+OOYWGeByJiNyyMqh5R9E0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 04 Jun 2021 15:27:48 +0200
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: enetc: use get/put_unaligned() for mac
 address handling
In-Reply-To: <db1964cd-df60-08a2-1a66-8a8df7f14fef@gmail.com>
References: <20210604123018.24940-1-michael@walle.cc>
 <db1964cd-df60-08a2-1a66-8a8df7f14fef@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <a1f426e85e24a910944fc712e5c08f01@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-06-04 14:44, schrieb Heiner Kallweit:
> On 04.06.2021 14:30, Michael Walle wrote:
>> The supplied buffer for the MAC address might not be aligned. Thus
>> doing a 32bit (or 16bit) access could be on an unaligned address. For
>> now, enetc is only used on aarch64 which can do unaligned accesses, 
>> thus
>> there is no error. In any case, be correct and use the 
>> get/put_unaligned()
>> helpers.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c 
>> b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> index 31274325159a..a96d2acb5e11 100644
>> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
>> @@ -1,6 +1,7 @@
>>  // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>>  /* Copyright 2017-2019 NXP */
>> 
>> +#include <asm/unaligned.h>
>>  #include <linux/mdio.h>
>>  #include <linux/module.h>
>>  #include <linux/fsl/enetc_mdio.h>
>> @@ -17,15 +18,15 @@ static void enetc_pf_get_primary_mac_addr(struct 
>> enetc_hw *hw, int si, u8 *addr)
>>  	u32 upper = __raw_readl(hw->port + ENETC_PSIPMAR0(si));
>>  	u16 lower = __raw_readw(hw->port + ENETC_PSIPMAR1(si));
>> 
>> -	*(u32 *)addr = upper;
>> -	*(u16 *)(addr + 4) = lower;
>> +	put_unaligned(upper, (u32 *)addr);
>> +	put_unaligned(lower, (u16 *)(addr + 4));
> 
> I think you want to write little endian, therefore on a BE platform
> this code may be wrong. Better use put_unaligned_le32?
> By using these versions of the unaligned helpers you could also
> remove the pointer cast.

I wasn't sure about the endianness. Might be the case, that on BE
platforms, the endianess of the register will swap too. (OTOH I
could use aarch64 with BE..)

But I'm fine with changing it. I'd presume this being the only
platform for now it doesn't really matter.

-michael
