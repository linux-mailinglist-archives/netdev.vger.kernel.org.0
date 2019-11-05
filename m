Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53801F02D6
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390479AbfKEQcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:32:52 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49645 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390432AbfKEQcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:50 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1lA-0002Hp-9B; Tue, 05 Nov 2019 17:32:48 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Colin Ian King <colin.king@canonical.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 28/33] can: j1939: fix resource leak of skb on error return paths
Date:   Tue,  5 Nov 2019 17:32:10 +0100
Message-Id: <20191105163215.30194-29-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
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

From: Colin Ian King <colin.king@canonical.com>

Currently the error return paths do not free skb and this results in a
memory leak. Fix this by freeing them before the return.

Addresses-Coverity: ("Resource leak")
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/socket.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 37c1040bcb9c..5c6eabcb5df1 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -909,8 +909,10 @@ void j1939_sk_errqueue(struct j1939_session *session,
 	memset(serr, 0, sizeof(*serr));
 	switch (type) {
 	case J1939_ERRQUEUE_ACK:
-		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_ACK))
+		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_ACK)) {
+			kfree_skb(skb);
 			return;
+		}
 
 		serr->ee.ee_errno = ENOMSG;
 		serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
@@ -918,8 +920,10 @@ void j1939_sk_errqueue(struct j1939_session *session,
 		state = "ACK";
 		break;
 	case J1939_ERRQUEUE_SCHED:
-		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_SCHED))
+		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_SCHED)) {
+			kfree_skb(skb);
 			return;
+		}
 
 		serr->ee.ee_errno = ENOMSG;
 		serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
-- 
2.24.0.rc1

