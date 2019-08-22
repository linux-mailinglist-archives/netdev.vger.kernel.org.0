Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF59D9A154
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404412AbfHVUlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:41:40 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:41706
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389251AbfHVUlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:41:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVOeQMfe7aOIT2KLZd/Rg2ZpDe6NN4/SvYTHQUzA2BU/LgGXWeITlzaiz3MBnzSmX0gUjCoPkUSkCaT7IvWc9eo2KwltgdnezRdTIy/fROG8DIIkoEc990Byr1DFcCmu1n/kqLnGzs4amDtZTW5hjhZcsVrhQ2n5n3qC5G5XqU/vVr1nFUoTAoX0at0PN77WxyDwAcwcATTQpUl01igZiFsfcY+eRflJJiQwl9HcrS4ZTm71NQCIuS/YuunSgTyeXTcfjWHJiIh6J/7QuuPabZvfOkOvUCrsAvJnyygSGL0PULm2pPzWeudNbDpfmR13V+HkmMV0I+PkWJEiwqDH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmJMEvjopdhvUQo2kSfR4NwcNjAEn+wKP2wnD3SFJGo=;
 b=MgluOAYnMXONYZKDSaFmD9bo4YSUZlih97MnqYZylfNzDzlfBVj3p7B9FhEjODB6f2m6ErdpCl/E/+liug+Yyvyz68p9IoPYRJUTiErfqo+CEz6mvbjFkqcQFiUXKzRy/Rm01Mth0Di2qGWmuO1kQfwzPrDaNdEF/Z+GxC+k7nRuGFAsMi7irCmll1WfBEINm3dc3XE5U80JturExltVR7EP6upTeWKYuM1Hbl59+whAPmwY5KRv06PdkE1m2h0q9Gicg30umQ5EBYk+qqUKE3Kq+SjqEPuuVKbRS3KnWHFCzL0Jg9xlUSud5ARXR8MgJbhKbdiHxo9J9iLVyR3dag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmJMEvjopdhvUQo2kSfR4NwcNjAEn+wKP2wnD3SFJGo=;
 b=QsAjmObCbjwDUFcqsSSMrp10MimmmcG3FG3K83QyjDN/2/ksfcmB6qVhvDfFiT7+RC9VhxrDkvAeqaMKAlvvd5Hsc065hxBHLdIS7/xRAastqZmH/AyET/8XZuBm5jjpGuq+8y3hjg84z0qDZBwitwD4HINZt3d0ggryy997qeY=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2724.eurprd05.prod.outlook.com (10.172.221.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 20:41:36 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 20:41:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/4] net/mlx5: Fix crdump chunks print
Thread-Topic: [net 1/4] net/mlx5: Fix crdump chunks print
Thread-Index: AQHVWSn+6QlFVPz7xUmOH7fTdTyDww==
Date:   Thu, 22 Aug 2019 20:41:36 +0000
Message-ID: <20190822204121.16954-2-saeedm@mellanox.com>
References: <20190822204121.16954-1-saeedm@mellanox.com>
In-Reply-To: <20190822204121.16954-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa69230e-9f79-429c-3be4-08d72741205d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2724;
x-ms-traffictypediagnostic: AM4PR0501MB2724:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB27242145003BE71EF87C94A8BEA50@AM4PR0501MB2724.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(199004)(189003)(446003)(36756003)(316002)(54906003)(478600001)(476003)(66946007)(64756008)(11346002)(8936002)(81156014)(50226002)(66556008)(8676002)(81166006)(4326008)(66476007)(486006)(2616005)(102836004)(66066001)(386003)(1076003)(6506007)(7736002)(305945005)(5660300002)(66446008)(26005)(6486002)(6916009)(71190400001)(71200400001)(6116002)(53936002)(256004)(14444005)(3846002)(14454004)(107886003)(186003)(25786009)(99286004)(76176011)(52116002)(2906002)(6512007)(6436002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2724;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S03ufQMg0wZEDhfxD16rHhtPBClSSCB0SZ/QuGTiIe891+F0foeYwiMwKki3ogPcSiythtgvexCK1ZH7Dx9N1E9IUHf7m1u9bAqNvwzUqL7chpaEKyc5trct1lR/SiNnsQ9e/l+3QEBCGNRhkWz1+CxKSklA31RKkY391DSy5VhKxNwDWBE/dfRiGy0UgvUOqWKyMc0UTI33o7eYC+YDBV+6160OE7rBEhZDxuDxnmrKexXYnOcaW1DO4DlQR7lylqsk208T3xLJoC5ewoOl55001+7dOIlCJ3pb3lqu3LaCxkGZtSruD1Pra1koB3ct7leVJUNRJIkOvs2T0CthRRxbSC/Ye5CVGm4fOHSKWo79xTXxHjLK70qbqj4B0ZNPbqcKPtKqVt061MWzykZ8LNfTeQqOroIhaTg4pOxwfrQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa69230e-9f79-429c-3be4-08d72741205d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 20:41:36.9011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Oc6QS+yMIgOYmFN1pUJvSs3UMUBEWL3YSJw214kaAQhiwsxya+Y/gPhN5I3T8suc3aupwyLLQKoIiEQwDdFuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2724
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Crdump repeats itself every chunk of 256bytes.
That is due to bug of missing progressing offset while copying the data
from buffer to devlink_fmsg.

Fixes: 9b1f29823605 ("net/mlx5: Add support for FW fatal reporter dump")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net=
/ethernet/mellanox/mlx5/core/health.c
index 9314777d99e3..cc5887f52679 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -590,7 +590,8 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_repor=
ter *reporter,
 			data_size =3D crdump_size - offset;
 		else
 			data_size =3D MLX5_CR_DUMP_CHUNK_SIZE;
-		err =3D devlink_fmsg_binary_put(fmsg, cr_data, data_size);
+		err =3D devlink_fmsg_binary_put(fmsg, (char *)cr_data + offset,
+					      data_size);
 		if (err)
 			goto free_data;
 	}
--=20
2.21.0

