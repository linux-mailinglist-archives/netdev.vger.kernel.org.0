Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314BF10309E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKTAPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:15:52 -0500
Received: from mail-eopbgr40042.outbound.protection.outlook.com ([40.107.4.42]:57648
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727518AbfKTAPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 19:15:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxJR7blKX135epMuXlr21VsyfjsPBgoZK7PB6OS8yPAPrEYsjy8SFcpL4QdU1Cm8Zenr8VcC3P4a8ZqnIw+qRHZadx5W66TbUQelLa9wVm41GbDZNbVbX7z54vBBjRASKN8+izOnKwN2dWZBRnI0B8jKZTRGJ6VzpeBOReWXPq3z7pG9a8vnG8Ci5yAtNf8Ji3ketvM7jbQzjIKhnoc0VwBerl/ZGaljb11xAxU4CBUHt9VAUZoyunZCtz2IWB4RyjxvoMDGtk9op1rOZiS3dD2kia/KF1dZdmRSPANFxq/ifrglrU4FM74+D768BmqpktgsTTC92cHZCZQlAyVO9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvqBIzdT/rwsHbZntj7gxefWY8bGVZeJZkyMRoKVyZU=;
 b=jYN7Lz1qRWnWfc/2ePPSOsqKpjCeemzyQgfltVwf8AWDSj2FC8Dg1x9RXQFBbdC7xIxGhczRC3yXj014Xh+B/EsoisNSBSF43MSJptAGL5B74DjLojISmGzEhMRUhRmLn+9rwKEKBepWguf3NTveDI/v4e0JiXYtpJos6K9QV7jJ31vFQaKhpPW+Bmsv2+LU+cfrqK8ynyhgKB3to1sQeclsqHXSRZeXNFuRu6eE9UEUGhvG8Rw2kusKIrg894Da2Wh6PJ9zhpIoob+k7VbMpKHbRnDeTxMwnSBic71iPeDdn1iTwThzVAzBPsFWcjiabdKpg1C1czwcBMcGPzNTkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvqBIzdT/rwsHbZntj7gxefWY8bGVZeJZkyMRoKVyZU=;
 b=SQ0CaLpJhHqf6Lgm0CiGrm2RPB7BPkFjgO6Ri6Pgx3eYcSWvAk5OmET99R7G1m6nXVEptMAqGI5iBe1QEbeKKm4woQ4N8k3JAc6isZKc5BrQtipNNJzjVXUocRsUGQx5cjaVfSwZ0ab9MrLtXeQvmrPHc5PcGg2yAYRvKx8sIyk=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5378.eurprd05.prod.outlook.com (20.177.188.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 00:15:21 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4%6]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 00:15:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: [PATCH net-next V3 3/3] net/mlx5e: Rx, Update page pool numa node
 when changed
Thread-Topic: [PATCH net-next V3 3/3] net/mlx5e: Rx, Update page pool numa
 node when changed
Thread-Index: AQHVnzeYdwBKSlQ+aUKSpbDfXMiUjQ==
Date:   Wed, 20 Nov 2019 00:15:21 +0000
Message-ID: <20191120001456.11170-4-saeedm@mellanox.com>
References: <20191120001456.11170-1-saeedm@mellanox.com>
In-Reply-To: <20191120001456.11170-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d1e044e9-10f2-48ad-a524-08d76d4ebb3b
x-ms-traffictypediagnostic: AM6PR05MB5378:|AM6PR05MB5378:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB53789D3536FBB18A6DB2A8CABE4F0@AM6PR05MB5378.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(189003)(199004)(15650500001)(6116002)(3846002)(256004)(14444005)(66946007)(110136005)(446003)(305945005)(81156014)(6506007)(386003)(81166006)(36756003)(6512007)(2906002)(54906003)(14454004)(71190400001)(71200400001)(11346002)(316002)(7736002)(64756008)(66556008)(66476007)(66446008)(486006)(476003)(2616005)(102836004)(50226002)(99286004)(52116002)(186003)(5660300002)(6486002)(86362001)(478600001)(8936002)(76176011)(25786009)(6436002)(26005)(4326008)(1076003)(66066001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5378;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zrY5CL9W5PaEYfWCAO6bQiLnYby5/DQI9gC5dmoBeZWy5dXM7TKlozDoelTKZd+G3D+GIqfoNvGLREJvRXxMAg8XHq/KHJmLq92sVMrRxmaJEk2VdZNml8WLi+5ml+ZIVEik35SEPXRdPkAAWeCfaaJIPH91JDyZbtee0ctnoEJ9NeotncgEiMwf+S5SUQpEuxfNvk41sOk0EqexFqcCaePhpBqnf1FGLo4LWO3BritBOmlemfY4+RVwcAxQG1oNrtNcd5SUXa0ifXYf+2tnqSbP1hymZ4f/A8nlbUNwlh4DYWlyODi8FpwO2wOMqi/i9AL+J8K1SU9zWqluaOk3leXbEuGVmcDR2IEGiRho9CZV9ytX/Kt18AQ+FKJ/51Gr3cBzUEXoEnBVFV3UC3xIE9rdb+H2E0zit2B5m1ug4oLh1JxVd85TGobK+XQn7jr/
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e044e9-10f2-48ad-a524-08d76d4ebb3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 00:15:21.5357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q28rxqSnHgYuELVg4Nu19fNDb4z+A61BOqlNko0slHzGrTdRm06l2XhH4vH+IEd/zeIU9bN9S1TSXjWevGEVYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5378
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once every napi poll cycle, check if numa node is different than
the page pool's numa id, and update it using page_pool_update_nid().

Alternatively, we could have registered an irq affinity change handler,
but page_pool_update_nid() must be called from napi context anyways, so
the handler won't actually help.

Performance testing:
XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
while migrating rx ring irq from close to far numa:

mlx5 internal page cache was locally disabled to get pure page pool
results.

CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)

XDP Drop/TX single core:
NUMA  | XDP  | Before    | After
---------------------------------------
Close | Drop | 11   Mpps | 10.9 Mpps
Far   | Drop | 4.4  Mpps | 5.8  Mpps

Close | TX   | 6.5 Mpps  | 6.5 Mpps
Far   | TX   | 3.5 Mpps  | 4  Mpps

Improvement is about 30% drop packet rate, 15% tx packet rate for numa
far test.
No degradation for numa close tests.

TCP single/multi cpu/stream:
NUMA  | #cpu | Before  | After
--------------------------------------
Close | 1    | 18 Gbps | 18 Gbps
Far   | 1    | 15 Gbps | 18 Gbps
Close | 12   | 80 Gbps | 80 Gbps
Far   | 12   | 68 Gbps | 80 Gbps

In all test cases we see improvement for the far numa case, and no
impact on the close numa case.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 82cffb3a9964..9e9960146e5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1386,6 +1386,9 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return 0;
=20
+	if (rq->page_pool)
+		page_pool_nid_changed(rq->page_pool, numa_mem_id());
+
 	if (rq->cqd.left) {
 		work_done +=3D mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
 		if (rq->cqd.left || work_done >=3D budget)
--=20
2.21.0

