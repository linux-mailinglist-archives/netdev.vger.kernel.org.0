Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72260B6123
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbfIRKMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 06:12:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44519 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728672AbfIRKMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 06:12:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iAWwG-0002Zr-Ek; Wed, 18 Sep 2019 10:11:56 +0000
From:   Colin King <colin.king@canonical.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] can: fix resource leak of skb on error return paths
Date:   Wed, 18 Sep 2019 11:11:56 +0100
Message-Id: <20190918101156.24370-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the error return paths do not free skb and this results
in a memory leak. Fix this by freeing them before the return.

Addresses-Coverity: ("Resource leak")
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
2.20.1

