Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8142866E193
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjAQPEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjAQPDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:03:20 -0500
X-Greylist: delayed 501 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 Jan 2023 07:02:56 PST
Received: from gentwo.de (gentwo.de [161.97.139.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D640540BD5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.de; s=default;
        t=1673967274; bh=YUkx402qu4UC96PEyoN3rqY+K2l/1K3Egsf24+uIlVI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=ypAisRGZyTCIeesL+SJlm0iw/Cb2dIENh54JtFmm2DkpKzG+PFzkGkzebKLuUfM+T
         lAzCGSeKJ602YdzTfdgqB44JL7YHyg6DCqjr00veaVaJsLndS4fAK/eddxAtk6EX5Z
         uPOYcyzguXCmn64jQU1Z8YzFLQWbi/mwfZF8N161d0nA77GGFtdpkUoDRghiZiRloP
         dpBHCPW1EGj0cZk10kbscdXCPvVWH5mYvKHscCNPU3ccJWJleBN4xuo51ocvO/2Xi8
         WF2eNwvoBE9UJky3Y8BMgm531lDkVarmhree82/m5J+elJHtB8eFtUOm4TXDvZgQUs
         SL3Tp9/ZbJYXA==
Received: by gentwo.de (Postfix, from userid 1001)
        id 57685B000FF; Tue, 17 Jan 2023 15:54:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.de (Postfix) with ESMTP id 5062DB0001E;
        Tue, 17 Jan 2023 15:54:34 +0100 (CET)
Date:   Tue, 17 Jan 2023 15:54:34 +0100 (CET)
From:   Christoph Lameter <cl@gentwo.de>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
        penberg@kernel.org, vbabka@suse.cz,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
In-Reply-To: <167396280045.539803.7540459812377220500.stgit@firesoul>
Message-ID: <36f5761f-d4d9-4ec9-a64-7a6c6c8b956f@gentwo.de>
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Jan 2023, Jesper Dangaard Brouer wrote:

> When running different network performance microbenchmarks, I started
> to notice that performance was reduced (slightly) when machines had
> longer uptimes. I believe the cause was 'skbuff_head_cache' got
> aliased/merged into the general slub for 256 bytes sized objects (with
> my kernel config, without CONFIG_HARDENED_USERCOPY).

Well that is a common effect that we see in multiple subsystems. This is
due to general memory fragmentation. Depending on the prior load the
performance could actually be better after some runtime if the caches are
populated avoiding the page allocator etc.

The merging could actually be beneficial since there may be more partial
slabs to allocate from and thus avoiding expensive calls to the page
allocator.

I wish we had some effective way of memory defragmentation.



