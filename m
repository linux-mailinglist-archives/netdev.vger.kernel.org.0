Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C70681B4C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjA3UWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjA3UWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:22:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951B8470B6;
        Mon, 30 Jan 2023 12:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB06B8168C;
        Mon, 30 Jan 2023 20:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77452C433EF;
        Mon, 30 Jan 2023 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675110128;
        bh=2amaQBzxTLZAx/R22ao8Phymmp5xGE1DaFtSYzJHbrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HBGugDWrPykzyvqC7IIOk71SVz6xABUkxS12I6+QHtxmBweGJZ9rp7MfHe408Hn+V
         N+ZuH1ueJ6zUi+BgQPUIYcG6IcKnbkwGAv6Let4QA2e183dWowI5r9OwqBpURt2R2e
         7XaV6ML2TNcBH26pg1vPS/YNNHhkydZPHxhLtLyyNYPZCH+1wVIhPqlrXYQBSehGlj
         4EFiwvC9zT02MCQPlYuSlVOrJzYJoIoS2ZRJu6SazOGnMR6uIJU9iD/faeHHLWHjWq
         rANd/dc+piV+P2LApLcuvh1/7w+JDMmG5Fc5h45mGbPUiDi5YM1w7ASvowAurKICM9
         AbbNxsoSTAc9w==
Date:   Mon, 30 Jan 2023 12:22:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RESEND 0/9] sched: cpumask: improve on
 cpumask_local_spread() locality
Message-ID: <20230130122206.3b55a0a7@kernel.org>
In-Reply-To: <4fa5d53d-d614-33b6-2d33-156281420507@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
        <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
        <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
        <4fa5d53d-d614-33b6-2d33-156281420507@gmail.com>
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

On Sun, 29 Jan 2023 10:07:58 +0200 Tariq Toukan wrote:
> > Peter/Ingo, any objections to stashing this in tip/sched/core?
> 
> Can you please look into it? So we'll have enough time to act (in 
> case...) during this kernel.
> 
> We already missed one kernel...

We really need this in linux-next by the end of the week. PTAL.
