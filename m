Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50C3575801
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 01:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbiGNXX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 19:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiGNXX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 19:23:57 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEA1FD34;
        Thu, 14 Jul 2022 16:23:54 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 4E8A05005CD;
        Fri, 15 Jul 2022 02:21:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 4E8A05005CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1657840917; bh=V+C4gr9CbiPEj9A3ITjBgPtVbOKHC75ezm7u6Ioo5lo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=g6A+7Iv7VJCX3oekrjGWKzQ2OX/uUCPjzOa98B8QatzUMBzuSOKc0ZOgISy1Y9HWP
         XAtK2mguDC/qH32gQ5MZod/p/irXmvc+6wTuKDod/XAPTOdN+r6ltZwjEQsJAsVUbr
         50CpmCHZyzLHvi/8Gsto+oN1J9iy9jZsMNTvPCQ8=
Message-ID: <46554eb0-e7ff-09e5-6a39-5d7545387677@novek.ru>
Date:   Fri, 15 Jul 2022 00:23:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 1/3] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-2-vfedorenko@novek.ru>
 <DM6PR11MB4657460B855863E76EBB6BCD9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <DM6PR11MB4657460B855863E76EBB6BCD9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
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

On 11.07.2022 10:01, Kubalewski, Arkadiusz wrote:
> -----Original Message-----
> From: Vadim Fedorenko <vfedorenko@novek.ru>
> Sent: Sunday, June 26, 2022 9:25 PM
>>
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> DPLL framework is used to represent and configure DPLL devices
>> in systems. Each device that has DPLL and can configure sources
>> and outputs can use this framework.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
> 
> Hi Vadim,
> I've been trying to implement usage of this code in our driver.
> Any chance for some testing/example app?
> 

Hi Arkadiusz,
Sorry, but I don't have any working app yet, this subsystem is
treated as experimental and as we now have different interface
for configuring features we need, app implementation is postponed
a bit. After some conversation with Jakub I'm thinking about library
to provide easy interface to this subsystem, but stil no code yet.

>> +struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int sources_count,
>> +					 int outputs_count, void *priv)
> 
> Aren't there some alignment issues around function definitions?
>

Yeah, I know about some style issues, trying to fix them for the next round.

>> +{
>> +	struct dpll_device *dpll;
>> +	int ret;
>> +
>> +	dpll = kzalloc(sizeof(*dpll), GFP_KERNEL);
>> +	if (!dpll)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	mutex_init(&dpll->lock);
>> +	dpll->ops = ops;
>> +	dpll->dev.class = &dpll_class;
>> +	dpll->sources_count = sources_count;
>> +	dpll->outputs_count = outputs_count;
>> +
>> +	mutex_lock(&dpll_device_xa_lock);
>> +	ret = xa_alloc(&dpll_device_xa, &dpll->id, dpll, xa_limit_16b, GFP_KERNEL);
>> +	if (ret)
>> +		goto error;
>> +	dev_set_name(&dpll->dev, "dpll%d", dpll->id);
> 
> Not sure if I mentioned it before, the user must be able to identify the
> purpose and origin of dpll. Right now, if 2 dplls register in the system, it is
> not possible to determine where they belong or what do they do. I would say,
> easiest to let caller of dpll_device_alloc assign some name or description.
>

Maybe driver can export information about dpll device name after registering it?
But at the same time looks like it's easy enough to implement custom naming. The
only problem is to control that names are unique.

>> +	mutex_unlock(&dpll_device_xa_lock);
>> +	dpll->priv = priv;
>> +
>> +	return dpll;
>> +
>> +error:
>> +	mutex_unlock(&dpll_device_xa_lock);
>> +	kfree(dpll);
>> +	return ERR_PTR(ret);
>> +}
>> +EXPORT_SYMBOL_GPL(dpll_device_alloc);
>> +
>> +void dpll_device_free(struct dpll_device *dpll)
>> +{
>> +	if (!dpll)
>> +		return;
>> +
>> +	mutex_destroy(&dpll->lock);
>> +	kfree(dpll);
>> +}
> 
> dpll_device_free() is defined in header, shouldn't it be exported?
> 

yeah, definitely. Already changed in new draft.

>> +
>> +void dpll_device_register(struct dpll_device *dpll)
>> +{
>> +	ASSERT_DPLL_NOT_REGISTERED(dpll);
>> +
>> +	mutex_lock(&dpll_device_xa_lock);
>> +	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
>> +	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
> 
> dpll_notify_device_create is not yet defined, this is part of patch 2/3?
> Also in patch 2/3 similar call was added in dpll_device_alloc().
>

Ah. Yes, there was some mess with patches, looks like I missed this thing, thank
you for pointing it.


>> +static const struct genl_ops dpll_genl_ops[] = {
>> +	{
>> +		.cmd	= DPLL_CMD_DEVICE_GET,
>> +		.start	= dpll_genl_cmd_start,
>> +		.dumpit	= dpll_genl_cmd_dumpit,
>> +		.doit	= dpll_genl_cmd_doit,
>> +		.policy	= dpll_genl_get_policy,
>> +		.maxattr = ARRAY_SIZE(dpll_genl_get_policy) - 1,
>> +	},
> 
> I wouldn't leave non-privileged user with possibility to call any HW requests.
>

Yep, definitely. Didn't thought about security restrictions yet.


>> +/* Commands supported by the dpll_genl_family */
>> +enum dpll_genl_cmd {
>> +	DPLL_CMD_UNSPEC,
>> +	DPLL_CMD_DEVICE_GET,	/* List of DPLL devices id */
>> +	DPLL_CMD_SET_SOURCE_TYPE,	/* Set the DPLL device source type */
>> +	DPLL_CMD_SET_OUTPUT_TYPE,	/* Set the DPLL device output type */
> 
> This week, I am going to prepare the patch for DPLL mode and input priority list
> we have discussed on the previous patch series.
>

Great! Do you have this work somewhere in public git? If not I will try to 
publish this branch somewhere to make collaboration easier.

> Thank you!
> Arkadiusz
> 
>> +
>> +	__DPLL_CMD_MAX,
>> +};
>> +#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
>> +
>> +#endif /* _UAPI_LINUX_DPLL_H */
>> -- 
>> 2.27.0
>>

