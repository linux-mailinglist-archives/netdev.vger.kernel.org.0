Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E6216F4E4
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730288AbgBZBN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:59 -0500
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:6029
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729908AbgBZBNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDDZyMLrdLxQl7vp8j3RQ8zw/p1sq3ptWd4gXF6Po6tZXwPDFmQL9bUkgT9lgSHBXqUDfCXzq+ZOTdTXZWmkoiohR81j7NU3N/Jm1N9L/FMWZMxvuWXJeidmF42/mpsWKTjyNU1XGp/2JlOyNcQsWwjdFPd1xzb8nCCZhMY1IN7tLGzampTVlibPuifBdFZT0sKv12C/jAbKTEplm7cY48tRTrzn+ujQlfKITqwzxaPx6EH6/W0R7O/jGKDASPcxWnPDZeQhlAmHHnlPgY5uoNIkhWnPDBcZSCUh5n5azVnTQyXpQE0gTEMhaBaxKbyi43lfs++Op0O+LJgVrL3vBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mboq3pTVLiyk5v141DFnaUmom6jrvIAefBDLElrqoU=;
 b=I9UmFSO1jL+Y4bWgIHNy6JzwES9MlRLrJ53NCaErKo6kBTa82kcZztXrNFJesY05gqpXtYlCEuPc3ge8gEOf3lXZ3m463gUEvdxDeAu09TkL3Ca+sVwrb7XXIETD3NLv640wZwzx8Nm0cLlEzIZaJNs6O5aDoqkqLNfy0PoDLCH+MZJ0K7OQvdW1+yCqsYWJ17qwfTWcOSfCuJdlZaj6BECcJjc0OwrhJyyxW0s0F0WEeN0N6DaMCOOpCn2GTWqH2Qszk47UxCe478cKUVexE2OzCqaqMU2EhdA50mNmn0Um4fOXABIONUGzauG5khprOYDrRxVbuljJ6IMQGJZlgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mboq3pTVLiyk5v141DFnaUmom6jrvIAefBDLElrqoU=;
 b=QGtg0pUyehK2W3y/kPaz2boNgZsfSKlFZQq6VmxpofHn0xFsslEBP0pT3iiC3RjJ2pdJ/Il+klQKPMg3HyFAAjVgn+Sb7YzdVgX5r5KHMnu3oo9jaFHrF87NZV1nigpYyZi6VjrS8gggUENoXorpf2yn2QfTCaPKYluNYgwJmf4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/16] net/mlx5e: RX, Use indirect calls wrapper for posting descriptors
Date:   Tue, 25 Feb 2020 17:12:41 -0800
Message-Id: <20200226011246.70129-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:33 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d9aff62-b3d9-4e1f-3fc5-08d7ba591a73
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7038EBB6F80FE25340FADD03BEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(6512007)(2906002)(2616005)(86362001)(956004)(26005)(52116002)(498600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QqwnCdwMds6akLrBX1ucznBFnXYUHLpcu1v5a3GuAyZRCGayF1mR65K9VeNiLoKrrXDAlzVBnmA2XJk4qKcITo5oU6SR38/SxKMmkJ/TfJI6BKXliIOKX/n+wPLeuAz3gvyWzbKyPxJADkVTu6JBcyJlQnrhTe9xxUfPpgW7dyAI4DXoLJhg2m3Nd1EVWHz3uQ61nyaI/swI8iLbtaIQWft5+jSELuRNdJCxmjHo4/hRFfB3NfwHzlj9C/0LqY8i587zpMs2787rjr+2sGhyya0drIYsS8kV4buaVNRRtHSQear9N5PJscfJXnF5HEPiUYx32IsoER5Jx5Bz8TzjO0lP12pEAjI0jG3q+3KdpNyOpiXYXnir+ynB6rccIgSTIU9ZbxSaIGrGk14NRqAfKXZldeYjp/te1A9pkJ/VRKWd6va3MswW5lmdQTXHue9AeHvQ79IQxkV9x9DN1+xN+IoAbKjC12eYoSbmIStTHVUYCW9QKZXCbvM7tYMNMkhKtChR6myO5BviymLf5uxhgVTIzQauRK4ZoRErp658/xk=
X-MS-Exchange-AntiSpam-MessageData: i8JJYs2dVS+oh36xkZ1AP0rD/fN0HjrU98ckzRFxGdRvcOex+dQJpoyQLykKQBsmPNdMwgwsgPcJVrvCEW9k3ZC6Wt1Mr/ioVwdLBBesmv1METl+l/tFOGFJCSDmjaDtyQQSqso/4PEtvOWo1c8JnQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9aff62-b3d9-4e1f-3fc5-08d7ba591a73
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:35.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyDJD6AxKLQGkn8g4XSeZ6JBBFza4h3SajgdvNhIWbZ456g92zwDU5jgrc0DslZH5TDarBuXrajmSBfxtwaU+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

We can avoid an indirect call per NAPI cycle wrapping the RX descriptors
posting call with the appropriate helper.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 257a7c9f7a14..267f4535c36b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/indirect_call_wrapper.h>
 #include "en.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
@@ -99,7 +100,10 @@ static bool mlx5e_napi_xsk_post(struct mlx5e_xdpsq *xsksq, struct mlx5e_rq *xskr
 	busy_xsk |= mlx5e_xsk_tx(xsksq, MLX5E_TX_XSK_POLL_BUDGET);
 	mlx5e_xsk_update_tx_wakeup(xsksq);
 
-	xsk_rx_alloc_err = xskrq->post_wqes(xskrq);
+	xsk_rx_alloc_err = INDIRECT_CALL_2(xskrq->post_wqes,
+					   mlx5e_post_rx_mpwqes,
+					   mlx5e_post_rx_wqes,
+					   xskrq);
 	busy_xsk |= mlx5e_xsk_update_rx_wakeup(xskrq, xsk_rx_alloc_err);
 
 	return busy_xsk;
@@ -142,7 +146,10 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 
 	mlx5e_poll_ico_cq(&c->icosq.cq);
 
-	busy |= rq->post_wqes(rq);
+	busy |= INDIRECT_CALL_2(rq->post_wqes,
+				mlx5e_post_rx_mpwqes,
+				mlx5e_post_rx_wqes,
+				rq);
 	if (xsk_open) {
 		mlx5e_poll_ico_cq(&c->xskicosq.cq);
 		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
-- 
2.24.1

