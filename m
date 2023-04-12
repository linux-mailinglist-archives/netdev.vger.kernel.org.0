Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADD46DFC06
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjDLQ6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDLQ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:58:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A65D8A6B
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC80B6377D
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 16:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7586C433D2;
        Wed, 12 Apr 2023 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681318700;
        bh=qO+BHVbAdbOi17e3iuuV7UrsZT32RuVzhLdRq57nzho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bYpEGst2zAq6va28qljnBhloqwHCcPkpJqPGNbHi57OOqoZsfaSeFh1zR2Vm/Mk3U
         9fcz1SC9gopGHlGGpVObd7xfc3/ramna2dE9uH6Ag9n9rHyNwUbx+XKJ5WUVX9cqNT
         lY04NSzxA6sOwzpr3XAT1MVcEmdhfUlNNKE56fwBDahPOmqKztkD7k9eWduNU/cjol
         J50VMpGf3IhI1x34uzp/OtpVJG53po4BjjCP9nJp37LN7UQy3CYw6U4YXwgENUAJdQ
         j57DL25WZxd4QdHOaylNbsBNAoTB+NyISRL3or+IbOGbO6NBylW9ezEAK6BD7uJCiP
         L5X1HZqEfxGzg==
Date:   Wed, 12 Apr 2023 19:58:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, davem@davemloft.net,
        netdev@vger.kernel.org, drivers@pensando.io,
        shannon.nelson@amd.com, neel.patel@amd.com
Subject: Re: [PATCH net] ionic: Fix allocation of q/cq info structures from
 device local node
Message-ID: <20230412165816.GB182481@unreal>
References: <20230407233645.35561-1-brett.creeley@amd.com>
 <20230409105242.GR14869@unreal>
 <bd48d23b-093c-c6d4-86f1-677c2a0ab03c@amd.com>
 <20230411124704.GX182481@unreal>
 <20230411124945.527b0ee4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411124945.527b0ee4@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 12:49:45PM -0700, Jakub Kicinski wrote:
> On Tue, 11 Apr 2023 15:47:04 +0300 Leon Romanovsky wrote:
> > > We want to allocate memory from the node local to our PCI device, which is
> > > not necessarily the same as the node that the thread is running on where
> > > vzalloc() first tries to alloc.  
> > 
> > I'm not sure about it as you are running kernel thread which is
> > triggered directly by device and most likely will run on same node as
> > PCI device.
> 
> Isn't that true only for bus-side probing?
> If you bind/unbind via sysfs does it still try to move to the right
> node? Same for resources allocated during ifup?

Kernel threads are more interesting case, as they are not controlled
through mempolicy (maybe it is not true in 2023, I'm not sure).

User triggered threads are subjected to mempolicy and all allocations
are expected to follow it. So users, who wants specific memory behaviour
should use it.

https://docs.kernel.org/6.1/admin-guide/mm/numa_memory_policy.html

There is a huge chance that fallback mechanisms proposed here in ionic
and implemented in ENA are "break" this interface.

> 
> > > Since it wasn't clear to us that vzalloc_node() does any fallback,   
> > 
> > vzalloc_node() doesn't do fallback, but vzalloc will find the right node
> > for you.
> 
> Sounds like we may want a vzalloc_node_with_fallback or some GFP flag?
> All the _node() helpers which don't fall back lead to unpleasant code
> in the users.

I would challenge the whole idea of having *_node() allocations in
driver code at the first place. Even in RDMA, where we super focused
on performance and allocation of memory in right place is super
critical, we rely on general kzalloc().

There is one exception in RDMA world (hfi1), but it is more because of
legacy implementation and not because of specific need, at least Intel
folks didn't success to convince me with real data.

> 
> > > we followed the example in the ena driver to follow up with a more
> > > generic vzalloc() request.  
> > 
> > I don't know about ENA implementation, maybe they have right reasons to
> > do it, but maybe they don't.
> > 
> > > 
> > > Also, the custom message helps us quickly figure out exactly which
> > > allocation failed.  
> > 
> > If OOM is missing some info to help debug allocation failures, let's add
> > it there, but please do not add any custom prints after alloc failures.
> 
> +1
