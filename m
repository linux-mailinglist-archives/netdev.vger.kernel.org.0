Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60C8114882
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfLEVMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:33 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730241AbfLEVMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7UIn8YTn9bH8zfPoxKjJUEcZFVz2XBwqcxjoME0vA1hX39dBlSwHpBW4ltl1FxXFlOZYIXLCy2HPY4z0zsIOap0SMXc3X1t0Xzmo3UUKvO6hT9d61TLawKMSwDtilrJGaNf05JpISE8CTN5rFjFRDb34Wh073UJUsbg5k+CVRqVFMAWdnD00aWtZwxkQrc/D6uaS+XbX522TPn0ECaU0yChg/xc2ehzLAx4cepjMILvAqammcfpNj9m4fS2+fM+a9QZY7QEgtg5Ac1gAlhNqTHoAUshE6KzVGMf685G9Dq1EktuscZclZdogGnHOUocb+SxW+6gubngZZgYYeMEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJO2vQ9gQNnxEQ0AsBEk41pb3dvz2jeiNX2KadASLs8=;
 b=mvddtBI0Bb2vJQFjAdNuXCqYH/cJhEllQWg8Aw8iTFlC5K7+M+daRsAg7v05fT5+2hlWhmmBl6BUqD3TiogNg6dSSeB7zCx7NsrueBYo/TtioUEP46ceAOS8r8y8UssW0/wmjAD1iyirTrDkCBys7+yRNFvmFqZO9K72BTdbudCEiQ9+M3bGncAFcnWFL1PzxMPkPqGvZ459qWHzKmwLb7eg1jH5GAlkvCQpB6gxGUYFkqkEI5gkxfVFqP6kmZR17JDYiDuu+YETtUFERIfPCeEDgZhvgWoePzEQ8KDyEjyj0xj6EqDzF5eFHmZXhZQMSVkyDczDNpNKYJ/FKXMX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJO2vQ9gQNnxEQ0AsBEk41pb3dvz2jeiNX2KadASLs8=;
 b=HSwkU202ysDMRJaFEVFMJXixkfw+aFHZimqzGWsdHeBAHitmss/0dKZy2bUOIXxZpKCYxKF6XATNBZFnFZOGQvibF2QUGJa4mr4wLyxKGclKy1ucpR4wZhai5KweSMnC/NNjnl4WVM+aune1eLZkiWO/+d4TiIaVHi2pafayy4U=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/8] net/mlx5e: Fix translation of link mode into speed
Thread-Topic: [net 6/8] net/mlx5e: Fix translation of link mode into speed
Thread-Index: AQHVq7CrOdGlLGSQCk+bRTowdEFhCw==
Date:   Thu, 5 Dec 2019 21:12:15 +0000
Message-ID: <20191205211052.14584-7-saeedm@mellanox.com>
References: <20191205211052.14584-1-saeedm@mellanox.com>
In-Reply-To: <20191205211052.14584-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dfcc875b-7b84-49d0-9674-08d779c7cdcb
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3326CD5C007CB5E0AECF0179BE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(76176011)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UiOsPGMfU7A2UeIlX0XSbpc0Z24Wmv2aM94GaQnh6246m4N6rfkJgD4jdjQTe3j2HJqq21Q2VFbGsobU+8CmevlmZ+CvsWnk0nl8YZcvXdv8fgNJzGgtPUFBLo/LBvGz15l0lkcD9KQOXE/yLzscVOrr9RRV16V2ETOQKuCv7kNlPIku2/2L5h+17N1vPeFLJXJiwViHUy8+5WPKwuRWJ1Vp/OOHXia7O9lIjZjp1kvb+EKu0vhO1ZseDQHYohf8EH5U8J66w4fbGgsReFJl7tKyeEjv4f1US9Z3NBHxK7c9MBT9hcXicWDtLsKCxIHadZQJlVZqld9/XPtupwh3ulwxXWviyDlzo9IO7LPdotrcunZSiBu+Sf5Ogj8F8xB+gnbIgnG4PiBQ7LApDvioC9jlkBxWMHwcr3yWJYDFsRdbUO/aSj0gMiQQudkT/V8Z
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfcc875b-7b84-49d0-9674-08d779c7cdcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:15.8906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JDK6Y3ZlYJK4RjoGPm85yy2LlmmdD8w2XHJ1zUKqiQiWE1mi1FMlhq4NB5qHegvxHDB1ZosFTQYo+mKlCEzHog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add a missing value in translation of PTYS ext_eth_proto_oper to its
corresponding speed. When ext_eth_proto_oper bit 10 is set, ethtool
shows unknown speed. With this fix, ethtool shows speed is 100G as
expected.

Fixes: a08b4ed1373d ("net/mlx5: Add support to ext_* fields introduced in P=
ort Type and Speed register")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.c
index f777994f3005..fce6eccdcf8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -73,6 +73,7 @@ static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODE=
S_NUMBER] =3D {
 	[MLX5E_50GAUI_2_LAUI_2_50GBASE_CR2_KR2]	=3D 50000,
 	[MLX5E_50GAUI_1_LAUI_1_50GBASE_CR_KR]	=3D 50000,
 	[MLX5E_CAUI_4_100GBASE_CR4_KR4]		=3D 100000,
+	[MLX5E_100GAUI_2_100GBASE_CR2_KR2]	=3D 100000,
 	[MLX5E_200GAUI_4_200GBASE_CR4_KR4]	=3D 200000,
 	[MLX5E_400GAUI_8]			=3D 400000,
 };
--=20
2.21.0

