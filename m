Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B938438995
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhJXPAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 11:00:13 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:65173 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhJXPAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 11:00:13 -0400
Received: from [192.168.1.18] ([92.140.161.106])
        by smtp.orange.fr with ESMTPA
        id eewXmJYg7TdRTeewXmLjC3; Sun, 24 Oct 2021 16:57:51 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 24 Oct 2021 16:57:51 +0200
X-ME-IP: 92.140.161.106
Subject: Re: [PATCH] gve: Fix a possible invalid memory access
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        davem@davemloft.net, kuba@kernel.org, bcf@google.com,
        gustavoars@kernel.org, edumazet@google.com, jfraker@google.com,
        yangchun@google.com, xliutaox@google.com, sagis@google.com,
        lrizzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <fb712f802228ab4319891983164bf45e90d529e7.1635076200.git.christophe.jaillet@wanadoo.fr>
 <CA+FuTSftgpOGxAxRE5u9o6gT_exaLtC2JkBz=iq21qe+tTTomA@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <f14bbf8a-2070-650f-3f26-bd45aad48b88@wanadoo.fr>
Date:   Sun, 24 Oct 2021 16:57:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSftgpOGxAxRE5u9o6gT_exaLtC2JkBz=iq21qe+tTTomA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 24/10/2021 à 15:51, Willem de Bruijn a écrit :
> On Sun, Oct 24, 2021 at 7:52 AM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> It is spurious to allocate a bitmap for 'num_qpls' bits and record the
>> size of this bitmap with another value.
>>
>> 'qpl_map_size' is used in 'drivers/net/ethernet/google/gve/gve.h' with
>> 'find_[first|next]_zero_bit()'.
>> So, it looks that memory after the allocated 'qpl_id_map' could be
>> scanned.
> 
> find_first_zero_bit takes a length argument in bits:
> 
>      /**
>       * find_first_zero_bit - find the first cleared bit in a memory region
>       * @addr: The address to start the search at
>       * @size: The maximum number of bits to search
> 
> qpl_map_size is passed to find_first_zero_bit.
> 
> It does seem roundabout to compute first the number of longs needed to
> hold num_qpl bits
> 
>      BITS_TO_LONGS(num_qpls)
> 
> then again compute the number of bits in this buffer
> 
>      * sizeof(unsigned long) * BITS_PER_BYTE
> 
> Which will simply be num_qpls again.
> 
> But, removing BITS_PER_BYTE does not arrive at the right number.

(* embarrassed *)

So obvious.
Thank you for taking time for the explanation on a so badly broken patch.

I apologize for the noise and the waste of time :(


BTW, why not just have 'priv->qpl_cfg.qpl_map_size = num_qpls;'?

CJ

> 
> 
>>
>> Remove the '* BITS_PER_BYTE' to have allocation and length be the same.
>>
>> Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> This patch is completely speculative and un-tested!
>> You'll be warned.
>> ---
>>   drivers/net/ethernet/google/gve/gve_main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
>> index 7647cd05b1d2..19fe9e9b62f5 100644
>> --- a/drivers/net/ethernet/google/gve/gve_main.c
>> +++ b/drivers/net/ethernet/google/gve/gve_main.c
>> @@ -866,7 +866,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
>>          }
>>
>>          priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(num_qpls) *
>> -                                    sizeof(unsigned long) * BITS_PER_BYTE;
>> +                                    sizeof(unsigned long);
>>          priv->qpl_cfg.qpl_id_map = kvcalloc(BITS_TO_LONGS(num_qpls),
>>                                              sizeof(unsigned long), GFP_KERNEL);
>>          if (!priv->qpl_cfg.qpl_id_map) {
>> --
>> 2.30.2
>>
> 

