Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE2525FF14
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgIGQ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:27:16 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11311 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729863AbgIGQ1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:27:05 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f565f450002>; Mon, 07 Sep 2020 09:26:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 07 Sep 2020 09:26:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 07 Sep 2020 09:26:59 -0700
Received: from [172.27.13.12] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 16:26:50 +0000
Subject: Re: [PATCH net-next RFC v1 3/4] devlink: Add hierarchy between traps
 in device level and port level
To:     Ido Schimmel <idosch@idosch.org>, Aya Levin <ayal@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
 <1599060734-26617-4-git-send-email-ayal@mellanox.com>
 <20200906155858.GB2431016@shredder>
From:   Aya Levin <ayal@nvidia.com>
Message-ID: <a8147d79-fde1-4b31-0f06-fe2e54ee75c7@nvidia.com>
Date:   Mon, 7 Sep 2020 19:26:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200906155858.GB2431016@shredder>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599496005; bh=zWN2HLHNzNDC/aRGR6xUqOC8/KSE1ZfTowseUrpuvXE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=SzMIKPjHuDMvng3v+lrgs1iZyZwrlI9C5LxvELAbZBBD93qzkwtYgIoVM0f0DJ4uU
         Uwl9YQ3J1+LpDJl4MjqqjQ2pLTvWMmKf0n3N7PTC7VEVT/cVdf6g65UrKZogiILUvh
         3n6BjCyHWBwi0efHltOGCYj+yppTSvtWYHsHSHqC5Yf0FD5zVv6oO/J9g1RfO17RTn
         2BuGKt9/NrgBwYPRUN8s3m1HIOuB4bkRh6ShgrSYXKv6IWlzfS8KIhrZPU+vbBs0s4
         oQvGb66djDNCgXdTAKe9V2hqrg5MgkOdtoR2bNwhq/uF4NYVd8j0gRiYFzm49XNFH1
         LIbitXgUobRYQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2020 6:58 PM, Ido Schimmel wrote:
> On Wed, Sep 02, 2020 at 06:32:13PM +0300, Aya Levin wrote:
>> Managing large scale port's traps may be complicated. This patch
>> introduces a shortcut: when setting a trap on a device and this trap is
>> not registered on this device, the action will take place on all related
>> ports that did register this trap.
> 
> I'm not really a fan of this and I'm not sure there is precedent for
> something similar. Also, it's an optimization, so I wouldn't put it as
> part of the first submission before you gather some operational
> experience with the initial interface.

I thought it was a nice idea but I agree that this is an optimization 
and can be dropped from preliminary submission
> 
> In addition, I find it very unintuitive for users. When I do 'devlink
> trap show' I will not see anything. I will only see the traps when I
> issue 'devlink port trap show', yet 'devlink trap set ...' is expected
> to work.
> 
> Lets assume that this is a valid change, it would be better implemented
> with my suggestion from the previous patch: When devlink sees that a
> trap is registered on all the ports it can auto-register a new
> per-device trap and user space gets the appropriate notification.
> 
>>
>> Signed-off-by: Aya Levin <ayal@mellanox.com>
>> ---
>>   net/core/devlink.c | 43 +++++++++++++++++++++++++++++++++----------
>>   1 file changed, 33 insertions(+), 10 deletions(-)
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index b13e1b40bf1c..dea5482b2517 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -6501,23 +6501,46 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
>>   	struct devlink *devlink = info->user_ptr[0];
>>   	struct devlink_trap_mngr *trap_mngr;
>>   	struct devlink_trap_item *trap_item;
>> +	struct devlink_port *devlink_port;
>>   	int err;
>>   
>> -	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
>> -	if (list_empty(&trap_mngr->trap_list))
>> -		return -EOPNOTSUPP;
>> +	devlink_port = devlink_port_get_from_attrs(devlink, info->attrs);
>> +	if (IS_ERR(devlink_port)) {
>> +		trap_mngr =  &devlink->trap_mngr;
>> +		if (list_empty(&trap_mngr->trap_list))
>> +			goto loop_over_ports;
>>   
>> -	trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
>> -	if (!trap_item) {
>> -		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
>> -		return -ENOENT;
>> +		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
>> +		if (!trap_item)
>> +			goto loop_over_ports;
>> +	} else {
>> +		trap_mngr = &devlink_port->trap_mngr;
>> +		if (list_empty(&trap_mngr->trap_list))
>> +			return -EOPNOTSUPP;
>> +
>> +		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
>> +		if (!trap_item) {
>> +			NL_SET_ERR_MSG_MOD(extack, "Port did not register this trap");
>> +			return -ENOENT;
>> +		}
>>   	}
>>   	return devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
>>   
>> -	err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
>> -	if (err)
>> -		return err;
>> +loop_over_ports:
>> +	if (list_empty(&devlink->port_list))
>> +		return -EOPNOTSUPP;
>> +	list_for_each_entry(devlink_port, &devlink->port_list, list) {
>> +		trap_mngr = &devlink_port->trap_mngr;
>> +		if (list_empty(&trap_mngr->trap_list))
>> +			continue;
>>   
>> +		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
>> +		if (!trap_item)
>> +			continue;
>> +		err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
>> +		if (err)
>> +			return err;
>> +	}
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.14.1
>>
