Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384076B2B3C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjCIQyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCIQxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:53:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D30E1C94
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678380236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBYjTI8PgGxLAtEJnnuZ8LRWuHsJNFJKEu/Uajd9epk=;
        b=i5E/Qs1/L41Il6Vqlc338wWnIgu9rocxzqn4tAXHTA3sTtKjRJr/N8CpAkmbTPIDzsyoAg
        9UNvsOdGUAo8cjslAVi0XYQ6MuXK8rZmb9/i6Cy3sW0qpBnrej02sYJx4859gbkRs38tp1
        dG7b93EysMO3AU4gzI9wRdwStuFIlPc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-OyNzsve9NBiVxoBPhY-dow-1; Thu, 09 Mar 2023 11:43:55 -0500
X-MC-Unique: OyNzsve9NBiVxoBPhY-dow-1
Received: by mail-ed1-f69.google.com with SMTP id v11-20020a056402348b00b004ce34232666so3752732edc.3
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678380234;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gBYjTI8PgGxLAtEJnnuZ8LRWuHsJNFJKEu/Uajd9epk=;
        b=i0wvK+lqr8eD/AqVxbSyNOFsmCrppL3cDnKGKyIBtAs6cBtk+7Y8eRzB2pj6k0gsNM
         pNweS/9SVFNtYQVyvkqdBj4UUL8daw3SQunMwDQPWzsumh26qkRD9nQ0U4P97PgHyMLd
         EbeR3z0ZkpkvCS19qvaVQrpcYiZKJY4xPqbObPQixIo4T4JCyNFcynwix3oKgyvik0BQ
         PCfQwCJMwLwzBsUrO5QYPytcgx5WI3LslaiJAFCXVwu6NBl4hDrVaiLBow5U081zsW+p
         nKGNX5ag2mN7JDhSCIN+06lw6yb8wFcTP3E9E8D8AoVguvtCyiGl9/R3UMe7l5PX6A9E
         36XQ==
X-Gm-Message-State: AO0yUKXKeqhFWGIxX3sE5DjK70JasamzBYzatOoZQNSirDx1M2+2VheY
        MqCPsRwiuUMzw/ZBEnqwtnREzhfK4egTKxB4O3P3qmdW8s0p6EUKCG8MZBlHlD/9DWHGM5pQAcQ
        zhDs5DI5dgb3y9sDF
X-Received: by 2002:aa7:d385:0:b0:4ac:d8a1:7385 with SMTP id x5-20020aa7d385000000b004acd8a17385mr22723861edq.3.1678380234023;
        Thu, 09 Mar 2023 08:43:54 -0800 (PST)
X-Google-Smtp-Source: AK7set+YXdWGTr+wwyLt6gx1zoE1Sr4/UFcOwc798aU7m3XxYsJQWmujjulXzcRp+Ar11o7JCqfjAg==
X-Received: by 2002:aa7:d385:0:b0:4ac:d8a1:7385 with SMTP id x5-20020aa7d385000000b004acd8a17385mr22723846edq.3.1678380233757;
        Thu, 09 Mar 2023 08:43:53 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id t30-20020a50ab5e000000b004ad601533a3sm9926098edc.55.2023.03.09.08.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 08:43:53 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <73b5076c-335b-c746-b227-0edd40435ef5@redhat.com>
Date:   Thu, 9 Mar 2023 17:43:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/3] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
References: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
In-Reply-To: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/03/2023 14.32, Alexander Lobakin wrote:
> Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.
> 
> __xdp_build_skb_from_frame() missed the moment when the networking stack
> became able to recycle skb pages backed by a page_pool. This was making
> e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
> also affected in some scenarios.
> A lot of drivers use skb_mark_for_recycle() already, it's been almost
> two years and seems like there are no issues in using it in the generic
> code too. {__,}xdp_release_frame() can be then removed as it losts its
> last user.
> Page Pool becomes then zero-alloc (or almost) in the abovementioned
> cases, too. Other memory type models (who needs them at this point)
> have no changes.
> 
> Some numbers on 1 Xeon Platinum core bombed with 27 Mpps of 64-byte
> IPv6 UDP, iavf w/XDP[0] (CONFIG_PAGE_POOL_STATS is enabled):
> 
> Plain %XDP_PASS on baseline, Page Pool driver:
> 
> src cpu Rx     drops  dst cpu Rx
>    2.1 Mpps       N/A    2.1 Mpps
> 
> cpumap redirect (w/o leaving its node) on baseline:

What does it mean "without leaving its node" ?
I interpret this means BPF program CPU redirect to "same" CPU ?
Or does the "node" reference a NUMA node?

> 
>    6.8 Mpps  5.0 Mpps    1.8 Mpps
> 
> cpumap redirect with skb PP recycling:

Does this test use two CPUs?

> 
>    7.9 Mpps  5.7 Mpps    2.2 Mpps
>                         +22% (from cpumap redir on baseline)
> [0] https://github.com/alobakin/linux/commits/iavf-xdp
> 
> Alexander Lobakin (3):
>    net: page_pool, skbuff: make skb_mark_for_recycle() always available
>    xdp: recycle Page Pool backed skbs built from XDP frames
>    xdp: remove unused {__,}xdp_release_frame()
> 
>   include/linux/skbuff.h |  4 ++--
>   include/net/xdp.h      | 29 -----------------------------
>   net/core/xdp.c         | 19 ++-----------------
>   3 files changed, 4 insertions(+), 48 deletions(-)
> 
> ---
>  From v1[1]:
> * make skb_mark_for_recycle() always available, otherwise there are build
>    failures on non-PP systems (kbuild bot);
> * 'Page Pool' -> 'page_pool' when it's about a page_pool instance, not
>    API (Jesper);
> * expanded test system info a bit in the cover letter (Jesper).
> 
> [1] https://lore.kernel.org/bpf/20230301160315.1022488-1-aleksander.lobakin@intel.com

