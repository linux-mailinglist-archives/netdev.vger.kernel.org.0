Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA87F5FBCC9
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJKVY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJKVY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:24:28 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D429AFB0;
        Tue, 11 Oct 2022 14:24:15 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 23DD5504E7D;
        Wed, 12 Oct 2022 00:20:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 23DD5504E7D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665523214; bh=MDibX3QnpCj3TqB4AtZu19h+sj0Jd8FGbcjUg0y2xHQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=z2emdgMVpRFlkMn7I1aqv3GhS82HrAQJJXUNNEQfo0hfVpMWHpYaV40yJmezRK7dj
         Ac3XE+4iHGo4PNzD54rf9M2cjExCGolK33jZNNI/dc81iHFMLwTp2tMAPyivJAPq5g
         Ya3OrBUEX67uKunhcLT2JTktAR9UK9qUWOYW4+Ec=
Message-ID: <576aaccb-991e-ea77-e27a-b9f640c49292@novek.ru>
Date:   Tue, 11 Oct 2022 22:23:38 +0100
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
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <Y0UqFml6tEdFt0rj@nanopsycho>
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

On 11.10.2022 09:32, Jiri Pirko wrote:
> Mon, Oct 10, 2022 at 09:54:26PM CEST, vfedorenko@novek.ru wrote:
>> On 10.10.2022 10:18, Jiri Pirko wrote:
>>> Mon, Oct 10, 2022 at 03:17:59AM CEST, vfedorenko@novek.ru wrote:
>>>> From: Vadim Fedorenko <vadfed@fb.com>
>>>>
>>>> DPLL framework is used to represent and configure DPLL devices
>>>> in systems. Each device that has DPLL and can configure sources
>>>> and outputs can use this framework.
>>>>
>>>> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>>>> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
>>>> Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>>> ---

[...]

>>>> +static int __dpll_cmd_device_dump_one(struct dpll_device *dpll,
>>>> +					   struct sk_buff *msg)
>>>> +{
>>>> +	if (nla_put_u32(msg, DPLLA_DEVICE_ID, dpll->id))
>>>> +		return -EMSGSIZE;
>>>> +
>>>> +	if (nla_put_string(msg, DPLLA_DEVICE_NAME, dev_name(&dpll->dev)))
>>>> +		return -EMSGSIZE;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
>>>> +					   struct sk_buff *msg)
>>>> +{
>>>> +	struct nlattr *src_attr;
>>>> +	int i, ret = 0, type;
>>>> +
>>>> +	for (i = 0; i < dpll->sources_count; i++) {
>>>> +		src_attr = nla_nest_start(msg, DPLLA_SOURCE);
>>>> +		if (!src_attr) {
>>>> +			ret = -EMSGSIZE;
>>>> +			break;
>>>> +		}
>>>> +		type = dpll->ops->get_source_type(dpll, i);
>>>> +		if (nla_put_u32(msg, DPLLA_SOURCE_ID, i) ||
>>>> +		    nla_put_u32(msg, DPLLA_SOURCE_TYPE, type)) {
>>>> +			nla_nest_cancel(msg, src_attr);
>>>> +			ret = -EMSGSIZE;
>>>> +			break;
>>>> +		}
>>>> +		if (dpll->ops->get_source_supported) {
>>>> +			for (type = 0; type <= DPLL_TYPE_MAX; type++) {
>>>> +				ret = dpll->ops->get_source_supported(dpll, i, type);
>>>
>>> Okay, this looks weird to me. This implicates that it is possible to
>>> have for example:
>>> source index 0 of type 10
>>> source index 0 of type 11
>>> Both possible.
>>>
>>> However, from how I understand this, each source if of certain fixed type.
>>> Either it is:
>>> SyncE port
>>> 1pps external input (SMA)
>>> 10MHZ external input (SMA)
>>> internal oscilator (free-running)
>>> GNSS (GPS)
>>>
>>> So for example:
>>> index 0, type: 1pps external input (SMA)
>>> index 1, type: 10MHZ external input (
>>> index 2, type: SyncE port, netdev ifindex: 20
>>> index 3, type: SyncE port, netdev ifindex: 30
>>>
>>> So 4 "source" objects, each of different type.
>>> In this case I can imagine that the netlink API might look something
>>> like:
>>> -> DPLL_CMD_SOURCE_GET - dump
>>>        ATTR_DEVICE_ID X
>>>
>>> <- DPLL_CMD_SOURCE_GET
>>>
>>>        ATTR_DEVICE_ID X
>>>        ATTR_SOURCE_INDEX 0
>>>        ATTR_SOURCE_TYPE EXT_1PPS
>>>        ATTR_DEVICE_ID X
>>>        ATTR_SOURCE_INDEX 1
>>>        ATTR_SOURCE_TYPE EXT_10MHZ
>>>        ATTR_DEVICE_ID X
>>>        ATTR_SOURCE_INDEX 2
>>>        ATTR_SOURCE_TYPE SYNCE_ETH_PORT
>>>        ATTR_SOURCE_NETDEV_IFINDEX 20
>>>
>>>        ATTR_DEVICE_ID X
>>>        ATTR_SOURCE_INDEX 3
>>>        ATTR_SOURCE_TYPE SYNCE_ETH_PORT
>>>        ATTR_SOURCE_NETDEV_IFINDEX 30
>>>
>>> You see kernel would dump 4 source objects.
>>>
>> I see your point. We do have hardware which allows changing type of SMA
>> connector, and even the direction, each SMA could be used as input/source or
>> output of different signals. But there are limitation, like not all SMAs can
>> produce IRIG-B signal or only some of them can be used to get GNSS 1PPS. The
> 
> Okay, so that is not the *type* of source, but rather attribute of it.
> Example:
> 
> $ dpll X show
> index 0
>    type EXT
>    signal 1PPS
>    supported_signals
>       1PPS 10MHz
> 
> $ dpll X set source index 1 signal_type 10MHz
> $ dpll X show
> index 0
>    type EXT
>    signal 10MHz
>    supported_signals
>       1PPS 10MHz
> 
> So one source with index 0 of type "EXT" (could be "SMA", does not
> matter) supports 1 signal types.
> 
> 
> Thinking about this more and to cover the case when one SMA could be
> potencially used for input and output. It already occured to me that
> source/output are quite similar, have similar/same attributes. What if
> they are merged together to say a "pin" object only with extra
> PERSONALITY attribute?
> 
> Example:
> 
> -> DPLL_CMD_PIN_GET - dump
>        ATTR_DEVICE_ID X
> 
> <- DPLL_CMD_PIN_GET
> 
>         ATTR_DEVICE_ID X
>         ATTR_PIN_INDEX 0
>         ATTR_PIN_TYPE EXT
>         ATTR_PIN_SIGNAL 1PPS   (selected signal)
>         ATTR_PIN_SUPPORTED_SIGNALS (nest)
>           ATTR_PIN_SIGNAL 1PPS
>           ATTR_PIN_SIGNAL 10MHZ
>         ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>           ATTR_PIN_PERSONALITY DISCONNECTED
>           ATTR_PIN_PERSONALITY INPUT
>           ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
> 					  output)
> 
>         ATTR_DEVICE_ID X
>         ATTR_PIN_INDEX 1
>         ATTR_PIN_TYPE EXT
>         ATTR_PIN_SIGNAL 10MHz   (selected signal)
>         ATTR_PIN_SUPPORTED_SIGNALS (nest)
>           ATTR_PIN_SIGNAL 1PPS
>           ATTR_PIN_SIGNAL 10MHZ
>         ATTR_PIN_PERSONALITY DISCONNECTED   (selected personality - not
> 					    connected currently)
>         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>           ATTR_PIN_PERSONALITY DISCONNECTED
>           ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
> 
>         ATTR_DEVICE_ID X
>         ATTR_PIN_INDEX 2
>         ATTR_PIN_TYPE GNSS
>         ATTR_PIN_SIGNAL 1PPS   (selected signal)
>         ATTR_PIN_SUPPORTED_SIGNALS (nest)
>           ATTR_PIN_SIGNAL 1PPS
>         ATTR_PIN_PERSONALITY INPUT   (selected personality - note this is
> 				     now he selected source, being only
> 				     pin with INPUT personality)
>         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>           ATTR_PIN_PERSONALITY DISCONNECTED
>           ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
> 
>         ATTR_DEVICE_ID X
>         ATTR_PIN_INDEX 3
>         ATTR_PIN_TYPE SYNCE_ETH_PORT
>         ATTR_PIN_NETDEV_IFINDEX 20
>         ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>           ATTR_PIN_PERSONALITY DISCONNECTED
>           ATTR_PIN_PERSONALITY INPUT
>           ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
> 					  output)
> 
>         ATTR_DEVICE_ID X
>         ATTR_PIN_INDEX 4
>         ATTR_PIN_TYPE SYNCE_ETH_PORT
>         ATTR_PIN_NETDEV_IFINDEX 30
>         ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>           ATTR_PIN_PERSONALITY DISCONNECTED
>           ATTR_PIN_PERSONALITY INPUT
>           ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
> 					  output)
> 
> 
> This allows the user to actually see the full picture:
> 1) all input/output pins in a single list, no duplicates
> 2) each pin if of certain type (ATTR_PIN_TYPE) EXT/GNSS/SYNCE_ETH_PORT
> 3) the pins that can change signal type contain the selected and list of
>     supported signal types (ATTR_PIN_SIGNAL, ATTR_PIN_SUPPORTED_SIGNALS)
> 4) direction/connection of the pin to the DPLL is exposed over
>     ATTR_PIN_PERSONALITY. For each pin, the driver would expose it can
>     act as INPUT/OUTPUT and even more, it can indicate the pin can
>     disconnect from DPLL entirely (if possible).
> 5) user can select the source by setting ATTR_PIN_PERSONALITY of certain
>     pin to INPUT. Only one pin could be set to INPUT and that is the
>     souce of DPLL.
>     In case no pin have personality set to INPUT, the DPLL is
>     free-running.
> 
> This would introduce quite nice flexibility, exposes source/output
> capabilities and provides good visilibity of current configuration.
> 

My comments about this part are in the answer to the next message

> 
>> interface was created to cover such case. I believe we have to improve it to
>> cover SyncE configuration better, but I personally don't have SyncE hardware
>> ready to test and that's why I have to rely on suggestions from yours or
>> Arkadiusz's experience. From what I can see now there is need for special
>> attribute to link source to net device, and I'm happy to add it. In case of
>> fixed configuration of sources, the device should provide only one type as
>> supported and that's it.
>>
>>
>>>
>>>
>>>> +				if (ret && nla_put_u32(msg, DPLLA_SOURCE_SUPPORTED, type)) {
>>>> +					ret = -EMSGSIZE;
>>>> +					break;
>>>> +				}
>>>> +			}
>>>> +			ret = 0;
>>>> +		}
>>>> +		nla_nest_end(msg, src_attr);
>>>> +	}
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
>>>> +					   struct sk_buff *msg)
>>>> +{
>>>> +	struct nlattr *out_attr;
>>>> +	int i, ret = 0, type;
>>>> +
>>>> +	for (i = 0; i < dpll->outputs_count; i++) {
>>>> +		out_attr = nla_nest_start(msg, DPLLA_OUTPUT);
>>>> +		if (!out_attr) {
>>>> +			ret = -EMSGSIZE;
>>>> +			break;
>>>> +		}
>>>> +		type = dpll->ops->get_output_type(dpll, i);
>>>> +		if (nla_put_u32(msg, DPLLA_OUTPUT_ID, i) ||
>>>> +		    nla_put_u32(msg, DPLLA_OUTPUT_TYPE, type)) {
>>>> +			nla_nest_cancel(msg, out_attr);
>>>> +			ret = -EMSGSIZE;
>>>> +			break;
>>>> +		}
>>>> +		if (dpll->ops->get_output_supported) {
>>>> +			for (type = 0; type <= DPLL_TYPE_MAX; type++) {
>>>> +				ret = dpll->ops->get_output_supported(dpll, i, type);
>>>> +				if (ret && nla_put_u32(msg, DPLLA_OUTPUT_SUPPORTED, type)) {
>>>
>>> This I believe is similar to sources, see my comment above.
>>>
>> As I said, we have to cover the case when SMAs are flexible to configure.
>>
>>> I believe we should have separate commands to GET and SET outputs and
>>> sources. That would make the object separation clear and will also help
>>> event model. See below I suggestion how output netlink API may look
>>> like (comment in header file near enum dpll_genl_cmd definition).
>>>
>>>
>>>> +					ret = -EMSGSIZE;
>>>> +					break;
>>>> +				}
>>>> +			}
>>>> +			ret = 0;
>>>> +		}
>>>> +		nla_nest_end(msg, out_attr);
>>>> +	}
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int __dpll_cmd_dump_status(struct dpll_device *dpll,
>>>> +					   struct sk_buff *msg)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	if (dpll->ops->get_status) {
>>>> +		ret = dpll->ops->get_status(dpll);
>>>> +		if (nla_put_u32(msg, DPLLA_STATUS, ret))
>>>> +			return -EMSGSIZE;
>>>> +	}
>>>> +
>>>> +	if (dpll->ops->get_temp) {
>>>> +		ret = dpll->ops->get_temp(dpll);
>>>> +		if (nla_put_u32(msg, DPLLA_TEMP, ret))
>>>> +			return -EMSGSIZE;
>>>> +	}
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
>>>> +static int
>>>> +dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff *msg,
>>>> +		     u32 portid, u32 seq, int flags)
>>>> +{
>>>> +	struct nlattr *hdr;
>>>> +	int ret;
>>>> +
>>>> +	hdr = genlmsg_put(msg, portid, seq, &dpll_gnl_family, 0,
>>>> +			  DPLL_CMD_DEVICE_GET);
>>>> +	if (!hdr)
>>>> +		return -EMSGSIZE;
>>>> +
>>>> +	mutex_lock(&dpll->lock);
>>>> +	ret = __dpll_cmd_device_dump_one(dpll, msg);
>>>> +	if (ret)
>>>> +		goto out_unlock;
>>>> +
>>>> +	if (flags & DPLL_FLAG_SOURCES && dpll->ops->get_source_type) {
>>>> +		ret = __dpll_cmd_dump_sources(dpll, msg);
>>>> +		if (ret)
>>>> +			goto out_unlock;
>>>> +	}
>>>> +
>>>> +	if (flags & DPLL_FLAG_OUTPUTS && dpll->ops->get_output_type) {
>>>> +		ret = __dpll_cmd_dump_outputs(dpll, msg);
>>>> +		if (ret)
>>>> +			goto out_unlock;
>>>> +	}
>>>> +
>>>> +	if (flags & DPLL_FLAG_STATUS) {
>>>> +		ret = __dpll_cmd_dump_status(dpll, msg);
>>>> +		if (ret)
>>>> +			goto out_unlock;
>>>> +	}
>>>> +	mutex_unlock(&dpll->lock);
>>>> +	genlmsg_end(msg, hdr);
>>>> +
>>>> +	return 0;
>>>> +
>>>> +out_unlock:
>>>> +	mutex_unlock(&dpll->lock);
>>>> +	genlmsg_cancel(msg, hdr);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int dpll_genl_cmd_set_source(struct sk_buff *skb, struct genl_info *info)
>>>> +{
>>>> +	struct dpll_device *dpll = info->user_ptr[0];
>>>> +	struct nlattr **attrs = info->attrs;
>>>> +	int ret = 0, src_id, type;
>>>
>>> Enums.
>>>
>>
>> Sure.
>>
>>>> +
>>>> +	if (!attrs[DPLLA_SOURCE_ID] ||
>>>> +	    !attrs[DPLLA_SOURCE_TYPE])
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (!dpll->ops->set_source_type)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>> +	src_id = nla_get_u32(attrs[DPLLA_SOURCE_ID]);
>>>> +	type = nla_get_u32(attrs[DPLLA_SOURCE_TYPE]);
>>>
>>>
>>> This looks odd to me. The user should just pass the index of source to
>>> select. Type should be static, and non-changeable.
>>>
>>>
>>>> +
>>>> +	mutex_lock(&dpll->lock);
>>>> +	ret = dpll->ops->set_source_type(dpll, src_id, type);
>>>> +	mutex_unlock(&dpll->lock);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int dpll_genl_cmd_set_output(struct sk_buff *skb, struct genl_info *info)
>>>> +{
>>>> +	struct dpll_device *dpll = info->user_ptr[0];
>>>> +	struct nlattr **attrs = info->attrs;
>>>> +	int ret = 0, out_id, type;
>>>
>>> Enums.
>>>
>>>
>>>> +
>>>> +	if (!attrs[DPLLA_OUTPUT_ID] ||
>>>> +	    !attrs[DPLLA_OUTPUT_TYPE])
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (!dpll->ops->set_output_type)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>> +	out_id = nla_get_u32(attrs[DPLLA_OUTPUT_ID]);
>>>> +	type = nla_get_u32(attrs[DPLLA_OUTPUT_TYPE]);
>>>
>>> Same here, passing type here looks wrong.
>>>
>>>
>>>
>>>> +
>>>> +	mutex_lock(&dpll->lock);
>>>> +	ret = dpll->ops->set_output_type(dpll, out_id, type);
>>>> +	mutex_unlock(&dpll->lock);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int dpll_device_loop_cb(struct dpll_device *dpll, void *data)
>>>> +{
>>>> +	struct dpll_dump_ctx *ctx;
>>>> +	struct param *p = (struct param *)data;
>>>> +
>>>> +	ctx = dpll_dump_context(p->cb);
>>>> +
>>>> +	ctx->pos_idx = dpll->id;
>>>> +
>>>> +	return dpll_device_dump_one(dpll, p->msg, 0, 0, ctx->flags);
>>>> +}
>>>> +
>>>> +static int
>>>> +dpll_cmd_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>>> +{
>>>> +	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>>>> +	struct param p = { .cb = cb, .msg = skb };
>>>> +
>>>> +	return for_each_dpll_device(ctx->pos_idx, dpll_device_loop_cb, &p);
>>>> +}
>>>> +
>>>> +static int
>>>> +dpll_genl_cmd_device_get_id(struct sk_buff *skb, struct genl_info *info)
>>>
>>> Just "get", no "id" here.
>>>
>>
>> Got it.
>>
>>>
>>>> +{
>>>> +	struct dpll_device *dpll = info->user_ptr[0];
>>>> +	struct nlattr **attrs = info->attrs;
>>>> +	struct sk_buff *msg;
>>>> +	int flags = 0;
>>>> +	int ret;
>>>> +
>>>> +	if (attrs[DPLLA_FLAGS])
>>>> +		flags = nla_get_u32(attrs[DPLLA_FLAGS]);
>>>> +
>>>> +	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>>> +	if (!msg)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	ret = dpll_device_dump_one(dpll, msg, info->snd_portid, info->snd_seq,
>>>> +				   flags);
>>>> +	if (ret)
>>>> +		goto out_free_msg;
>>>> +
>>>> +	return genlmsg_reply(msg, info);
>>>> +
>>>> +out_free_msg:
>>>> +	nlmsg_free(msg);
>>>> +	return ret;
>>>> +
>>>> +}
>>>> +
>>>> +static int dpll_genl_cmd_start(struct netlink_callback *cb)
>>>> +{
>>>> +	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
>>>> +	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
>>>> +
>>>> +	ctx->dev = NULL;
>>>> +	if (info->attrs[DPLLA_FLAGS])
>>>> +		ctx->flags = nla_get_u32(info->attrs[DPLLA_FLAGS]);
>>>> +	else
>>>> +		ctx->flags = 0;
>>>> +	ctx->pos_idx = 0;
>>>> +	ctx->pos_src_idx = 0;
>>>> +	ctx->pos_out_idx = 0;
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int dpll_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
>>>> +						 struct genl_info *info)
>>>> +{
>>>> +	struct dpll_device *dpll_id = NULL, *dpll_name = NULL;
>>>> +
>>>> +	if (!info->attrs[DPLLA_DEVICE_ID] &&
>>>> +	    !info->attrs[DPLLA_DEVICE_NAME])
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (info->attrs[DPLLA_DEVICE_ID]) {
>>>> +		u32 id = nla_get_u32(info->attrs[DPLLA_DEVICE_ID]);
>>>> +
>>>> +		dpll_id = dpll_device_get_by_id(id);
>>>> +		if (!dpll_id)
>>>> +			return -ENODEV;
>>>> +		info->user_ptr[0] = dpll_id;
>>>
>>> struct dpll_device *dpll should be stored here.
>>>
>>>
>>>> +	}
>>>> +	if (info->attrs[DPLLA_DEVICE_NAME]) {
>>>
>>> You define new API, have one clear handle for devices. Either name or
>>> ID. Having both is messy.
>>>
>> That was added after the discussion with Jakub and Arkadiusz where we agreed
>> that the device could be referenced either by index or by name. The example
>> is that userspace app can easily find specific DPLL device if it knows the
>> name provided by a driver of that specific device. Without searching through
>> sysfs to find index value. Later commands could be executed using index once
>> it's known through CMD_GET_DEVICE/ATTR_DEVICE_NAME.
> 
> What exacly is the name? What is the semantics? How the name is
> generated in case of multiple instances of the same driver. What happens
> if two drivers use the same name? Is the name predictable (in sense of
> "stable over reboots")?
>

The way we were thinking about name is that driver can provide it's own name 
based on the hardware values, like MAC address or any other unique identifier, 
or the subsystem will use 'dpll%d' template to create the device. In the first 
case names can be predictable and stable over reboots at the same time.

> 
>>>
>>>> +		const char *name = nla_data(info->attrs[DPLLA_DEVICE_NAME]);
>>>> +
>>>> +		dpll_name = dpll_device_get_by_name(name);
>>>> +		if (!dpll_name)
>>>> +			return -ENODEV;
>>>> +
>>>> +		if (dpll_id && dpll_name != dpll_id)
>>>> +			return -EINVAL;
>>>> +		info->user_ptr[0] = dpll_name;
>>>
>>> struct dpll_device *dpll should be stored here.
>>>
>>
>>
>> Didn't get you, where should we store it?
>> dpll_name and dpll_id are of type struct dpll_device*,
> 
> Ah sorry, you confused me with the "name"/"id" suffix. Why you don't
> have just one variable called "dpll" instead and have the check for both
> attrs being set at the beginning? Also, extack error message would be
> nice (not only here).
> 

Yeah, I will re-think that part, it definitely needs improvement.

> 
>> and they are compared to avoid situation when both index and name are
>> provided, but refer to different devices.
>>
>>>
>>>
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static const struct genl_ops dpll_genl_ops[] = {
>>>> +	{
>>>> +		.cmd	= DPLL_CMD_DEVICE_GET,
>>>> +		.flags  = GENL_UNS_ADMIN_PERM,
>>>> +		.start	= dpll_genl_cmd_start,
>>>> +		.dumpit	= dpll_cmd_device_dump,
>>>> +		.doit	= dpll_genl_cmd_device_get_id,
>>>> +		.policy	= dpll_genl_get_policy,
>>>> +		.maxattr = ARRAY_SIZE(dpll_genl_get_policy) - 1,
>>>> +	},
>>>> +	{
>>>> +		.cmd	= DPLL_CMD_SET_SOURCE_TYPE,
>>>> +		.flags	= GENL_UNS_ADMIN_PERM,
>>>> +		.doit	= dpll_genl_cmd_set_source,
>>>> +		.policy	= dpll_genl_set_source_policy,
>>>> +		.maxattr = ARRAY_SIZE(dpll_genl_set_source_policy) - 1,
>>>> +	},
>>>> +	{
>>>> +		.cmd	= DPLL_CMD_SET_OUTPUT_TYPE,
>>>> +		.flags	= GENL_UNS_ADMIN_PERM,
>>>> +		.doit	= dpll_genl_cmd_set_output,
>>>> +		.policy	= dpll_genl_set_output_policy,
>>>> +		.maxattr = ARRAY_SIZE(dpll_genl_set_output_policy) - 1,
>>>> +	},
>>>> +};
>>>> +
>>>> +static struct genl_family dpll_gnl_family __ro_after_init = {
>>>> +	.hdrsize	= 0,
>>>> +	.name		= DPLL_FAMILY_NAME,
>>>> +	.version	= DPLL_VERSION,
>>>> +	.ops		= dpll_genl_ops,
>>>> +	.n_ops		= ARRAY_SIZE(dpll_genl_ops),
>>>> +	.mcgrps		= dpll_genl_mcgrps,
>>>> +	.n_mcgrps	= ARRAY_SIZE(dpll_genl_mcgrps),
>>>> +	.pre_doit	= dpll_pre_doit,
>>>
>>> Have  .parallel_ops   = true,
>>> You have dpll->lock, you don't need genl, to protect you.
>>>
>>
>> Yep, sure, thanks!
>>
>>>
>>>> +};
>>>> +
>>>> +int __init dpll_netlink_init(void)
>>>> +{
>>>> +	return genl_register_family(&dpll_gnl_family);
>>>> +}
>>>> +
>>>> +void dpll_netlink_finish(void)
>>>> +{
>>>> +	genl_unregister_family(&dpll_gnl_family);
>>>> +}
>>>> +
>>>> +void __exit dpll_netlink_fini(void)
>>>> +{
>>>> +	dpll_netlink_finish();
>>>> +}
>>>> diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>>>> new file mode 100644
>>>> index 000000000000..e2d100f59dd6
>>>> --- /dev/null
>>>> +++ b/drivers/dpll/dpll_netlink.h
>>>> @@ -0,0 +1,7 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>>> + */
>>>> +
>>>> +int __init dpll_netlink_init(void);
>>>> +void dpll_netlink_finish(void);
>>>> diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>>>> new file mode 100644
>>>> index 000000000000..9d49b19d03d9
>>>> --- /dev/null
>>>> +++ b/include/linux/dpll.h
>>>> @@ -0,0 +1,29 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>>> + */
>>>> +
>>>> +#ifndef __DPLL_H__
>>>> +#define __DPLL_H__
>>>> +
>>>> +struct dpll_device;
>>>> +
>>>> +struct dpll_device_ops {
>>>> +	int (*get_status)(struct dpll_device *dpll);
>>>> +	int (*get_temp)(struct dpll_device *dpll);
>>>> +	int (*get_lock_status)(struct dpll_device *dpll);
>>>> +	int (*get_source_type)(struct dpll_device *dpll, int id);
>>>> +	int (*get_source_supported)(struct dpll_device *dpll, int id, int type);
>>>> +	int (*get_output_type)(struct dpll_device *dpll, int id);
>>>> +	int (*get_output_supported)(struct dpll_device *dpll, int id, int type);
>>>> +	int (*set_source_type)(struct dpll_device *dpll, int id, int val);
>>>> +	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
>>>
>>> All int should be enums, when they are really enums. Makes things much
>>> nicer and easier to see what's what.
>>>
>> Yep, will update it.
>>>
>>>
>>>> +};
>>>> +
>>>> +struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
>>>> +				      int sources_count, int outputs_count, void *priv);
>>>> +void dpll_device_register(struct dpll_device *dpll);
>>>> +void dpll_device_unregister(struct dpll_device *dpll);
>>>> +void dpll_device_free(struct dpll_device *dpll);
>>>> +void *dpll_priv(struct dpll_device *dpll);
>>>> +#endif
>>>> diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>>>> new file mode 100644
>>>> index 000000000000..fcbea5a5e4d6
>>>> --- /dev/null
>>>> +++ b/include/uapi/linux/dpll.h
>>>> @@ -0,0 +1,101 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>>> +#ifndef _UAPI_LINUX_DPLL_H
>>>> +#define _UAPI_LINUX_DPLL_H
>>>> +
>>>> +#define DPLL_NAME_LENGTH	20
>>>> +
>>>> +/* Adding event notification support elements */
>>>> +#define DPLL_FAMILY_NAME		"dpll"
>>>> +#define DPLL_VERSION			0x01
>>>> +#define DPLL_CONFIG_DEVICE_GROUP_NAME  "config"
>>>> +#define DPLL_CONFIG_SOURCE_GROUP_NAME  "source"
>>>> +#define DPLL_CONFIG_OUTPUT_GROUP_NAME  "output"
>>>> +#define DPLL_MONITOR_GROUP_NAME        "monitor"
>>>
>>> What is exactly the reason for multiple multicast groups? Why you don't
>>> use one?
>>>
>> Yes, I agree, there is no need to use multiple groups and I will remove them
>> in the next version.
>>
>>>
>>>> +
>>>> +#define DPLL_FLAG_SOURCES	1
>>>> +#define DPLL_FLAG_OUTPUTS	2
>>>> +#define DPLL_FLAG_STATUS	4
>>>
>>> I think it is more common to use either 0x prefix or (1<<X) expression
>>> But I don't think these flags are needed at all, if you have per-object
>>> messages.
>>>
>>>
>>>> +
>>>> +/* Attributes of dpll_genl_family */
>>>> +enum dpll_genl_attr {
>>>
>>> I don't see need for "genl" here.
>>> Also, it is common to have consistency betwee enum name and members name.
>>> For example:
>>>
>>> enum dpll_attr {
>>> 	DPLL_ATTR_UNSPEC,
>>> 	DPLL_ATTR_DEVICE_ID,
>>>
>>> 	...
>>> }
>>> This applies to all enums in this file.
>>>
>> Got it, naming is always hard task. Will update all of them in the next version.
>>
>>>
>>>> +	DPLLA_UNSPEC,
>>>> +	DPLLA_DEVICE_ID,
>>>> +	DPLLA_DEVICE_NAME,
>>>> +	DPLLA_SOURCE,
>>>> +	DPLLA_SOURCE_ID,
>>>
>>> "ID" sounds a bit odd. I think "index" would be more suitable.
>>>
>> I just wanted to have shorter names to better fit 80 columns per line restrictions.
> 
> I think that ID has a bit different semantics. If "INDEX" is too long
> for you (not sure why), use "IDX" perhaps?
> 
> 
>>>
>>>> +	DPLLA_SOURCE_TYPE,
>>>> +	DPLLA_SOURCE_SUPPORTED,
>>>> +	DPLLA_OUTPUT,
>>>> +	DPLLA_OUTPUT_ID,
>>>> +	DPLLA_OUTPUT_TYPE,
>>>> +	DPLLA_OUTPUT_SUPPORTED,
>>>> +	DPLLA_STATUS,
>>>> +	DPLLA_TEMP,
>>>> +	DPLLA_LOCK_STATUS,
>>>> +	DPLLA_FLAGS,
>>>> +
>>>> +	__DPLLA_MAX,
>>>> +};
>>>> +#define DPLLA_MAX (__DPLLA_MAX - 1)
>>>> +
>>>> +/* DPLL status provides information of device status */
>>>> +enum dpll_genl_status {
>>>> +	DPLL_STATUS_NONE,
>>>> +	DPLL_STATUS_CALIBRATING,
>>>> +	DPLL_STATUS_LOCKED,
>>>> +
>>>> +	__DPLL_STATUS_MAX,
>>>> +};
>>>> +#define DPLL_STATUS_MAX (__DPLL_STATUS_MAX - 1)
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
>>>> +/* DPLL lock status provides information of source used to lock the device */
>>>> +enum dpll_genl_lock_status {
>>>> +	DPLL_LOCK_STATUS_UNLOCKED,
>>>> +	DPLL_LOCK_STATUS_EXT_1PPS,
>>>> +	DPLL_LOCK_STATUS_EXT_10MHZ,
>>>> +	DPLL_LOCK_STATUS_SYNCE,
>>>> +	DPLL_LOCK_STATUS_INT_OSCILLATOR,
>>>> +	DPLL_LOCK_STATUS_GNSS,
>>>
>>> I find it a bit odd and redundant to have lock status here as a separate
>>> enum. You have a souce selected (either autoselected or manualy
>>> selected). Then the status is either:
>>> "UNLOCKED"
>>> "LOCKED"
>>> "HOLDOVER"
>>>
>>> Or something similar. The point is, don't have the "source type" as a
>>> part of lock status.
>>>
>>
>> Yes, it's a very good idea, I was thinking about the same, but it didn't end
>> up in the code.
>>
>>>
>>>> +
>>>> +	__DPLL_LOCK_STATUS_MAX,
>>>> +};
>>>> +#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
>>>> +
>>>> +/* Events of dpll_genl_family */
>>>> +enum dpll_genl_event {
>>>> +	DPLL_EVENT_UNSPEC,
>>>> +	DPLL_EVENT_DEVICE_CREATE,		/* DPLL device creation */
>>>> +	DPLL_EVENT_DEVICE_DELETE,		/* DPLL device deletion */
>>>> +	DPLL_EVENT_STATUS_LOCKED,		/* DPLL device locked to source */
>>>> +	DPLL_EVENT_STATUS_UNLOCKED,	/* DPLL device freerun */
>>>
>>> Again, redundant I belive. There should be one event,
>>> inside the message there should be and ATTR of the lock state.
>>>
>>> Also, I believe there are 2 options:
>>> 1) follow the existing netlink models and have:
>>> DPLL_EVENT_DEVICE_NEW
>>>     - sent for new device
>>>     - sent for change with device
>>> DPLL_EVENT_DEVICE_DEL
>>>     - sent for removed device
>>> 2)
>>> DPLL_EVENT_DEVICE_NEW
>>>     - sent for new device
>>> DPLL_EVENT_DEVICE_DEL
>>>     - sent for removed device
>>> DPLL_EVENT_DEVICE_CHANGE
>>>     - sent for change with device
>>>
>>> Bot options work fine I belive. The point is, you don't want to have
>>> "cmd" per one attr change. Changed the device, attrs are passed in one
>>> message.
>>>
>>
>> I will try to change events this way, thanks.
>>
>>>
>>>
>>>> +	DPLL_EVENT_SOURCE_CHANGE,		/* DPLL device source changed */
>>>
>>> Similar here, source of device changed, should be just one attr in
>>> device message, see above.
>>>
>>
>> The WIP right now is going the way to have separate objects representing
>> pins, which could be used as source/output or even mux device. And the whole
>> part about sources and outputs is going to change. But I'll keep in mind that
>> suggestion while implementing this new way.
> 
> Yeah, see my suggestion about the pins above. Good to hear that we are
> in sync.
> 
> 
>>
>>>
>>>> +	DPLL_EVENT_OUTPUT_CHANGE,		/* DPLL device output changed */
>>>
>>>
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
>>>
>>> This is confusing, you select "source", not "type".
>>
>> As I said, we can have different types for one source.
> 
> Again, see above my comment suggesting to separate TYPE and SIGNAL.
> 
> 
> 
>>
>>>
>>> Please be consistent in naming:
>>> DPLL_CMD_*_GET/SET
>>
>> Sure
>>
>>>
>>> Also, to be consistend with other netlink interfaces, we don't need
>>> cmd per action, rather there should be OBJ_GET (can dump) and OBJ_SET
>>> commands, like this:
>>>      DPLL_CMD_DEVICE_GET (can dump all present devices)
>>>      	ATTR_SOURCE_SELECT_MODE (current one)
>>>      	ATTR_SOURCE_INDEX (currect one)
>>>      DPLL_CMD_DEVICE_SET
>>>      	ATTR_SOURCE_INDEX (to set)
>>>      DPLL_CMD_DEVICE_SET
>>>      	ATTR_SOURCE_SELECT_MODE (to set)
>>>
>>
>> I believe we have to provide all the possible (or suitable) attributes in SET
>> command too, to fully configure the source by one command only, right?
> 
> Yep.
> 
> 
>>
>> And I also think we have to provide special attribute to show which source is
>> actually used to sync to, like ATTR_CONNECTED.
> 
> Either that or it could be exposed by PERSONALITY set to INPUT of one of
> the pins. See my suggestion about pin personalities above.
> 
> 
>>
>>>
>>>> +	DPLL_CMD_SET_OUTPUT_TYPE,	/* Set the DPLL device output type */
>>>
>>> Similar to what I suggested for "source", we should
>>> enable to select the OUTPUT, the type should be static. Also instead,
>>> I belive we should have a list of outputs and basically just allow
>>> enable/disable individual outputs:
>>>      DPLL_CMD_OUTPUT_GET (can dump the list of available outputs)
>>> 	ATTR_ENABLED (or "CONNECTED" or whatever) of type bool
>>>      DPLL_CMD_OUTPUT_SET
>>> 	ATTR_ENABLED (or "CONNECTED" or whatever) of type bool
>>>
>>> This is suitable for SyncE for example, when you have multiple netdev ports
>>> that are connected as "outputs", you can enable exactly those you you want.
>>> Example:
>>> # To list the available outputs:
>>> -> DPLL_CMD_OUTPUT_GET - dump
>>>        ATTR_DEVICE_ID X
>>>
>>> <- DPLL_CMD_OUTPUT_GET
>>>        ATTR_DEVICE_ID X
>>>        ATTR_OUTPUT_INDEX 0
>>>        ATTR_OUTPUT_TYPE SYNCE_ETH_PORT
>>>        ATTR_OUTPUT_NETDEV_IFINDEX 20
>>>        ATTR_OUTPUT_ENABLED 0
>>>        ATTR_DEVICE_ID X
>>>        ATTR_OUTPUT_INDEX 1
>>>        ATTR_OUTPUT_TYPE SYNCE_ETH_PORT
>>>        ATTR_OUTPUT_NETDEV_IFINDEX 30
>>>        ATTR_OUTPUT_ENABLED 0
>>>
>>> # Now enable output with index 0
>>> -> DPLL_CMD_OUTPUT_SET
>>>        ATTR_DEVICE_ID X
>>>        ATTR_OUTPUT_INDEX 0
>>>        ATTR_OUTPUT_ENABLED 1
>>>
>> Well, in case when we have flexible outputs, we can provide this information
>> as special type, like DPLL_TYPE_DISABLED. Having other types configured on
>> the output will assume that the OUTPUT is enabled.
> 
> Either that or it could be configureg by setting the pin PERSONALITY
> set to DISCONNECTED See my suggestion about pin personalities above.
> 
> 
>>
>>>
>>>> +
>>>> +	__DPLL_CMD_MAX,
>>>> +};
>>>> +#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
>>>> +
>>>> +#endif /* _UAPI_LINUX_DPLL_H */
>>>> -- 
>>>> 2.27.0
>>>>
>>
>> Thanks for actionable feedback, I hope to prepare new version soon with all
>> the comments and suggestions addressed!
> 
> Thanks! Looking forward to it!
> 
>>
>>

