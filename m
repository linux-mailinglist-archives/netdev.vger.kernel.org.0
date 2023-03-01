Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C086A6C5F
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 13:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCAMbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 07:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCAMbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 07:31:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6045639B9A
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 04:31:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXLc2-0001u4-1B; Wed, 01 Mar 2023 13:31:14 +0100
Date:   Wed, 1 Mar 2023 13:31:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        shakeelb@google.com, soheil@google.com
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
Message-ID: <20230301123114.GA6827@breakpoint.cc>
References: <20230224184606.7101-1-fw@strlen.de>
 <CANn89iJ+7X8kLjR2YrGbT64zGSu_XQfT_T5+WPQfheDmgQrf2A@mail.gmail.com>
 <CANn89i+WYy+Q1i1e1vrQmPzH-eDEVHJn29xgmsXJ8uMidP9CqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+WYy+Q1i1e1vrQmPzH-eDEVHJn29xgmsXJ8uMidP9CqQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> BTW I was curious why Google was not seeing this, and it appears Brian Vasquez
> forgot to upstream this change...
> 
> commit 5ea2f21d6c1078d2c563cb455ad5877b4ada94e1
> Author: Brian Vazquez <brianvv@google.com>
> Date:   Thu Mar 3 19:09:49 2022 -0800
> 
>     PRODKERNEL: net-directcall: annotate tcp_leave_memory_pressure and
>     tcp_getsockopt
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 05032b399c873984e5297898d647905ca9f21f2e..54cb989dc162f3982380ac12cf5a150214e209a2
> 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2647,10 +2647,13 @@ static void sk_enter_memory_pressure(struct sock *sk)
>         sk->sk_prot->enter_memory_pressure(sk);
>  }
> 
> +INDIRECT_CALLABLE_DECLARE(void tcp_leave_memory_pressure(struct sock *sk));
> +
>  static void sk_leave_memory_pressure(struct sock *sk)
>  {
>         if (sk->sk_prot->leave_memory_pressure) {
> -               sk->sk_prot->leave_memory_pressure(sk);
> +               INDIRECT_CALL_1(sk->sk_prot->leave_memory_pressure,
> +                               tcp_leave_memory_pressure, sk);
>         } else {
>                 unsigned long *memory_pressure = sk->sk_prot->memory_pressure;

re-tested: this change also resolves the regression i was seeing.

If you prefer to upstream this instead of the proposed change then I'm
fine with that.

Thanks.
