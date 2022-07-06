Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012E5568C0F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiGFPAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiGFPAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:00:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D724252A5
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 08:00:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 060EAB81D4C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 15:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497C6C341C6;
        Wed,  6 Jul 2022 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657119600;
        bh=4zEq8wxOZye+2sH4DJQIkdmlggQtJVHshXMnVKIvaIA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HELIzoT/hLiyElXtaVHhcNOJBYWmZ2pp9O3tHpzI+nBv7hPPulGMTh/ob6LlMeGWB
         UR+LDdwmFnpNCZr2N2djPqcX7HmtZ8lPFinFmQoQLqT0c47NLCBaTEqJj0Qrry6Qy9
         igGSw5TfWS4ztvZLMdRdFhjHbKrMeBqyZLNuQePzairXrzB61T0hzfb/IYL1D+cQni
         rkzQVgi4FgB3e/MImv2UJc4c2RzFIVypFtbgoI5YC1mLg6+ncPDK3OCbbVnCCFR+Gp
         OPGAra1oEsVvggwXux6TUIr74zCmgmqx6SoUkRveQzRXyig5C3OlPKzjpFh2tZ2w8R
         60Z063+8oDx+Q==
Message-ID: <00116bab-22c5-0bce-d82b-a10eb95e7daa@kernel.org>
Date:   Wed, 6 Jul 2022 08:59:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3 net-next] net: Find dst with sk's xfrm policy not
 ctl_sk
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>, Sewook Seo <ssewook@gmail.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
References: <20220621202240.4182683-1-ssewook@gmail.com>
 <20220706063243.2782818-1-ssewook@gmail.com>
 <CANn89iJiod_=AGbKM=-5cGvDQjUzxLm88Zg6UU2T8Mvj6nAcOQ@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89iJiod_=AGbKM=-5cGvDQjUzxLm88Zg6UU2T8Mvj6nAcOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 1:19 AM, Eric Dumazet wrote:
> On Wed, Jul 6, 2022 at 8:34 AM Sewook Seo <ssewook@gmail.com> wrote:
>>
>> From: sewookseo <sewookseo@google.com>
>>
>> If we set XFRM security policy by calling setsockopt with option
>> IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
>> struct. However tcp_v6_send_response doesn't look up dst_entry with the
>> actual socket but looks up with tcp control socket. This may cause a
>> problem that a RST packet is sent without ESP encryption & peer's TCP
>> socket can't receive it.
>> This patch will make the function look up dest_entry with actual socket,
>> if the socket has XFRM policy(sock_policy), so that the TCP response
>> packet via this function can be encrypted, & aligned on the encrypted
>> TCP socket.
>>
>> Tested: We encountered this problem when a TCP socket which is encrypted
>> in ESP transport mode encryption, receives challenge ACK at SYN_SENT
>> state. After receiving challenge ACK, TCP needs to send RST to
>> establish the socket at next SYN try. But the RST was not encrypted &
>> peer TCP socket still remains on ESTABLISHED state.
>> So we verified this with test step as below.
>> [Test step]
>> 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHED).
>> 2. Client tries a new connection on the same TCP ports(src & dst).
>> 3. Server will return challenge ACK instead of SYN,ACK.
>> 4. Client will send RST to server to clear the SOCKET.
>> 5. Client will retransmit SYN to server on the same TCP ports.
>> [Expected result]
>> The TCP connection should be established.
>>
>> Effort: net
> 
> Please remove this Effort: tag, this is not appropriate for upstream patches.
> 
>> Cc: Maciej Żenczykowski <maze@google.com>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Steffen Klassert <steffen.klassert@secunet.com>
>> Cc: Sehee Lee <seheele@google.com>
>> Signed-off-by: Sewook Seo <sewookseo@google.com>
>> ---
>>  net/ipv4/ip_output.c | 7 ++++++-
>>  net/ipv4/tcp_ipv4.c  | 5 +++++
>>  net/ipv6/tcp_ipv6.c  | 7 ++++++-
>>  3 files changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>> index 00b4bf26fd93..1da430c8fee2 100644
>> --- a/net/ipv4/ip_output.c
>> +++ b/net/ipv4/ip_output.c
>> @@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
>>                            tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
>>                            arg->uid);
>>         security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
>> -       rt = ip_route_output_key(net, &fl4);
>> +#ifdef CONFIG_XFRM
>> +       if (sk->sk_policy[XFRM_POLICY_OUT])
>> +               rt = ip_route_output_flow(net, &fl4, sk);
>> +       else
>> +#endif
>> +               rt = ip_route_output_key(net, &fl4);
> 
> I really do not like adding more #ifdef
> 
> What happens if we simply use :
> 
>       rt = ip_route_output_flow(net, &fl4, sk);
> 

That should be fine - and simpler solution.


>> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
>> index c72448ba6dc9..8b8819c3d2c2 100644
>> --- a/net/ipv6/tcp_ipv6.c
>> +++ b/net/ipv6/tcp_ipv6.c
>> @@ -952,7 +952,12 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
>>          * Underlying function will use this to retrieve the network
>>          * namespace
>>          */
>> -       dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
>> +#ifdef CONFIG_XFRM
>> +       if (sk && sk->sk_policy[XFRM_POLICY_OUT] && sk_fullsock(sk))
>> +               dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);  /* Get dst with sk's XFRM policy */
>> +       else
>> +#endif
>> +               dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
> 
> and then:
> 
>      dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);

same here.
