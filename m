Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2238E0132
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731618AbfJVJxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:38 -0400
Received: from mail-eopbgr780077.outbound.protection.outlook.com ([40.107.78.77]:64688
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730312AbfJVJxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOrd1h+rq8SENYm1bnCbEz51KnQiMqbc752kmdDIo+4DB09TyrKbo2TsOEdUXrrD//xW41BhVqntPWfozhHNM7ORy/xDCsmzeKa5a8TmURKYlFRCSUlOYCibRq0AT0MZeR+AIr/Y2D7x9yMB8HSGWLZxcFOyxJu7ix7R0MR+1Iln/hIo6lHxQf/xx0S0WfzyuCfGB8pADaAHj9mGJpe2Y9vbbBQa0Bf+CGBu1fdcL8bwjnGhi0R9c+bmMLKkqMtE3p7n8+cliLkO442KukEW194Jn4xBELEi5bVmrknY4Pp0JWDXZShIY97O+3ihm5+Ji07VKIi7wsX+kF3juzlkzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sDucuVc0QacVpZvQ6YgNCaouTS2L8/AV+6/mk2yp0A=;
 b=bhBO8WoKsNrBCCPYwzlL+2mye9Wm2Nzal7rKuioJF7x5IxKQZHaUxmA/qJVd//UwS6UAJqu+k18EGGxWJgE3UDgu4jV7q4pRys4ossKixX5DgYEmebUlyxbrroXTlGYqrrgLfUx+gOAZiqebF4MXzUsYkxWiEDxERY5SlSh2+6v6CN2Z2ih4ClbaMSc7d/cV4+nZbOb0KpJz0DgL8gy8NnfaUxwunffPq5ahe4G0Sk9+y2NUpsUQ09YiFZ5AKVfHLj8waxdaLU3i+g2uueEZWZVndRz593A1QsOCWud6KibDI85u8nX7pP/KmKw1GJl1H7xcQA9XmBnxo3A5t0U8VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sDucuVc0QacVpZvQ6YgNCaouTS2L8/AV+6/mk2yp0A=;
 b=ChKxPd9UVIXGw968FgZ4KpHR/NNadGCe1l6j8JNesUZ0L9wRBFMIHb+xV0HaC8ttMVm6+w14uMjHZp50+FjikYwTZJ4a8+Dg47TvoU6Au+FXqwKGThobOtIkDqA7VFPVEJ1cJywNZyRDlGrVh67Ff5NUCgT9BmJkZDeHOYWK+tE=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:30 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:29 +0000
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
Subject: [PATCH v3 net-next 04/12] net: aquantia: add PTP rings infrastructure
Thread-Topic: [PATCH v3 net-next 04/12] net: aquantia: add PTP rings
 infrastructure
Thread-Index: AQHViL6OdNSo/+lf5UOqBgT4A+ymfQ==
Date:   Tue, 22 Oct 2019 09:53:29 +0000
Message-ID: <855844d84a191bc00b9fb847d665f6e16ab131f5.1571737612.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 80b527cc-7ac5-4781-6c78-08d756d5b114
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3732D6741148376CA044063998680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(30864003)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qRBeB1FCyH6JHyeLvK9Y4M58P+RarG1C4tkMsnBFfYYSEkg2f7wtIL1TqiIxZqiyqSPZfR6uKhlSPgWxak5JtQ7aCZFMVbhrlGWmSE4RhOHkIMfddkTSLArPwB8JpkjfdRMfDD+liRfhRhTziTRBqcnztUGOWejQBeYXM5siOM/BQIWC1D03LgPWd8eYOWBIQUMnLps4+yttGKPP/8KIXhY2PjLgYSbX0YLP+5kWKKXTJ3eaYPS1II7A5xY5dFMffEGExSPXD/w0Wiue4iVv0rD/HBKg2c8Njr9O3RUAfVC44/PFpnQ8BrP3uIXRT2IYk+cvnVs3+9o9WeBl2bT1Vg/zCYVw/FG/eQgoLUGjCqxlBcU2khBeIbvQ70oYobZHC/PiRa7kPpyMnQmfKm9HKY3cqWBjOxn+y672f0joj8yiaME/jUemvLbQv7am3Q8P
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b527cc-7ac5-4781-6c78-08d756d5b114
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:29.7561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3gwBYlQuC52XG5LssX2+Fi/Zz5XqCVsU3mBs4J4acyGYZ99vRMNobCQfvBFotzw4iggFA6O2ebtTtphi4Wmsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

Add implementations of PTP rings alloc/free.

PTP desing on this device uses two separate rings on a separate traffic
class for traffic rx/tx.

Third ring (hwts) is not a traffic ring, but is used only to receive timest=
amps
of the transmitted packets.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   4 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  16 ++
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 235 ++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |   8 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  26 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |   6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  45 +++-
 .../atlantic/hw_atl/hw_atl_b0_internal.h      |   9 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  14 ++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   6 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |   8 +
 11 files changed, 365 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index 121e633fc25b..edc7d83ef5e1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -240,6 +240,10 @@ struct aq_hw_ops {
 	int (*hw_set_offload)(struct aq_hw_s *self,
 			      struct aq_nic_cfg_s *aq_nic_cfg);
=20
+	int (*hw_tx_tc_mode_get)(struct aq_hw_s *self, u32 *tc_mode);
+
+	int (*hw_rx_tc_mode_get)(struct aq_hw_s *self, u32 *tc_mode);
+
 	void (*hw_get_ptp_ts)(struct aq_hw_s *self, u64 *stamp);
=20
 	int (*hw_adj_clock_freq)(struct aq_hw_s *self, s32 delta);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index dc9769fe762b..ecca2c4cf140 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -339,6 +339,14 @@ int aq_nic_init(struct aq_nic_s *self)
 	if (err < 0)
 		goto err_exit;
=20
+	err =3D aq_ptp_ring_alloc(self);
+	if (err < 0)
+		goto err_exit;
+
+	err =3D aq_ptp_ring_init(self);
+	if (err < 0)
+		goto err_exit;
+
 	netif_carrier_off(self->ndev);
=20
 err_exit:
@@ -369,6 +377,10 @@ int aq_nic_start(struct aq_nic_s *self)
 			goto err_exit;
 	}
=20
+	err =3D aq_ptp_ring_start(self);
+	if (err < 0)
+		goto err_exit;
+
 	err =3D self->aq_hw_ops->hw_start(self->aq_hw);
 	if (err < 0)
 		goto err_exit;
@@ -965,6 +977,8 @@ int aq_nic_stop(struct aq_nic_s *self)
 		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
 		aq_vec_stop(aq_vec);
=20
+	aq_ptp_ring_stop(self);
+
 	return self->aq_hw_ops->hw_stop(self->aq_hw);
 }
=20
@@ -981,6 +995,8 @@ void aq_nic_deinit(struct aq_nic_s *self)
 		aq_vec_deinit(aq_vec);
=20
 	aq_ptp_unregister(self);
+	aq_ptp_ring_deinit(self);
+	aq_ptp_ring_free(self);
 	aq_ptp_free(self);
=20
 	if (likely(self->aq_fw_ops->deinit)) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index 02c2a8cd1219..f2fd0ca14a49 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -12,14 +12,55 @@
=20
 #include "aq_nic.h"
 #include "aq_ptp.h"
+#include "aq_ring.h"
+
+struct ptp_skb_ring {
+	struct sk_buff **buff;
+	spinlock_t lock;
+	unsigned int size;
+	unsigned int head;
+	unsigned int tail;
+};
=20
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
 	spinlock_t ptp_lock;
+	spinlock_t ptp_ring_lock;
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_info;
+
+	struct aq_ring_param_s ptp_ring_param;
+
+	struct aq_ring_s ptp_tx;
+	struct aq_ring_s ptp_rx;
+	struct aq_ring_s hwts_rx;
+
+	struct ptp_skb_ring skb_ring;
 };
=20
+static int aq_ptp_skb_ring_init(struct ptp_skb_ring *ring, unsigned int si=
ze)
+{
+	struct sk_buff **buff =3D kmalloc(sizeof(*buff) * size, GFP_KERNEL);
+
+	if (!buff)
+		return -ENOMEM;
+
+	spin_lock_init(&ring->lock);
+
+	ring->buff =3D buff;
+	ring->size =3D size;
+	ring->head =3D 0;
+	ring->tail =3D 0;
+
+	return 0;
+}
+
+static void aq_ptp_skb_ring_release(struct ptp_skb_ring *ring)
+{
+	kfree(ring->buff);
+	ring->buff =3D NULL;
+}
+
 /* aq_ptp_adjfine
  * @ptp: the ptp clock structure
  * @ppb: parts per billion adjustment from base
@@ -107,6 +148,190 @@ static int aq_ptp_settime(struct ptp_clock_info *ptp,
 	return 0;
 }
=20
+int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	int err =3D 0;
+
+	if (!aq_ptp)
+		return 0;
+
+	err =3D aq_ring_init(&aq_ptp->ptp_tx);
+	if (err < 0)
+		goto err_exit;
+	err =3D aq_nic->aq_hw_ops->hw_ring_tx_init(aq_nic->aq_hw,
+						 &aq_ptp->ptp_tx,
+						 &aq_ptp->ptp_ring_param);
+	if (err < 0)
+		goto err_exit;
+
+	err =3D aq_ring_init(&aq_ptp->ptp_rx);
+	if (err < 0)
+		goto err_exit;
+	err =3D aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
+						 &aq_ptp->ptp_rx,
+						 &aq_ptp->ptp_ring_param);
+	if (err < 0)
+		goto err_exit;
+
+	err =3D aq_ring_rx_fill(&aq_ptp->ptp_rx);
+	if (err < 0)
+		goto err_rx_free;
+	err =3D aq_nic->aq_hw_ops->hw_ring_rx_fill(aq_nic->aq_hw,
+						 &aq_ptp->ptp_rx,
+						 0U);
+	if (err < 0)
+		goto err_rx_free;
+
+	err =3D aq_ring_init(&aq_ptp->hwts_rx);
+	if (err < 0)
+		goto err_rx_free;
+	err =3D aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
+						 &aq_ptp->hwts_rx,
+						 &aq_ptp->ptp_ring_param);
+
+	return err;
+
+err_rx_free:
+	aq_ring_rx_deinit(&aq_ptp->ptp_rx);
+err_exit:
+	return err;
+}
+
+int aq_ptp_ring_start(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	int err =3D 0;
+
+	if (!aq_ptp)
+		return 0;
+
+	err =3D aq_nic->aq_hw_ops->hw_ring_tx_start(aq_nic->aq_hw, &aq_ptp->ptp_t=
x);
+	if (err < 0)
+		goto err_exit;
+
+	err =3D aq_nic->aq_hw_ops->hw_ring_rx_start(aq_nic->aq_hw, &aq_ptp->ptp_r=
x);
+	if (err < 0)
+		goto err_exit;
+
+	err =3D aq_nic->aq_hw_ops->hw_ring_rx_start(aq_nic->aq_hw,
+						  &aq_ptp->hwts_rx);
+	if (err < 0)
+		goto err_exit;
+
+err_exit:
+	return err;
+}
+
+void aq_ptp_ring_stop(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return;
+
+	aq_nic->aq_hw_ops->hw_ring_tx_stop(aq_nic->aq_hw, &aq_ptp->ptp_tx);
+	aq_nic->aq_hw_ops->hw_ring_rx_stop(aq_nic->aq_hw, &aq_ptp->ptp_rx);
+
+	aq_nic->aq_hw_ops->hw_ring_rx_stop(aq_nic->aq_hw, &aq_ptp->hwts_rx);
+}
+
+void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp || !aq_ptp->ptp_tx.aq_nic || !aq_ptp->ptp_rx.aq_nic)
+		return;
+
+	aq_ring_tx_clean(&aq_ptp->ptp_tx);
+	aq_ring_rx_deinit(&aq_ptp->ptp_rx);
+}
+
+#define PTP_8TC_RING_IDX             8
+#define PTP_4TC_RING_IDX            16
+#define PTP_HWST_RING_IDX           31
+
+int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	unsigned int tx_ring_idx, rx_ring_idx;
+	struct aq_ring_s *hwts =3D 0;
+	u32 tx_tc_mode, rx_tc_mode;
+	struct aq_ring_s *ring;
+	int err;
+
+	if (!aq_ptp)
+		return 0;
+
+	/* Index must to be 8 (8 TCs) or 16 (4 TCs).
+	 * It depends from Traffic Class mode.
+	 */
+	aq_nic->aq_hw_ops->hw_tx_tc_mode_get(aq_nic->aq_hw, &tx_tc_mode);
+	if (tx_tc_mode =3D=3D 0)
+		tx_ring_idx =3D PTP_8TC_RING_IDX;
+	else
+		tx_ring_idx =3D PTP_4TC_RING_IDX;
+
+	ring =3D aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
+				tx_ring_idx, &aq_nic->aq_nic_cfg);
+	if (!ring) {
+		err =3D -ENOMEM;
+		goto err_exit;
+	}
+
+	aq_nic->aq_hw_ops->hw_rx_tc_mode_get(aq_nic->aq_hw, &rx_tc_mode);
+	if (rx_tc_mode =3D=3D 0)
+		rx_ring_idx =3D PTP_8TC_RING_IDX;
+	else
+		rx_ring_idx =3D PTP_4TC_RING_IDX;
+
+	ring =3D aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
+				rx_ring_idx, &aq_nic->aq_nic_cfg);
+	if (!ring) {
+		err =3D -ENOMEM;
+		goto err_exit_ptp_tx;
+	}
+
+	hwts =3D aq_ring_hwts_rx_alloc(&aq_ptp->hwts_rx, aq_nic, PTP_HWST_RING_ID=
X,
+				     aq_nic->aq_nic_cfg.rxds,
+				     aq_nic->aq_nic_cfg.aq_hw_caps->rxd_size);
+	if (!hwts) {
+		err =3D -ENOMEM;
+		goto err_exit_ptp_rx;
+	}
+
+	err =3D aq_ptp_skb_ring_init(&aq_ptp->skb_ring, aq_nic->aq_nic_cfg.rxds);
+	if (err !=3D 0) {
+		err =3D -ENOMEM;
+		goto err_exit_hwts_rx;
+	}
+
+	return 0;
+
+err_exit_hwts_rx:
+	aq_ring_free(&aq_ptp->hwts_rx);
+err_exit_ptp_rx:
+	aq_ring_free(&aq_ptp->ptp_rx);
+err_exit_ptp_tx:
+	aq_ring_free(&aq_ptp->ptp_tx);
+err_exit:
+	return err;
+}
+
+void aq_ptp_ring_free(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return;
+
+	aq_ring_free(&aq_ptp->ptp_tx);
+	aq_ring_free(&aq_ptp->ptp_rx);
+	aq_ring_free(&aq_ptp->hwts_rx);
+
+	aq_ptp_skb_ring_release(&aq_ptp->skb_ring);
+}
+
 static struct ptp_clock_info aq_ptp_clock =3D {
 	.owner		=3D THIS_MODULE,
 	.name		=3D "atlantic ptp",
@@ -122,6 +347,15 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 	.pin_config	=3D NULL,
 };
=20
+void aq_ptp_clock_init(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	struct timespec64 ts;
+
+	ktime_get_real_ts64(&ts);
+	aq_ptp_settime(&aq_ptp->ptp_info, &ts);
+}
+
 int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 {
 	struct hw_atl_utils_mbox mbox;
@@ -155,6 +389,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int i=
dx_vec)
 	aq_ptp->aq_nic =3D aq_nic;
=20
 	spin_lock_init(&aq_ptp->ptp_lock);
+	spin_lock_init(&aq_ptp->ptp_ring_lock);
=20
 	aq_ptp->ptp_info =3D aq_ptp_clock;
 	clock =3D ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index cea238959b20..32350f75e138 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -17,6 +17,14 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int id=
x_vec);
 void aq_ptp_unregister(struct aq_nic_s *aq_nic);
 void aq_ptp_free(struct aq_nic_s *aq_nic);
=20
+int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic);
+void aq_ptp_ring_free(struct aq_nic_s *aq_nic);
+
+int aq_ptp_ring_init(struct aq_nic_s *aq_nic);
+int aq_ptp_ring_start(struct aq_nic_s *aq_nic);
+void aq_ptp_ring_stop(struct aq_nic_s *aq_nic);
+void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic);
+
 void aq_ptp_clock_init(struct aq_nic_s *aq_nic);
=20
 #endif /* AQ_PTP_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c
index 76bdbe1596d6..8e84ff6eefe3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_ring.c: Definition of functions for Rx/Tx rings. */
@@ -177,6 +177,30 @@ struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *s=
elf,
 	return self;
 }
=20
+struct aq_ring_s *
+aq_ring_hwts_rx_alloc(struct aq_ring_s *self, struct aq_nic_s *aq_nic,
+		      unsigned int idx, unsigned int size, unsigned int dx_size)
+{
+	struct device *dev =3D aq_nic_get_dev(aq_nic);
+	size_t sz =3D size * dx_size + AQ_CFG_RXDS_DEF;
+
+	memset(self, 0, sizeof(*self));
+
+	self->aq_nic =3D aq_nic;
+	self->idx =3D idx;
+	self->size =3D size;
+	self->dx_size =3D dx_size;
+
+	self->dx_ring =3D dma_alloc_coherent(dev, sz, &self->dx_ring_pa,
+					   GFP_KERNEL);
+	if (!self->dx_ring) {
+		aq_ring_free(self);
+		return NULL;
+	}
+
+	return self;
+}
+
 int aq_ring_init(struct aq_ring_s *self)
 {
 	self->hw_head =3D 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.h
index 47abd09d06c2..068689f44bc9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_ring.h: Declaration of functions for Rx/Tx rings. */
@@ -174,4 +174,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		     int budget);
 int aq_ring_rx_fill(struct aq_ring_s *self);
=20
+struct aq_ring_s *aq_ring_hwts_rx_alloc(struct aq_ring_s *self,
+		struct aq_nic_s *aq_nic, unsigned int idx,
+		unsigned int size, unsigned int dx_size);
+
 #endif /* AQ_RING_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 881caa8ee319..55c7f9985692 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -126,13 +126,16 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
=20
-	hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, 0U);
-	hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, 0U);
-	hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, 0U);
-	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, 0U);
+	tc =3D 0;
+
+	/* TX Packet Scheduler Data TC0 */
+	hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, tc);
+	hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, tc);
+	hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
+	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
=20
-	/* Tx buf size */
-	buff_size =3D HW_ATL_B0_TXBUF_MAX;
+	/* Tx buf size TC0 */
+	buff_size =3D HW_ATL_B0_TXBUF_MAX - HW_ATL_B0_PTP_TXBUF_SIZE;
=20
 	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, buff_size, tc);
 	hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self,
@@ -143,10 +146,15 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 						   (buff_size *
 						   (1024 / 32U) * 50U) /
 						   100U, tc);
+	/* Init TC2 for PTP_TX */
+	tc =3D 2;
+
+	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_TXBUF_SIZE,
+					       tc);
=20
 	/* QoS Rx buf size per TC */
 	tc =3D 0;
-	buff_size =3D HW_ATL_B0_RXBUF_MAX;
+	buff_size =3D HW_ATL_B0_RXBUF_MAX - HW_ATL_B0_PTP_RXBUF_SIZE;
=20
 	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, buff_size, tc);
 	hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self,
@@ -160,6 +168,14 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
=20
 	hw_atl_b0_set_fc(self, self->aq_nic_cfg->flow_control, tc);
=20
+	/* Init TC2 for PTP_RX */
+	tc =3D 2;
+
+	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_RXBUF_SIZE,
+					       tc);
+	/* No flow control for PTP */
+	hw_atl_rpb_rx_xoff_en_per_tc_set(self, 0U, tc);
+
 	/* QoS 802.1p priority -> TC mapping */
 	for (i_priority =3D 8U; i_priority--;)
 		hw_atl_rpf_rpb_user_priority_tc_map_set(self, i_priority, 0U);
@@ -1007,6 +1023,18 @@ static int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s =
*self,
 	return aq_hw_err_from_flags(self);
 }
=20
+static int hw_atl_b0_tx_tc_mode_get(struct aq_hw_s *self, u32 *tc_mode)
+{
+	*tc_mode =3D hw_atl_rpb_tps_tx_tc_mode_get(self);
+	return aq_hw_err_from_flags(self);
+}
+
+static int hw_atl_b0_rx_tc_mode_get(struct aq_hw_s *self, u32 *tc_mode)
+{
+	*tc_mode =3D hw_atl_rpb_rpf_rx_traf_class_mode_get(self);
+	return aq_hw_err_from_flags(self);
+}
+
 #define get_ptp_ts_val_u64(self, indx) \
 	((u64)(hw_atl_pcs_ptp_clock_get(self, indx) & 0xffff))
=20
@@ -1278,6 +1306,9 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.hw_get_hw_stats             =3D hw_atl_utils_get_hw_stats,
 	.hw_get_fw_version           =3D hw_atl_utils_get_fw_version,
=20
+	.hw_tx_tc_mode_get       =3D hw_atl_b0_tx_tc_mode_get,
+	.hw_rx_tc_mode_get       =3D hw_atl_b0_rx_tc_mode_get,
+
 	.hw_get_ptp_ts           =3D hw_atl_b0_get_ptp_ts,
 	.hw_adj_sys_clock        =3D hw_atl_b0_adj_sys_clock,
 	.hw_set_sys_clock        =3D hw_atl_b0_set_sys_clock,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_intern=
al.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
index 808d8cd4252a..7ab23a1751d3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0_internal.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_b0_internal.h: Definition of Atlantic B0 chip specific
@@ -64,8 +64,11 @@
 #define HW_ATL_B0_MPI_SPEED_MSK         0xFFFFU
 #define HW_ATL_B0_MPI_SPEED_SHIFT       16U
=20
-#define HW_ATL_B0_TXBUF_MAX  160U
-#define HW_ATL_B0_RXBUF_MAX  320U
+#define HW_ATL_B0_TXBUF_MAX              160U
+#define HW_ATL_B0_PTP_TXBUF_SIZE           8U
+
+#define HW_ATL_B0_RXBUF_MAX              320U
+#define HW_ATL_B0_PTP_RXBUF_SIZE          16U
=20
 #define HW_ATL_B0_RSS_REDIRECTION_MAX 64U
 #define HW_ATL_B0_RSS_REDIRECTION_BITS 3U
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index eb982288fc52..368b5caf3c49 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -572,6 +572,13 @@ void hw_atl_rpb_rpf_rx_traf_class_mode_set(struct aq_h=
w_s *aq_hw,
 			    rx_traf_class_mode);
 }
=20
+u32 hw_atl_rpb_rpf_rx_traf_class_mode_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_RPB_RPF_RX_TC_MODE_ADR,
+			HW_ATL_RPB_RPF_RX_TC_MODE_MSK,
+			HW_ATL_RPB_RPF_RX_TC_MODE_SHIFT);
+}
+
 void hw_atl_rpb_rx_buff_en_set(struct aq_hw_s *aq_hw, u32 rx_buff_en)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_RPB_RX_BUF_EN_ADR,
@@ -1290,6 +1297,13 @@ void hw_atl_tpb_tx_buff_en_set(struct aq_hw_s *aq_hw=
, u32 tx_buff_en)
 			    HW_ATL_TPB_TX_BUF_EN_SHIFT, tx_buff_en);
 }
=20
+u32 hw_atl_rpb_tps_tx_tc_mode_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_TPB_TX_TC_MODE_ADDR,
+			HW_ATL_TPB_TX_TC_MODE_MSK,
+			HW_ATL_TPB_TX_TC_MODE_SHIFT);
+}
+
 void hw_atl_rpb_tps_tx_tc_mode_set(struct aq_hw_s *aq_hw,
 				   u32 tx_traf_class_mode)
 {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index 7753ab860c95..a579864b6ba1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -292,6 +292,9 @@ void hw_atl_rpb_dma_sys_lbk_set(struct aq_hw_s *aq_hw, =
u32 dma_sys_lbk);
 void hw_atl_rpb_rpf_rx_traf_class_mode_set(struct aq_hw_s *aq_hw,
 					   u32 rx_traf_class_mode);
=20
+/* get rx traffic class mode */
+u32 hw_atl_rpb_rpf_rx_traf_class_mode_get(struct aq_hw_s *aq_hw);
+
 /* set rx buffer enable */
 void hw_atl_rpb_rx_buff_en_set(struct aq_hw_s *aq_hw, u32 rx_buff_en);
=20
@@ -605,6 +608,9 @@ void hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(struct a=
q_hw_s *aq_hw,
 void hw_atl_rpb_tps_tx_tc_mode_set(struct aq_hw_s *aq_hw,
 				   u32 tx_traf_class_mode);
=20
+/* get TX Traffic Class Mode */
+u32 hw_atl_rpb_tps_tx_tc_mode_get(struct aq_hw_s *aq_hw);
+
 /* set tx buffer enable */
 void hw_atl_tpb_tx_buff_en_set(struct aq_hw_s *aq_hw, u32 tx_buff_en);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index f2eb94f298e2..77132bda4696 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -44,6 +44,14 @@ struct __packed hw_atl_rxd_wb_s {
 	u16 vlan;
 };
=20
+/* Hardware rx HW TIMESTAMP writeback */
+struct __packed hw_atl_rxd_hwts_wb_s {
+	u32 sec_hw;
+	u32 ns;
+	u32 sec_lw0;
+	u32 sec_lw1;
+};
+
 struct __packed hw_atl_stats_s {
 	u32 uprc;
 	u32 mprc;
--=20
2.17.1

