Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33026B05B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgIOWIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:08:34 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5416 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgIOUVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:21:20 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f6122160003>; Tue, 15 Sep 2020 13:20:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 13:20:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 15 Sep 2020 13:20:51 -0700
Received: from [10.21.180.184] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 20:20:43 +0000
Subject: Re: [PATCH net-next RFC v4 03/15] devlink: Add reload action stats
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-4-git-send-email-moshe@mellanox.com>
 <20200914133939.GG2236@nanopsycho.orion>
 <a5b7cbd5-ef55-1d74-a21e-5fb962307773@nvidia.com>
 <20200915133309.GP2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <3e5869e2-aad7-0d71-12fb-6d14c76864c9@nvidia.com>
Date:   Tue, 15 Sep 2020 23:20:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915133309.GP2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600201238; bh=gXm1Y7LWJHpwMwPUFxEj3aiKP6/AqqK11Yru+/Nnsps=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=nCz5Uv4p5BYDSrLTM/S4JVd8GippPoxH6YZh27JU5DwmP0mhKj0kNjLJ1uYUXWsZP
         nCI+ScnLOHVmyANVhYkFY0Sr6MpSBtb9SMZlv9eXMzfB45DkEo8NRUnd7ExdF6RIWt
         WoxeT65Tg6ewQ9AvZikTJqQ7xlvA2DBKWTaLaVLWx6odsZxb0OSaoprz5rz0kJxA2a
         MiRakmjyEuMaCdc8jpUQc66D3WtSDPbyV4Wn8/yVOvUx9SxnxayXhk8AOWBVjdXst3
         vrW6p/VafCIv1FslxwCd0TNMVXTrAEXm4L9vquxmHQtLosuhteLYYbacG3yoXxMxJf
         9qQNlJTnBQ1eQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/15/2020 4:33 PM, Jiri Pirko wrote:
> Tue, Sep 15, 2020 at 02:30:19PM CEST, moshe@nvidia.com wrote:
>> On 9/14/2020 4:39 PM, Jiri Pirko wrote:
>>> Mon, Sep 14, 2020 at 08:07:50AM CEST, moshe@mellanox.com wrote:
> [..]
>
>
>>>> +/**
>>>> + *	devlink_reload_implicit_actions_performed - Update devlink on reload actions
>>>> + *	  performed which are not a direct result of devlink reload call.
>>>> + *
>>>> + *	This should be called by a driver after performing reload actions in case it was not
>>>> + *	a result of devlink reload call. For example fw_activate was performed as a result
>>>> + *	of devlink reload triggered fw_activate on another host.
>>>> + *	The motivation for this function is to keep data on reload actions performed on this
>>>> + *	function whether it was done due to direct devlink reload call or not.
>>>> + *
>>>> + *	@devlink: devlink
>>>> + *	@limit_level: reload action limit level
>>>> + *	@actions_performed: bitmask of actions performed
>>>> + */
>>>> +void devlink_reload_implicit_actions_performed(struct devlink *devlink,
>>>> +					       enum devlink_reload_action_limit_level limit_level,
>>>> +					       unsigned long actions_performed)
>>> What I'm a bit scarred of that the driver would call this from withing
>>> reload_down()/up() ops. Perheps this could be WARN_ON'ed here (or in
>>> devlink_reload())?
>>>
>> Not sure how I know if it was called from devlink_reload_down()/up() ? Maybe
>> mutex ? So the warn will be actually mutex deadlock ?
> No. Don't abuse mutex for this.
> Just make sure that the counters do not move when you call
> reload_down/up().
>

Can make that, but actually I better take devlink->lock anyway in this 
function to avoid races, WDYT ?

>>>> +{
>>>> +	if (!devlink_reload_supported(devlink))
>>> Hmm. I think that the driver does not have to support the reload and can
>>> still be reloaded by another instance and update the stats here. Why
>>> not?
>>>
>> But I show counters only for supported reload actions and levels, otherwise
>> we will have these counters on devlink dev show output for other drivers that
>> don't have support for devlink reload and didn't implement any of these
>> including this function and these drivers may do some actions like
>> fw_activate in another way and don't update the stats and so that will make
>> these stats misleading. They will show history "stats" but they don't update
>> them as they didn't apply anything related to devlink reload.
> The case I tried to point at is the driver instance, that does not
> implement reload ops itself, but still it can be reloaded by someone else -
> the other driver instance outside.
>
> The counters should work no matter if the driver implements reload ops
> or not. Why wouldn't they? The user still likes to know that the devices
> was reloaded.
>

OK, so you say that every driver should show all counters no matter what 
actions it supports and if it supports devlink reload at all, right ?

>
>>>> +		return;
>>>> +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(devlink_reload_implicit_actions_performed);
>>>> +
>>>> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>>>> 			  enum devlink_reload_action action,
>>>> 			  enum devlink_reload_action_limit_level limit_level,
>>>> -			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>>>> +			  struct netlink_ext_ack *extack, unsigned long *actions_performed_out)
>>>> {
>>>> +	unsigned long actions_performed;
>>>> 	int err;
>>>>
>>>> 	if (!devlink->reload_enabled)
>>>> @@ -2998,9 +3045,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>>>> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>>>> 		devlink_reload_netns_change(devlink, dest_net);
>>>>
>>>> -	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
>>>> +	err = devlink->ops->reload_up(devlink, action, limit_level, extack, &actions_performed);
>>>> 	devlink_reload_failed_set(devlink, !!err);
>>>> -	return err;
>>>> +	if (err)
>>>> +		return err;
>>>> +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>>>> +	if (actions_performed_out)
>>> Just make the caller to provide valid pointer, as I suggested in the
>>> other patch review.
>>
>> Ack.
>>
>>>> +		*actions_performed_out = actions_performed;
>>>> +	return 0;
>>>> }
>>>>
>>>> static int
>>>> -- 
>>>> 2.17.1
>>>>
