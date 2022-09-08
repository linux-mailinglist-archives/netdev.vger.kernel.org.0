Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC8A5B1A70
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 12:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiIHKsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 06:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiIHKsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 06:48:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0431DED3B4
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 03:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662634091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yfx6Pf7fOZJ08hVi3MDI43RjV5cYDVw4BdOhPdnkxu4=;
        b=YkyCXJBAHVPDovjTJtEprrd/kFhIwXVIfq1iwzvguFAvbNA6fQKgzp6V3QdfxXjwOiV5r2
        1JMifKX+xY9xPYd+2YJvvfkadwCE53ze6hkctBHCpCqT01lMS3miEJu9eXeScHcUvzodKQ
        +n1AF79caluqPt2iQ7X1WaAa+z20uOQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-9VmBXe3iPo26hvm72DA_Xw-1; Thu, 08 Sep 2022 06:48:09 -0400
X-MC-Unique: 9VmBXe3iPo26hvm72DA_Xw-1
Received: by mail-qv1-f72.google.com with SMTP id g4-20020ad45424000000b004a9bb302c85so7088053qvt.22
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 03:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=yfx6Pf7fOZJ08hVi3MDI43RjV5cYDVw4BdOhPdnkxu4=;
        b=YQYepPd4TqLhw7vSXyjA7AsYg7JW725f0ZOos2bFYMmmZfe3zJ1kgMq8ET6CuiQ59N
         ufc9vaTcbF2Ew/kUBv5GQ9BI3xlQlJN24JhP0OfNlnCjIJPZMSAlVooe5gbFOlJGc+9D
         fqbzHMeJtXHd1aoduGA/b3G2V5QGvf1I7dY8bUNSOrOcAFZ235LZkOAB5l5+p8JN/VjG
         fBX4D6VO2tzG9IriM9ZmMWoHrJvUAU0PJgPNcKyB7hbcfL5rgJkCzn2EdhpJp1DWqNvY
         ZBUHsjZHNCl4Pk9IBN3rn2gCO0fa0YXV84K5WvVdrC0dXHdwAJHlqhNZhJLDikZkVcQt
         FRjA==
X-Gm-Message-State: ACgBeo0U0i346U/60qWmBYNMQ/pAAgLFZs8eYN2k3MZKKdsIo1F04V+z
        1eDJJXukDKxGHSC20VUqsNq0iTD3//pe0WlpFdtNbpq3zuvofH3rPGSSuhjBPnZp30LW/hnsXhh
        GkGfP4mHcckmxumD4
X-Received: by 2002:ad4:5c6f:0:b0:4aa:a393:fe85 with SMTP id i15-20020ad45c6f000000b004aaa393fe85mr6696467qvh.124.1662634089427;
        Thu, 08 Sep 2022 03:48:09 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4y2W4LejdYbw3BROZCwbWX/f7TdFQGfm8JOHS5wVF3jE7vJfCgi1ij92pkBCpt4BWBEPbYFw==
X-Received: by 2002:ad4:5c6f:0:b0:4aa:a393:fe85 with SMTP id i15-20020ad45c6f000000b004aaa393fe85mr6696449qvh.124.1662634089214;
        Thu, 08 Sep 2022 03:48:09 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id m11-20020a05620a290b00b006bb87c4833asm17594284qkp.109.2022.09.08.03.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 03:48:08 -0700 (PDT)
Message-ID: <fff6a18ddb74423cd31918802e4001f8bd7e27c5.camel@redhat.com>
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
Date:   Thu, 08 Sep 2022 12:48:05 +0200
In-Reply-To: <66c8b7c2-25a6-2834-b341-22b6498e3f7e@gmail.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
         <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
         <66c8b7c2-25a6-2834-b341-22b6498e3f7e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-07 at 13:40 -0700, Eric Dumazet wrote:
> On 9/7/22 13:19, Paolo Abeni wrote:
> > Hello,
> > 
> > reviving an old thread...
> > On Wed, 2021-01-13 at 08:18 -0800, Eric Dumazet wrote:
> > > While using page fragments instead of a kmalloc backed skb->head might give
> > > a small performance improvement in some cases, there is a huge risk of
> > > under estimating memory usage.
> > [...]
> > 
> > > Note that we might in the future use the sk_buff napi cache,
> > > instead of going through a more expensive __alloc_skb()
> > > 
> > > Another idea would be to use separate page sizes depending
> > > on the allocated length (to never have more than 4 frags per page)
> > I'm investigating a couple of performance regressions pointing to this
> > change and I'd like to have a try to the 2nd suggestion above.
> > 
> > If I read correctly, it means:
> > - extend the page_frag_cache alloc API to allow forcing max order==0
> > - add a 2nd page_frag_cache into napi_alloc_cache (say page_order0 or
> > page_small)
> > - in __napi_alloc_skb(), when len <= SKB_WITH_OVERHEAD(1024), use the
> > page_small cache with order 0 allocation.
> > (all the above constrained to host with 4K pages)
> > 
> > I'm not quite sure about the "never have more than 4 frags per page"
> > part.
> > 
> > What outlined above will allow for 10 min size frags in page_order0, as
> > (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) == 384. I'm
> > not sure that anything will allocate such small frags.
> > With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page.
> 
> Well, some arches have PAGE_SIZE=65536 :/

Yes, the idea is to implement all the above only for arches with
PAGE_SIZE==4K. Would that be reasonable? 

Thanks!

Paolo

