Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B14E3C1C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437040AbfJXTjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:39:00 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:46757
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405543AbfJXTi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vu9ATBKSsQrBR3uP1Le+MhfGIchukWe40VCmXu0aLoFdHyffNw8NY09dlFtwPyvWjth8sytGLitSIpNqVuka2KBlBgAWylZOweTI0SVSH+qtBUsgV0PX5BzI2YJSApmI848fIFgnAZkQ0MVxu60uW7jSecfK/iUPMuMz0Hp6zRYslqlIEY8fx9Pa6UionQEeG+Br6IJIQZSNxtNqcadNF5ZjOt4W9u2qLMwakGZyadDJjigKMQMxRpmREfVkZmiLMyCXyXljzLm/AW471ZszRODVoBdVZ+qz2kuYIda30e6dLrLPjPPBCr9xQeLWi53aUINFJ2O1NkXq0/5U5ZYohg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL7uvRVjx9fc/z1rnwg958leSFT5AHArzXyMZzSnyeo=;
 b=cdnLiduY4ORDWPef9Xuu9YqHJGWl6OyyZ4eTTlLx/TvYuWSvTFH3oFwVBaot9fbHlSRUBMajkn5uR+8HVPNyl6fO8t1vo+fJW3ziuaGswCIyKKcmIvaJcB2mxVtybAfMImYHmxiL7lzz9w0J+fpBTX+5N22k/xD4y7LzwkBofu+NZecX2Au4fOSetFwD8jXPWW/ElV0YFDrSZjhK48wyPzB5UoGY0jHLYJx4Ahr5rw/PwkG+IO5K6icblP958G221pjwLY71px+8Nuv/fPJfcFdbdKWr5Fk5SQU+MOZMea5J35UdF0rxS0hWr3+WsRDGVpzragzpC1hrzIZWYZKMEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL7uvRVjx9fc/z1rnwg958leSFT5AHArzXyMZzSnyeo=;
 b=j50gLIG/5xTt0vALQHmkZh2zuW6iU8xHul0p8AGyRd2lwefaX2ik9dO0Uh9HX4LYU7w9Tvyz01A/+Xt4bUcQugeXAiEHzBRjpVWvMCp7NXjyIqrLrTbELTVw55felGwH7YMgp/nRjcxVQjSMh/lc6cTbsK4pPihLv9Jq486P9OQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/11] net/mlx5: Fix NULL pointer dereference in extended
 destination
Thread-Topic: [net 07/11] net/mlx5: Fix NULL pointer dereference in extended
 destination
Thread-Index: AQHViqKrazNp0oj9B0arCCpnnO0Cvg==
Date:   Thu, 24 Oct 2019 19:38:54 +0000
Message-ID: <20191024193819.10389-8-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea425aee-4b20-4e94-8654-08d758b9ce14
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4623074AE11CEA4CF07581E6BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nTMyTKJmh3UIPib4oPUd9Olnj1elKKapY/gmraM7cxIjoTRpXk13Z0uKWGNb1pJFFIWSElj89pG5fYjZdDnXIqqR7fXYxNhQkKZlCIz+nl9Ei1qXmlKPgkdmHsROU46GBze8LtEJ/3UJIgJsjQTDAmU4HBl1hY4e+2kDHQXmS+NstzsMSAcwtwMs1E51cAJ8TgfFs6mLGLXb5FP8/Qjb0LSP6sw6Q6cFlxpks8RdiFxTShNq1E1vKAnzGzSDAaO26mPWltA4Fo0V5qJc4FHSvedU9EgyBwkl4qJ0N8PgXliGxjc9Su83Gvxcb+pJG+7Mu24iaC2qTqQyYUjCO6eWA1mTwaVp2N/h6UbhUFHOqpFtAqG1wprHnNjk4ZVtJDUuICAfQn5VC9IIbqVu+7nO9Z2biGR9d9DpqBNwTJUMU4EFuqjexMaDSPvQvtCa2PdM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea425aee-4b20-4e94-8654-08d758b9ce14
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:54.9737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OMvktlmWTBA4STdAzZ5TIEFrVWkST8V1rdPQUXb3BdM4bn36OSt3sB+NtZNRrotEdRkegDUSSsI8A9JAuHiFzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
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

