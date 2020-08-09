Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4208123FC48
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 05:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgHIDTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 23:19:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3049 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgHIDTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 23:19:36 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 647C9DCD89E35B8A92CA;
        Sun,  9 Aug 2020 11:19:32 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sun, 9 Aug 2020 11:19:31 +0800
Subject: Re: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
To:     Kees Cook <keescook@chromium.org>
CC:     David Miller <davem@davemloft.net>, <David.Laight@ACULAB.COM>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200807020914.3123-1-luobin9@huawei.com>
 <e7a4fcf12a4e4d179e2fae8ffb44f992@AcuMS.aculab.com>
 <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
 <20200807.204243.696618708291045170.davem@davemloft.net>
 <202008072320.03879DAC@keescook>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <493cae67-6346-1a57-5cca-65a2b6d2aeba@huawei.com>
Date:   Sun, 9 Aug 2020 11:19:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <202008072320.03879DAC@keescook>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/8 14:44, Kees Cook wrote:
> On Fri, Aug 07, 2020 at 08:42:43PM -0700, David Miller wrote:
>> From: "luobin (L)" <luobin9@huawei.com>
>> Date: Sat, 8 Aug 2020 11:36:42 +0800
>>
>>> On 2020/8/7 17:32, David Laight wrote:
>>>>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>>> b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>>> index c6adc776f3c8..1ec88ebf81d6 100644
>>>>> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>>>> @@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
>>>>>
>>>>>  	level = event->event.chip.err_level;
>>>>>  	if (level < FAULT_LEVEL_MAX)
>>>>> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
>>>>> +		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);
>>>>
>>>> Have you even considered what that code is actually doing?
>>  ...
>>> I'm sorry that I haven't got what you mean and I haven't found any defects in that code. Can you explain more to me?
>>
>> David is trying to express the same thing I was trying to explain to
>> you, you should use sizeof(level_str) as the third argument because
>> the code is trying to make sure that the destination buffer is not
>> overrun.
>>
>> If you use the strlen() of the source buffer, the strncpy() can still
>> overflow the destination buffer.
>>
>> Now do you understand?
> 
> Agh, please never use strncpy() on NUL-terminated strings[1]. (You can
> see this ultimately gets passed down into devlink_fmsg_string_put()
> which expects NUL-terminated strings and does not require trailing
> NUL-padding (which if it did, should still never use strncpy(), but
> rather strscpy_pad()).
> 
> But, as David Laight hints, none of this is needed. The entire buffer
> can be avoided (just point into the existing array of strings -- which
> should also be const). Add I see that one of the array sizes is wrong.
> Both use FAULT_TYPE_MAX, but one should be FAULT_LEVEL_MAX. And since
> "Unknown" can just be added to the array, do that and clamp the value
> since it's only used for finding the strings in the array.
> 
> I would suggest this (totally untested):
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> index c6adc776f3c8..20bfb05896e5 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> @@ -334,18 +334,12 @@ void hinic_devlink_unregister(struct hinic_devlink_priv *priv)
>  static int chip_fault_show(struct devlink_fmsg *fmsg,
>  			   struct hinic_fault_event *event)
>  {
> -	char fault_level[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
> -		"fatal", "reset", "flr", "general", "suggestion"};
> -	char level_str[FAULT_SHOW_STR_LEN + 1] = {0};
> -	u8 level;
> +	const char * const level_str[FAULT_LEVEL_MAX + 1] = {
> +		"fatal", "reset", "flr", "general", "suggestion",
> +		[FAULT_LEVEL_MAX] = "Unknown"};
> +	u8 fault_level;
>  	int err;
>  
> -	level = event->event.chip.err_level;
> -	if (level < FAULT_LEVEL_MAX)
> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
> -	else
> -		strncpy(level_str, "Unknown", strlen("Unknown"));
> -
>  	if (level == FAULT_LEVEL_SERIOUS_FLR) {
>  		err = devlink_fmsg_u32_pair_put(fmsg, "Function level err func_id",
>  						(u32)event->event.chip.func_id);
> @@ -361,7 +355,8 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
>  	if (err)
>  		return err;
>  
> -	err = devlink_fmsg_string_pair_put(fmsg, "err_level", level_str);
> +	fault_level = clamp(event->event.chip.err_level, FAULT_LEVEL_MAX);
> +	err = devlink_fmsg_string_pair_put(fmsg, "err_level", fault_str[fault_level]);
>  	if (err)
>  		return err;
>  
> @@ -381,18 +376,15 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
>  static int fault_report_show(struct devlink_fmsg *fmsg,
>  			     struct hinic_fault_event *event)
>  {
> -	char fault_type[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
> +	const char * const type_str[FAULT_TYPE_MAX + 1] = {
>  		"chip", "ucode", "mem rd timeout", "mem wr timeout",
> -		"reg rd timeout", "reg wr timeout", "phy fault"};
> -	char type_str[FAULT_SHOW_STR_LEN + 1] = {0};
> +		"reg rd timeout", "reg wr timeout", "phy fault",
> +		[FAULT_TYPE_MAX] = "Unknown"};
> +	u8 fault_type;
>  	int err;
>  
> -	if (event->type < FAULT_TYPE_MAX)
> -		strncpy(type_str, fault_type[event->type], strlen(fault_type[event->type]));
> -	else
> -		strncpy(type_str, "Unknown", strlen("Unknown"));
> -
> -	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str);
> +	fault_type = clamp(event->type, FAULT_TYPE_MAX);
> +	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str[fault_type]);
>  	if (err)
>  		return err;
>  
> 
> 
> -Kees
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> 
Thanks for your explanation and review. I haven't realized using strncpy() on NUL-terminated strings is deprecated
and just trying to avoid the compile warnings. The website you provide helps me a lot. Thank you very much!
