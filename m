Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA955455A3
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245178AbiFIU3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbiFIU32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:29:28 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593E327234F;
        Thu,  9 Jun 2022 13:29:20 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzOmK-000AgO-G9; Thu, 09 Jun 2022 22:29:16 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzOmK-000MoD-5H; Thu, 09 Jun 2022 22:29:16 +0200
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Jon Maxwell <jmaxwell37@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, kafai@fb.com, joe@cilium.io,
        i@lmb.io, bpf@vger.kernel.org
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
Date:   Thu, 9 Jun 2022 22:29:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220609011844.404011-1-jmaxwell37@gmail.com>
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

On 6/9/22 3:18 AM, Jon Maxwell wrote:
> A customer reported a request_socket leak in a Calico cloud environment. We
> found that a BPF program was doing a socket lookup with takes a refcnt on
> the socket and that it was finding the request_socket but returning the parent
> LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> 1st, resulting in request_sock slab object leak. This patch retains the
> existing behaviour of returning full socks to the caller but it also decrements
> the child request_socket if one is present before doing so to prevent the leak.
> 
> Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> thanks to Antoine Tenart for the reproducer and patch input.
> 
> Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> Co-developed-by: Antoine Tenart <atenart@kernel.org>
> Signed-off-by:: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>   net/core/filter.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2e32cee2c469..e3c04ae7381f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>   {
>   	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
>   					   ifindex, proto, netns_id, flags);
> +	struct sock *sk1 = sk;
>   
>   	if (sk) {
>   		sk = sk_to_full_sk(sk);
> -		if (!sk_fullsock(sk)) {
> -			sock_gen_put(sk);
> +		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> +		 * sock refcnt is decremented to prevent a request_sock leak.
> +		 */
> +		if (!sk_fullsock(sk1))
> +			sock_gen_put(sk1);
> +		if (!sk_fullsock(sk))
>   			return NULL;

[ +Martin/Joe/Lorenz ]

I wonder, should we also add some asserts in here to ensure we don't get an unbalance for the
bpf_sk_release() case later on? Rough pseudocode could be something like below:

static struct sock *
__bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
                 struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
                 u64 flags)
{
         struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
                                            ifindex, proto, netns_id, flags);
         if (sk) {
                 struct sock *sk2 = sk_to_full_sk(sk);

                 if (!sk_fullsock(sk2))
                         sk2 = NULL;
                 if (sk2 != sk) {
                         sock_gen_put(sk);
                         if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
                                 WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
                                 sk2 = NULL;
                         }
                 }
                 sk = sk2;
         }
         return sk;
}

Thanks,
Daniel
