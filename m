Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E20BE93E5
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfJ2Xq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:28 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:62542
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfJ2XqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kt8pwgrrPLQDuiNwN3/sGqhvd22fHquhqq4rHFM+uy5MEgVJmPweUW4KiIWmX69FbUODGYNc3Qty4+9U9sZpNUQLm3XDIX7n1MN6KIaRTaZJId5svRSCSHvTCKmPrgFJWb87UXSHYHvHgMpYsAGltNBmTk7EYz0QcUjDAfPgUJQCKxWe8HAlUnaAaq0Q83XC31mx8/itWv7zN6q+oz55eEtaM8lvnZwiyaVWSZz5s6J3N9QWZkdWEhytrzsvYomv1mnN0T/RN5eZKGL11sBCdlwDHCx0fAozgRch40ZP/RxSynuQ4aXqUlD01p0MO8xAzkAcGXfbXIW2uWYT0UmleA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL7uvRVjx9fc/z1rnwg958leSFT5AHArzXyMZzSnyeo=;
 b=PXzV2w6G6iODJvxBW044X43fieTAPboF89bz4mhsgLfL0tRoDSgLMHpsvIESBD1IuCO/la/hz2rqWZZBbCKECo26rI8sOnQ9AUfyaGX22g5qSwADqSgU5XEV6SQx0aBrX4GN+Z8RuurNORbZmoeOaPFxw8CfhGL6mYqn5iOtEWwm7mJyWqq4UcYNoIvhUjfy9YL3amUDH/ifLBPcFDUaAHuHaiXAhn1ORXPJCNDha8Wnd5rrEnR+hhVs+kpwhIaErEK48K0a77lbx3RUSMqNEKrhN+0DtJec1rjJLB299Uo40LwqVwiqreGbsr7pFgYFNDtdrleBWWYluVNwrks+ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL7uvRVjx9fc/z1rnwg958leSFT5AHArzXyMZzSnyeo=;
 b=QI5tn3pRtJRMfIE9iO3Ip6tf6coGOeZj+WC5r8Mfe1hAoWmSq7qZzuYQsNW+RpdhTk2sjGSzdmionpZ8ejirnDc7hMF+dXLrAGeP4GcuuvY1RpJTJ9q4vqRwCeDohYIP+ojs+OOcLReTrOcinkf3EF9EMiKT96Rv7KRymHlBd+4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4320.eurprd05.prod.outlook.com (52.134.31.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Tue, 29 Oct 2019 23:46:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:46:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 07/11] net/mlx5: Fix NULL pointer dereference in extended
 destination
Thread-Topic: [net V2 07/11] net/mlx5: Fix NULL pointer dereference in
 extended destination
Thread-Index: AQHVjrMHmBn6Y/GFjEiLwgK1TI/r1g==
Date:   Tue, 29 Oct 2019 23:46:06 +0000
Message-ID: <20191029234526.3145-8-saeedm@mellanox.com>
References: <20191029234526.3145-1-saeedm@mellanox.com>
In-Reply-To: <20191029234526.3145-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30f73f7c-1f1a-40aa-2c5e-08d75cca2a29
x-ms-traffictypediagnostic: VI1PR05MB4320:|VI1PR05MB4320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4320FB1F700660D41F1D5862BE610@VI1PR05MB4320.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(199004)(189003)(86362001)(8936002)(7736002)(305945005)(6436002)(99286004)(81166006)(50226002)(52116002)(26005)(66066001)(8676002)(4326008)(81156014)(66476007)(66556008)(102836004)(54906003)(186003)(6506007)(478600001)(386003)(76176011)(6512007)(25786009)(66446008)(64756008)(66946007)(6116002)(3846002)(486006)(476003)(36756003)(446003)(6916009)(2616005)(11346002)(316002)(14454004)(107886003)(14444005)(256004)(71200400001)(71190400001)(6486002)(2906002)(1076003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4320;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WwnB4EaKz/Nu7v10HKPU22nh4LhpO95oG5+FacgQeB05s3pGhyBXfsWnG2da+2pP5tCtiKCc3I9OS6pnqliSN4di1NqSLAy3eIP+VAwCvGcBPAEwPdemxn+bu/0TEqHb2xvdeK0S9P3ogttsMcXaIqClIjew1WwQKjMN7k0TvhZQ6GYfWr3F6tifVLKYJAPIYsNWGXhsmWyhAxfiUjdUp4TFxA4/8MTkPguRHdrvax90oFDo6LOK1n1NUMZlHlVZRiE8rgbuUjJ7zxnLChLhfuBO3mm3NW38sxqYcbOat2dU2x5XZNTqO83XDDeHXCG/IQ+t1nrXo7Jj6F+5fBunUtAnZGfCB+bMsF7If+wzcuvibHAef5/m5PAI+N3x1HhgDoNcaa+5wP9RFYx1kBSWi/xGvfDmPzFRFSuI04Ul4Ej6lF6f54yb5RtOFgcxkDsS
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f73f7c-1f1a-40aa-2c5e-08d75cca2a29
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:46:06.1832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mau9dyQor2QaXqkTwJNNn3+IzisZbXfpruBnbE4vPIgDVRyDojeAk9U6MqmuCmDMBPr14yJpdrCq8qfLOpxZ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4320
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

The cited commit refactored the encap id into a struct pointed from the
destination.
Bug fix for the case there is no encap for one of the destinations.

Fixes: 2b688ea5efde ("net/mlx5: Add flow steering actions to fs_cmd shim la=
yer")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index 579c306caa7b..3c816e81f8d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -507,7 +507,8 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id,
 					 dst->dest_attr.vport.vhca_id);
-				if (extended_dest) {
+				if (extended_dest &&
+				    dst->dest_attr.vport.pkt_reformat) {
 					MLX5_SET(dest_format_struct, in_dests,
 						 packet_reformat,
 						 !!(dst->dest_attr.vport.flags &
--=20
2.21.0

