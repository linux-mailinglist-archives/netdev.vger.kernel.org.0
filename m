Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2C2B8906
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKSA06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:26:58 -0500
Received: from novek.ru ([213.148.174.62]:38626 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKSA05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:26:57 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 8732A501633;
        Thu, 19 Nov 2020 03:27:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 8732A501633
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605745628; bh=K6MUUk54ulYNAUapum7/o+0d30Gr3UEO9JD2aOX6HSY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=hFiL0fG/QXVKnZNY8UiO7McQB1YUPnRDm58neN+kAzGNEcBeLiaTH/ufNCa2daiza
         QWkGwF+vhUCQ3mtODOVheB+uCzgnuZPgUXT1FkqvCsjUMIzTK7Li1XCW6UT2JZ6e59
         7DAxnPRBzfXtN6zHxTI/kDVHkDteyEWbb0ZeyVBQ=
Subject: Re: [net] net/tls: missing received data after fast remote close
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
 <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
 <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <33ede124-583b-4bdd-621b-638bbca1a6c8@novek.ru>
 <20201118082336.6513c6c0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3c3f9b9d-0fef-fb62-25f8-c9f17ec43a69@novek.ru>
 <20201118153931.43898a9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <12e61d3c-cc7d-71a7-f3be-4b796986a4d5@novek.ru>
Date:   Thu, 19 Nov 2020 00:26:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118153931.43898a9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.11.2020 23:39, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 20:51:30 +0000 Vadim Fedorenko wrote:
>>>> The async nature of parser is OK for classic HTTPS server/client case
>>>> because it's very good to have parsed record before actual call to recvmsg
>>>> or splice_read is done. The code inside the loop in tls_wait_data is slow
>>>> path - maybe just move the check and the __unpause in this slow path?
>>> Yeah, looking closer this problem can arise after we start as well :/
>>>
>>> How about we move the __unparse code into the loop tho? Seems like this
>>> could help with latency. Right now AFAICT we get a TCP socket ready
>>> notification, which wakes the waiter for no good reason and makes
>>> strparser queue its work, the work then will call tls_queue() ->
>>> data_ready waking the waiting thread second time this time with the
>>> record actually parsed.
>>>
>>> Did I get that right? Should the waiter not cancel the work on the
>>> first wake up and just kick of the parsing itself?
>> I was thinking of the same solution too, but simple check of emptyness of
>> socket's receive queue is not working in case when we have partial record
>> in queue - __unpause will return without changing ctx->skb and still having
>> positive value in socket queue and we will have blocked loop until new data
>> is received or strp_abort_strp is fired because of timeout. If you could
>> suggest proper condition to break the loop it would be great.
>>
>> Or probably I misunderstood what loop did you mean exactly?
> Damn, you may be seeing some problem I'm missing again ;) Running
> __unparse can be opportunistic, if it doesn't parse anything that's
> fine. I was thinking:
>
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 95ab5545a931..6478bd968506 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1295,6 +1295,10 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
>                          return NULL;
>                  }
>   
> +               __strp_unpause(&ctx->strp);
> +               if (ctx->recv_pkt)
> +                       return ctx->recv_pkt;
> +
>                  if (sk->sk_shutdown & RCV_SHUTDOWN)
>                          return NULL;
>   
> Optionally it would be nice if unparse cancelled the work if it managed
> to parse the record out.
Oh, simple and fine solution. But is it better to unpause parser conditionally when
there is something in the socket queue? Otherwise this call will be just wasting
cycles. Maybe like this:

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2fe9e2c..97c5f6e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1295,6 +1295,12 @@ static struct sk_buff *tls_wait_data(struct sock *sk, 
struct sk_psock *psock,
                         return NULL;
                 }

+               if (!skb_queue_empty(&sk->sk_receive_queue)) {
+                       __strp_unpause(&ctx->strp);
+                       if (ctx->recv_pkt)
+                               return ctx->recv_pkt;
+               }
+
                 if (sk->sk_shutdown & RCV_SHUTDOWN)
                         return NULL;

