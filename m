Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94723683648
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjAaTUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjAaTUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:20:04 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5241215568;
        Tue, 31 Jan 2023 11:20:02 -0800 (PST)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.10])
        by mail.ispras.ru (Postfix) with ESMTPSA id AC03B44C1001;
        Tue, 31 Jan 2023 19:19:58 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru AC03B44C1001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1675192798;
        bh=acFv/EVWgo/r3B/eoVvQRH4Rv7zdDgk0cupPU3JKT9M=;
        h=From:To:Cc:Subject:Date:From;
        b=jBfys3aNqdowNgIq94lu6N83EpR+X80bo1ofcMXeb1zgvwdvebEsEi/vXWWQtsv4m
         0ccAt1+HTgCWlkjiUaxj574FkwKu/b/fi8cOTknLy/QOli5JKEa4vd7axb7GZu5PVY
         p33LaoAlsKacsP8+zQX1mUIDX/A/SYeFPWwZEE5c=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Pravin B Shelar <pshelar@ovn.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH] net: openvswitch: fix flow memory leak in ovs_flow_cmd_new
Date:   Tue, 31 Jan 2023 22:19:39 +0300
Message-Id: <20230131191939.901288-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports a memory leak of new_flow in ovs_flow_cmd_new() as it is
not freed when an allocation of a key fails.

BUG: memory leak
unreferenced object 0xffff888116668000 (size 632):
  comm "syz-executor231", pid 1090, jiffies 4294844701 (age 18.871s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000defa3494>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
    [<00000000defa3494>] ovs_flow_alloc+0x19/0x180 net/openvswitch/flow_table.c:77
    [<00000000c67d8873>] ovs_flow_cmd_new+0x1de/0xd40 net/openvswitch/datapath.c:957
    [<0000000010a539a8>] genl_family_rcv_msg_doit+0x22d/0x330 net/netlink/genetlink.c:739
    [<00000000dff3302d>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
    [<00000000dff3302d>] genl_rcv_msg+0x328/0x590 net/netlink/genetlink.c:800
    [<000000000286dd87>] netlink_rcv_skb+0x153/0x430 net/netlink/af_netlink.c:2515
    [<0000000061fed410>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
    [<000000009dc0f111>] netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
    [<000000009dc0f111>] netlink_unicast+0x545/0x7f0 net/netlink/af_netlink.c:1339
    [<000000004a5ee816>] netlink_sendmsg+0x8e7/0xde0 net/netlink/af_netlink.c:1934
    [<00000000482b476f>] sock_sendmsg_nosec net/socket.c:651 [inline]
    [<00000000482b476f>] sock_sendmsg+0x152/0x190 net/socket.c:671
    [<00000000698574ba>] ____sys_sendmsg+0x70a/0x870 net/socket.c:2356
    [<00000000d28d9e11>] ___sys_sendmsg+0xf3/0x170 net/socket.c:2410
    [<0000000083ba9120>] __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
    [<00000000c00628f8>] do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
    [<000000004abfdcf4>] entry_SYSCALL_64_after_hwframe+0x61/0xc6

To fix this the patch removes unnecessary err_kfree_key label and adds a
proper goto statement on the key-allocation-error path.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 68bb10101e6b ("openvswitch: Fix flow lookup to use unmasked key")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 net/openvswitch/datapath.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index a71795355aec..3d4b5d83d306 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1004,7 +1004,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	key = kzalloc(sizeof(*key), GFP_KERNEL);
 	if (!key) {
 		error = -ENOMEM;
-		goto err_kfree_key;
+		goto err_kfree_flow;
 	}
 
 	ovs_match_init(&match, key, false, &mask);
@@ -1128,7 +1128,6 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_nla_free_flow_actions(acts);
 err_kfree_flow:
 	ovs_flow_free(new_flow, false);
-err_kfree_key:
 	kfree(key);
 error:
 	return error;
-- 
2.30.2

