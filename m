Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C39E69D44B
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 20:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjBTTrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 14:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBTTrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 14:47:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A00BCDE2;
        Mon, 20 Feb 2023 11:47:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B543DB80DB6;
        Mon, 20 Feb 2023 19:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECAEC4339B;
        Mon, 20 Feb 2023 19:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676922419;
        bh=Zim4BTwaWJ5LW+ey7LEUKLQwBzXyAFrmCFyU7jEmkQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ni5gGKzqNc5uv3ipbV5+58jGCO1r2pvYYtzEvFGYGd2YXJZMsaOHImZRQWY3VgKpL
         v8/dzcveg3yePwHh+EaIsxPmCrdEmF6ySpcmvEtuelNVKHshqnOsCrT7fSvlMGGVqQ
         NPRbBDcgaHPqchkTScUxDHTlOshS0Rj375fRgOuOkY140cpp4gi1HJRMjy5jttT9B8
         z1ziiZAGuXpBtBS8K/ERnWfN0T5C/j6kkVQJFh3i5Ds15cXXFQvL25Yu/pR841Jk2o
         AnML/hUQXgQetdSRaFT5HDSm7rLQnlYv0ZAAAh5J0/aLgaEm4PJ9LLwnhe1y1AWovt
         B08XR0Cdpjm2Q==
Date:   Mon, 20 Feb 2023 11:46:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
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
        Kees Cook <kees@kernel.org>,
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
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/9] sched: add sched_numa_find_nth_cpu()
Message-ID: <20230220114657.7670bf71@kernel.org>
In-Reply-To: <Y+7avK6V9SyAWsXi@yury-laptop>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
        <20230121042436.2661843-4-yury.norov@gmail.com>
        <Y+7avK6V9SyAWsXi@yury-laptop>
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

On Thu, 16 Feb 2023 17:39:08 -0800 Yury Norov wrote:
> Despite that prev_hop is used conditionally on curr_hop is not the
> first hop, it's initialized unconditionally.
> 
> Because initialization implies dereferencing, it might happen that
> the code dereferences uninitialized memory, which has been spotted by
> KASAN. Fix it by reorganizing hop_cmp() logic.
> 
> Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

Fixed the spelling pointed out by Andy and applied, thanks!
