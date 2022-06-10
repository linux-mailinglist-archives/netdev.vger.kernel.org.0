Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5090D545CDA
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346297AbiFJHIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbiFJHIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:08:48 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF39423D5C0;
        Fri, 10 Jun 2022 00:08:46 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzYl8-00070W-6F; Fri, 10 Jun 2022 09:08:42 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzYl7-000SZb-On; Fri, 10 Jun 2022 09:08:41 +0200
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Jon Maxwell <jmaxwell37@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, joe@cilium.io, i@lmb.io,
        bpf@vger.kernel.org
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
 <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
 <20220610001743.z5nxapagwknlfjqi@kafai-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <76972cdc-6a3c-2052-f353-06ebd2d61eca@iogearbox.net>
Date:   Fri, 10 Jun 2022 09:08:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220610001743.z5nxapagwknlfjqi@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26567/Thu Jun  9 10:06:06 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 2:17 AM, Martin KaFai Lau wrote:
> On Thu, Jun 09, 2022 at 10:29:15PM +0200, Daniel Borkmann wrote:
>> On 6/9/22 3:18 AM, Jon Maxwell wrote:
>>> A customer reported a request_socket leak in a Calico cloud environment. We
>>> found that a BPF program was doing a socket lookup with takes a refcnt on
>>> the socket and that it was finding the request_socket but returning the parent
>>> LISTEN socket via sk_to_full_sk() without decrementing the child request socket
>>> 1st, resulting in request_sock slab object leak. This patch retains the
> Great catch and debug indeed!
> 
>>> existing behaviour of returning full socks to the caller but it also decrements
>>> the child request_socket if one is present before doing so to prevent the leak.
>>>
>>> Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
>>> thanks to Antoine Tenart for the reproducer and patch input.
>>>
>>> Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
>>> Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> Instead of the above commits, I think this dated back to
> 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> 
>>> Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
>>> Co-developed-by: Antoine Tenart <atenart@kernel.org>
>>> Signed-off-by:: Antoine Tenart <atenart@kernel.org>
>>> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
>>> ---
>>>    net/core/filter.c | 20 ++++++++++++++------
>>>    1 file changed, 14 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index 2e32cee2c469..e3c04ae7381f 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>>>    {
>>>    	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
>>>    					   ifindex, proto, netns_id, flags);
>>> +	struct sock *sk1 = sk;
>>>    	if (sk) {
>>>    		sk = sk_to_full_sk(sk);
>>> -		if (!sk_fullsock(sk)) {
>>> -			sock_gen_put(sk);
>>> +		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
>>> +		 * sock refcnt is decremented to prevent a request_sock leak.
>>> +		 */
>>> +		if (!sk_fullsock(sk1))
>>> +			sock_gen_put(sk1);
>>> +		if (!sk_fullsock(sk))
> In this case, sk1 == sk (timewait).  It is a bit worrying to pass
> sk to sk_fullsock(sk) after the above sock_gen_put().
> I think Daniel's 'if (sk2 != sk) { sock_gen_put(sk); }' check is better.
> 
>> [ +Martin/Joe/Lorenz ]
>>
>> I wonder, should we also add some asserts in here to ensure we don't get an unbalance for the
>> bpf_sk_release() case later on? Rough pseudocode could be something like below:
>>
>> static struct sock *
>> __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>>                  struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
>>                  u64 flags)
>> {
>>          struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
>>                                             ifindex, proto, netns_id, flags);
>>          if (sk) {
>>                  struct sock *sk2 = sk_to_full_sk(sk);
>>
>>                  if (!sk_fullsock(sk2))
>>                          sk2 = NULL;
>>                  if (sk2 != sk) {
>>                          sock_gen_put(sk);
>>                          if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
> I don't think it matters if the helper-returned sk2 is refcounted or not (SOCK_RCU_FREE).
> The verifier has ensured the bpf_sk_lookup() and bpf_sk_release() are
> always balanced regardless of the type of sk2.
> 
> bpf_sk_release() will do the right thing to check the sk2 is refcounted or not
> before calling sock_gen_put().
> 
> The bug here is the helper forgot to call sock_gen_put(sk) while
> the verifier only tracks the sk2, so I think the 'if (unlikely...) { WARN_ONCE(...); }'
> can be saved.

I was mainly thinking given in sk_lookup() we have the check around `sk && !refcounted &&
!sock_flag(sk, SOCK_RCU_FREE)` to check for unreferenced non-SOCK_RCU_FREE socket, and
given sk_to_full_sk() can return inet_reqsk(sk)->rsk_listener we don't have a similar
assertion there. Given we don't bump any ref on the latter, it must be SOCK_RCU_FREE then
as otherwise latter call to bpf_sk_release() will unbalance sk2. @Jon: maybe lets just
manually verify that such sk2 has SOCK_RCU_FREE and state it in the commit message for
future reference then, either is fine with me. Thanks!

>>                                  WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
>>                                  sk2 = NULL;
>>                          }
>>                  }
>>                  sk = sk2;
>>          }
>>          return sk;
>> }

