Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E242E69C5F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbfGOUKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:10:07 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:60879
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732345AbfGOUKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 16:10:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyhqhDsNR85QskSlikXCkmiqysukhVVO7S32jq1vxDK4316uqKyR9WE9VtPmL3vO2r1E7Ko68KDMUmeQRLjD9XH4dmjZzalA6LGGcVcJXepEu65q+wtvyihe8kS/vDOwWVTX9VObSaX+32h4QD0wNsrqdpUTngOyOR2+4MPlHLCkrh8TeBVj+DQ+pBScdd58+/1gxLopFBS7b6p4Z7udPYuKiB3oS+a+PcjozTxZm7y67T/TggObxvn5oYm2yq4hx6mxh0FehDIZYPlK6AH/ct7JKoJAtRheAA8GppMtOFyjjS+7tOVWTtJi/hPfxq0dHZ5tBlCoUGQEknb9+3nhPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHzk1OLoxmfHBZUSMQVQxO+vJsJV+/CyiLkUXMtBu54=;
 b=VtzXiRsc1q/1MuzQlkJnil+RhBrSEAePloY0aQteeuDv/gvn5EPsZA9hGHZjZFAlXKQahNe2tvjORUdeEMlemZqRV63Rg310QPiUhQo9MlceGliCLVomM9PjT8AKj16RpQH8UkGRSpl0qK9zsTVsDn4INc3UhAPg1JLV4MhgzP+/BmL/DezEsLT0yN/Hcy4ffFvdIoLCBm4b3hPznJDYpIORiQvfgdHsFibHyjH5HdrO87gSTyfJLCnF3aiODO3I5lZKHYk2pQamtYx8xMJME54vJKTOPsYwsYtDSNKi+4GIz5ihP75xvfvk9i1rnBKNK3LVVcelWDt+RoqzSbP/Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHzk1OLoxmfHBZUSMQVQxO+vJsJV+/CyiLkUXMtBu54=;
 b=o8Q0DX6Xbbb1bDxxrCCryFJIcZStg9ENvGocNRDsF+Vp9y/BAkzyqrnYRRqwWUeEMc92PYFBcvz7AcGVNrQBtWsPvS2uz4YbORYhyaybwpYBDoBbve3ua2ETaza1D6X2/2mFv2iWF8rxLb9MYqwAutURelDimS/s8HMULRS3gs8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2485.eurprd05.prod.outlook.com (10.168.74.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 20:09:56 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 20:09:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/3] net/mlx5e: Rely on filter_dev instead of dissector keys for
 tunnels
Thread-Topic: [net 2/3] net/mlx5e: Rely on filter_dev instead of dissector
 keys for tunnels
Thread-Index: AQHVO0lFfLK+Qe6QMkuCcPbRWeLsXQ==
Date:   Mon, 15 Jul 2019 20:09:56 +0000
Message-ID: <20190715200940.31799-3-saeedm@mellanox.com>
References: <20190715200940.31799-1-saeedm@mellanox.com>
In-Reply-To: <20190715200940.31799-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8582ec12-af3a-459c-b544-08d709606819
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2485;
x-ms-traffictypediagnostic: DB6PR0501MB2485:
x-microsoft-antispam-prvs: <DB6PR0501MB2485DF15588E90FB0C2004A3BECF0@DB6PR0501MB2485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(6436002)(305945005)(25786009)(7736002)(102836004)(6116002)(26005)(6506007)(81166006)(3846002)(81156014)(53936002)(107886003)(36756003)(478600001)(486006)(6512007)(186003)(256004)(8676002)(68736007)(386003)(8936002)(2906002)(66556008)(86362001)(99286004)(66476007)(476003)(66946007)(64756008)(2616005)(446003)(11346002)(66066001)(5660300002)(71200400001)(66446008)(14454004)(71190400001)(4326008)(6916009)(52116002)(76176011)(1076003)(50226002)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2485;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nSTjAJ6aTKUhv1mZb6D/E4nBEMhVGVvjDZ78AkOufbKo2Je51aNtIWMNv49+k52SQqPxPPspu/xS68A2LQKPbZDrCq9ImlYK/W+TGW1I7Y3P69q/z1ac9LiB7fzSucrni0n3AY08XkfjrCypRyZm2f/z2ZigIphxaheEF9JiHdheaIp3sQ58IRjz3p2QPDK7Ok4QKEgBMh68Ys9OyWRvjvTlBLpenn+hKx6Gym7ueQRHV7X5BUkHM7q9gc5yV80316QIZPpd3lP+InkWYmZbT0+DvS68FJdRb+oxV7VMj8gbQ5+O/NgPCD3wdtbThg71SlJThnk+hv9vSYMenIspDfsEcLwhKGtkAxzZX8deFIVdNRVQ5d4KDKI2pTiwnMwDxV6e1QvptGhB2VpQQ8vYKzBhPR1ao9lZRtJgoDjnG9M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8582ec12-af3a-459c-b544-08d709606819
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 20:09:56.6769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Currently, tunnel attributes are parsed and inner header matching is used
only when flow dissector specifies match on some of the supported
encapsulation fields. When user tries to offload tc filter that doesn't
match any encapsulation fields on tunnel device, mlx5 tc layer incorrectly
sets to match packet header keys on encap header (outer header) and
firmware rejects the rule with syndrome 0x7e1579 when creating new flow
group.

Change __parse_cls_flower() to determine whether tunnel is used based on
fitler_dev tunnel info, instead of determining it indirectly by checking
flow dissector enc keys.

Fixes: bbd00f7e2349 ("net/mlx5e: Add TC tunnel release action for SRIOV off=
loads")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 018709a4343f..b95e0ae4d7fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1522,11 +1522,7 @@ static int __parse_cls_flower(struct mlx5e_priv *pri=
v,
 		return -EOPNOTSUPP;
 	}
=20
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
-	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) ||
-	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
-	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS) ||
-	    flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS)) {
+	if (mlx5e_get_tc_tun(filter_dev)) {
 		if (parse_tunnel_attr(priv, spec, f, filter_dev, tunnel_match_level))
 			return -EOPNOTSUPP;
=20
--=20
2.21.0

