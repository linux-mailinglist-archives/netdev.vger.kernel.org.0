Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D74B6BA8C5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjCOHKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCOHKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C973AA1;
        Wed, 15 Mar 2023 00:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5041861B40;
        Wed, 15 Mar 2023 07:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AEDB4C4339B;
        Wed, 15 Mar 2023 07:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678864216;
        bh=jIc+tSUDTUzRQsZCDgPoqfJJEpObOoK0VuhyA1UII8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LCg05OYOZlxQWrZy8Df6wKLDfYuh/eFBMPhgoMoYHX5JI/5Cg/39/dm8tyyuRNnRb
         cOOmiNd9hctjKFiHdyWJPp8ZE5HlLsMdoMw37e6kpibGMeY4+yUUEJjRqyLZphwRJA
         mTOeDx5h7wxrFBHyiCJye43tLZ/f6foOFBfhOA1kl6Y4r2lVFP4kDS0YKhUvrSCLF6
         4oHYKQPPHAE8/2GvxygwX4O8nJOvARQqd7TXAjXdK+ArbaMC3ddFI3lbfeppd0p8tr
         kMKi/8r0jjbxHCaCJ3IYc1DtDl7z6t1C4AVCczhpzGjIMkzhJRYkuoccAFH87+gTiR
         AqZqeC+/+9unQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 963DEE66CBC;
        Wed, 15 Mar 2023 07:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/1] ice: avoid bonding causing auxiliary plug/unplug
 under RTNL lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886421661.23656.18355961550243995627.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:10:16 +0000
References: <20230310194833.3074601-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230310194833.3074601-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        david.m.ertman@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jgg@nvidia.com, leonro@nvidia.com,
        linux-rdma@vger.kernel.org, poros@redhat.com, ivecera@redhat.com,
        jaroslav.pulchart@gooddata.com, git@sphalerite.org,
        stable@vger.kernel.org, arpanax.arland@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 11:48:33 -0800 you wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> RDMA is not supported in ice on a PF that has been added to a bonded
> interface. To enforce this, when an interface enters a bond, we unplug
> the auxiliary device that supports RDMA functionality.  This unplug
> currently happens in the context of handling the netdev bonding event.
> This event is sent to the ice driver under RTNL context.  This is causing
> a deadlock where the RDMA driver is waiting for the RTNL lock to complete
> the removal.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/1] ice: avoid bonding causing auxiliary plug/unplug under RTNL lock
    https://git.kernel.org/netdev/net/c/248401cb2c46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


