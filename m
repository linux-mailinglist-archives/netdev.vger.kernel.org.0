Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C68C116E01
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfLINeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:34:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:43802 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727438AbfLINeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 08:34:14 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CEB9515513E7DF9DA6CA;
        Mon,  9 Dec 2019 21:34:10 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Mon, 9 Dec 2019 21:34:02 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <loke.chetan@gmail.com>,
        <willemb@google.com>, <edumazet@google.com>,
        <maximmi@mellanox.com>, <nhorman@tuxdriver.com>,
        <pabeni@redhat.com>, <maowenan@huawei.com>,
        <yuehaibing@huawei.com>, <tglx@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Xiao Jiangfeng <xiaojiangfeng@huawei.com>
Subject: [PATCH net] af_packet: set defaule value for tmo
Date:   Mon, 9 Dec 2019 21:31:25 +0800
Message-ID: <20191209133125.59093-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is softlockup when using TPACKET_V3:
...
NMI watchdog: BUG: soft lockup - CPU#2 stuck for 60010ms!
(__irq_svc) from [<c0558a0c>] (_raw_spin_unlock_irqrestore+0x44/0x54)
(_raw_spin_unlock_irqrestore) from [<c027b7e8>] (mod_timer+0x210/0x25c)
(mod_timer) from [<c0549c30>]
(prb_retire_rx_blk_timer_expired+0x68/0x11c)
(prb_retire_rx_blk_timer_expired) from [<c027a7ac>]
(call_timer_fn+0x90/0x17c)
(call_timer_fn) from [<c027ab6c>] (run_timer_softirq+0x2d4/0x2fc)
(run_timer_softirq) from [<c021eaf4>] (__do_softirq+0x218/0x318)
(__do_softirq) from [<c021eea0>] (irq_exit+0x88/0xac)
(irq_exit) from [<c0240130>] (msa_irq_exit+0x11c/0x1d4)
(msa_irq_exit) from [<c0209cf0>] (handle_IPI+0x650/0x7f4)
(handle_IPI) from [<c02015bc>] (gic_handle_irq+0x108/0x118)
(gic_handle_irq) from [<c0558ee4>] (__irq_usr+0x44/0x5c)
...

If __ethtool_get_link_ksettings() is failed in
prb_calc_retire_blk_tmo(), msec and tmo will be zero, so tov_in_jiffies
is zero and the timer expire for retire_blk_timer is turn to
mod_timer(&pkc->retire_blk_timer, jiffies + 0),
which will trigger cpu usage of softirq is 100%.

Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
Tested-by: Xiao Jiangfeng <xiaojiangfeng@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/packet/af_packet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 53c1d41fb1c9..118cd66b7516 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -544,7 +544,8 @@ static int prb_calc_retire_blk_tmo(struct packet_sock *po,
 			msec = 1;
 			div = ecmd.base.speed / 1000;
 		}
-	}
+	} else
+		return DEFAULT_PRB_RETIRE_TOV;
 
 	mbits = (blk_size_in_bytes * 8) / (1024 * 1024);
 
-- 
2.20.1

