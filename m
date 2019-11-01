Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B6CECA9B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfKAV7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:21 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:44510
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727387AbfKAV7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRVyqewR4FtejZ8ie2aVBuatM1fntKFx+zzCa0/GnchWKhVsGDBZD3uz/0II/jxJc9FcKJeHV8mtqDF3co1FK8xM0hqguIMh8iEWuCvw8o5/GU/H38RRheuuGCy35nKQCJKlomR2h2amBHCk6NcmVEI8flxgtO7iKAL9vQBOxhx+sXHW/b9aJyi3XbZbv4gZqTiezlHw//SWsi8ZUbU+jwSh47Sxla+7+0si3xyY2GRs2htLLSZBQH5bCCKtYg3jnFMI1bSSH/LbPkyh9moQWRyQ/8Eg0puEoBxfH2qyiWSiksnYPTfbMcMkQJl3dCB5wFvIlovV+cReVSspppQxBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Boou3kkiZCVXfauaTFe73VEVXOlMrYjl05Ta42vmxtY=;
 b=a1yt9GekwvwSh94HjSEdQNrBv/5RxgwYaqYMMFLrQGi+2gDpv1+FnKvo9VRR8AFBK43vgZeWcZaroWbUHx3EbSuzF+8zpuSMeNjViZLXEvnncCSKrl/v6heUg4leasdRaGberrTKFF/brgxeGoCSILWziK+gwyJcJXzuK3eZOF7JPOYps9tUhve7/aDEdgWHztfuJQrfHZyzktJ33VND/fXpdu5A2IZBWmjf61Yo2z91zW2EIcGIX/PoBYWCuNG5CmCH25A6ws0XUJv6ST40dSQEqjt6HPQaigOGYEE6O0OeE3BmtRFzvIu13PK4ekQre4cBGxYGRVR3WF38GoT8Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Boou3kkiZCVXfauaTFe73VEVXOlMrYjl05Ta42vmxtY=;
 b=KiJIL7ElCu7RZoeZYcixvc5tKwgu7PSmA90MQKIeEiDFGnYgybCQwr+sg3nKr6cyO6QC+nQekOI4vMq9axqXkk1XSUyoWfQ1MaqenkdeU/rUm3BYMBmilt2lfY3ru00RYiUnPt7s0nIikd0+bg5Ia7aJUqznY68QC/AN3tPbyCk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6173.eurprd05.prod.outlook.com (20.178.123.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 21:59:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [net-next 08/15] net/mlx5e: TX, Dump WQs wqe descriptors on CQE with
 error events
Thread-Topic: [net-next 08/15] net/mlx5e: TX, Dump WQs wqe descriptors on CQE
 with error events
Thread-Index: AQHVkP+Xh4bJPRBYLE+khELyFVMUiQ==
Date:   Fri, 1 Nov 2019 21:59:11 +0000
Message-ID: <20191101215833.23975-9-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bd92269b-271e-48c7-42d0-08d75f16b9e7
x-ms-traffictypediagnostic: VI1PR05MB6173:|VI1PR05MB6173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB617394ACD6FE6762D6089F84BE620@VI1PR05MB6173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(189003)(199004)(476003)(5660300002)(486006)(14454004)(107886003)(76176011)(7736002)(478600001)(66066001)(52116002)(2906002)(71190400001)(8676002)(71200400001)(6486002)(102836004)(81166006)(36756003)(81156014)(50226002)(6436002)(386003)(8936002)(6506007)(25786009)(66446008)(66476007)(6512007)(6116002)(3846002)(6916009)(26005)(99286004)(11346002)(66946007)(64756008)(86362001)(305945005)(54906003)(4326008)(316002)(1076003)(14444005)(186003)(446003)(2616005)(256004)(66556008)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aCoAuhWdb7q8euquWLjCbqq3U7X5qcd3jPrB7/ZR7/RzC8O/1XTKNPQIUpdV/igLMVJCz9Wa4i3nfZZ3fkLnW0473mXYT4zsiXIWyZ3TEEvXrmT19KiHnPaCWNJIugOUvTZa+KXwCVXk+YxwrYhIF/qBhOPgO3tEHMIcTmix58rdRfDbdSySTo7AdrB+fJ1Gt0R2VyRLEyra1C65IWmr437IuFolAMpiKfRZm51dPr0FsmHFSqzLCkyRiQUeHLsclr/kq0qLGISPnL329BasdhqlpFFYXFevUeSWaA8Hkg57L6MJaLI16qWTiA8YyCv7IBoEN68XaGk8o1BJn36LSUMvCAUcgOxqvZBdpnPmmt5HbfVnzX3aOEHlp7/0yfVx7mrvI4MAUBbdAXf2XgTgZ2kVTGLF/ge9cz58DCEwy+94U29JlLT9Tyek/JMx8uoa
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd92269b-271e-48c7-42d0-08d75f16b9e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:11.4031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sP0obwKVXvbrmXzSOkMf08OLlDiovmFyZHX8oVOSfrMIWRbiEp7xigNklP0l34bAvql2b5ETtW4sT/vEQfAGqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dump the Work Queue's TX WQE descriptor when a completion with
error is received.

Example:
[5.331832] mlx5_core 0000:00:04.0 enp0s4: Error cqe on cqn 0xa, ci 0x1, TXQ=
-SQ qpn 0xe, opcode 0xd, syndrome 0x2, vendor syndrome 0x0
[5.333127] 00000000: 55 65 02 75 31 fe c2 d2 6b 6c 62 1e f9 e1 d8 5c
[5.333837] 00000010: d3 b2 6c b8 89 e4 84 20 0b f4 3c e0 f3 75 41 ca
[5.334568] 00000020: 46 00 00 00 cd 70 a0 92 18 3a 01 de 00 00 00 00
[5.335313] 00000030: 7d bc 05 89 b2 e9 00 02 1e 00 00 0e 00 00 30 d2
[5.335972] WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0x0, len: 64
[5.336710] 00000000: 00 00 00 1e 00 00 0e 04 00 00 00 08 00 00 00 00
[5.337524] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 12 33 33
[5.338151] 00000020: 00 00 00 16 52 54 00 00 00 01 86 dd 60 00 00 00
[5.338740] 00000030: 00 00 00 48 00 00 00 00 00 00 00 00 66 ba 58 14

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c    |  6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/wq.c   | 18 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/wq.h   |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index d3a67a9b4eba..29730f52e315 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -458,8 +458,14 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bu=
dget)
 		if (unlikely(get_cqe_opcode(cqe) =3D=3D MLX5_CQE_REQ_ERR)) {
 			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
 					      &sq->state)) {
+				struct mlx5e_tx_wqe_info *wi;
+				u16 ci;
+
+				ci =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
+				wi =3D &sq->db.wqe_info[ci];
 				mlx5e_dump_error_cqe(sq,
 						     (struct mlx5_err_cqe *)cqe);
+				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
 				queue_work(cq->channel->priv->wq,
 					   &sq->recover_work);
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.c
index dd2315ce4441..dab2625e1e59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -96,6 +96,24 @@ int mlx5_wq_cyc_create(struct mlx5_core_dev *mdev, struc=
t mlx5_wq_param *param,
 	return err;
 }
=20
+void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
+{
+	size_t len;
+	void *wqe;
+
+	if (!net_ratelimit())
+		return;
+
+	nstrides =3D max_t(u8, nstrides, 1);
+
+	len =3D nstrides << wq->fbc.log_stride;
+	wqe =3D mlx5_wq_cyc_get_wqe(wq, ix);
+
+	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n"=
,
+		mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, fal=
se);
+}
+
 int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *qpc, struct mlx5_wq_qp *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.h
index 55791f71a778..27338c3c6136 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -79,6 +79,7 @@ struct mlx5_wq_ll {
 int mlx5_wq_cyc_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *p=
aram,
 		       void *wqc, struct mlx5_wq_cyc *wq,
 		       struct mlx5_wq_ctrl *wq_ctrl);
+void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides);
 u32 mlx5_wq_cyc_get_size(struct mlx5_wq_cyc *wq);
=20
 int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
--=20
2.21.0

