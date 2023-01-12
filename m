Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164246687F4
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 00:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjALXrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 18:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjALXrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 18:47:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26251EC6D
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 15:47:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07B54620B6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 23:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6EBC433D2;
        Thu, 12 Jan 2023 23:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673567221;
        bh=1cn4fcmsP8g2d5ZQgmZSXV/6Ieop9waXm7iOOHFPEMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mw8wpPXjUEK74eVKEE0kZ3JzR5rXbxTwi0dLRoA6cCUHaURR45jSzIeVTBSlTEpIX
         OnoQpzqHh2qazMNmTVtdIglUHcOewqzq5KvSky7HGzR+Yh9DsjSVCxWLLW/hQZtGaC
         tzDDGmupvpkSRpUSthvTckz6wpPoklAjToQOWJfR6wqIz8WcNMMpGnS8aALxYPLZub
         cZD9FkmmeAx+XG16d9ExPwoh+bIPlv5l+1JLMd+qM+InhTSyNTukLWQ9Z1AdSYZoK5
         4gh4UhxazoAt4kTLjj3QV9zTwBv5V4sTH1XC7ZcSavlTPyGB0PmOSsXyPztHQe1Fn3
         6VtvTCLbgl4aA==
Date:   Thu, 12 Jan 2023 15:47:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        Shai Malin <smalin@nvidia.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH v8 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Message-ID: <20230112154700.46d148ed@kernel.org>
In-Reply-To: <SJ1PR12MB6075B6ACD47B7707087522AAA5FD9@SJ1PR12MB6075.namprd12.prod.outlook.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
        <20230109133116.20801-4-aaptel@nvidia.com>
        <20230111204644.040d0a9d@kernel.org>
        <SJ1PR12MB6075B6ACD47B7707087522AAA5FD9@SJ1PR12MB6075.namprd12.prod.outlook.com>
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

On Thu, 12 Jan 2023 18:50:16 +0000 Aurelien Aptel wrote:
> > The implementation of stats is not what I had in mind.
> > None of the stats you listed under "Statistics" in the documentation look nVidia
> > specific. The implementation should look something like the pause frame stats
> > (struct ethtool_pause_stats etc) but you can add the dynamic string set if you
> > like.
> > 
> > If given implementation does not support one of the stats it will not fill in the
> > value and netlink will skip over it. The truly vendor- -specific stats (if any) can go
> > to the old ethtool -S.  
> 
> Do you mean that we could use the dynamic string approach and just
> define the counters names in netlink? Our concern is that it will not
> allow us to have those stats per queue (as we do in the mlx patches),
> in that case we can suggest reusing ethtool -Q option to request
> per-queue stats. What do you think?

The standard ethtool interface should expose the accumulated stats.
The stats of finer granularity need to be reported on the object to
which they are scoped. 

I'm still yet to find any practical use for per-queue stats in
production.

IOW report the cumulative per device stats in ethtool -I --your-switch.
The per-queue stats can go to ethtool -S until someone actually finds 
a good reason to read them in production..
