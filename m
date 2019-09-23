Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D49EBB406
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439547AbfIWMlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:41:03 -0400
Received: from mail-eopbgr40086.outbound.protection.outlook.com ([40.107.4.86]:43238
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2501898AbfIWMlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:41:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nm29sRuQxQfPVrOK2eg4U8A5VvOCNAgZnvljc/qVCdz2IzmO9O8gTXQ/Ojp4mL4/jqI1gYDcL+zWRnR0XO1YWbcxPDHe/lEnZbVCeR6ghxd1qF4Cdk7hsMHOcTKPhJqYPw4TyzyW98YWF8RVaXpK6ctsYOCow0gCovWKfNd6mNwqO5IfMbxEo3+aPI61kD6XYFSjDiCqUYca89mMaTO2mDzUJ06V5yzZLS/wTQHgtH+P7JJIBHlCjrGHsv+DsjRqQKJhZmJ9Gb448ycTIalhryrWzyDruPE7bG8Y3p39e2QD6PAh3ja0FnS3+tn3q7HJQtustl9AqDRif3wVZklNsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxlVWEAoIECVS8NoDBWEuGYomeD5twIRNWyvDXNzDCE=;
 b=ogPvGkbGiGPtcgdWWdWiLinfv838RUag/jCBrZ3AhmUA0rFD6vuo2baUjSrbdES5t4d6IN7f8wjnNRloJBHQsTI+V53p+chUK7O4Jdc14B5KovHzESyvXi7GGcOMK0On/DrGlwu8GsiYelbDgPHdqFULODcei+SrZW4am26m4RzKpW6xQqwKnEA/Qp5IoNMfJaBL7d7oWyvXnsPGIlbTNqw6GPLJetmaSCt4ExDj1SSliyYcy4lggJRiyJRHzHNni5swJ6njAjjKcBTANm83ZYqSXIOJSsrsjWi7k/E6BHFtw42n5EtsfedzuzTGDboDpFs5hvKa78rqc5NCpicwXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxlVWEAoIECVS8NoDBWEuGYomeD5twIRNWyvDXNzDCE=;
 b=girjTONCG9E1d78mfvsjp95HKBl8/Y3LqVKZa04lXF+5zyKqJI0DmXV/08TWwtacgvL9yRT85n0wsBgs7yy0FXFDUyaxBn3TtET4nv5VohQj3G+ZZD5UjeKGGejj8pBDGFbvOr2Y0/A5yUmhh7rJVZp1gl/6sLhZpinEtnH9XZU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:40:20 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:40:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 4.19-stable 5/7] net/mlx5e: XDP, Avoid checksum complete when
 XDP prog is loaded
Thread-Topic: [PATCH 4.19-stable 5/7] net/mlx5e: XDP, Avoid checksum complete
 when XDP prog is loaded
Thread-Index: AQHVcgwPdQX/5j4ERkKtJbW7q8C7mQ==
Date:   Mon, 23 Sep 2019 12:40:20 +0000
Message-ID: <20190923123917.16817-6-saeedm@mellanox.com>
References: <20190923123917.16817-1-saeedm@mellanox.com>
In-Reply-To: <20190923123917.16817-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [89.138.141.98]
x-clientproxiedby: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab0fff3f-ea14-4c40-8dd9-08d7402331fa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB233999B482467BE836F9AAD0BE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:49;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(11346002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(446003)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(76176011)(6916009)(107886003)(14454004)(26005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9YIHMfC4YDKPU4fTlmv3qOzS8SzVW6IBu+3/WZZvGtbXKFWzBiRpKujwjWPTNYNmqRRxcotfmm3VW7DYrA6sneWABpEAGd8vi/ZBE3TadZ26uHUWcunAc1BwBfeeAWuJn1blEJuY3ug8OXBe/A4Vblk6/f953QsTM1sTn7bdpEVFiLBypVayujffVRz2h+W45KW9FoYSXH774YdslK49zXLXQ7b56fTVesec9vVk3uM7ALKcKgsg8TRUwpiLeTPbXbRt6QdFrLydM0ZF9UCD0NAvSZtqkOTJHkCF65HYf/TzQi3xU4pW4oPQAVNamhaDK45qyuAqZH8CzxEVy7GRAI5TngzosRo9p89b09FfvXHpXLMSKOrcV4IZefc6cmJiq47CEHMdof9K7wV/72D0a92tTaa+js/1PUpueLM63Pw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0fff3f-ea14-4c40-8dd9-08d7402331fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:40:20.6709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4JQRsou7gJZh1OXs6yY4aM6kNjlYGOGJrz1wkDUzn4TN5E3mp/pysKnwdjE+XkZD7fEXeSitwFF0i9hrEx6hMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 5d0bb3bac4b9f6c22280b04545626fdfd99edc6b ]

XDP programs might change packets data contents which will make the
reported skb checksum (checksum complete) invalid.

When XDP programs are loaded/unloaded set/clear rx RQs
MLX5E_RQ_STATE_NO_CSUM_COMPLETE flag.

Fixes: 86994156c736 ("net/mlx5e: XDP fast RX drop bpf programs support")
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      | 3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index cb79aaea1a69..10d72c83714d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1517,7 +1517,8 @@ static int set_pflag_rx_no_csum_complete(struct net_d=
evice *netdev, bool enable)
 	struct mlx5e_channel *c;
 	int i;
=20
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) ||
+	    priv->channels.params.xdp_prog)
 		return 0;
=20
 	for (i =3D 0; i < channels->num; i++) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 5e98b31620c1..7e6706333fa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -934,7 +934,11 @@ static int mlx5e_open_rq(struct mlx5e_channel *c,
 	if (params->rx_dim_enabled)
 		__set_bit(MLX5E_RQ_STATE_AM, &c->rq.state);
=20
-	if (params->pflags & MLX5E_PFLAG_RX_NO_CSUM_COMPLETE)
+	/* We disable csum_complete when XDP is enabled since
+	 * XDP programs might manipulate packets which will render
+	 * skb->checksum incorrect.
+	 */
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_NO_CSUM_COMPLETE) || c->xdp)
 		__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
=20
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 4851fc575185..98509e228ac3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -754,7 +754,8 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 		return;
 	}
=20
-	if (unlikely(test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state)))
+	/* True when explicitly set via priv flag, or XDP prog is loaded */
+	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state))
 		goto csum_unnecessary;
=20
 	/* CQE csum doesn't cover padding octets in short ethernet
--=20
2.21.0

