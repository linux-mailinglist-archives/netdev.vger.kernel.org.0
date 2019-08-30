Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192C1A2D89
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfH3Dp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:45:28 -0400
Received: from mail-eopbgr780100.outbound.protection.outlook.com ([40.107.78.100]:62487
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbfH3Dp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 23:45:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxbpZL48W1USE4w5uGHqiv+b+37YmStLYp6tryY0lK9iIGXNbmR7JFuA/MOnlcg1B9WTqMsDrdZuccDfroF4vXWJxLRj1cEFmokZOOTQ+2GP/Ab8xVUppeN7wDFSHKCX0vxVFr43CtLCqx3BEK9wZO0txRiXMrABP77DoA85ow7oA0fV0xB5kRGlKUUZEW8ulzoSQ4KshRgvmqmpz18FTmWbdYzCJ8aXYcotGgu6XTiYNloqEnuzhfDCrtQEo5xe6MAM1f7Zf6QVPN6kwRg1ALvWbN1mgsewD5ZYha5OLyDzrU0jXlBVdEugM+vWN1QvH414Ul+4EtxY2vgOJU2dMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7WQMHD1jaGESLBl+6sw+OsohcgwEeI0r+TjnP4YdFY=;
 b=ajFCBspdtp/U3fKx1vgxGXCuK7BcLw/dg/hu10uRdS/91QE5vuWwhqvyUs1lgl4VdzjZ+kM/CbCmYpPkhh1G3qW5aQfkP1BowXtr77Cc7eTx8haOK9/SkFl/C2fMCgBd/Nv6NMi9wqZJeZpWvXuNw58Y1qvjW/7vUZ+dLfasn+3xX+I+nGip/oq6WftmPU46rmaHSepz+gJnxkqDBC3i/DkvrIAE/4BSLGHTOg26Db5UsXH192IEIbh7sx/hEQYGFURgc0bn3BrovzGZJ8Yqo+c/hbfL/TgfLB6iOEq+YkSHTjp/HeESkv8nlYYhTGshdmv0Zm7Xe0GKsto6O+rgNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7WQMHD1jaGESLBl+6sw+OsohcgwEeI0r+TjnP4YdFY=;
 b=PEJPLe7oP+c0BZnapOho9Ab0i0GHDaZTWTd8llH+HXhO4v95B0y/2YFs30wlb1jQCHCX1DRBe676Up2wVdIoD+to5i8AQGTEsy/qJZQ6ryL3mRNgQWOTgOgWspyV97/wpZXbKNFo2kHUBIXnYIq/o5qIjhE310L4as0cm/mb+co=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1307.namprd21.prod.outlook.com (20.179.52.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.1; Fri, 30 Aug 2019 03:45:24 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785%5]) with mapi id 15.20.2241.000; Fri, 30 Aug 2019
 03:45:24 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next, 1/2] hv_netvsc: Allow scatter-gather feature to be
 tunable
Thread-Topic: [PATCH net-next, 1/2] hv_netvsc: Allow scatter-gather feature to
 be tunable
Thread-Index: AQHVXuVaXXbsNF1InkabwiSwiKRb8w==
Date:   Fri, 30 Aug 2019 03:45:24 +0000
Message-ID: <1567136656-49288-2-git-send-email-haiyangz@microsoft.com>
References: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:301:74::28) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a544caa-a7d2-4b2a-7d99-08d72cfc7d0a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1307;
x-ms-traffictypediagnostic: DM6PR21MB1307:|DM6PR21MB1307:|DM6PR21MB1307:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1307BAFC28D480149813ECB2ACBD0@DM6PR21MB1307.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(189003)(199004)(81156014)(8676002)(99286004)(50226002)(7846003)(66446008)(476003)(71200400001)(4326008)(66476007)(102836004)(3846002)(14454004)(8936002)(2906002)(81166006)(256004)(478600001)(10090500001)(76176011)(22452003)(6436002)(26005)(52116002)(316002)(6486002)(2616005)(25786009)(11346002)(66946007)(446003)(64756008)(6116002)(66556008)(2201001)(10290500003)(2501003)(5660300002)(36756003)(7736002)(53936002)(54906003)(6506007)(110136005)(386003)(4720700003)(305945005)(71190400001)(6392003)(6512007)(486006)(186003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1307;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8eUqTv+vb/JD3u31Ov7zEAq/r4y4cTtK1pnfDbu6YUZqv0CJWiyfCRTdzQi31L36Q7v6H6Dp95SU+XtOmfPu/o40cxjDoE5rcaWGGKmIom68hHcHuCeSuNlxVwIDJ2LamJEuNZY4vHFn6PHWjaN1edSkg+YKc3/OR9vJ+7vL/I14abrD6s87jqVTxO9bb8cOsWsem0pvXoP6RX5NgCZT+UXm2tOWtgBPJp9FN5p5CxK3jbtunyRnS4ICdYlqbAgqRK8DtSROKegGZdOotBXq9733fc8mN26fnMmkn/lChlW7M92iwRuEcsBNXRUhgDesNk/HdpKypRYrJeH/d7iqhBxHI1kZOmYTw7H7yyGNjravi4nb60s9qBo9TgsJSsKP2TaDKzZp+a8bC69z6EY8C5O/G4F0PKaOv27/hHl44DE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a544caa-a7d2-4b2a-7d99-08d72cfc7d0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 03:45:24.1642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 768/HreQvO2QsrjeR4gE66018nxSoJH039/i5bvH7jZ5nyVngVwRTyFIMchwGgJq9A3B7Z1sFURkTPAEsddSiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a previous patch, the NETIF_F_SG was missing after the code changes.
That caused the SG feature to be "fixed". This patch includes it into
hw_features, so it is tunable again.

Fixes: 	23312a3be999 ("netvsc: negotiate checksum and segmentation paramete=
rs")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   | 2 +-
 drivers/net/hyperv/netvsc_drv.c   | 4 ++--
 drivers/net/hyperv/rndis_filter.c | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_ne=
t.h
index ecc9af0..670ef68 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -822,7 +822,7 @@ struct nvsp_message {
=20
 #define NETVSC_SUPPORTED_HW_FEATURES (NETIF_F_RXCSUM | NETIF_F_IP_CSUM | \
 				      NETIF_F_TSO | NETIF_F_IPV6_CSUM | \
-				      NETIF_F_TSO6 | NETIF_F_LRO)
+				      NETIF_F_TSO6 | NETIF_F_LRO | NETIF_F_SG)
=20
 #define VRSS_SEND_TAB_SIZE 16  /* must be power of 2 */
 #define VRSS_CHANNEL_MAX 64
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 0a6cd2f..1f1192e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2313,8 +2313,8 @@ static int netvsc_probe(struct hv_device *dev,
=20
 	/* hw_features computed in rndis_netdev_set_hwcaps() */
 	net->features =3D net->hw_features |
-		NETIF_F_HIGHDMA | NETIF_F_SG |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+		NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX |
+		NETIF_F_HW_VLAN_CTAG_RX;
 	net->vlan_features =3D net->features;
=20
 	netdev_lockdep_set_classes(net);
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_f=
ilter.c
index 317dbe9..abaf815 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1207,6 +1207,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_devic=
e *rndis_device,
=20
 	/* Compute tx offload settings based on hw capabilities */
 	net->hw_features |=3D NETIF_F_RXCSUM;
+	net->hw_features |=3D NETIF_F_SG;
=20
 	if ((hwcaps.csum.ip4_txcsum & NDIS_TXCSUM_ALL_TCP4) =3D=3D NDIS_TXCSUM_AL=
L_TCP4) {
 		/* Can checksum TCP */
--=20
1.8.3.1

