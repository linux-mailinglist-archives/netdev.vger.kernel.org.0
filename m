Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AC12B703E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgKQUiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:38:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9043 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgKQUiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:38:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb434aa0001>; Tue, 17 Nov 2020 12:38:02 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:38:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net 1/2] net/tls: Protect from calling tls_dev_del for TLS RX twice
Date:   Tue, 17 Nov 2020 12:33:54 -0800
Message-ID: <20201117203355.389661-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605645482; bh=4Ch/Wg6AoY2f8JHpAMaRUFIVmUSPWpsqb0k6D9cNgew=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=JSFCpBdVtGoNTYaU8wghki7EGYApagxfCa5KEINED+hYEHU9BeIvqpWNRctdYZPpy
         lAPG2bS8+dai6h3PKEHBuoCYmhMIo5hcrn4akGBpVMZJg1/brJIKVQWjQ0H/Mt37XN
         QTtRyUGHvvrOLNpJKQPpagu7LRV+5AWsLBQREccgjNhMHu0JN7yF7/hY8ne8afNcv+
         8LacHPE26NwtDYhlnO7W5kwNk8Grlq+F81X2kWsiIrcbEtSsbbNJwz2m40/0Oc9pla
         lv+oO51MQV2caKdhBbwWDPHz4MKgXRH9q9rlKq+g/XLnHBQK4JD3eXeyimybaFLLKp
         emC/t+R5uoYMA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

tls_device_offload_cleanup_rx doesn't clear tls_ctx->netdev after
calling tls_dev_del if TLX TX offload is also enabled. Clearing
tls_ctx->netdev gets postponed until tls_device_gc_task. It leaves a
time frame when tls_device_down may get called and call tls_dev_del for
RX one extra time, confusing the driver, which may lead to a crash.

This patch corrects this racy behavior by adding a flag to prevent
tls_device_down from calling tls_dev_del the second time.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
For -stable: 5.3

 include/net/tls.h    | 1 +
 net/tls/tls_device.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index baf1e99d8193..a0deddfde412 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -199,6 +199,7 @@ enum tls_context_flags {
 	 * to be atomic.
 	 */
 	TLS_TX_SYNC_SCHED =3D 1,
+	TLS_RX_DEV_RELEASED =3D 2,
 };
=20
 struct cipher_context {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cec86229a6a0..b2261caac6be 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1241,6 +1241,7 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
=20
 	netdev->tlsdev_ops->tls_dev_del(netdev, tls_ctx,
 					TLS_OFFLOAD_CTX_DIR_RX);
+	set_bit(TLS_RX_DEV_RELEASED, &tls_ctx->flags);
=20
 	if (tls_ctx->tx_conf !=3D TLS_HW) {
 		dev_put(netdev);
@@ -1274,7 +1275,7 @@ static int tls_device_down(struct net_device *netdev)
 		if (ctx->tx_conf =3D=3D TLS_HW)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_TX);
-		if (ctx->rx_conf =3D=3D TLS_HW)
+		if (ctx->rx_conf =3D=3D TLS_HW && !test_bit(TLS_RX_DEV_RELEASED, &ctx->f=
lags))
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
 		WRITE_ONCE(ctx->netdev, NULL);
--=20
2.26.2

