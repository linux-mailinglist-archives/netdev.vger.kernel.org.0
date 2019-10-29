Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FCDE93DB
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfJ2XqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:12 -0400
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:58478
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726684AbfJ2XqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDjAzTXblxUXztlV3QjH4epUiXFtTVKkDNU8wHY+qTnxg34QctFqGsE/jFSiqBa3+wEzoEyE67QEXEHKWZ7L3O4zC4VvwHV0jE8H0EW3w1GIOAf4jJ8R+7fhYQjEV7AQt2OQjk9l4Pg9J6prWszyyq09pNjshkNRW5QuLSJ9S3ukdSN3q6v0GqqKIDliGAfUhThLqOBTspUdGdhrSdNoFRH20+33bP42dYzh8Wrb4FDMVRw5dgDPA3Rp2Gm0Y9aRuXuRChL+TN/lyL0Nj4mPApTtGRwyUJJb7T39uyfvOEasUxWpgLg1UUaSwpoDDle/VY8Tvc8Wff99MMG1DobOSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FN+d1CJe00PDnrnGyes/eJpvvUnN+nZwVFj+Hw8SmoQ=;
 b=ezDa7Fw1J5xdFMWXPGZD6NKKX/VOtM+fE2F2ZjKEmgbEP8YWqeug3KvLFs0Grt7IVVk9YEujnsgjdHsUV9SVSrIhaYnIwHlyC3WBdVz3uI/aoUUmtMvq6cRrrPYiC/U9xetoZJIN1IueeEx1+FsgCApKT0R9cf2AGsa/dJidk0LKz/Chs+tTg/IeDEBMiFJwW8Ptzu1eTB//22rHTjZ/YK6H2r1PvHhZDetSIy/A82Z5P9DrMZl0sWIoCftk+uRP4VVkXgCQbx+atFWII2WfsLx7TXM+rhNFRDVaU1Z5DWOKZ+B0LE0AJ0Ngp2gqJZrc0oDM3BFfY6w6hakPatRcoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FN+d1CJe00PDnrnGyes/eJpvvUnN+nZwVFj+Hw8SmoQ=;
 b=hFhS/xjt1rDInzFem+yMWFMbMT+GoRm9G4wkcTVB2KUBXJXXiVfcTX++0e32nMvCizJ58kL9jVIF8pduxZfCXBk/smTz3akvZWJNuioeb717irNVCmmQGwCwZRR/4zBybZUv7haAYiHy9fUmuCfFrpbz7cD7StX1sspyGaXaN5E=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:46:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:46:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 04/11] net/mlx5e: Replace kfree with kvfree when free vhca
 stats
Thread-Topic: [net V2 04/11] net/mlx5e: Replace kfree with kvfree when free
 vhca stats
Thread-Index: AQHVjrME9wi7n5J0AEOMW/WqYuTV/w==
Date:   Tue, 29 Oct 2019 23:45:59 +0000
Message-ID: <20191029234526.3145-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5523e892-be30-4c5d-cf4b-08d75cca267b
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61576CE6C0DF3A828D819148BE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:130;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZEYiRbXawtnM++r8XN9PXYY3o1sHXJygiH1sDdv5rtZpwGugib+F9c42szY4q4nDTGufFfUVL83Zubo+vTenBqNM0o/OqtjBeeTmhioh7uauvxycLFQvSeVR3nPtCtgBaqHhOr7ud26pgYfsk/8QBlOlLwSXK7Ymxb2EtYCn5/Z7TDygjw05GqIIObwrd6MBOpfS8Xf9fSYAuVlpg56ZyRvgC5mTT0VwEIQMNJD9wJMuTRwxufY+8f2spJzdEYXDzevsdczq2joar2QGGDcIiR3he7tbcFSyUu7Q9g/9mfpLyUca4QnYk4ekZRF0Ri2vNFWPNY8Kln8Dv86PfpcsT5eexTEuE+HhUTdjS4R3geezP8Kx3DuKJIfTjmdWCVMGwjBhMUtrVKTgO1d/aFD1hYx7u6AWt0gnhMtbKq6dKTcnsbYsIVSyl1tMszVv/NTI
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5523e892-be30-4c5d-cf4b-08d75cca267b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:45:59.9449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /lhUkKBoZywh5a6Y9VYWYHNWVPXBlN7f6JjPjlj3K2q3jBDqJRRHo0S+2CtJxDdGeD4q67bk1a/V7wHQ7ezkpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Memory allocated by kvzalloc should be freed by kvfree.

Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index b3a249b2a482..ac44bbe95c5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -141,7 +141,7 @@ int mlx5e_hv_vhca_stats_create(struct mlx5e_priv *priv)
 				    "Failed to create hv vhca stats agent, err =3D %ld\n",
 				    PTR_ERR(agent));
=20
-		kfree(priv->stats_agent.buf);
+		kvfree(priv->stats_agent.buf);
 		return IS_ERR_OR_NULL(agent);
 	}
=20
@@ -157,5 +157,5 @@ void mlx5e_hv_vhca_stats_destroy(struct mlx5e_priv *pri=
v)
 		return;
=20
 	mlx5_hv_vhca_agent_destroy(priv->stats_agent.agent);
-	kfree(priv->stats_agent.buf);
+	kvfree(priv->stats_agent.buf);
 }
--=20
2.21.0

