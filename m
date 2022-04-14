Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A813550031A
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 02:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiDNAmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 20:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiDNAmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 20:42:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C727E2252A
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BD15610FB
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD68C385A6;
        Thu, 14 Apr 2022 00:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649896793;
        bh=e5iDnKHQy9tP+0tDdbkfOLFRE1wcln67VXV3t8FSytc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IgPrSZhLFaVwHwXvNyfdJS8p18BQEbxwPEUZATBM2bt53ca+I3eA6jUzPArnOf3/a
         UAPl9d/TjyKhUorrFAT3AHb7oJY3bUZ5pGJaijj91wQSyggduHLdMQRfDvup7qMIXS
         85VM5AudPtAqNhiLrVcvXouYC05CyPlWCy8St/s3NTPsgBVLAbwGAooavRyLu4niMs
         fN+0KUbSUlyQes7Mrmf+uOJQPgb3l/13B0lr2w0MxcKxbNJuCFAmLGMEN/6TsVrt/I
         /Yw+juY0Fs5T0imraVFszQpd9yjR4S3qR7cM1yqvKXt+7yWYiqdEe4tK3Lhf0yQuzE
         nb02D2BM0q8hg==
Message-ID: <93a31a81-a586-3fbb-d98b-ce78a4927ff7@kernel.org>
Date:   Wed, 13 Apr 2022 18:39:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net] ipv6: make ip6_rt_gc_expire an atomic_t
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20220413181333.649424-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220413181333.649424-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 12:13 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Reads and Writes to ip6_rt_gc_expire always have been racy,
> as syzbot reported lately [1]
> 
> There is a possible risk of under-flow, leading
> to unexpected high value passed to fib6_run_gc(),
> although I have not observed this in the field.
> 
> Hosts hitting ip6_dst_gc() very hard are under pretty bad
> state anyway.
> 
> [1]
> BUG: KCSAN: data-race in ip6_dst_gc / ip6_dst_gc
> 
> read-write to 0xffff888102110744 of 4 bytes by task 13165 on cpu 1:
>  ip6_dst_gc+0x1f3/0x220 net/ipv6/route.c:3311
>  dst_alloc+0x9b/0x160 net/core/dst.c:86
>  ip6_dst_alloc net/ipv6/route.c:344 [inline]
>  icmp6_dst_alloc+0xb2/0x360 net/ipv6/route.c:3261
>  mld_sendpack+0x2b9/0x580 net/ipv6/mcast.c:1807
>  mld_send_cr net/ipv6/mcast.c:2119 [inline]
>  mld_ifc_work+0x576/0x800 net/ipv6/mcast.c:2651
>  process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
>  worker_thread+0x618/0xa70 kernel/workqueue.c:2436
>  kthread+0x1a9/0x1e0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30
> 
> read-write to 0xffff888102110744 of 4 bytes by task 11607 on cpu 0:
>  ip6_dst_gc+0x1f3/0x220 net/ipv6/route.c:3311
>  dst_alloc+0x9b/0x160 net/core/dst.c:86
>  ip6_dst_alloc net/ipv6/route.c:344 [inline]
>  icmp6_dst_alloc+0xb2/0x360 net/ipv6/route.c:3261
>  mld_sendpack+0x2b9/0x580 net/ipv6/mcast.c:1807
>  mld_send_cr net/ipv6/mcast.c:2119 [inline]
>  mld_ifc_work+0x576/0x800 net/ipv6/mcast.c:2651
>  process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
>  worker_thread+0x618/0xa70 kernel/workqueue.c:2436
>  kthread+0x1a9/0x1e0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30
> 
> value changed: 0x00000bb3 -> 0x00000ba9
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 11607 Comm: kworker/0:21 Not tainted 5.18.0-rc1-syzkaller-00037-g42e7a03d3bad-dirty #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: mld mld_ifc_work
> 
> Fixes: 1da177e4c3 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  include/net/netns/ipv6.h |  4 ++--
>  net/ipv6/route.c         | 11 ++++++-----
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


