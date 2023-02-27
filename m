Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A276A4618
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjB0Paf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjB0Paa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:30:30 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70876DBDB
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:30:26 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536d63d17dbso146633347b3.22
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=poF9lsCHtcbrff89kcJnOuM8zVY9vRlCRZ+A7w7CJn0=;
        b=UkN2CnXqKR8eC6CcNpbywqLkU7eoqkR9bpCfS6rFuwAq/O31CnCFivWzU1zJkAE8+H
         3RscsimcLogetsRCiyihrgM5wc45KKQfDfaiv2dJVPUe6Cu4iuXfXnpmFBSyZMnVr5/L
         h6HOB4SbVi/vjZWys+Wc33hQaHRhJRPGmd0nRjUILSHh4pzV4GpcNQL0r3jlo17N+9cP
         Y19Nk/DWUzsP45Ieku8m4azvlyqCkQkLUkI5T8H449CPz0Jk6O275rwabkxb3o2u3xfj
         M9orQ3KGuvOZqQJZ+D3CccXnCTbaMSuCqDI6Wy/dp1brubdVZUO8BxRL47yLLLDa0589
         C8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=poF9lsCHtcbrff89kcJnOuM8zVY9vRlCRZ+A7w7CJn0=;
        b=Im/1Ib15VgpVEUQ+BF5FAy2SLaLS3Tsn0SDBBS0p3aSziQ3YvbPEB4blbePd/C5lQD
         +FpvdLpIlymfr46Xtpf13LkmUuPa5gxn/386ck/VOdtdei1LrlosYMo6C9gUVRnbISJc
         nmzjxjrXVFrsPii0BWf/ItRNHLhFwj+2I8C4sEIaogX1IEHAo1RoCGRqXc4UKsQ0BnHK
         vPi9eNSAE1q8ZHLmIHW6XUCQ/UNSLLQ7G83UbAcMTRR2hYosc+do+5T/+ZTlqjlOVjgn
         tHZ6rPhdUs/l4CyAwpyRnFLe9B1gpHCV5szfhcUPJH458Xe43dNhD7AbVaU20YlfZC8y
         uMDg==
X-Gm-Message-State: AO0yUKUv7oKjWXXkbdIDTKihW4y/OoI+8iWLDP/uZ6Q5+vKfh3jhxQno
        cawdS1DzNxx2VkO5FVeuEsR7A9dOA+PTkQ==
X-Google-Smtp-Source: AK7set/oXF3LHljjVt6hQzufMOCNtIxngFuqqNajYulBufredL2Lak0rumqRmHmhZoMKPMkSqUC5JedvQwrbkw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:684:0:b0:a5a:18d1:d456 with SMTP id
 j4-20020a5b0684000000b00a5a18d1d456mr3829396ybq.12.1677511825646; Mon, 27 Feb
 2023 07:30:25 -0800 (PST)
Date:   Mon, 27 Feb 2023 15:30:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230227153024.526366-1-edumazet@google.com>
Subject: [PATCH net] ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
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

ila_xlat_nl_cmd_get_mapping() generates an empty skb,
triggerring a recent sanity check [1].

Instead, return an error code, so that user space
can get it.

[1]
skb_assert_len
WARNING: CPU: 0 PID: 5923 at include/linux/skbuff.h:2527 skb_assert_len include/linux/skbuff.h:2527 [inline]
WARNING: CPU: 0 PID: 5923 at include/linux/skbuff.h:2527 __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
Modules linked in:
CPU: 0 PID: 5923 Comm: syz-executor269 Not tainted 6.2.0-syzkaller-18300-g2ebd1fbb946d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : skb_assert_len include/linux/skbuff.h:2527 [inline]
pc : __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
lr : skb_assert_len include/linux/skbuff.h:2527 [inline]
lr : __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
sp : ffff80001e0d6c40
x29: ffff80001e0d6e60 x28: dfff800000000000 x27: ffff0000c86328c0
x26: dfff800000000000 x25: ffff0000c8632990 x24: ffff0000c8632a00
x23: 0000000000000000 x22: 1fffe000190c6542 x21: ffff0000c8632a10
x20: ffff0000c8632a00 x19: ffff80001856e000 x18: ffff80001e0d5fc0
x17: 0000000000000000 x16: ffff80001235d16c x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000001
x11: ff80800008353a30 x10: 0000000000000000 x9 : 21567eaf25bfb600
x8 : 21567eaf25bfb600 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff80001e0d6558 x4 : ffff800015c74760 x3 : ffff800008596744
x2 : 0000000000000001 x1 : 0000000100000000 x0 : 000000000000000e
Call trace:
skb_assert_len include/linux/skbuff.h:2527 [inline]
__dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
dev_queue_xmit include/linux/netdevice.h:3033 [inline]
__netlink_deliver_tap_skb net/netlink/af_netlink.c:307 [inline]
__netlink_deliver_tap+0x45c/0x6f8 net/netlink/af_netlink.c:325
netlink_deliver_tap+0xf4/0x174 net/netlink/af_netlink.c:338
__netlink_sendskb net/netlink/af_netlink.c:1283 [inline]
netlink_sendskb+0x6c/0x154 net/netlink/af_netlink.c:1292
netlink_unicast+0x334/0x8d4 net/netlink/af_netlink.c:1380
nlmsg_unicast include/net/netlink.h:1099 [inline]
genlmsg_unicast include/net/genetlink.h:433 [inline]
genlmsg_reply include/net/genetlink.h:443 [inline]
ila_xlat_nl_cmd_get_mapping+0x620/0x7d0 net/ipv6/ila/ila_xlat.c:493
genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
genl_rcv_msg+0x938/0xc1c net/netlink/genetlink.c:1065
netlink_rcv_skb+0x214/0x3c4 net/netlink/af_netlink.c:2574
genl_rcv+0x38/0x50 net/netlink/genetlink.c:1076
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x660/0x8d4 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x800/0xae0 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
____sys_sendmsg+0x558/0x844 net/socket.c:2479
___sys_sendmsg net/socket.c:2533 [inline]
__sys_sendmsg+0x26c/0x33c net/socket.c:2562
__do_sys_sendmsg net/socket.c:2571 [inline]
__se_sys_sendmsg net/socket.c:2569 [inline]
__arm64_sys_sendmsg+0x80/0x94 net/socket.c:2569
__invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
el0_svc_common+0x138/0x258 arch/arm64/kernel/syscall.c:142
do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
el0_svc+0x58/0x168 arch/arm64/kernel/entry-common.c:637
el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
irq event stamp: 136484
hardirqs last enabled at (136483): [<ffff800008350244>] __up_console_sem+0x60/0xb4 kernel/printk/printk.c:345
hardirqs last disabled at (136484): [<ffff800012358d60>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last enabled at (136418): [<ffff800008020ea8>] softirq_handle_end kernel/softirq.c:414 [inline]
softirqs last enabled at (136418): [<ffff800008020ea8>] __do_softirq+0xd4c/0xfa4 kernel/softirq.c:600
softirqs last disabled at (136371): [<ffff80000802b4a4>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
skb len=0 headroom=0 headlen=0 tailroom=192
mac=(0,0) net=(0,-1) trans=-1
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0x0 sw=0 l4=0) proto=0x0010 pkttype=6 iif=0
dev name=nlmon0 feat=0x0000000000005861

Fixes: 7f00feaf1076 ("ila: Add generic ILA translation facility")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ila/ila_xlat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 47447f0241df604bc657acbd9ce37008b49bacf0..bee45dfeb18741106fa517ef634fa09d25f0cea3 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -477,6 +477,7 @@ int ila_xlat_nl_cmd_get_mapping(struct sk_buff *skb, struct genl_info *info)
 
 	rcu_read_lock();
 
+	ret = -ESRCH;
 	ila = ila_lookup_by_params(&xp, ilan);
 	if (ila) {
 		ret = ila_dump_info(ila,
-- 
2.39.2.637.g21b0678d19-goog

