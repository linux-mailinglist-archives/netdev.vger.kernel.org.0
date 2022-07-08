Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EC256B142
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiGHEKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHEKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066A631343;
        Thu,  7 Jul 2022 21:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BB9D623A1;
        Fri,  8 Jul 2022 04:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733C6C341C0;
        Fri,  8 Jul 2022 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657253410;
        bh=RKt4q5s2rd/Z1G/joTCkf/8KTmk6ZH1LUIi9T6SFsJc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VLrKqpCPTHZCq+G32MgSXGrzDQwGCjOsf6aa/+leinx9UrTzGtxpKrrXYOQjFk5Oz
         ALqsC7q8YjzhnVU3wMZR/PhSNzYcFHmo8zVG+bjX7VtErHExZrMVV+64ix60WSK+B9
         myifGoYwJ/FWjtqPvk013PjOrpDk5nPXNIboudOr+0zfJXNNhcUZWrKBOVh0bwZcVO
         EMz0XKq/yJ4O2U79D0NQ7vBrJc3YbxwC6fWAiTeJUI2wV/tTDWGM1HYornIWhRT1l6
         HERKAx6LW7vyBRCbg7qqe8QkOkrVz+AVq9qXE6ydd/1Fs+KdI5AwpQoa4KGlmOqMIT
         NWe0QGkAntR+A==
Message-ID: <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
Date:   Thu, 7 Jul 2022 22:10:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/22 5:49 AM, Pavel Begunkov wrote:
> NOTE: Not be picked directly. After getting necessary acks, I'll be working
>       out merging with Jakub and Jens.
> 
> The patchset implements io_uring zerocopy send. It works with both registered
> and normal buffers, mixing is allowed but not recommended. Apart from usual
> request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
> the userspace when buffers are freed and can be reused (see API design below),
> which is delivered into io_uring's Completion Queue. Those "buffer-free"
> notifications are not necessarily per request, but the userspace has control
> over it and should explicitly attaching a number of requests to a single
> notification. The series also adds some internal optimisations when used with
> registered buffers like removing page referencing.
> 
> From the kernel networking perspective there are two main changes. The first
> one is passing ubuf_info into the network layer from io_uring (inside of an
> in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
> caching on the io_uring side, but also helps to avoid cross-referencing
> and synchronisation problems. The second part is an optional optimisation
> removing page referencing for requests with registered buffers.
> 
> Benchmarking with an optimised version of the selftest (see [1]), which sends
> a bunch of requests, waits for completions and repeats. "+ flush" column posts
> one additional "buffer-free" notification per request, and just "zc" doesn't
> post buffer notifications at all.
> 
> NIC (requests / second):
> IO size | non-zc    | zc             | zc + flush
> 4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
> 1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
> 1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
> 600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)
> 
> dummy (requests / second):
> IO size | non-zc    | zc             | zc + flush
> 8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
> 4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
> 1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
> 600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)
> 
> Previously it also brought a massive performance speedup compared to the
> msg_zerocopy tool (see [3]), which is probably not super interesting.
> 

can you add a comment that the above results are for UDP.

You dropped comments about TCP testing; any progress there? If not, can
you relay any issues you are hitting?

