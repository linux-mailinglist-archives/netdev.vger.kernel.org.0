Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7532123C424
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 05:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHEDvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 23:51:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9334 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726971AbgHEDvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 23:51:04 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C4FF1D4A86073B67D193;
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
Subject: [PATCH net 3/4] can: j1939: abort multipacket broadcast session when timeout occurs
Date:   Wed, 5 Aug 2020 11:50:24 +0800
Message-ID: <1596599425-5534-4-git-send-email-zhangchangzhong@huawei.com>
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

If timeout occurs, j1939_tp_rxtimer() first calls hrtimer_start() to
restart rxtimer, and then calls __j1939_session_cancel() to set
session->state = J1939_SESSION_WAITING_ABORT. At next timeout
expiration, because of the J1939_SESSION_WAITING_ABORT session state
j1939_tp_rxtimer() will call j1939_session_deactivate_activate_next()
to deactivate current session, and rxtimer won't be set.

But for multipacket broadcast session, __j1939_session_cancel() don't
set session->state = J1939_SESSION_WAITING_ABORT, thus current session
won't be deactivate and hrtimer_start() is called to start new
rxtimer again and again.

So fix it by moving session->state = J1939_SESSION_WAITING_ABORT out of
if (!j1939_cb_is_broadcast(&session->skcb)) statement.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index dd6a120..5757f9f 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1055,9 +1055,9 @@ static void __j1939_session_cancel(struct j1939_session *session,
 	lockdep_assert_held(&session->priv->active_session_list_lock);
 
 	session->err = j1939_xtp_abort_to_errno(priv, err);
+	session->state = J1939_SESSION_WAITING_ABORT;
 	/* do not send aborts on incoming broadcasts */
 	if (!j1939_cb_is_broadcast(&session->skcb)) {
-		session->state = J1939_SESSION_WAITING_ABORT;
 		j1939_xtp_tx_abort(priv, &session->skcb,
 				   !session->transmission,
 				   err, session->skcb.addr.pgn);
-- 
2.9.5

