Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72173B5074
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 01:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFZXXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 19:23:41 -0400
Received: from novek.ru ([213.148.174.62]:39374 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhFZXXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 19:23:41 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 13F62503CB8;
        Sun, 27 Jun 2021 02:19:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 13F62503CB8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624749557; bh=HGkuypySFrOMd390va8Z8pxZ26jYBQlX0s9VKZbWhug=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TxbtS18+YDLyJxswRALN5FZLX3RLZzR0WJKvaU9xrOJ2Y1YXBB+K4rQgZhZE2M6I9
         aPwBMr0nh5QCwko+c1yKDusMngZ9iTKiTBlAxl33EtmHVtzxRQacwGxbnOA5xKGs4B
         iifcAbjbgx5reifkel0xZ6eq4DlTusqeAFDfwjYM=
Subject: Re: [PATCH net v2] net: lwtunnel: handle MTU calculation in forwading
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210625162139.9067-1-vfedorenko@novek.ru>
 <afc66439-d288-c2ea-f129-c9833d8a4d89@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <098bdb2d-aba1-0838-eae1-098848d174b1@novek.ru>
Date:   Sun, 27 Jun 2021 00:21:13 +0100
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
pmtu.sh tests are ok for everything except OVS which are skipped on my test system.
