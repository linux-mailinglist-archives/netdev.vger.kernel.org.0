Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC41588503
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 02:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiHCAFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 20:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiHCAFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 20:05:14 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1585282;
        Tue,  2 Aug 2022 17:05:10 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 9F2CE50058B;
        Wed,  3 Aug 2022 03:02:50 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 9F2CE50058B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1659484973; bh=wXopEasXpStqYyg48pjpKCvh19nePMQDtM3Atgyc6gI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZrUZUvvplYlGoTCWRBp3Qg9EegYgVM0nS5+e8U+3ltU0zAKXjtV4Whv/mg2FLW9gK
         XsoQVq8XdvoeivHu1Z4YlgoMYdRjitVuZyFYD5WQ9qvQrlPji9hIDZOSVEOurlU1lk
         D3ESOIj0dJ5j2LUpP4DEtbzbav5BaUC6NwAX6DFs=
Message-ID: <0bb71f1a-ba5e-5162-663b-1be32202231d@novek.ru>
Date:   Wed, 3 Aug 2022 01:05:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v2 2/3] dpll: add netlink events
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
 <20220626192444.29321-3-vfedorenko@novek.ru>
 <DM6PR11MB46573FA8D51D40DAD2AC060B9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
 <715d8f47-d246-6b4a-b22d-82672e8f11d8@novek.ru>
 <DM6PR11MB465732355816F30254FCFA9E9B8B9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <DM6PR11MB4657FADDDA75A5F35CF8FE3F9B9D9@DM6PR11MB4657.namprd11.prod.outlook.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <DM6PR11MB4657FADDDA75A5F35CF8FE3F9B9D9@DM6PR11MB4657.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.08.2022 15:02, Kubalewski, Arkadiusz wrote:
>> -----Original Message-----
>> From: Vadim Fedorenko <vfedorenko@novek.ru>
>> Sent: Friday, July 15, 2022 1:29 AM
>>>
>>> On 11.07.2022 10:02, Kubalewski, Arkadiusz wrote:
>>>> -----Original Message-----
>>>> From: Vadim Fedorenko <vfedorenko@novek.ru>
>>>> Sent: Sunday, June 26, 2022 9:25 PM
>>>>>
>>>>> From: Vadim Fedorenko <vadfed@fb.com>
>>>>>
>>>>> Add netlink interface to enable notification of users about
>>>>> events in DPLL framework. Part of this interface should be
>>>>> used by drivers directly, i.e. lock status changes.
>>>>>
>>>>> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>>>>> ---
>>>>> drivers/dpll/dpll_core.c    |   2 +
>>>>> drivers/dpll/dpll_netlink.c | 141 ++++++++++++++++++++++++++++++++++++
>>>>> drivers/dpll/dpll_netlink.h |   7 ++
>>>>> 3 files changed, 150 insertions(+)
>>>>>
>>>>> diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
>>>>> index dc0330e3687d..387644aa910e 100644
>>>>> --- a/drivers/dpll/dpll_core.c
>>>>> +++ b/drivers/dpll/dpll_core.c
>>>>> @@ -97,6 +97,8 @@ struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int sources_c
>>>>> 	mutex_unlock(&dpll_device_xa_lock);
>>>>> 	dpll->priv = priv;
>>>>>
>>>>> +	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
>>>>> +
>>>>> 	return dpll;
>>>>>
>>>>> error:
>>>>> diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>>>>> index e15106f30377..4b1684fcf41e 100644
>>>>> --- a/drivers/dpll/dpll_netlink.c
>>>>> +++ b/drivers/dpll/dpll_netlink.c
>>>>> @@ -48,6 +48,8 @@ struct param {
>>>>> 	int dpll_source_type;
>>>>> 	int dpll_output_id;
>>>>> 	int dpll_output_type;
>>>>> +	int dpll_status;
>>>>> +	const char *dpll_name;
>>>>> };
>>>>>
>>>>> struct dpll_dump_ctx {
>>>>> @@ -239,6 +241,8 @@ static int dpll_genl_cmd_set_source(struct param *p)
>>>>> 	ret = dpll->ops->set_source_type(dpll, src_id, type);
>>>>> 	mutex_unlock(&dpll->lock);
>>>>>
>>>>> +	dpll_notify_source_change(dpll->id, src_id, type);
>>>>> +
>>>>> 	return ret;
>>>>> }
>>>>>
>>>>> @@ -262,6 +266,8 @@ static int dpll_genl_cmd_set_output(struct param *p)
>>>>> 	ret = dpll->ops->set_source_type(dpll, out_id, type);
>>>>> 	mutex_unlock(&dpll->lock);
>>>>>
>>>>> +	dpll_notify_source_change(dpll->id, out_id, type);
>>>>> +
>>>>> 	return ret;
>>>>> }
>>>>>
>>>>> @@ -438,6 +444,141 @@ static struct genl_family dpll_gnl_family __ro_after_init = {
>>>>> 	.pre_doit	= dpll_pre_doit,
>>>>> };
>>>>>
>>>>> +static int dpll_event_device_create(struct param *p)
>>>>> +{
>>>>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>>>>> +	    nla_put_string(p->msg, DPLLA_DEVICE_NAME, p->dpll_name))
>>>>> +		return -EMSGSIZE;
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int dpll_event_device_delete(struct param *p)
>>>>> +{
>>>>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id))
>>>>> +		return -EMSGSIZE;
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int dpll_event_status(struct param *p)
>>>>> +{
>>>>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>>>>> +		nla_put_u32(p->msg, DPLLA_LOCK_STATUS, p->dpll_status))
>>>>> +		return -EMSGSIZE;
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int dpll_event_source_change(struct param *p)
>>>>> +{
>>>>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>>>>> +	    nla_put_u32(p->msg, DPLLA_SOURCE_ID, p->dpll_source_id) ||
>>>>> +		nla_put_u32(p->msg, DPLLA_SOURCE_TYPE, p->dpll_source_type))
>>>>> +		return -EMSGSIZE;
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int dpll_event_output_change(struct param *p)
>>>>> +{
>>>>> +	if (nla_put_u32(p->msg, DPLLA_DEVICE_ID, p->dpll_id) ||
>>>>> +	    nla_put_u32(p->msg, DPLLA_OUTPUT_ID, p->dpll_output_id) ||
>>>>> +		nla_put_u32(p->msg, DPLLA_OUTPUT_TYPE, p->dpll_output_type))
>>>>> +		return -EMSGSIZE;
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static cb_t event_cb[] = {
>>>>> +	[DPLL_EVENT_DEVICE_CREATE]	= dpll_event_device_create,
>>>>> +	[DPLL_EVENT_DEVICE_DELETE]	= dpll_event_device_delete,
>>>>> +	[DPLL_EVENT_STATUS_LOCKED]	= dpll_event_status,
>>>>> +	[DPLL_EVENT_STATUS_UNLOCKED]	= dpll_event_status,
>>>>> +	[DPLL_EVENT_SOURCE_CHANGE]	= dpll_event_source_change,
>>>>> +	[DPLL_EVENT_OUTPUT_CHANGE]	= dpll_event_output_change,
>>>>> +};
>>>>> +/*
>>>>> + * Generic netlink DPLL event encoding
>>>>> + */
>>>>> +static int dpll_send_event(enum dpll_genl_event event,
>>>>> +				   struct param *p)
>>>>> +{
>>>>> +	struct sk_buff *msg;
>>>>> +	int ret = -EMSGSIZE;
>>>>> +	void *hdr;
>>>>> +
>>>>> +	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>>>>> +	if (!msg)
>>>>> +		return -ENOMEM;
>>>>> +	p->msg = msg;
>>>>> +
>>>>> +	hdr = genlmsg_put(msg, 0, 0, &dpll_gnl_family, 0, event);
>>>>> +	if (!hdr)
>>>>> +		goto out_free_msg;
>>>>> +
>>>>> +	ret = event_cb[event](p);
>>>>> +	if (ret)
>>>>> +		goto out_cancel_msg;
>>>>> +
>>>>> +	genlmsg_end(msg, hdr);
>>>>> +
>>>>> +	genlmsg_multicast(&dpll_gnl_family, msg, 0, 1, GFP_KERNEL);
>>>>
>>>> All multicasts are send only for group "1" (DPLL_CONFIG_SOURCE_GROUP_NAME),
>>>> but 4 groups were defined.
>>>>
>>>
>>> Yes, you are right! Will update it in the next round.
>>>
>>>>> +
>>>>> +	return 0;
>>>>> +
>>>>> +out_cancel_msg:
>>>>> +	genlmsg_cancel(msg, hdr);
>>>>> +out_free_msg:
>>>>> +	nlmsg_free(msg);
>>>>> +
>>>>> +	return ret;
>>>>> +}
>>>>> +
>>>>> +int dpll_notify_device_create(int dpll_id, const char *name)
>>>>> +{
>>>>> +	struct param p = { .dpll_id = dpll_id, .dpll_name = name };
>>>>> +
>>>>> +	return dpll_send_event(DPLL_EVENT_DEVICE_CREATE, &p);
>>>>> +}
>>>>> +
>>>>> +int dpll_notify_device_delete(int dpll_id)
>>>>> +{
>>>>> +	struct param p = { .dpll_id = dpll_id };
>>>>> +
>>>>> +	return dpll_send_event(DPLL_EVENT_DEVICE_DELETE, &p);
>>>>> +}
>>>>> +
>>>>> +int dpll_notify_status_locked(int dpll_id)
>>>>> +{
>>>>> +	struct param p = { .dpll_id = dpll_id, .dpll_status = 1 };
>>>>> +
>>>>> +	return dpll_send_event(DPLL_EVENT_STATUS_LOCKED, &p);
>>>>> +}
>>>>> +
>>>>> +int dpll_notify_status_unlocked(int dpll_id)
>>>>> +{
>>>>> +	struct param p = { .dpll_id = dpll_id, .dpll_status = 0 };
>>>>> +
>>>>> +	return dpll_send_event(DPLL_EVENT_STATUS_UNLOCKED, &p);
>>>>> +}
>>>>> +
>>>>> +int dpll_notify_source_change(int dpll_id, int source_id, int source_type)
>>>>> +{
>>>>> +	struct param p =  { .dpll_id = dpll_id, .dpll_source_id = source_id,
>>>>> +						.dpll_source_type = source_type };
>>>>> +
>>>>> +	return dpll_send_event(DPLL_EVENT_SOURCE_CHANGE, &p);
>>>>> +}
>>>>> +
>>>>> +int dpll_notify_output_change(int dpll_id, int output_id, int output_type)
>>>>> +{
>>>>> +	struct param p =  { .dpll_id = dpll_id, .dpll_output_id = output_id,
>>>>> +						.dpll_output_type = output_type };
>>>>> +
>>>>> +	return dpll_send_event(DPLL_EVENT_OUTPUT_CHANGE, &p);
>>>>> +}
>>>>> +
>>>>> int __init dpll_netlink_init(void)
>>>>> {
>>>>> 	return genl_register_family(&dpll_gnl_family);
>>>>> diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
>>>>> index e2d100f59dd6..0dc81320f982 100644
>>>>> --- a/drivers/dpll/dpll_netlink.h
>>>>> +++ b/drivers/dpll/dpll_netlink.h
>>>>> @@ -3,5 +3,12 @@
>>>>>    *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
>>>>>    */
>>>>>
>>>>> +int dpll_notify_device_create(int dpll_id, const char *name);
>>>>> +int dpll_notify_device_delete(int dpll_id);
>>>>> +int dpll_notify_status_locked(int dpll_id);
>>>>> +int dpll_notify_status_unlocked(int dpll_id);
>>>>> +int dpll_notify_source_change(int dpll_id, int source_id, int source_type);
>>>>> +int dpll_notify_output_change(int dpll_id, int output_id, int output_type);
>>>>
>>>> Only dpll_notify_device_create is actually used, rest is not.
>>>> I am getting confused a bit, who should call those "notify" functions?
>>>> It is straightforward for create/delete, dpll subsystem shall do it, but what
>>>> about the rest?
>>>> I would say notifications about status or source/output change shall originate
>>>> in the driver implementing dpll interface, thus they shall be exported and
>>>> defined in the header included by the driver.
>>>>
>>>
>>> I was thinking about driver too, because device can have different interfaces to
>>> configure source/output, and different notifications to update status. I will
>>> update ptp_ocp driver to implement this logic. And it will also cover question
>>> of exporting these functions and their definitions.
>>>
>>
>> Great!
>>
>> Thank,
>> Arkadiusz
>>>>> +
>>>>> int __init dpll_netlink_init(void);
>>>>> void dpll_netlink_finish(void);
>>>>> -- 
>>>>> 2.27.0
>>>>>
>>>
>>
> 
> Good day Vadim,
> 
> I just wanted to make sure I didn't miss anything through the spam filters or
> something? We are still waiting for that github repo, or you were on
> vacation/busy, right?
> 

Hi Arkadiusz, Jakub

Actually I was on vacation which lasted unexpectedly long thanks for european 
airlines. So was busy catching up all the things happened while I was away.
Finally I created github repo with all the comments from previous conversation 
addressed and rebased on top of current net-next. No special progress apart from 
that, still need some time to prepare RFC v3 with documentation and proper 
driver usage, but current state should be usable for priorities implementation 
and simple tests:

https://github.com/vvfedorenko/linux-dpll.git

Ping me on github to have a write access to this repo, and sorry for being so late.

All best,
Vadim
