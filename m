Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E28633196
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbiKVAtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKVAtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:49:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AED22B3A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669078101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N1lAtUfxSqu18fCCviIv82tE3o1gDbqJA8/vG7g+Iw4=;
        b=WP0ljl9/51M7509U4+EZOG4TW3MvWobcHGkY50a7RCVUXdWg2JqbxbgE2hZdHPeHYejsCS
        f2+yz2MDaTyDtRTGVpl/NPn8ODmcOdoikkoluwWAJ8WfNTdm6R6m5wP4e0gEhJGOUd6RGV
        /Psp+9KC7m09XuDRk1BVJezCGFAgjPM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-673-Lm7P3tVgP7KWi-LP5mWmuQ-1; Mon, 21 Nov 2022 19:48:20 -0500
X-MC-Unique: Lm7P3tVgP7KWi-LP5mWmuQ-1
Received: by mail-qv1-f69.google.com with SMTP id h13-20020a0ceecd000000b004c6964dc952so9672441qvs.13
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:48:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N1lAtUfxSqu18fCCviIv82tE3o1gDbqJA8/vG7g+Iw4=;
        b=h/Lb6rf3wFe9aDvK0qdwFagIy8pOLOLk9UoX6i6yxWPdbfwsN1YIJSkRltW9UOUuAT
         XQLwEnbodpM3k/gTUcU9svLdjxwiF5S0o4exz/XRdb3tDUU/SBPjLCR1ePyMdpurnZV5
         L7dGbpm6oUmgh2fGMc7EDPwGbV/XnYf7MB1jPqetGkItumGK1OuKVOmW80JRtVibWB9h
         d6/wZw9tGE84aP9vUyD8y95yDHtyUYaaAoTN+uAtYSHxCn4PRE8j9FMmP7NnLRA1vQAB
         Bv+bFP6vCG/PdrRS03wGzvUK27Zi0yIgS4Iw5kDbkWaJaGGZwFtLczboxfFNsynaIEjh
         Nngg==
X-Gm-Message-State: ANoB5pnP3kx/AdoXzXIrKmTlKfVhjCr6LToZkKU6FE7MEVfdsaS+rj2z
        lENXtswpd+QgvGpgKZB+s4LU9Ur7T6PPRjYltD+kagXnqzDCKzQi+hH0Vly0U9GgcAaxbxTVtvs
        mYtrU/rgKpp0sW1Ur
X-Received: by 2002:a05:620a:8086:b0:6fa:7b74:1cc1 with SMTP id ef6-20020a05620a808600b006fa7b741cc1mr3318044qkb.144.1669078099764;
        Mon, 21 Nov 2022 16:48:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6qV3cnbP4oy61ujmZe64y9rbsAHEhhDhutJO9GEtcu+pUoCPG21F4vHc1eu9t0SH3F6onHJA==
X-Received: by 2002:a05:620a:8086:b0:6fa:7b74:1cc1 with SMTP id ef6-20020a05620a808600b006fa7b741cc1mr3318008qkb.144.1669078099482;
        Mon, 21 Nov 2022 16:48:19 -0800 (PST)
Received: from [10.0.0.96] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id t18-20020a05620a451200b006fafc111b12sm9466619qkp.83.2022.11.21.16.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 16:48:19 -0800 (PST)
Message-ID: <9c813d3e-96f9-218b-94a7-a5e47615d617@redhat.com>
Date:   Mon, 21 Nov 2022 19:48:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] tipc: check skb_linearize() return value in
 tipc_disc_rcv()
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>, ying.xue@windriver.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20221119072832.7896-1-yuehaibing@huawei.com>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <20221119072832.7896-1-yuehaibing@huawei.com>
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



On 11/19/22 02:28, YueHaibing wrote:
> If skb_linearize() fails in tipc_disc_rcv(), we need to free the skb instead of
> handle it.
>
> Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   net/tipc/discover.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/tipc/discover.c b/net/tipc/discover.c
> index e8630707901e..e8dcdf267c0c 100644
> --- a/net/tipc/discover.c
> +++ b/net/tipc/discover.c
> @@ -211,7 +211,10 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
>   	u32 self;
>   	int err;
>   
> -	skb_linearize(skb);
> +	if (skb_linearize(skb)) {
> +		kfree_skb(skb);
> +		return;
> +	}
>   	hdr = buf_msg(skb);
>   
>   	if (caps & TIPC_NODE_ID128)
Acked-by: Jon Maloy <jmaloy@redhat.com>

