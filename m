Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B731D12945D
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLWKq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:46:28 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:39904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725799AbfLWKq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 05:46:27 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 218214BBEA90FFFFFDB1;
        Mon, 23 Dec 2019 18:46:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Mon, 23 Dec 2019 18:46:16 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <willemb@google.com>,
        <maximmi@mellanox.com>, <maowenan@huawei.com>, <pabeni@redhat.com>,
        <yuehaibing@huawei.com>, <nhorman@tuxdriver.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2] af_packet: refactoring code for prb_calc_retire_blk_tmo
Date:   Mon, 23 Dec 2019 18:42:57 +0800
Message-ID: <20191223104257.132354-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CA+FuTScgWi905_NhGNsRzpwaQ+OPwahj6NtKgPjLZRjuqJvhXQ@mail.gmail.com>
References: <CA+FuTScgWi905_NhGNsRzpwaQ+OPwahj6NtKgPjLZRjuqJvhXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If __ethtool_get_link_ksettings() is failed and with
non-zero value, prb_calc_retire_blk_tmo() should return
DEFAULT_PRB_RETIRE_TOV firstly. 

This patch is to refactory code and make it more readable.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 v2: delete 'Fixes' tag, do not initialize some variable, 
 and delete two variable as Willem de Bruijn proposal.
 net/packet/af_packet.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 118cd66b7516..3bec515ccde3 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -520,7 +520,7 @@ static int prb_calc_retire_blk_tmo(struct packet_sock *po,
 				int blk_size_in_bytes)
 {
 	struct net_device *dev;
-	unsigned int mbits = 0, msec = 0, div = 0, tmo = 0;
+	unsigned int mbits, div;
 	struct ethtool_link_ksettings ecmd;
 	int err;
 
@@ -532,31 +532,25 @@ static int prb_calc_retire_blk_tmo(struct packet_sock *po,
 	}
 	err = __ethtool_get_link_ksettings(dev, &ecmd);
 	rtnl_unlock();
-	if (!err) {
-		/*
-		 * If the link speed is so slow you don't really
-		 * need to worry about perf anyways
-		 */
-		if (ecmd.base.speed < SPEED_1000 ||
-		    ecmd.base.speed == SPEED_UNKNOWN) {
-			return DEFAULT_PRB_RETIRE_TOV;
-		} else {
-			msec = 1;
-			div = ecmd.base.speed / 1000;
-		}
-	} else
+	if (err)
 		return DEFAULT_PRB_RETIRE_TOV;
 
+	/* If the link speed is so slow you don't really
+	 * need to worry about perf anyways
+	 */
+	if (ecmd.base.speed < SPEED_1000 ||
+	    ecmd.base.speed == SPEED_UNKNOWN)
+		return DEFAULT_PRB_RETIRE_TOV;
+
+	div = ecmd.base.speed / 1000;
 	mbits = (blk_size_in_bytes * 8) / (1024 * 1024);
 
 	if (div)
 		mbits /= div;
 
-	tmo = mbits * msec;
-
 	if (div)
-		return tmo+1;
-	return tmo;
+		return mbits + 1;
+	return mbits;
 }
 
 static void prb_init_ft_ops(struct tpacket_kbdq_core *p1,
-- 
2.20.1

