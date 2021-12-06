Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3113746A1F9
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhLFRHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346300AbhLFQ5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 11:57:03 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC21C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 08:53:34 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id y7so7495934plp.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 08:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FKyRvc06OYHyIhtRt9od5+Ecbd9zPhcedewDjua4g7c=;
        b=DwB8Pb06h80WmACgyRh56hBz6CA+Q8KyJhsEWv0nii2MfRn+uJZ+g5e7U0Kf8RbQ5A
         zYz2xczUD7MuaCo03CwwDXCtmbXr/HM45XnISThWeDXu0ldvqjgkTVlz94IQ9p0ybSec
         jVbXZWA4mIW/dKEesZ84AbA9OUTR+oeg/kiiYetq1BEpkeq1aFqecMLldIjiXdKfoF+X
         5w6FB1vB66iQY8tt7WfaS75s/p8NIvdzKlle+BX7xd/PXjd02Mnml0aqQEG180Nx6Olo
         PczOylh4hNQOFaWz6fhK8BaHVnRsbqtM9UL7xxmCmLswclmgxiNOmTbFcDHLTeD4cfV3
         tbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FKyRvc06OYHyIhtRt9od5+Ecbd9zPhcedewDjua4g7c=;
        b=hdgiGDQa1N/78rOHAvD2D52ICW4t3lNdLy3Qg7i8q0hkjIqNh6/2AugrP47UHCL7aL
         oY/DIVN+QCVG9psj/Drwun2949CnW26Fe0j8kfVr5B4u8jEF1vBOqPiVSSptLhbCN/oH
         Ya6Xjqqy88kMsff8ErH7Wz+ow5i6Kd2kfOMwejyv8/HpRelL+ENnN5hu1w64sUZcIo4p
         NZ7y16QnwokIKY+orL1mqX6ajA4upxkbaHlkLQNmZIdrAGqtAwp7qofm0SMTzmuXqo0f
         WGD12msklGRfLW2Zza5xamCAuuH4X6l1KM0dB31HWjMcSwi7uwGInzbKN5foRr+gvxF8
         3nNw==
X-Gm-Message-State: AOAM532r7G29IO10WNGlIFELhviQ08wyzupT1fv3hY5M9aYc3lwLv6Tu
        QPmNxY1jcqfMxdQ+NGi/r8c=
X-Google-Smtp-Source: ABdhPJxH1IHFTqoAAw5CkGHhFKStrLXbhpjduA4zRsfoXYnolcX+M1AdKhGd2sLNEBRJYJeXfkBSQA==
X-Received: by 2002:a17:90a:7ac8:: with SMTP id b8mr38412189pjl.206.1638809613885;
        Mon, 06 Dec 2021 08:53:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a314:9d83:ab71:fd64])
        by smtp.gmail.com with ESMTPSA id e7sm7537044pfv.156.2021.12.06.08.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 08:53:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: [PATCH net] net, neigh: clear whole pneigh_entry at alloc time
Date:   Mon,  6 Dec 2021 08:53:29 -0800
Message-Id: <20211206165329.1049835-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Commit 2c611ad97a82 ("net, neigh: Extend neigh->flags to 32 bit
to allow for extensions") enables a new KMSAM warning [1]

I think the bug is actually older, because the following intruction
only occurred if ndm->ndm_flags had NTF_PROXY set.

	pn->flags = ndm->ndm_flags;

Let's clear all pneigh_entry fields at alloc time.

[1]
BUG: KMSAN: uninit-value in pneigh_fill_info+0x986/0xb30 net/core/neighbour.c:2593
 pneigh_fill_info+0x986/0xb30 net/core/neighbour.c:2593
 pneigh_dump_table net/core/neighbour.c:2715 [inline]
 neigh_dump_info+0x1e3f/0x2c60 net/core/neighbour.c:2832
 netlink_dump+0xaca/0x16a0 net/netlink/af_netlink.c:2265
 __netlink_dump_start+0xd1c/0xee0 net/netlink/af_netlink.c:2370
 netlink_dump_start include/linux/netlink.h:254 [inline]
 rtnetlink_rcv_msg+0x181b/0x18c0 net/core/rtnetlink.c:5534
 netlink_rcv_skb+0x447/0x800 net/netlink/af_netlink.c:2491
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5589
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x1095/0x1360 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x16f3/0x1870 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_write_iter+0x594/0x690 net/socket.c:1057
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0x1318/0x2030 fs/read_write.c:590
 ksys_write+0x28c/0x520 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0xdb/0x120 fs/read_write.c:652
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 slab_alloc mm/slub.c:3259 [inline]
 __kmalloc+0xc3c/0x12d0 mm/slub.c:4437
 kmalloc include/linux/slab.h:595 [inline]
 pneigh_lookup+0x60f/0xd70 net/core/neighbour.c:766
 arp_req_set_public net/ipv4/arp.c:1016 [inline]
 arp_req_set+0x430/0x10a0 net/ipv4/arp.c:1032
 arp_ioctl+0x8d4/0xb60 net/ipv4/arp.c:1232
 inet_ioctl+0x4ef/0x820 net/ipv4/af_inet.c:947
 sock_do_ioctl net/socket.c:1118 [inline]
 sock_ioctl+0xa3f/0x13e0 net/socket.c:1235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0x2df/0x4a0 fs/ioctl.c:860
 __x64_sys_ioctl+0xd8/0x110 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 1 PID: 20001 Comm: syz-executor.0 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 62dd93181aaa ("[IPV6] NDISC: Set per-entry is_router flag in Proxy NA.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
---
 net/core/neighbour.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 72ba027c34cfea6f38a9e78927c35048ebfe7a7f..dda12fbd177ba6ad2798ea2b07733fa3f03441ab 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -763,11 +763,10 @@ struct pneigh_entry * pneigh_lookup(struct neigh_table *tbl,
 
 	ASSERT_RTNL();
 
-	n = kmalloc(sizeof(*n) + key_len, GFP_KERNEL);
+	n = kzalloc(sizeof(*n) + key_len, GFP_KERNEL);
 	if (!n)
 		goto out;
 
-	n->protocol = 0;
 	write_pnet(&n->net, net);
 	memcpy(n->key, pkey, key_len);
 	n->dev = dev;
-- 
2.34.1.400.ga245620fadb-goog

