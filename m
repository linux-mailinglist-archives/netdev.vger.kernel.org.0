Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F58D56BD62
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238402AbiGHPL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiGHPL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:11:57 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417182316E
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 08:11:56 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id f14-20020ac8068e000000b0031e899fabdcso10074619qth.5
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 08:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Lw3mE9XibSyJGeeym+U7hDw1qb6cZwUd2GOXItbzMUo=;
        b=jz2MOB0QJk7N8WADng97o+67KosDrrIJucbi4ukvKtTvy+aPzUot7loQoWGGicyb+S
         UrajfQRMUaHkrF2WiWL510lbq7s779XotHKFYYbMst35Xr8R4mXK0Lxcd8dMUQSw029T
         JrRyb8+t9AthVRd3Nqsaa07UvgkRPA0KC2da5FCraGfFf6BmqjhJ66j8pXxuGXp7vqnh
         jNDLhSEQkiVfKhfB10Y4IFyb4DrQhsLma2EipSHEFF6pm533aESQaAvEu8VARX8JVg7N
         uw9U7W61978ZUkfUTIimSRALv9Nbnq9TUaSYwfmszy+2OkLkeTp5fbr/gvQbkxv+cZtf
         9wPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Lw3mE9XibSyJGeeym+U7hDw1qb6cZwUd2GOXItbzMUo=;
        b=a8Ew6jy3s6eEbcIIZH/RRBI70Wb9EnEp1PUvYvKKSXuaol634uHkbS2caUKYngoNcn
         5Pn4SNNx6kFJHiL6vL03LPo50b4NzuQ5KeE4VCvEtLaBBzpHiPrWp8Pu4VQXldKjkHcf
         Jq272hxQ9O7g3FuFQlRCqk7Y/nen2ITuxTn60VHo2L1W84cRBlwxUIGetzocI+Vu63Tx
         F+10Jz9vLRiv4N+LfvOwu2F8OSXPCMxfVfO1gbsQ9NVg0a9J3cCuM+wHeQrLhNYEfK7j
         AZeb16H1ZRPXScMYjMvkLWWptVzmRJh1xJeblaBdHm2RZUR7yhAsbMRK9VCzeUf0lul6
         jd9Q==
X-Gm-Message-State: AJIora87lZDzN1NuKZ4csr6n5egU82iNXdC8/yGr9MUchqSHyNHraGtA
        UeffQ74IlNSgqWOiHYbPz2wbC+9OPnM2AQ==
X-Google-Smtp-Source: AGRyM1urZtF3rG6okHOxV6sBH7onlcEXai3xwiak8yQSjWFrY78Ox5oYwVznGYDEsQQVs55kTUZuo5b0NPJ7tw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:622a:1348:b0:31e:9f66:880f with SMTP
 id w8-20020a05622a134800b0031e9f66880fmr3405450qtk.542.1657293115442; Fri, 08
 Jul 2022 08:11:55 -0700 (PDT)
Date:   Fri,  8 Jul 2022 15:11:53 +0000
Message-Id: <20220708151153.1813012-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net] vlan: fix memory leak in vlan_newlink()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Xin Long <lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Blamed commit added back a bug I fixed in commit 9bbd917e0bec
("vlan: fix memory leak in vlan_dev_set_egress_priority")

If a memory allocation fails in vlan_changelink() after other allocations
succeeded, we need to call vlan_dev_free_egress_priority()
to free all allocated memory because after a failed ->newlink()
we do not call any methods like ndo_uninit() or dev->priv_destructor().

In following example, if the allocation for last element 2000:2001 fails,
we need to free eight prior allocations:

ip link add link dummy0 dummy0.100 type vlan id 100 \
	egress-qos-map 1:2 2:3 3:4 4:5 5:6 6:7 7:8 8:9 2000:2001

syzbot report was:

BUG: memory leak
unreferenced object 0xffff888117bd1060 (size 32):
comm "syz-executor408", pid 3759, jiffies 4294956555 (age 34.090s)
hex dump (first 32 bytes):
09 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<ffffffff83fc60ad>] kmalloc include/linux/slab.h:600 [inline]
[<ffffffff83fc60ad>] vlan_dev_set_egress_priority+0xed/0x170 net/8021q/vlan_dev.c:193
[<ffffffff83fc6628>] vlan_changelink+0x178/0x1d0 net/8021q/vlan_netlink.c:128
[<ffffffff83fc67c8>] vlan_newlink+0x148/0x260 net/8021q/vlan_netlink.c:185
[<ffffffff838b1278>] rtnl_newlink_create net/core/rtnetlink.c:3363 [inline]
[<ffffffff838b1278>] __rtnl_newlink+0xa58/0xdc0 net/core/rtnetlink.c:3580
[<ffffffff838b1629>] rtnl_newlink+0x49/0x70 net/core/rtnetlink.c:3593
[<ffffffff838ac66c>] rtnetlink_rcv_msg+0x21c/0x5c0 net/core/rtnetlink.c:6089
[<ffffffff839f9c37>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2501
[<ffffffff839f8da7>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
[<ffffffff839f8da7>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
[<ffffffff839f9266>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
[<ffffffff8384dbf6>] sock_sendmsg_nosec net/socket.c:714 [inline]
[<ffffffff8384dbf6>] sock_sendmsg+0x56/0x80 net/socket.c:734
[<ffffffff8384e15c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2488
[<ffffffff838523cb>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2542
[<ffffffff838525b8>] __sys_sendmsg net/socket.c:2571 [inline]
[<ffffffff838525b8>] __do_sys_sendmsg net/socket.c:2580 [inline]
[<ffffffff838525b8>] __se_sys_sendmsg net/socket.c:2578 [inline]
[<ffffffff838525b8>] __x64_sys_sendmsg+0x78/0xf0 net/socket.c:2578
[<ffffffff845ad8d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<ffffffff845ad8d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
[<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 37aa50c539bc ("vlan: introduce vlan_dev_free_egress_priority")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
---
 net/8021q/vlan_netlink.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 53b1955b027f89245eb8dd46ede9d7bfd6e553a3..214532173536b790cf032615f73fb3d868d2aae1 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -182,10 +182,14 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
 	else if (dev->mtu > max_mtu)
 		return -EINVAL;
 
+	/* Note: If this initial vlan_changelink() fails, we need
+	 * to call vlan_dev_free_egress_priority() to free memory.
+	 */
 	err = vlan_changelink(dev, tb, data, extack);
-	if (err)
-		return err;
-	err = register_vlan_dev(dev, extack);
+
+	if (!err)
+		err = register_vlan_dev(dev, extack);
+
 	if (err)
 		vlan_dev_free_egress_priority(dev);
 	return err;
-- 
2.37.0.rc0.161.g10f37bed90-goog

