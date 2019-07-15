Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90516930C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392181AbfGOOlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404478AbfGOOlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:41:21 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 534E3205ED;
        Mon, 15 Jul 2019 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201681;
        bh=4cambM2xw2lxptzwMFd8uZq+I0RHRfjOYzUQtpKrL/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ox26xdpnF8CsuwqDm31kQvCrq1p992MnwmhmPqLcFIBeKexNtRBHDtKB3K1ekO279
         hDlrxq9ri2UzQ3yin4Ilh7WCrMgg05jUZ6jrOqDiKrN2lKscRcGegFYwp0bSuaRIZY
         B51lH/5ZK9SFn2O0OxN4XWJ/rOGZTEPoPB3qOjHM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 72/73] gtp: fix Illegal context switch in RCU read-side critical section.
Date:   Mon, 15 Jul 2019 10:36:28 -0400
Message-Id: <20190715143629.10893-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715143629.10893-1-sashal@kernel.org>
References: <20190715143629.10893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 3f167e1921865b379a9becf03828e7202c7b4917 ]

ipv4_pdp_add() is called in RCU read-side critical section.
So GFP_KERNEL should not be used in the function.
This patch make ipv4_pdp_add() to use GFP_ATOMIC instead of GFP_KERNEL.

Test commands:
gtp-link add gtp1 &
gtp-tunnel add gtp1 v1 100 200 1.1.1.1 2.2.2.2

Splat looks like:
[  130.618881] =============================
[  130.626382] WARNING: suspicious RCU usage
[  130.626994] 5.2.0-rc6+ #50 Not tainted
[  130.627622] -----------------------------
[  130.628223] ./include/linux/rcupdate.h:266 Illegal context switch in RCU read-side critical section!
[  130.629684]
[  130.629684] other info that might help us debug this:
[  130.629684]
[  130.631022]
[  130.631022] rcu_scheduler_active = 2, debug_locks = 1
[  130.632136] 4 locks held by gtp-tunnel/1025:
[  130.632925]  #0: 000000002b93c8b7 (cb_lock){++++}, at: genl_rcv+0x15/0x40
[  130.634159]  #1: 00000000f17bc999 (genl_mutex){+.+.}, at: genl_rcv_msg+0xfb/0x130
[  130.635487]  #2: 00000000c644ed8e (rtnl_mutex){+.+.}, at: gtp_genl_new_pdp+0x18c/0x1150 [gtp]
[  130.636936]  #3: 0000000007a1cde7 (rcu_read_lock){....}, at: gtp_genl_new_pdp+0x187/0x1150 [gtp]
[  130.638348]
[  130.638348] stack backtrace:
[  130.639062] CPU: 1 PID: 1025 Comm: gtp-tunnel Not tainted 5.2.0-rc6+ #50
[  130.641318] Call Trace:
[  130.641707]  dump_stack+0x7c/0xbb
[  130.642252]  ___might_sleep+0x2c0/0x3b0
[  130.642862]  kmem_cache_alloc_trace+0x1cd/0x2b0
[  130.643591]  gtp_genl_new_pdp+0x6c5/0x1150 [gtp]
[  130.644371]  genl_family_rcv_msg+0x63a/0x1030
[  130.645074]  ? mutex_lock_io_nested+0x1090/0x1090
[  130.645845]  ? genl_unregister_family+0x630/0x630
[  130.646592]  ? debug_show_all_locks+0x2d0/0x2d0
[  130.647293]  ? check_flags.part.40+0x440/0x440
[  130.648099]  genl_rcv_msg+0xa3/0x130
[ ... ]

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index cb206e5526c4..60df6e391ad2 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -952,7 +952,7 @@ static int ipv4_pdp_add(struct net_device *dev, struct genl_info *info)
 
 	}
 
-	pctx = kmalloc(sizeof(struct pdp_ctx), GFP_KERNEL);
+	pctx = kmalloc(sizeof(*pctx), GFP_ATOMIC);
 	if (pctx == NULL)
 		return -ENOMEM;
 
-- 
2.20.1

