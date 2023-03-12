Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166EA6B6599
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 12:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjCLLm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 07:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLLm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 07:42:58 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5FA18E
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 04:42:55 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pbK6D-0004cZ-5Q; Sun, 12 Mar 2023 12:42:49 +0100
Message-ID: <533d3c1a-db7e-6ff2-1fdf-fb8bbbb7a14c@leemhuis.info>
Date:   Sun, 12 Mar 2023 12:42:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v1 net 1/2] tcp: Fix bind() conflict check for dual-stack
 wildcard address.
Content-Language: en-US, de-DE
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Paul Holzinger <pholzing@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <20230312031904.4674-1-kuniyu@amazon.com>
 <20230312031904.4674-2-kuniyu@amazon.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <20230312031904.4674-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678621376;f84c8b11;
X-HE-SMSGID: 1pbK6D-0004cZ-5Q
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thx for working on this. There is one small detail to improve:

On 12.03.23 04:19, Kuniyuki Iwashima wrote:
> Paul Holzinger reported [0] that commit 5456262d2baa ("net: Fix
> incorrect address comparison when searching for a bind2 bucket")
> introduced a bind() regression.  Paul also gave a nice repro that
> calls two types of bind() on the same port, both of which now
> succeed, but the second call should fail:
> 
>   bind(fd1, ::, port) + bind(fd2, 127.0.0.1, port)
> 
> The cited commit added address family tests in three functions to
> fix the uninit-value KMSAN report. [1]  However, the test added to
> inet_bind2_bucket_match_addr_any() removed a necessary conflict
> check; the dual-stack wildcard address no longer conflicts with
> an IPv4 non-wildcard address.
> 
> If tb->family is AF_INET6 and sk->sk_family is AF_INET in
> inet_bind2_bucket_match_addr_any(), we still need to check
> if tb has the dual-stack wildcard address.
> 
> Note that the IPv4 wildcard address does not conflict with
> IPv6 non-wildcard addresses.
> 
> [0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
> [1]: https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/
> 
> Fixes: 5456262d2baa ("net: Fix incorrect address comparison when searching for a bind2 bucket")
> Reported-by: Paul Holzinger <pholzing@redhat.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

The links above should use proper link tags, this thus ideally should
look something like this:

Link:
https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/
[1]
Fixes: 5456262d2baa ("net: Fix incorrect address comparison when
searching for a bind2 bucket")
Reported-by: Paul Holzinger <pholzing@redhat.com>
Link:
https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
[0]

[placing the link [1] at the end would be fine, too]

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

P.S.: While at it:

#regzbot ^backmonitor:
https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/

