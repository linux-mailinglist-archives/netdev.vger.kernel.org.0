Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B1D625F6C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiKKQZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiKKQZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:25:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442D26324;
        Fri, 11 Nov 2022 08:25:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8DD1ECE2843;
        Fri, 11 Nov 2022 16:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76562C433D6;
        Fri, 11 Nov 2022 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668183953;
        bh=OQ/EpSlHbcD4pnx4y1IaBDrv3gzT9uiG1VObrf/kmUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CnvaXD8N+0HL+jWFlNDj2BAS3IfMnVYgT6ci+Kz+CdBbnnIz4qjgeBZsYJehB2Izf
         zaS7Zm/j2r7EpRCmDgzdIR38/PzONJ2wv3G0vhClVLWd3Bt9EFfVRbdyE+ZzOkl6M/
         SDxJCmH+UXD976ynQycQFSHvV4wfw/KiKch39tky/7E+zc9hBEcfsl1YsYnIdZrRJL
         G9B0T5Kw7BJSXwFCSd8kGfuC58NH6hb8dBQabV8x8sgfvUAk5rEIEnOhv6wQTvaPsU
         jIEYvNHIY9i4FJh74MkGo/BOsjt3NlqISPDMpE7i7Az4Lh254P1iH1cnNvzzboJAeJ
         6vIZ3gZSf0sAw==
Date:   Fri, 11 Nov 2022 08:25:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
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
Subject: Re: [PATCH 0/4] cpumask: improve on cpumask_local_spread() locality
Message-ID: <20221111082551.7e71fbf4@kernel.org>
In-Reply-To: <20221111040027.621646-1-yury.norov@gmail.com>
References: <20221111040027.621646-1-yury.norov@gmail.com>
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

On Thu, 10 Nov 2022 20:00:23 -0800 Yury Norov wrote:
> cpumask_local_spread() currently checks local node for presence of i'th
> CPU, and then if it finds nothing makes a flat search among all non-local
> CPUs. We can do it better by checking CPUs per NUMA hops.

Nice.

> This series is inspired by Valentin Schneider's "net/mlx5e: Improve remote
> NUMA preferences used for the IRQ affinity hints"
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/
> 
> According to Valentin's measurements, for mlx5e:
> 
> 	Bottleneck in RX side is released, reached linerate (~1.8x speedup).
> 	~30% less cpu util on TX.
> 
> This patch makes cpumask_local_spread() traversing CPUs based on NUMA
> distance, just as well, and I expect comparabale improvement for its
> users, as in Valentin's case.
> 
> I tested it on my VM with the following NUMA configuration:

nit: the authorship is a bit more complicated, it'd be good to mention
Tariq. Both for the code and attribution of the testing / measurements.
