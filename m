Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE7F68E609
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjBHCZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHCZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:25:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D5E1F4BC;
        Tue,  7 Feb 2023 18:25:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E605B81B89;
        Wed,  8 Feb 2023 02:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476F0C433EF;
        Wed,  8 Feb 2023 02:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675823135;
        bh=SgugQqxYjKhGUHXY/+X1U2clrX2KnDY2G5ysonoqD4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VV2iSfyfqFn9Wt1M1ZbkHRbI+v7uUjZk6ph5Wg7xtSbkAXrTKOdrtF484WKZec4ys
         bi7cTm/oFHUwC4qJlphWDIH3YwHomrbB9pgkChlad9MWAwBxyIQhaLACE9ml09f53C
         epKonp2iromyLe983yhIl0BXOiVwvRXmC347Im1fJo9+KG63M4DMbK/TufiV0dYJHF
         Fs2FDFHB12n8vLi+8mZxXpqMe6G2jKY80M41GWOptJxXoRalf8wbY7U1jRvLZWAas8
         bRHsJpZoSBGrOGo5/Ot8QMjcVGxQylLIjAn1dEQyrZKKtlPv5ECHe0UmUDUeQZoO7S
         62vduv1zgxj1w==
Date:   Tue, 7 Feb 2023 18:25:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
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
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20230207182533.4819fbb9@kernel.org>
In-Reply-To: <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
        <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
        <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
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

On Mon, 23 Jan 2023 09:57:43 +0000 Valentin Schneider wrote:
> On 22/01/23 14:57, Tariq Toukan wrote:
> > On 21/01/2023 6:24, Yury Norov wrote:  
> >>
> >> This series was supposed to be included in v6.2, but that didn't happen. It
> >> spent enough in -next without any issues, so I hope we'll finally see it
> >> in v6.3.
> >>
> >> I believe, the best way would be moving it with scheduler patches, but I'm
> >> OK to try again with bitmap branch as well.  
> >
> > Now that Yury dropped several controversial bitmap patches form the PR,
> > the rest are mostly in sched, or new API that's used by sched.
> >
> > Valentin, what do you think? Can you take it to your sched branch?
>
> I would if I had one :-)
> 
> Peter/Ingo, any objections to stashing this in tip/sched/core?

No replies... so let me take it via networking.
