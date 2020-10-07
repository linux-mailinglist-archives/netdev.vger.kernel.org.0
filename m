Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09AD285830
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 07:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgJGFls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 01:41:48 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14732 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgJGFls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 01:41:48 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7d550f0000>; Tue, 06 Oct 2020 22:41:35 -0700
Received: from [10.21.180.193] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 05:41:31 +0000
Subject: Re: [PATCH net-next 05/16] devlink: Add remote reload stats
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-6-git-send-email-moshe@mellanox.com>
 <20201003090542.GF3159@nanopsycho.orion>
 <9ea0e668-3613-18dc-e1e0-c6dfbd803906@nvidia.com>
 <f0ae9141-3ed2-f296-b3ae-84408a87b2d9@intel.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <2cd57697-a1e1-cab8-6a7d-f139b5af1420@nvidia.com>
Date:   Wed, 7 Oct 2020 08:41:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f0ae9141-3ed2-f296-b3ae-84408a87b2d9@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602049295; bh=9upe5PRTkXHVgj06Gi2i1YyoRi+xygsiFggdIlcwuA8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=OibxIPubHJOw6TU1hp1ECGcKaEP3ZfuvqwPvRpBCI11bQvxwbA1eYgpioxoM8ztAG
         9TRiRqRiVZAtriDlijYKFy2o5eNaemVacEl/yqLGVy0xrwSklbkrGEhvtoxddm9Psc
         wAUTan+SvqyvAgS0Tj9ueMB4IWaseyMm+ipOx5udl2C74n510DWtuW0FjTFqZCpU72
         k3NjKkD/ZtZfbobvgUS7ORsZ+AQCIhyDwvWQo5RNdRuY8mgIEsEoGTQueLqP2IVxox
         l/XDIEabAaDR1tTVfgRtiYZUwqeSWbOhoDVnA6knRSMyLdO+5us7sBC5fHFfZlM7r9
         Tqz1cHNvQLrAQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/5/2020 10:12 PM, Jacob Keller wrote:
>
> On 10/4/2020 12:09 AM, Moshe Shemesh wrote:
>> On 10/3/2020 12:05 PM, Jiri Pirko wrote:
>>> Thu, Oct 01, 2020 at 03:59:08PM CEST, moshe@mellanox.com wrote:
>>>> Add remote reload stats to hold the history of actions performed due
>>>> devlink reload commands initiated by remote host. For example, in case
>>>> firmware activation with reset finished successfully but was initiated
>>>> by remote host.
>>>>
>>>> The function devlink_remote_reload_actions_performed() is exported to
>>>> enable drivers update on remote reload actions performed as it was not
>>>> initiated by their own devlink instance.
>>>>
>>>> Expose devlink remote reload stats to the user through devlink dev get
>>>> command.
>>>>
>>>> Examples:
>>>> $ devlink dev show
>>>> pci/0000:82:00.0:
>>>>    stats:
>>>>        reload_stats:
>>>>          driver_reinit 2
>>>>          fw_activate 1
>>>>          fw_activate_no_reset 0
>>>>        remote_reload_stats:
>>>>          driver_reinit 0
>>>>          fw_activate 0
>>>>          fw_activate_no_reset 0
>>>> pci/0000:82:00.1:
>>>>    stats:
>>>>        reload_stats:
>>>>          driver_reinit 1
>>>>          fw_activate 0
>>>>          fw_activate_no_reset 0
>>>>        remote_reload_stats:
>>>>          driver_reinit 1
>>>>          fw_activate 1
>>>>          fw_activate_no_reset 0
>>>>
>>>> $ devlink dev show -jp
>>>> {
>>>>      "dev": {
>>>>          "pci/0000:82:00.0": {
>>>>              "stats": {
>>>>                  "reload_stats": [ {
>>>>                          "driver_reinit": 2
>>>>                      },{
>>>>                          "fw_activate": 1
>>>>                      },{
>>>>                          "fw_activate_no_reset": 0
>>>>                      } ],
>>>>                  "remote_reload_stats": [ {
>>>>                          "driver_reinit": 0
>>>>                      },{
>>>>                          "fw_activate": 0
>>>>                      },{
>>>>                          "fw_activate_no_reset": 0
>>>>                      } ]
>>>>              }
>>>>          },
>>>>          "pci/0000:82:00.1": {
>>>>              "stats": {
>>>>                  "reload_stats": [ {
>>>>                          "driver_reinit": 1
>>>>                      },{
>>>>                          "fw_activate": 0
>>>>                      },{
>>>>                          "fw_activate_no_reset": 0
>>>>                      } ],
>>>>                  "remote_reload_stats": [ {
>>>>                          "driver_reinit": 1
>>>>                      },{
>>>>                          "fw_activate": 1
>>>>                      },{
>>>>                          "fw_activate_no_reset": 0
>>>>                      } ]
>>>>              }
>>>>          }
>>>>      }
>>>> }
>>>>
>>>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>>>> ---
>>>> RFCv5 -> v1:
>>>> - Resplit this patch and the previous one by remote/local reload stats
>>>> instead of set/get reload stats
>>>> - Rename reload_action_stats to reload_stats
>>>> RFCv4 -> RFCv5:
>>>> - Add remote actions stats
>>>> - If devlink reload is not supported, show only remote_stats
>>>> RFCv3 -> RFCv4:
>>>> - Renamed DEVLINK_ATTR_RELOAD_ACTION_CNT to
>>>>    DEVLINK_ATTR_RELOAD_ACTION_STAT
>>>> - Add stats per action per limit level
>>>> RFCv2 -> RFCv3:
>>>> - Add reload actions counters instead of supported reload actions
>>>>    (reload actions counters are only for supported action so no need f=
or
>>>>     both)
>>>> RFCv1 -> RFCv2:
>>>> - Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
>>>> - Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
>>>> - Have actions instead of levels
>>>> ---
>>>> include/net/devlink.h        |  1 +
>>>> include/uapi/linux/devlink.h |  1 +
>>>> net/core/devlink.c           | 49 +++++++++++++++++++++++++++++++-----
>>>> 3 files changed, 45 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>>>> index 0f3bd23b6c04..a4ccb83bbd2c 100644
>>>> --- a/include/net/devlink.h
>>>> +++ b/include/net/devlink.h
>>>> @@ -42,6 +42,7 @@ struct devlink {
>>>>      const struct devlink_ops *ops;
>>>>      struct xarray snapshot_ids;
>>>>      u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
>>>> +   u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
>>> Perhaps a nested struct  {} stats?
>> I guess you mean struct that holds these two arrays.
>>>>      struct device *dev;
>>>>      possible_net_t _net;
>>>>      struct mutex lock; /* Serializes access to devlink instance speci=
fic objects such as
>>>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink=
.h
>>>> index 97e0137f6201..f9887d8afdc7 100644
>>>> --- a/include/uapi/linux/devlink.h
>>>> +++ b/include/uapi/linux/devlink.h
>>>> @@ -530,6 +530,7 @@ enum devlink_attr {
>>>>      DEVLINK_ATTR_RELOAD_STATS,              /* nested */
>>>>      DEVLINK_ATTR_RELOAD_STATS_ENTRY,        /* nested */
>>>>      DEVLINK_ATTR_RELOAD_STATS_VALUE,        /* u32 */
>>>> +   DEVLINK_ATTR_REMOTE_RELOAD_STATS,       /* nested */
>>>>
>>>>      /* add new attributes above here, update the policy in devlink.c =
*/
>>>>
>>>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>>>> index 05516f1e4c3e..3b6bd3b4d346 100644
>>>> --- a/net/core/devlink.c
>>>> +++ b/net/core/devlink.c
>>>> @@ -523,28 +523,35 @@ static int devlink_reload_stat_put(struct sk_buf=
f *msg, enum devlink_reload_acti
>>>>      return -EMSGSIZE;
>>>> }
>>>>
>>>> -static int devlink_reload_stats_put(struct sk_buff *msg, struct devli=
nk *devlink)
>>>> +static int devlink_reload_stats_put(struct sk_buff *msg, struct devli=
nk *devlink, bool is_remote)
>>>> {
>>>>      struct nlattr *reload_stats_attr;
>>>>      int i, j, stat_idx;
>>>>      u32 value;
>>>>
>>>> -   reload_stats_attr =3D nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STAT=
S);
>>>> +   if (!is_remote)
>>>> +           reload_stats_attr =3D nla_nest_start(msg, DEVLINK_ATTR_REL=
OAD_STATS);
>>>> +   else
>>>> +           reload_stats_attr =3D nla_nest_start(msg, DEVLINK_ATTR_REM=
OTE_RELOAD_STATS);
>>>>
>>>>      if (!reload_stats_attr)
>>>>              return -EMSGSIZE;
>>>>
>>>>      for (j =3D 0; j <=3D DEVLINK_RELOAD_LIMIT_MAX; j++) {
>>>> -           if (j !=3D DEVLINK_RELOAD_LIMIT_UNSPEC &&
>>>> +           if (!is_remote && j !=3D DEVLINK_RELOAD_LIMIT_UNSPEC &&
>>> I don't follow the check "!is_remote" here,
>>
>> We agreed that remote stats should be shown also for non supported
>> actions and limits, because its remote. So it makes this condition
>> different for remote stats. Rethinking about it, maybe that's wrong. I
>> mean if we had here reload actions as a result of remote driver, they
>> have common device, so it has to be the same type of driver and support
>> same actions/limits, right ?
>>
> Obviously it runs the same device but.. technically, couldn't the remote
> device be running a different version of the driver? i.e. what if it
> supports some new mode that this host doesn't yet understand? (or does
> understand but has a driver which doesn't yet?)


Yes, also there is a possibility that one host function has privilege to=20
do an action that the other doesn't have.=C2=A0 I see there are reasons to=
=20
keep this diff between remote stats and local. I will keep it. Thanks.

