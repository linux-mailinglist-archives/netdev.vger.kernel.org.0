Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217DA68A339
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 20:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjBCTru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 14:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjBCTrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 14:47:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521C99DCB3
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 11:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03972B82B9A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 19:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67555C433D2;
        Fri,  3 Feb 2023 19:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675453665;
        bh=c0iSkZKUeGaxon5Z5/0ZogfWYUDFxMHhl2jL34gi3Pw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eUu6xQSzasUWvyR5N8ZOhz3fP/BjMf7PjqZizuTMQkRX97KTynq0jD3jyW1x3IJd6
         8w8wQ23ZZ0COSr2HdjdWPpa7gmS+//QQ3P3mgoF9lc4jVzT+KxjboXMUUdnHjAl8eI
         6YVF9CX4ny0Z8/lUOXGf5axO7KnGDAidYrI1HfSzS5SqyP4H7p9Hb5sl88y7MZd9rt
         0Z4gKC8nbHJubHyPbgryGdKZnCobntur2GMPEEbCR9bmHAq+ysCjj8u0BEjer4goqH
         zmSyhu1XU6oCPdSWZpIaMmCDGb43kgZjn5KuWWITTLtMIB76wkTpguMuFkYCholJzz
         PKMyBkin9kpUg==
Date:   Fri, 3 Feb 2023 11:47:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Alexander Duyck <alexanderduyck@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
Message-ID: <20230203114744.153c4063@kernel.org>
In-Reply-To: <CANn89iLj8hC7jgb5jDNi01nKqikGbgKMtFvbZDxWi4Qoi1y8fw@mail.gmail.com>
References: <20230202185801.4179599-1-edumazet@google.com>
        <20230202185801.4179599-5-edumazet@google.com>
        <db71bb74eb61fa09226ef5f2071747f35d67df82.camel@redhat.com>
        <CANn89iLj8hC7jgb5jDNi01nKqikGbgKMtFvbZDxWi4Qoi1y8fw@mail.gmail.com>
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

On Fri, 3 Feb 2023 09:17:55 +0100 Eric Dumazet wrote:
> > I *think* non power of two size is also required to avoid an issue
> > plain (no GFP_DMA nor __GFP_ACCOUNT) allocations in case of fallback to
> > kmalloc(), to prevent skb_kfree_head() mis-interpreting skb->head as
> > kmem_cache allocated.  
> 
> Indeed there are multiple cases explaining why SKB_SMALL_HEAD_CACHE_SIZE
> needs to be a non power of two.

Since you may need to respin would you mind spelling this out a bit
more in the comment ? Maybe: 

-/* We want SKB_SMALL_HEAD_CACHE_SIZE to not be a power of two. */
+/* We want SKB_SMALL_HEAD_CACHE_SIZE to not be a power of two.
+ * This should ensure that SKB_SMALL_HEAD_HEADROOM is a unique
+ * size, and we can differentiate heads from skb_small_head_cache
+ * vs system slabs by looking at their size (skb_end_offset()).
+ */
