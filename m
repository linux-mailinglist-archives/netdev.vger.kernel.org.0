Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFADE2CB56F
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 08:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgLBHB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 02:01:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18515 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgLBHB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 02:01:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc73ba00000>; Tue, 01 Dec 2020 23:00:48 -0800
Received: from [10.26.73.44] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 07:00:40 +0000
Subject: Re: [PATCH iproute2-net 2/3] devlink: Add pr_out_dev() helper
 function
To:     David Ahern <dsahern@gmail.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
 <1606389296-3906-3-git-send-email-moshe@mellanox.com>
 <f44cc093-2199-7e94-561a-a9450511293a@gmail.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <1285ee42-29ed-c06e-1560-1853dbf02823@nvidia.com>
Date:   Wed, 2 Dec 2020 09:00:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <f44cc093-2199-7e94-561a-a9450511293a@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606892448; bh=9EjDu0bE5ITpA3WR/V0NzkVsXFf46+TtYPoSu+RRcrI=;
        h=Subject:To:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=FfnYZrKrpyHrLeMIAt0bdWHFd6zrcUhSJcGsu4LtVciOXJYjCLo/6J9e53BMhjPKK
         JNdkEx6Yw2+rVp/28AWhM240FQlcmTX5fjE5WI/B5NPCdkIk70uWOLtcy8JuqVuh+T
         yKSnbr8g8/Ij1MVm5XBXb1Rj9jYtN9tH9DMlq9rq/QWtADbYh9GyhZVBoCLkBI4Eas
         nvVqAUjvdo/3tWbqBp0LAFP2WT7H9ZJxiMcH9RCq4qCk53/Taq2I3ZcsHGIWiF31/A
         VxGM30+1rlvFG7Ydy9uJjuQEfzLqYT5wPUGwnXCjWR2MBlA5GmHQYgNrqlfP/YaG8a
         yOs1v3NErzLRw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/29/2020 11:15 PM, David Ahern wrote:
> On 11/26/20 4:14 AM, Moshe Shemesh wrote:
>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>> index a9ba0072..bd588869 100644
>> --- a/devlink/devlink.c
>> +++ b/devlink/devlink.c
>> @@ -2974,17 +2974,11 @@ static int cmd_dev_param(struct dl *dl)
>>   	pr_err("Command \"%s\" not found\n", dl_argv(dl));
>>   	return -ENOENT;
>>   }
>> -static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
>> +
>> +static void pr_out_dev(struct dl *dl, struct nlattr **tb)
> why 'pr_out_dev'? there is no 'dev' argument.


Because it prints command dev show output, the data is in tb argument 
and includes bus name, dev name and dev stats.
>>   {
>> -	struct dl *dl = data;
>> -	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
>> -	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
>>   	uint8_t reload_failed = 0;
>>   
>> -	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
>> -	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
>> -		return MNL_CB_ERROR;
>> -
>>   	if (tb[DEVLINK_ATTR_RELOAD_FAILED])
>>   		reload_failed = mnl_attr_get_u8(tb[DEVLINK_ATTR_RELOAD_FAILED]);
>>   
