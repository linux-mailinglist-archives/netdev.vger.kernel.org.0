Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F528857B
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfHIWEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:35 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:4427
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728044AbfHIWEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b98E0wvZi1aq5gw7vJv8CBTKs85CcDpOVW6VOmE7Xu4BzkxTP9KlD5s2jj8dQpU+/jY7szkxIj3d7/BxiqfQkeXAMGkr5iyZP2G6jnJcCAXD+OXppaXY+EejYBvCCYb9BOsvQii1k6JKt2Rw3XWfxhxAgOKohdHFxfpzQ3jnh8pQcDy1qKwX+jxbw3x3/VcUqCvNE/30zf9RLcdDxeUjfrksx3HCCLjrDqGNXg29RrYwwSI/t1/Rd8Hadhc/e2mYQ1Nnf0pqwRC7ddpbTJf7VvGtqNh1udFQVAsA1B8sI1tuLBSOJ2ghMuxm7n3DoWO9FG/xb2jSBsgtwor8kDuGmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CT/SNCyOwhPB34eHcwy7KXzpkKtciO8mwbw31I3Wvyo=;
 b=ED3FUXKk+jQDtdirbzm077GbtdPzPuUXRQXM4FAI5YYtqg+3AMg2xP3SXTyQ4/omWP2+Vz/xe0DyW7ZeHqcn4zJINgCSZgbGCDwCQa26FUMxu1ftXz/k9ClFvE52H4INBftwBTvr28dGOcS1idMXE+XyjaeJSpfAoahCirz3ZGJ58aycHB6x/ncajFzE0OJE5iUU2Gu4V2d0aFfRqB7MW6K4eR14NjLqTCCEoHS59FvLqb45JO9eGTaZQvk9NUHA/OOC/KoUficRQTBDF6DkT7pFlnWWgJFzw8/RtNKYE2O0bQ5XeuUvstagcbYsEQ3UnwE1zL4Ygw9DzVCbNeNbug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CT/SNCyOwhPB34eHcwy7KXzpkKtciO8mwbw31I3Wvyo=;
 b=UBCy1HRfodZVhfSTskZmRfLHmxxNsotaxrxOehQtToP1IGDQag0hB4egexdZmESPAlI5PKjJ1GAB5f/xYNdyYn7exgH48u1qNScivaZvUfUS2vXC9xIWe7wpFdQ5VvI3xXRDsVwpVsuba2IeWmhwyxls52IfwMgP4jjEWdo+bZ0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:21 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/15] net/mlx5e: Protect hairpin entry flows list with
 spinlock
Thread-Topic: [net-next 02/15] net/mlx5e: Protect hairpin entry flows list
 with spinlock
Thread-Index: AQHVTv5lVe88oSAqNEufkNSGxkOvYw==
Date:   Fri, 9 Aug 2019 22:04:21 +0000
Message-ID: <20190809220359.11516-3-saeedm@mellanox.com>
References: <20190809220359.11516-1-saeedm@mellanox.com>
In-Reply-To: <20190809220359.11516-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da27345b-646d-44f3-09c5-08d71d15882f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB28562557C3EAB6C06B26DB25BED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZIZc2TMo/lE+Y6NGmK/4fApt71mkReOOY+rkcvVOPkS/RJpTJqWZvnaoebnQSP6+wXkoxcBmB1uqH/Qdgi8VBjKf7HQaxd2a2ad0xaKJJsOxtLpZQQTzNSKh7RVA7/2cYWkhX/ipZYotGZwdgjP9OimTlyAE1YNTDE0Tzxvj3PsxUyRE+lUm6wtCC/dvc7F2JrOsnvugByTRpOMDBVT08Q8skR/MrrWIjAguZZ43NjZVLbCU8qdedoSecuNpkxR2ENSsXqyb44IjGg+X55Dzt0/JZ4HeNWzGQ3kAuYCUqaYon7Hb/HLEWS9s+p8UnOYaL9mc3ZOLLjhdHjkb9Mayz08t/Eyl3Js+pF/aMcFv52uHmY/WOAHhQ4o6Vy7HZGHZnpHn+0JHcMEjiQZHbFaqF47mjM6/daQcwMWltGZ/z1U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da27345b-646d-44f3-09c5-08d71d15882f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:21.5705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bZcLiT4Y8qyF2Jq2Bp7ad7L9VL+q9Bvox1S39t452jFNe7u1+NMogcoQkPp0YigFaxEJkoKcXBeLo+oxDyX0aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock, extend hairpin entry with spinlock and
use it to protect list of flows attached to hairpin entry from concurrent
modifications.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 64ce762ec1e6..0abfa9b3ec54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -162,6 +162,8 @@ struct mlx5e_hairpin_entry {
 	/* a node of a hash table which keeps all the  hairpin entries */
 	struct hlist_node hairpin_hlist;
=20
+	/* protects flows list */
+	spinlock_t flows_lock;
 	/* flows sharing the same hairpin */
 	struct list_head flows;
=20
@@ -735,6 +737,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
 	if (!hpe)
 		return -ENOMEM;
=20
+	spin_lock_init(&hpe->flows_lock);
 	INIT_LIST_HEAD(&hpe->flows);
 	hpe->peer_vhca_id =3D peer_id;
 	hpe->prio =3D match_prio;
@@ -782,7 +785,9 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
 		flow->nic_attr->hairpin_tirn =3D hpe->hp->tirn;
 	}
 	flow->hpe =3D hpe;
+	spin_lock(&hpe->flows_lock);
 	list_add(&flow->hairpin, &hpe->flows);
+	spin_unlock(&hpe->flows_lock);
=20
 	return 0;
=20
@@ -798,7 +803,10 @@ static void mlx5e_hairpin_flow_del(struct mlx5e_priv *=
priv,
 	if (!flow->hpe)
 		return;
=20
+	spin_lock(&flow->hpe->flows_lock);
 	list_del(&flow->hairpin);
+	spin_unlock(&flow->hpe->flows_lock);
+
 	mlx5e_hairpin_put(priv, flow->hpe);
 	flow->hpe =3D NULL;
 }
--=20
2.21.0

