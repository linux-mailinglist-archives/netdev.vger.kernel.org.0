Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B168CEBB
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 06:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjBGFKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 00:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjBGFKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 00:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B77A1E5D2;
        Mon,  6 Feb 2023 21:09:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A897BB816D5;
        Tue,  7 Feb 2023 05:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DFDC433D2;
        Tue,  7 Feb 2023 05:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675746586;
        bh=3LepokumWhsUfcne4ek1k9dUXAWx6TVmsA0QwbcNahI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rps20H7gpxHZwRFmaICD5lE3X/hCpzp0GCH5RNI99H2bEh28AQqc09qVX4t+6TeT5
         KPqk1Fp0d4bx634U2129pxvgrVaoc1RQuogI98WcEPu0goQgpaqliXOCn6kyuv6Z7o
         /lySGAv5Sdm1lmhLMTOEn3xdPn5MKk0IsSDO/jT2cEsM0S4MgOnzVDuN9ydMpGGA/Q
         hR9lfyDWTjhUogG0vtQQ2FzGrMApoIanAWnGzCdDq1yHwoVqPB6xgRBIV8yfCYnnFb
         VvroBOcsQ4SOxTbIyWGqKwSdyz9hwo+TuRua6HWHYix5cun28O+dPf/3gCqq2p2sKU
         DIKBN0Pw0wodQ==
Date:   Mon, 6 Feb 2023 21:09:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
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
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/9] sched: add sched_numa_find_nth_cpu()
Message-ID: <20230206210943.79e01af9@kernel.org>
In-Reply-To: <20230121042436.2661843-4-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
        <20230121042436.2661843-4-yury.norov@gmail.com>
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

On Fri, 20 Jan 2023 20:24:30 -0800 Yury Norov wrote:
> The function finds Nth set CPU in a given cpumask starting from a given
> node.
> 
> Leveraging the fact that each hop in sched_domains_numa_masks includes the
> same or greater number of CPUs than the previous one, we can use binary
> search on hops instead of linear walk, which makes the overall complexity
> of O(log n) in terms of number of cpumask_weight() calls.

Valentin, would you be willing to give us a SoB or Review tag for 
this one?  We'd like to take the whole series via networking, if 
that's okay.
