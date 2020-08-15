Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA4F2453AD
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgHOWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgHOVvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDF1C03B3DF
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 02:21:27 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1k6sNR-000762-4Y; Sat, 15 Aug 2020 11:21:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 2/4] can: j1939: cancel rxtimer on multipacket broadcast session complete
Date:   Sat, 15 Aug 2020 11:21:14 +0200
Message-Id: <20200815092116.424137-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200815092116.424137-1-mkl@pengutronix.de>
References: <20200815092116.424137-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

If j1939_xtp_rx_dat_one() receive last frame of multipacket broadcast message,
j1939_session_timers_cancel() should be called to cancel rxtimer.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1596599425-5534-3-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 868ecb2bfa45..2f3c3afd5071 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1824,6 +1824,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	}
 
 	if (final) {
+		j1939_session_timers_cancel(session);
 		j1939_session_completed(session);
 	} else if (do_cts_eoma) {
 		j1939_tp_set_rxtimeout(session, 1250);
-- 
2.28.0

