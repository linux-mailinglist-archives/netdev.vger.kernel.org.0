Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79611259EEE
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgIATFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:05:49 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7624 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIATFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:05:48 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e9b7e0001>; Tue, 01 Sep 2020 12:05:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 12:05:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Sep 2020 12:05:48 -0700
Received: from [10.21.180.182] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 19:05:40 +0000
Subject: Re: [PATCH net-next RFC v3 02/14] devlink: Add reload actions
 counters
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-3-git-send-email-moshe@mellanox.com>
 <20200831104827.GB3794@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <1fa33c3c-57b8-fe38-52d6-f50a586a8d3f@nvidia.com>
Date:   Tue, 1 Sep 2020 22:05:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831104827.GB3794@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598987134; bh=joZ6P2X1Ecq5o34OvZRltWE5VuFJHy8GLteOaavP120=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=FYvRakbucA3oTb87f/fnrZoIyzUfLNj1q6JuQOpvRzPyrV+Oc4P9cqcfYqQ271CGP
         H5SCVbvC0gIxUHbhMTvzmha3qQ6GkNOFf31Wkqy/EUs6IXfHFzDM/9vB1gJCxMmCrG
         DlQt3YZmkhUgXWT0IOPkNWLfWGaKYrZqkEI+FnfXmWMwrgfHUgYgOPGW7341XK0y0v
         FzQCM4mCLuUoEPYuRvKfLrPA4vqQ1Dfmu1IBdMi+viC/tA16Xsym07omcgYY2uINaX
         vdr/cCyiELe0f/TZeHsQmLesaGN/CAcFRiBCDpx8RQBcKJE0wsp8ocIvMdDg1RmcJD
         PvW2zuEAImR2Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/2020 1:48 PM, Jiri Pirko wrote:
> Sun, Aug 30, 2020 at 05:27:22PM CEST, moshe@mellanox.com wrote:
>> Add reload actions counters to hold the history per reload action type.
>> For example, the number of times fw_activate has been done on this
>> device since the driver module was added or if the firmware activation
>> was done with or without reset.
>> The function devlink_reload_actions_cnts_update() is exported to enable
>> also drivers update on reload actions done, for example in case firmware
>> activation with reset finished successfully but was initiated by remote
>> host.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v2 -> v3:
>> - New patch
>> ---
>> include/net/devlink.h |  2 ++
>> net/core/devlink.c    | 24 +++++++++++++++++++++---
>> 2 files changed, 23 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index b8f0152a1fff..0547f0707d92 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -38,6 +38,7 @@ struct devlink {
>> 	struct list_head trap_policer_list;
>> 	const struct devlink_ops *ops;
>> 	struct xarray snapshot_ids;
>> +	u32 reload_actions_cnts[DEVLINK_RELOAD_ACTION_MAX];
>> 	struct device *dev;
>> 	possible_net_t _net;
>> 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
>> @@ -1372,6 +1373,7 @@ void
>> devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
>>
>> bool devlink_is_reload_failed(const struct devlink *devlink);
>> +void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done);
>>
>> void devlink_flash_update_begin_notify(struct devlink *devlink);
>> void devlink_flash_update_end_notify(struct devlink *devlink);
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 8d4137ad40db..20a29c34ff71 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -2969,10 +2969,23 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>> }
>> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>> +void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done)
>> +{
>> +	int action;
>> +
>> +	for (action = 0; action < DEVLINK_RELOAD_ACTION_MAX; action++) {
>> +		if (!test_bit(action, &actions_done))
>> +			continue;
>> +		devlink->reload_actions_cnts[action]++;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_reload_actions_cnts_update);
> I don't follow why this is an exported symbol if you only use it from
> this .c. Looks like a leftover...
>
Not leftover, in the commit message I notified and explained why I 
exposed it.
>> +
>> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> 			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
>> -			  unsigned long *actions_done)
>> +			  unsigned long *actions_done_out)
>> {
>> +	unsigned long actions_done;
>> 	int err;
>>
>> 	if (!devlink->reload_enabled)
>> @@ -2985,9 +2998,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>> 		devlink_reload_netns_change(devlink, dest_net);
>>
>> -	err = devlink->ops->reload_up(devlink, action, extack, actions_done);
>> +	err = devlink->ops->reload_up(devlink, action, extack, &actions_done);
>> 	devlink_reload_failed_set(devlink, !!err);
>> -	return err;
>> +	if (err)
>> +		return err;
>> +	devlink_reload_actions_cnts_update(devlink, actions_done);
>> +	if (actions_done_out)
>> +		*actions_done_out = actions_done;
> Why don't you just use the original actions_done directly without having
> extra local variable?

Because the parameter can be NULL if not needed, see patch 01/14 
devlink_reload() called from devlink_pernet_pre_exit()


>
>> +	return 0;
>> }
>>
>> static int
>> -- 
>> 2.17.1
>>
