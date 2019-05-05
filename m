Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F22C13C84
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfEEBQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:16:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726294AbfEEBQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:16:46 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 518EB388E02B2147DB63;
        Sun,  5 May 2019 09:16:44 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Sun, 5 May 2019
 09:16:34 +0800
Subject: Re: [PATCH iproute2 v3] ipnetns: use-after-free problem in
 get_netnsid_from_name func
To:     David Ahern <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <liuhangbin@gmail.com>, <kuznet@ms2.inr.ac.ru>
CC:     <nicolas.dichtel@6wind.com>, <phil@nwl.cc>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>, <kouhuiying@huawei.com>,
        <netdev@vger.kernel.org>
References: <f6c76a60-d5c4-700f-2fbf-912fc1545a31@huawei.com>
 <815afacc-4cd2-61b4-2181-aabce6582309@huawei.com>
 <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
 <afffe3c9-5f08-3cc5-f356-dbb41e94ab75@gmail.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <a7e88fd6-65be-97f9-f660-152fabef565e@huawei.com>
Date:   Sun, 5 May 2019 09:15:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <afffe3c9-5f08-3cc5-f356-dbb41e94ab75@gmail.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 5/4/19 1:26 AM, Zhiqiang Liu wrote:
>>
>> diff --git a/ip/ipnetns.c b/ip/ipnetns.c
>> index 430d884..d72be95 100644
>> --- a/ip/ipnetns.c
>> +++ b/ip/ipnetns.c
>> @@ -107,7 +107,7 @@ int get_netnsid_from_name(const char *name)
>>  	struct nlmsghdr *answer;
>>  	struct rtattr *tb[NETNSA_MAX + 1];
>>  	struct rtgenmsg *rthdr;
>> -	int len, fd;
>> +	int len, fd, ret = -1;
>>
>>  	netns_nsid_socket_init();
>>
>> @@ -134,8 +134,9 @@ int get_netnsid_from_name(const char *name)
>>  	parse_rtattr(tb, NETNSA_MAX, NETNS_RTA(rthdr), len);
>>
>>  	if (tb[NETNSA_NSID]) {
>> +		ret = rta_getattr_u32(tb[NETNSA_NSID]);
>>  		free(answer);
>> -		return rta_getattr_u32(tb[NETNSA_NSID]);
>> +		return ret;
> 
> set ret here, drop the free, let it proceed down to the existing free
> and return but now using ret. That way there is 1 exit path and handles
> the cleanup

Yes, you are right. I will do that in the v4 patch.
That is very nice of you. Thanks a lot.


