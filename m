Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984DE5E685F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiIVQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiIVQ3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:29:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6400E11DA
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 09:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663864155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gbm3MGzkzAzqLi6unjp6uyGziEmnPXsJ0Wi7D6W5hg8=;
        b=ilpV/ja9IzWfIiLGM8Qhs0uqxjNkW8RB9BOpIAmOJ05oIn299FG63F5xtIuRe9JGn8d5Gk
        baRFR5x2jHJ9FPJ3ospoQ5u/PKW4PhB0sxGMPBqo4YGDhsuFlGD8SvwOOPZfKDX6e6BJpV
        N9gH2CGDAolgpoRkBtI6Fo2KQsxsdg8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121-2pEwn2rVP5mdUO-pshzjLA-1; Thu, 22 Sep 2022 12:29:14 -0400
X-MC-Unique: 2pEwn2rVP5mdUO-pshzjLA-1
Received: by mail-wr1-f72.google.com with SMTP id e2-20020adf9bc2000000b0022ae4ea0afcso1251588wrc.8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 09:29:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Gbm3MGzkzAzqLi6unjp6uyGziEmnPXsJ0Wi7D6W5hg8=;
        b=duIPN467dEZcHIZiEXtCc1USqOkIYnT5f/jNbi3kMn3EztGxIZ9DjmCJfMODmDYZBn
         tRmLgDkJAzh3eaCxkvRRn2N8anGeuCpslj5mVHhXL2gJvQtJDPFB61Qq7OeSTZwQCtPr
         iguYR3oBEi32ZyXB3VUUJQ4p9fp5tT7gY5TZQYs4fLSwVXHgnAnGZOLTn/Vsdl6C8tju
         If00Gg65QW1rXFs8fV0lIi4ofnbQWsLPij5wjoQwGGF07eY0gZteP0CjMYpW5rQc3Wyi
         NHcViMN6bgxE1B8xjmGZiX6HFaFjDvF2Alm/19yNIyw4QHNWne58h3HcPt+kdbKZHjB5
         tefw==
X-Gm-Message-State: ACrzQf0MMKxrQukrQh3Izm2yuNfAa0Bv+iSSUpsv7DwrhxLunDJld70M
        XYyFtZgbu/AY5DUi8O4p+jk1ouwmEl7OTNBBkDYrqCzJXshg/AyRVswbyQXZH4XtEf3EIgpH1gk
        YtKMscD8g2U+xynMl
X-Received: by 2002:a05:6000:2aa:b0:22b:1dd4:f72d with SMTP id l10-20020a05600002aa00b0022b1dd4f72dmr2803282wry.616.1663864153264;
        Thu, 22 Sep 2022 09:29:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7aAXx2/5S4lbQQYW3Due6Q2uKMZNEk6/EXrZLbAHe7wbmhUOEnshefJbiauMCos4bNTlQv7g==
X-Received: by 2002:a05:6000:2aa:b0:22b:1dd4:f72d with SMTP id l10-20020a05600002aa00b0022b1dd4f72dmr2803266wry.616.1663864153017;
        Thu, 22 Sep 2022 09:29:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id s8-20020adfeb08000000b0022b1ffa7480sm6223155wrn.0.2022.09.22.09.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 09:29:12 -0700 (PDT)
Message-ID: <791065bb090ffe08f170e91bd7fabe0a5660ab53.camel@redhat.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag
 cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 22 Sep 2022 18:29:11 +0200
In-Reply-To: <CAKgT0Uf-fDHD_g75PSO591WVHdtHuUJ+L=aWBWoiM3vHyzxRtw@mail.gmail.com>
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
         <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
         <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
         <1642882091e772bcdbf44e61fe5fce125a034e52.camel@gmail.com>
         <d347ab0f1a1aaf370d7d2908122bd886c02ec983.camel@redhat.com>
         <CAKgT0Uf-fDHD_g75PSO591WVHdtHuUJ+L=aWBWoiM3vHyzxRtw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 14:44 -0700, Alexander Duyck wrote:
> On Wed, Sep 21, 2022 at 1:52 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > In that case we will still duplicate a bit of code  -
> > this_cpu_ptr(&napi_alloc_cache) on both branches. gcc 11.3.1 here says
> > that the generated code is smaller without this change.
> 
> Why do you need to duplicate it? 

The goal was using a single local variable to track the napi cache and
the memory info. I thought ("was sure") that keeping two separate
variables ('nc' and 'page_frag' instead of 'nc' and 'pfmemalloc') would
produce the same amount of code. gcc says I'm wrong and you are right
;)

I'll use that in v2, thanks!

Paolo

