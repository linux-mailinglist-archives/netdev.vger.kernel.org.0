Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C24E2CB570
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 08:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbgLBHCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 02:02:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18627 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgLBHCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 02:02:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc73bd70000>; Tue, 01 Dec 2020 23:01:43 -0800
Received: from [10.26.73.44] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 07:01:31 +0000
Subject: Re: [PATCH iproute2-net 3/3] devlink: Add reload stats to dev show
To:     David Ahern <dsahern@gmail.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
 <1606389296-3906-4-git-send-email-moshe@mellanox.com>
 <505ce6cb-be99-3972-a882-4baeeeece216@gmail.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <035bdb1a-4aac-04cb-15ab-78fd687f5dc5@nvidia.com>
Date:   Wed, 2 Dec 2020 09:01:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <505ce6cb-be99-3972-a882-4baeeeece216@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606892503; bh=6ZnY/URj3cI5wyEBcpESN3MYj7S4j7UjbQSO1PVr5Hw=;
        h=Subject:To:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=kZa2zT5gzFTceFnjputUqels/0Hv9DFX810j07OQZL9IsUnFihHH2WaZSI3LdQ2ke
         SjEetaUMlxrYCbpizzrRm299JMiJGo6BZhsSuRwk4IkxNYDE+dk9uSSAobHZOocKg1
         fXDfMOfRu17M+f58ChIf6cOrC2ZgiIPj3VQ0Yz34/0niJNcTEH6yPd1Oyn+kDINenv
         7URcHU5NyAX6WvZbFTnLoaJLEMIkIOa827z5Oo3sIhFGxVP1AuxjxktHIeZT5NzSSy
         PbvCxGaeYQS1FN8//t81OaLWTWxYIzETZ4OZqXDT6gAcVpnOq7IXkaPAkBCAXUtyvC
         /YPKuVXdcwbvw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/29/2020 11:22 PM, David Ahern wrote:
> On 11/26/20 4:14 AM, Moshe Shemesh wrote:
>> @@ -2975,17 +2996,93 @@ static int cmd_dev_param(struct dl *dl)
>>   	return -ENOENT;
>>   }
>>   
>> -static void pr_out_dev(struct dl *dl, struct nlattr **tb)
>> +static void pr_out_action_stats(struct dl *dl, struct nlattr *action_stats)
>> +{
>> +	struct nlattr *tb_stats_entry[DEVLINK_ATTR_MAX + 1] = {};
>> +	struct nlattr *reload_stats_entry;
>> +	enum devlink_reload_limit limit;
>> +	uint32_t value;
>> +	int err;
>> +
>> +	mnl_attr_for_each_nested(reload_stats_entry, action_stats) {
>> +		err = mnl_attr_parse_nested(reload_stats_entry, attr_cb, tb_stats_entry);
> wrap lines at 80 columns unless it is a print statement.
Ack.
>
>> +		if (err != MNL_CB_OK)
>> +			return;
>> +		if (!tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_LIMIT] ||
>> +		    !tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_VALUE])
>> +			return;
>> +
>> +		check_indent_newline(dl);
>> +		limit = mnl_attr_get_u8(tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_LIMIT]);
>> +		value = mnl_attr_get_u32(tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_VALUE]);
> Use temp variables for the attributes to make the code readable.
Ack.
>
>> +		print_uint_name_value(reload_limit_name(limit), value);
>> +	}
>> +}
>> +
> that applies to all of the patches.
>
