Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEF0619479
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiKDKc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiKDKcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:32:23 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C03626496
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:32:22 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id z15-20020a05640240cf00b00461b253c220so3219805edb.3
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1SoVxq2eq/o0I9xtkXlt1Kp3g3hRPftcZsAVlrUyHqU=;
        b=ZyllgC7zGELy6cGe6p7Ftxhj8uOxfJaMzP88cFA/WXJtT+qO9qEKdYh2GUYYXzZBp1
         ebZGF0WzM4X8dHtN1yeXD5w/b6/PjExUSKtNOHeEmDRCDEZ6GrJpc1EH635/m1bf8X/U
         JPyeRheqFhpSuwFWPDhsBZg+qCmt/G9V+dyxE3/74K5r4YCc0g87eqKWo864kSGauAQG
         vmSe2ExhzxAoqrMD/3+3DGZqK0HNQtP3qvOmUj9wGqI6ATi9XD/e3cK5KNkzLkjEuoI/
         /0xHcyZWKoHq/+tjyLCnxB5ZziHh4OmbN65tgTrVWrbHDQYLlKqnLmO+gVvqSEgBWKIL
         3ecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1SoVxq2eq/o0I9xtkXlt1Kp3g3hRPftcZsAVlrUyHqU=;
        b=lFfmsTA/m63whiwMgvCKk4aRORbp3QmS1vpi32J6YKHSZSvpQ8+5NQJ6Ck4U3Mf6Nu
         nJir1PYQlWMj33A5d6Hb8gEiJYGMsQuJWNmOwBwe2kdh4mrgp4XgclBnzC2ewZYGcNuD
         hIRDAUXwD7va6jf0K3jqGPDKxiFyi2zgjj1DiLmBHmJDWLsRTL6ET/g80AAL/NuedzRn
         IAUKQ6rWtmDA20YVmhwDGwXxCEqm6vIbgqqekGSE8OELn+cXFIA6CAj91VzchNNW900Q
         pN7TWkLlQVV7uX9NHH7fwFXMFMnNJP8hrtyd5TbBe2cpv+NyuFh9WTsJtLqEOm+BB+0p
         7yZA==
X-Gm-Message-State: ACrzQf2qNMH0TRkHJKKPOsg8RMWMcjKKGjhdWW99/rki+5lH3Suj4q1H
        KHW3lq06Uso/OQVcCXeWwnnybjznxWg=
X-Google-Smtp-Source: AMsMyM6wV8HP6okWpJ0OWN0Wppl1sSkhPhQplfnquRRlxmsvRqQoBI99SzGgSy8idSzsRXa7jBVqu3/bjJg=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:9c:201:6696:b522:be5f:6acc])
 (user=glider job=sendgmr) by 2002:a05:6402:616:b0:463:e2cd:a88d with SMTP id
 n22-20020a056402061600b00463e2cda88dmr15251520edv.400.1667557940714; Fri, 04
 Nov 2022 03:32:20 -0700 (PDT)
Date:   Fri,  4 Nov 2022 11:32:16 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104103216.2576427-1-glider@google.com>
Subject: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
From:   Alexander Potapenko <glider@google.com>
To:     glider@google.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When copying a `struct ifaddrlblmsg` to the network, __ifal_reserved
remained uninitialized, resulting in a 1-byte infoleak:

  BUG: KMSAN: kernel-network-infoleak in __netdev_start_xmit ./include/linux/netdevice.h:4841
   __netdev_start_xmit ./include/linux/netdevice.h:4841
   netdev_start_xmit ./include/linux/netdevice.h:4857
   xmit_one net/core/dev.c:3590
   dev_hard_start_xmit+0x1dc/0x800 net/core/dev.c:3606
   __dev_queue_xmit+0x17e8/0x4350 net/core/dev.c:4256
   dev_queue_xmit ./include/linux/netdevice.h:3009
   __netlink_deliver_tap_skb net/netlink/af_netlink.c:307
   __netlink_deliver_tap+0x728/0xad0 net/netlink/af_netlink.c:325
   netlink_deliver_tap net/netlink/af_netlink.c:338
   __netlink_sendskb net/netlink/af_netlink.c:1263
   netlink_sendskb+0x1d9/0x200 net/netlink/af_netlink.c:1272
   netlink_unicast+0x56d/0xf50 net/netlink/af_netlink.c:1360
   nlmsg_unicast ./include/net/netlink.h:1061
   rtnl_unicast+0x5a/0x80 net/core/rtnetlink.c:758
   ip6addrlbl_get+0xfad/0x10f0 net/ipv6/addrlabel.c:628
   rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
  ...
  Uninit was created at:
   slab_post_alloc_hook+0x118/0xb00 mm/slab.h:742
   slab_alloc_node mm/slub.c:3398
   __kmem_cache_alloc_node+0x4f2/0x930 mm/slub.c:3437
   __do_kmalloc_node mm/slab_common.c:954
   __kmalloc_node_track_caller+0x117/0x3d0 mm/slab_common.c:975
   kmalloc_reserve net/core/skbuff.c:437
   __alloc_skb+0x27a/0xab0 net/core/skbuff.c:509
   alloc_skb ./include/linux/skbuff.h:1267
   nlmsg_new ./include/net/netlink.h:964
   ip6addrlbl_get+0x490/0x10f0 net/ipv6/addrlabel.c:608
   rtnetlink_rcv_msg+0xb33/0x1570 net/core/rtnetlink.c:6082
   netlink_rcv_skb+0x299/0x550 net/netlink/af_netlink.c:2540
   rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6109
   netlink_unicast_kernel net/netlink/af_netlink.c:1319
   netlink_unicast+0x9ab/0xf50 net/netlink/af_netlink.c:1345
   netlink_sendmsg+0xebc/0x10f0 net/netlink/af_netlink.c:1921
  ...

This patch ensures that the reserved field is always initialized.

Reported-by: syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
Fixes: 2a8cc6c89039 ("[IPV6] ADDRCONF: Support RFC3484 configurable address selection policy table.")
Signed-off-by: Alexander Potapenko <glider@google.com>
---
 net/ipv6/addrlabel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index 8a22486cf2702..17ac45aa7194c 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -437,6 +437,7 @@ static void ip6addrlbl_putmsg(struct nlmsghdr *nlh,
 {
 	struct ifaddrlblmsg *ifal = nlmsg_data(nlh);
 	ifal->ifal_family = AF_INET6;
+	ifal->__ifal_reserved = 0;
 	ifal->ifal_prefixlen = prefixlen;
 	ifal->ifal_flags = 0;
 	ifal->ifal_index = ifindex;
-- 
2.38.1.431.g37b22c650d-goog

