Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3753DE0138
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfJVJxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:52 -0400
Received: from mail-eopbgr780047.outbound.protection.outlook.com ([40.107.78.47]:41694
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731636AbfJVJxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4FakSicuPE3Ktr5Pe3ndn46LhqlSehNKKDUYJD8L4Pcchzgs1ef+CfS4VKa0URrtQio+xKOfs1CwF66Q7Z4lvis2RmBYzRoqKZQM7h8TX5othqhn9C2zwRsZtqHFoftIz6LX8vVIN1GpwKaW5CGUC45HkRxIhegWZHWpESI9qaLXIrIzPFatvRcmQCXi11eAqIvt5K4uvlVIlxomLn+EhkSI66dnXjeSQ58JXcxeXcqRqJpMJoir8RFVUHpfK6KOwSmk8Big8sUm2i+eGyKL1yaEvJQf8P+h9j9G/IT0URrASkeMzGKgwGlKfi1KGKQbeVl7X3rnpmBXomw21D1IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kVvcP361kusnQOL7tWlU6X4asf0pnsMFdYEi7xxfew=;
 b=IO3Tg3/mZU1UAlJS95nc5DcLWewjq8Dm0/OqVxhb66EtDHHQpT/Wa/dJ7gno3yVhFKs2/eZijGQuZaSc/6V+b4GenEiDNfwWTJoWBnvW2qME0xHF7/Nrobr0tV7X+msvCN6m+Q6gZCovPwIrfvw/+T8JCX5ZJry6ipYhuKA0lW4xqy2eEk6U8D9rqC4czm5kB3aH2EWxC1BzJ4YFWuBI7xkRmhIjZvx4OLei/Plcbn7Xv3VYCaXDoY7qvIVusbRlFoPX6aanMctA1ZJEXe+MnloDDEHdrKZiQdKYI12zQF+AF0JaVhl7MOevlnUYISErauwMMvP9/fo07Nm4h4yAgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kVvcP361kusnQOL7tWlU6X4asf0pnsMFdYEi7xxfew=;
 b=rfdkxEQYcjUp1UWh1MX9o5LI9WpDwNo4iKiDheUKjZr0+3Q5kDckT/UZr7ghLO1g7qbWZZcT6MsfX9YVmEnlVTTPKIiKfoWfDtOJIUeBj+jNTmeO0qcf4+1qV2mH0ws7iV8Fa2V8w7coBXOb1hdzd5LEQjgh/IQ90pHUnK4QNy4=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:43 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:43 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: [PATCH v3 net-next 09/12] net: aquantia: implement get_ts_info
 ethtool
Thread-Topic: [PATCH v3 net-next 09/12] net: aquantia: implement get_ts_info
 ethtool
Thread-Index: AQHViL6WwVBUUcelPka2qlBkJD3//A==
Date:   Tue, 22 Oct 2019 09:53:42 +0000
Message-ID: <037c934c8926d1ff708e1348333fdf91001dbaf0.1571737612.git.igor.russkikh@aquantia.com>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1571737612.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5af56a2-01c1-46be-fb9a-08d756d5b8f1
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB37329C17B19EA8FA22CFD9F998680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:285;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1crDkuR3t0trYHJM8XIiihSk40u3aNR4bHGV/1OGJx0/0iHE4P44rmPuqTXz8Zti8x19Fn2bHOYfqMQDURpS+KOdNbaeXjYW+0rIVcT2y1e3rp5ggcgt616piayc+UeLW90zS5LRRoYgMGWbxLPMUX7Ob13Uqx1k6sDb96omcdSrWWCMLWgkEBIK/GZ8rQZ1QEPus3dzQ8P+gI4vAy+3iNY8OLF5KR7ORMRcTJ/Ac765lpW79HI/bPNt0RB5ysNpWXIM9Jx0NBaHs6HKmrRFDYQ+hlPs7uWcx79xetSFAtToK8lwl+fqNWBCdf9yd2Qt5aX16zikSCREyGRanugRAxTVfc0TnuIdZG4aGT1RZtmjHYVsa3kF5IaW72JtfMr1iIDWd91XtHMzGepoWZdmN1gyjUNGA0SPyJgyKxEfuUzlwnIxa61D9d/N496W0zcc
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5af56a2-01c1-46be-fb9a-08d756d5b8f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:42.8692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ox2pCFSv/3d+m1XyhXyM+m3Bx9Rn6VFwt+5f2LsnVggJm4V+b2rqdTkqG+1+eoBpdpZBC13/XoC1pu4cQYU3BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

Ethtool callback with basic information on what PTP features are supported
by the device.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 35 ++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 24df132384fb..1ae8aabcc41a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_ethtool.c: Definition of ethertool related functions. */
@@ -9,8 +9,11 @@
 #include "aq_ethtool.h"
 #include "aq_nic.h"
 #include "aq_vec.h"
+#include "aq_ptp.h"
 #include "aq_filters.h"
=20
+#include <linux/ptp_clock_kernel.h>
+
 static void aq_ethtool_get_regs(struct net_device *ndev,
 				struct ethtool_regs *regs, void *p)
 {
@@ -377,6 +380,35 @@ static int aq_ethtool_set_wol(struct net_device *ndev,
 	return err;
 }
=20
+static int aq_ethtool_get_ts_info(struct net_device *ndev,
+				  struct ethtool_ts_info *info)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+
+	ethtool_op_get_ts_info(ndev, info);
+
+	if (!aq_nic->aq_ptp)
+		return 0;
+
+	info->so_timestamping |=3D
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->tx_types =3D BIT(HWTSTAMP_TX_OFF) |
+			 BIT(HWTSTAMP_TX_ON);
+
+	info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE);
+
+	info->rx_filters |=3D BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			    BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	info->phc_index =3D ptp_clock_index(aq_ptp_get_ptp_clock(aq_nic->aq_ptp))=
;
+
+	return 0;
+}
+
 static enum hw_atl_fw2x_rate eee_mask_to_ethtool_mask(u32 speed)
 {
 	u32 rate =3D 0;
@@ -604,4 +636,5 @@ const struct ethtool_ops aq_ethtool_ops =3D {
 	.set_link_ksettings  =3D aq_ethtool_set_link_ksettings,
 	.get_coalesce	     =3D aq_ethtool_get_coalesce,
 	.set_coalesce	     =3D aq_ethtool_set_coalesce,
+	.get_ts_info         =3D aq_ethtool_get_ts_info,
 };
--=20
2.17.1

