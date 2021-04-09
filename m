Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A748435A27F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhDIQBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232395AbhDIQBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E79DB610D0;
        Fri,  9 Apr 2021 16:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617984066;
        bh=Qvi9CFZ5Rs6RwHD+vjuqhjZBFQ1++B4VKawm1rxlmdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y+/Y/G+QdvZzqaJeDFggd3f+GQFZY5nCua203XTmV8qpiKyFd2//iTsY1lyzphzg8
         ZssyAW/0ewOT6GV4EPkNMFZAFARHPO6KHJl16RpXNItJmbtjD2XvYGn36gvkj572Je
         Z54QUGY9whWvHM8/84iUjqymZif1nsNvEbPocsMizt0Ou/LgOVpy9ye5quHF9Cgmdt
         urGF5yc3pRIt9LsbaMKcc40ZHlzQQ7AZJee2KbrG9zEAR/ZPSzl4iBpDe2Rf8/VwtZ
         oiLfI8cgoq+g7YCkodyN1Tfga+CVbi7O+zXP4/ikFKpfs4nKYMBY7oFQiblToF/qOH
         QfkUFgpyoErMg==
Date:   Fri, 9 Apr 2021 09:01:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net] net: flow_offload: Fix UBSAN invalid-load warning
 in tcf_block_unbind
Message-ID: <20210409090104.3e2a95e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409062555.GA1191@vdi.nvidia.com>
References: <20210408074718.14331-1-jianbol@nvidia.com>
        <20210408141619.7dd765b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210409062555.GA1191@vdi.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 06:25:56 +0000 Jianbo Liu wrote:
> The 04/08/2021 14:16, Jakub Kicinski wrote:
> > On Thu, 8 Apr 2021 07:47:18 +0000 Jianbo Liu wrote:  
> > > When device is removed, indirect block is unregisterd. As
> > > bo->unlocked_driver_cb is not initialized, the following UBSAN is
> > > triggered.
> > > 
> > > UBSAN: invalid-load in net/sched/cls_api.c:1496:10
> > > load of value 6 is not a valid value for type '_Bool'
> > > 
> > > This patch fixes the warning by calling device's indr block bind
> > > callback, and unlocked_driver_cb is assigned with correct value.
> > > 
> > > Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
> > > Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> > > Reviewed-by: Roi Dayan <roid@nvidia.com>  
> > 
> > It's been a while since I looked at this code but I don't understand
> > what you're doing here.  
> 
> To fix the UBSAN warning in tcf_block_unbind. It's easily triggered when
> netdev is removed before tunnel netdev.
> 
> > The init in tc_block_indr_cleanup() makes sense. What's the change to
> > setup_cb achieving? Thanks.  
> 
> But unlocked_driver_cb of flow_block_offload is not initialized in init.
> Calling setup_cb is to get the correct value from driver.

I'm trying to understand what became of this code :/ Was there no call
with FLOW_BLOCK_UNBIND to the driver when driver was unregistering
before your change?

