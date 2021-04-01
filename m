Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D63350C0C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 03:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhDABo0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 31 Mar 2021 21:44:26 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:59202 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhDABoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 21:44:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuchunmei@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UU-bDw-_1617241448;
Received: from 30.225.32.30(mailfrom:xuchunmei@linux.alibaba.com fp:SMTPD_---0UU-bDw-_1617241448)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 01 Apr 2021 09:44:08 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH] ip-nexthop: support flush by id
From:   xuchunmei <xuchunmei@linux.alibaba.com>
In-Reply-To: <d2f565b8-f501-2abb-2067-8971ab683bd6@gmail.com>
Date:   Thu, 1 Apr 2021 09:44:08 +0800
Cc:     netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CA728C0D-7ED9-481A-B72E-434AA5AA7BA8@linux.alibaba.com>
References: <20210331022234.52977-1-xuchunmei@linux.alibaba.com>
 <YGRi0oimvPC/FSRT@shredder.lan>
 <d2f565b8-f501-2abb-2067-8971ab683bd6@gmail.com>
To:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I just refer to the support of protocol, not considering that id is unique. It is too heavy to get all.

> 2021年3月31日 下午11:36，David Ahern <dsahern@gmail.com> 写道：
> 
> On 3/31/21 5:53 AM, Ido Schimmel wrote:
>>> @@ -124,6 +125,9 @@ static int flush_nexthop(struct nlmsghdr *nlh, void *arg)
>>> 	if (tb[NHA_ID])
>>> 		id = rta_getattr_u32(tb[NHA_ID]);
>>> 
>>> +	if (filter.id && filter.id != id)
>>> +		return 0;
>>> +
>>> 	if (id && !delete_nexthop(id))
>>> 		filter.flushed++;
>>> 
>>> @@ -491,7 +495,10 @@ static int ipnh_list_flush(int argc, char **argv, int action)
>>> 			NEXT_ARG();
>>> 			if (get_unsigned(&id, *argv, 0))
>>> 				invarg("invalid id value", *argv);
>>> -			return ipnh_get_id(id);
>>> +			if (action == IPNH_FLUSH)
>>> +				filter.id = id;
>>> +			else
>>> +				return ipnh_get_id(id);
>> 
>> I think it's quite weird to ask for a dump of all nexthops only to
>> delete a specific one. How about this:
> 
> +1
> 
>> 
>> ```
>> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
>> index 0263307c49df..09a3076231aa 100644
>> --- a/ip/ipnexthop.c
>> +++ b/ip/ipnexthop.c
>> @@ -765,8 +765,16 @@ static int ipnh_list_flush(int argc, char **argv, int action)
>>                        if (!filter.master)
>>                                invarg("VRF does not exist\n", *argv);
>>                } else if (!strcmp(*argv, "id")) {
>> -                       NEXT_ARG();
>> -                       return ipnh_get_id(ipnh_parse_id(*argv));
>> +                       /* When 'id' is specified with 'flush' / 'list' we do
>> +                        * not need to perform a dump.
>> +                        */
>> +                       if (action == IPNH_LIST) {
>> +                               NEXT_ARG();
>> +                               return ipnh_get_id(ipnh_parse_id(*argv));
>> +                       } else {
>> +                               return ipnh_modify(RTM_DELNEXTHOP, 0, argc,
>> +                                                  argv);
>> +                       }
> 
> since delete just needs the id, you could refactor ipnh_modify and
> create a ipnh_delete_id.

