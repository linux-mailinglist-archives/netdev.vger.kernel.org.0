Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD275B0E05
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiIGUUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiIGUUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:20:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573825D0C6
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662581999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9bGApLVZjZf2Pt5T8EGnmMcSyM2NNytRS2Xq0m7fxGc=;
        b=UuSNaqA4ptOskB4BKl74zCBzYfexvUDXGWM8wheeoIMDGxjYqV0S14WtMe8HrcwK2IIir2
        qzJmtu36/aCFot2pKfO+nsxrm6cXLSeT537DDZd2+OuMwhh4f6oXBy3oBhjOOjiLmEM3tg
        ujFwH3ysqNzigLcyZ5W3xZiPw1YWGsM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-8y_DgmhJP7K2fLel9kclfQ-1; Wed, 07 Sep 2022 16:19:58 -0400
X-MC-Unique: 8y_DgmhJP7K2fLel9kclfQ-1
Received: by mail-qv1-f70.google.com with SMTP id q5-20020a056214194500b004a03466c568so8085816qvk.19
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 13:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=9bGApLVZjZf2Pt5T8EGnmMcSyM2NNytRS2Xq0m7fxGc=;
        b=hi56ohL1byXoEXCvHtR6a9sbGzio7fTy9dnNxC7OLPmWxtZN9ss/Tx0lU4MNVJJG6a
         fXAzrqslt/D83kkyW8N9kRy1zydmSukfytDN5iIRG2hUfG5NWtUZY3krEm4EY028qiLu
         66s6mdl5IX4C0aWlW+ke8sguG4j72qTK4nQDRSh0AguAQtz2rn/ilvF690KHfm58T0RR
         3DHDW4zBwpRVKZ4nSoijPa16IlOc68PQK2XtRHuOQihJJ+nXp6TZrBjGrUkEPrsJzsiM
         tjnULDF9NWhDCOcvMHTj7HVZWQEjEAX4mjkTLstWRI7E5lfBVl4lCBNqt7t+Zl9Dre6C
         GXhA==
X-Gm-Message-State: ACgBeo0yfc6flbYAeQnaYy3mrbDvbyT62E5dd/ZWxXoV3IbXfi3aDiK+
        Vruys8fOwjyUXuis+8UbtTHzQrGS+96aKotYfXYuX4pU/1Gpn/+9Cg59HE2qycD5LbG14WJUoWE
        SJShhYGZJjh8DZ8Kb
X-Received: by 2002:a05:620a:600f:b0:6bc:612f:a0a6 with SMTP id dw15-20020a05620a600f00b006bc612fa0a6mr4068271qkb.497.1662581998013;
        Wed, 07 Sep 2022 13:19:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6DTLWnhaCXPHsRPVswPTQH42kJB8lCWnVDQk/dFU9JMwvVAPrv8YyfMUERdBEpVO0sGEbqFQ==
X-Received: by 2002:a05:620a:600f:b0:6bc:612f:a0a6 with SMTP id dw15-20020a05620a600f00b006bc612fa0a6mr4068253qkb.497.1662581997776;
        Wed, 07 Sep 2022 13:19:57 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-72.dyn.eolo.it. [146.241.112.72])
        by smtp.gmail.com with ESMTPSA id o12-20020ac841cc000000b003430589dd34sm13000272qtm.57.2022.09.07.13.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 13:19:57 -0700 (PDT)
Message-ID: <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Date:   Wed, 07 Sep 2022 22:19:53 +0200
In-Reply-To: <20210113161819.1155526-1-eric.dumazet@gmail.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
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

Hello,

reviving an old thread...
On Wed, 2021-01-13 at 08:18 -0800, Eric Dumazet wrote:
> While using page fragments instead of a kmalloc backed skb->head might give
> a small performance improvement in some cases, there is a huge risk of
> under estimating memory usage.

[...]

> Note that we might in the future use the sk_buff napi cache,
> instead of going through a more expensive __alloc_skb()
> 
> Another idea would be to use separate page sizes depending
> on the allocated length (to never have more than 4 frags per page)

I'm investigating a couple of performance regressions pointing to this
change and I'd like to have a try to the 2nd suggestion above. 

If I read correctly, it means:
- extend the page_frag_cache alloc API to allow forcing max order==0
- add a 2nd page_frag_cache into napi_alloc_cache (say page_order0 or
page_small)
- in __napi_alloc_skb(), when len <= SKB_WITH_OVERHEAD(1024), use the
page_small cache with order 0 allocation.
(all the above constrained to host with 4K pages)

I'm not quite sure about the "never have more than 4 frags per page"
part.

What outlined above will allow for 10 min size frags in page_order0, as
(SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) == 384. I'm
not sure that anything will allocate such small frags.
With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page. 

The maximum truesize underestimation in both cases will be lower than
what we can get with the current code in the worst case (almost 32x
AFAICS). 

Is the above schema safe enough or should the requested size
artificially inflatted to fit at most 4 allocations per page_order0?
Am I miss something else? Apart from omitting a good deal of testing in
the above list ;) 

Thanks!

Paolo

