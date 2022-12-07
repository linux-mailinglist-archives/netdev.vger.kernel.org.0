Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5116452D5
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLGEEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLGEEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:04:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E66510043;
        Tue,  6 Dec 2022 20:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4728B81CBF;
        Wed,  7 Dec 2022 04:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BDCC433C1;
        Wed,  7 Dec 2022 04:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670385856;
        bh=hZuuBjFD5s3iT0ZcFcf+0PFFOJ4BHuMDbqodL+1hsnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tGd2X79tBm9S3hp6wNB+GiMth5EDBmnMYb85fxhanjQfvkrQk9grXEugvvDbL+mlh
         8fep0KofSNrT9N9KDEy8YYWWdOcricb4R4BQo5Xbqp5ef+puJLWZNV/+L8oqN1/AVz
         UTt6cnAQ8KwBhqNGaUV+HNrvr8GsxNWoLtn8TE9sg1G3UpKK/yjRQhEzWdw/STxVrz
         y8DHN+Jk+k1wvf7Ek6jcnKcm8jmHNHDOKrberhU+9NzFd2g9Vb8jUvAOMWghP8fDbl
         zwu+yecNn2bwjhmYy3haMFokzqQKASd94vG7jJZD+v7JdSXCnMLEJH43cVTTEBZ7lc
         Vx2CnNIs/pRgw==
Date:   Tue, 6 Dec 2022 20:04:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <kees@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        pepsipu <soopthegoop@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, martin.lau@linux.dev,
        Stanislav Fomichev <sdf@google.com>, song@kernel.org,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Richard Gobert <richardbgobert@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        David Rientjes <rientjes@google.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] skbuff: Reallocate to ksize() in __build_skb_around()
Message-ID: <20221206200414.5cd915d8@kernel.org>
In-Reply-To: <67D5F9F1-3416-4E08-9D5A-369ED5B4EA95@kernel.org>
References: <20221206231659.never.929-kees@kernel.org>
        <20221206175557.1cbd3baa@kernel.org>
        <67D5F9F1-3416-4E08-9D5A-369ED5B4EA95@kernel.org>
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

On Tue, 06 Dec 2022 19:47:13 -0800 Kees Cook wrote:
> >Aammgh. build_skb(0) is plain silly, AFAIK. The performance hit of
> >using kmalloc()'ed heads is large because GRO can't free the metadata.
> >So we end up carrying per-MTU skbs across to the application and then
> >freeing them one by one. With pages we just aggregate up to 64k of data
> >in a single skb.  
> 
> This isn't changed by this patch, though? The users of
> kmalloc+build_skb are pre-existing.

Yes.

> >I can only grep out 3 cases of build_skb(.. 0), could we instead
> >convert them into a new build_skb_slab(), and handle all the silliness
> >in such a new helper? That'd be a win both for the memory safety and one
> >fewer branch for the fast path.  
> 
> When I went through callers, it was many more than 3. Regardless, I
> don't see the point: my patch has no more branches than the original
> code (in fact, it may actually be faster because I made the initial
> assignment unconditional, and zero-test-after-assign is almost free,
> where as before it tested before the assign. And now it's marked as
> unlikely to keep it out-of-line.

Maybe.

> >I think it's worth doing, so LMK if you're okay to do this extra
> >work, otherwise I can help (unless e.g. Eric tells me I'm wrong..).  
> 
> I had been changing callers to round up (e.g. bnx2), but it seemed
> like centralizing this makes more sense. I don't think a different
> helper will clean this up.

It's a combination of the fact that I think "0 is magic" falls in 
the "garbage" category of APIs, and the fact that driver developers
have many things to worry about, so they often don't know that using
slab is a bad idea. So I want a helper out of the normal path, where 
I can put a kdoc warning that says "if you're doing this - GRO will
suck, use page frags".
