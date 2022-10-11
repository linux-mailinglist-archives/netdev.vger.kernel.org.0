Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006C05FBCF6
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJKVbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJKVbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:31:31 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A752192594;
        Tue, 11 Oct 2022 14:31:29 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 99A78504E80;
        Wed, 12 Oct 2022 00:27:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 99A78504E80
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665523680; bh=Snqz/eTDzxw25Q39oAWKZOmTxeAOD5iOEPrqAgO67Eg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IZqHkfh3Ozakx9ncf5mATON2e5fdD0U8UUpLxUMUCl3Yne5hdbT6IZObiWAqXpzu7
         Hhk8x2vhJ7h1v6dXhzZ69+Jc+R9MSH8GRw+Ph7VW53tu6volQsi0PU5rayuCZdRyvI
         xmHw0yWtEkmnBB+b3Pu+0F3IjNduzuulKUFdLpnM=
Message-ID: <ecf59dda-2d6a-2c56-668b-5377ae107439@novek.ru>
Date:   Tue, 11 Oct 2022 22:31:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-2-vfedorenko@novek.ru> <Y0PjULbYQf1WbI9w@nanopsycho>
 <24d1d750-7fd0-44e2-318c-62f6a4a23ea5@novek.ru> <Y0UqFml6tEdFt0rj@nanopsycho>
 <Y0UtiBRcc8aBS4tD@nanopsycho>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <Y0UtiBRcc8aBS4tD@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.10.2022 09:47, Jiri Pirko wrote:
> Tue, Oct 11, 2022 at 10:32:22AM CEST, jiri@resnulli.us wrote:
>> Mon, Oct 10, 2022 at 09:54:26PM CEST, vfedorenko@novek.ru wrote:
>>> On 10.10.2022 10:18, Jiri Pirko wrote:
>>>> Mon, Oct 10, 2022 at 03:17:59AM CEST, vfedorenko@novek.ru wrote:
>>>>> From: Vadim Fedorenko <vadfed@fb.com>
> 
> [...]
> 
> 
>>> I see your point. We do have hardware which allows changing type of SMA
>>> connector, and even the direction, each SMA could be used as input/source or
>>> output of different signals. But there are limitation, like not all SMAs can
>>> produce IRIG-B signal or only some of them can be used to get GNSS 1PPS. The
>>
>> Okay, so that is not the *type* of source, but rather attribute of it.
>> Example:
>>
>> $ dpll X show
>> index 0
>>   type EXT
>>   signal 1PPS
>>   supported_signals
>>      1PPS 10MHz
>>
>> $ dpll X set source index 1 signal_type 10MHz
>> $ dpll X show
>> index 0
>>   type EXT
>>   signal 10MHz
>>   supported_signals
>>      1PPS 10MHz
>>
>> So one source with index 0 of type "EXT" (could be "SMA", does not
>> matter) supports 1 signal types.
>>
>>
>> Thinking about this more and to cover the case when one SMA could be
>> potencially used for input and output. It already occured to me that
>> source/output are quite similar, have similar/same attributes. What if
>> they are merged together to say a "pin" object only with extra
>> PERSONALITY attribute?
>>
>> Example:
>>
>> -> DPLL_CMD_PIN_GET - dump
>>       ATTR_DEVICE_ID X
>>
>> <- DPLL_CMD_PIN_GET
>>
>>        ATTR_DEVICE_ID X
>>        ATTR_PIN_INDEX 0
>>        ATTR_PIN_TYPE EXT
>>        ATTR_PIN_SIGNAL 1PPS   (selected signal)
>>        ATTR_PIN_SUPPORTED_SIGNALS (nest)
>>          ATTR_PIN_SIGNAL 1PPS
>>          ATTR_PIN_SIGNAL 10MHZ
>>        ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>>        ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>>          ATTR_PIN_PERSONALITY DISCONNECTED
>>          ATTR_PIN_PERSONALITY INPUT
>>          ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>> 					  output)
>>
>>        ATTR_DEVICE_ID X
>>        ATTR_PIN_INDEX 1
>>        ATTR_PIN_TYPE EXT
>>        ATTR_PIN_SIGNAL 10MHz   (selected signal)
>>        ATTR_PIN_SUPPORTED_SIGNALS (nest)
>>          ATTR_PIN_SIGNAL 1PPS
>>          ATTR_PIN_SIGNAL 10MHZ
>>        ATTR_PIN_PERSONALITY DISCONNECTED   (selected personality - not
>> 					    connected currently)
>>        ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>>          ATTR_PIN_PERSONALITY DISCONNECTED
>>          ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
>>
>>        ATTR_DEVICE_ID X
>>        ATTR_PIN_INDEX 2
>>        ATTR_PIN_TYPE GNSS
>>        ATTR_PIN_SIGNAL 1PPS   (selected signal)
>>        ATTR_PIN_SUPPORTED_SIGNALS (nest)
>>          ATTR_PIN_SIGNAL 1PPS
>>        ATTR_PIN_PERSONALITY INPUT   (selected personality - note this is
>> 				     now he selected source, being only
>> 				     pin with INPUT personality)
>>        ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>>          ATTR_PIN_PERSONALITY DISCONNECTED
>>          ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
>>
>>        ATTR_DEVICE_ID X
>>        ATTR_PIN_INDEX 3
>>        ATTR_PIN_TYPE SYNCE_ETH_PORT
>>        ATTR_PIN_NETDEV_IFINDEX 20
>>        ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>>        ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>>          ATTR_PIN_PERSONALITY DISCONNECTED
>>          ATTR_PIN_PERSONALITY INPUT
>>          ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>> 					  output)
>>
>>        ATTR_DEVICE_ID X
>>        ATTR_PIN_INDEX 4
>>        ATTR_PIN_TYPE SYNCE_ETH_PORT
>>        ATTR_PIN_NETDEV_IFINDEX 30
>>        ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>>        ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>>          ATTR_PIN_PERSONALITY DISCONNECTED
>>          ATTR_PIN_PERSONALITY INPUT
>>          ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>> 					  output)
>>
>>
>> This allows the user to actually see the full picture:
>> 1) all input/output pins in a single list, no duplicates
>> 2) each pin if of certain type (ATTR_PIN_TYPE) EXT/GNSS/SYNCE_ETH_PORT
>> 3) the pins that can change signal type contain the selected and list of
>>    supported signal types (ATTR_PIN_SIGNAL, ATTR_PIN_SUPPORTED_SIGNALS)
>> 4) direction/connection of the pin to the DPLL is exposed over
>>    ATTR_PIN_PERSONALITY. For each pin, the driver would expose it can
>>    act as INPUT/OUTPUT and even more, it can indicate the pin can
>>    disconnect from DPLL entirely (if possible).
>> 5) user can select the source by setting ATTR_PIN_PERSONALITY of certain
>>    pin to INPUT. Only one pin could be set to INPUT and that is the
>>    souce of DPLL.
>>    In case no pin have personality set to INPUT, the DPLL is
>>    free-running.
> 
> Okay, thinking about it some more, I would leave the source select
> indepentent from the ATTR_PIN_PERSONALITY and selectable using device
> set cmd and separate attribute. It works better even more when consider
> autoselect mode.
> 
> Well of course only pins with ATTR_PIN_PERSONALITY INPUT could be
> selected as source.
> 

Overall, I agree with this proposal, and as I've already said, the work is going 
exactly the same way - to introduce pin object with separate set of attributes.
I don't really like 'PERSONALITY' naming, I think we have to find a better name. 
It looks like DIRECTION is slightly better. And the CONNECTED/DISCONNECTED 
should be different attribute. And we also need attribute PRIORITY to be able to 
configure (or hint) auto-select mode. There are also special objects called 
muxes, which consist of several inputs and one output, but they cannot 
synthonise signal, only pass one of the inputs to output. We are still in kind 
of discussion whether to have them as separate objects, or extend the amount of 
pins of DPLL device in this case. The problem again in the auto-select mode and 
priorities. It would be great to hear your thoughts about such objects.

>>
>> This would introduce quite nice flexibility, exposes source/output
>> capabilities and provides good visilibity of current configuration.
>>
>>
>>> interface was created to cover such case. I believe we have to improve it to
>>> cover SyncE configuration better, but I personally don't have SyncE hardware
>>> ready to test and that's why I have to rely on suggestions from yours or
>>> Arkadiusz's experience. From what I can see now there is need for special
>>> attribute to link source to net device, and I'm happy to add it. In case of
>>> fixed configuration of sources, the device should provide only one type as
>>> supported and that's it.
>>>
> 
> [...]

