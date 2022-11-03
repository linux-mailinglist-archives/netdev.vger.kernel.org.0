Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665DA617499
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 03:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiKCC4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 22:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiKCC4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 22:56:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DD41116B;
        Wed,  2 Nov 2022 19:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71CBACE24F1;
        Thu,  3 Nov 2022 02:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB88CC433D6;
        Thu,  3 Nov 2022 02:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667444178;
        bh=tD7HISYbOkSJc2+ZVHlEVkAOqJHo5AkPqZ+MZ6h6daU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nM6ajyfyLprHH/c2CXEK4niMZiDKOw0wjQmQRIR18HHlgpdfMgNBCY+4cO6qUxOK2
         Jd8YjyLkNjH/bWK+DfFaPcxdKxBrwwdCKzEK3bCGUmn+OWyv5fPeKzeJSWc5yBfPza
         v5z3VGza6WHThHKCY8kRuCAnHgv1GG8PW/ef30EF71mtMl2fDHIUgQ44XfhO3ouong
         vhE2nvLUEl3QzKc8KTZHiZ4A+nqvdMRWKzZqm+89dI7KFsiptfcxzglwA6IqTGXuth
         XGgqrw9K4k2Q0DPMy4uXB6X/o+a9c3XdjT1OShC/ZRdvgDfAX4Jc35HMbKY7Nm1cp7
         x5CRcT5j6hi7w==
Date:   Wed, 2 Nov 2022 19:56:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v6 0/3] sched, net: NUMA-aware CPU spreading interface
Message-ID: <20221102195616.6f55c894@kernel.org>
In-Reply-To: <20221028164959.1367250-1-vschneid@redhat.com>
References: <20221028164959.1367250-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 17:49:56 +0100 Valentin Schneider wrote:
> Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
> it).
> 
> The proposed interface involved an array of CPUs and a temporary cpumask, and
> being my difficult self what I'm proposing here is an interface that doesn't
> require any temporary storage other than some stack variables (at the cost of
> one wild macro).
> 
> [1]: https://lore.kernel.org/all/20220728191203.4055-1-tariqt@nvidia.com/

Not sure who's expected to take these, no preference here so:

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks for ironing it out!
