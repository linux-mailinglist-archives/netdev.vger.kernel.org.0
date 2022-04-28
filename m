Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A649A513954
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349780AbiD1QFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349782AbiD1QFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:05:35 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB1515835;
        Thu, 28 Apr 2022 09:02:18 -0700 (PDT)
Received: from [IPV6:2003:e9:d725:1d84:da74:857c:13d4:984b] (p200300e9d7251d84da74857c13d4984b.dip0.t-ipconnect.de [IPv6:2003:e9:d725:1d84:da74:857c:13d4:984b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 9F385C02E8;
        Thu, 28 Apr 2022 18:02:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1651161736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36sLovBjT3MSxnmcWLyHM8r5DPEDk2J8t0QWZ9otyyk=;
        b=agoEIK+39ArYo8XBpk/6CcZ46YU6J+td2OFz7uQJO9w5Fv9C8aKrsL2WPRUbHWsdWlIHPm
        4SrR9aRW8CnJn0wR3VVpJeIzknE8Pk26AZqxMPLFeMJdhunwz3qsZnZZbRPJ7RPPp/n9Jh
        Ls8NJZ29xYgIhJlBa5TmYPviqkjOcGDz8D/G5zApxCE36rmxIQjGsVm4F6IS8HF+fbtTvU
        nb8MEcXPI2KEiWUb+xkxtMJROwo1ELAAD1ap5cveT89kIK+wIITC50matfR8upVqOL69AV
        DhH9JeClXtnpQBXe2I7GZ1NgNhqkI5YBhjVqdEr24iNsiCVAhi9XcOvc0pM8NA==
Message-ID: <8f32c05e-5830-79b3-1a3a-996ee8b58e52@datenfreihafen.org>
Date:   Thu, 28 Apr 2022 18:02:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH wpan-next v3 3/4] net: mac802154: Set durations
 automatically
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
 <20220201180629.93410-4-miquel.raynal@bootlin.com>
 <20220428175838.08bb7717@xps13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220428175838.08bb7717@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 28.04.22 17:58, Miquel Raynal wrote:
> Hi Stefan,
> 
> miquel.raynal@bootlin.com wrote on Tue,  1 Feb 2022 19:06:28 +0100:
> 
>> As depicted in the IEEE 802.15.4 specification, modulation/bands are
>> tight to a number of page/channels so we can for most of them derive the
>> durations automatically.
>>
>> The two locations that must call this new helper to set the variou
>> symbol durations are:
>> - when manually requesting a channel change though the netlink interface
>> - at PHY creation, once the device driver has set the default
>>    page/channel
>>
>> If an information is missing, the symbol duration is not touched, a
>> debug message is eventually printed. This keeps the compatibility with
>> the unconverted drivers for which it was too complicated for me to find
>> their precise information. If they initially provided a symbol duration,
>> it would be kept. If they don't, the symbol duration value is left
>> untouched.
>>
>> Once the symbol duration derived, the lifs and sifs durations are
>> updated as well.
>>
>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>> ---
>>   include/net/cfg802154.h |  2 ++
>>   net/mac802154/cfg.c     |  1 +
>>   net/mac802154/main.c    | 46 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 49 insertions(+)
>>
>> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
>> index 8a4b6a50452f..49b4bcc24032 100644
>> --- a/include/net/cfg802154.h
>> +++ b/include/net/cfg802154.h
>> @@ -405,4 +405,6 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
>>   	return dev_name(&phy->dev);
>>   }
>>   
>> +void ieee802154_configure_durations(struct wpan_phy *phy);
>> +
>>   #endif /* __NET_CFG802154_H */
>> diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
>> index fbeebe3bc31d..1e4a9f74ed43 100644
>> --- a/net/mac802154/cfg.c
>> +++ b/net/mac802154/cfg.c
>> @@ -118,6 +118,7 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
>>   	if (!ret) {
>>   		wpan_phy->current_page = page;
>>   		wpan_phy->current_channel = channel;
>> +		ieee802154_configure_durations(wpan_phy);
>>   	}
>>   
>>   	return ret;
>> diff --git a/net/mac802154/main.c b/net/mac802154/main.c
>> index 53153367f9d0..5546ef86e231 100644
>> --- a/net/mac802154/main.c
>> +++ b/net/mac802154/main.c
>> @@ -113,6 +113,50 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
>>   }
>>   EXPORT_SYMBOL(ieee802154_alloc_hw);
>>   
>> +void ieee802154_configure_durations(struct wpan_phy *phy)
>> +{
>> +	u32 duration = 0;
>> +
>> +	switch (phy->current_page) {
>> +	case 0:
>> +		if (BIT(phy->current_page) & 0x1)
> 
> I am very sorry to spot this only now but this is wrong.
> 
> all the conditions from here and below should be:
> 
> 		if (BIT(phy->current_channel & <mask>))
> 
> The masks look good, the durations as well, but the conditions are
> wrong.
> 
>> +			/* 868 MHz BPSK 802.15.4-2003: 20 ksym/s */
>> +			duration = 50 * NSEC_PER_USEC;
>> +		else if (phy->current_page & 0x7FE)
> 
> Ditto
> 
>> +			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
>> +			duration = 25 * NSEC_PER_USEC;
>> +		else if (phy->current_page & 0x7FFF800)
> 
> Ditto
> 
>> +			/* 2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
>> +			duration = 16 * NSEC_PER_USEC;
>> +		break;
>> +	case 2:
>> +		if (BIT(phy->current_page) & 0x1)
> 
> Ditto
> 
>> +			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
>> +			duration = 40 * NSEC_PER_USEC;
>> +		else if (phy->current_page & 0x7FE)
> 
> Ditto
> 
>> +			/* 915 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
>> +			duration = 16 * NSEC_PER_USEC;
>> +		break;
>> +	case 3:
>> +		if (BIT(phy->current_page) & 0x3FFF)
> 
> Ditto
> 
>> +			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
>> +			duration = 6 * NSEC_PER_USEC;
>> +		break;
> 
> I see it's "only" in wpan-next (781830c800dd "net: mac802154: Set
> durations automatically") and was not yet pulled in the net-next
> tree so please let me know what you prefer: I can either provide a
> proper patch to fit it (without upstream Fixes reference), or you can
> just apply this diff below and push -f the branch. Let me know what you
> prefer.

No forced push to a public branch in my public repo. Please provide a 
fixup patch that I can apply on top.

regards
Stefan Schmidt
