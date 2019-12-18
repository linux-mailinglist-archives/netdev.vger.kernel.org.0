Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C5D124A74
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfLROzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:46 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:9171
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbfLROzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzrPuBlUnnRJavz0WuETMxgRU6riwDkaZLj9mp3ZKqyKE+xwLyBriWVeJAz6CHZihiAU1Ux/7V2egwB7YLj8sDkvGOtTuRnBq3BAQsl4xTG9Qkjjz2IHlz6tVgq2OtobbDjg629RkVqm677B2jVJCS2946WmOF89jcEHgpHy/6CeAW0wO9jbs48M/p1LlUoELTlGYlNvN4goyNml4L5FljLCAzA8xvMR03awDYveJDDKc1kS9nHhkEbWL6S5Teq8cRXMy49/TejWS0N0qqbahUVCLLfyInkxKwnfFh6L9sPD//VgjEP51N/MIYch4VGEPw3bRSoqfC0sdhvxq4wySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkQbSoIy1Vbnfd1SpoXRPW7S8t0d1xrkxX6o6cOD6Ro=;
 b=ka7yUnrKQxsPrRto1jtPLeYfjMhJ+5+UPFgpFMFZvYIp26Aflnr+3DRBITcYwuyDn+PX8hGvBQSuSI/691WBiwln3BoT9zQuRgSK9AaU8urRJTTul18NKM5gBnhjoXzR6MT54vxxvZjbvsos7Te2QFt9TCZXh9UHSZRQIYLu3vy01sQf5p1iWELq0Xkbxc3zNgRCAaL1lZJuCnxp93vf+PLbhOPVXNX6GplTGrkrAxrUvXfN8KBMnCQFP3ViMPLyZ7sqMbHLgv3c9qVo5W+PelV+794EhStGCGejhE7G+EW/U2a8w8AMAETwB/Jh6XfRF4sO0o2RwshEZl719g9kpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkQbSoIy1Vbnfd1SpoXRPW7S8t0d1xrkxX6o6cOD6Ro=;
 b=YjzHmFz0rp93VNLpb/ka2usVW/hKkj3LvgGIRza5RyozsZiVTuyNbmf7Gfl9szQwGOU9VePpKoRklrdDP27u77U9KY/BQDbG95MCtif91w6cTFX2UM0q1p0OJPu01SrIiCTu/tNOPJ1N/a7je7ch5kgVqhT5FrQ0Mzr2xeWdJOE=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:21 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:21 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 08/10] selftests: forwarding: Move
 start_/stop_traffic from mlxsw to lib.sh
Thread-Topic: [PATCH net-next mlxsw v2 08/10] selftests: forwarding: Move
 start_/stop_traffic from mlxsw to lib.sh
Thread-Index: AQHVtbMr7bCwX7zLhk293fgTVjEL2Q==
Date:   Wed, 18 Dec 2019 14:55:21 +0000
Message-ID: <0caf966f43dd5648f9e8fb5ad802d86c6ac4d027.1576679651.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR2P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::19) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 47399b26-c0d5-43d6-1340-08d783ca4dcd
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB30481205FE0AC674C1CD8F2EDB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4sPpCYkvDobmOI7gxrdr/4bMIbXcvH8PPBXAC347oHuoJB/LHr4bBB4ozhDWDIkAIUYy2tMVePpcqyGWU9xNmakdVFqAqxFSF2v1WGXu6RpJHkgyY3FlGohRl5VLH5+HVfcfRIy3IffHH8mKKC/rIKvPM3HWpQ7C6bdxAxbUPRn78fFZ6tXZBrk6eI5Cek1esDVtZUPHJ2RxDMkkPhd+0UnhudVytPxMALE2B2YuJl6x8d8VquZo0HWRrjVVesc8L3smNJ7/2XpFstYzdU8LFbIf+WTBqH60rhcPAQVCHzOIhqJMVmncdwmgvYJEymkuWndyA8JGsuYNLuuljdhZqRk/lZCGsxO2gL1YS4+sW7kowSD077rzQ/0mI8ZRXqMUbE/ZQdob8cY/dg26OgPW4irgc7tk9fJqfwLoWeMosmxn038YnZV2ClW+3NeHulFz
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47399b26-c0d5-43d6-1340-08d783ca4dcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:21.2070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: brKWHkYoNESsKuaBFrEsepeoT/eIqNmd4RGSMGdOjXAabk+7OGldxxnHVuh1QgWkI2RxVF6zBOsUG/NTbEVkpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two functions are used for starting several streams of traffic, and
then stopping them later. They will be handy for the test coverage of ETS
Qdisc. Move them from mlxsw-specific qos_lib.sh to the generic lib.sh.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/qos_lib.sh     | 18 ------------------
 tools/testing/selftests/net/forwarding/lib.sh  | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh b/tools/t=
esting/selftests/drivers/net/mlxsw/qos_lib.sh
index e80be65799ad..75a3fb3b5663 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
@@ -24,24 +24,6 @@ rate()
 	echo $((8 * (t1 - t0) / interval))
 }
=20
-start_traffic()
-{
-	local h_in=3D$1; shift    # Where the traffic egresses the host
-	local sip=3D$1; shift
-	local dip=3D$1; shift
-	local dmac=3D$1; shift
-
-	$MZ $h_in -p 8000 -A $sip -B $dip -c 0 \
-		-a own -b $dmac -t udp -q &
-	sleep 1
-}
-
-stop_traffic()
-{
-	# Suppress noise from killing mausezahn.
-	{ kill %% && wait %%; } 2>/dev/null
-}
-
 check_rate()
 {
 	local rate=3D$1; shift
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/=
selftests/net/forwarding/lib.sh
index 1f64e7348f69..a0b09bb6995e 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1065,3 +1065,21 @@ flood_test()
 	flood_unicast_test $br_port $host1_if $host2_if
 	flood_multicast_test $br_port $host1_if $host2_if
 }
+
+start_traffic()
+{
+	local h_in=3D$1; shift    # Where the traffic egresses the host
+	local sip=3D$1; shift
+	local dip=3D$1; shift
+	local dmac=3D$1; shift
+
+	$MZ $h_in -p 8000 -A $sip -B $dip -c 0 \
+		-a own -b $dmac -t udp -q &
+	sleep 1
+}
+
+stop_traffic()
+{
+	# Suppress noise from killing mausezahn.
+	{ kill %% && wait %%; } 2>/dev/null
+}
--=20
2.20.1

