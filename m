Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBFC5FD39D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 05:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiJMDtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 23:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJMDtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 23:49:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21958108E;
        Wed, 12 Oct 2022 20:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65EA4615B1;
        Thu, 13 Oct 2022 03:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722FCC433D6;
        Thu, 13 Oct 2022 03:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665632982;
        bh=K3+Spu2EH3logPqr6cSQ4UYLEL0vGrnyEj+WmuJ3JBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Unfvd/ba7xDuF/KobnJt1U+LcAN7ZarvrDzLSuU/wW4Ws67soEe9x2YoNTxfn6NVH
         WhonJ5zXVbly3kfiG2sU6O6X9LCr/pmVrWwZCsI9E7LOAKeeLevoCy/iO0sHje6fXF
         fsEhn/xJyCGNMLLWKkiqNsNCzeyXoV48qWUGH0FpeNASXvY4xk9wDV4hXEJ4kMSvwd
         rHolzENWpMMfx5r7ebhZcjwG/NkrYOXXsfzRxXdJHtHXwRAweb8AWQu4BrkyPSFo3i
         xns1kWtwdcFO1ESO7Hfzq/TX1M8T7KDC8ycu9TniAG40FNFf5hBj39e7rApYjIepdK
         mxQZNNUgXRvnw==
Date:   Wed, 12 Oct 2022 20:49:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Message-ID: <20221012204941.3223d205@kernel.org>
In-Reply-To: <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
        <20221012173825.45d6fbf2@kernel.org>
        <20221013005431.wzjurocrdoozykl7@google.com>
        <20221012184050.5a7f3bde@kernel.org>
        <20221012201650.3e55331d@kernel.org>
        <CAEA6p_CqqPtnWjr_yYr1oVF3UKe=6RqFLrg1OoANs2eg5_by0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 20:34:00 -0700 Wei Wang wrote:
> > I pushed this little nugget to one affected machine via KLP:
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 03ffbb255e60..c1ca369a1b77 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -7121,6 +7121,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> >                 return true;
> >         }
> >
> > +       if (gfp_mask == GFP_NOWAIT) {
> > +               try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
> > +               refill_stock(memcg, nr_pages);
> > +       }
> >         return false;
> >  }
> >  
> AFAICT, if you force charge by passing __GFP_NOFAIL to try_charge(),
> you should return true to tell the caller that the nr_pages is
> actually being charged.

Ack - not sure what the best thing to do is, tho. Always pass NOFAIL 
in softirq?

It's not clear to me yet why doing the charge/uncharge actually helps,
perhaps try_to_free_mem_cgroup_pages() does more when NOFAIL is passed?

I'll do more digging tomorrow.

> Although I am not very sure what refill_stock() does. Does that
> "uncharge" those pages?

I think so, I copied it from mem_cgroup_uncharge_skmem().
