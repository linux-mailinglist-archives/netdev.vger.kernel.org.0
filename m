Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8641E61F353
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiKGMbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbiKGMai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:30:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED3D1BE8C;
        Mon,  7 Nov 2022 04:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC423B810B5;
        Mon,  7 Nov 2022 12:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67284C433C1;
        Mon,  7 Nov 2022 12:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667824214;
        bh=zw1PqbgMPFQqiqne9wQFSSrGcbfmiU99qaQD5uMGUzg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kUbUWVlyV4jc2NYPbaHOruolaygi5yrg5p9KTYzCCKu+5rf2OfoD0pjkZ/Z27UK3M
         sIslimlL++hvChObynPNKoz2ShDBd8UiMmTTlzYzyvRt3Rq1PXJlUaZjOVl7/DQxeh
         xXyQMK0gBdl8P3HnEgN8qWO9fxPMaWGLjtT4b48HeHwA+ZqATlNW3JvEIvYPWYX4xm
         TMt3TGvFfqpr2z8kHdIdxy8oUHMtZAGWHkm4zlB3N7ttBlidBVrmpITrcP4Dh1Imu2
         tpbFNAnBxIv+HpeUpJEG3ohqDcxYc6PdDg2n77ZEb+Su2vowm+ZYBa9QUrsowvHB5y
         9TogNL3jpaJWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FE79C4166D;
        Mon,  7 Nov 2022 12:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166782421432.17007.10784521244287672524.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 12:30:14 +0000
References: <20221104103216.2576427-1-glider@google.com>
In-Reply-To: <20221104103216.2576427-1-glider@google.com>
To:     Alexander Potapenko <glider@google.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Nov 2022 11:32:16 +0100 you wrote:
> When copying a `struct ifaddrlblmsg` to the network, __ifal_reserved
> remained uninitialized, resulting in a 1-byte infoleak:
> 
>   BUG: KMSAN: kernel-network-infoleak in __netdev_start_xmit ./include/linux/netdevice.h:4841
>    __netdev_start_xmit ./include/linux/netdevice.h:4841
>    netdev_start_xmit ./include/linux/netdevice.h:4857
>    xmit_one net/core/dev.c:3590
>    dev_hard_start_xmit+0x1dc/0x800 net/core/dev.c:3606
>    __dev_queue_xmit+0x17e8/0x4350 net/core/dev.c:4256
>    dev_queue_xmit ./include/linux/netdevice.h:3009
>    __netlink_deliver_tap_skb net/netlink/af_netlink.c:307
>    __netlink_deliver_tap+0x728/0xad0 net/netlink/af_netlink.c:325
>    netlink_deliver_tap net/netlink/af_netlink.c:338
>    __netlink_sendskb net/netlink/af_netlink.c:1263
>    netlink_sendskb+0x1d9/0x200 net/netlink/af_netlink.c:1272
>    netlink_unicast+0x56d/0xf50 net/netlink/af_netlink.c:1360
>    nlmsg_unicast ./include/net/netlink.h:1061
>    rtnl_unicast+0x5a/0x80 net/core/rtnetlink.c:758
>    ip6addrlbl_get+0xfad/0x10f0 net/ipv6/addrlabel.c:628
>    rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
>   ...
>   Uninit was created at:
>    slab_post_alloc_hook+0x118/0xb00 mm/slab.h:742
>    slab_alloc_node mm/slub.c:3398
>    __kmem_cache_alloc_node+0x4f2/0x930 mm/slub.c:3437
>    __do_kmalloc_node mm/slab_common.c:954
>    __kmalloc_node_track_caller+0x117/0x3d0 mm/slab_common.c:975
>    kmalloc_reserve net/core/skbuff.c:437
>    __alloc_skb+0x27a/0xab0 net/core/skbuff.c:509
>    alloc_skb ./include/linux/skbuff.h:1267
>    nlmsg_new ./include/net/netlink.h:964
>    ip6addrlbl_get+0x490/0x10f0 net/ipv6/addrlabel.c:608
>    rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
>    netlink_rcv_skb+0x299/0x550 net/netlink/af_netlink.c:2540
>    rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6109
>    netlink_unicast_kernel net/netlink/af_netlink.c:1319
>    netlink_unicast+0x9ab/0xf50 net/netlink/af_netlink.c:1345
>    netlink_sendmsg+0xebc/0x10f0 net/netlink/af_netlink.c:1921
>   ...
> 
> [...]

Here is the summary with links:
  - ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network
    https://git.kernel.org/netdev/net/c/c23fb2c82267

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


