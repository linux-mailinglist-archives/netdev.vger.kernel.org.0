Return-Path: <netdev+bounces-5473-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 404527117C6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 22:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C7112815DF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9571624157;
	Thu, 25 May 2023 20:01:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5D3FC05;
	Thu, 25 May 2023 20:01:18 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7757895;
	Thu, 25 May 2023 13:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=nqfhm3/Yv5prAaAJ3hLzCTN2dKkIp+erbKr/gQI7qtE=; b=HDLoT+2z2oyn1lpV6boByRvq0B
	ssnHAwUL8qfkkR0wmfBHbhRowm5fQdTtJqQ9zqhRmuz1XaWy6Ln7+rAu5po+Lmpx9sBXTVHdZETE/
	Mk5yY/q6l7oaKOWnK16xkeHVczkDp0Ndpl/lf5fveWhxxq5oft2IikFtcuzeGW3EaokONEGiN/Opg
	tcaJYmrmOvH9EHlQaywLLzT1ag+S4i4vMvMfl/9s3MvkWj/6a8KXQumR8quO3e4cOjlPdq35CNqlX
	q5+N8wIeHk9VImG40lii0oygOVjO39OSgFLOEMcvslER6QxS067b7aJKJ9EcPmeHKe9GMnHnvUvmM
	bnOWDWcA==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q2H93-0001Bo-V8; Thu, 25 May 2023 22:01:09 +0200
Received: from [178.197.248.42] (helo=linux.home)
	by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q2H92-000XIa-Sz; Thu, 25 May 2023 22:01:08 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf, net: Support SO_REUSEPORT sockets with
 bpf_sk_assign
To: Kuniyuki Iwashima <kuniyu@amazon.com>, lmb@isovalent.com
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 haoluo@google.com, joe@cilium.io, joe@wand.net.nz, john.fastabend@gmail.com,
 jolsa@kernel.org, kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
 linux-kernel@vger.kernel.org, martin.lau@linux.dev, netdev@vger.kernel.org,
 pabeni@redhat.com, sdf@google.com, song@kernel.org,
 willemdebruijn.kernel@gmail.com, yhs@fb.com
References: <20230525081923.8596-1-lmb@isovalent.com>
 <20230525174131.4706-1-kuniyu@amazon.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <99681548-fa79-0607-d574-db61818cab78@iogearbox.net>
Date: Thu, 25 May 2023 22:01:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230525174131.4706-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26918/Thu May 25 09:25:14 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/25/23 7:41 PM, Kuniyuki Iwashima wrote:
> From: Lorenz Bauer <lmb@isovalent.com>
> Date: Thu, 25 May 2023 09:19:22 +0100
>> Currently the bpf_sk_assign helper in tc BPF context refuses SO_REUSEPORT
>> sockets. This means we can't use the helper to steer traffic to Envoy, which
>> configures SO_REUSEPORT on its sockets. In turn, we're blocked from removing
>> TPROXY from our setup.
>>
>> The reason that bpf_sk_assign refuses such sockets is that the bpf_sk_lookup
>> helpers don't execute SK_REUSEPORT programs. Instead, one of the
>> reuseport sockets is selected by hash. This could cause dispatch to the
>> "wrong" socket:
>>
>>      sk = bpf_sk_lookup_tcp(...) // select SO_REUSEPORT by hash
>>      bpf_sk_assign(skb, sk) // SK_REUSEPORT wasn't executed
>>
>> Fixing this isn't as simple as invoking SK_REUSEPORT from the lookup
>> helpers unfortunately. In the tc context, L2 headers are at the start
>> of the skb, while SK_REUSEPORT expects L3 headers instead.
>>
>> Instead, we execute the SK_REUSEPORT program when the assigned socket
>> is pulled out of the skb, further up the stack. This creates some
>> trickiness with regards to refcounting as bpf_sk_assign will put both
>> refcounted and RCU freed sockets in skb->sk. reuseport sockets are RCU
>> freed. We can infer that the sk_assigned socket is RCU freed if the
>> reuseport lookup succeeds, but convincing yourself of this fact isn't
>> straight forward. Therefore we defensively check refcounting on the
>> sk_assign sock even though it's probably not required in practice.
>>
>> Fixes: 8e368dc ("bpf: Fix use of sk->sk_reuseport from sk_assign")
>> Fixes: cf7fbe6 ("bpf: Add socket assign support")
> 
> Please use 12 chars of hash.
> 
> $ cat ~/.gitconfig
> [core]
> 	abbrev = 12
> [pretty]
> 	fixes = Fixes: %h (\"%s\")
> 
> $ git show 8e368dc --pretty=fixes | head -n 1
> Fixes: 8e368dc72e86 ("bpf: Fix use of sk->sk_reuseport from sk_assign")

Yeap, not quite sure what happened here but the 12 chars is clear. Will
be fixed up in v2, too, ofc.

>> Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
>> Cc: Joe Stringer <joe@cilium.io>
>> Link: https://lore.kernel.org/bpf/CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com/
>> ---
>>   include/net/inet6_hashtables.h | 36 +++++++++++++++++++++++++++++-----
>>   include/net/inet_hashtables.h  | 27 +++++++++++++++++++++++--
>>   include/net/sock.h             |  7 +++++--
>>   include/uapi/linux/bpf.h       |  3 ---
>>   net/core/filter.c              |  2 --
>>   net/ipv4/inet_hashtables.c     | 15 +++++++-------
>>   net/ipv4/udp.c                 | 23 +++++++++++++++++++---
>>   net/ipv6/inet6_hashtables.c    | 19 +++++++++---------
>>   net/ipv6/udp.c                 | 23 +++++++++++++++++++---
>>   tools/include/uapi/linux/bpf.h |  3 ---
>>   10 files changed, 119 insertions(+), 39 deletions(-)
>>
[...]
>> @@ -85,14 +92,33 @@ static inline struct sock *__inet6_lookup_skb(struct inet_hashinfo *hashinfo,
>>   					      int iif, int sdif,
>>   					      bool *refcounted)
>>   {
>> -	struct sock *sk = skb_steal_sock(skb, refcounted);
>> -
>> +	bool prefetched;
>> +	struct sock *sk = skb_steal_sock(skb, refcounted, &prefetched);
>> +	struct net *net = dev_net(skb_dst(skb)->dev);
>> +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> 
> nit: Reverse Xmas Tree order.  Same for other chunks.

It is, the prefetched bool is simply used one line below. I don't think
this is much different than most other code from style pov..

>> +
>> +	if (prefetched) {
>> +		struct sock *reuse_sk = inet6_lookup_reuseport(net, sk, skb, doff,
>> +							       &ip6h->saddr, sport,
>> +							       &ip6h->daddr, ntohs(dport));
>> +		if (reuse_sk) {
>> +			if (reuse_sk != sk) {
>> +				if (*refcounted) {
>> +					sock_put(sk);
>> +					*refcounted = false;
>> +				}
>> +				if (IS_ERR(reuse_sk))
>> +					return NULL;
>> +			}
>> +			return reuse_sk;
>> +		}
> 
> Maybe we can add a hepler to avoid this duplication ?

We'll check if it can be made a bit nicer and integrate this into the v2.

Thanks,
Daniel

