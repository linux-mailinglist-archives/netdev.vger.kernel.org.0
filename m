Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE5C6B7D28
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCMQNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjCMQNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:13:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E135077CA6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678723960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4/7ewzBQiiKI8nU3w0jBFH3Rlbl9oB7oX/86v//b4bc=;
        b=QGvibqH8LwORDzLqKbcA3JrdtcKyTdqaP3gpYurRwtny+qerCw/WcZmmut2a06gg8/+z2y
        4cTFxAaJSLoSXH4M44z2zRSq487RX8QMpiTQ5HUGqcf78Iy6kwSRyasabP79NpHsi1fBDb
        WOp6N0e4jK+CXniCWGs54mR63NbMTxA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-5-hlTgw3M1GnqYJyp6HKJQ-1; Mon, 13 Mar 2023 12:12:38 -0400
X-MC-Unique: 5-hlTgw3M1GnqYJyp6HKJQ-1
Received: by mail-wm1-f70.google.com with SMTP id m28-20020a05600c3b1c00b003e7d4662b83so8022248wms.0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678723957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/7ewzBQiiKI8nU3w0jBFH3Rlbl9oB7oX/86v//b4bc=;
        b=AgnGfHdboEkRgdIM8zpm4J9I37byIuiqDZOrU17X3NHiluEZ+/2kigFwaidDX6svUl
         jQbWTS9U/uWsma+LG5gIxnwniN+s0K9OZxaX2luj80DT/5BBK4Lda7enSCYDCD6BleNn
         XmuZ/9tA8KJP21X35hPaFw69qOkH70L97mZuBjgqUXxMYaEiGao5Sagb6oroljMTbgwm
         raIidteam4RuuDbN8jqSLobXGeEJQP1IAQKFsCN22p1Q5okM6apCBpyX6xaVcLSW9fw7
         E7DGvmSHBNHFNJWmouPvMO5s+nTlghKPJBh8Rs5es21/WB5Vqy4xIxphKcnUfvLIaotv
         N20Q==
X-Gm-Message-State: AO0yUKWEUbOOeqGaZaPGS7ipPpKPmc33kHVll1fqA31RCvJfn8M1bcao
        r5TK82Bv4f17V/btvg0Get3qdmDJzJJjypwJoQ+IqZaXRuaRQO+V2Y1TrvJvMXWKTQ2ng5osrgR
        iZrJJF+2UctMdKIj+
X-Received: by 2002:a05:600c:600a:b0:3de:d52:2cd2 with SMTP id az10-20020a05600c600a00b003de0d522cd2mr11574644wmb.4.1678723957561;
        Mon, 13 Mar 2023 09:12:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set8PGQpyZrsjfGoQFw9JO1/n4HBNdmx1u6vP6YR0wemSKF6AhEgAELSf57FYMFtplgK4bQtb9w==
X-Received: by 2002:a05:600c:600a:b0:3de:d52:2cd2 with SMTP id az10-20020a05600c600a00b003de0d522cd2mr11574632wmb.4.1678723957274;
        Mon, 13 Mar 2023 09:12:37 -0700 (PDT)
Received: from [192.168.188.25] ([80.243.52.133])
        by smtp.gmail.com with ESMTPSA id j5-20020a05600c1c0500b003eb2e33f327sm439551wms.2.2023.03.13.09.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 09:12:36 -0700 (PDT)
Message-ID: <d39f0806-cbe7-52ae-2271-67e365315018@redhat.com>
Date:   Mon, 13 Mar 2023 17:12:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v1 net 1/2] tcp: Fix bind() conflict check for dual-stack
 wildcard address.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <20230312031904.4674-1-kuniyu@amazon.com>
 <20230312031904.4674-2-kuniyu@amazon.com>
Content-Language: en-US
From:   Paul Holzinger <pholzing@redhat.com>
In-Reply-To: <20230312031904.4674-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Kuniyuki, patch works for me.

On 12/03/2023 04:19, Kuniyuki Iwashima wrote:
> Paul Holzinger reported [0] that commit 5456262d2baa ("net: Fix
> incorrect address comparison when searching for a bind2 bucket")
> introduced a bind() regression.  Paul also gave a nice repro that
> calls two types of bind() on the same port, both of which now
> succeed, but the second call should fail:
>
>    bind(fd1, ::, port) + bind(fd2, 127.0.0.1, port)
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
> ---
> Cc: Martin KaFai Lau <martin.lau@kernel.org>
> ---
> Some cleanup patches will be posted against net-next later:
>
>    * s/addr_any/in6addr_any/
>    * Remove duplicated tests for net, port, and l3mdev.
> ---
>   net/ipv4/inet_hashtables.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index e41fdc38ce19..6edae3886885 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -828,8 +828,14 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
>   #if IS_ENABLED(CONFIG_IPV6)
>   	struct in6_addr addr_any = {};
>   
> -	if (sk->sk_family != tb->family)
> +	if (sk->sk_family != tb->family) {
> +		if (sk->sk_family == AF_INET)
> +			return net_eq(ib2_net(tb), net) && tb->port == port &&
> +				tb->l3mdev == l3mdev &&
> +				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> +
>   		return false;
> +	}
>   
>   	if (sk->sk_family == AF_INET6)
>   		return net_eq(ib2_net(tb), net) && tb->port == port &&
Tested-by: Paul Holzinger <pholzing@redhat.com>

