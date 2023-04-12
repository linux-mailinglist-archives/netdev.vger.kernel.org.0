Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA956DFEE1
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDLToO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLToN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:44:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC708185
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 12:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86BB063004
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E65C433EF;
        Wed, 12 Apr 2023 19:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681328650;
        bh=0AZq/o3ZCUS0t9BJn7kB+7sv3AQMQsMAajH6hzk2VG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TIEskSknvbCe2MPNLvbnZNoQY391EE3YD7BrCJnnbu+ZD9QncDPsXRVRxssxq9fTC
         lRnI9Xo7VzihVNx9uuFWgsIufwGKOFe1H3P/Zt2l5y3WivVQVrLQP+RDr35KLz7xBq
         7Hn2MLIT8pySVsg2EFb6Gml8DKD0eQ8MBcAOX0bPUsnGnmYjNUL66ma5pMhFYOxTgW
         nFEgt4aiMWrSciriGvjA8fx2kmrxC5047imkikDPqGiBpp5zzVUEN8XBavqrBWbhh5
         pQWlQ8Z/g+TxswJ5nJ+K1Iz9Rkg2USniFWi+wacVvLDykE4s4qH0nIsqyV2sS8wwpm
         oCs27m41jhOTA==
Date:   Wed, 12 Apr 2023 12:44:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, davem@davemloft.net,
        netdev@vger.kernel.org, drivers@pensando.io,
        shannon.nelson@amd.com, neel.patel@amd.com
Subject: Re: [PATCH net] ionic: Fix allocation of q/cq info structures from
 device local node
Message-ID: <20230412124409.7c2d73cc@kernel.org>
In-Reply-To: <20230412165816.GB182481@unreal>
References: <20230407233645.35561-1-brett.creeley@amd.com>
        <20230409105242.GR14869@unreal>
        <bd48d23b-093c-c6d4-86f1-677c2a0ab03c@amd.com>
        <20230411124704.GX182481@unreal>
        <20230411124945.527b0ee4@kernel.org>
        <20230412165816.GB182481@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 19:58:16 +0300 Leon Romanovsky wrote:
> > > I'm not sure about it as you are running kernel thread which is
> > > triggered directly by device and most likely will run on same node as
> > > PCI device.  
> > 
> > Isn't that true only for bus-side probing?
> > If you bind/unbind via sysfs does it still try to move to the right
> > node? Same for resources allocated during ifup?  
> 
> Kernel threads are more interesting case, as they are not controlled
> through mempolicy (maybe it is not true in 2023, I'm not sure).
> 
> User triggered threads are subjected to mempolicy and all allocations
> are expected to follow it. So users, who wants specific memory behaviour
> should use it.
> 
> https://docs.kernel.org/6.1/admin-guide/mm/numa_memory_policy.html
> 
> There is a huge chance that fallback mechanisms proposed here in ionic
> and implemented in ENA are "break" this interface.

Ack, that's what I would have answered while working for a vendor
myself, 5 years ago. Now, after seeing how NICs get configured in
practice, and all the random tools which may decide to tweak some
random param and forget to pin themselves - I'm not as sure.

Having a policy configured per netdev and maybe netdev helpers for
memory allocation could be an option. We already link netdev to 
the struct device.

> > > vzalloc_node() doesn't do fallback, but vzalloc will find the right node
> > > for you.  
> > 
> > Sounds like we may want a vzalloc_node_with_fallback or some GFP flag?
> > All the _node() helpers which don't fall back lead to unpleasant code
> > in the users.  
> 
> I would challenge the whole idea of having *_node() allocations in
> driver code at the first place. Even in RDMA, where we super focused
> on performance and allocation of memory in right place is super
> critical, we rely on general kzalloc().
> 
> There is one exception in RDMA world (hfi1), but it is more because of
> legacy implementation and not because of specific need, at least Intel
> folks didn't success to convince me with real data.

Yes, but RDMA is much more heavy on the application side, much more
tightly integrated in general.
