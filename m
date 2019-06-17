Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121AD47834
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 04:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfFQCcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 22:32:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfFQCcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 22:32:06 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C24286F0077CABDF59D6;
        Mon, 17 Jun 2019 10:32:02 +0800 (CST)
Received: from [127.0.0.1] (10.184.16.119) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 17 Jun 2019
 10:32:00 +0800
Subject: Re: [PATCH] ipv4: fix inet_select_addr() when enable route_localnet
To:     David Ahern <dsahern@gmail.com>, <davem@davemloft.net>,
        <tgraf@suug.ch>
CC:     <netdev@vger.kernel.org>, <viro@zeniv.linux.org.uk>
References: <1560531321-163094-1-git-send-email-luoshijie1@huawei.com>
 <7f4443a0-b63f-22ea-2b39-9ab9752b3479@gmail.com>
From:   "Luoshijie (Poincare Lab)" <luoshijie1@huawei.com>
Message-ID: <a9366e02-5b12-967f-621a-3ffc979101d1@huawei.com>
Date:   Mon, 17 Jun 2019 10:31:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7f4443a0-b63f-22ea-2b39-9ab9752b3479@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.16.119]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/6/15 9:00, David Ahern wrote:
> On 6/14/19 10:55 AM, luoshijie wrote:
>> From: Shijie Luo <luoshijie1@huawei.com>
>>
>> Suppose we have two interfaces eth0 and eth1 in two hosts, follow 
>> the same steps in the two hosts:
>> # sysctl -w net.ipv4.conf.eth1.route_localnet=1
>> # sysctl -w net.ipv4.conf.eth1.arp_announce=2
>> # ip route del 127.0.0.0/8 dev lo table local
>> and then set ip to eth1 in host1 like:
>> # ifconfig eth1 127.25.3.4/24
>> set ip to eth2 in host2 and ping host1:
>> # ifconfig eth1 127.25.3.14/24
>> # ping -I eth1 127.25.3.4
>> Well, host2 cannot connect to host1.
> 
> Since you already have the commands, create a test script in
> tools/testing/selftests/net that uses network namespaces for host1 and
> host2 and demonstrates the problem. There quite a few examples in that
> directory to use as a template. eg., see icmp_redirect.sh
>
Thanks for your advice, I will follow it to add a testcase to demonstrate the problem.

>> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
>> index ea4bd8a52..325fafd4b 100644
>> --- a/net/ipv4/devinet.c
>> +++ b/net/ipv4/devinet.c
>> @@ -1249,14 +1249,19 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
>>  	struct in_device *in_dev;
>>  	struct net *net = dev_net(dev);
>>  	int master_idx;
>> +	unsigned char localnet_scope = RT_SCOPE_HOST;
> 
> net code uses reverse xmas tree ordering. ie., move that up.
> 
>>  
>>  	rcu_read_lock();
>>  	in_dev = __in_dev_get_rcu(dev);
>>  	if (!in_dev)
>>  		goto no_in_dev;
>>  
>> +	if (unlikely(IN_DEV_ROUTE_LOCALNET(in_dev))) {
>> +		localnet_scope = RT_SCOPE_LINK;
>> +	}
>> +
> 
> brackets are not needed.
> 
> 
>>  	for_primary_ifa(in_dev) {
>> -		if (ifa->ifa_scope > scope)
>> +		if (min(ifa->ifa_scope, localnet_scope) > scope)
>>  			continue;
>>  		if (!dst || inet_ifa_match(dst, ifa)) {
>>  			addr = ifa->ifa_local;
>>
> 
> 
> .
> 
Thanks for your reply and I really appreciate your advice very much.
I will soon add the testcase and submit the V2 patch.

