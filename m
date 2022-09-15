Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9655B98CD
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIOKb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIOKb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:31:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC0E8981D
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 03:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663237885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HL5dXGFkel+k2FQJcxVsi3gdKr147k7OQegCjfsQj8=;
        b=NyN/QGyAzmK4/mKxxl6/MORN0Z8RLWWF9CBGoVxQYUW22eWB3JBrnxGoDt0IDGHvFjronA
        YNvOiAXL+CQ/+rGrfjBrSAI+lRMnXGfnazRUjDrlOzygyvE48ZkPLP1JxQq0ksjo+ypRmH
        JwJs+8GrKhdznnoMNPXj56NlV20anxk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-536-IKCu1LzjM_WEz2erFveoCw-1; Thu, 15 Sep 2022 06:31:24 -0400
X-MC-Unique: IKCu1LzjM_WEz2erFveoCw-1
Received: by mail-wr1-f71.google.com with SMTP id s1-20020adf9781000000b002286cd81376so4660633wrb.22
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 03:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=+HL5dXGFkel+k2FQJcxVsi3gdKr147k7OQegCjfsQj8=;
        b=FwJXzYUp8riBfe0xAp4wh6MUkxP9DHj9jVoN1+0dO9jCe4/dizOAiu0grvH1CBb3Zv
         hg10HMiUoOb2Zypa41QdpuMBXfR8OrTwR8Ce+5y5Qpu4ULlbsJ7DuljTrJGlXnKQI1zJ
         yLM/fpT7cHWnu0FOTKa4zFQdMHOJJWGlayCn4FcTkA0B1Fr9iSL5v0BO1zcqRZGL2dl1
         hw33uCFj/zTy0j4wifGrl2t71AuDF96Q8Bg9M3ks55gFzJL5iyyzZ2M2NszeRm9MdGkU
         ZTcW0mOyN3drwjYU1xErfQ0mbHtorTfQQI/f2BM5qTqCi68Lc+O7rbTekVI7zSuKdOdo
         wXvg==
X-Gm-Message-State: ACgBeo3vhKqGS4hvbW6yGBzPInbIf6506Jqjo0OroCpO89ET3YgghsHo
        u1+LC/IunrzIVFWxfyQvHCZL8XWYU9/YPKf0O9HpCyS13M6XIn8j5t9E61OgsuEdUOixi0afxcp
        NXszwqex3ojdQEYij
X-Received: by 2002:a05:600c:6029:b0:3b4:9fcc:cbb3 with SMTP id az41-20020a05600c602900b003b49fcccbb3mr5512263wmb.169.1663237882135;
        Thu, 15 Sep 2022 03:31:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5XPvzR/ghLHKj+PVThKHDYUBLDDfRYhLss6ghZ4gVD0CLcwv/vZQS+bRRJqkobowYqE+LDJQ==
X-Received: by 2002:a05:600c:6029:b0:3b4:9fcc:cbb3 with SMTP id az41-20020a05600c602900b003b49fcccbb3mr5512234wmb.169.1663237881772;
        Thu, 15 Sep 2022 03:31:21 -0700 (PDT)
Received: from gerbillo.redhat.com ([212.2.180.165])
        by smtp.gmail.com with ESMTPSA id q12-20020a1ce90c000000b003a844885f88sm2201509wmc.22.2022.09.15.03.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 03:31:21 -0700 (PDT)
Message-ID: <800a1c4eead00b97947e4b289ae49d2858e9f99e.camel@redhat.com>
Subject: Re: [PATCH net] net: tun: limit first seg size to avoid oversized
 linearization
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petar Penkov <peterpenkov96@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>
Date:   Thu, 15 Sep 2022 12:31:20 +0200
In-Reply-To: <efc3708e-47d8-b3e8-08a9-40031d11b8ff@huawei.com>
References: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
         <CANn89iKPmDXvPzw9tYpiqHH7LegAgTb14fAiAqH8vAxZ3KsryA@mail.gmail.com>
         <efc3708e-47d8-b3e8-08a9-40031d11b8ff@huawei.com>
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

On Tue, 2022-09-13 at 20:07 +0800, Ziyang Xuan (William) wrote:
> > On Tue, Sep 6, 2022 at 6:56 PM Ziyang Xuan
> > <william.xuanziyang@huawei.com> wrote:
> > > 
> > > Recently, we found a syzkaller problem as following:
> > > 
> > > ========================================================
> > > WARNING: CPU: 1 PID: 17965 at mm/page_alloc.c:5295
> > > __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
> > > ...
> > > Call trace:
> > >  __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
> > >  __alloc_pages_node include/linux/gfp.h:550 [inline]
> > >  alloc_pages_node include/linux/gfp.h:564 [inline]
> > >  kmalloc_large_node+0x94/0x350 mm/slub.c:4038
> > >  __kmalloc_node_track_caller+0x620/0x8e4 mm/slub.c:4545
> > >  __kmalloc_reserve.constprop.0+0x1e4/0x2b0 net/core/skbuff.c:151
> > >  pskb_expand_head+0x130/0x8b0 net/core/skbuff.c:1654
> > >  __skb_grow include/linux/skbuff.h:2779 [inline]
> > >  tun_napi_alloc_frags+0x144/0x610 drivers/net/tun.c:1477
> > >  tun_get_user+0x31c/0x2010 drivers/net/tun.c:1835
> > >  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
> > > 
> > > It is because the first seg size of the iov_iter from user space
> > > is
> > > very big, it is 2147479538 which is bigger than the threshold
> > > value
> > > for bail out early in __alloc_pages(). And skb->pfmemalloc is
> > > true,
> > > __kmalloc_reserve() would use pfmemalloc reserves without
> > > __GFP_NOWARN
> > > flag. Thus we got a warning.
> > > 
> > > I noticed that non-first segs size are required less than
> > > PAGE_SIZE in
> > > tun_napi_alloc_frags(). The first seg should not be a special
> > > case, and
> > > oversized linearization is also unreasonable. Limit the first seg
> > > size to
> > > PAGE_SIZE to avoid oversized linearization.
> > > 
> > > Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP
> > > driver")
> > > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > > ---
> > >  drivers/net/tun.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > index 259b2b84b2b3..7db515f94667 100644
> > > --- a/drivers/net/tun.c
> > > +++ b/drivers/net/tun.c
> > > @@ -1454,12 +1454,12 @@ static struct sk_buff
> > > *tun_napi_alloc_frags(struct tun_file *tfile,
> > >                                             size_t len,
> > >                                             const struct iov_iter
> > > *it)
> > >  {
> > > +       size_t linear = iov_iter_single_seg_count(it);
> > >         struct sk_buff *skb;
> > > -       size_t linear;
> > >         int err;
> > >         int i;
> > > 
> > > -       if (it->nr_segs > MAX_SKB_FRAGS + 1)
> > > +       if (it->nr_segs > MAX_SKB_FRAGS + 1 || linear >
> > > PAGE_SIZE)
> > >                 return ERR_PTR(-EMSGSIZE);
> > > 
> > 
> > This does not look good to me.
> > 
> > Some drivers allocate 9KB+ for 9000 MTU, in a single allocation,
> > because the hardware is not SG capable in RX.
> 
> So, do you mean that it does not matter and keep current status, or
> give a bigger size but PAGE_SIZE (usually 4KB size)?
> 
> Would like to hear your advice.

I'm guessing that what Eric is suggesting here is to use a bigger limit
for 'linear'. Possibly ETH_MAX_MTU could fit. @Eric, fell free to
correct me :)

Thanks!

Paolo

