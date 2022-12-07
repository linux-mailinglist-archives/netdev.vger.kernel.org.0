Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE364519A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiLGB4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiLGB4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:56:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EB32ED;
        Tue,  6 Dec 2022 17:56:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7B376068E;
        Wed,  7 Dec 2022 01:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57939C433D6;
        Wed,  7 Dec 2022 01:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670378159;
        bh=/z+Iu62uP4cJGR3CTHqreL6Uha56POJb1QIiPp7cJ9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=skStzngAaBq+LugCgiSvQgoYE632Mrtu89piWFC/pKdrCtyWcYSLK+DssC6Ko9Vtk
         gLSo2Wj9mFS2oM+ZDthoSb7N30k++/sPaHRKPjKdLExCKhwtqoKvG9zKj2YGY37Xyc
         I3NLSeRxE7aFN76JPSYbEPZV/uYWaXzR8BD9IMw0PNJHY0eId2tZghTVVW70ILExbm
         GScSP9XWnvVWEba8O8BSCvGbj48Zxlla8xG+f4pv4qWxaVm4VlmF8nUfBSZ/V1VZ6D
         XavSa2AbgFLJJkU3p6Rx58oEt4EAFRoHn8RoEjad9maFsQh8L4KLstesRo7s8fwDuq
         ZIO1u6rFDTZTQ==
Date:   Tue, 6 Dec 2022 17:55:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20221206175557.1cbd3baa@kernel.org>
In-Reply-To: <20221206231659.never.929-kees@kernel.org>
References: <20221206231659.never.929-kees@kernel.org>
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

On Tue,  6 Dec 2022 15:17:14 -0800 Kees Cook wrote:
> -	unsigned int size = frag_size ? : ksize(data);
> +	unsigned int size = frag_size;
> +
> +	/* When frag_size == 0, the buffer came from kmalloc, so we
> +	 * must find its true allocation size (and grow it to match).
> +	 */
> +	if (unlikely(size == 0)) {
> +		void *resized;
> +
> +		size = ksize(data);
> +		/* krealloc() will immediate return "data" when
> +		 * "ksize(data)" is requested: it is the existing upper
> +		 * bounds. As a result, GFP_ATOMIC will be ignored.
> +		 */
> +		resized = krealloc(data, size, GFP_ATOMIC);
> +		if (WARN_ON(resized != data))
> +			data = resized;
> +	}
>  

Aammgh. build_skb(0) is plain silly, AFAIK. The performance hit of
using kmalloc()'ed heads is large because GRO can't free the metadata.
So we end up carrying per-MTU skbs across to the application and then
freeing them one by one. With pages we just aggregate up to 64k of data
in a single skb.

I can only grep out 3 cases of build_skb(.. 0), could we instead
convert them into a new build_skb_slab(), and handle all the silliness
in such a new helper? That'd be a win both for the memory safety and one
fewer branch for the fast path.

I think it's worth doing, so LMK if you're okay to do this extra work,
otherwise I can help (unless e.g. Eric tells me I'm wrong..).
