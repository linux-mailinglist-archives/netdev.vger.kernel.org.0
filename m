Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0524C9980
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiCAXvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiCAXvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:51:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576CD61A15;
        Tue,  1 Mar 2022 15:50:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C32EB81EA7;
        Tue,  1 Mar 2022 23:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E51C340EE;
        Tue,  1 Mar 2022 23:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646178632;
        bh=BDy9HN55VjW0OXpj2rwgeo/0PzouCOspchdWJqyE92I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n8buYiA5Xkt+q8CyWCxWZ7apeIUFPN9cIiAXgvymFb8EvDRYYA6i8g0FrZu8y066u
         7hlvM60J3bOaN5p7f4s4J0oOeeIZEDmSPIpV32p2UhXJFLcAGRwLzowXzXLj21DXLD
         OnaMluWGZ+gG0cI2A1meYYvLuAvaDqbqGOFJLceqaXfV5WIA5sIydu8GkyThy8JW0/
         5FG1EBHUv1Yp1kl98/lObDwo7xvsrOubooirCnCwavbjHiX/68G3cJqGK/C32rzBaQ
         YJ09EL2UreSH09hYPK92Bw82XzUV4O9jvUcVk3kbck1cZ/LW8T5IOee43BsCGQ8UOG
         jPSpo6yNgnHOA==
Date:   Tue, 1 Mar 2022 15:50:31 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [net-next v8 1/4] page_pool: Add allocation stats
Message-ID: <20220301235031.ryy4trywlc3bmnpx@sx1>
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
 <1646172610-129397-2-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1646172610-129397-2-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Mar 14:10, Joe Damato wrote:
>Add per-pool statistics counters for the allocation path of a page pool.
>These stats are incremented in softirq context, so no locking or per-cpu
>variables are needed.
>
>This code is disabled by default and a kernel config option is provided for
>users who wish to enable them.
>

Sorry for the late review Joe,

Why disabled by default ? if your benchmarks showed no diff.

IMHO If we believe in this, we should have it enabled by default.

>The statistics added are:
>	- fast: successful fast path allocations
>	- slow: slow path order-0 allocations
>	- slow_high_order: slow path high order allocations
>	- empty: ptr ring is empty, so a slow path allocation was forced.
>	- refill: an allocation which triggered a refill of the cache
>	- waive: pages obtained from the ptr ring that cannot be added to
>	  the cache due to a NUMA mismatch.
>

Let's have this documented under kernel documentation.
https://docs.kernel.org/networking/page_pool.html

I would also mention the kconfig and any user knobs APIs introduced in
this series


