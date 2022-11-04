Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD7A619A8A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiKDOuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiKDOuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BFDF45;
        Fri,  4 Nov 2022 07:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B682062228;
        Fri,  4 Nov 2022 14:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0821C433D6;
        Fri,  4 Nov 2022 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667573415;
        bh=jSXc5912qZ6K35ZCxxlFpfB7oyU7Fv9+teBw18osnAk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kklccCp8MUSVLKGvA4xseNVGbE3AvoUMSWdzvgk2+8PhtfJRdofKTWPW2LNz132Zi
         jqhJPv9kk56fmt2ceXJnpy2SgBMyr5cCNQ5bEVen754e920gi9gIBVB++IWJAA9Jfl
         u+3J535SyWibOVX4Sla4GUvX98o/2qzpECwcMXQR9TUE4yqZYKNxlJaj5QgD17U5I8
         fivpzZcmCM1djnr4seYQ52S9zxlS1qZ9jJxlYlpqpiMehJQeGfTOXxIK/d/hTC0ihH
         +dHfC9h4EqqXznhSFMDS1LncQ9O/OfkzD+gJ+87c9P2cyP0n3TKcRDTXLmu3JuB8zZ
         DFkyJU2Kedsaw==
Message-ID: <73f88a48-72e8-e6e7-faae-1d4b92e0e13b@kernel.org>
Date:   Fri, 4 Nov 2022 08:50:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
Content-Language: en-US
To:     Alexander Potapenko <glider@google.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
References: <20221104103216.2576427-1-glider@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221104103216.2576427-1-glider@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 4:32 AM, Alexander Potapenko wrote:
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
> This patch ensures that the reserved field is always initialized.
> 
> Reported-by: syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
> Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
> Signed-off-by: Alexander Potapenko <glider@google.com>
> ---
>  net/ipv6/addrlabel.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


