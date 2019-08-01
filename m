Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DEA7E39F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388818AbfHAT5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:05 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388600AbfHAT5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZvlYjefyNbORLI+kVAyDru2TJOwWXl/86MSo4egciYkwDps3RpTk5tZ0voD6nE6SFZ1fpgoA7yRjfH02TNncDThLQrmMfvpTIituShLvo5OWThLK7PsTATkm8snEvb1bvgZat66DDaZl9PuAIMB5WFcPnTq8Q1xC5d3neKAtJbDSKZw6qTJmtk4dhkP1pj+fcj9whOlF2plpcltkG75VGOE31XQZh3UIJDTUVllEO9l7iI88GxDhzmE9MYh2qN+o6Lmoxa7uQQOeuF3BKleyfEgBhcT0kEFv80eEGSve54jjzl0CaREHdgze6881AMUpGKSIz8yoN/bvEz8iKndBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZWCR0G8evxSe86+uacpwn0Wo4sEUiqIAT+gv7kT88Q=;
 b=LK4oNdjI/pWz/MkZnvuuDDL1vnvPfdyOyZiIwbobW6Mc8jEuduaQwxU+TBlAtxTNr5MhZsA6ehwZtv+2XOo1Ur7R5iiZbtsYQ72BKnieVxL1S7fUyi85JqfeJK/10elJ8iqDj0yut1MaHWwmeD89cbuuodRpi6BPOoKF4qmnKUvvtDk6b2NkpEhHiJAl4r3nesANYb5tSor5frJzMb4yYFXw3fMQLc4UKcBnmlr4VaU1Kiy4iMBwpDCom5GuCCNkjLGiz+fQVTLY7vzv1G9o3n/h5c2/VgjyKnQpR8BZQhoH/AT13EO1fEiUezENV1LON6WESx+7jbN3TnYPkoff2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZWCR0G8evxSe86+uacpwn0Wo4sEUiqIAT+gv7kT88Q=;
 b=izp4d6EBfmgioPXdJgj1wRws8DxUUMB9zfr+DvMxnO2aAZInfiCxJ/YETIcPvzB00RrUA7ZOPY89sN5IkNFVKtdpC5OtX9dlQG2dMFQiHWexVYgD1+fcud5WRvs7KgL9YEbU5ABKi3dwe3ghBu7tG9SepQckSk13xvZbguWvLLE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:56:54 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:56:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gavi Teitz <gavi@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/12] net/mlx5: Add flow counter bulk infrastructure
Thread-Topic: [net-next 02/12] net/mlx5: Add flow counter bulk infrastructure
Thread-Index: AQHVSKNEucupFuKgRUWCC2xULMTcqQ==
Date:   Thu, 1 Aug 2019 19:56:53 +0000
Message-ID: <20190801195620.26180-3-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f3cf039-1f64-4175-6620-08d716ba66aa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB27597CD5AFBEBB0172A2F6FEBEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fSV1JcLI8NIjD7a+kGUXM/SbToC9S6gWiPLi/LNF6RI1HjswMgVySex/J9lhnDO17THQlM8rOGkYAs282aocpEOzTZoMAyLm61FQbiIBhaaKZFYP8AOed2YiZXvkPSz8JsGSDFh55iZD2cG3Ylx5vz5UiwzvuMAtom7SSVDq781CGoGHF4i37siFWXN51OUEpAM+IfVuwzAjnj3FZsHZlxsnN3IeDS5qqR+L8v0vbxPpzylUI2iHUfP5gHPguFT6Ln13yCDap8+zreZHDjW2EpMj16O4J7eQ0un3T6ISn1oJdn147HMB7sA7OsTfa3GLU6NwRbCW87GyGGBFFr0ZmXgUfTMvpkfqQG2CtXFrOd/8W4FuNAsx+kpTT4C5L45NitoS6e6ohkuMZILP91EWaoxBQaDJ48Yh2iU0L+CBQQ8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3cf039-1f64-4175-6620-08d716ba66aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:56:54.0005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavi Teitz <gavi@mellanox.com>

Add infrastructure to track bulks of flow counters, providing
the means to allocate and deallocate bulks, and to acquire and
release individual counters from the bulks.

Signed-off-by: Gavi Teitz <gavi@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 105 ++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/driver=
s/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 067a4b56498b..3e734e62a6cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -58,6 +58,7 @@ struct mlx5_fc {
 	u64 lastpackets;
 	u64 lastbytes;
=20
+	struct mlx5_fc_bulk *bulk;
 	u32 id;
 	bool aging;
=20
@@ -412,3 +413,107 @@ void mlx5_fc_update_sampling_interval(struct mlx5_cor=
e_dev *dev,
 	fc_stats->sampling_interval =3D min_t(unsigned long, interval,
 					    fc_stats->sampling_interval);
 }
+
+/* Flow counter bluks */
+
+struct mlx5_fc_bulk {
+	u32 base_id;
+	int bulk_len;
+	unsigned long *bitmask;
+	struct mlx5_fc fcs[0];
+};
+
+static void
+mlx5_fc_init(struct mlx5_fc *counter, struct mlx5_fc_bulk *bulk, u32 id)
+{
+	counter->bulk =3D bulk;
+	counter->id =3D id;
+}
+
+static int mlx5_fc_bulk_get_free_fcs_amount(struct mlx5_fc_bulk *bulk)
+{
+	return bitmap_weight(bulk->bitmask, bulk->bulk_len);
+}
+
+static struct mlx5_fc_bulk __attribute__((unused))
+*mlx5_fc_bulk_create(struct mlx5_core_dev *dev)
+{
+	enum mlx5_fc_bulk_alloc_bitmask alloc_bitmask;
+	struct mlx5_fc_bulk *bulk;
+	int err =3D -ENOMEM;
+	int bulk_len;
+	u32 base_id;
+	int i;
+
+	alloc_bitmask =3D MLX5_CAP_GEN(dev, flow_counter_bulk_alloc);
+	bulk_len =3D alloc_bitmask > 0 ? MLX5_FC_BULK_NUM_FCS(alloc_bitmask) : 1;
+
+	bulk =3D kzalloc(sizeof(*bulk) + bulk_len * sizeof(struct mlx5_fc),
+		       GFP_KERNEL);
+	if (!bulk)
+		goto err_alloc_bulk;
+
+	bulk->bitmask =3D kcalloc(BITS_TO_LONGS(bulk_len), sizeof(unsigned long),
+				GFP_KERNEL);
+	if (!bulk->bitmask)
+		goto err_alloc_bitmask;
+
+	err =3D mlx5_cmd_fc_bulk_alloc(dev, alloc_bitmask, &base_id);
+	if (err)
+		goto err_mlx5_cmd_bulk_alloc;
+
+	bulk->base_id =3D base_id;
+	bulk->bulk_len =3D bulk_len;
+	for (i =3D 0; i < bulk_len; i++) {
+		mlx5_fc_init(&bulk->fcs[i], bulk, base_id + i);
+		set_bit(i, bulk->bitmask);
+	}
+
+	return bulk;
+
+err_mlx5_cmd_bulk_alloc:
+	kfree(bulk->bitmask);
+err_alloc_bitmask:
+	kfree(bulk);
+err_alloc_bulk:
+	return ERR_PTR(err);
+}
+
+static int __attribute__((unused))
+mlx5_fc_bulk_destroy(struct mlx5_core_dev *dev, struct mlx5_fc_bulk *bulk)
+{
+	if (mlx5_fc_bulk_get_free_fcs_amount(bulk) < bulk->bulk_len) {
+		mlx5_core_err(dev, "Freeing bulk before all counters were released\n");
+		return -EBUSY;
+	}
+
+	mlx5_cmd_fc_free(dev, bulk->base_id);
+	kfree(bulk->bitmask);
+	kfree(bulk);
+
+	return 0;
+}
+
+static struct mlx5_fc __attribute__((unused))
+*mlx5_fc_bulk_acquire_fc(struct mlx5_fc_bulk *bulk)
+{
+	int free_fc_index =3D find_first_bit(bulk->bitmask, bulk->bulk_len);
+
+	if (free_fc_index >=3D bulk->bulk_len)
+		return ERR_PTR(-ENOSPC);
+
+	clear_bit(free_fc_index, bulk->bitmask);
+	return &bulk->fcs[free_fc_index];
+}
+
+static int __attribute__((unused))
+mlx5_fc_bulk_release_fc(struct mlx5_fc_bulk *bulk, struct mlx5_fc *fc)
+{
+	int fc_index =3D fc->id - bulk->base_id;
+
+	if (test_bit(fc_index, bulk->bitmask))
+		return -EINVAL;
+
+	set_bit(fc_index, bulk->bitmask);
+	return 0;
+}
--=20
2.21.0

