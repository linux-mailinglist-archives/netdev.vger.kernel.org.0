Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381ADECAA6
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfKAV73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:29 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:20086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbfKAV73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITlhpi5bwdODL/6zOZmZLQz3K2ttN7fZ2D1W3huRbLDuItvpgjngz1+/ZDjOM38b7BL5Hnhgft6Lax4nZJxq2j9/2veI6J8JU48XelRh0C0Ij8dUTsnceJJgjlu+EwTujJYe4Qs4phCsWNn2Y+y0coWrbbnOsVcHxzr8muvjXxeow0NX68yeryE3Z8VZzyuj8T5Eo6tRGFLRxdJRHQtzCT1OOaZZ+M5eZ1GAi43TyWHjx6mT0TNeUETpPiuYaKwqDhg4Kx17PQ8NpP9HV1jfL2l19sy0MUqE+8wzK2zLBlxkCMPt7cnn+e8qaZ5OLZGP+nS2jvWC5fj6INSxvP6Qng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0y4Shym17BFqfvumBzXhZcznEwf7DxvknhT0B1Usahg=;
 b=NW0GSz9cfPylvHiXrRCtP6wNRabRfS2CY8hC7kEZHYLqmrpUDEO6486U9fcHPjIsfk5akw1rHmdElk109YnFFipvQtdrw+fQczmAz4ykAsTPf7Ukp/QZ9d/cvvbc97K6ts4ww43QlbYDC2smyle5yd4HspEdljH/L2+zZxSC7f3r9zMjXhZnwmttmFtCqtdV/JrJs8j5rp9alkahIL/YdkRKQXIr61guc3KSt3qSkUN/fARgjN+mZ/kkoy1R2HU4a+Wx1e/S4lHfyAvDZVGxpR9mpJcGh4WCfAnsg4YPykKS+XsYtM+RlVdb4xFc3jVSwL+NcnncxpqSyI9oQtbQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0y4Shym17BFqfvumBzXhZcznEwf7DxvknhT0B1Usahg=;
 b=IaOiuPQqt/01BmBh+XfzTv67ORJefiev/vLs1dShBeo5ttS+QW5bZ7aj6Om6hZrQCFjxG7BtUaiCJbveUtsnNmBNUJYk29udYahUg59LSZG8f49ne2RWF0ZW36ffDw0FbcuT1a+5dBVCRAaaA9TJ72id8dH76C/9akSmNRrQj6k=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5679.eurprd05.prod.outlook.com (20.178.121.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:59:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/15] net/mlx5e: Add ToS (DSCP) header rewrite support
Thread-Topic: [net-next 11/15] net/mlx5e: Add ToS (DSCP) header rewrite
 support
Thread-Index: AQHVkP+bSHVluNV0l0SaaZp148ta/g==
Date:   Fri, 1 Nov 2019 21:59:16 +0000
Message-ID: <20191101215833.23975-12-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2b2aaedd-c3b6-41e4-9fac-08d75f16bd6b
x-ms-traffictypediagnostic: VI1PR05MB5679:|VI1PR05MB5679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5679000645490F94E7555016BE620@VI1PR05MB5679.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(4326008)(99286004)(316002)(2616005)(2906002)(6116002)(476003)(6512007)(3846002)(1076003)(36756003)(66946007)(14454004)(25786009)(54906003)(66066001)(66556008)(64756008)(486006)(11346002)(446003)(81156014)(6916009)(76176011)(305945005)(7736002)(26005)(66476007)(66446008)(86362001)(5660300002)(102836004)(386003)(6506007)(50226002)(6486002)(6436002)(81166006)(71190400001)(71200400001)(478600001)(8676002)(256004)(8936002)(107886003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5679;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WuUU11hDygsnvpHy2IgskF55J0U0Z4xtV+trUbHLZxmznpzrVPPkavmfAFDae4nIxtloXp21tbt7O6pwpk5rt/mtsW/Ak3bPsh2f0RkhBJlRWNyU6FMwrFrWwIvSYpFZlN4rTnC1btk8/43r2wJHk9hrHTEVgzIm3BZLFFnWuYA4tio+Om1841DrsMMknqn6ehiN2WqhLGpnb6IjP7OiBgzblB+hFRzR21f1884KGnTD6eMYsFRKPFZiFhVDvYZKcC9hS+igSJnt45taBFw004uY4+OrOY0LUvld+P6rs6i5tbOsf51DijFye8ZlX5NPl8wFMvpF8347vaDML5NlyQaxxpSvqBCBMviufKKQ5bErnjWpsvLmjNdqsZ+tjr4wcJIeYmxb+V393dGRpsXCn1lwXJkP/WM6S+qF/8IvRRBBR4jmcL1kUaF6TNRmHFu4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b2aaedd-c3b6-41e4-9fac-08d75f16bd6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:16.9789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tshCs+cYCqj8neUPMiYpwvhkaObTInaCykhxODXMz9XwEbbq4ysYmxSZ3qv+bhOaW1fHwsfHJrHwQQlMzPaciw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Add support for rewriting of DSCP part of ToS field.
Next commands, for example, can be used to offload rewrite action:

OVS:
 $ ovs-ofctl add-flow ovs-sriov "ip, in_port=3DREP, \
       actions=3Dmod_nw_tos:68, output:NIC"

iproute2 (used retain mask, as tc command rewrite whole ToS field):
 $ tc filter add dev REP ingress protocol ip prio 1 flower skip_sw \
       ip_proto icmp action pedit munge ip tos set 68 retain 0xfc pipe \
       action mirred egress redirect dev NIC

Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 67b73a00f8fa..4b4be896383f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2290,6 +2290,7 @@ static struct mlx5_fields fields[] =3D {
 	OFFLOAD(ETHERTYPE,  16, U16_MAX, eth.h_proto, 0, ethertype),
 	OFFLOAD(FIRST_VID,  16, U16_MAX, vlan.h_vlan_TCI, 0, first_vid),
=20
+	OFFLOAD(IP_DSCP, 8,    0xfc, ip4.tos,   0, ip_dscp),
 	OFFLOAD(IP_TTL,  8,  U8_MAX, ip4.ttl,   0, ttl_hoplimit),
 	OFFLOAD(SIPV4,  32, U32_MAX, ip4.saddr, 0, src_ipv4_src_ipv6.ipv4_layout.=
ipv4),
 	OFFLOAD(DIPV4,  32, U32_MAX, ip4.daddr, 0, dst_ipv4_dst_ipv6.ipv4_layout.=
ipv4),
--=20
2.21.0

