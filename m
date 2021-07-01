Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990A33B8F95
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 11:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhGAJQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 05:16:35 -0400
Received: from novek.ru ([213.148.174.62]:40094 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235088AbhGAJQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 05:16:34 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D4C06503B07;
        Thu,  1 Jul 2021 12:11:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D4C06503B07
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1625130720; bh=ZssubnTsRYCGHXANQcA+xAsy3JW6+np0OSyPXXlcPkk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=zEOztgpcx6gOtCNY2LbAQ+ykbcdYhEbpHbqAS7CbBJpn1oD8b70olgPu5fhTKeXOT
         FPSF95OAx0yEYrGB9dUES1yqgnOa9IHDh9qMNFojFZY4x27kHAEHAVLzfth0hijJqh
         SrJ6lvxjBAU0LUHt9vVAoN7+D6F0fnksIBf/PIKc=
Subject: Re: [RFC net-next 2/2] net: ipv4: Consolidate ipv4_mtu and
 ip_dst_mtu_maybe_forward
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20210701011728.22626-1-vfedorenko@novek.ru>
 <20210701011728.22626-3-vfedorenko@novek.ru>
 <424dcef7-9d5e-ce3a-d9af-190ffca2a093@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <1e6bea71-d1f4-0b4a-2cba-6e48d483ed5f@novek.ru>
Date:   Thu, 1 Jul 2021 10:14:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <424dcef7-9d5e-ce3a-d9af-190ffca2a093@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.2021 02:40, David Ahern wrote:
> On 6/30/21 7:17 PM, Vadim Fedorenko wrote:
>> Consolidate IPv4 MTU code the same way it is done in IPv6 to have code
>> aligned in both address families
>>
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>> ---
>>   include/net/ip.h | 22 ++++++++++++++++++----
>>   net/ipv4/route.c | 21 +--------------------
>>   2 files changed, 19 insertions(+), 24 deletions(-)
>>
>> diff --git a/include/net/ip.h b/include/net/ip.h
>> index d9683bef8684..ed261f2a40ac 100644
>> --- a/include/net/ip.h
>> +++ b/include/net/ip.h
>> @@ -436,18 +436,32 @@ static inline bool ip_sk_ignore_df(const struct sock *sk)
>>   static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>>   						    bool forwarding)
>>   {
>> +	const struct rtable *rt = (const struct rtable *)dst;
> 
> I realize this a code move from ipv4_mtu, but please use container_of
> here; I have been removing the typecasts as code is changed.
> 
No problem, I will change in next iteration

