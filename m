Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29558619478
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiKDKcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiKDKcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:32:23 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E84240BC
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:32:22 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id d2-20020a056e020be200b00300ecc7e0d4so1074097ilu.5
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:32:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bSnqp4UQlUG2QqlzZ3iUAIc6MEm8SU7cmM0LL8se2r0=;
        b=Gc1xfK5Bh5MwVS7vymmU1qjUrSy5WpjlDhqhRsmA6lIyeTA1uJ7+gOWGEvcc28t42+
         2Dbpm5dFBH9de7BCWdgMhF54m7nE8RSyVmDiUhMLRZ/uHtBXYAvSGWhPoITu75hgMGy4
         ZWHxW+fG6mi+ldc6/Yct/Dy3jJ4sAqzCzwzHv58svcJhh1YqciRQqu4JHD6N7hMzFANp
         jrTVsUdinnLLqR+EuaurUT2lVyNXESdr6SNrzi9mKScnvQ1Qpki6VXA3LlMjIsfKQbN0
         kegqcRkO7dVFAIt5SLNdZtYOFGfm30PYydM1rwVjaC1Mza5IkVX7UwSjQV6db4Mw8KtL
         8Kjg==
X-Gm-Message-State: ACrzQf04DoBc+V93AFSjzVyakvNellf+SGFk9CRJM5WIsc6UsU6SQo8/
        JeBpGV3ekdHAGfYl+0sdoyQL9iUDgwBjly8z11hx0bJx4ZH7
X-Google-Smtp-Source: AMsMyM5asMkNk/IBjdzr0g1FEDiMRsuuLSd5z4zwlK77wevqztwMM0tN2ky5BWsL0Sv7NeybSiEaULNMkolgWJQqtBvmzQ0GIK5k
MIME-Version: 1.0
X-Received: by 2002:a02:94ab:0:b0:35a:d1b9:c71c with SMTP id
 x40-20020a0294ab000000b0035ad1b9c71cmr19992511jah.310.1667557941733; Fri, 04
 Nov 2022 03:32:21 -0700 (PDT)
Date:   Fri, 04 Nov 2022 03:32:21 -0700
In-Reply-To: <20221104103216.2576427-1-glider@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c2709105eca2960b@google.com>
Subject: Re: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
From:   syzbot 
        <syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com>
To:     Alexander Potapenko <glider@google.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
> diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
> index 8a22486cf2702..17ac45aa7194c 100644
> --- a/net/ipv6/addrlabel.c
> +++ b/net/ipv6/addrlabel.c
> @@ -437,6 +437,7 @@ static void ip6addrlbl_putmsg(struct nlmsghdr *nlh,
>  {
>  	struct ifaddrlblmsg *ifal = nlmsg_data(nlh);
>  	ifal->ifal_family = AF_INET6;
> +	ifal->__ifal_reserved = 0;
>  	ifal->ifal_prefixlen = prefixlen;
>  	ifal->ifal_flags = 0;
>  	ifal->ifal_index = ifindex;
> -- 
> 2.38.1.431.g37b22c650d-goog
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

