Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F97C3C5DF1
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhGLOIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:08:43 -0400
Received: from novek.ru ([213.148.174.62]:54172 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhGLOIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 10:08:43 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 9E154503DAF;
        Mon, 12 Jul 2021 17:03:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 9E154503DAF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626098619; bh=HD6LZfhYrqWB3Lr4upgJjF2rkoAMfYRfzy9KJ6VQ8o0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=b0gQ2Y6610Smsq58aav//EtnxdtSszy9i1SIoiqzmSUZtZ0tgLAam2bMNuyGMDVsd
         vDLPNgAT/x0OtQuPnyXv9C0tgLl7eEz3CxqpnRHrd+EasL+bvB5on/7dJoMcChusNK
         dTfS1JzWriDo/sSFFQLP7gSLfV1WuQKXhGWupDzM=
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
To:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210712005554.26948-1-vfedorenko@novek.ru>
 <20210712005554.26948-3-vfedorenko@novek.ru>
 <4cf247328ea397c28c9c404094fb0f952a41f3c6.camel@redhat.com>
 <161cf19b-6ed6-affb-ab67-e8627f6ed6d9@novek.ru>
 <cb9830bd8ef1edc3b5a5f11546618cd50ed82f21.camel@redhat.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <74c28a85-ad6d-0b33-b5be-90b1bff7ca52@novek.ru>
Date:   Mon, 12 Jul 2021 15:05:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cb9830bd8ef1edc3b5a5f11546618cd50ed82f21.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.07.2021 14:37, Paolo Abeni wrote:
> On Mon, 2021-07-12 at 13:45 +0100, Vadim Fedorenko wrote:
>>
>>> After this patch, the above chunk will not clear 'sk' for packets
>>> targeting ESP in UDP sockets, but AFAICS we will still enter the
>>> following conditional, preserving the current behavior - no ICMP
>>> processing.
>>
>> We will not enter following conditional for ESP in UDP case because
>> there is no more check for encap_type or encap_enabled.
> 
> I see. You have a bug in the ipv6 code-path. With your patch applied:
> 
> ---
>   	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
>                                 inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
>          if (sk && udp_sk(sk)->encap_enabled) {
> 		//...
>          }
> 
>          if (!sk || udp_sk(sk)->encap_enabled) {
> 	// can still enter here...
> ---	
> 

Oh, my bad, thanks for catching this!

>> I maybe missing something but d26796ae5894 doesn't actually explain
>> which particular situation should be avoided by this additional check
>> and no tests were added to simply reproduce the problem. If you can
>> explain it a bit more it would greatly help me to improve the fix.
> 
> Xin knows better, but AFAICS it used to cover the situation you
> explicitly tests in patch 3/3 - incoming packet with src-port == dst-
> port == tunnel port - for e.g. vxlan tunnels.
>

Ok, so my assumption was like yours, that's good.

>>> Why can't you use something alike the following instead?
>>>
>>> ---
>>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>>> index c0f9f3260051..96a3b640e4da 100644
>>> --- a/net/ipv4/udp.c
>>> +++ b/net/ipv4/udp.c
>>> @@ -707,7 +707,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
>>>           sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
>>>                                  iph->saddr, uh->source, skb->dev->ifindex,
>>>                                  inet_sdif(skb), udptable, NULL);
>>> -       if (!sk || udp_sk(sk)->encap_type) {
>>> +       if (!sk || READ_ONCE(udp_sk(sk)->encap_err_lookup)) {
>>>                   /* No socket for error: try tunnels before discarding */
>>>                   sk = ERR_PTR(-ENOENT);
>>>                   if (static_branch_unlikely(&udp_encap_needed_key)) {
>>>
>>> ---
> 
> Could you please have a look at the above ?
> 
Sure. The main problem I see here is that udp4_lib_lookup in udp_lib_err_encap
could return different socket because of different source and destination port
and in this case we will never check for correctness of originally found socket,
i.e. encap_err_lookup will never be called and the ICMP notification will never
be applied to that socket even if it passes checks.
My point is that it's simplier to explicitly check socket that was found than
rely on the result of udp4_lib_lookup with different inputs and leave the case
of no socket as it was before d26796ae5894.

If it's ok, I will unify the code for check as Willem suggested and resend v2.

