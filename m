Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1EA5ED5BB
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiI1HL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbiI1HLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:11:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DC14AD4D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664349075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bc9uFDCtFpFNxdHZWOSYk92dw5sp3Qj8vI/egBSgnI0=;
        b=YOkQmm1A9rZN8Qx9rBpkaaPYSLMqAsIiGLV3NHhLkCw42B6r+ESh19+4xAbvLs5Vmtf08P
        UIOcrm4Tn096WoSIqRa5gKQx4ZUMtsgStgF/mcfraHosCgZVyNYYJ+hf7WMisIt+XQwEXt
        NDJdrGOmg6yUOcmhJCAXG2/x7vhinKw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-580-NVO42UBKNtKRYClq-3V8FQ-1; Wed, 28 Sep 2022 03:11:14 -0400
X-MC-Unique: NVO42UBKNtKRYClq-3V8FQ-1
Received: by mail-wm1-f72.google.com with SMTP id c130-20020a1c3588000000b003b56be513e1so258826wma.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=bc9uFDCtFpFNxdHZWOSYk92dw5sp3Qj8vI/egBSgnI0=;
        b=AEFFR65JfYOV5XlBqtqKhLTzBrGta7PfDT4rNxVtl2Y9jB6gsk+4bzxIWgJWXDYQ1A
         yI0+Z6Hv2k8qGGhmG4aqH+TJOpJaXBcKSgVIbtPKkywd9Qz4H6M7pnZoKRHIbYc2gSpO
         u2osNoanctFKC3aP2AbjGEXDp+DQw8uE17KeBSwBan6YQhRND0V/W0EjbCah7XKtTfjU
         2rcbWUHokEZEgYkEZTqsS55EPTE2ZZdSKMOQdMJ8wwKbRAnx9fNByQbEYG9Qqf+jRCbP
         a8tlLy5/HNy6m3oR6SWvsJRX/nteT6V3ALLoZFcn3ef+zU+sQmYk5lb5SseP39rB6gKG
         qwLQ==
X-Gm-Message-State: ACrzQf0EUapsukKJ2oyq6ugvSVVncW5s+SEoLHVtPHbkF4d69JPhWBjh
        wBrfzFuXABqfGEmK+HnzyF9fHbOAHtkykrr3/2Fh3vQjXO+Z02/hSYSjFTsYIZKf3kbBryoraP4
        JPyaNBFr6TFNHVh1r
X-Received: by 2002:a05:600c:1d94:b0:3b4:7b91:7056 with SMTP id p20-20020a05600c1d9400b003b47b917056mr5465607wms.18.1664349072635;
        Wed, 28 Sep 2022 00:11:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5C65EHVlGnOjjxvRSrZWsHA6NRVWKYi9diJhc5WG0ETulQhqZh4YWpBPkLJUJyb2yg/SWgJQ==
X-Received: by 2002:a05:600c:1d94:b0:3b4:7b91:7056 with SMTP id p20-20020a05600c1d9400b003b47b917056mr5465579wms.18.1664349072310;
        Wed, 28 Sep 2022 00:11:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c4f8200b003b27f644488sm892727wmq.29.2022.09.28.00.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 00:11:11 -0700 (PDT)
Message-ID: <a1884884db58d09a31611a5ed4c4e0ab97dd35c4.camel@redhat.com>
Subject: Re: [PATCH net-next v3] net: skb: introduce and use a single page
 frag cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexanderduyck@fb.com>
Date:   Wed, 28 Sep 2022 09:11:10 +0200
In-Reply-To: <CANn89i+NWzLxyXPMysaLrMZ-_fWmKUBTFdoL74exBzsSPi8Www@mail.gmail.com>
References: <8596dd058b9f94f519a8f035dbf8a94670c1ccea.1663953061.git.pabeni@redhat.com>
         <CANn89i+NWzLxyXPMysaLrMZ-_fWmKUBTFdoL74exBzsSPi8Www@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-09-27 at 21:05 -0700, Eric Dumazet wrote:
> On Fri, Sep 23, 2022 at 10:14 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> > for tiny skbs") we are observing 10-20% regressions in performance
> > tests with small packets. The perf trace points to high pressure on
> > the slab allocator.
> > 
> > This change tries to improve the allocation schema for small packets
> > using an idea originally suggested by Eric: a new per CPU page frag is
> > introduced and used in __napi_alloc_skb to cope with small allocation
> > requests.
> > 
> > To ensure that the above does not lead to excessive truesize
> > underestimation, the frag size for small allocation is inflated to 1K
> > and all the above is restricted to build with 4K page size.
> > 
> > Note that we need to update accordingly the run-time check introduced
> > with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").
> > 
> > Alex suggested a smart page refcount schema to reduce the number
> > of atomic operations and deal properly with pfmemalloc pages.
> > 
> > Under small packet UDP flood, I measure a 15% peak tput increases.
> > 
> > Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Suggested-by: Alexander H Duyck <alexanderduyck@fb.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > v2 -> v3:
> >  - updated Alex email address
> >  - fixed build with !NAPI_HAS_SMALL_PAGE_FRAG
> > 
> > v1 -> v2:
> >  - better page_frag_alloc_1k() (Alex & Eric)
> >  - avoid duplicate code and gfp_flags misuse in __napi_alloc_skb() (Alex)
> > ---
> >  include/linux/netdevice.h |   1 +
> >  net/core/dev.c            |  17 ------
> >  net/core/skbuff.c         | 112 ++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 108 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 9f42fc871c3b..a1938560192a 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3822,6 +3822,7 @@ void netif_receive_skb_list(struct list_head *head);
> >  gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
> >  void napi_gro_flush(struct napi_struct *napi, bool flush_old);
> >  struct sk_buff *napi_get_frags(struct napi_struct *napi);
> > +void napi_get_frags_check(struct napi_struct *napi);
> >  gro_result_t napi_gro_frags(struct napi_struct *napi);
> >  struct packet_offload *gro_find_receive_by_type(__be16 type);
> >  struct packet_offload *gro_find_complete_by_type(__be16 type);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index d66c73c1c734..fa53830d0683 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6358,23 +6358,6 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
> >  }
> >  EXPORT_SYMBOL(dev_set_threaded);
> > 
> > -/* Double check that napi_get_frags() allocates skbs with
> > - * skb->head being backed by slab, not a page fragment.
> > - * This is to make sure bug fixed in 3226b158e67c
> > - * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > - * does not accidentally come back.
> > - */
> > -static void napi_get_frags_check(struct napi_struct *napi)
> > -{
> > -       struct sk_buff *skb;
> > -
> > -       local_bh_disable();
> > -       skb = napi_get_frags(napi);
> > -       WARN_ON_ONCE(skb && skb->head_frag);
> > -       napi_free_frags(napi);
> > -       local_bh_enable();
> > -}
> > -
> >  void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
> >                            int (*poll)(struct napi_struct *, int), int weight)
> >  {
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index f1b8b20fc20b..e7578549a561 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -134,8 +134,73 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
> >  #define NAPI_SKB_CACHE_BULK    16
> >  #define NAPI_SKB_CACHE_HALF    (NAPI_SKB_CACHE_SIZE / 2)
> > 
> > +/* the compiler doesn't like 'SKB_TRUESIZE(GRO_MAX_HEAD) > 512', but we
> > + * can imply such condition checking the double word and MAX_HEADER size
> > + */
> > +#if PAGE_SIZE == SZ_4K && (defined(CONFIG_64BIT) || MAX_HEADER > 64)
> 
> This looks quite convoluted to me.
> It hides the relation between GRO_MAX_HEAD and MAX_HEADER ?
> Is anyone going to notice if we consume 1K instead of 512 bytes on
> 32bit arches, and when LL_MAX_HEADER==32
> and no tunnel is enabled ?

Indeed I was a little doubious about the above, as I agree it's quite
convoluted. In the end I preferred a "better safe than sorry" approach,
but I agree that is possibly too much conservative.

> I would simply use
> 
> #if PAGE_SIZE == SZ_4K

I'll do in the next revision.

> > +
> > +#define NAPI_HAS_SMALL_PAGE_FRAG       1
> > +#define NAPI_SMALL_PAGE_PFMEMALLOC(nc) ((nc).pfmemalloc)
> > +
> > +/* specializzed page frag allocator using a single order 0 page
> 
> specialized

Thanks,

Paolo

