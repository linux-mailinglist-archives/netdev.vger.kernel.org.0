Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F54DCF60
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443327AbfJRTib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:31 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443309AbfJRTia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOT0HTXpGMJCXusMCU9LjZBYgenM8SS04ZTafJM6Xp1eL01lneioCbtoMXqiTOJl6AgbuipSjclucpn4/0MKhb1wnk+k9UrtkNn2tMolOeuhnqCM8VstwzDM1XB0EdA1/DnvESDS6A5z1jlZzo0F4IguLgZwjK2Tp6A7inmQu25ELwBE2v+tj8DOaoQhbx6Cll8/HV8ZcDGgH3U7Ffq0jncw/Qpdz+RzMNBYfCt+Z66djt90Dv7flq6wbdW/m64apVbWn5CfKaavUk1EvApLJShqL3OtZLyk52ygYALe4gOHmX96ncIxS7tCxi9uRdXzShg+E0rW5mk43BsnTPEZhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuif14HNrz+gqviHUJAQgTXJwvMgZt9bL93tu8oSWtc=;
 b=J+uecvYeMQjNuYaLATjOnYgt/Vo8GCS+s2FkMCWMN4U6F4Hv/TaQ3bUISFNNPg3udqMeli5lKrIFO/2tl5KptGRbzqDI/gKFaeAsl2Sds4lShUmRaEq6RjKrLwdVmWWVFBPLu7bwnDnuff6H9VdTGJKr958umXRL1+WgrvmQgYKYzv4Q5dbGDVNlw44UmtRiGP3qYUZFQdFma6/vpri0QFafH1sS211WdHnonKQgtmpdv9FugBYpRC2vpKvM4U/iyfG69E1GQO2WMyg4pSHSV2Vq+sapTUDF++LMmHVEPFJIexlYI7LUKur+jmE2d/qAHQ5pZYwAJep1SLG4BVSf4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuif14HNrz+gqviHUJAQgTXJwvMgZt9bL93tu8oSWtc=;
 b=f7UXMmuQfGFiSva0897OICt5N9DkbwnVlDhmm2xuoDDRVDY0b4y9Q1KESJUrOJZKwP/qOUj/PvWKM97NkRquTYWKzNOsk2CuiOXjIhqRR7ti1dIZP8/ESvMQlNuueWBb01KneznfgzdTVGQ7Mu3kiaobU+bY+cNjDNTyxKvsQ+4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/15] net/mlx5e: kTLS, Fix missing SQ edge fill
Thread-Topic: [net 08/15] net/mlx5e: kTLS, Fix missing SQ edge fill
Thread-Index: AQHVheuWhbsnj34E5kuz9uPbGdGLcg==
Date:   Fri, 18 Oct 2019 19:38:16 +0000
Message-ID: <20191018193737.13959-9-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
In-Reply-To: <20191018193737.13959-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91f7be10-11a9-4ad7-ac8a-08d75402b8f6
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392B8D2C7371F7DF34751E8BE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8JFHCiJLtr8U6dy8xm+euwcr/G5u6fhVfSQoDf7PmKf68c5oD+uNW1hQn2s7YLDix0Xt8iWwgzeBL/pDwFk6oIbTCcXZhwAdzWBoMR0J8bYCtCcrd/253upZam90B15RW8JEiWiLD27+Vx3sqpXuLM8XXSWFSgu7H6cQS40MFvABtE+195DezBoxtyvnunrdM52NgyDAiUDujt1GuZB3EMVBvDKYUswlc4VQyLuhOSo8SO9Vy6BAn0IWFtWGDMLUv0w1T1ZtR24B34AeMQk6JghwBUZkU0gw6TArIfCg/CbQZmwkTDzIb0KPG9Bsxf84tRjODFk42cOzgaQi26+KOBumfeDF6YqIR6BoYxL90kf8rKYoQanmpE1Wfmjmk4F9vd0xEkk8aqjA+b11+Wks0qLaY06rOmufCVQddjQmfE/Kict9oCRjo03nXoceBhSz
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f7be10-11a9-4ad7-ac8a-08d75402b8f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:16.7944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +K57wuDz9ZylYEVTfqpDEFWG3ywI/VNpPM0vxiDdNrRdNcvIstPeNEYDD38ATxNVAsFEaIhakP1C4kJ+ahjoCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Before posting the context params WQEs, make sure there is enough
contiguous room for them, and fill frag edge if needed.

When posting only a nop, no need for room check, as it needs a single
WQEBB, meaning no contiguity issue.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 28 +++++++++++++------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 5f1d18fb644e..59e3f48470d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -168,6 +168,14 @@ mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
 			      bool skip_static_post, bool fence_first_post)
 {
 	bool progress_fence =3D skip_static_post || !fence_first_post;
+	struct mlx5_wq_cyc *wq =3D &sq->wq;
+	u16 contig_wqebbs_room, pi;
+
+	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	contig_wqebbs_room =3D mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+	if (unlikely(contig_wqebbs_room <
+		     MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS))
+		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
=20
 	if (!skip_static_post)
 		post_static_params(sq, priv_tx, fence_first_post);
@@ -355,10 +363,20 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_co=
ntext_tx *priv_tx,
=20
 	stats->tls_ooo++;
=20
-	num_wqebbs =3D MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS +
-		(info.nr_frags ? info.nr_frags * MLX5E_KTLS_DUMP_WQEBBS : 1);
+	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
+
+	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
+	 * actual data xmit.
+	 */
+	if (!info.nr_frags) {
+		tx_post_fence_nop(sq);
+		return skb;
+	}
+
+	num_wqebbs =3D info.nr_frags * MLX5E_KTLS_DUMP_WQEBBS;
 	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 	contig_wqebbs_room =3D mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+
 	if (unlikely(contig_wqebbs_room < num_wqebbs))
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
=20
@@ -368,12 +386,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_con=
text_tx *priv_tx,
 		if (tx_post_resync_dump(sq, &info.frags[i], priv_tx->tisn, !i))
 			goto err_out;
=20
-	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
-	 * actual data xmit.
-	 */
-	if (!info.nr_frags)
-		tx_post_fence_nop(sq);
-
 	return skb;
=20
 err_out:
--=20
2.21.0

