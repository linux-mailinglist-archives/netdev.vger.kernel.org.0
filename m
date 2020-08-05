Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848AA23C426
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 05:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgHEDu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 23:50:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbgHEDuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 23:50:55 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B989B58AA064C2FC41CC;
        Wed,  5 Aug 2020 11:50:53 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 5 Aug 2020 11:50:49 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <robin@protonic.nl>, <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 2/4] can: j1939: cancel rxtimer on multipacket broadcast session complete
Date:   Wed, 5 Aug 2020 11:50:23 +0800
Message-ID: <1596599425-5534-3-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
References: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If j1939_xtp_rx_dat_one() receive last frame of multipacket broadcast
message, j1939_session_timers_cancel() should be called to cancel
rxtimer.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index e5188ac..dd6a120 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1788,6 +1788,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 	}
 
 	if (final) {
+		j1939_session_timers_cancel(session);
 		j1939_session_completed(session);
 	} else if (do_cts_eoma) {
 		j1939_tp_set_rxtimeout(session, 1250);
-- 
2.9.5

