Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8F50A12D
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354918AbiDUNv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387532AbiDUNv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7377C387B0;
        Thu, 21 Apr 2022 06:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB7FF61D43;
        Thu, 21 Apr 2022 13:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920B5C385A1;
        Thu, 21 Apr 2022 13:48:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oOBY5cE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650548913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmw2affTTW8Jrsi1py2DH/poP+25yl94U+xIteuoEyo=;
        b=oOBY5cE9ReqqNWmEIrcpJ7ew7ylwRbkqGwrrLEOUmld7YcTghFLOnYNsFo/ZFaJNx9AHqG
        GnsULGFpSJ1AJSyZLlBrjaFV5gCP6gSic/42jrbDNaGKpaja9MC/Khj9aapFTRlH4uepnw
        JiDr0oAtR5dcGobOetHXMXpIXCHmCxc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c330bc87 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 21 Apr 2022 13:48:33 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, stable@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/2] wireguard: device: check for metadata_dst with skb_valid_dst()
Date:   Thu, 21 Apr 2022 15:48:05 +0200
Message-Id: <20220421134805.279118-3-Jason@zx2c4.com>
In-Reply-To: <20220421134805.279118-1-Jason@zx2c4.com>
References: <20220421134805.279118-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <razor@blackwall.org>

When we try to transmit an skb with md_dst attached through wireguard
we hit a null pointer dereference in wg_xmit() due to the use of
dst_mtu() which calls into dst_blackhole_mtu() which in turn tries to
dereference dst->dev.

Since wireguard doesn't use md_dsts we should use skb_valid_dst(), which
checks for DST_METADATA flag, and if it's set, then falls back to
wireguard's device mtu. That gives us the best chance of transmitting
the packet; otherwise if the blackhole netdev is used we'd get
ETH_MIN_MTU.

 [  263.693506] BUG: kernel NULL pointer dereference, address: 00000000000000e0
 [  263.693908] #PF: supervisor read access in kernel mode
 [  263.694174] #PF: error_code(0x0000) - not-present page
 [  263.694424] PGD 0 P4D 0
 [  263.694653] Oops: 0000 [#1] PREEMPT SMP NOPTI
 [  263.694876] CPU: 5 PID: 951 Comm: mausezahn Kdump: loaded Not tainted 5.18.0-rc1+ #522
 [  263.695190] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
 [  263.695529] RIP: 0010:dst_blackhole_mtu+0x17/0x20
 [  263.695770] Code: 00 00 00 0f 1f 44 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 47 10 48 83 e0 fc 8b 40 04 85 c0 75 09 48 8b 07 <8b> 80 e0 00 00 00 c3 66 90 0f 1f 44 00 00 48 89 d7 be 01 00 00 00
 [  263.696339] RSP: 0018:ffffa4a4422fbb28 EFLAGS: 00010246
 [  263.696600] RAX: 0000000000000000 RBX: ffff8ac9c3553000 RCX: 0000000000000000
 [  263.696891] RDX: 0000000000000401 RSI: 00000000fffffe01 RDI: ffffc4a43fb48900
 [  263.697178] RBP: ffffa4a4422fbb90 R08: ffffffff9622635e R09: 0000000000000002
 [  263.697469] R10: ffffffff9b69a6c0 R11: ffffa4a4422fbd0c R12: ffff8ac9d18b1a00
 [  263.697766] R13: ffff8ac9d0ce1840 R14: ffff8ac9d18b1a00 R15: ffff8ac9c3553000
 [  263.698054] FS:  00007f3704c337c0(0000) GS:ffff8acaebf40000(0000) knlGS:0000000000000000
 [  263.698470] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  263.698826] CR2: 00000000000000e0 CR3: 0000000117a5c000 CR4: 00000000000006e0
 [  263.699214] Call Trace:
 [  263.699505]  <TASK>
 [  263.699759]  wg_xmit+0x411/0x450
 [  263.700059]  ? bpf_skb_set_tunnel_key+0x46/0x2d0
 [   263.700382]  ? dev_queue_xmit_nit+0x31/0x2b0
 [  263.700719]  dev_hard_start_xmit+0xd9/0x220
 [  263.701047]  __dev_queue_xmit+0x8b9/0xd30
 [  263.701344]  __bpf_redirect+0x1a4/0x380
 [  263.701664]  __dev_queue_xmit+0x83b/0xd30
 [  263.701961]  ? packet_parse_headers+0xb4/0xf0
 [  263.702275]  packet_sendmsg+0x9a8/0x16a0
 [  263.702596]  ? _raw_spin_unlock_irqrestore+0x23/0x40
 [  263.702933]  sock_sendmsg+0x5e/0x60
 [  263.703239]  __sys_sendto+0xf0/0x160
 [  263.703549]  __x64_sys_sendto+0x20/0x30
 [  263.703853]  do_syscall_64+0x3b/0x90
 [  263.704162]  entry_SYSCALL_64_after_hwframe+0x44/0xae
 [  263.704494] RIP: 0033:0x7f3704d50506
 [  263.704789] Code: 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 c3 90 55 48 83 ec 30 44 89 4c 24 2c 4c 89
 [  263.705652] RSP: 002b:00007ffe954b0b88 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
 [  263.706141] RAX: ffffffffffffffda RBX: 0000558bb259b490 RCX: 00007f3704d50506
 [  263.706544] RDX: 000000000000004a RSI: 0000558bb259b7b2 RDI: 0000000000000003
 [  263.706952] RBP: 0000000000000000 R08: 00007ffe954b0b90 R09: 0000000000000014
 [  263.707339] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe954b0b90
 [  263.707735] R13: 000000000000004a R14: 0000558bb259b7b2 R15: 0000000000000001
 [  263.708132]  </TASK>
 [  263.708398] Modules linked in: bridge netconsole bonding [last unloaded: bridge]
 [  263.708942] CR2: 00000000000000e0

Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Link: https://github.com/cilium/cilium/issues/19428
Reported-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 0fad1331303c..aa9a7a5970fd 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -19,6 +19,7 @@
 #include <linux/if_arp.h>
 #include <linux/icmp.h>
 #include <linux/suspend.h>
+#include <net/dst_metadata.h>
 #include <net/icmp.h>
 #include <net/rtnetlink.h>
 #include <net/ip_tunnels.h>
@@ -167,7 +168,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto err_peer;
 	}
 
-	mtu = skb_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
+	mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
 	__skb_queue_head_init(&packets);
 	if (!skb_is_gso(skb)) {
-- 
2.35.1

