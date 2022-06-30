Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371D2561F27
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiF3PVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiF3PVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:21:49 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6064C3983F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:21:47 -0700 (PDT)
Received: from [10.120.40.106] (static-qvn-qvt-113043.business.bouyguestelecom.com [89.83.113.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2B8FA500E92;
        Thu, 30 Jun 2022 18:20:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2B8FA500E92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1656602406; bh=azbLJz9lx+ReNAytpxhJDM/MYNNJHaeq9TUY+VLzcnM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bL5sVi3iosD0yPhnZ7/pYQ+KJ+i3I/YXKtVUp5oAlQ8GmejV6ZwmFXHUhcQQBUKdO
         6rNZzD4qe8r9fUCsDOmUtyVti8Sa2+DKHNGPvgx6eBDCuEsVGS6BgBAGDzGxeEPrT6
         6rjZJx4SWZsB6RVhmSScDVk5zO99MeDGN6q9/i14=
Message-ID: <367e0ed7-1314-da6d-ee97-3ae2044e3346@novek.ru>
Date:   Thu, 30 Jun 2022 16:21:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: tls: fix tls with sk_redirect using a BPF verdict.
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Julien Salleyron <julien.salleyron@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Marc Vertes <mvertes@free.fr>
References: <20220628152505.298790-1-julien.salleyron@gmail.com>
 <20220628103424.5330e046@kernel.org> <62bbf87f16223_2181420853@john.notmuch>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <62bbf87f16223_2181420853@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.06.2022 08:00, John Fastabend wrote:
> Jakub Kicinski wrote:
>> On Tue, 28 Jun 2022 17:25:05 +0200 Julien Salleyron wrote:
>>> This patch allows to use KTLS on a socket where we apply sk_redirect using a BPF
>>> verdict program.
>>>
> 
> You'll also need a signed-off-by.
> 
>>> Without this patch, we see that the data received after the redirection are
>>> decrypted but with an incorrect offset and length. It seems to us that the
>>> offset and length are correct in the stream-parser data, but finally not applied
>>> in the skb. We have simply applied those values to the skb.
>>>
>>> In the case of regular sockets, we saw a big performance improvement from
>>> applying redirect. This is not the case now with KTLS, may be related to the
>>> following point.
>>
>> It's because kTLS does a very expensive reallocation and copy for the
>> non-zerocopy case (which currently means all of TLS 1.3). I have
>> code almost ready to fix that (just needs to be reshuffled into
>> upstreamable patches). Brings us up from 5.9 Gbps to 8.4 Gbps per CPU
>> on my test box with 16k records. Probably much more than that with
>> smaller records.
> 
> Also on my list open-ssl support is lacking ktls support for both
> direction in tls1.3 iirc. We have a couple test workloads pinned on
> 1.2 for example which really isn't great.
>

AFAIK in-kernel TLS 1.3 is supported in OpenSSL 3.0, I implemented TX part long 
time ago and was fixing some parts while it was 3.0-alpha. Not sure about RX.
Or are you talking about zero-copy implementation?

>>
>>> It is still necessary to perform a read operation (never triggered) from user
>>> space despite the redirection. It makes no sense, since this read operation is
>>> not necessary on regular sockets without KTLS.
>>>
>>> We do not see how to fix this problem without a change of architecture, for
>>> example by performing TLS decrypt directly inside the BPF verdict program.
>>>
>>> An example program can be found at
>>> https://github.com/juliens/ktls-bpf_redirect-example/
>>>
>>> Co-authored-by: Marc Vertes <mvertes@free.fr>
>>> ---
>>>   net/tls/tls_sw.c                           | 6 ++++++
>>>   tools/testing/selftests/bpf/test_sockmap.c | 8 +++-----
>>>   2 files changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
>>> index 0513f82b8537..a409f8a251db 100644
>>> --- a/net/tls/tls_sw.c
>>> +++ b/net/tls/tls_sw.c
>>> @@ -1839,8 +1839,14 @@ int tls_sw_recvmsg(struct sock *sk,
>>>   			if (bpf_strp_enabled) {
>>>   				/* BPF may try to queue the skb */
>>>   				__skb_unlink(skb, &ctx->rx_list);
>>> +
>>>   				err = sk_psock_tls_strp_read(psock, skb);
>>> +
>>>   				if (err != __SK_PASS) {
>>> +                    if (err == __SK_REDIRECT) {
>>> +                        skb->data += rxm->offset;
>>> +                        skb->len = rxm->full_len;
>>> +                    }
>>
>> IDK what this is trying to do but I certainly depends on the fact
>> we run skb_cow_data() and is not "generally correct" :S
> 
> Ah also we are not handling partially consumed correctly either.
> Seems we might pop off the skb even when we need to continue;
> 
> Maybe look at how skb_copy_datagram_msg() goes below because it
> fixes the skb copy up with the rxm->offset. But, also we need to
> do this repair before sk_psock_tls_strp_read I think so that
> the BPF program reads the correct data in all cases? I guess
> your sample program (and selftests for that matter) just did
> the redirect without reading the data?
> 
> Thanks!

