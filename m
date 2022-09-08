Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9F5B1AC4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIHLA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIHLA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:00:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA735B276A
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662634854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tc8oQBF9Qw9ZbPm0DoFV49CE44ekZUxvU0qecc6cMtE=;
        b=OVXLA4Q0J68WGunkBvBFNZ/idUxzDmpZHcOOD3LQ9jnu6YllOuSD6xBUntOKiVmUxAaofw
        SxVkqpkNGkbMyECLQi/aQaejNlH6L1JMM8jdvlwPey0LMymPg6vBSfedEYFm4d4dA0/ESw
        wkhESoJnN22lxVMkK66vSIAgF0TcmBk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-A21GjwImO5aeRkl_hfFedw-1; Thu, 08 Sep 2022 07:00:53 -0400
X-MC-Unique: A21GjwImO5aeRkl_hfFedw-1
Received: by mail-wr1-f69.google.com with SMTP id h2-20020adfa4c2000000b00228db7822cbso2667094wrb.19
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 04:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=tc8oQBF9Qw9ZbPm0DoFV49CE44ekZUxvU0qecc6cMtE=;
        b=2G+IP8EzM+0SIxspRJGB0nBoZFVb5KgWOW71hi2MpapVwmvFt6nnr92N7D73y4PTcw
         tiNwJbdwU7kl0GZjIPfvKBp02cewDMZvQB3yWuYP5+W8MqLtvNiMm9EcrCtNz0H4pQTe
         oJ+dlV5UFn+11WovkYk0IOHpON4bGNjElVMq8kDsY75ASSoEkLslGsYmTv0SgPUMZ01V
         rx+8ZXHGAZtMh1k/LRkU3To1jMRwGsKJbHQso3AHx+pfYmAJvgToZty91cyO6uvMB3RY
         B1EF+9L/qKv8r5g6gXy+bfqbd3ZlNAvR/o2g2M26A1MMUNVvtgOfegqwsKPHpSAaKtQh
         RvEA==
X-Gm-Message-State: ACgBeo1fC2kAp7xqc5liB/q65J2X8JN5bZ5qkeRoJ0MgB2xqi4CXHejk
        Sp7ko4h1Z7d1mespTjoKM73nUhtiE12VBTJD6JW+prsAWANIkoaQMKWRf74RNYWAyIwwOP+gVFv
        I1jMVIqHYPn8f2GL7
X-Received: by 2002:a05:600c:3d09:b0:3a5:e408:ca19 with SMTP id bh9-20020a05600c3d0900b003a5e408ca19mr1883715wmb.135.1662634852104;
        Thu, 08 Sep 2022 04:00:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7rhUZPz9EVPjEB+7st3OYmzKDYw3L4ZpK/1dte/dIvQ+9VNa+WQ6kDF3k4FiQGXcttXvJvVQ==
X-Received: by 2002:a05:600c:3d09:b0:3a5:e408:ca19 with SMTP id bh9-20020a05600c3d0900b003a5e408ca19mr1883693wmb.135.1662634851820;
        Thu, 08 Sep 2022 04:00:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id m5-20020adff385000000b00228c792aaaasm13170345wro.100.2022.09.08.04.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 04:00:51 -0700 (PDT)
Message-ID: <498a25e4f7ba4e21d688ca74f335b28cadcb3381.camel@redhat.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Date:   Thu, 08 Sep 2022 13:00:50 +0200
In-Reply-To: <dcffcf6fde8272975e44124f55fba3936833360e.camel@gmail.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
         <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
         <dcffcf6fde8272975e44124f55fba3936833360e.camel@gmail.com>
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

On Wed, 2022-09-07 at 14:36 -0700, Alexander H Duyck wrote:
> On Wed, 2022-09-07 at 22:19 +0200, Paolo Abeni wrote:
> > What outlined above will allow for 10 min size frags in page_order0, as
> > (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) == 384. I'm
> > not sure that anything will allocate such small frags.
> > With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page. 
> 
> That doesn't account for any headroom though. 

Yes, the 0-size data packet was just a theoretical example to make the
really worst case scenario.

> Most of the time you have
> to reserve some space for headroom so that if this buffer ends up
> getting routed off somewhere to be tunneled there is room for adding to
> the header. I think the default ends up being NET_SKB_PAD, though many
> NICs use larger values. So adding any data onto that will push you up
> to a minimum of 512 per skb for the first 64B for header data.
> 
> With that said it would probably put you in the range of 8 or fewer
> skbs per page assuming at least 1 byte for data:
>   512 =	SKB_DATA_ALIGN(NET_SKB_PAD + 1) +
> 	SKB_DATA_ALIGN(struct skb_shared_info)

In most build GRO_MAX_HEAD packets are even larger (should be 640)

> > The maximum truesize underestimation in both cases will be lower than
> > what we can get with the current code in the worst case (almost 32x
> > AFAICS). 
> > 
> > Is the above schema safe enough or should the requested size
> > artificially inflatted to fit at most 4 allocations per page_order0?
> > Am I miss something else? Apart from omitting a good deal of testing in
> > the above list ;) 
> 
> If we are working with an order 0 page we may just want to split it up
> into a fixed 1K fragments and not bother with a variable pagecnt bias.
> Doing that we would likely simplify this quite a bit and avoid having
> to do as much page count manipulation which could get expensive if we
> are not getting many uses out of the page. An added advantage is that
> we can get rid of the pagecnt_bias and just work based on the page
> offset.
> 
> As such I am not sure the page frag cache would really be that good of
> a fit since we have quite a bit of overhead in terms of maintaining the
> pagecnt_bias which assumes the page is a bit longer lived so the ratio
> of refcnt updates vs pagecnt_bias updates is better.

I see. With the above schema there will be 4-6 frags per packet. I'm
wild guessing that the pagecnt_bias optimization still give some gain
in that case, but I really shold collect some data points.

If the pagecnt optimization should be dropped, it would be probably
more straight-forward to use/adapt 'page_frag' for the page_order0
allocator.

BTW it's quite strange/confusing having to very similar APIs (page_frag
and page_frag_cache) with very similar names and no references between
them.

Thanks!

Paolo

