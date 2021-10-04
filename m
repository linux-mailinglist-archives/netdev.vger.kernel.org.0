Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05974421804
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbhJDT5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbhJDT5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:57:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824ABC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 12:55:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso582124pjb.0
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 12:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mB33G1prEIZiVLD2SFLG+swLg4+0DQWT6yFGCLUCrgs=;
        b=jY2+FbJMz4EcmpSsk/sDZwr2qdsXq6Cq1vu09ritYCFQKF+4c9J1alVTx3L+97TRbW
         D4j+itWoVXmuupa/6Hxv6dGAZiSisl+Ku87ihI+S2tR8T4WmQun4rvGp/dxsGZVu79uu
         QG5NYWAXIJwxQ4b+PfVRomTPgsW05+xcq4YKOz8wD1XoCR56GNjNYmnllx7hTsy88+ao
         3IpxrLVoTD9sEBKQyo1COFDbH7lW5QB4nwpzr6GE92OhYNlM/cu2ukZuZkWGwCpAQMz1
         oKggzfl8gVf+to/7I+0tvoyEQ6mHF2P109Prw8y238SES/7nMUGafvngKc2Fz8U6IJRR
         8rVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mB33G1prEIZiVLD2SFLG+swLg4+0DQWT6yFGCLUCrgs=;
        b=Ai3ivtdq4eBzQX2kplzZrD684atxAZQAsA40klfobWnhl075ojH6UegvUSbU09wXtV
         J9dSXwqdRxBRAJUdX3x40+hIl46r8B2LHS+1BrJPZLvMuLC9Zq0KqVPnsmy8OaElVm4H
         youKeFnx9uVkhrgWO3do6GqN0/oYIyTtUb+JXCIox+V7yMtqMGgtmGTBFpC8eDPNj9mi
         CWhvejS8We90gjWeE2oXrmo/3SdUzSZwT4eAk2YAl0DNJAVYdvwyHclSJSMAmZEPemEx
         WTkFwkaQ3KneMFI1VT9lWExBKB95Es6N9eXyOQR5wdUR88IeHRWacnSnjKaxkw4NOp4+
         9+XA==
X-Gm-Message-State: AOAM533QBPPwjbRjw4A/DrvIZ/jtO1fSJCpAudTHdHZUg1U1/dUZ+Y/7
        OS2e5LXbPeQzmC0bfWKKe5I=
X-Google-Smtp-Source: ABdhPJxYkES6/KXMPb+ML7MMbyHZPSLHwQUDUIXL49AzIovbzjLFzBYqSiM2QsAqipfb5wyuxSya6w==
X-Received: by 2002:a17:902:db06:b0:13e:58d8:3fef with SMTP id m6-20020a170902db0600b0013e58d83fefmr1383200plx.43.1633377328061;
        Mon, 04 Oct 2021 12:55:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7236:cc97:8564:4e2a])
        by smtp.gmail.com with ESMTPSA id f25sm15364026pge.7.2021.10.04.12.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:55:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net/sched: sch_taprio: properly cancel timer from taprio_destroy()
Date:   Mon,  4 Oct 2021 12:55:22 -0700
Message-Id: <20211004195522.2041705-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

There is a comment in qdisc_create() about us not calling ops->reset()
in some cases.

err_out4:
	/*
	 * Any broken qdiscs that would require a ops->reset() here?
	 * The qdisc was never in action so it shouldn't be necessary.
	 */

As taprio sets a timer before actually receiving a packet, we need
to cancel it from ops->destroy, just in case ops->reset has not
been called.

syzbot reported:

ODEBUG: free active (active state 0) object type: hrtimer hint: advance_sched+0x0/0x9a0 arch/x86/include/asm/atomic64_64.h:22
WARNING: CPU: 0 PID: 8441 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 8441 Comm: syz-executor813 Not tainted 5.14.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd e0 d3 e3 89 4c 89 ee 48 c7 c7 e0 c7 e3 89 e8 5b 86 11 05 <0f> 0b 83 05 85 03 92 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000130f330 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff88802baeb880 RSI: ffffffff815d87b5 RDI: fffff52000261e58
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d25ee R11: 0000000000000000 R12: ffffffff898dd020
R13: ffffffff89e3ce20 R14: ffffffff81653630 R15: dffffc0000000000
FS:  0000000000f0d300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffb64b3e000 CR3: 0000000036557000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __debug_check_no_obj_freed lib/debugobjects.c:987 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1018
 slab_free_hook mm/slub.c:1603 [inline]
 slab_free_freelist_hook+0x171/0x240 mm/slub.c:1653
 slab_free mm/slub.c:3213 [inline]
 kfree+0xe4/0x540 mm/slub.c:4267
 qdisc_create+0xbcf/0x1320 net/sched/sch_api.c:1299
 tc_modify_qdisc+0x4c8/0x1a60 net/sched/sch_api.c:1663
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80

Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Davide Caratti <dcaratti@redhat.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_taprio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1ab2fc933a214d04dfff763d2c5de65f4a67374a..b9fd18d986464f317a9fb7ce709a9728ffb75751 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1641,6 +1641,10 @@ static void taprio_destroy(struct Qdisc *sch)
 	list_del(&q->taprio_list);
 	spin_unlock(&taprio_list_lock);
 
+	/* Note that taprio_reset() might not be called if an error
+	 * happens in qdisc_create(), after taprio_init() has been called.
+	 */
+	hrtimer_cancel(&q->advance_timer);
 
 	taprio_disable_offload(dev, q, NULL);
 
-- 
2.33.0.800.g4c38ced690-goog

