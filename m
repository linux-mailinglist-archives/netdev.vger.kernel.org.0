Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742906BB6CE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbjCOO7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbjCOO7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:59:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FB859E47
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678892149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KN2VfOdmy3iuUxxB9vdBrJH3zqGfCKYM7D6HphZuQAQ=;
        b=WhxTh+D1bag9AxTOPBCwbDJPlAYmL7AA5eOk1QcZB+N5TKlqJESAwfS+k9iiWrJ5Wm67d/
        /ioMu3TmmSTjDQI3l1RWMHBo4LQMghT1uIsyundI2ApkdPS2emj+flIq5L9XeWGuTnM6/K
        YC6m+MU2w1s8KvkDoId6RoahNXvzGa4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-s2rXS8j4PS2uotBuzXbgOg-1; Wed, 15 Mar 2023 10:55:48 -0400
X-MC-Unique: s2rXS8j4PS2uotBuzXbgOg-1
Received: by mail-ed1-f69.google.com with SMTP id es16-20020a056402381000b004fa3e04c882so18195820edb.10
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678892147;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KN2VfOdmy3iuUxxB9vdBrJH3zqGfCKYM7D6HphZuQAQ=;
        b=Cd7HNqn7mVBFeYXtjW/yFAD/Av2fsG/IOF00hWsKRq45rhlqCondjN6vUd812vkoTf
         54EXx+Zie0Bssd8hCqscg+vYDM8qu9HqRVBb7YkDJJw/qcWfro62b1ClFQomsB+gN20k
         A4MWxAARW7QPQ6CQRfFc3T8JnRtag/GZZrAxwZIeAxlVIi79DI2G4SOQkRijsbTrwAST
         96XI1aetdy824IKigP59IegD3HPCtppVnEBJIQMb4dlZp4ZW1idjw9IwOxT7BpAi7mtf
         prdQoIsvUiLtwF6lVZ4cxKuqGzUxtdWDrxQE+/2gC3nT0oO7dulwVJg3Wcwf9esZkda/
         eH9A==
X-Gm-Message-State: AO0yUKW6gP73bdPV5DZVcu89C2AqDmBpz14rJP+1BV06jgFm5ubqCqUA
        7jjrQe8/077Cp+lMt3MmC7zqQLjdzSw/w+YBWkfZROP1s/idWSs1ALeS/JmUDe2/vEAUVoIQn60
        bnZEJhHM2tcqMyBsx
X-Received: by 2002:a17:906:3986:b0:91f:32f9:82f0 with SMTP id h6-20020a170906398600b0091f32f982f0mr6472697eje.29.1678892147617;
        Wed, 15 Mar 2023 07:55:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set9c1+AtvFOAgCIHn6BjFo1rVzWT/trJ8pAA7XjvvZTEPWHgRlzyMfqEq18LBBKV860wFQSBDg==
X-Received: by 2002:a17:906:3986:b0:91f:32f9:82f0 with SMTP id h6-20020a170906398600b0091f32f982f0mr6472677eje.29.1678892147344;
        Wed, 15 Mar 2023 07:55:47 -0700 (PDT)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id z18-20020a17090655d200b008edc39530fbsm2598963ejp.219.2023.03.15.07.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:55:46 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <11e480dd-7969-7b58-440e-3207b98d0ac5@redhat.com>
Date:   Wed, 15 Mar 2023 15:55:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
Subject: Re: [PATCH bpf-next v3 3/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <20230313215553.1045175-4-aleksander.lobakin@intel.com>
In-Reply-To: <20230313215553.1045175-4-aleksander.lobakin@intel.com>
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


On 13/03/2023 22.55, Alexander Lobakin wrote:
> __xdp_build_skb_from_frame() state(d):
> 
> /* Until page_pool get SKB return path, release DMA here */
> 
> Page Pool got skb pages recycling in April 2021, but missed this
> function.
> 
> xdp_release_frame() is relevant only for Page Pool backed frames and it
> detaches the page from the corresponding page_pool in order to make it
> freeable via page_frag_free(). It can instead just mark the output skb
> as eligible for recycling if the frame is backed by a pp. No change for
> other memory model types (the same condition check as before).
> cpumap redirect and veth on Page Pool drivers now become zero-alloc (or
> almost).
> 
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>   net/core/xdp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 8c92fc553317..a2237cfca8e9 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -658,8 +658,8 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>   	 * - RX ring dev queue index	(skb_record_rx_queue)
>   	 */
>   
> -	/* Until page_pool get SKB return path, release DMA here */
> -	xdp_release_frame(xdpf);
> +	if (xdpf->mem.type == MEM_TYPE_PAGE_POOL)
> +		skb_mark_for_recycle(skb);

I hope this is safe ;-) ... Meaning hopefully drivers does the correct
thing when XDP_REDIRECT'ing page_pool pages.

Looking for drivers doing weird refcnt tricks and XDP_REDIRECT'ing, I
noticed the driver aquantia/atlantic (in aq_get_rxpages_xdp), but I now
see this is not using page_pool, so it should be affected by this (but I
worry if atlantic driver have a potential race condition for its refcnt
scheme).

>   
>   	/* Allow SKB to reuse area used by xdp_frame */
>   	xdp_scrub_frame(xdpf);

