Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEBB396A45
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbfHTUYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:44 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:30086
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731039AbfHTUYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSa6XBbPWhTob2Xrj30XYPOT0TIAqHnAxBQU68qVef6YxBpy6deE9+0lUKWTuyCQsMmcm7oAi6xIvgA9jg+KvhdDnLrpYAx0JMTzF+SDPhrZkXlGpENO4PWvmAiiC6EfyTZCb+nlN8fZur+uHHIzBef5pCrZQlvEUANxUowSbjHHHW5uhTnWiedsZmSVLJUY0YdTPIQAf0aL2SF7V4OOVRWaX6npsCxMhfWjphKafkIeMcXP0Q9yfaGGs/pK1fiWb8vEWB30LpuE5rzjC8+OnBZmqte6aTYh5ZQEtaO2gOmHb/hFH1TsycT1hNcF2u6ac7L17OCsjWrYN+IoSbwQAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1SxxzmraeN689u3BxAUOSz2PSJ2ZVW1S/OXZ4N0vY0=;
 b=aBitwQQGlhbvU2hNYrQ44IkEdc16QAyp4dI41kQPjWpnhDtU4wnFjtnxMRBjCya63PwOq76ls/olnBuMNWmtodBH7OQFl53Xvqqm/w8T7CFJZ0oXRjeA9Ss2R9SNg7HpsQXlFPPz8aOW6mkbL1wbUVtl1xczhfusVMRB9grPlwfKe003xAk5GjsszeB8IBsoM7hqEDYRIsa+8LLJATr2m8J7Ve0DjMSYhJHTg/d0GVlS+O4Oeioil+ZCvPsfNklHWfHnUmsT7F2a4b+i7UrweR4x6OknDU8+mNT9lH53gHfOpRaXM5J9ZtyVhHarCg+YkQcL+KDRgDnQKzYb+dh5Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1SxxzmraeN689u3BxAUOSz2PSJ2ZVW1S/OXZ4N0vY0=;
 b=cO1O18TVSbEDUUBUjy6V9WL3ZxCwpPwvG5/kKGm2F2S99C+5cf6klVcdUsS8p7pBFmO7BD0pLs+6YtXMIZ6PND285EO4+++3DacrzV1PeRQsvZXwkYFaw4PyViCKC1skJVHftM/CEMI2nZdRgnQCJluEfVEROi4/Vye9eXRPtHA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2502.eurprd05.prod.outlook.com (10.168.74.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 20:24:40 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gavi Teitz <gavi@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 16/16] net/mlx5: Fix the order of fc_stats cleanup
Thread-Topic: [net-next v2 16/16] net/mlx5: Fix the order of fc_stats cleanup
Thread-Index: AQHVV5VL2VgXmQeFhEa3wnaMD8yJVA==
Date:   Tue, 20 Aug 2019 20:24:40 +0000
Message-ID: <20190820202352.2995-17-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f30d45d-67fc-4e2c-f4ce-08d725ac6de3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2502;
x-ms-traffictypediagnostic: DB6PR0501MB2502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB25025B5E3F018C1E761A6055BEAB0@DB6PR0501MB2502.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(199004)(189003)(486006)(107886003)(14454004)(446003)(2906002)(478600001)(52116002)(476003)(50226002)(71200400001)(71190400001)(86362001)(4326008)(316002)(54906003)(53936002)(1076003)(99286004)(11346002)(5660300002)(7736002)(186003)(6436002)(14444005)(256004)(6512007)(6116002)(305945005)(3846002)(8936002)(76176011)(6486002)(8676002)(26005)(66066001)(64756008)(81156014)(66946007)(2616005)(81166006)(66476007)(66556008)(66446008)(386003)(102836004)(6506007)(25786009)(36756003)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2502;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I41ttr8P2t4VbWFYD1w9SrO1cIkVu+i2L26QJ70SH0vN7SKGzgL5LXN+4k7P+MDk00A0YPWlgl5UBXtgQj43par7SWz0HnDYEX2DEGVseC8apxhauR0a9k7SUGOupY+V4wHQPdfzYQYISeA2zw7EzmwPSS/il+lu9/KMo8+TpO1rncE4X2GHKHB3T1ygTfonVGtq8ZFBnl0wYWO9QC+lbKVR2kvCCje5DxzBGwIaya00hvjI2xr11Qjv10jpX0f237K7o6bJhgDu1w6gG78gaB9hvsBtFxYqZdlXBAZu5MMVy9aX9UHnAADmQdWIo4EbCcAEYs7tCU9mGt5rxQbCv4lQ5x0os8dVfKW/tudEt+pprsWSazNTC1wsV2s1dMeXZzApXuznzypKc8GbA53uGjJf80tmc1Qe1XLb+qMDr3g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f30d45d-67fc-4e2c-f4ce-08d725ac6de3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:40.5832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gn/BbyNGSi7AGnX44jOG6CfgLmhwfBFayhvZJWxUmmbXSi9xpEuDwOqjg3dvwuCTdQ9EPVaRYz9R9KBZ7wM5pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2502
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavi Teitz <gavi@mellanox.com>

Previously, mlx5_cleanup_fc_stats() would cleanup the flow counter
pool beofre releasing all the counters to it, which would result in
flow counter bulks not getting freed. Resolve this by changing the
order in which elements of fc_stats are cleaned up, so that the flow
counter pool is cleaned up after all the counters are released.

Also move cleanup actions for freeing the bulk query memory and
destroying the idr to the end of mlx5_cleanup_fc_stats().

Signed-off-by: Gavi Teitz <gavi@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/driver=
s/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 1804cf3c3814..ab69effb056d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -402,21 +402,20 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 	struct mlx5_fc *counter;
 	struct mlx5_fc *tmp;
=20
-	mlx5_fc_pool_cleanup(&fc_stats->fc_pool);
 	cancel_delayed_work_sync(&dev->priv.fc_stats.work);
 	destroy_workqueue(dev->priv.fc_stats.wq);
 	dev->priv.fc_stats.wq =3D NULL;
=20
-	kfree(fc_stats->bulk_query_out);
-
-	idr_destroy(&fc_stats->counters_idr);
-
 	tmplist =3D llist_del_all(&fc_stats->addlist);
 	llist_for_each_entry_safe(counter, tmp, tmplist, addlist)
 		mlx5_fc_release(dev, counter);
=20
 	list_for_each_entry_safe(counter, tmp, &fc_stats->counters, list)
 		mlx5_fc_release(dev, counter);
+
+	mlx5_fc_pool_cleanup(&fc_stats->fc_pool);
+	idr_destroy(&fc_stats->counters_idr);
+	kfree(fc_stats->bulk_query_out);
 }
=20
 int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
--=20
2.21.0

