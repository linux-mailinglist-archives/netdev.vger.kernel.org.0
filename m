Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D4061F34B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiKGMbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiKGMai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:30:38 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8613F1BE87
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 04:30:16 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id c14-20020a5ea80e000000b006d6e9b05e58so6049271ioa.23
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 04:30:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2QdW3bJTfTlvyJUtpT98DVIdFoZcbyI7i1Ng3F21ZM=;
        b=3x5D2QtoJUYb9jX0QigFI0u2Neb2AMuPhmPTwQzZqNNG3ay+Pl13sLLjRMX/eqcaaX
         H4kgUUqg4FeVE7s52TbkiTO9vroNSBDKYiwDddK2EMmSJ2NaPlDNE/660Ka44ZgcpnvB
         xEUAvYQ9bOZVo45rQ/StLF86b4jCnNHA8lIXwDWSq7Gl4G7liAgpRTwjmnEDxZF6vOi2
         /hMO99ChiK6009awghJh1DopUJXtvveQMxbPAZR9cehe7byr0qqK0h4rCnlTqypko33I
         zdkdX+bbn5j/P6xhhjyhIsKGpLGsCU+4+JthaZ6PxwO5y1kVMAmEM4LClFebJNP2IycN
         MGzg==
X-Gm-Message-State: ACrzQf06IM3c2ten5EQS02AtQdNDun1zVS9u1h2JzqBQbYIfJmHpIDBp
        qQDVX+xKTL4il8Fxx3mFImkZolzMid0SjkOGwy5KQzUs64Nj
X-Google-Smtp-Source: AMsMyM5zNyZwCNzGQQ9aYpaDy2NwhphvTmTYw1TQJAXCOTL3zwZtbYWFHe5BIJModjQDXN9uWsC5b3rBBHjlIv35GvjvOHaFrMlN
MIME-Version: 1.0
X-Received: by 2002:a02:5147:0:b0:375:9c59:7825 with SMTP id
 s68-20020a025147000000b003759c597825mr10835928jaa.51.1667824215859; Mon, 07
 Nov 2022 04:30:15 -0800 (PST)
Date:   Mon, 07 Nov 2022 04:30:15 -0800
In-Reply-To: <166782421432.17007.10784521244287672524.git-patchwork-notify@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef24d205ece0953f@google.com>
Subject: Re: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
From:   syzbot 
        <syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com>
To:     <patchwork-bot+netdevbpf@kernel.org>
Cc:     davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        patchwork-bot@kernel.org, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello:
>
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Fri,  4 Nov 2022 11:32:16 +0100 you wrote:
>> When copying a `struct ifaddrlblmsg` to the network, __ifal_reserved
>> remained uninitialized, resulting in a 1-byte infoleak:
>> 
>>   BUG: KMSAN: kernel-network-infoleak in __netdev_start_xmit ./include/linux/netdevice.h:4841
>>    __netdev_start_xmit ./include/linux/netdevice.h:4841
>>    netdev_start_xmit ./include/linux/netdevice.h:4857
>>    xmit_one net/core/dev.c:3590
>>    dev_hard_start_xmit+0x1dc/0x800 net/core/dev.c:3606
>>    __dev_queue_xmit+0x17e8/0x4350 net/core/dev.c:4256
>>    dev_queue_xmit ./include/linux/netdevice.h:3009
>>    __netlink_deliver_tap_skb net/netlink/af_netlink.c:307
>>    __netlink_deliver_tap+0x728/0xad0 net/netlink/af_netlink.c:325
>>    netlink_deliver_tap net/netlink/af_netlink.c:338
>>    __netlink_sendskb net/netlink/af_netlink.c:1263
>>    netlink_sendskb+0x1d9/0x200 net/netlink/af_netlink.c:1272
>>    netlink_unicast+0x56d/0xf50 net/netlink/af_netlink.c:1360
>>    nlmsg_unicast ./include/net/netlink.h:1061
>>    rtnl_unicast+0x5a/0x80 net/core/rtnetlink.c:758
>>    ip6addrlbl_get+0xfad/0x10f0 net/ipv6/addrlabel.c:628
>>    rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
>>   ...
>>   Uninit was created at:
>>    slab_post_alloc_hook+0x118/0xb00 mm/slab.h:742
>>    slab_alloc_node mm/slub.c:3398
>>    __kmem_cache_alloc_node+0x4f2/0x930 mm/slub.c:3437
>>    __do_kmalloc_node mm/slab_common.c:954
>>    __kmalloc_node_track_caller+0x117/0x3d0 mm/slab_common.c:975
>>    kmalloc_reserve net/core/skbuff.c:437
>>    __alloc_skb+0x27a/0xab0 net/core/skbuff.c:509
>>    alloc_skb ./include/linux/skbuff.h:1267
>>    nlmsg_new ./include/net/netlink.h:964
>>    ip6addrlbl_get+0x490/0x10f0 net/ipv6/addrlabel.c:608
>>    rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
>>    netlink_rcv_skb+0x299/0x550 net/netlink/af_netlink.c:2540
>>    rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6109
>>    netlink_unicast_kernel net/netlink/af_netlink.c:1319
>>    netlink_unicast+0x9ab/0xf50 net/netlink/af_netlink.c:1345
>>    netlink_sendmsg+0xebc/0x10f0 net/netlink/af_netlink.c:1921
>>   ...
>> 
>> [...]
>
> Here is the summary with links:
>   - ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network
>     https://git.kernel.org/netdev/net/c/c23fb2c82267
>
> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

