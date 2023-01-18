Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A1A6722A1
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjARQJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjARQJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:09:22 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DA64B885
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:05:22 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-4d19b2686a9so346560047b3.6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mv4WhZ9tz8M4h+dBHkfCDtia/ozTrylSiZoNS6twafM=;
        b=dO861jhouGEyJtteCRsHOvvj0kKfgM3/TufeAYlDSjxopVsneXc7xqT1bBVmRIIsuF
         lduRc0eZVfWk3lrZHUtIOO9SLaFojv+KZ8Yot5I3TMH0N6P4XrSMUwHo69+3n1xQFDFg
         p0r3nvaFrer2un+dNvns2WvyjUrahHZpSDkoJ18fcJ05GLPJH/eZocyqWAWp+OFfx4m1
         /eo7PzRYWMJ9+7vpfCpmMz6rcCLueF7svkNOTn2m72nmRKPiuYzOIIuzT+hhP6pgz/2+
         KX3iqrIZCFn3GK10CY1YMdd1A7nyNGMLvwGETXSdeNMMacXnLjUdvlwDmkVjid2oT9BK
         fzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mv4WhZ9tz8M4h+dBHkfCDtia/ozTrylSiZoNS6twafM=;
        b=oGeRBoadwiravEcmantg0pf152d9l0ByubYTb58nF9MZdBUiZFetcGYklX7hqQJjmo
         qWJdhzSHcQq5c8UpxQmK+Lxq9JIprs3TbpSyZdbmxY5xXQyOIwkEhAcaIKiOdukphYol
         ztheSIfN5ALcKO3TwDHdm9/p0XZ9l7UhG4Dh1TN1ClOKoy9Zczy8BV4wm/T5gG/8vVAZ
         eeVF0K55YLhbHr2lnQFPVq1PKBvF/C6Y6vmr/Lv1od07VHzTQf/+WiHbc0HwdGwZogpv
         FLsOIwNx/9SIr7ioMHvGvnMtP0O655NoJpdi75wiM6GKqB5JxIc5XoI70mmHFj/d/HvV
         yKJg==
X-Gm-Message-State: AFqh2koe2llYm0q2EhFYpJWH5hvW2e0em3S1WP0nCu6OTcpNZ0MEiH+c
        OT0/xhF/Gh/5kEXhOyYarE1oqzhuSk900IkxceeXRCG74lqeZw==
X-Google-Smtp-Source: AMrXdXusY7xUHC2uvlM4HxMdPPtpaDSVJiuXcxBKId0oau0baMf/TPqRt6nmqhszDJW5i0tdMjPUYqBSFgfYSTNh/Dg=
X-Received: by 2002:a81:6e46:0:b0:37e:6806:a5f9 with SMTP id
 j67-20020a816e46000000b0037e6806a5f9mr933494ywc.47.1674057921679; Wed, 18 Jan
 2023 08:05:21 -0800 (PST)
MIME-Version: 1.0
References: <167361788585.531803.686364041841425360.stgit@firesoul> <167361792462.531803.224198635706602340.stgit@firesoul>
In-Reply-To: <167361792462.531803.224198635706602340.stgit@firesoul>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 18 Jan 2023 17:05:09 +0100
Message-ID: <CANn89i+POvkrx-RW3WNA2-1oQSdHt2-0sOddQWwtGQkAbW9RFQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use kmem_cache_free_bulk
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 2:52 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> The kfree_skb_list function walks SKB (via skb->next) and frees them
> individually to the SLUB/SLAB allocator (kmem_cache). It is more
> efficient to bulk free them via the kmem_cache_free_bulk API.
>
> This patches create a stack local array with SKBs to bulk free while
> walking the list. Bulk array size is limited to 16 SKBs to trade off
> stack usage and efficiency. The SLUB kmem_cache "skbuff_head_cache"
> uses objsize 256 bytes usually in an order-1 page 8192 bytes that is
> 32 objects per slab (can vary on archs and due to SLUB sharing). Thus,
> for SLUB the optimal bulk free case is 32 objects belonging to same
> slab, but runtime this isn't likely to occur.
>
> The expected gain from using kmem_cache bulk alloc and free API
> have been assessed via a microbencmark kernel module[1].
>
> The module 'slab_bulk_test01' results at bulk 16 element:
>  kmem-in-loop Per elem: 109 cycles(tsc) 30.532 ns (step:16)
>  kmem-bulk    Per elem: 64 cycles(tsc) 17.905 ns (step:16)
>
> More detailed description of benchmarks avail in [2].
>
> [1] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm
> [2] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org
>
> V2: rename function to kfree_skb_add_bulk.
>
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

According to syzbot, this patch causes kernel panics, in IP fragmentation logic.

Can you double check if there is no obvious bug ?
