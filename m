Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF366E0730
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjDMGnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDMGnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:43:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094B119A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 971E56358A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA89C433D2;
        Thu, 13 Apr 2023 06:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681368198;
        bh=ghxWfIIoU8cIacTmWcO58F3LNc1m0Px68kb7VjDnVhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lm5k6RW32QM45WqiJPl5mGEKtlu6mbwCVrQoAybf0zAz8n98Y180WIQtugeNHy7tc
         cswO0HrOsJvcWUTJ3jOCMha7JvNxImhVne82yT1FHgSukFVraz/sCA51jCQbiwUCVZ
         AIQuW8cpv1B25xuNmKcSzmprxYv2fE+zkj/xmDWmh/EtijUjDi8FohvQ3G+4LbRe+E
         uat7LJSTQ8YLV//0dItZ52VVkk45p+9URc0ntWI+hhs8ekoo3Wv7rljYJywYYHXLcT
         Xl2u61PPFHU6PwQtXkzG8iGDUd0GJHQrkPQlt/iBKD8FITovIoFwGvvrP7Lh+sVGfT
         YFdpVwaA3SCtQ==
Date:   Thu, 13 Apr 2023 09:43:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, davem@davemloft.net,
        netdev@vger.kernel.org, drivers@pensando.io,
        shannon.nelson@amd.com, neel.patel@amd.com
Subject: Re: [PATCH net] ionic: Fix allocation of q/cq info structures from
 device local node
Message-ID: <20230413064313.GD182481@unreal>
References: <20230407233645.35561-1-brett.creeley@amd.com>
 <20230409105242.GR14869@unreal>
 <bd48d23b-093c-c6d4-86f1-677c2a0ab03c@amd.com>
 <20230411124704.GX182481@unreal>
 <20230411124945.527b0ee4@kernel.org>
 <20230412165816.GB182481@unreal>
 <20230412124409.7c2d73cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412124409.7c2d73cc@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 12:44:09PM -0700, Jakub Kicinski wrote:
> On Wed, 12 Apr 2023 19:58:16 +0300 Leon Romanovsky wrote:
> > > > I'm not sure about it as you are running kernel thread which is
> > > > triggered directly by device and most likely will run on same node as
> > > > PCI device.  
> > > 
> > > Isn't that true only for bus-side probing?
> > > If you bind/unbind via sysfs does it still try to move to the right
> > > node? Same for resources allocated during ifup?  
> > 
> > Kernel threads are more interesting case, as they are not controlled
> > through mempolicy (maybe it is not true in 2023, I'm not sure).
> > 
> > User triggered threads are subjected to mempolicy and all allocations
> > are expected to follow it. So users, who wants specific memory behaviour
> > should use it.
> > 
> > https://docs.kernel.org/6.1/admin-guide/mm/numa_memory_policy.html
> > 
> > There is a huge chance that fallback mechanisms proposed here in ionic
> > and implemented in ENA are "break" this interface.
> 
> Ack, that's what I would have answered while working for a vendor
> myself, 5 years ago. Now, after seeing how NICs get configured in
> practice, and all the random tools which may decide to tweak some
> random param and forget to pin themselves - I'm not as sure.

I would like to separate between tweaks to driver internals and general
kernel core functionality. Everything that fails under latter category
should be avoided in drivers and in-some extent in subsystems too.

NUMA, IRQ, e.t.c are one of such general features.

> 
> Having a policy configured per netdev and maybe netdev helpers for
> memory allocation could be an option. We already link netdev to 
> the struct device.

I don't think that it is really needed, I personally never saw real data
which supports claim that system default policy doesn't work for NICs.
I saw a lot of synthetic testing results where allocations were forced
to be taken from far node, but even in this case the performance
difference wasn't huge.

From reading the NUMA Locality docs, I can imagine that NICs already get
right NUMA node from the beginning.
https://docs.kernel.org/6.1/admin-guide/mm/numaperf.html

> 
> > > > vzalloc_node() doesn't do fallback, but vzalloc will find the right node
> > > > for you.  
> > > 
> > > Sounds like we may want a vzalloc_node_with_fallback or some GFP flag?
> > > All the _node() helpers which don't fall back lead to unpleasant code
> > > in the users.  
> > 
> > I would challenge the whole idea of having *_node() allocations in
> > driver code at the first place. Even in RDMA, where we super focused
> > on performance and allocation of memory in right place is super
> > critical, we rely on general kzalloc().
> > 
> > There is one exception in RDMA world (hfi1), but it is more because of
> > legacy implementation and not because of specific need, at least Intel
> > folks didn't success to convince me with real data.
> 
> Yes, but RDMA is much more heavy on the application side, much more
> tightly integrated in general.

Yes and no, we have vast number of in-kernel RDMA users (NVMe, RDS, NFS,
e.t.c) who care about performance.

Thanks
