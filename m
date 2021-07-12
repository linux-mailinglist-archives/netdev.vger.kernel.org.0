Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576CC3C5C8F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhGLMsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:48:25 -0400
Received: from novek.ru ([213.148.174.62]:51920 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhGLMsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:48:25 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id DE5C8503D9C;
        Mon, 12 Jul 2021 15:43:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru DE5C8503D9C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626093801; bh=EtYW4qD/2YH4kIS7pgePjJXO+sUzvkxJzPl9620Jn94=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dzDh3sPFTsXNBxqCRDs9dzTwdf06myzrtx2z1QAXJXm7Om+EOjEFlew+satDPT0/L
         8ko0+JR+ADfkLcP4fOcewWZSd1vsgJ1MpvWhSj2Ea+DWDVussn+CkR2OXtfOdoobpQ
         cY4klyjDBSde2oTnQSFH0Qu3DRqKMO4svipEm/AQ=
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
To:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210712005554.26948-1-vfedorenko@novek.ru>
 <20210712005554.26948-3-vfedorenko@novek.ru>
 <4cf247328ea397c28c9c404094fb0f952a41f3c6.camel@redhat.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <161cf19b-6ed6-affb-ab67-e8627f6ed6d9@novek.ru>
Date:   Mon, 12 Jul 2021 13:45:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4cf247328ea397c28c9c404094fb0f952a41f3c6.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.07.2021 10:07, Paolo Abeni wrote:
> Hello,
> 
> On Mon, 2021-07-12 at 03:55 +0300, Vadim Fedorenko wrote:
>> Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
>> added checks for encapsulated sockets but it broke cases when there is
>> no implementation of encap_err_lookup for encapsulation, i.e. ESP in
>> UDP encapsulation. Fix it by calling encap_err_lookup only if socket
>> implements this method otherwise treat it as legal socket.
>>
>> Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
>> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>> ---
>>   net/ipv4/udp.c | 24 +++++++++++++++++++++++-
>>   net/ipv6/udp.c | 22 ++++++++++++++++++++++
>>   2 files changed, 45 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>> index e5cb7fedfbcd..4980e0f19990 100644
>> --- a/net/ipv4/udp.c
>> +++ b/net/ipv4/udp.c
>> @@ -707,7 +707,29 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
>>   	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
>>   			       iph->saddr, uh->source, skb->dev->ifindex,
>>   			       inet_sdif(skb), udptable, NULL);
>> -	if (!sk || udp_sk(sk)->encap_enabled) {
>> +	if (sk && udp_sk(sk)->encap_enabled) {
>> +		int (*lookup)(struct sock *sk, struct sk_buff *skb);
>> +
>> +		lookup = READ_ONCE(udp_sk(sk)->encap_err_lookup);
>> +		if (lookup) {
>> +			int network_offset, transport_offset;
>> +
>> +			network_offset = skb_network_offset(skb);
>> +			transport_offset = skb_transport_offset(skb);
>> +
>> +			/* Network header needs to point to the outer IPv4 header inside ICMP */
>> +			skb_reset_network_header(skb);
>> +
>> +			/* Transport header needs to point to the UDP header */
>> +			skb_set_transport_header(skb, iph->ihl << 2);
>> +			if (lookup(sk, skb))
>> +				sk = NULL;
>> +			skb_set_transport_header(skb, transport_offset);
>> +			skb_set_network_header(skb, network_offset);
>> +		}
>> +	}
>> +
>> +	if (!sk) {
>>   		/* No socket for error: try tunnels before discarding */
>>   		sk = ERR_PTR(-ENOENT);
>>   		if (static_branch_unlikely(&udp_encap_needed_key)) {
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index 798916d2e722..ed49a8589d9f 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -558,6 +558,28 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>>   
>>   	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
>>   			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
>> +	if (sk && udp_sk(sk)->encap_enabled) {
>> +		int (*lookup)(struct sock *sk, struct sk_buff *skb);
>> +
>> +		lookup = READ_ONCE(udp_sk(sk)->encap_err_lookup);
>> +		if (lookup) {
>> +			int network_offset, transport_offset;
>> +
>> +			network_offset = skb_network_offset(skb);
>> +			transport_offset = skb_transport_offset(skb);
>> +
>> +			/* Network header needs to point to the outer IPv6 header inside ICMP */
>> +			skb_reset_network_header(skb);
>> +
>> +			/* Transport header needs to point to the UDP header */
>> +			skb_set_transport_header(skb, offset);
>> +			if (lookup(sk, skb))
>> +				sk = NULL;
>> +			skb_set_transport_header(skb, transport_offset);
>> +			skb_set_network_header(skb, network_offset);
>> +		}
>> +	}
> 
> I can't follow this code. I guess that before d26796ae5894,
> __udp6_lib_err() used to invoke ICMP processing on the ESP in UDP
> socket, and after d26796ae5894 'sk' was cleared
> by __udp4_lib_err_encap(), is that correct?

Actually it was cleared just before __udp4_lib_err_encap() and after
it we totally loose the information of socket found by __udp4_lib_lookup()
because __udp4_lib_err_encap() uses different combination of ports
(source and destination ports are exchanged) and could find different
socket.

> 
> After this patch, the above chunk will not clear 'sk' for packets
> targeting ESP in UDP sockets, but AFAICS we will still enter the
> following conditional, preserving the current behavior - no ICMP
> processing.

We will not enter following conditional for ESP in UDP case because
there is no more check for encap_type or encap_enabled. Just for
case of no udp socket as it was before d26796ae5894. But we still
have to check if the socket found by __udp4_lib_lookup() is correct
for received ICMP packet that's why I added code about encap_err_lookup.

I maybe missing something but d26796ae5894 doesn't actually explain
which particular situation should be avoided by this additional check
and no tests were added to simply reproduce the problem. If you can
explain it a bit more it would greatly help me to improve the fix.

Thanks
> 
> Can you please clarify?
> 
> Why can't you use something alike the following instead?
> 
> ---
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index c0f9f3260051..96a3b640e4da 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -707,7 +707,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
>          sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
>                                 iph->saddr, uh->source, skb->dev->ifindex,
>                                 inet_sdif(skb), udptable, NULL);
> -       if (!sk || udp_sk(sk)->encap_type) {
> +       if (!sk || READ_ONCE(udp_sk(sk)->encap_err_lookup)) {
>                  /* No socket for error: try tunnels before discarding */
>                  sk = ERR_PTR(-ENOENT);
>                  if (static_branch_unlikely(&udp_encap_needed_key)) {
> 
> ---
> 
> Thanks!
> 
> /P
> 

