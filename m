Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12E743E3AD
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhJ1O3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:29:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13986 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhJ1O3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:29:42 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hg7BF4GHhzZcW8;
        Thu, 28 Oct 2021 22:25:09 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 22:27:06 +0800
Received: from compute.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 22:27:06 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2 1/3] can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport
Date:   Thu, 28 Oct 2021 22:38:25 +0800
Message-ID: <1635431907-15617-2-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
References: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prevents BAM transport from being closed by receiving abort
message, as specified in SAE-J1939-82 2015 (A.3.3 Row 4).

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 6c0a0eb..05eb3d0 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2085,6 +2085,12 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		break;
 
 	case J1939_ETP_CMD_ABORT: /* && J1939_TP_CMD_ABORT */
+		if (j1939_cb_is_broadcast(skcb)) {
+			netdev_err_once(priv->ndev, "%s: abort to broadcast (%02x), ignoring!\n",
+					__func__, skcb->addr.sa);
+			return;
+		}
+
 		if (j1939_tp_im_transmitter(skcb))
 			j1939_xtp_rx_abort(priv, skb, true);
 
-- 
2.9.5

