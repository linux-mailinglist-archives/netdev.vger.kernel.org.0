Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573A2687926
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjBBJlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbjBBJlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A55D83499
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNW68-0000eE-W6
        for netdev@vger.kernel.org; Thu, 02 Feb 2023 10:41:41 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E067F16D0D4
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:41:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B094216D0A7;
        Thu,  2 Feb 2023 09:41:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d86d5259;
        Thu, 2 Feb 2023 09:41:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        syzbot+9981a614060dcee6eeca@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/5] can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate
Date:   Thu,  2 Feb 2023 10:41:31 +0100
Message-Id: <20230202094135.2293939-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202094135.2293939-1-mkl@pengutronix.de>
References: <20230202094135.2293939-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

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
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20210906094200.95868-1-william.xuanziyang@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 5c722b55fe23..fce9b9ebf13f 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1092,10 +1092,6 @@ static bool j1939_session_deactivate(struct j1939_session *session)
 	bool active;
 
 	j1939_session_list_lock(priv);
-	/* This function should be called with a session ref-count of at
-	 * least 2.
-	 */
-	WARN_ON_ONCE(kref_read(&session->kref) < 2);
 	active = j1939_session_deactivate_locked(session);
 	j1939_session_list_unlock(priv);
 

base-commit: 917d5e04d4dd2bbbf36fc6976ba442e284ccc42d
-- 
2.39.1


