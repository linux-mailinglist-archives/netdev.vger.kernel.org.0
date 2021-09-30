Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB7941D1DF
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347939AbhI3Db3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:31:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13858 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347737AbhI3Db2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:31:28 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKdsZ11Pdz8ysr;
        Thu, 30 Sep 2021 11:25:06 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:29:35 +0800
Received: from compute.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:29:35 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Kurt Van Dijck" <dev.kurt@vandijck-laurijssen.be>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
Date:   Thu, 30 Sep 2021 11:33:20 +0800
Message-ID: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
cancel session when receive unexpected TP.DT message.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index bb5c4b8..eedaeaf 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
 static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 				 struct sk_buff *skb)
 {
+	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
 	struct j1939_priv *priv = session->priv;
 	struct j1939_sk_buff_cb *skcb, *se_skcb;
 	struct sk_buff *se_skb = NULL;
@@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 
 	skcb = j1939_skb_to_cb(skb);
 	dat = skb->data;
-	if (skb->len <= 1)
+	if (skb->len != 8) {
 		/* makes no sense */
+		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
 		goto out_session_cancel;
+	}
 
 	switch (session->last_cmd) {
 	case 0xff:
@@ -1904,7 +1907,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
  out_session_cancel:
 	kfree_skb(se_skb);
 	j1939_session_timers_cancel(session);
-	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
+	j1939_session_cancel(session, abort);
 	j1939_session_put(session);
 }
 
-- 
2.9.5

