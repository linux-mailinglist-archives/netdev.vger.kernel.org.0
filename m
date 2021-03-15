Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1387B33AF70
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCOJ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:59:04 -0400
Received: from foss.arm.com ([217.140.110.172]:56956 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhCOJ63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 05:58:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E82F1FB;
        Mon, 15 Mar 2021 02:58:29 -0700 (PDT)
Received: from [10.57.12.51] (unknown [10.57.12.51])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1A7F3F70D;
        Mon, 15 Mar 2021 02:58:26 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] thermal/drivers/core: Use a char pointer for the
 cooling device name
From:   Lukasz Luba <lukasz.luba@arm.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
References: <20210312170316.3138-1-daniel.lezcano@linaro.org>
 <18fdc11b-abda-25d9-582f-de2f9dfa2feb@arm.com>
 <f51fcec0-1483-cecb-d984-591097c324ca@linaro.org>
 <1aada78d-06f1-4ccd-cf81-7c2e8f5fe747@arm.com>
Message-ID: <77c2ef52-960b-f4d5-9de7-f4a1a4a6e376@arm.com>
Date:   Mon, 15 Mar 2021 09:58:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1aada78d-06f1-4ccd-cf81-7c2e8f5fe747@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/21 9:40 AM, Lukasz Luba wrote:
> 
> 
> On 3/12/21 9:01 PM, Daniel Lezcano wrote:
>> On 12/03/2021 19:49, Lukasz Luba wrote:
>>>
>>>
>>> On 3/12/21 5:03 PM, Daniel Lezcano wrote:
>>>> We want to have any kind of name for the cooling devices as we do no
>>>> longer want to rely on auto-numbering. Let's replace the cooling
>>>> device's fixed array by a char pointer to be allocated dynamically
>>>> when registering the cooling device, so we don't limit the length of
>>>> the name.
>>>>
>>>> Rework the error path at the same time as we have to rollback the
>>>> allocations in case of error.
>>>>
>>>> Tested with a dummy device having the name:
>>>>    "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch"
>>>>
>>>> A village on the island of Anglesey (Wales), known to have the longest
>>>> name in Europe.
>>>>
>>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>> ---
>>>>    .../ethernet/mellanox/mlxsw/core_thermal.c    |  2 +-
>>>>    drivers/thermal/thermal_core.c                | 38 
>>>> +++++++++++--------
>>>>    include/linux/thermal.h                       |  2 +-
>>>>    3 files changed, 24 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>>>> b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>>>> index bf85ce9835d7..7447c2a73cbd 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>>>> @@ -141,7 +141,7 @@ static int mlxsw_get_cooling_device_idx(struct
>>>> mlxsw_thermal *thermal,
>>>>        /* Allow mlxsw thermal zone binding to an external cooling
>>>> device */
>>>>        for (i = 0; i < ARRAY_SIZE(mlxsw_thermal_external_allowed_cdev);
>>>> i++) {
>>>>            if (strnstr(cdev->type, 
>>>> mlxsw_thermal_external_allowed_cdev[i],
>>>> -                sizeof(cdev->type)))
>>>> +                strlen(cdev->type)))
>>>>                return 0;
>>>>        }
>>>>    diff --git a/drivers/thermal/thermal_core.c
>>>> b/drivers/thermal/thermal_core.c
>>>> index 996c038f83a4..9ef8090eb645 100644
>>>> --- a/drivers/thermal/thermal_core.c
>>>> +++ b/drivers/thermal/thermal_core.c
>>>> @@ -960,10 +960,7 @@ __thermal_cooling_device_register(struct
>>>> device_node *np,
>>>>    {
>>>>        struct thermal_cooling_device *cdev;
>>>>        struct thermal_zone_device *pos = NULL;
>>>> -    int result;
>>>> -
>>>> -    if (type && strlen(type) >= THERMAL_NAME_LENGTH)
>>>> -        return ERR_PTR(-EINVAL);
>>>> +    int ret;
>>>>          if (!ops || !ops->get_max_state || !ops->get_cur_state ||
>>>>            !ops->set_cur_state)
>>>> @@ -973,14 +970,17 @@ __thermal_cooling_device_register(struct
>>>> device_node *np,
>>>>        if (!cdev)
>>>>            return ERR_PTR(-ENOMEM);
>>>>    -    result = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
>>>> -    if (result < 0) {
>>>> -        kfree(cdev);
>>>> -        return ERR_PTR(result);
>>>> +    ret = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
>>>> +    if (ret < 0)
>>>> +        goto out_kfree_cdev;
>>>> +    cdev->id = ret;
>>>> +
>>>> +    cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
>>>> +    if (!cdev->type) {
>>>> +        ret = -ENOMEM;
>>>
>>> Since we haven't called the device_register() yet, I would call here:
>>> kfree(cdev);
>>> and then jump
>>
>> I'm not sure to understand, we have to remove the ida, no ?
> 
> Yes, we have to remove 'ida' and you jump to that label:
> goto out_ida_remove;
> but under that label, there is no 'put_device()'.
> We could have here, before the 'goto', a simple kfree, which
> should be safe, since we haven't called the device_register() yet.
> Something like:
> 
> --------8<------------------------------
> cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
> if (!cdev->type) {
>      ret = -ENOMEM;
>      kfree(cdev);
>      goto out_ida_remove;
> }
> 
> -------->8------------------------------
> 

I've check that label and probably not easy to modify it
and put conditional there. So probably you would have to
call everything here (not jumping to label):

ida_simple_remove(&thermal_cdev_ida, cdev->id);
kfree(cdev);
return ERR_PTR(-_ENOMEM);


> 
>>
>>> Other than that, LGTM
>>>
>>> Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
>>>
>>> Regards,
>>> Lukasz
>>
>>
