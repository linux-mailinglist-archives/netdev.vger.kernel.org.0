Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3871AA0A1E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfH1S6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:58:22 -0400
Received: from mail-eopbgr50073.outbound.protection.outlook.com ([40.107.5.73]:26958
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726883AbfH1S6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:58:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gp68s4WjZoU9nitFDZMdphEskOAEhWs86MZ3Xvbs23oUBCwZy7iRwobTpOEHgi8JZFQq7WX+2nLouVow53VwY0bMD5p7Oel69gf5eBnf/j73qLcrnXuEDVuQy4TqfYMMAiHXJGJyRUKdUrRhWo4i+rihGEpKCfvs6u9d+HzApRLd5g1i1KfmsDJVIKMipSZpZlVWuWq1E4HaoQI883BW2Qj/8Ft0Lo4xyIkYSxZ3rXuIVa7Rnzx0sAKyhaTAhY42Gc8u1OgkHpcOzWIXo1BiHQ+OFIccXAJZaCtt5e2TmijzGW0Xj7MYesOiCocDwtFUS56kGWvkqckIzWw2FisbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxyNFQ22oMM3+JPQN8v6NiUX/fwhk5AHWyWvpR6s3e0=;
 b=P/b0G5DZK2Fqb1x7FbXAMWnU78+nIlo6DPU+U5lkh/lhIqPMkbB77Icxt40lfEkdLpdPAdLTf6C7q2V5tzPl2y2Jt4XKQm8pqzl48Bn0VYvGrXowGyoqy9v6CjZnFGuau50tOPeDc4kCm88yNeLqzewJDLsDXbNHnjF8HEpObTHXxro8513Fl+TD1wlnCB9XPewsvMEwUltU72DZWGssAzumRzip8dtRb1jolImvHYFHuvhNLRst0/6NK3eoQUDullBEBDFghy3Tj//N3+jO8Qkr3q/S9akZuZb3+U/tvU1E2mtc3aqo82ulAtRn7uNXTcOuHRokDMW9bLpBd9f0Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxyNFQ22oMM3+JPQN8v6NiUX/fwhk5AHWyWvpR6s3e0=;
 b=TqhEHHl3KKGLgqlb+0A8zs0xzExfx8RXVMxY6pl3VGHnxpWm46w67e1GQIWCd1U9YIDZMr87E0Ze1CZawsHv+Ap10bhPIcbNUnxrlx4szKl0EpI9miyS8Ft1VlGyITnGbeTYrVSHr2u+t0tvVLu2jqbgryawz19vBdDvUFxDISg=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2638.eurprd05.prod.outlook.com (10.172.80.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:56 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Marina Varshaver <marinav@mellanox.com>,
        Avihu Hagag <avihuh@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 8/8] net/mlx5e: Support TSO and TX checksum offloads for
 IP-in-IP tunnels
Thread-Topic: [net-next v2 8/8] net/mlx5e: Support TSO and TX checksum
 offloads for IP-in-IP tunnels
Thread-Index: AQHVXdKAnchsvU8SoEKQv1mUC3TV4w==
Date:   Wed, 28 Aug 2019 18:57:55 +0000
Message-ID: <20190828185720.2300-9-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1a8c389-d1f1-4814-5f50-08d72be9a2e3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2638;
x-ms-traffictypediagnostic: VI1PR0501MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB263870CD0907D23EB192BAD2BEA30@VI1PR0501MB2638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(6512007)(107886003)(6486002)(54906003)(1076003)(25786009)(3846002)(316002)(186003)(8936002)(5660300002)(6116002)(53936002)(81156014)(6436002)(478600001)(86362001)(14454004)(2906002)(6916009)(4326008)(81166006)(36756003)(7736002)(50226002)(66446008)(305945005)(256004)(66946007)(486006)(476003)(11346002)(2616005)(66066001)(446003)(66556008)(66476007)(71200400001)(52116002)(26005)(6506007)(386003)(102836004)(71190400001)(76176011)(64756008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2638;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mAe1gMy79OzBGaglARCYCDBZiz3wQgsa7IWES6JNESaYvDVG4j28JsRiwhhJScxY+QusO5SQqSpN24AFvMvE15Dq7AR3w2VKPucoNyhHmmbnJ4gZUXs5347cc9Z+k5D9U0wwS+rbpRfrxj4t4QDKqWUqJ4/PkD1E7AbXcwo9iuvIGiVFITXSA3Pe7CRl8D74jWLjhaSQRpc9mbUyXz/qS7fyh1VIfs1jNxBcN7KPqmnebiLZp5qtvS1teAqlliO2yqKFWFjmNUaIsTm5naUGOED7RKeBGsmW0YyPlQC03ubLBixbTjfqBHir4K+uHrdJsRT4NOZoljnpzHCjn0TIZo8ydMeNP8jKJ7Uho384jKp72Xsq9WyMkELU487duWA0yxovmCwdBnM+8FLSPjdpy8ZcYYAOkMfHOAUUctdRj0k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a8c389-d1f1-4814-5f50-08d72be9a2e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:55.8148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mzbytDEkYk+d3qfLALsAOxrPsrmaR2e09kwGYbjnuDLxaOkfQRO6BB9VvRjoVRA78bOPLaP4Womst9tqxkhcsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marina Varshaver <marinav@mellanox.com>

Add TX offloads support for IP-in-IP tunneled packets by reporting
the needed netdev features.

Signed-off-by: Marina Varshaver <marinav@mellanox.com>
Signed-off-by: Avihu Hagag <avihuh@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 327c90d936e9..9ff28e2d72cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4243,6 +4243,8 @@ static netdev_features_t mlx5e_tunnel_features_check(=
struct mlx5e_priv *priv,
=20
 	switch (proto) {
 	case IPPROTO_GRE:
+	case IPPROTO_IPIP:
+	case IPPROTO_IPV6:
 		return features;
 	case IPPROTO_UDP:
 		udph =3D udp_hdr(skb);
@@ -4903,6 +4905,15 @@ static void mlx5e_build_nic_netdev(struct net_device=
 *netdev)
 						NETIF_F_GSO_GRE_CSUM;
 	}
=20
+	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_IPIP)) {
+		netdev->hw_features |=3D NETIF_F_GSO_IPXIP4 |
+				       NETIF_F_GSO_IPXIP6;
+		netdev->hw_enc_features |=3D NETIF_F_GSO_IPXIP4 |
+					   NETIF_F_GSO_IPXIP6;
+		netdev->gso_partial_features |=3D NETIF_F_GSO_IPXIP4 |
+						NETIF_F_GSO_IPXIP6;
+	}
+
 	netdev->hw_features	                 |=3D NETIF_F_GSO_PARTIAL;
 	netdev->gso_partial_features             |=3D NETIF_F_GSO_UDP_L4;
 	netdev->hw_features                      |=3D NETIF_F_GSO_UDP_L4;
--=20
2.21.0

