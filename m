Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C1142D5CE
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhJNJSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:18:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:28939 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhJNJSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 05:18:12 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HVNtx19Kdzbn9S;
        Thu, 14 Oct 2021 17:11:37 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 17:16:05 +0800
Received: from compute.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 17:16:04 +0800
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
Subject: [PATCH net] can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes
Date:   Thu, 14 Oct 2021 17:26:40 +0800
Message-ID: <1634203601-3460-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The receiver should abort TP if 'total message size' in TP.CM_RTS and
TP.CM_BAM is less than 9 or greater than 1785 [1], but currently the
j1939 stack only checks the upper bound and the receiver will accept the
following broadcast message:
  vcan1  18ECFF00   [8]  20 08 00 02 FF 00 23 01
  vcan1  18EBFF00   [8]  01 00 00 00 00 00 00 00
  vcan1  18EBFF00   [8]  02 00 FF FF FF FF FF FF

This patch adds check for the lower bound and abort illegal TP.

[1] SAE-J1939-82 A.3.4 Row 2 and A.3.6 Row 6.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/j1939-priv.h | 1 +
 net/can/j1939/transport.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/can/j1939/j1939-priv.h b/net/can/j1939/j1939-priv.h
index f6df208..16af1a7 100644
--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -330,6 +330,7 @@ int j1939_session_activate(struct j1939_session *session);
 void j1939_tp_schedule_txtimer(struct j1939_session *session, int msec);
 void j1939_session_timers_cancel(struct j1939_session *session);
 
+#define J1939_MIN_TP_PACKET_SIZE 9
 #define J1939_MAX_TP_PACKET_SIZE (7 * 0xff)
 #define J1939_MAX_ETP_PACKET_SIZE (7 * 0x00ffffff)
 
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index bb5c4b8..b685d31 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1609,6 +1609,8 @@ j1939_session *j1939_xtp_rx_rts_session_new(struct j1939_priv *priv,
 			abort = J1939_XTP_ABORT_FAULT;
 		else if (len > priv->tp_max_packet_size)
 			abort = J1939_XTP_ABORT_RESOURCE;
+		else if (len < J1939_MIN_TP_PACKET_SIZE)
+			abort = J1939_XTP_ABORT_FAULT;
 	}
 
 	if (abort != J1939_XTP_NO_ABORT) {
-- 
2.9.5

