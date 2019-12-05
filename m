Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE4C11487F
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbfLEVMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:24 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729799AbfLEVMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcHL9IJBmYx8Oqn+gA/Z8eBmSl6v58pEcvzAxA/vp/9AfHd+QCDh1uX2wPXWdQyfPzar2cv9ChWPXZV4qxix76ZtpwKfFLdc/psx5J9/9FgpfQgDrPSZXm76gNFHSsAN1bhyimuhp/zYDx4VpYjpy9Q8+qIgx1SY5evRnwQPZMvpTes6tbrVIY6CiuWduUMY+MR1ttBJ/aQuoapNKJAYDjzQ2qIvHGU05B5WcgbVwrniOSw+VjKl2IQOujBqu7tOqrktNEiyPZq0ERlfa2qU6k+RE1NI9LnQjjU7XGxAgGV6tPk22M7YHuStqnM3hKPQB8/0Vph3IWmB9X+5PnNr0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlZvpZbedyXvTmpOUl7HfLcBhK6BjeHnF5oczuTjRSQ=;
 b=gbJz1og9C7kqpKLgiIZrYqevK4zof77rvwSnmjkeoVEhZ3smy3JeLhtKp225ohn+xgyy51x5OMqKVmPMGHKk4tCK2YqY3SwjDWx8iCq6PBfyFEt2eqW8FN2BqF4tjXzTdkbCEq4/uvnft4l2KfumzESOsHTyQOsaPXQ8aUHl/L/kRnD/TZcz2cTOjV2vcB9LI8X2mKNWP2TZlYEI3GY1oL4YJuIRf0W6tCxWTSKxyM500vb8UKm+UPPCF9FfcjTIcpelAaOEyFzUT0ooNBkPCWqxcQhoe4gf0oRPKJIUqtck/FuBWDXSwyVLr+WSJAdyaVlZ8iuYzgDIz7QSG1Dm4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlZvpZbedyXvTmpOUl7HfLcBhK6BjeHnF5oczuTjRSQ=;
 b=mI6ss/lTFIM+h8GNPVM5C0nwkS3t7rXZwNxbHB+ValLeQSNpH+gGzXzcG7dEMgwxEr0+1uuam7PQDDOgt04yIK+AfkoucVYgoUhBY/AZ55bOIhLYkHTqO+NdQ+P+6pzhgz6sbA8+Z+n8t1B31/eFPWY5VqjPqtt/3/GtqJE5X4M=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/8] net/mlx5e: Fix freeing flow with kfree() and not kvfree()
Thread-Topic: [net 4/8] net/mlx5e: Fix freeing flow with kfree() and not
 kvfree()
Thread-Index: AQHVq7Cpte5G5E64YEicZ3eUf+cjvg==
Date:   Thu, 5 Dec 2019 21:12:11 +0000
Message-ID: <20191205211052.14584-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: dcf95591-216c-42bc-744f-08d779c7cb77
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB33266A19DAC08A20266C2252BE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(14444005)(76176011)(8676002)(4326008)(50226002)(4744005)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EVaKiHXBDPI8u1z+8tSItXskQbCMRKKA8bxeSto3qISMTL+nywf5Oz1ITqOg4AZrLJrHAxQ1NlP9wCu+rJYgB6AyRujw5EFVdDRHDvnMxNNKa2G4DYgqu5wqbvzcDkB5tLBVw/Pm1dunUgayd3mLGgapWyXp6e04MFPl2z3kI6XuvtKzvb6e2K8GDcgVothanwJP72821zJMlebVViF7a73gQ8ukMD9OTIaIrnV1F60eJYKnRqBdDSpYEkpE/tVrr7HuYAunrZVO+1KIuY95CIuBaKnZVxQsDKTqyi87GaidVUVLKnU1EyEKVy/4lhIadf/rK005QJVZi3En8i04Cakl/rER1ary8lCVx8AikjNrGqGtNCjktCAWjwE7MTiP9XwT+CmhtmEIH9gUXnq9REM8FcP7CGj4nmnoTsQREZyRto7bik+3/vmyINsLPkEA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf95591-216c-42bc-744f-08d779c7cb77
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:11.9618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GCg48WEniwmOLRX8nGc1FRsnwbaJMmR19P2ugf9BHFsMH2uyU2YmpdazG7deCUSQZX7qnNKvk+P4pk2iACupSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Flows are allocated with kzalloc() so free with kfree().

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading o=
f TC flows")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 0d5d84b5fa23..704f892b321f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1627,7 +1627,7 @@ static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e=
_tc_flow *flow)
 	flow_flag_clear(flow, DUP);
=20
 	mlx5e_tc_del_fdb_flow(flow->peer_flow->priv, flow->peer_flow);
-	kvfree(flow->peer_flow);
+	kfree(flow->peer_flow);
 	flow->peer_flow =3D NULL;
 }
=20
--=20
2.21.0

