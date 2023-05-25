Return-Path: <netdev+bounces-5471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA117117A9
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 570051C20F19
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955FA2414F;
	Thu, 25 May 2023 19:51:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832401DDED;
	Thu, 25 May 2023 19:51:53 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BEA12F;
	Thu, 25 May 2023 12:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=51vGjxfu+4jotgoJPqTXpcFpuWreFBe0vTvfgLveh0Y=; b=WzVLUJN1dYmV1mynMoZwi8ICIP
	NtA2lShoTygqgtpXYkIe5sF+5WXFcm+Jej6ktbE0g1HpXQY48uBsUku8kaEZnZPk+afyRbucGHlVH
	IfnoX6xV203VqkBQlAt+SCGwYq/twxrjzXsLXbvklVi1JjmcvcH5dEn+z/QM2PS/JZbLwSmIZSCci
	fe3qpg/sqS71PwAhakT6qeoQWcR+2gyRal1XLChNGtkmorNg2tkzOHienaazOQTRiuvJVroRFkYkX
	AcA3vPn2CAWVu84iHYg7djTtkD0KeJXqDLmaZbYy/F67zzhxODejLfgFcO0KvCMUgjDfUXszBFvYH
	U8jC/61A==;
Received: from sslproxy04.your-server.de ([78.46.152.42])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q2GzU-0000BH-Lm; Thu, 25 May 2023 21:51:16 +0200
Received: from [178.197.248.42] (helo=linux.home)
	by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q2GzT-00018s-Nw; Thu, 25 May 2023 21:51:15 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf, net: Support SO_REUSEPORT sockets with
 bpf_sk_assign
To: Eric Dumazet <edumazet@google.com>, Lorenz Bauer <lmb@isovalent.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>,
 KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>,
 Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
 David Ahern <dsahern@kernel.org>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Joe Stringer <joe@wand.net.nz>, Joe Stringer <joe@cilium.io>,
 Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20230525081923.8596-1-lmb@isovalent.com>
 <CANn89iJx74gR7Xuahd0S3pLXYC8EX6+JRkbt6T_bemMX-8zyig@mail.gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a71b8941-1ffc-37fc-6676-d3b4cf44f149@iogearbox.net>
Date: Thu, 25 May 2023 21:51:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CANn89iJx74gR7Xuahd0S3pLXYC8EX6+JRkbt6T_bemMX-8zyig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26918/Thu May 25 09:25:14 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/25/23 3:24 PM, Eric Dumazet wrote:
> On Thu, May 25, 2023 at 10:19 AM Lorenz Bauer <lmb@isovalent.com> wrote:
>>
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
> 
> 
>> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
>> index e7391bf310a7..920131e4a65d 100644
>> --- a/net/ipv4/inet_hashtables.c
>> +++ b/net/ipv4/inet_hashtables.c
>> @@ -332,10 +332,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
>>          return score;
>>   }
>>
>> -static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
>> -                                           struct sk_buff *skb, int doff,
>> -                                           __be32 saddr, __be16 sport,
>> -                                           __be32 daddr, unsigned short hnum)
>> +struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
>> +                                  struct sk_buff *skb, int doff,
>> +                                  __be32 saddr, __be16 sport,
>> +                                  __be32 daddr, unsigned short hnum)
>>   {
>>          struct sock *reuse_sk = NULL;
>>          u32 phash;
>> @@ -346,6 +346,7 @@ static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
>>          }
>>          return reuse_sk;
>>   }
>> +EXPORT_SYMBOL_GPL(inet_lookup_reuseport);
>>
>>   /*
>>    * Here are some nice properties to exploit here. The BSD API
>> @@ -369,8 +370,8 @@ static struct sock *inet_lhash2_lookup(struct net *net,
>>          sk_nulls_for_each_rcu(sk, node, &ilb2->nulls_head) {
>>                  score = compute_score(sk, net, hnum, daddr, dif, sdif);
>>                  if (score > hiscore) {
>> -                       result = lookup_reuseport(net, sk, skb, doff,
>> -                                                 saddr, sport, daddr, hnum);
>> +                       result = inet_lookup_reuseport(net, sk, skb, doff,
>> +                                                      saddr, sport, daddr, hnum);
>>                          if (result)
>>                                  return result;
>>
> 
> Please split in a series.
> 
> First a patch renaming lookup_reuseport() to inet_lookup_reuseport()
> and inet6_lookup_reuseport()
> (cleanup, no change in behavior)
> 
> This would ease review and future bug hunting quite a bit.

Makes sense and should reduce the churn on the actual change.

I think Lorenz is planning to flush out a v2 next week with this split.

Thanks,
Daniel

