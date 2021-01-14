Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BEC2F6569
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhANQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbhANQHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:07:10 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE23C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 08:06:43 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id v3so3107611plz.13
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 08:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jshthWkfursUYeoa93OIN20KDm6kOD11YBN+qn6iVt8=;
        b=cM1au4dRRrk7gfAtJBg05j7q1z6nw+H7+DICqL6BoR+mUt/L0HTv2NZt87IOfnzOgI
         A1yaI+jMCvuc+hWSj99W8Ngi6X5dPhWTRBNxXbg06OSIs8nlEx69LTozA2Ccc9f662Ez
         u6eXzuqAtazlbMfXJQIIO+eondOnQQd86IANsS9McTY3L70/ZbF/ClFFPm21KrLusOwN
         HkJQXfBob0tOMB6cppPbodlWTIwhY8rqDtHdA5+8J98Y1gbM9snKRsAjJpT5pHQWwNBo
         yyrG5rw8tIFBoSrWIIqi0/p2oRaXBoWgl0lSUH6oMIazOFFzx6gFjV6DmxO+L0JN2/5t
         zEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jshthWkfursUYeoa93OIN20KDm6kOD11YBN+qn6iVt8=;
        b=kCLjCgbq5jHx+K2XwXEktcYrmeEvIxrxGvHnTQNUVF2apLMOZ2qD51Kai6llA6IdLf
         jgY8s3iy5x9L17o+QN8eerm51awkXs0U1KOi2vLfDkV8/LXlLdP8XhvMS8sD2KlMaOEI
         aDvcPx3r6bUpdef/Ydz2RRvqGz5A71qDCgoKu/0uh/Nw/iqxVD1aHJbP3ErY6eS10V33
         B32inoGPFLbcquNRUFK6TXV3yUiTO+8ht7ztxN2P96U8jbnG6nCargtijkqbBX17LqJj
         jdXKjaSAvjPmRTm+iSwmxG1aEaqrNpELdeZ99uD4UChjMgfUKqPWCXOScX2mhQnfu+US
         Z8HA==
X-Gm-Message-State: AOAM531gfDhO+spj65OMJlQ9lfJrATMBtYuLCsV7fmGfR6+YlkG7U9dU
        0C+tP+UWviPAL+Dni7iTedB5mOl2+Ns=
X-Google-Smtp-Source: ABdhPJyGeBi+Dj9r2EcVn1xT0V2+EblIU1HEp+hWe6FiTOFHLe6VlVcfSf5BJlZk23p0bOBiriTznQ==
X-Received: by 2002:a17:90a:4d84:: with SMTP id m4mr5669329pjh.145.1610640402134;
        Thu, 14 Jan 2021 08:06:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id s7sm5413480pfh.207.2021.01.14.08.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 08:06:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net_sched: reject silly cell_log in qdisc_get_rtab()
Date:   Thu, 14 Jan 2021 08:06:37 -0800
Message-Id: <20210114160637.1660597-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

iproute2 probably never goes beyond 8 for the cell exponent,
but stick to the max shift exponent for signed 32bit.

UBSAN reported:
UBSAN: shift-out-of-bounds in net/sched/sch_api.c:389:22
shift exponent 130 is too large for 32-bit type 'int'
CPU: 1 PID: 8450 Comm: syz-executor586 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x183/0x22e lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
 __detect_linklayer+0x2a9/0x330 net/sched/sch_api.c:389
 qdisc_get_rtab+0x2b5/0x410 net/sched/sch_api.c:435
 cbq_init+0x28f/0x12c0 net/sched/sch_cbq.c:1180
 qdisc_create+0x801/0x1470 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x9e3/0x1fc0 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0xb1d/0xe60 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xaa6/0xe90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 51cb553e4317a3e2bca1996e0df004aab8111d58..6fe4e5cc807c90b046a16f014df43bfe841cbc43 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -412,7 +412,8 @@ struct qdisc_rate_table *qdisc_get_rtab(struct tc_ratespec *r,
 {
 	struct qdisc_rate_table *rtab;
 
-	if (tab == NULL || r->rate == 0 || r->cell_log == 0 ||
+	if (tab == NULL || r->rate == 0 ||
+	    r->cell_log == 0 || r->cell_log >= 32 ||
 	    nla_len(tab) != TC_RTAB_SIZE) {
 		NL_SET_ERR_MSG(extack, "Invalid rate table parameters for searching");
 		return NULL;
-- 
2.30.0.284.gd98b1dd5eaa7-goog

