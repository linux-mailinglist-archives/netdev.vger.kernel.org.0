Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1343CAAF0F
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 01:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388636AbfIEXXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 19:23:10 -0400
Received: from mail-eopbgr720117.outbound.protection.outlook.com ([40.107.72.117]:55712
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfIEXXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 19:23:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGkIJgvAK/5EwcQHh9DsxS6Q8dvLA7FNI2B45CBFZ7jd2MoWAYnqDC8q2aLEaU5zH84TxUWtmChu4r3yteWxpdMe8gbi77b1aPHmbMDne8l+661n4HThnGi748WMi035uj20DdgYKpmNffyJRhzRU2J1HB9HI/jeot4sNP2oXt4LYLAY+BecXNSEUH3ckyToMguln242TTffJAOk3oXHpkWiMmMs2jtHxFyTESUztL9ETuX16t/SP/0NMzjRatTKxWVp4TNgfARvYkzmsO5L6hn/Xfd2KPGUqP3JhkJNpQa0EqCT0OQf9YhewQoeK4Eonurwg1EDiNC3rbZK9QKDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQjlJlWwEchtntwJRYCTjcuSFI2MquKeLYCKFm2QVFA=;
 b=JRXYZgJf0HGQgHnKjqsA7ZEb/oe5mnw1ApdpLoW3/9Arbq0qnBgP/BXeiSiuXuoJmuJzUJ1BYDK2fTcY0zNcdBS5MNfnwDCdSHshjwZuF3DVqdzmdQB/qqiidsfzRippQ91sUt6AY5QFyuNPHgdHlZBZB5KATjBajKL6V5jnSJN3F5LzE/+9FhPKZ+3N10jeXNrhfxJ4dnDjJuKKNqiIvHT3mkV8ky1Z82FcCSQYA5iSa9MzXzGODqHNLbpkoAp2cHTSW37bPDDGPrn6HTDcW/XbTDJRBkUFeX1QWLbq6TZJhhwSPpQq8Z20v4HXgJc54stIX5xQw+LKryBZcYiaFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQjlJlWwEchtntwJRYCTjcuSFI2MquKeLYCKFm2QVFA=;
 b=hwqffr0If5/mzlDUcyc54RdnS/rzPgUvDYYWgnpoaCXqCBXq9WYCgFj2QrCAfzBRo6nbSTmzoufL3XcoBNn8XJy3szPWL8EU1oGfFmRpmM6UfeRJbyQRrNQfeIcLmw1PzgmdzaPjS3d1lmL57Kze4y/TEwjYWsq2UyZop46VqQ4=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1241.namprd21.prod.outlook.com (20.179.50.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Thu, 5 Sep 2019 23:23:07 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a419:3eba:811b:847b]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::a419:3eba:811b:847b%5]) with mapi id 15.20.2263.005; Thu, 5 Sep 2019
 23:23:07 +0000
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
Subject: [PATCH net-next,v2, 1/2] hv_netvsc: Allow scatter-gather feature to
 be tunable
Thread-Topic: [PATCH net-next,v2, 1/2] hv_netvsc: Allow scatter-gather feature
 to be tunable
Thread-Index: AQHVZEDfjwVRccJuCkaZate+TG8SrA==
Date:   Thu, 5 Sep 2019 23:23:07 +0000
Message-ID: <1567725722-33552-2-git-send-email-haiyangz@microsoft.com>
References: <1567725722-33552-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1567725722-33552-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0082.namprd17.prod.outlook.com
 (2603:10b6:300:c2::20) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75a0b617-4999-4bbe-ff29-08d732580219
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1241;
x-ms-traffictypediagnostic: DM6PR21MB1241:|DM6PR21MB1241:|DM6PR21MB1241:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB12414C0B3C18F20A3659DEB4ACBB0@DM6PR21MB1241.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(7846003)(6392003)(4720700003)(6436002)(66066001)(10290500003)(305945005)(25786009)(6512007)(8676002)(256004)(36756003)(8936002)(81156014)(81166006)(5660300002)(52116002)(4326008)(53936002)(478600001)(99286004)(2201001)(7736002)(10090500001)(22452003)(3846002)(71200400001)(6116002)(316002)(71190400001)(66476007)(66556008)(64756008)(66946007)(66446008)(14454004)(2906002)(446003)(11346002)(2616005)(486006)(476003)(186003)(76176011)(26005)(6486002)(386003)(54906003)(110136005)(50226002)(2501003)(6506007)(102836004)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1241;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rGK0SRVUNBeMnrZ6u8pyZVfTTGs+B3/H1EAhef5t9YxK0maPpWCvthxtN522Hla3MgOYvFb8MC2xT34jU6r+m/azEhC5BNLDih6HvZI7gsGd/j2DnjNAsysfyeXq2sZ6+bibvjVGBEAtfEEAkXQCQb/rcAS3d1oN6c9vHIcutMpL1ZDwoWYKWmpuJ0uvovXdCbkaq6vok6+Tzq5EJdN/XAbjaPlNc2g3NxOHAUFdTxiUVK3B3p9sLI97LeBFZl9fPdxi+vS2/6R1NMnrOo3brwNiIXyx2/v9PQ6q5AKhnJ1K7cBGotP3KQqLDCeuHoMcOjdkT9A8cUqDhJ8ehsBN5EEWw2/M1O0exiV6F1o7pJla8qfB640OdhGKt+zGxETUcn4OAJKHRoJtluf6A5XyzrcjMVtOhGldfjAlLYmWGrM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a0b617-4999-4bbe-ff29-08d732580219
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 23:23:07.1342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0AyiJMRbAYkvLoErAZ8JKL4VzLK/v4i+gd/WzQqn0H0IuyZ8YZ1WBg6vkUDi494Xm4ArD5fWoDHZnWCu6Kq9oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1241
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a previous patch, the NETIF_F_SG was missing after the code changes.
That caused the SG feature to be "fixed". This patch includes it into
hw_features, so it is tunable again.

Fixes: 23312a3be999 ("netvsc: negotiate checksum and segmentation parameter=
s")
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

