Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2283C2A4FEE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgKCTTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:19 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15829 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729639AbgKCTTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad2f0000>; Tue, 03 Nov 2020 11:19:11 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net 4/9] net/mlx5e: Fix refcount leak on kTLS RX resync
Date:   Tue, 3 Nov 2020 11:18:25 -0800
Message-ID: <20201103191830.60151-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103191830.60151-1-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604431151; bh=LHYaHR8xWCF3Eu51PXiD6bLWtfdqpKwQKvPmL5aXlms=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=YGNWoJASOrmotwp3t8MIIRddGq1K61oSBq5eDrLBUQMv9hqpFRKrbkL/zC7epURe2
         PLHyv/h/dvU08/uThmUIsWNy3Iv6L2xABZtNu8txywiJSAm4mvOWe8h1Md/776EXty
         HrLJS3z1UQrV64TznnKqgE5yiqZpLC10rdkRakvP7EPr2jG2STsAWjL2m2RKRLySLA
         +nVJks9XVm8gTiDllYLOKfsEKSrHoyYQ5IMiqQhxaSgwhORJNeibqKpIRQtExGShtw
         AZZGQd3/zlRKBLB3N+Tdxy1YVwZwxhcE+wkmvnDBeP8Zl3Iah5MUO2Xtg20Qf1MQQY
         cGGHeGp16LjNg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

On resync, the driver calls inet_lookup_established
(__inet6_lookup_established) that increases sk_refcnt of the socket. To
decrease it, the driver set skb->destructor to sock_edemux. However, it
didn't work well, because the TCP stack also sets this destructor for
early demux, and the refcount gets decreased only once, while increased
two times (in mlx5e and in the TCP stack). It leads to a socket leak, a
TLS context leak, which in the end leads to calling tls_dev_del twice:
on socket close and on driver unload, which in turn leads to a crash.

This commit fixes the refcount leak by calling sock_gen_put right away
after using the socket, thus fixing all the subsequent issues.

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c  | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 7f6221b8b1f7..6a1d82503ef8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -476,19 +476,22 @@ static void resync_update_sn(struct mlx5e_rq *rq, str=
uct sk_buff *skb)
=20
 	depth +=3D sizeof(struct tcphdr);
=20
-	if (unlikely(!sk || sk->sk_state =3D=3D TCP_TIME_WAIT))
+	if (unlikely(!sk))
 		return;
=20
-	if (unlikely(!resync_queue_get_psv(sk)))
-		return;
+	if (unlikely(sk->sk_state =3D=3D TCP_TIME_WAIT))
+		goto unref;
=20
-	skb->sk =3D sk;
-	skb->destructor =3D sock_edemux;
+	if (unlikely(!resync_queue_get_psv(sk)))
+		goto unref;
=20
 	seq =3D th->seq;
 	datalen =3D skb->len - depth;
 	tls_offload_rx_resync_async_request_start(sk, seq, datalen);
 	rq->stats->tls_resync_req_start++;
+
+unref:
+	sock_gen_put(sk);
 }
=20
 void mlx5e_ktls_rx_resync(struct net_device *netdev, struct sock *sk,
--=20
2.26.2

