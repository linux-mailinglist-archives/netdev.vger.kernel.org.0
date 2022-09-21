Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2485E54BF
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 22:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiIUUwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 16:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiIUUwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 16:52:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE5CA4051
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663793525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wO2hkXy0T956T4aeVGGbsF0leKYdI0J8fXj3X45k2m8=;
        b=dkMqD6syLdBzx6VxtN8TnuXIlAQxZGI7Jtyc0rEBPK5/FLx6XaAwQq1PvxNuNb/wBjD/xt
        t8anVS8/Y/xU1XKN73S74eR0dkz/PQ1OZ4cTF0rBJaHmttNJ+RarcrlE20rbZAZHEw7OtT
        wyi4GTDP/+w+yxKhsMY4+jlUVzxfRmA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-3QtSKtqoOMuEgCGGm4V1wQ-1; Wed, 21 Sep 2022 16:52:04 -0400
X-MC-Unique: 3QtSKtqoOMuEgCGGm4V1wQ-1
Received: by mail-qk1-f197.google.com with SMTP id n15-20020a05620a294f00b006b5768a0ed0so5077802qkp.7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=wO2hkXy0T956T4aeVGGbsF0leKYdI0J8fXj3X45k2m8=;
        b=6iPmm/AUX5aWiSnw68lbFeYvVLbq3tn5TBgHMFIA1kHm5LGdAoJTpuQ2f2ejs8NnNs
         FL7yAQ8g1LOKbQ/P+7INIPvWxdyccoB6Wr/hudGpFHS+2OHieA3cJlyS44Pigkjs1Ccz
         fevauFSpYPCbcnLPeQF5s7z2oJKkfWaUGvNcgBIE5gRjvkC6wR2bVra3hRVgzgh6gdWo
         3DDLjwAwInWIkiWRkKgIEvziANDdjsXfSHIe/ZeofLwcZYqxJiwKsfZrEt3g1fHPt4Gy
         hHXZTkka0aHXLmmHdUMzQKOeFbsRDFleaM6JgQVAtKG4OGuuEaROeuKgpoyVxPoFoUAv
         Qyhw==
X-Gm-Message-State: ACrzQf0BKxy2UXKBEU5JArbNMwlA3QyaHeyWS301Nd4bmcuypD5L2BCs
        ZJyiXgNIMx6BjWDEkEXFxLX8a+0Ce3Wwt4K/Ip5pPHjoKKnMv9Zqpx2zI0qQIHQP0LFRjeDPw9t
        qAPmE6lBzU7xNL0wK
X-Received: by 2002:ac8:59cd:0:b0:35c:e1f8:3382 with SMTP id f13-20020ac859cd000000b0035ce1f83382mr202367qtf.304.1663793523171;
        Wed, 21 Sep 2022 13:52:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM512sxILoqweUQWRCiNmCcYAPK93DjtsD+EJqOPyt7QWC3p7WyIj9osN/X96JGsP1yjhgTQaA==
X-Received: by 2002:ac8:59cd:0:b0:35c:e1f8:3382 with SMTP id f13-20020ac859cd000000b0035ce1f83382mr202358qtf.304.1663793522919;
        Wed, 21 Sep 2022 13:52:02 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id bk29-20020a05620a1a1d00b006bb208bd889sm2450172qkb.120.2022.09.21.13.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 13:52:02 -0700 (PDT)
Message-ID: <d347ab0f1a1aaf370d7d2908122bd886c02ec983.camel@redhat.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag
 cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 21 Sep 2022 22:51:58 +0200
In-Reply-To: <1642882091e772bcdbf44e61fe5fce125a034e52.camel@gmail.com>
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
         <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
         <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
         <1642882091e772bcdbf44e61fe5fce125a034e52.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 13:23 -0700, Alexander H Duyck wrote:
> On Wed, 2022-09-21 at 21:33 +0200, Paolo Abeni wrote:
> > Nice! I'll use that in v2, with page_ref_add(page, offset / SZ_1K - 1);
> > or we will leak the page.
> 
> No, the offset already takes care of the -1 via the "- SZ_1K". What we
> are adding is references for the unused offset.

You are right. For some reasons I keep reading PAGE_SIZE instead of
'offset'.

> > > 
> It occurs to me that I think you are missing the check for the gfp_mask
> and the reclaim and DMA flags values as a result with your change. I
> think we will need to perform that check before we can do the direct
> page allocation based on size.

Yes, the gtp_mask checks are required (it just stuck me a few moments
ago ;). I will move the code as you originally suggested.

> > > 
> > Why? in the end we will still use an ancillary variable and the
> > napi_alloc_cache struct will be bigger (probaly not very relevant, but
> > for no gain at all).
> 
> It was mostly just about reducing instructions. The thought is we could
> get rid of the storage of the napi cache entirely since the only thing
> used is the page member, so if we just passed that around instead it
> would save us the trouble and not really be another variable. Basically
> we would be passing a frag cache pointer instead of a napi_alloc_cache.

In that case we will still duplicate a bit of code  -
this_cpu_ptr(&napi_alloc_cache) on both branches. gcc 11.3.1 here says
that the generated code is smaller without this change.

Cheers,

Paolo

