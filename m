Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD954D2BF8
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfJJOBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:01:35 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:30660
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726108AbfJJOBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:01:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h13JCNLz+eO345KsBF5Pb49vuVDX6Kxvecoi9GIFtm9tX6F8FupFqP805+36RL/K9GNEgjnrpy/0MTTkogvtyd3uXWdMlNWRcasof9HUC/M4Cp3LZ5WUMDvbjntWN8K5pn2gTBqUA82NO3J18kmfbXXE5iGI9kz3CMukMmi1ZlOy/zfDqG+/Jfeobu4Xy+xfibaOubcLwyZITdFn+/1qAeLmIt6Qt9sXanENuTdjW+7FagNzconiKkF6lHH8g/ahanWv9zHMXaQNXF0jZSmcwqcSruA+/UlfypRBPHJlCBbralfGoJ8qw8ggAFPf2OCIy98OlxT/ApU3wYpyV/tujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTOW4a41kwYYcO6cndXLMDP60wkRoCKLK3OZpxTS8hk=;
 b=QuM/R/8l5ij4b0O+uhJVkTvT58ej2eml+fLLr588TIcQdJz8ucE9rmxipFYMTY7X47pnJH/YGtROOu0PZvHwDq7mIcYQFPNW2oeqNkM0WggRO15UMWFSRuvSAjWu9+x/NwNZTgZ8+p4QQkMSdBOalAA2ebK5wuJBIHnaGDqZEYUB+iGXznobQ682rGTVBw4NQ6oNAGEfiQr+IR3wS3Rlga7Dt3cohlz6nrNvwJNKCnN57psiXfW2ju1FPAN1BxA195Xo3PoBFndN3FxU02GMd9cjRENrHjhKMqmUrV57+HQMPz9zWmKiI6o2qVIcQD9SrxLHKeTlPR2P5s3hr7sgEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTOW4a41kwYYcO6cndXLMDP60wkRoCKLK3OZpxTS8hk=;
 b=V9A0mmcOg0xwqWA1rowih4zKNfdZKaNFQO9TnYfnvOlBx6b/e8BezdYUF9pTTZRnNzJYpGLCEnm5wxxIgPaeR0nNMqrtrRNdQqwG33PIaHZGng+OHf6mfZvB4J5Iti5/IOWWcWt1VejWaCs9PamyCaEC9IEl0zhm78UsjHTgifM=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3826.namprd11.prod.outlook.com (20.178.219.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Thu, 10 Oct 2019 14:01:26 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 14:01:26 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: [PATCH net 4/4] net: aquantia: correctly handle macvlan and multicast
 coexistence
Thread-Topic: [PATCH net 4/4] net: aquantia: correctly handle macvlan and
 multicast coexistence
Thread-Index: AQHVf3M1J21O9K9tC0umiDK0ZBXoDA==
Date:   Thu, 10 Oct 2019 14:01:26 +0000
Message-ID: <4c88f6e02548d8c5bd85c385e50ff664b3e3f6a5.1570708006.git.igor.russkikh@aquantia.com>
References: <cover.1570708006.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570708006.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0003.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::15)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c629750e-e27c-4f60-11c9-08d74d8a5763
x-ms-traffictypediagnostic: BN8PR11MB3826:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3826BDFD6DD71787F4645F0B98940@BN8PR11MB3826.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:131;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(366004)(136003)(39850400004)(199004)(189003)(6512007)(446003)(11346002)(476003)(44832011)(2616005)(486006)(102836004)(26005)(6506007)(386003)(186003)(316002)(2501003)(107886003)(54906003)(6486002)(6436002)(5640700003)(25786009)(3846002)(508600001)(6916009)(14454004)(6116002)(99286004)(8936002)(256004)(50226002)(52116002)(76176011)(1730700003)(81156014)(81166006)(8676002)(305945005)(7736002)(64756008)(66066001)(118296001)(71190400001)(71200400001)(86362001)(2351001)(66946007)(2906002)(4326008)(66476007)(66446008)(5660300002)(36756003)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3826;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l6qWymxubef1RZInQor4QnkxE5TqJeEd8qqS1uf5uvAATndl+qB1HpKWbkE/x2BYyzzQ2LbEqQ4w7/OiY+2WopN5x4jM1QqU2JVBoDLrDkJ/0VTuHyeKK8cV5/OnO/tnOVgtsts605mK88B40hAXU0HjEuctHiHSjURHAOhZ/wr1R1Fs8wsQZ/IZKvTkITBLMf2cxBWJctg08Vu7cfn2L/tSOGru+wYBjzYxOSTabT/yp3qgeVA753/87ykyIfWXRzdiJh2KWK6xu3p9q/CodzhPgbou2ckh+VRy40HoUp0AzP/cXfhzp4H1tXpV6papuQIdF6kQ8O53PNkfSXPoilGuHT2/cZSDQFsIN/7Sqn9Zp81F8MHDa2SGJNmaz/f/GGzfkEz7HxCSve6sPlzZMgcOBBdGXhsulvepG6qAtKM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c629750e-e27c-4f60-11c9-08d74d8a5763
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 14:01:26.5609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZQmDSKMBIV4SRSnz8qPhc8BYBjVRnqYjSuPRcbnNZCs9cg8Q1H7uwk4ERQx/QPvxfOjVfGd5E+oWfM5cHALkhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3826
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

macvlan and multicast handling is now mixed up.
The explicit issue is that macvlan interface gets broken (no traffic)
after clearing MULTICAST flag on the real interface.

We now do separate logic and consider both ALLMULTI and MULTICAST
flags on the device.

Fixes: 11ba961c9161 ("net: aquantia: Fix IFF_ALLMULTI flag functionality")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  4 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 32 +++++++++----------
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  7 ++--
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index b4a0fb281e69..bb65dd39f847 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -194,9 +194,7 @@ static void aq_ndev_set_multicast_settings(struct net_d=
evice *ndev)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
=20
-	aq_nic_set_packet_filter(aq_nic, ndev->flags);
-
-	aq_nic_set_multicast_list(aq_nic, ndev);
+	(void)aq_nic_set_multicast_list(aq_nic, ndev);
 }
=20
 static int aq_ndo_vlan_rx_add_vid(struct net_device *ndev, __be16 proto,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 8f66e7817811..2a18439b36fb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -631,9 +631,12 @@ int aq_nic_set_packet_filter(struct aq_nic_s *self, un=
signed int flags)
=20
 int aq_nic_set_multicast_list(struct aq_nic_s *self, struct net_device *nd=
ev)
 {
-	unsigned int packet_filter =3D self->packet_filter;
+	const struct aq_hw_ops *hw_ops =3D self->aq_hw_ops;
+	struct aq_nic_cfg_s *cfg =3D &self->aq_nic_cfg;
+	unsigned int packet_filter =3D ndev->flags;
 	struct netdev_hw_addr *ha =3D NULL;
 	unsigned int i =3D 0U;
+	int err =3D 0;
=20
 	self->mc_list.count =3D 0;
 	if (netdev_uc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
@@ -641,29 +644,26 @@ int aq_nic_set_multicast_list(struct aq_nic_s *self, =
struct net_device *ndev)
 	} else {
 		netdev_for_each_uc_addr(ha, ndev) {
 			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >=3D AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
 		}
 	}
=20
-	if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |=3D IFF_ALLMULTI;
-	} else {
-		netdev_for_each_mc_addr(ha, ndev) {
-			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >=3D AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
+	cfg->is_mc_list_enabled =3D !!(packet_filter & IFF_MULTICAST);
+	if (cfg->is_mc_list_enabled) {
+		if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
+			packet_filter |=3D IFF_ALLMULTI;
+		} else {
+			netdev_for_each_mc_addr(ha, ndev) {
+				ether_addr_copy(self->mc_list.ar[i++],
+						ha->addr);
+			}
 		}
 	}
=20
 	if (i > 0 && i <=3D AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |=3D IFF_MULTICAST;
 		self->mc_list.count =3D i;
-		self->aq_hw_ops->hw_multicast_list_set(self->aq_hw,
-						       self->mc_list.ar,
-						       self->mc_list.count);
+		err =3D hw_ops->hw_multicast_list_set(self->aq_hw,
+						    self->mc_list.ar,
+						    self->mc_list.count);
 	}
 	return aq_nic_set_packet_filter(self, packet_filter);
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 3459fadb7ddd..2ad3fa6316ce 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -818,14 +818,15 @@ static int hw_atl_b0_hw_packet_filter_set(struct aq_h=
w_s *self,
 				     cfg->is_vlan_force_promisc);
=20
 	hw_atl_rpfl2multicast_flr_en_set(self,
-					 IS_FILTER_ENABLED(IFF_ALLMULTI), 0);
+					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					 IS_FILTER_ENABLED(IFF_MULTICAST), 0);
=20
 	hw_atl_rpfl2_accept_all_mc_packets_set(self,
-					       IS_FILTER_ENABLED(IFF_ALLMULTI));
+					      IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					      IS_FILTER_ENABLED(IFF_MULTICAST));
=20
 	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
=20
-	cfg->is_mc_list_enabled =3D IS_FILTER_ENABLED(IFF_MULTICAST);
=20
 	for (i =3D HW_ATL_B0_MAC_MIN; i < HW_ATL_B0_MAC_MAX; ++i)
 		hw_atl_rpfl2_uc_flr_en_set(self,
--=20
2.17.1

