Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4C955B3D2
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiFZTjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiFZTje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:39:34 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F097FA8
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 12:39:32 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BC5025001E5;
        Sun, 26 Jun 2022 22:37:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BC5025001E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656272277; bh=1adkKsCUW/LBYenvLhrr/HCvSsxBPAtDdyxVUJ8h1HY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bHBG29tAh4kIdnH8e5v4jRgsLm4vC34eQ5ZF+mC9Al8HJ0shOQGS/AjAVPefWSUDU
         Epmh9qITHbg3gMSoo8onN3lG6GGZed1fVUJ9Mio6AgEUTuCbcHo0DgNwxUS3S0JuUK
         LZVV6i42jK2YE5HEAb/6aUp9zNSdFGCnuxgrWUxE=
Message-ID: <a85620a1-94ef-0fdf-3c92-6c9d2e3614f5@novek.ru>
Date:   Sun, 26 Jun 2022 20:39:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v1 1/3] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-2-vfedorenko@novek.ru>
 <DM6PR11MB46579C692B75DEF81530B7339BB59@DM6PR11MB4657.namprd11.prod.outlook.com>
 <34093244-431b-98c8-ba88-82957c659808@novek.ru>
 <DM6PR11MB4657C1830DACC5EB4CD98B789BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <DM6PR11MB4657C1830DACC5EB4CD98B789BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.06.2022 18:36, Kubalewski, Arkadiusz wrote:

... skipped ...

>>>> +static int __dpll_cmd_dump_status(struct dpll_device *dpll,
>>>> +					   struct sk_buff *msg)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	if (!dpll->ops->get_status && !dpll->ops->get_temp && !dpll->ops->get_lock_status)
>>>> +		return 0;
>>>
>>> what if dpll doesn't support one of those commands?
>>>
>>
>> then only supported attributes will be messaged back to user
> 
> Hmm, isn't that redundat if we need to check those again below?
> 

I removed this check for now. Maybe I will return -NOOPSUPP here.

>>
>>>> +
>>>> +	if (dpll->ops->get_status) {
>>>> +		ret = dpll->ops->get_status(dpll);
>>>> +		if (nla_put_u32(msg, DPLLA_STATUS, ret))
>>>> +			return -EMSGSIZE;
>>>> +	}
>>>> +
>>>> +	if (dpll->ops->get_temp) {
>>>> +		ret = dpll->ops->get_status(dpll);
>>>> +		if (nla_put_u32(msg, DPLLA_TEMP, ret))
>>>> +			return -EMSGSIZE;
>>>> +	}
>>>
>>> shouldn't be get_temp(dpll)?
>>
>> good catch, copy-paste error
>>
>>>> +
>>>> +	if (dpll->ops->get_lock_status) {
>>>> +		ret = dpll->ops->get_lock_status(dpll);
>>>> +		if (nla_put_u32(msg, DPLLA_LOCK_STATUS, ret))
>>>> +			return -EMSGSIZE;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int dpll_device_dump_one(struct dpll_device *dev, struct sk_buff *msg, int flags)
>>>> +{
>>>> +	struct nlattr *hdr;
>>>> +	int ret;
>>>> +
>>>> +	hdr = nla_nest_start(msg, DPLLA_DEVICE);
>>>> +	if (!hdr)
>>>> +		return -EMSGSIZE;
>>>> +
>>>> +	mutex_lock(&dev->lock);
>>>> +	ret = __dpll_cmd_device_dump_one(dev, msg);
>>>> +	if (ret)
>>>> +		goto out_cancel_nest;
>>>> +
>>>> +	if (flags & DPLL_FLAG_SOURCES && dev->ops->get_source_type) {
>>>> +		ret = __dpll_cmd_dump_sources(dev, msg);
>>>> +		if (ret)
>>>> +			goto out_cancel_nest;
>>>> +	}
>>>> +
>>>> +	if (flags & DPLL_FLAG_OUTPUTS && dev->ops->get_output_type) {
>>>> +		ret = __dpll_cmd_dump_outputs(dev, msg);
>>>> +		if (ret)
>>>> +			goto out_cancel_nest;
>>>> +	}
>>>> +
>>>> +	if (flags & DPLL_FLAG_STATUS) {
>>>> +		ret = __dpll_cmd_dump_status(dev, msg);
>>>> +		if (ret)
>>>> +			goto out_cancel_nest;
>>>> +	}
>>>> +
>>>> +	mutex_unlock(&dev->lock);
>>>> +	nla_nest_end(msg, hdr);
>>>> +
>>>> +	return 0;
>>>> +
>>>> +out_cancel_nest:
>>>> +	mutex_unlock(&dev->lock);
>>>> +	nla_nest_cancel(msg, hdr);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int dpll_genl_cmd_set_source(struct param *p)
>>>> +{
>>>> +	const struct genl_dumpit_info *info = genl_dumpit_info(p->cb);
>>>> +	struct dpll_device *dpll = p->dpll;
>>>> +	int ret = 0, src_id, type;
>>>> +
>>>> +	if (!info->attrs[DPLLA_SOURCE_ID] ||
>>>> +	    !info->attrs[DPLLA_SOURCE_TYPE])
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (!dpll->ops->set_source_type)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>> +	src_id = nla_get_u32(info->attrs[DPLLA_SOURCE_ID]);
>>>> +	type = nla_get_u32(info->attrs[DPLLA_SOURCE_TYPE]);
>>>> +
>>>> +	mutex_lock(&dpll->lock);
>>>> +	ret = dpll->ops->set_source_type(dpll, src_id, type);
>>>> +	mutex_unlock(&dpll->lock);
> 
> I wonder if shouldn't the dpll ptr be validated here, and in similar cases.
> I mean, between calling dpll_pre_doit and actually doing something on a 'dpll',
> it is possible that device gets removed?
> 
> Or maybe pre_doit/post_doit shall lock and unlock some other mutex?
> Altough, I am not an expert in the netlink stuff, thus just raising a concern.
>

I was trying to reduce the scope of mutex as much as possible, but it looks like 
it's better to extend it to cover whole iteration with dpll ptr. Not sure if 
this is a correct way though.

... skipped ...

>>>> +
>>>> +/* Attributes of dpll_genl_family */
>>>> +enum dpll_genl_get_attr {
>>>> +	DPLLA_UNSPEC,
>>>> +	DPLLA_DEVICE,
>>>> +	DPLLA_DEVICE_ID,
>>>> +	DPLLA_DEVICE_NAME,
>>>> +	DPLLA_SOURCE,
>>>> +	DPLLA_SOURCE_ID,
>>>> +	DPLLA_SOURCE_TYPE,
>>>> +	DPLLA_OUTPUT,
>>>> +	DPLLA_OUTPUT_ID,
>>>> +	DPLLA_OUTPUT_TYPE,
>>>> +	DPLLA_STATUS,
>>>> +	DPLLA_TEMP,
>>>> +	DPLLA_LOCK_STATUS,
>>>> +	DPLLA_FLAGS,
>>>> +
>>>> +	__DPLLA_MAX,
>>>> +};
>>>> +#define DPLLA_GET_MAX (__DPLLA_MAX - 1)
>>>
>>> I think "_get_/_GET_" in above names is outdated?
>>>
>>
>> Yes, you are right. The earliest revision had these "GET/SET" in attributes but
>> later we decided to unite them into common attributes. I will remove these
>> artifacts in the next revision.
>>

removed these artifacts

>>>> +
>>>> +/* DPLL signal types used as source or as output */
>>>> +enum dpll_genl_signal_type {
>>>> +	DPLL_TYPE_EXT_1PPS,
>>>> +	DPLL_TYPE_EXT_10MHZ,
>>>> +	DPLL_TYPE_SYNCE_ETH_PORT,
>>>> +	DPLL_TYPE_INT_OSCILLATOR,
>>>> +	DPLL_TYPE_GNSS,
>>>> +
>>>> +	__DPLL_TYPE_MAX,
>>>> +};
>>>> +#define DPLL_TYPE_MAX (__DPLL_TYPE_MAX - 1)
>>>> +
>>>> +/* Events of dpll_genl_family */
>>>> +enum dpll_genl_event {
>>>> +	DPLL_EVENT_UNSPEC,
>>>> +	DPLL_EVENT_DEVICE_CREATE,		/* DPLL device creation */
>>>> +	DPLL_EVENT_DEVICE_DELETE,		/* DPLL device deletion */
>>>> +	DPLL_EVENT_STATUS_LOCKED,		/* DPLL device locked to source */
>>>> +	DPLL_EVENT_STATUS_UNLOCKED,	/* DPLL device freerun */
>>>> +	DPLL_EVENT_SOURCE_CHANGE,		/* DPLL device source changed */
>>>> +	DPLL_EVENT_OUTPUT_CHANGE,		/* DPLL device output changed */
>>>> +
>>>> +	__DPLL_EVENT_MAX,
>>>> +};
>>>> +#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
>>>> +
>>>> +/* Commands supported by the dpll_genl_family */
>>>> +enum dpll_genl_cmd {
>>>> +	DPLL_CMD_UNSPEC,
>>>> +	DPLL_CMD_DEVICE_GET,	/* List of DPLL devices id */
>>>> +	DPLL_CMD_SET_SOURCE_TYPE,	/* Set the DPLL device source type */
>>>> +	DPLL_CMD_SET_OUTPUT_TYPE,	/* Get the DPLL device output type */
>>>
>>> "Get" in comment description looks like a typo.
>>> I am getting bit confused with the name and comments.
>>> For me, first look says: it is selection of a type of a source.
>>> But in the code I can see it selects a source id and a type.
>>> Type of source originates in HW design, why would the one want to "set" it?
>>> I can imagine a HW design where a single source or output would allow to choose
>>> where the signal originates/goes, some kind of extra selector layer for a
>>> source/output, but was that the intention?
>>
>> In general - yes, we have experimented with our time card providing different
>> types of source synchronisation signal on different input pins, i.e. 1PPS,
>> 10MHz, IRIG-B, etc. Any of these signals could be connected to any of 4 external
>> pins, that's why I source id is treated as input pin identifier and source type
>> is the signal type it receives.
>>
>>> If so, shouldn't the user get some bitmap/list of modes available for each
>>> source/output?
>>
>> Good idea. We have list of available modes exposed via sysfs file, and I agree
>> that it's worth to expose them via netlink interface. I will try to address this
>> in the next version.
>>
>>>
>>> The user shall get some extra information about the source/output. Right now
>>> there can be multiple sources/outputs of the same type, but not really possible
>>> to find out their purpose. I.e. a dpll equipped with four source of
>>> DPLL_TYPE_EXT_1PPS type.
>>>   > This implementation looks like designed for a "forced reference lock" mode
>>> where the user must explicitly select one source. But a multi source/output
>>> DPLL could be running in different modes. I believe most important is automatic
>>> mode, where it tries to lock to a user-configured source priority list.
>>> However, there is also freerun mode, where dpll isn't even trying to lock to
>>> anything, or NCO - Numerically Controlled Oscillator mode.
>>
>> Yes, you are right, my focus was on "forced reference lock" mode as currently
>> this is the only mode supported by our hardware. But I'm happy to extend it to
>> other usecases.
>>
>>> It would be great to have ability to select DPLL modes, but also to be able to
>>> configure priorities, read failure status, configure extra "features" (i.e.
>>> Embedded Sync, EEC modes, Fast Lock)
>> I absolutely agree on this way of improvement, and I already have some ongoing
>> work about failures/events/status change messages. I can see no stoppers for
>> creating priorities (if supported by HW) and other extra "features", but we have
>> to agree on the interface with flexibility in mind.
> 
> Great and makes perfect sense!
> 
>>
>>> The sources and outputs can also have some extra features or capabilities, like:
>>> - enable Embedded Sync
>>
>> Does it mean we want to enable or disable Embedded Sync within one protocol? Is
>> it like Time-Sensitive Networking (TSN) for Ethernet?
> 
> Well, from what I know, Embedded PPS (ePPS), Embedded Pulse Per 2 Seconds
> (ePP2S) and Embedded Sync (eSync) can be either 25/75 or 75/25, which describes
> a ratio of how the 'embedded pulse' is divided into HIGH and LOW states on a
> pulse of higher frequency signal in which EPPS/EPP2S/ESync is embedded.
> 
> EPPS and EPP2S are rather straightforward, once an EPPS enabled input is
> selected as a source, then output configured as PPS(PP2S) shall tick in the
> same periods as signal "embedded" in input.
> Embedded Sync (eSync) is similar but it allows for configuration of frequency
> of a 'sync' signal, i.e. source is 10MHz with eSync configured as 100 HZ, where
> the output configured for 100HZ could use it.
> 
> I cannot say how exactly Embedded Sync/PPS will be used, as from my perspective
> this is user specific, and I am not very familiar with any standard describing
> its usage.
> I am working on SyncE, where either Embedded Sync or PPS is not a part of SyncE
> standard, but I strongly believe that users would need to run a DPLL with
> Embedded Sync/PPS enabled for some other things. And probably would love to
> have SW control over the dpll.
> 
> Lets assume following simplified example:
> input1 +-------------+ output1
> -------|             |---------
>         |  DPLL 1     |
> input2 |             | output2
> -------|             |---------
>         +-------------+
> where:
> - input1 is external 10MHz with 25/75 Embedded PPS enabled,
> - input2 is a fallback PPS from GNSS
> user expects:
> - output1 as a 10MHz with embedded sync
> - output2 as a PPS
> As long as input1 is selected source, output1 is synchonized with it and
> output2 ticks are synchronized with ePPS.
> Now the user selects input2 as a source, where outputs are unchanged,
> both output2 and output1-ePPS are synchronized with input2, and output1
> 10MHz must be generated by DPLL.
> 
> I am trying to show example of what DPLL user might want to configure, this
> would be a separated configuration of ePPS/ePP2S/eSync per source as well as
> per output.
> Also a DPLL itself can have explicitly disabled embedded signal processing on
> its sources.
>

Thank you for the explanation. Looks like we will need several attributes to 
configure inputs/outputs. And this way can also answer some questions from 
Jonathan regarding support of different specific features of hardware. I'm in 
process of finding an interface to implement it, if you have any suggestions, 
please share it.

>>
>>> - add phase delay
>>> - configure frequency (user might need to use source/output with different
>>>     frequency then 1 PPS or 10MHz)
>>
>> Providing these modes I was thinking about the most common and widely used
>> signals in measurement equipment. So my point here is that both 1PPS and 10MHz
>> should stay as is, but another type of signal should be added, let's say
>> CUSTOM_FREQ, which will also consider special attribute in netlink terms. is it ok?
> 
> Sure, makes sense.
> 
>>
>>> Generally, for simple DPLL designs this interface could do the job (although,
>>> I still think user needs more information about the sources/outputs), but for
>>> more complex ones, there should be something different, which takes care of my
>>> comments regarding extra configuration needed.
>>>
>>
>> As I already mentioned earlier, I'm open for improvements and happy to
>> collaborate to cover other use cases of this subsystem from the very beginning
>> of development. We can even create an open github repo to share implementation
>> details together with comments if it works better for you.
>>
> 
> Sure, great! I am happy to help.
> I could start working on a part for extra DPLL modes and source-priorities as
> automatic mode doesn't make sense without them.
> 
> Thank you,
> Arkadiusz
> 

Please, take a look at RFC v2, I tried to address some of the comments.

Thanks,
Vadim
