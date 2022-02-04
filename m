Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9144A94CA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 08:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbiBDH5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 02:57:44 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17469 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbiBDH5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 02:57:44 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1643961448; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=iK6RxJ631XMxSoNmTixWQ36uvaf5jF8rYd2qVqL4WErQiCm6r/AXZLluHC1/ZBQIjWiKfMU+2ggvK2e8T4hzR4Y54UtWom7jP95umXaVbwv7BGUWrsSI1rWhUDVZIFypB8Ux7zDlGdPnPOXALFyXxOVg7EKnwisc93FzA9D5888=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1643961448; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=AHKeA2qeC3z5LzQrVwHpNBIUBP9mW/yZB/2Yu0eXEfE=; 
        b=FFRm1khxycNKB9BBgQTtkYzrkrd10xHW2iIsE3IoWbN+Q4DTBugYtNWuoWM6UW8WrLGiFYdBD4Bynljz9AU+1yGNdjqDIcyQ3z4FI2iL4BaSKVGMbotgd3gIQkZXnwy/viBzV1f1ESMI3dVCRykDC86aHP+0T6Zg4DdGptmK0ls=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1643961448;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=AHKeA2qeC3z5LzQrVwHpNBIUBP9mW/yZB/2Yu0eXEfE=;
        b=A7TF5iH+XLYYmbz0iWB3oFnxb95iU2tdazD2jWpKVuz+FuJwQWprQ57dRjGWe7Qd
        u6UGG0GIEQcJuL46AAk9wc8kI3ZglfS4PX5i6r0oLjQkvCpon14lP/z4vURjNK4hzms
        8KjZurhMoDIA8ZFEzzig1AEa0dl7dtomJ0J4w5sY=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1643961447104732.0817040849935; Thu, 3 Feb 2022 23:57:27 -0800 (PST)
Message-ID: <71769232-1502-bd59-0d72-129dbe72efb6@arinc9.com>
Date:   Fri, 4 Feb 2022 10:57:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v6 05/13] net: dsa: realtek: convert subdrivers
 into modules
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, frank-w@public-files.de, davem@davemloft.net
References: <20220128060509.13800-1-luizluca@gmail.com>
 <20220128060509.13800-6-luizluca@gmail.com>
 <20220203175850.5d0a8cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220203175850.5d0a8cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/02/2022 04:58, Jakub Kicinski wrote:
> On Fri, 28 Jan 2022 03:05:01 -0300 Luiz Angelo Daros de Luca wrote:
>> diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
>> index 1c62212fb0ec..cd1aa95b7bf0 100644
>> --- a/drivers/net/dsa/realtek/Kconfig
>> +++ b/drivers/net/dsa/realtek/Kconfig
>> @@ -2,8 +2,6 @@
>>   menuconfig NET_DSA_REALTEK
>>   	tristate "Realtek Ethernet switch family support"
>>   	depends on NET_DSA
>> -	select NET_DSA_TAG_RTL4_A
>> -	select NET_DSA_TAG_RTL8_4
>>   	select FIXED_PHY
>>   	select IRQ_DOMAIN
>>   	select REALTEK_PHY
>> @@ -18,3 +16,21 @@ config NET_DSA_REALTEK_SMI
>>   	help
>>   	  Select to enable support for registering switches connected
>>   	  through SMI.
>> +
>> +config NET_DSA_REALTEK_RTL8365MB
>> +	tristate "Realtek RTL8365MB switch subdriver"
>> +	default y
>> +	depends on NET_DSA_REALTEK
>> +	depends on NET_DSA_REALTEK_SMI
>> +	select NET_DSA_TAG_RTL8_4
>> +	help
>> +	  Select to enable support for Realtek RTL8365MB
>> +
>> +config NET_DSA_REALTEK_RTL8366RB
>> +	tristate "Realtek RTL8366RB switch subdriver"
>> +	default y
>> +	depends on NET_DSA_REALTEK
>> +	depends on NET_DSA_REALTEK_SMI
>> +	select NET_DSA_TAG_RTL4_A
>> +	help
>> +	  Select to enable support for Realtek RTL8366RB
> 
> Why did all these new config options grow a 'default y'? Our usual
> policy is to default drivers to disabled.

NET_DSA_REALTEK_SMI and NET_DSA_REALTEK_MDIO also have got "default y".

Respectively:
319a70a5fea9 ("net: dsa: realtek-smi: move to subdirectory")
aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/diff/drivers/net/dsa/realtek/Kconfig?id=319a70a5fea9590e9431dd57f56191996c4787f4

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/diff/drivers/net/dsa/realtek/Kconfig?id=aac94001067da183455d6d37959892744fa01d9d
