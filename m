Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19F25B2081
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiIHO0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiIHO00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:26:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DBCFB8CF
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662647181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMcpwqPqWAUl25PqKrWr6Y7WQAHGIW5e+w2aQFa0sQg=;
        b=e3FG8Ur5ZUV/oWVifr+q4cBarpph4PUrk/CFfDy4k+iquIMYgjxKwtyJ+92ublvJ3PEY5l
        zrYF2b+xaJoSCVzC7PFU4gAOFzbbEZ2sD/Eoo2O92RV8De1Q6lKIiW1cDKKyUKfF1pLK88
        rsOiAp2d84bOfC+jNJG0r6OyHfIAL4Q=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-Vk0ny81CNSGPDgaSgWYojg-1; Thu, 08 Sep 2022 10:26:18 -0400
X-MC-Unique: Vk0ny81CNSGPDgaSgWYojg-1
Received: by mail-qt1-f197.google.com with SMTP id h19-20020ac85493000000b00343408bd8e5so14516018qtq.4
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 07:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=RMcpwqPqWAUl25PqKrWr6Y7WQAHGIW5e+w2aQFa0sQg=;
        b=v0DJwkYZH8MOUNQB5WKGyYOmx1H4Bg0DvcysvEWxNNvr6ortdv3dTwKDr0JLgHJxb5
         ZPlpNLo78xCUPhLlPEVkdGeuBI7ZLs3nlaZD/r55yYgf/m0eqj4TM2KqACmo0KR+kN9l
         n/hRHt5NomXlzT+apO9NGe4JRPZbp/rry6XfNxKE5qBJ2SHdTAJne/UFmqkBba/WiPsj
         +w1GrF8DKPF7jH5hxOSbZAtzdovao17Ikl+eDrKZiJiJ4i7CShM98QawpZaVr6daAY7/
         zJYc7j6uYIliDtiMS6IuuHby4J0xyJC7rGDIFb7wG0Cz+GxzfKjE+l4oQvcEv3tYnXfl
         DaWA==
X-Gm-Message-State: ACgBeo1Tkg8RvXICG1wKWO8Nll/rapaCBpnCHuw20RRLxQGD+Bqcin0+
        EpcQoWZLYi88kSeWmum4e5GSNk/0qt3AEayJD6KcSi02lL9FU7mkI39Vma5HtzIy8MH5q4S9D3l
        yC6FRvs2ptAkIUSxg
X-Received: by 2002:a05:622a:2d1:b0:343:6193:3348 with SMTP id a17-20020a05622a02d100b0034361933348mr8214453qtx.633.1662647177529;
        Thu, 08 Sep 2022 07:26:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4+9coz+EzaDAS7QE+rrL05GUW6TNi8oKibhJQCwsvOVaopMNnnRbZp/JWMja/yS7o+S3/igg==
X-Received: by 2002:a05:622a:2d1:b0:343:6193:3348 with SMTP id a17-20020a05622a02d100b0034361933348mr8214429qtx.633.1662647177252;
        Thu, 08 Sep 2022 07:26:17 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id j7-20020a05620a410700b006bc68cfcdf7sm17735261qko.13.2022.09.08.07.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:26:16 -0700 (PDT)
Message-ID: <0ad4ba2bc157a2d1fa8a898056bea431fc244122.camel@redhat.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Date:   Thu, 08 Sep 2022 16:26:13 +0200
In-Reply-To: <CANn89iJzSgdQg3BO0ifEKOAaptBVfyH1kxKLOW=oMfojCiUvSg@mail.gmail.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
         <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
         <66c8b7c2-25a6-2834-b341-22b6498e3f7e@gmail.com>
         <fff6a18ddb74423cd31918802e4001f8bd7e27c5.camel@redhat.com>
         <CANn89iJzSgdQg3BO0ifEKOAaptBVfyH1kxKLOW=oMfojCiUvSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-09-08 at 05:20 -0700, Eric Dumazet wrote:
> On Thu, Sep 8, 2022 at 3:48 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Wed, 2022-09-07 at 13:40 -0700, Eric Dumazet wrote:
> > > On 9/7/22 13:19, Paolo Abeni wrote:
> > > > reviving an old thread...
> > > > On Wed, 2021-01-13 at 08:18 -0800, Eric Dumazet wrote:
> > > > > While using page fragments instead of a kmalloc backed skb->head might give
> > > > > a small performance improvement in some cases, there is a huge risk of
> > > > > under estimating memory usage.
> > > > [...]
> > > > 
> > > > > Note that we might in the future use the sk_buff napi cache,
> > > > > instead of going through a more expensive __alloc_skb()
> > > > > 
> > > > > Another idea would be to use separate page sizes depending
> > > > > on the allocated length (to never have more than 4 frags per page)
> > > > I'm investigating a couple of performance regressions pointing to this
> > > > change and I'd like to have a try to the 2nd suggestion above.
> > > > 
> > > > If I read correctly, it means:
> > > > - extend the page_frag_cache alloc API to allow forcing max order==0
> > > > - add a 2nd page_frag_cache into napi_alloc_cache (say page_order0 or
> > > > page_small)
> > > > - in __napi_alloc_skb(), when len <= SKB_WITH_OVERHEAD(1024), use the
> > > > page_small cache with order 0 allocation.
> > > > (all the above constrained to host with 4K pages)
> > > > 
> > > > I'm not quite sure about the "never have more than 4 frags per page"
> > > > part.
> > > > 
> > > > What outlined above will allow for 10 min size frags in page_order0, as
> > > > (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) == 384. I'm
> > > > not sure that anything will allocate such small frags.
> > > > With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page.
> > > 
> > > Well, some arches have PAGE_SIZE=65536 :/
> > 
> > Yes, the idea is to implement all the above only for arches with
> > PAGE_SIZE==4K. Would that be reasonable?
> 
> Well, we also have changed MAX_SKB_FRAGS from 17 to 45 for BIG TCP.
> 
> And locally we have
> 
> #define GRO_MAX_HEAD 192

default allocation size for napi_get_frags() is ~960b in google kernel,
right? It looks like it should fit the above quite nicely with 4 frags
per page?!?

Vanilla kernel may hit a larger number of fragments per page, even if
very likely not as high as the theoretical maximum mentioned in my
previous email (as noted by Alex). 

If in that case excessive truesize underestimation would still be
problematic (with a order0 4k page) __napi_alloc_skb() could be patched
to increase smaller sizes to some reasonable minimum. 

Likely there is some point in your reply I did not get. Luckily LPC is
coming :) 

> Reference:
> 
> commit fd9ea57f4e9514f9d0f0dec505eefd99a8faa148
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Jun 8 09:04:38 2022 -0700
> 
>     net: add napi_get_frags_check() helper

I guess such check should be revisited with all the above. 

Thanks,

Paolo

