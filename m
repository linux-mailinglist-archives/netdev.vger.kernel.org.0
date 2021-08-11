Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B593B3E88F0
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 05:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhHKDlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 23:41:52 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:27303 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232795AbhHKDlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 23:41:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uied3FN_1628653275;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0Uied3FN_1628653275)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 Aug 2021 11:41:16 +0800
Subject: Re: [PATCH] ipv4: return early for possible invalid uaddr
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Baoyou Xie <baoyou.xie@alibaba-inc.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210807171938.38501-1-wenyang@linux.alibaba.com>
 <20210809153251.4c51c3cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
Message-ID: <72dd5ee4-d7f3-576c-c7b9-3f8f4980faf3@linux.alibaba.com>
Date:   Wed, 11 Aug 2021 11:41:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809153251.4c51c3cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2021/8/10 ÉÏÎç6:32, Jakub Kicinski Ð´µÀ:
> On Sun,  8 Aug 2021 01:19:38 +0800 Wen Yang wrote:
>> The inet_dgram_connect() first calls inet_autobind() to select an
>> ephemeral port, then checks uaddr in udp_pre_connect() or
>> __ip4_datagram_connect(), but the port is not released until the socket
>> is closed.
>>
>> We should return early for invalid uaddr to improve performance and
>> simplify the code a bit,
> 
> The performance improvement would be if the benchmark is calling
> connect with invalid arguments? That seems like an extremely rare
> scenario in real life.
> 

Thanks for your comments.

On the one hand, it is the performance impact, but we also found that it
may cause DoS: simulate a scenario where udp connect is frequently
performed (illegal addrlen, and the socket is not closed), the local
ports will be exhausted quickly.

>> and also switch from a mix of tabs and spaces to just tabs.
> 
> Please never mix unrelated whitespace cleanup into patches making real
> code changes.
>
OK.

>> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
>> index 5464818..97b6fc4 100644
>> --- a/net/ipv4/af_inet.c
>> +++ b/net/ipv4/af_inet.c
>> @@ -569,6 +569,11 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
>>   	if (uaddr->sa_family == AF_UNSPEC)
>>   		return sk->sk_prot->disconnect(sk, flags);
>>   
>> +	if (uaddr->sa_family != AF_INET)
>> +		return -EAFNOSUPPORT;
> 
> And what about IPv6 which also calls this function?
> 

Sorry that currently only ipv4 has been modified, we will continue to 
improve, and the v2 patch will be submitted later, thank you.


-- 
Best wishes£¬
Wen


>> +	if (addr_len < sizeof(struct sockaddr_in))
>> +		return -EINVAL;
>> +
>>   	if (BPF_CGROUP_PRE_CONNECT_ENABLED(sk)) {
>>   		err = sk->sk_prot->pre_connect(sk, uaddr, addr_len);
>>   		if (err)
