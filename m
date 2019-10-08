Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1813CCF7A4
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfJHK5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:57:07 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:48528
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730278AbfJHK5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:57:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUWqbom5T3XZBKYz5gosPJq9Lapk8jbKgjnVQSgvK7kHJSOS1WV8f6W3EsiGchY6yvxFRWy/4qf6h+JV0YQB3q21CA06TSbSBZqrWwkW92RRSxl+9/3Bo+PkCW3SS27b+ybEm9sbDIEuFJhn0aycjy30OH1xvYgcmKS09gajhTcfWbesb1Dz2ORhreBakFdO5HQc6fBXSjYfX4YlexNYjnVCy4PkuH5YJ+2peKN/bC+plpPpxRcyvGV/iPBjiOsnnV2pEyAdwgFNjMPu3TNYwRDJXAQHzzvHxuThxFdTiZddb6YFeJzY2hTiXrhkG022qw3ewJS6KhKO/W2/aW8lZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiVhpnkuBQJ2Pgmuj+nkuNA0KDDIfwRoo69A56k/zs8=;
 b=Ks3fzxifKhlGUqd9F5vhCw5U7YsW2kH+Bwnwippv8eNO0pdGvMXRtEq5lFMQCFK1pJrrxoyocIeF7GfgbFfygJZgYBcEXoxNIqq6seVY1BYsU76ACAMtlfA1EMf0n2585rmyNK71J9jnwQR2jLf+DRkQHW5Sz+XV11iOK1Tr3zSzytqLq8fOMI7D0qov1I6ARQHcdV/AbIdNDLLV9jovTBJYTOZduKo/pNxcNLfZ07y8rwtHL7MWeRSafD8KPsPneso9ec2F1nlDSvDAUJ3xm6zReDQVnVJrEZfpalZsgZHMCfHjjYCX7iOkDh1QXeeTyXDr7QYBMMnjXFaWaOb1Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiVhpnkuBQJ2Pgmuj+nkuNA0KDDIfwRoo69A56k/zs8=;
 b=xrWGW2amMgrZGeJgwevGVqyxyzZOMc9uKgcXzCN3WvVj678mC3gFU9z0AFrYVgNbVQ3KIW/bIV3ZZrMnjJnkk28jRx8B6HheDgDwG8xjoo7RonnYHNtHz3WDGiJn7+gy61IlMMhJlKAHZtMSEnC2W+uoBMTf0O0J3axFLMJWuT8=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:52 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:52 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: [PATCH v2 net-next 08/12] net: aquantia: add support for ptp ioctls
Thread-Topic: [PATCH v2 net-next 08/12] net: aquantia: add support for ptp
 ioctls
Thread-Index: AQHVfccXCcYGqZ7qm0Cnpew/aZ65pg==
Date:   Tue, 8 Oct 2019 10:56:52 +0000
Message-ID: <e5810b73ee7a792d464284069b7dec7f775575b8.1570531332.git.igor.russkikh@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570531332.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1257a5f1-7960-40f3-3b9c-08d74bde39b8
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB36666C516CA4FCC9C89BE516989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:13;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N6iKdIVUyLEQysZ0k+iJMccTKQPa52L704aL8i51TC73HfTfYgI0brHaNoRSty3sU94364jnSMoB2CGMiIKfkX39tOb4JEVm3uf0vNPTQy9iYaA169cCZTTnz137dy2ZShHul7Gsya/H3RoRW/9P3aronLIMmOJXA6pUwhXaHblPsobb++t0NTnBSlWFbqIyzwZ7/ZZOOIzrTD6S64FqqvQB3zqmH5vvGIEMQMvIGJRPw/GMlY68S4VOPOi93lV3j6GFdcY2X0AwVrxdLeKMaBFp/yaQ6xCrOMU9YD2Al84BsRCz3X+isv2pOVE5CzN+L/Ia7t4Dprm6qHxAAiOPo466QbcHM7JjEMS6rrSRHvL86m++9bicYG5MO9+2yPMWz+7xJXNA4A+dB9Zm6YOaZWkbFE9tDIVbZhM39fjh/xo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1257a5f1-7960-40f3-3b9c-08d74bde39b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:52.2301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fm+vC+X56Q9Mt2T9lbmU1rjXYQ/ccDah+fz2uiU/6brKaWOZiVdFzkcMnsxy2J15zE1l0XP3o5VCrXu8mxeoRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <egor.pomozov@aquantia.com>

Here we add support for PTP specific IOCTLs of HW timestamp get/set.

These will use filters to configure flows onto the required queue ids.

Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 82 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 64 +++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  6 ++
 3 files changed, 152 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index 0b9ad49b5081..d7937c95457f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -220,6 +220,87 @@ static void aq_ndev_set_multicast_settings(struct net_=
device *ndev)
 	aq_nic_set_multicast_list(aq_nic, ndev);
 }
=20
+static int aq_ndev_config_hwtstamp(struct aq_nic_s *aq_nic,
+				   struct hwtstamp_config *config)
+{
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+	case HWTSTAMP_TX_ON:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		config->rx_filter =3D HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return aq_ptp_hwtstamp_config_set(aq_nic->aq_ptp, config);
+}
+
+static int aq_ndev_hwtstamp_set(struct aq_nic_s *aq_nic, struct ifreq *ifr=
)
+{
+	struct hwtstamp_config config;
+	int ret_val;
+
+	if (!aq_nic->aq_ptp)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	ret_val =3D aq_ndev_config_hwtstamp(aq_nic, &config);
+	if (ret_val)
+		return ret_val;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+	       -EFAULT : 0;
+}
+
+static int aq_ndev_hwtstamp_get(struct aq_nic_s *aq_nic, struct ifreq *ifr=
)
+{
+	struct hwtstamp_config config;
+
+	if (!aq_nic->aq_ptp)
+		return -EOPNOTSUPP;
+
+	aq_ptp_hwtstamp_config_get(aq_nic->aq_ptp, &config);
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+	       -EFAULT : 0;
+}
+
+static int aq_ndev_ioctl(struct net_device *netdev, struct ifreq *ifr, int=
 cmd)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(netdev);
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return aq_ndev_hwtstamp_set(aq_nic, ifr);
+
+	case SIOCGHWTSTAMP:
+		return aq_ndev_hwtstamp_get(aq_nic, ifr);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int aq_ndo_vlan_rx_add_vid(struct net_device *ndev, __be16 proto,
 				  u16 vid)
 {
@@ -257,6 +338,7 @@ static const struct net_device_ops aq_ndev_ops =3D {
 	.ndo_change_mtu =3D aq_ndev_change_mtu,
 	.ndo_set_mac_address =3D aq_ndev_set_mac_address,
 	.ndo_set_features =3D aq_ndev_set_features,
+	.ndo_do_ioctl =3D aq_ndev_ioctl,
 	.ndo_vlan_rx_add_vid =3D aq_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid =3D aq_ndo_vlan_rx_kill_vid,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index e30747d2e7ca..39ba2d20728a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -45,6 +45,8 @@ struct ptp_tx_timeout {
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
=20
+	struct hwtstamp_config hwtstamp_config;
+
 	spinlock_t ptp_lock;
 	spinlock_t ptp_ring_lock;
 	struct ptp_clock *ptp_clock;
@@ -398,6 +400,68 @@ static void aq_ptp_rx_hwtstamp(struct aq_ptp_s *aq_ptp=
, struct sk_buff *skb,
 	aq_ptp_convert_to_hwtstamp(aq_ptp, skb_hwtstamps(skb), timestamp);
 }
=20
+void aq_ptp_hwtstamp_config_get(struct aq_ptp_s *aq_ptp,
+				struct hwtstamp_config *config)
+{
+	*config =3D aq_ptp->hwtstamp_config;
+}
+
+static void aq_ptp_prepare_filters(struct aq_ptp_s *aq_ptp)
+{
+	aq_ptp->udp_filter.cmd =3D HW_ATL_RX_ENABLE_FLTR_L3L4 |
+			       HW_ATL_RX_ENABLE_CMP_PROT_L4 |
+			       HW_ATL_RX_UDP |
+			       HW_ATL_RX_ENABLE_CMP_DEST_PORT_L4 |
+			       HW_ATL_RX_HOST << HW_ATL_RX_ACTION_FL3F4_SHIFT |
+			       HW_ATL_RX_ENABLE_QUEUE_L3L4 |
+			       aq_ptp->ptp_rx.idx << HW_ATL_RX_QUEUE_FL3L4_SHIFT;
+	aq_ptp->udp_filter.p_dst =3D PTP_EV_PORT;
+
+	aq_ptp->eth_type_filter.ethertype =3D ETH_P_1588;
+	aq_ptp->eth_type_filter.queue =3D aq_ptp->ptp_rx.idx;
+}
+
+int aq_ptp_hwtstamp_config_set(struct aq_ptp_s *aq_ptp,
+			       struct hwtstamp_config *config)
+{
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	const struct aq_hw_ops *hw_ops;
+	int err =3D 0;
+
+	hw_ops =3D aq_nic->aq_hw_ops;
+	if (config->tx_type =3D=3D HWTSTAMP_TX_ON ||
+	    config->rx_filter =3D=3D HWTSTAMP_FILTER_PTP_V2_EVENT) {
+		aq_ptp_prepare_filters(aq_ptp);
+		if (hw_ops->hw_filter_l3l4_set) {
+			err =3D hw_ops->hw_filter_l3l4_set(aq_nic->aq_hw,
+							 &aq_ptp->udp_filter);
+		}
+		if (!err && hw_ops->hw_filter_l2_set) {
+			err =3D hw_ops->hw_filter_l2_set(aq_nic->aq_hw,
+						       &aq_ptp->eth_type_filter);
+		}
+		aq_utils_obj_set(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP);
+	} else {
+		aq_ptp->udp_filter.cmd &=3D ~HW_ATL_RX_ENABLE_FLTR_L3L4;
+		if (hw_ops->hw_filter_l3l4_set) {
+			err =3D hw_ops->hw_filter_l3l4_set(aq_nic->aq_hw,
+							 &aq_ptp->udp_filter);
+		}
+		if (!err && hw_ops->hw_filter_l2_clear) {
+			err =3D hw_ops->hw_filter_l2_clear(aq_nic->aq_hw,
+							&aq_ptp->eth_type_filter);
+		}
+		aq_utils_obj_clear(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP);
+	}
+
+	if (err)
+		return -EREMOTEIO;
+
+	aq_ptp->hwtstamp_config =3D *config;
+
+	return 0;
+}
+
 bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index 2c84483fcac1..7a7f36f43ce0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -38,6 +38,12 @@ void aq_ptp_clock_init(struct aq_nic_s *aq_nic);
 int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb);
 void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timestamp);
=20
+/* Must be to check available of PTP before call */
+void aq_ptp_hwtstamp_config_get(struct aq_ptp_s *aq_ptp,
+				struct hwtstamp_config *config);
+int aq_ptp_hwtstamp_config_set(struct aq_ptp_s *aq_ptp,
+			       struct hwtstamp_config *config);
+
 /* Return either ring is belong to PTP or not*/
 bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring);
=20
--=20
2.17.1

