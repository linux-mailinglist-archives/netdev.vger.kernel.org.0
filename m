Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F71A104533
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKTUgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:02 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfKTUgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZgEi89IbDRXp3fsUE4YBshAFqZu9TUDtrQzJDHg/deMUiu9k2HLwsEgKU5HKeKCYOKXtYL2xiQ8RSZy2VX5v83Geeqd23vhBNa4RADsbihEtcISoRISbZMmH2FLkHtm7h2x0zDcnZfH+QGStddpEEcO7D0+sP25Jmn3slrdRqAqi+EDgyT9zzCrRG7LeTXnwh256CdNFX8h0wMN5L1G6H6/wX3U0P4htfnNL0zvA+mlzf66wYJslhYhmdN6biDtEE5HvxRO628eNmbebF+Ks33zTMgt24oIhostQkysgqaEZXCoPQNfZM0wvC5RwTgJvuSjbIWZIr/f9ulDcXcBQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wel+9dMemYweVPnKBMvr4Q+MHMo8P8xzo5DsGdat8ws=;
 b=YUUyN8Xk+WUBmZ6bbqEVjb+iRB319w4LRSISCmzKTXFliCJgh3pGZdmKupS0w+e+lQiLQa9L++Gt+9gkkdNPNBoLZt9rbrHD2xXE2zvuA1MavfZWcJaMcKEslfo6ea/GTvq33V6jeNbgAWQv4QUtB3Chrmj8HUusvbE4fBA+gwGQtumjwIn2YiI78poB0XHFt9ee18J3/1sBvYciw/fFgCbBxq6jeWNIdzfFvKpQEJBRP10SKE4lpDfXxTbA7KBQ7P0TGlLKGHm8zmPiUA/jN1aeYN5V/+OR555KVnuBWvm3NS4Y+nd/kN/gVOUIghyZhFpIvyLrojZ+uQNaC8XyXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wel+9dMemYweVPnKBMvr4Q+MHMo8P8xzo5DsGdat8ws=;
 b=cRGjZeHp5nLN/muxe8Z0soRg1S8V0BjEex9KrSx5X3mjhAb8YB0cPOjS4xavQzyn8wqwdf3nFIpGOy0lNOnQVCTvG9G/u+SGiykAikv1Qz4jLuqgPoRJSQYg/6bdJ6dcHBfYo21aP8072Fw8ydJNYUqcI1eYYAvMoR+ESFOAtEo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/12] net/mlx5: DR, Skip rehash for tables with byte mask zero
Thread-Topic: [net 05/12] net/mlx5: DR, Skip rehash for tables with byte mask
 zero
Thread-Index: AQHVn+IZqHRda7Reu02ZgL1XnS3XQw==
Date:   Wed, 20 Nov 2019 20:35:51 +0000
Message-ID: <20191120203519.24094-6-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bb33aae7-57b5-4d96-260e-08d76df93b8f
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61102210B6F3F235CE7C68B9BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c/FXTAf/qQA6njMJ65Trql723jZSBamTwgZdX5IAgT9EzFHoCEzFy1/nOOOXgR3cBKVyrKHYawac9x5axW8hAjyN6uLJ8cXGQTlbUW1yPHqbeuB1dYhBileePSujK7XVGgGNV8K5pEO9E+NE9Fb3MP+ZP+om+R/xWL35yZQ+Bgww4lQKLBrh9t0TyMYuZMHarCJtxZk5ZWg2SwefMJ2K3mgFXEet36+2ltP0Jifwn92SAkrtPBPR+AJ9Qrln6U4wIrN4bmtWg/ofRfadjXQqjmoH7ZoV13XtK6gyosIyiaEA9zCLgNtDa70yFPmJ8KCKNReEY15RIzBgG/4pVtUhOohds79siQ4eQG0amhODIvheP6Bj9o8mULkpgYSJ3I6Y5HkFj+B/6GMXKUAyyLhrbMujbEYeI+1ssOPjgr1+LJD0Wym1w7AARaLBTKIZUjDS
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb33aae7-57b5-4d96-260e-08d76df93b8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:51.3503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dPgzJFvhvbxHqA7POQ2G+dxbuoDY2rtjTVgXhzxIzp5CmTlv+cpvAcd42ZF8e2feoZCPW4Dp6fWZDiWGX6M4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

The byte mask fields affect on the hash index distribution,
when the byte mask is zero, the hash calculation will always
be equal to the same index.

To avoid unneeded rehash of hash tables mark the table to skip
rehash.

This is needed by the next patch which will limit table rehash
to reduce memory consumption.

Fixes: 41d07074154c ("net/mlx5: DR, Expose steering rule functionality")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 4efe1b0be4a8..80680765d59c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -671,7 +671,7 @@ static void dr_ste_set_ctrl(struct mlx5dr_ste_htbl *htb=
l)
=20
 	htbl->ctrl.may_grow =3D true;
=20
-	if (htbl->chunk_size =3D=3D DR_CHUNK_SIZE_MAX - 1)
+	if (htbl->chunk_size =3D=3D DR_CHUNK_SIZE_MAX - 1 || !htbl->byte_mask)
 		htbl->ctrl.may_grow =3D false;
=20
 	/* Threshold is 50%, one is added to table of size 1 */
--=20
2.21.0

