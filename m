Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E445E4C60D5
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 03:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiB1COS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 21:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiB1COR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 21:14:17 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F137145510;
        Sun, 27 Feb 2022 18:13:36 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t14so7230471pgr.3;
        Sun, 27 Feb 2022 18:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DtL7SWK21u+xZhbjnZFVcZx7PZjrMA1o1qQEXFS0MNU=;
        b=BzKpTfnzjJcfZXPaely/HTimgea5Ajt9ht87rUYI2hbwr/Qp6Nkh9oY8eNOOr9o/lE
         1GN5hMxgxkyV1QyWFP0FetciKJTWzxFucni7mW8mf/CNa7RaivOqfa5AFhFrRDc0MipG
         dqmp/lLVJVD2hM5fCZpzkLjmmKD7X6uGSYQey3BDmcJCd1hKSHnC51pfOqLdt13VSgMm
         N/9t/2TfNUTz9QsTOjjHhOtbdQ8zNzBb3/05LBxrGvwNSC0eidxj6D/HB0oAuIIsJ577
         lyI4oxxFUtOkC8DteEbkKlzVwmRPRQdYDaAtRIJCSpLTC4DAXfowRhqDYy3UBG+79uuu
         TvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DtL7SWK21u+xZhbjnZFVcZx7PZjrMA1o1qQEXFS0MNU=;
        b=sdYXGvGnlIlQaiQubVu1i0qZKAsNgHF30gKL2F23bjPAH5UB1dLNagtyS87X8GG/5z
         Ondnfoy+OXHUBn4ACYUtdcpkk4geX95gF7qsS6jd5mStVXN+TGhMPDynfGXrQopkOM5Y
         JWoZ2DSTqhBtFRDVrV4LazZ5uxv5myoYf1ANqHqFhZvG6CMadwghaMQhsghiBrWILOxm
         D5YRIpDLwlkdLPd3CtryxmzBJIX3FgVUF+m8gmmp1FfGc31mMTBGxjEH0v1gBdX1utqo
         UtxAeV5dIVSL8RakDO12AN1lTGo0CO7zAsQTwuutQIIxHZy0Q/RZqJThe4B9cg5QHRhg
         ZSFw==
X-Gm-Message-State: AOAM532Aybco/7yUNrqTanOX/2BEPVY5Z2Z7Vh4J45vylDUGrysy8pJe
        GwH8L5XHJYU7XYEKVE+5AdgQELVr/6Y=
X-Google-Smtp-Source: ABdhPJxnFM6IXEA+rP8R+defBg6RvFrhktJtrIXjfp79gGeKIZ8Bl7ONFaaRIU1h9mpCtqTodplfrQ==
X-Received: by 2002:a63:27c7:0:b0:343:984e:3428 with SMTP id n190-20020a6327c7000000b00343984e3428mr15538326pgn.528.1646014416397;
        Sun, 27 Feb 2022 18:13:36 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m5-20020a056a00080500b004e174acd876sm11141056pfk.216.2022.02.27.18.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 18:13:35 -0800 (PST)
Message-ID: <872e2596-4d7c-3b91-341c-0db3a3d7fd57@gmail.com>
Date:   Sun, 27 Feb 2022 18:13:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 18/32] netfilter: egress: avoid a lockdep splat
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
References: <20220109231640.104123-1-pablo@netfilter.org>
 <20220109231640.104123-19-pablo@netfilter.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220109231640.104123-19-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/9/22 15:16, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
>
> include/linux/netfilter_netdev.h:97 suspicious rcu_dereference_check() usage!
> 2 locks held by sd-resolve/1100:
>   0: ..(rcu_read_lock_bh){1:3}, at: ip_finish_output2
>   1: ..(rcu_read_lock_bh){1:3}, at: __dev_queue_xmit
>   __dev_queue_xmit+0 ..
>
> The helper has two callers, one uses rcu_read_lock, the other
> rcu_read_lock_bh().  Annotate the dereference to reflect this.
>
> Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   include/linux/netfilter_netdev.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
> index b71b57a83bb4..b4dd96e4dc8d 100644
> --- a/include/linux/netfilter_netdev.h
> +++ b/include/linux/netfilter_netdev.h
> @@ -94,7 +94,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
>   		return skb;
>   #endif
>   
> -	e = rcu_dereference(dev->nf_hooks_egress);
> +	e = rcu_dereference_check(dev->nf_hooks_egress, rcu_read_lock_bh_held());
>   	if (!e)
>   		return skb;
>   


It seems other rcu_dereference() uses will also trigger lockdep splat.


nft_do_chain()

...

if (genbit)

     blob = rcu_dereference(chain->blob_gen_1);

else

    blob = rcu_dereference(chain->blob_gen_0);

I wonder how many other places will need a fix ?


