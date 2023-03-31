Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FED6D1631
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 06:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCaEGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 00:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCaEGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 00:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149C4EC76
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C37961EC3
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59BDC433D2;
        Fri, 31 Mar 2023 04:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680235567;
        bh=oJJPBUQtZ6qjq1hLhHt7y8VVYL3gLwLxf2hB3DNtqEY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mwDzGyZvpjpG9V9zFhtyckaezZ6ECQrJgs6XtYMam9YJjTiKigEtLCC03yZs5hsdN
         UHrJhsUwbfLJz63JMG6g1EuBrL6zp+7mDeoWOnMX2BItM2g1pH+T6I7iAxshKbfUcB
         4DqIYQP4GMRaFfEY++cJX4IERFOArXWvR2CQxSVbZW+N4Cx3pt5aFJPBMAQGAzYM37
         xwMO9G+ThPxiPB3hHimHR2586AcfBItrq5ze4qyYSoZC+fQEeMU94EyR7gHXT7TVGi
         TDPp7XPaudUoGnWCYPMRwka8JmBwX1C0jl4zecUT25FprRUkGI1/v8nPc79SJl8+80
         i2c6RTPZPvebg==
Date:   Thu, 30 Mar 2023 21:06:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: AMD IOMMU problem after NIC uses multi-page allocation
Message-ID: <20230330210605.02406324@kernel.org>
In-Reply-To: <76c7e508-c7ca-e2d9-5915-545b394623ae@arm.com>
References: <20230329181407.3eed7378@kernel.org>
        <ZCU9KZMlGMWb2ezZ@8bytes.org>
        <202ea27f-aa79-66b6-0c80-ba0459eef5bd@arm.com>
        <76c7e508-c7ca-e2d9-5915-545b394623ae@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 14:10:09 +0100 Robin Murphy wrote:
> > There is that old issue already mentioned where there seems to be some 
> > interplay between the IOVA caching and the lazy flush queue, which we 
> > never really managed to get to the bottom of. IIRC my hunch was that 
> > with a sufficiently large number of CPUs, fq_flush_timeout() overwhelms 
> > the rcache depot and gets into a pathological state where it then 
> > continually thrashes the IOVA rbtree in a fight with the caching system.
> > 
> > Another (simpler) possibility which comes to mind is if the 9K MTU 
> > (which I guess means 16KB IOVA allocations) puts you up against the 
> > threshold of available 32-bit IOVA space - if you keep using the 16K 
> > entries then you'll mostly be recycling them out of the IOVA caches, 
> > which is nice and fast. However once you switch back to 1500 so needing 
> > 2KB IOVAs, you've now got a load of IOVA space hogged by all the 16KB 
> > entries that are now hanging around in caches, which could push you into 
> > the case where the optimistic 32-bit allocation starts to fail (but 
> > because it *can* fall back to a 64-bit allocation, it's not going to 
> > purge those unused 16KB entries to free up more 32-bit space). If the 
> > 32-bit space then *stays* full, alloc_iova should stay in fail-fast 
> > mode, but if some 2KB allocations were below 32 bits and eventually get 
> > freed back to the tree, then subsequent attempts are liable to spend 
> > ages doing doing their best to scrape up all the available 32-bit space 
> > until it's definitely full again. For that case, [1] should help.  
> 
> ...where by "2KB" I obviously mean 4KB, since apparently in remembering 
> that the caches round up to powers of two I managed to forget that 
> that's still in units of IOVA pages, derp.
> 
> Robin.
> 
> > 
> > Even in the second case, though, I think hitting the rbtree much at all 
> > still implies that the caches might not be well-matched to the 
> > workload's map/unmap pattern, and maybe scaling up the depot size could 
> > still be the biggest win.
> > 
> > Thanks,
> > Robin.
> > 
> > [1] 
> > https://lore.kernel.org/linux-iommu/e9abc601b00e26fd15a583fcd55f2a8227903077.1674061620.git.robin.murphy@arm.com/

Alright, can confirm! :) 
That patch on top of Linus's tree fixes the issue for me!

Noob question about large systems, if you indulge me - I run into this
after enabling the IOMMU driver to get large (255+ thread) AMD machines
to work. Is there a general dependency on IOMMU for such x86 systems or
the tie between IOMMU and x2apic is AMD-specific? Or I'm completely
confused?

I couldn't find anything in the kernel docs and I'm trying to wrap my
head around getting the kernel to work the same across a heterogeneous*
fleet of machines (* in terms of vendor and CPU count).
