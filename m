Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBBC40190F
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbhIFJoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:44:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19009 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbhIFJn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:43:59 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H33Hy1MlVzbmD1;
        Mon,  6 Sep 2021 17:38:54 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 6 Sep 2021 17:42:52 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <robin@protonic.nl>
CC:     <linux@rempel-privat.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate
Date:   Mon, 6 Sep 2021 17:42:00 +0800
Message-ID: <20210906094200.95868-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conclusion "j1939_session_deactivate() should be called with a
session ref-count of at least 2" is incorrect. In some concurrent
scenarios, j1939_session_deactivate can be called with the session
ref-count less than 2. But there is not any problem because it
will check the session active state before session putting in
j1939_session_deactivate_locked().

Here is the concurrent scenario of the problem reported by syzbot
and my reproduction log.

        cpu0                            cpu1
                                j1939_xtp_rx_eoma
j1939_xtp_rx_abort_one
                                j1939_session_get_by_addr [kref == 2]
j1939_session_get_by_addr [kref == 3]
j1939_session_deactivate [kref == 2]
j1939_session_put [kref == 1]
				j1939_session_completed
				j1939_session_deactivate
				WARN_ON_ONCE(kref < 2)

=====================================================
WARNING: CPU: 1 PID: 21 at net/can/j1939/transport.c:1088 j1939_session_deactivate+0x5f/0x70
CPU: 1 PID: 21 Comm: ksoftirqd/1 Not tainted 5.14.0-rc7+ #32
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
RIP: 0010:j1939_session_deactivate+0x5f/0x70
Call Trace:
 j1939_session_deactivate_activate_next+0x11/0x28
 j1939_xtp_rx_eoma+0x12a/0x180
 j1939_tp_recv+0x4a2/0x510
 j1939_can_recv+0x226/0x380
 can_rcv_filter+0xf8/0x220
 can_receive+0x102/0x220
 ? process_backlog+0xf0/0x2c0
 can_rcv+0x53/0xf0
 __netif_receive_skb_one_core+0x67/0x90
 ? process_backlog+0x97/0x2c0
 __netif_receive_skb+0x22/0x80

Fixes: 0c71437dd50d ("can: j1939: j1939_session_deactivate(): clarify lifetime of session object")
Reported-by: syzbot+9981a614060dcee6eeca@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/j1939/transport.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index bdc95bd7a851..0f8309314075 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1079,10 +1079,6 @@ static bool j1939_session_deactivate(struct j1939_session *session)
 	bool active;
 
 	j1939_session_list_lock(priv);
-	/* This function should be called with a session ref-count of at
-	 * least 2.
-	 */
-	WARN_ON_ONCE(kref_read(&session->kref) < 2);
 	active = j1939_session_deactivate_locked(session);
 	j1939_session_list_unlock(priv);
 
-- 
2.25.1

