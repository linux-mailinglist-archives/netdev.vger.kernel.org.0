Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C5226AE6A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgIOUHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:07:10 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3609 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727713AbgIOUGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:06:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f611eba0005>; Tue, 15 Sep 2020 13:06:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 13:06:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 13:06:31 -0700
Received: from [10.21.180.184] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 20:06:19 +0000
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com>
 <20200914122732.GE2236@nanopsycho.orion>
 <996866b1-5472-dd95-f415-85c34c4d01c0@nvidia.com>
 <20200915132614.GN2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <b457bd8b-cf60-95a6-60eb-33b7a5ec06a4@nvidia.com>
Date:   Tue, 15 Sep 2020 23:06:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200915132614.GN2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600200378; bh=Lm81+AojpWyUlTb+BaNAF9XupWRNESqPe0U1Q1CgUr8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=FJa71lPrXTERv9ih7d4QbPrTAOkE7TyRa8i+iOzPRTmDzkAu08K+2OnK5Aet3sXgS
         hMj628IVIsnsWw95WjzMqbF1xfZUxojeUM2eqNQCT17l8XpE20PAmhO6D/uWzisty6
         3sJPvFsOjvOpSGlp6qOgm4EcpiNLAjQh+YkuYic25MGVD1ZF3vz57DrjfqUCWvG+eB
         +AdwNXDd2XKCnIqz2/zB207vYoNNNRwYJhjMfKBY851XARVlxnTrNUIs8mT8RU31tS
         HQii4G/6V6xlG5ORfSwu1IAsEPOzlU/3nC4zlJOiXh3C/GGNsqvkSXPpvpn1qPs0v3
         /nW6Zl5shI2VQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/15/2020 4:26 PM, Jiri Pirko wrote:
> Tue, Sep 15, 2020 at 02:12:25PM CEST, moshe@nvidia.com wrote:
>> On 9/14/2020 3:27 PM, Jiri Pirko wrote:
>>> Mon, Sep 14, 2020 at 08:07:48AM CEST, moshe@mellanox.com wrote:
> [..]	
> 	
>>>> @@ -7392,6 +7485,11 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
>>>> 	if (!devlink)
>>>> 		return NULL;
>>>> 	devlink->ops = ops;
>>>> +	if (devlink_reload_actions_verify(devlink)) {
>>> Move this check to the beginning. You don't need devlink instance for
>>> the check, just ops.
>>
>> Right, will fix.
>>
>>> also, your devlink_reload_actions_verify() function returns
>>> 0/-ESOMETHING. Treat it accordingly here.
>>
>> Well, yes, but I rather return NULL here since devlink_alloc() failed. If
>> devlink_reload_actions_verify() fails it has WARN_ON which will lead the
>> driver developer to his bug.
> So let the verify() return bool.
> My point is, if a function return 0/-ESOMETHING, you should not check
> the return value directly but you should use int err/ret.


OK, will fix.

>>>> +		kfree(devlink);
>>>> +		return NULL;
>>>> +	}
> [...]
