Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513D252E436
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345379AbiETFP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345343AbiETFPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:15:24 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2535AF1CD
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 22:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=99F3FMtynRXLU3SMkuLVS9khiLzldAnE2r+8J3zQyYY=; b=HqK2xzLWi4l6IlFumsdBxGlVhu
        4qw86F8QrlLB6HdpOSbkU81/61TJp9nIv8qcWoqqtq895TafiKzTBGPIheoVQHlDtMMuleOT4ZM/o
        7fN2Gbajq54987NuQJqkqYQkB9oyGZ+VCCHMe6N8UVFjJAa5pA4FSfc301lRmi6naS1KBGfXZQYfW
        bWNL68oDhdkVdDZJC9y9LsMdgckp+d/6Kh9iWdYR8p8NJAwPoDoB1friSWSustUMmBC2ny71LFQv4
        fyjurBDXs6e2HWu06dtcK9ZvoycfwsVUFeOoqwIM+TBfd19rej1NhsFB1EWB2jIbZ4qYczxsVFY1C
        Zy75BaOA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nruyk-002EPj-EJ; Fri, 20 May 2022 05:15:10 +0000
Message-ID: <f70d9209-1416-2f55-c006-38ec41e36fa3@infradead.org>
Date:   Thu, 19 May 2022 22:15:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Juergen Borleis <jbe@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220519213351.9020-1-rdunlap@infradead.org>
 <20220519230905.mkuwi3ytguxrwbpl@skbuf>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220519230905.mkuwi3ytguxrwbpl@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/19/22 16:09, Vladimir Oltean wrote:
> Hi Randy,
> 
> On Thu, May 19, 2022 at 02:33:51PM -0700, Randy Dunlap wrote:
>> Since kconfig 'select' does not follow dependency chains, if symbol KSA
>> selects KSB, then KSA should also depend on the same symbols that KSB
>> depends on, in order to prevent Kconfig warnings and possible build
>> errors.
>>
>> Change NET_DSA_SMSC_LAN9303_I2C so that it is limited to VLAN_8021Q if
>> the latter is enabled and results in changing NET_DSA_SMSC_LAN9303_I2C
>> from =y to =m and eliminating the kconfig warning.
>>
>> WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
>>   Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
>>   Selected by [y]:
>>   - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
>>
>> Fixes: be4e119f9914 ("net: dsa: LAN9303: add I2C managed mode support")
> 
> The Fixes: tag is incorrect. It should be:
> 
> Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")

Corrected. Thanks.
> 
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Vivien Didelot <vivien.didelot@gmail.com>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Vladimir Oltean <olteanv@gmail.com>
>> Cc: Juergen Borleis <jbe@pengutronix.de>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> ---
>>  drivers/net/dsa/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- a/drivers/net/dsa/Kconfig
>> +++ b/drivers/net/dsa/Kconfig
>> @@ -82,6 +82,7 @@ config NET_DSA_SMSC_LAN9303
>>  config NET_DSA_SMSC_LAN9303_I2C
>>  	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in I2C managed mode"
>>  	depends on I2C
>> +	depends on VLAN_8021Q || VLAN_8021Q=n
> 
> I'm pretty sure that NET_DSA_SMSC_LAN9303_MDIO needs the same treatment
> as NET_DSA_SMSC_LAN9303_I2C. And the "depends" line can now be removed
> from NET_DSA_SMSC_LAN9303, it serves no purpose.

Ok, v2 on the way.

>>  	select NET_DSA_SMSC_LAN9303
>>  	select REGMAP_I2C
>>  	help

-- 
~Randy
