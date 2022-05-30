Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B455537B2A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiE3NPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbiE3NPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:15:13 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E66230F64;
        Mon, 30 May 2022 06:15:12 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 9D8491F42E59
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1653916510;
        bh=sEie6GXsRwAWSR4UPX24pvsXPPWCr0i8UxuSQOMqwEs=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=dvv2c6kYLYDSJolgU65XbB33Z60fYRhamY0Tz8WYctFlG2XOi2biD1x8zKubNKCmJ
         4Sf7u4ZiX8SGYDLQWwgl0qoYPK/bVj57bDD+tp9plFVMLopTPOaV8dP5cB5J7L96D1
         IWJmLskH4VmeyBxx2C6YGxYdjPDTi2wXe/r6zCZ4Pt6Za6AKemf1z2qc/NyNluvgaZ
         3TBbdf42gkKaITMFnSZdZzvkTd6ke0ytpt5X46U/Yk1X50vn6X9Fvum7ZFBeCu+tqM
         imD1UhiA2KlHkHgpL6r/Is5oMn58f6/ti4nYVgMrhzNBPRLaOuPGIX51hrkyFDoupj
         bs9jRW8XuIUew==
Message-ID: <8eb9b438-7018-4fe3-8be6-bb023df99594@collabora.com>
Date:   Mon, 30 May 2022 18:15:03 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
To:     Eric Dumazet <edumazet@google.com>
Cc:     usama.anjum@collabora.com, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        open list <linux-kernel@vger.kernel.org>,
        Collabora Kernel ML <kernel@collabora.com>,
        Paul Gofman <pgofman@codeweavers.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        Sami Farin <hvtaifwkbgefbaei@gmail.com>
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for your reply.

On 5/25/22 3:13 AM, Eric Dumazet wrote:
> On Tue, May 24, 2022 at 1:19 AM Muhammad Usama Anjum
> <usama.anjum@collabora.com> wrote:
>>
>> Hello,
>>
>> We have a set of processes which talk with each other through a local
>> TCP socket. If the process(es) are killed (through SIGKILL) and
>> restarted at once, the bind() fails with EADDRINUSE error. This error
>> only appears if application is restarted at once without waiting for 60
>> seconds or more. It seems that there is some timeout of 60 seconds for
>> which the previous TCP connection remains alive waiting to get closed
>> completely. In that duration if we try to connect again, we get the error.
>>
>> We are able to avoid this error by adding SO_REUSEADDR attribute to the
>> socket in a hack. But this hack cannot be added to the application
>> process as we don't own it.
>>
>> I've looked at the TCP connection states after killing processes in
>> different ways. The TCP connection ends up in 2 different states with
>> timeouts:
>>
>> (1) Timeout associated with FIN_WAIT_1 state which is set through
>> `tcp_fin_timeout` in procfs (60 seconds by default)
>>
>> (2) Timeout associated with TIME_WAIT state which cannot be changed. It
>> seems like this timeout has come from RFC 1337.
>>
>> The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
>> also doesn't seem feasible to change the timeout of TIME_WAIT state as
>> the RFC mentions several hazards. But we are talking about a local TCP
>> connection where maybe those hazards aren't applicable directly? Is it
>> possible to change timeout for TIME_WAIT state for only local
>> connections without any hazards?
>>
>> We have tested a hack where we replace timeout of TIME_WAIT state from a
>> value in procfs for local connections. This solves our problem and
>> application starts to work without any modifications to it.
>>
>> The question is that what can be the best possible solution here? Any
>> thoughts will be very helpful.
>>
> 
> One solution would be to extend TCP diag to support killing TIME_WAIT sockets.
> (This has been raised recently anyway)
I think this has been raised here:
https://lore.kernel.org/netdev/ba65f579-4e69-ae0d-4770-bc6234beb428@gmail.com/

> 
> Then you could zap all sockets, before re-starting your program.
> 
> ss -K -ta src :listen_port
> 
> Untested patch:
The following command and patch work for my use case. The socket in
TIME_WAIT_2 or TIME_WAIT state are closed when zapped.

Can you please upstream this patch?

> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9984d23a7f3e1353d2e1fc9053d98c77268c577e..1b7bde889096aa800b2994c64a3a68edf3b62434
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4519,6 +4519,15 @@ int tcp_abort(struct sock *sk, int err)
>                         local_bh_enable();
>                         return 0;
>                 }
> +               if (sk->sk_state == TCP_TIME_WAIT) {
> +                       struct inet_timewait_sock *tw = inet_twsk(sk);
> +
> +                       refcount_inc(&tw->tw_refcnt);
> +                       local_bh_disable();
> +                       inet_twsk_deschedule_put(tw);
> +                       local_bh_enable();
> +                       return 0;
> +               }
>                 return -EOPNOTSUPP;
>         }

-- 
Muhammad Usama Anjum
