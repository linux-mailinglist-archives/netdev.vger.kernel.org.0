Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9583B504E
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 23:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFZVnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 17:43:49 -0400
Received: from novek.ru ([213.148.174.62]:39140 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230151AbhFZVns (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 17:43:48 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 7D794503CB8;
        Sun, 27 Jun 2021 00:39:23 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 7D794503CB8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624743564; bh=xBbDc27JAwZmHTwc0ebKXdc1RR2VWjTOa10i8t+JmhA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YtBAyAS6OUjBPAYepJF9LCUUuoKGBjt7EItb/I5hSx3Ii7HoioaP9zFexUjfrLboN
         6d3kDNtAnMmS04Uf6sNzCmdUChEGLk0S6pbeiEVwzq5OojIghhqNFno8gUPdY9Q60e
         lDHnAqr+srLm3p3+Og0k/5e1VjKXprQt0kyU0k0M=
Subject: Re: [PATCH net v2] net: lwtunnel: handle MTU calculation in forwading
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210625162139.9067-1-vfedorenko@novek.ru>
 <afc66439-d288-c2ea-f129-c9833d8a4d89@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <65961d37-9f7f-631c-2293-aa1193aca83b@novek.ru>
Date:   Sat, 26 Jun 2021 22:41:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <afc66439-d288-c2ea-f129-c9833d8a4d89@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.06.2021 18:18, David Ahern wrote:
> [ added Roopa's nvidia address ]
> 
> On 6/25/21 10:21 AM, Vadim Fedorenko wrote:
>> Commit 14972cbd34ff ("net: lwtunnel: Handle fragmentation") moved
>> fragmentation logic away from lwtunnel by carry encap headroom and
>> use it in output MTU calculation. But the forwarding part was not
>> covered and created difference in MTU for output and forwarding and
>> further to silent drops on ipv4 forwarding path. Fix it by taking
>> into account lwtunnel encap headroom.
>>
>> The same commit also introduced difference in how to treat RTAX_MTU
>> in IPv4 and IPv6 where latter explicitly removes lwtunnel encap
>> headroom from route MTU. Make IPv4 version do the same.
>>
>> Fixes: 14972cbd34ff ("net: lwtunnel: Handle fragmentation")
>> Suggested-by: David Ahern <dsahern@gmail.com>
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>> ---
>>   include/net/ip.h        | 12 ++++++++----
>>   include/net/ip6_route.h | 16 ++++++++++++----
>>   net/ipv4/route.c        |  3 ++-
>>   3 files changed, 22 insertions(+), 9 deletions(-)
>>
> 
> 
> I think this is the right approach - tunnel overhead should always be
> considered for the mtu. Did you run the pmtu.sh selftests to make sure
> those still work?
> 

Actually not, I was running my own tests of routing configurations with 
different types of tunnels like GRE, GUE and FOU with mpls lwtunnels to check 
consistency of calculated mtus.

Will re-run pmtu.sh but I my installation doesn't support OVS right now.

Also, I was thinking about this RTAX_MTU and I'm really in doubt. Do we actually 
want the situation when
   ip route A.B.C.D/32 encap mpls 100 dev ip6tnl1 mtu 1400
will actually require mtu=1396? Because this looks like not clear for users I 
suppose.
