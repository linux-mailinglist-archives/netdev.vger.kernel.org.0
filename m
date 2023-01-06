Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5827E660798
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbjAFUJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbjAFUJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:09:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BDE107
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 12:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62165B81E5A
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 20:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEC8C433D2;
        Fri,  6 Jan 2023 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673035755;
        bh=ps6A/aVPu6olZOxeK28dvWoxlLYzeEsrPOY7RuSWSn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uYKC7BHKgjehfuFIg01coAvXKoZshi1LXqmIbFWruX3rkRXxdbvQBM2y76UJTHEIq
         rbwiBSXaSMj1q3ko8FbIvAbpGTGh1/LOiBWt86D+HMNS5ASSPAbtv+swheYa0HAS/I
         ML8jidwwB9hxLTtnU6CkjFSSjnSL6KrLx2xs1pWpBAv+6nQc3mjnqEe6abgYctpE7S
         z8zAuARxdPgYuCxzjKmjTujcsIFTO0VGKhTg67v7HhCRHFTvWBP0CaOHA0frmXdT2P
         xoWUSkSEg0AMOTRlThp2DopNjwSL9A8z06W86zOL1ppyrDXU88AHbg05dxlwxpgxdi
         DpTNFjrdgeWNA==
Date:   Fri, 6 Jan 2023 12:09:13 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/2] net: kfree_skb_list use kmem_cache_free_bulk
Message-ID: <Y7h/6RwHW2IU3dq3@x130>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
 <167293336786.249536.14237439594457105125.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <167293336786.249536.14237439594457105125.stgit@firesoul>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jan 16:42, Jesper Dangaard Brouer wrote:
>The kfree_skb_list function walks SKB (via skb->next) and frees them
>individually to the SLUB/SLAB allocator (kmem_cache). It is more
>efficient to bulk free them via the kmem_cache_free_bulk API.
>
>This patches create a stack local array with SKBs to bulk free while
>walking the list. Bulk array size is limited to 16 SKBs to trade off
>stack usage and efficiency. The SLUB kmem_cache "skbuff_head_cache"
>uses objsize 256 bytes usually in an order-1 page 8192 bytes that is
>32 objects per slab (can vary on archs and due to SLUB sharing). Thus,
>for SLUB the optimal bulk free case is 32 objects belonging to same
>slab, but runtime this isn't likely to occur.
>
>Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

any performance numbers ? 

LGTM,
Reviewed-by: Saeed Mahameed <saeed@kernel.org>

