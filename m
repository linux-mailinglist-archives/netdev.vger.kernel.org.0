Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC45F01E2
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiI3AsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiI3AsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:48:17 -0400
X-Greylist: delayed 224 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Sep 2022 17:48:15 PDT
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90F02028AB;
        Thu, 29 Sep 2022 17:48:15 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 4D7D7500382;
        Fri, 30 Sep 2022 03:44:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 4D7D7500382
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1664498699; bh=A6CX7Yn7V4bWz53+BUtHi86gVDdx8o4EhwFuRHdHi0A=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=b+vXs5yOitWQmbABSEKqw8OQHeK4TV/EbxC9W/xx28WCk3huHsszrRPVWov8d5KjU
         jCDjlfWQy4fbnDEgYRRlQWeFdJXmTCL/9MvZMlI4i6ORc39ZjkZ1U3SvcyZB8U5EVS
         g6hzQF7CEvGYej3YUsrBupkmp7hMdaAdGu59pkag=
Message-ID: <15f1fb2d-35d1-918f-e7b2-6627718a179c@novek.ru>
Date:   Fri, 30 Sep 2022 01:48:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v2 2/3] dpll: add netlink events
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-3-vfedorenko@novek.ru> <YzWL0QpCYDEwtj5P@nanopsycho>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <YzWL0QpCYDEwtj5P@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.09.2022 13:13, Jiri Pirko wrote:
> Sun, Jun 26, 2022 at 09:24:43PM CEST, vfedorenko@novek.ru wrote:
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> Add netlink interface to enable notification of users about
>> events in DPLL framework. Part of this interface should be
>> used by drivers directly, i.e. lock status changes.
> 
> I don't get why this is a separate patch. I believe it should be
> squashed to the previous one, making it easier to review as a whole
> thing.
> 

I was trying to separate some functions to make review process a bit simplier.

> 
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>> ---
>> drivers/dpll/dpll_core.c    |   2 +
>> drivers/dpll/dpll_netlink.c | 141 ++++++++++++++++++++++++++++++++++++
>> drivers/dpll/dpll_netlink.h |   7 ++
>> 3 files changed, 150 insertions(+)
>>
>> diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>> index dc0330e3687d..387644aa910e 100644
>> --- a/drivers/dpll/dpll_core.c
>> +++ b/drivers/dpll/dpll_core.c
>> @@ -97,6 +97,8 @@ struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int sources_c
>> 	mutex_unlock(&dpll_device_xa_lock);
>> 	dpll->priv = priv;
>>
>> +	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
>> +
>> 	return dpll;
>>
>> error:
>> diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>> index e15106f30377..4b1684fcf41e 100644
>> --- a/drivers/dpll/dpll_netlink.c
>> +++ b/drivers/dpll/dpll_netlink.c
>> @@ -48,6 +48,8 @@ struct param {
>> 	int dpll_source_type;
>> 	int dpll_output_id;
>> 	int dpll_output_type;
>> +	int dpll_status;
>> +	const char *dpll_name;
>> };
>>
>> struct dpll_dump_ctx {
>> @@ -239,6 +241,8 @@ static int dpll_genl_cmd_set_source(struct param *p)
>> 	ret = dpll->ops->set_source_type(dpll, src_id, type);
>> 	mutex_unlock(&dpll->lock);
>>
>> +	dpll_notify_source_change(dpll->id, src_id, type);
>> +
>> 	return ret;
>> }
>>
>> @@ -262,6 +266,8 @@ static int dpll_genl_cmd_set_output(struct param *p)
>> 	ret = dpll->ops->set_source_type(dpll, out_id, type);
>> 	mutex_unlock(&dpll->lock);
>>
>> +	dpll_notify_source_change(dpll->id, out_id, type);
>> +
>> 	return ret;
>> }
>>
>> @@ -438,6 +444,141 @@ static struct genl_family dpll_gnl_family __ro_after_init = {
>> 	.pre_doit	= dpll_pre_doit,
>> };
>>
>> +static int dpll_event_device_create(struct param *p)
>> +{
>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>> +	    nla_put_string(p->msg, DPLLA_DEVICE_NAME, p->dpll_name))
>> +		return -EMSGSIZE;
>> +
>> +	return 0;
>> +}
>> +
>> +static int dpll_event_device_delete(struct param *p)
>> +{
>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id))
>> +		return -EMSGSIZE;
>> +
>> +	return 0;
>> +}
>> +
>> +static int dpll_event_status(struct param *p)
>> +{
>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>> +		nla_put_u32(p->msg, DPLLA_LOCK_STATUS, p->dpll_status))
>> +		return -EMSGSIZE;
>> +
>> +	return 0;
>> +}
>> +
>> +static int dpll_event_source_change(struct param *p)
>> +{
>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>> +	    nla_put_u32(p->msg, DPLLA_SOURCE_ID, p->dpll_source_id) ||
>> +		nla_put_u32(p->msg, DPLLA_SOURCE_TYPE, p->dpll_source_type))
>> +		return -EMSGSIZE;
>> +
>> +	return 0;
>> +}
>> +
>> +static int dpll_event_output_change(struct param *p)
>> +{
>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>> +	    nla_put_u32(p->msg, DPLLA_OUTPUT_ID, p->dpll_output_id) ||
>> +		nla_put_u32(p->msg, DPLLA_OUTPUT_TYPE, p->dpll_output_type))
>> +		return -EMSGSIZE;
>> +
>> +	return 0;
>> +}
>> +
>> +static cb_t event_cb[] = {
>> +	[DPLL_EVENT_DEVICE_CREATE]	= dpll_event_device_create,
>> +	[DPLL_EVENT_DEVICE_DELETE]	= dpll_event_device_delete,
>> +	[DPLL_EVENT_STATUS_LOCKED]	= dpll_event_status,
>> +	[DPLL_EVENT_STATUS_UNLOCKED]	= dpll_event_status,
>> +	[DPLL_EVENT_SOURCE_CHANGE]	= dpll_event_source_change,
>> +	[DPLL_EVENT_OUTPUT_CHANGE]	= dpll_event_output_change,
>> +};
>> +/*
>> + * Generic netlink DPLL event encoding
>> + */
>> +static int dpll_send_event(enum dpll_genl_event event,
>> +				   struct param *p)
> 
> "struct param". Can't you please maintain some namespace for
> function/struct names?
>
Ok, sure!
> 
>> +{
>> +	struct sk_buff *msg;
>> +	int ret = -EMSGSIZE;
>> +	void *hdr;
>> +
>> +	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		return -ENOMEM;
>> +	p->msg = msg;
>> +
>> +	hdr = genlmsg_put(msg, 0, 0, &dpll_gnl_family, 0, event);
>> +	if (!hdr)
>> +		goto out_free_msg;
>> +
>> +	ret = event_cb[event](p);
>> +	if (ret)
>> +		goto out_cancel_msg;
>> +
>> +	genlmsg_end(msg, hdr);
>> +
>> +	genlmsg_multicast(&dpll_gnl_family, msg, 0, 1, GFP_KERNEL);
>> +
>> +	return 0;
>> +
>> +out_cancel_msg:
>> +	genlmsg_cancel(msg, hdr);
>> +out_free_msg:
>> +	nlmsg_free(msg);
>> +
>> +	return ret;
>> +}
>> +
>> +int dpll_notify_device_create(int dpll_id, const char *name)
>> +{
>> +	struct param p = { .dpll_id = dpll_id, .dpll_name = name };
>> +
>> +	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
> 
> Just do that automatically in register() and avoid the need to rely on
> drivers to be so good to do it themselves. They won't.
> 
Yeah, the next version will have these changes.

> 
>> +}
>> +
>> +int dpll_notify_device_delete(int dpll_id)
>> +{
>> +	struct param p = { .dpll_id = dpll_id };
>> +
>> +	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
>> +}
>> +
>> +int dpll_notify_status_locked(int dpll_id)
> 
> For all notification functions called from the driver, please use struct
> dpll as an arg.

Will change it, thanks!

> 
>> +{
>> +	struct param p = { .dpll_id = dpll_id, .dpll_status = 1 };
>> +
>> +	return dpll_send_event(DPLL_EVENT_STATUS_LOCKED, &p);
>> +}
>> +
>> +int dpll_notify_status_unlocked(int dpll_id)
>> +{
>> +	struct param p = { .dpll_id = dpll_id, .dpll_status = 0 };
>> +
>> +	return dpll_send_event(DPLL_EVENT_STATUS_UNLOCKED, &p);
>> +}
>> +
>> +int dpll_notify_source_change(int dpll_id, int source_id, int source_type)
>> +{
>> +	struct param p =  { .dpll_id = dpll_id, .dpll_source_id = source_id,
>> +						.dpll_source_type = source_type };
>> +
>> +	return dpll_send_event(DPLL_EVENT_SOURCE_CHANGE, &p);
>> +}
>> +
>> +int dpll_notify_output_change(int dpll_id, int output_id, int output_type)
>> +{
>> +	struct param p =  { .dpll_id = dpll_id, .dpll_output_id = output_id,
>> +						.dpll_output_type = output_type };
>> +
>> +	return dpll_send_event(DPLL_EVENT_OUTPUT_CHANGE, &p);
>> +}
>> +
>> int __init dpll_netlink_init(void)
>> {
>> 	return genl_register_family(&dpll_gnl_family);
>> diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>> index e2d100f59dd6..0dc81320f982 100644
>> --- a/drivers/dpll/dpll_netlink.h
>> +++ b/drivers/dpll/dpll_netlink.h
>> @@ -3,5 +3,12 @@
>>   *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>   */
>>
>> +int dpll_notify_device_create(int dpll_id, const char *name);
>> +int dpll_notify_device_delete(int dpll_id);
>> +int dpll_notify_status_locked(int dpll_id);
>> +int dpll_notify_status_unlocked(int dpll_id);
>> +int dpll_notify_source_change(int dpll_id, int source_id, int source_type);
>> +int dpll_notify_output_change(int dpll_id, int output_id, int output_type);
> 
> Why these are not returning void? Does driver care about the return
> value? Why?
>
Yep, you are right, I will change to void because there is no reason to have a 
return value, thanks!

> 
>> +
>> int __init dpll_netlink_init(void);
>> void dpll_netlink_finish(void);
>> -- 
>> 2.27.0
>>

