Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CD3281618
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388280AbgJBPHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:07:20 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9820 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:07:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f77421a0000>; Fri, 02 Oct 2020 08:07:06 -0700
Received: from [10.21.180.145] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 2 Oct
 2020 15:07:09 +0000
Subject: Re: [PATCH net-next 04/16] devlink: Add reload stats
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-5-git-send-email-moshe@mellanox.com>
 <20201001142521.0c9ac25c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <df68d59b-8885-d685-ab53-2c5d8f7b56e4@nvidia.com>
Date:   Fri, 2 Oct 2020 18:07:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201001142521.0c9ac25c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601651226; bh=NuVgA+fbMDuI47xZ3QpLWjwdo2NcD5S+6qV110A/d8U=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=JBT+6Iv1LsjO6Jrl+HuWdow632b2hC+8vpN86Ed0h28nzu7uehjEpQbZZBeKXufyY
         ua3gFVQTEkAfVNB2q7SgGkl0diEEPaX2pfxTVu0m8BbStojTQIskQgvxxZVhdGpEbS
         BkWTu8tfRtnU2/WBPMrcPzo7M+ma0FDDqgPTSSY8KsAWZwBGasqvezhrUPOntzIHJr
         XgF+1YuUAep+sZdZ6KRy9vpCvIwKg58xP36J1w4owmfzZogciRj82U8EQjjt7M0oh0
         Tsm0TGceClLZHHOHjqUXF0ngGtkr6GSUpic9pSsay7pnCJSHyj4oxbZJaOwhvKyefW
         w/GnKItt1r6wQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/2/2020 12:25 AM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Thu,  1 Oct 2020 16:59:07 +0300 Moshe Shemesh wrote:
>> Add reload stats to hold the history per reload action type and limit.
>>
>> For example, the number of times fw_activate has been performed on this
>> device since the driver module was added or if the firmware activation
>> was performed with or without reset.
>>
>> Add devlink notification on stats update.
>>
>> Expose devlink reload stats to the user through devlink dev get command.
>>
>> Examples:
>> $ devlink dev show
>> pci/0000:82:00.0:
>>    stats:
>>        reload_stats:
>>          driver_reinit 2
>>          fw_activate 1
>>          fw_activate_no_reset 0
>> pci/0000:82:00.1:
>>    stats:
>>        reload_stats:
>>          driver_reinit 1
>>          fw_activate 0
>>          fw_activate_no_reset 0
>>
>> $ devlink dev show -jp
>> {
>>      "dev": {
>>          "pci/0000:82:00.0": {
>>              "stats": {
>>                  "reload_stats": [ {
>>                          "driver_reinit": 2
>>                      },{
>>                          "fw_activate": 1
>>                      },{
>>                          "fw_activate_no_reset": 0
>>                      } ]
>>              }
>>          },
>>          "pci/0000:82:00.1": {
>>              "stats": {
>>                  "reload_stats": [ {
>>                          "driver_reinit": 1
>>                      },{
>>                          "fw_activate": 0
>>                      },{
>>                          "fw_activate_no_reset": 0
>>                      } ]
> This will be a question to the user space part but IDK why every stat
> is in a separate object?
>
> Instead of doing an array of objects -> [ {}, {}, {} ]
> make "reload_stats" itself an object.


I first thought that there should be an array of stats, looking at it 
again, as long as each stat contains just sting and value, object of 
pairs will perfectly fit. I will change it.

>>              }
>>          }
>>      }
>> }
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> Minor nits, looks good overall:
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 6de7d6aa6ed1..05516f1e4c3e 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -500,10 +500,68 @@ devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_l
>>        return test_bit(limit, &devlink->ops->reload_limits);
>>   }
>>
>> +static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
>> +                                enum devlink_reload_limit limit, u32 value)
>> +{
>> +     struct nlattr *reload_stats_entry;
>> +
>> +     reload_stats_entry = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS_ENTRY);
>> +     if (!reload_stats_entry)
>> +             return -EMSGSIZE;
>> +
>> +     if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action))
>> +             goto nla_put_failure;
>> +     if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_LIMIT, limit))
>> +             goto nla_put_failure;
>> +     if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_STATS_VALUE, value))
>> +             goto nla_put_failure;
> nit: it's common to combine such expressions into:
>
> if (nla_put...() ||
>      nla_put...() ||
>      nla_put...())
>      goto ...;


Ack.

>> +     nla_nest_end(msg, reload_stats_entry);
>> +     return 0;
>> +
>> +nla_put_failure:
>> +     nla_nest_cancel(msg, reload_stats_entry);
>> +     return -EMSGSIZE;
>> +}
>> +
>> +static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink)
>> +{
>> +     struct nlattr *reload_stats_attr;
>> +     int i, j, stat_idx;
>> +     u32 value;
>> +
>> +     reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
>> +
>> +     if (!reload_stats_attr)
>> +             return -EMSGSIZE;
>> +
>> +     for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
>> +             if (j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
> Why check this? It can't be supported.
Show stats of the actions with unspecified limit.
>> +                 !devlink_reload_limit_is_supported(devlink, j))
>> +                     continue;
>> +             for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
>> +                     if (!devlink_reload_action_is_supported(devlink, i) ||
>> +                         devlink_reload_combination_is_invalid(i, j))
> Again, devlink instance would not have been registered with invalid
> combinations, right?


It does register actions and register limits, there can be invalid 
combination, but devlink will block it before it gets to the driver.

>> +                             continue;
>> +
>> +                     stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
>> +                     value = devlink->reload_stats[stat_idx];
>> +                     if (devlink_reload_stat_put(msg, i, j, value))
>> +                             goto nla_put_failure;
>> +             }
>> +     }
>> +     nla_nest_end(msg, reload_stats_attr);
>> +     return 0;
>> +
>> +nla_put_failure:
>> +     nla_nest_cancel(msg, reload_stats_attr);
>> +     return -EMSGSIZE;
>> +}
>
>> @@ -3004,6 +3072,34 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>>   }
>>   EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>> +static void
>> +__devlink_reload_stats_update(struct devlink *devlink, u32 *reload_stats,
>> +                           enum devlink_reload_limit limit, unsigned long actions_performed)
>> +     for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
> nit: for_each_set_bit
Ack.
>> +             if (!test_bit(action, &actions_performed))
>> +                     continue;
>> +             stat_idx = limit * __DEVLINK_RELOAD_ACTION_MAX + action;
>> +             reload_stats[stat_idx]++;
>> +     }
>> +     devlink_notify(devlink, DEVLINK_CMD_NEW);
>> +}
