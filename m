Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5AD2C4AC0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbgKYWS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:18:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17925 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731225AbgKYWS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:18:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbed8320002>; Wed, 25 Nov 2020 14:18:26 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 22:18:21 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>
Subject: [PATCH V2 net] net/tls: Protect from calling tls_dev_del for TLS RX twice
Date:   Wed, 25 Nov 2020 14:18:10 -0800
Message-ID: <20201125221810.69870-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606342706; bh=BBb1S07Lu30cjc3dEpimNRaPJcuIpT3gZ9CRxoBYDIQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=TzQSwqjG4+5/DCePiaY4C06+pYuez0Wp41VVD0OtvPm3F83r8jTtJ/ZMfZAZuxc04
         L6z5WQ4Elp2Zliyb9KXrzjLIUlPpoLGuylLm5STfIS76zlHieRbkHBeDg+EVZcGvBN
         ZK7xb7SXD0qiNs8V2XXn2ht9TcNT2c22o4EZxTDWfKStB5BbZXWhZkiIy8kWm5QrBK
         CTowbd6R+jyGQxNT51MbXM+owZRLE921gyBJB5m65zLbh7WlU8VdbZaXD23vnoIkBW
         7H2j3wQtYhur7/EH+vVkIk2W6kLFhCV5//ua0qchz+sgI66siFoMd/Z69MI7t+97Mf
         wP/BWKF12C4oA==
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
v1->v2:=20
   - Add comment explaining TLS_RX_DEV_RELEASED
   - set the bit in else branch

 include/net/tls.h    | 6 ++++++
 net/tls/tls_device.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index cf1473099453..2bdd802212fe 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -199,6 +199,12 @@ enum tls_context_flags {
 	 * to be atomic.
 	 */
 	TLS_TX_SYNC_SCHED =3D 1,
+	/* tls_dev_del was called for the RX side, device state was released,
+	 * but tls_ctx->netdev might still be kept, because TX-side driver
+	 * resources might not be released yet. Used to prevent the second
+	 * tls_dev_del call in tls_device_down if it happens simultaneously.
+	 */
+	TLS_RX_DEV_CLOSED =3D 2,
 };
=20
 struct cipher_context {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 54d3e161d198..8c2125caeb8a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1262,6 +1262,8 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 	if (tls_ctx->tx_conf !=3D TLS_HW) {
 		dev_put(netdev);
 		tls_ctx->netdev =3D NULL;
+	} else {
+		set_bit(TLS_RX_DEV_CLOSED, &tls_ctx->flags);
 	}
 out:
 	up_read(&device_offload_lock);
@@ -1291,7 +1293,7 @@ static int tls_device_down(struct net_device *netdev)
 		if (ctx->tx_conf =3D=3D TLS_HW)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_TX);
-		if (ctx->rx_conf =3D=3D TLS_HW)
+		if (ctx->rx_conf =3D=3D TLS_HW && !test_bit(TLS_RX_DEV_CLOSED, &ctx->fla=
gs))
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
 		WRITE_ONCE(ctx->netdev, NULL);
--=20
2.26.2

