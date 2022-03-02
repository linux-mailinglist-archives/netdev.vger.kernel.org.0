Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3A4C9C76
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 05:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiCBEdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 23:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiCBEdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 23:33:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7370CA4189;
        Tue,  1 Mar 2022 20:32:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC03E617A9;
        Wed,  2 Mar 2022 04:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD46FC004E1;
        Wed,  2 Mar 2022 04:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646195538;
        bh=NUxW0exMIw0qLhh0NucgNb8hdhUBvqARe8Wdo5Scw7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eUQNF44dB7lkaGOowszLnn0dK9z9Go/z647P34GCP83hnMQNDL7xp8qjOTQp3xFA3
         VmfrxS/acnhRIN1ClkrjP+UwKphoyXOD6kDeYlo6ogrgqvN4jWWNbwkdaacEHzE3lw
         nAJ1c2izEtR8UPddVGP2AACUSctUgdchPLR0phBGTWpO1rXid0WW0QZJuf84LLXWM7
         Z/pHwZtph8jhUfbF6327nquURGFOiThzV2Yl5tLjQGzcHo7xCpfwytQjekD5mlCAa8
         JDI9ri6WEiZhTe20RS3dJN3v7TIJhwN2TvOrCG88Mzu1HDGMWufRkmkV4NrsRDaG9+
         FlnRkRIWGoJnQ==
Date:   Tue, 1 Mar 2022 20:32:16 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [net-next v8 1/4] page_pool: Add allocation stats
Message-ID: <20220302043216.o7vhjtj2dzal4x76@sx1>
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
 <1646172610-129397-2-git-send-email-jdamato@fastly.com>
 <20220301235031.ryy4trywlc3bmnpx@sx1>
 <CALALjgzWZLjLj1Qss9JQd3DEh-_SZcwCAEkgAE19Nsxf07EOOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALALjgzWZLjLj1Qss9JQd3DEh-_SZcwCAEkgAE19Nsxf07EOOQ@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Mar 17:51, Joe Damato wrote:
>On Tue, Mar 1, 2022 at 3:50 PM Saeed Mahameed <saeed@kernel.org> wrote:
>>
>> On 01 Mar 14:10, Joe Damato wrote:
>> >Add per-pool statistics counters for the allocation path of a page pool.
>> >These stats are incremented in softirq context, so no locking or per-cpu
>> >variables are needed.
>> >
>> >This code is disabled by default and a kernel config option is provided for
>> >users who wish to enable them.
>> >
>>
>> Sorry for the late review Joe,
>
>No worries, thanks for taking a look.
>
>> Why disabled by default ? if your benchmarks showed no diff.
>>
>> IMHO If we believe in this, we should have it enabled by default.
>
>I think keeping it disabled by default makes sense for three reasons:
>  - The benchmarks on my hardware don't show a difference, but less
>powerful hardware may be more greatly impacted.
>  - The new code uses more memory when enabled for storing the stats.
>  - These stats are useful for debugging and performance
>investigations, but generally speaking I think the vast majority of
>everyday kernel users won't be looking at this data.
>
>Advanced users who need this information (and are willing to pay the
>cost in memory and potentially CPU) can enable the code relatively
>easily, so I think keeping it defaulted to off makes sense.

I partially agree, since we have other means to detect if page_pool is
effective or not without these stats.

But here is my .02$: the difference in performance when page_pool is
effective and when isn't is huge, these counters are useful on production
systems when the page pool is under stress.

Simply put, the benefits of the page_pool outweigh the overhead of counting
(if even measurable), these counters should've been added long time ago.

if you are aiming for debug only counters then you should've introduced this
feature as a static key (tracepoints) to be enabled on the fly and the
overhead is paid only when enabled for the debug period.

Anyway, not a huge deal :).

