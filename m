Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A228619A8B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiKDOuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiKDOuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:50:18 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EE26590
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:50:17 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id a15-20020a056e0208af00b00300806a52b6so3960481ilt.22
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 07:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZSAhvKaDCo9M5dwzXckOjIUu8YR18Bj9O1fS06XjzU=;
        b=wMsKqbXm5gNYMaepGQj7XQ+HD98xZ2lbYiugLOmbgcLCUHgFWPablLC4VDIv17z1xs
         d3bPoXpoATcoB+fTQyqvipMzfHUTCMgmv40BqphnS/ObpEBkW+ADTHr7Pk1/Y4v8LlMk
         fY0OS7c1vA95uykqG5mLWr3Tf0kke94PQ4jzVOH8OYQ6XQQqE198kICW2WLyJ+u3c+eU
         V/rxGHFrm90XXHIMKPW7XUy4ukol+GoOswY2UdpUoHnAWCdgi0wgoxQ2cBGBH9sMfKYQ
         ZZDGDzux7WNxbDwT1lxTVgCZWHMyu3Ezh6xA+IydSdDYGc2ZqYNaHUgX1EMSBjtNb9fe
         hDyA==
X-Gm-Message-State: ACrzQf0aTAHRNXKnDDtUd41nyqlKlPyZmCuYfhZjCAlORXhkXA+wLPL+
        ULDF6DiP1xbiUIH1Iq6ENUJSJKEq+1nUEctA24sPY4uQDkR0
X-Google-Smtp-Source: AMsMyM48vFZSD+wljzGUi1kCNaOQdol8nPZsTGyLSYXAWAi71A3bQGP5teK+u0H9qahj+dx6UpAntUJq7yEmPoz5NF3GQfGCqq6h
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1186:b0:36f:ae2e:a396 with SMTP id
 f6-20020a056638118600b0036fae2ea396mr21567605jas.89.1667573417002; Fri, 04
 Nov 2022 07:50:17 -0700 (PDT)
Date:   Fri, 04 Nov 2022 07:50:16 -0700
In-Reply-To: <73f88a48-72e8-e6e7-faae-1d4b92e0e13b@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028529905eca631f7@google.com>
Subject: Re: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
From:   syzbot 
        <syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com>
To:     David Ahern <dsahern@kernel.org>
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

> On 11/4/22 4:32 AM, Alexander Potapenko wrote:
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
>> This patch ensures that the reserved field is always initialized.
>> 
>> Reported-by: syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
>> Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
>> Signed-off-by: Alexander Potapenko <glider@google.com>
>> ---
>>  net/ipv6/addrlabel.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
>
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

