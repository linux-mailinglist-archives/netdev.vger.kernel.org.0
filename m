Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA412B9A6
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfL0SGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbfL0SCp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:02:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BFE1206CB;
        Fri, 27 Dec 2019 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469765;
        bh=XyFecWqBpKGcklNl7biKtm91cp0rUtKVz8cQNcFWqAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7VB9G4C1ide8gVKI4RnFomv5YOIpwr/qhbWe21raQkitmeMcmZPMNmaI0hu/iPZH
         v7m4o1bW4y3zerr6/inN36/NKWuOMKmKoZ7VUlZUzP31MX6OdEkRvZ1IDoawuXvceA
         z3JM0Mm/xw5EbchDuqNRCSM/q6lvgYrodObfoOls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mao Wenan <maowenan@huawei.com>,
        Xiao Jiangfeng <xiaojiangfeng@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/57] af_packet: set defaule value for tmo
Date:   Fri, 27 Dec 2019 13:01:42 -0500
Message-Id: <20191227180222.7076-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit b43d1f9f7067c6759b1051e8ecb84e82cef569fe ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1f86bf0d1649..4e1058159b08 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -593,7 +593,8 @@ static int prb_calc_retire_blk_tmo(struct packet_sock *po,
 			msec = 1;
 			div = ecmd.base.speed / 1000;
 		}
-	}
+	} else
+		return DEFAULT_PRB_RETIRE_TOV;
 
 	mbits = (blk_size_in_bytes * 8) / (1024 * 1024);
 
-- 
2.20.1

