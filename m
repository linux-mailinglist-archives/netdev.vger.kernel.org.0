Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF6B6083E9
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 05:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJVDoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 23:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJVDoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 23:44:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DA629F670;
        Fri, 21 Oct 2022 20:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 507BD60EF3;
        Sat, 22 Oct 2022 03:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47679C433D7;
        Sat, 22 Oct 2022 03:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666410253;
        bh=QGrqJRmKrC7n5l6fNgBt+ie5cOhLSDLj6WeJbXbViyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MEqiYHsPX7aAFtksae/zz0Xsa6afIqIFG806rmrbiTaGRLTL98Qee561UwvDWB1yM
         DkmTzJk/JkS4PcqZTcXXKqOwHtuItlUymv3tEBj1wVra1Y7ia9EmIRsC2RD6J8O7Df
         iCOPIJ2XnMdqMgypUz23rfmR8Tyw+Llestd1VmHeVAlYivPcBN90XVXvrkVAKLmUhB
         8Dnep7niBddb/BgvnsD4kGo2UuauOfpweAaqkCHV+Wjcwslrx3JTptbb3weQRsDWWf
         oJJDM4oalFvkJHVvGQ26+4eLWkbGY4FQXrgTHoMXvUYunRbKJOXikS4StfdmSrgXCP
         Y9Myz9K7WS9ww==
Date:   Fri, 21 Oct 2022 20:44:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bnx2: Pass allocation size to build_skb()
Message-ID: <20221021204412.4ee726c8@kernel.org>
In-Reply-To: <202210211853.99AE1276A4@keescook>
References: <20221018085911.never.761-kees@kernel.org>
        <20221019170255.100f41c7@kernel.org>
        <202210211853.99AE1276A4@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 19:06:26 -0700 Kees Cook wrote:
> On Wed, Oct 19, 2022 at 05:02:55PM -0700, Jakub Kicinski wrote:
> > On Tue, 18 Oct 2022 01:59:29 -0700 Kees Cook wrote:  
> > > In preparation for requiring that build_skb() have a non-zero size
> > > argument, pass the actual data allocation size explicitly into
> > > build_skb().  
> > 
> > build_skb(, 0) has the special meaning of "head buf has been kmalloc'd",
> > rather than alloc_page(). Was this changed and I missed it?  
> 
> Hm, I'm not clear on it. I see ksize() being called, but I guess that
> works for alloc_page() allocations too?
> 
> build_skb
> 	__build_skb:
> 		__build_skb_around:
> 		        unsigned int size = frag_size ? : ksize(data);

Hm, what I'm saying is the definition of the frag_size is - the size of
the frag if page-backed, or 0 if kmalloc-backed.

So the ternary op above applies ksize only in the kmalloc case.

> So I guess in this case, this patch is wrong, and should instead be this
> to match the ksize() used in build_skb():
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c
> b/drivers/net/ethernet/broadcom/bnx2.c
> index fec57f1982c8..dbe310144780 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -5415,8 +5415,9 @@ bnx2_set_rx_ring_size(struct bnx2 *bp, u32 size)
>  
>         bp->rx_buf_use_size = rx_size;
>         /* hw alignment + build_skb() overhead*/
> -       bp->rx_buf_size = SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
> -               NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +       bp->rx_buf_size = kmalloc_size_roundup(
> +               SKB_DATA_ALIGN(bp->rx_buf_use_size + BNX2_RX_ALIGN) +
> +               NET_SKB_PAD + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
>         bp->rx_jumbo_thresh = rx_size - BNX2_RX_OFFSET;
>         bp->rx_ring_size = size;
>         bp->rx_max_ring = bnx2_find_max_ring(size, BNX2_MAX_RX_RINGS);

IIUC you want the size of the allocation to match exactly to the result
of ksize()?  In that case - yup, the above looks good.

FWIW the kmalloc backed heads are actually a performance bottleneck 
so we'd be doing everyone a favor if we just converted the two drivers
which do this to use pages and killed the "feature".

But the roundup works well enough.
