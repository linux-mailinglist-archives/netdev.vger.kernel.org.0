Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC58C2CF1CF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgLDQZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDQZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:25:14 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F87CC0613D1;
        Fri,  4 Dec 2020 08:24:34 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q22so4030966pfk.12;
        Fri, 04 Dec 2020 08:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBrdOURnR648n2XD9NndbhDk737p/6hmnaT9+XJMRWw=;
        b=GNTCvb18UFsbl4Uzzr3uuCyhNZf63rjVElaIZFKYx2FKaOT98ctqtmQNDacHvNBp+d
         DBSnog8Mgs5Lay/ItMEXBxgcPk5CUtasRRZDVVv0D8oQEpX87gEvJw3RfjjSW7clcbs3
         EvpLRSRFnHHPyM9IY9ZL/RQbF43509RRnQfPhhWP1DG1jaASgnbxwcFXUfMN7o5ii33p
         4eJTX80kKRBHybkkZ6sBgq+bdqEEpZ7bz0plBEBLPtK+U3dkc6eflz9IXQkHVy//Tg1m
         Mqison8pRbncEQlnqI2myT03UvOueR2i/APUEj/Nyx1l5KKs5Wx5rCAtvXxJBcGAZart
         J2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBrdOURnR648n2XD9NndbhDk737p/6hmnaT9+XJMRWw=;
        b=W0ZviO9aDd+i/IKCJgs5JaueJBheNPVHgIkK7OhaLiD9xAy2PZF1Le7WZwo1RPrNom
         eYwRPoP52jvuPNVsnbymRX5qApxqoGGEc70KmqVxvYkUqM4fVDA0n80qfTYglAuikz6E
         tDQ9sbd6FxXjGEiT7wcBaNGM/fyWsMU6n3vNaWw/Q/bDNAaz5evdumIWdX7UIGAr778Z
         963cOzn9lfVECVFEEMUnQ89QdSSi8g4inVW6FzgFEAHVtQWazE4Iy7q2tY3niQ4nQ1RK
         kdb82SW+YK/SCUr2KIybCsxlyy8hgUDxs7gI7ivpFQfpkWQKlqiJty/KrmjQRhMvBD1n
         IH4w==
X-Gm-Message-State: AOAM532TCvIhDUn7+1kWy9AHC6KdDT9sx5O2414GL3Fjj6oJPNJ2r8lX
        AwAvlQGhy0cNS2nmafTiiDY=
X-Google-Smtp-Source: ABdhPJwBCaOAgRC7TtbkQr75r/87dnR331bPU8mpMxPO/H3+n9XNNBGdgfhQnv3mGRzI9LKenebsAA==
X-Received: by 2002:a63:5550:: with SMTP id f16mr8022458pgm.151.1607099073944;
        Fri, 04 Dec 2020 08:24:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id x10sm4806265pfc.133.2020.12.04.08.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 08:24:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net] mac80211: mesh: fix mesh_pathtbl_init() error path
Date:   Fri,  4 Dec 2020 08:24:28 -0800
Message-Id: <20201204162428.2583119-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If tbl_mpp can not be allocated, we call mesh_table_free(tbl_path)
while tbl_path rhashtable has not yet been initialized, which causes
panics.

Simply factorize the rhashtable_init() call into mesh_table_alloc()

WARNING: CPU: 1 PID: 8474 at kernel/workqueue.c:3040 __flush_work kernel/workqueue.c:3040 [inline]
WARNING: CPU: 1 PID: 8474 at kernel/workqueue.c:3040 __cancel_work_timer+0x514/0x540 kernel/workqueue.c:3136
Modules linked in:
CPU: 1 PID: 8474 Comm: syz-executor663 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__flush_work kernel/workqueue.c:3040 [inline]
RIP: 0010:__cancel_work_timer+0x514/0x540 kernel/workqueue.c:3136
Code: 5d c3 e8 bf ae 29 00 0f 0b e9 f0 fd ff ff e8 b3 ae 29 00 0f 0b 43 80 3c 3e 00 0f 85 31 ff ff ff e9 34 ff ff ff e8 9c ae 29 00 <0f> 0b e9 dc fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 7d fd ff
RSP: 0018:ffffc9000165f5a0 EFLAGS: 00010293
RAX: ffffffff814b7064 RBX: 0000000000000001 RCX: ffff888021c80000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888024039ca0 R08: dffffc0000000000 R09: fffffbfff1dd3e64
R10: fffffbfff1dd3e64 R11: 0000000000000000 R12: 1ffff920002cbebd
R13: ffff888024039c88 R14: 1ffff11004807391 R15: dffffc0000000000
FS:  0000000001347880(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 000000002cc0a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rhashtable_free_and_destroy+0x25/0x9c0 lib/rhashtable.c:1137
 mesh_table_free net/mac80211/mesh_pathtbl.c:69 [inline]
 mesh_pathtbl_init+0x287/0x2e0 net/mac80211/mesh_pathtbl.c:785
 ieee80211_mesh_init_sdata+0x2ee/0x530 net/mac80211/mesh.c:1591
 ieee80211_setup_sdata+0x733/0xc40 net/mac80211/iface.c:1569
 ieee80211_if_add+0xd5c/0x1cd0 net/mac80211/iface.c:1987
 ieee80211_add_iface+0x59/0x130 net/mac80211/cfg.c:125
 rdev_add_virtual_intf net/wireless/rdev-ops.h:45 [inline]
 nl80211_new_interface+0x563/0xb40 net/wireless/nl80211.c:3855
 genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x780/0x930 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x9a8/0xd40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/mesh_pathtbl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 48f31ac9233c8b33558cf41a9b44412c7b1ad591..620ecf922408b1f870d4da8ab7eef02e4d33ab15 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -60,6 +60,7 @@ static struct mesh_table *mesh_table_alloc(void)
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 	spin_lock_init(&newtbl->walk_lock);
+	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
 
 	return newtbl;
 }
@@ -773,9 +774,6 @@ int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
 		goto free_path;
 	}
 
-	rhashtable_init(&tbl_path->rhead, &mesh_rht_params);
-	rhashtable_init(&tbl_mpp->rhead, &mesh_rht_params);
-
 	sdata->u.mesh.mesh_paths = tbl_path;
 	sdata->u.mesh.mpp_paths = tbl_mpp;
 
-- 
2.29.2.576.ga3fc446d84-goog

