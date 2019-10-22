Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BDFE0131
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbfJVJxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:34 -0400
Received: from mail-eopbgr780077.outbound.protection.outlook.com ([40.107.78.77]:64688
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730312AbfJVJxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BujxX94t8QTzGIWWj2y5hpPWNtSMSyUMJCoXxlOA9PM24gRCcpz571UJIgYavOiC9A1Z25+Ww+60aROi1rJeEv4N4jmAbouZlKU4Mt38nXPpZiFhvZLMU2l1PqrGaPAPGj4NZNFfAS8Vph4de5kpt3OYohHO4iyqW4mdgZ4FyuuKLSFYhKpHi0P46iyz+QBH15v8fVD1HVqIJxwXpjvUrhmS/T8/RLzQZt8+njiZZi9x+IKURmRKea86ScDdALBeBPbph5pnNW2o8RFOmBonRkv/SOnoJ5Lw9ULumAmXAvg89KGvukosAzMmTuslrER+ewd5tOR0SyuZ4Vapvsy0kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/6X21K9eKrDKQ2CSHhnTHciZUBgULdkmVouzuAv7S0=;
 b=ejRdvOf6zw1Nrcu0l5M1ffFbT6KB435UtFzATXVbnJPxQQJUOR4yNyTogNgHMLb6bqsZn9ZtJFiehiy+14KGYYRpNGz0b389f4r+44ykfzrsZ+6oUHw0GveH9ICHOzMou2ER/s9YNepFtz3NTh9BjwH8N/aMUPU28zBNG+yf0me2R6wX4gW/6edYYY5BE/foVJ1fBZ2PLpEfRs8epJTDFnHc7wFHp7NRXcncvU2bNSl3lMFxGR+UZXBb3mAiG2HCzgup2AMHb6t2eQjUgZ/K4v8JDshs3P6m2QAxJ2V0lMtYk9vIgZB437KIQ5og+VKKBaRvzMHjWd9mZGi8Zat2Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/6X21K9eKrDKQ2CSHhnTHciZUBgULdkmVouzuAv7S0=;
 b=nMWLlaZp9vR8+48iSRVVw8lLbEBgDNaCijoXwO6laqOF8GCPZk4uEYG/kjUFZYrnXhKZ4n/3madUhk30DVWC3fTcvXGZwBlPD+HjLlelb5cY32ZelQmm3BTN+ojKG/swVy0y1gnngvPXCKxB4RfNGEg1trUL3bs94jQDtz5zzQE=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:27 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:27 +0000
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
Subject: [PATCH v3 net-next 03/12] net: aquantia: add basic ptp_clock
 callbacks
Thread-Topic: [PATCH v3 net-next 03/12] net: aquantia: add basic ptp_clock
 callbacks
Thread-Index: AQHViL6NHM0ujXxuTUmtM3oOY7k7tQ==
Date:   Tue, 22 Oct 2019 09:53:27 +0000
Message-ID: <cc5ad0d429db914b3615d9a32224e1dc141ba91e.1571737612.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 3f2d0b55-f28c-4bb7-5e36-08d756d5afb3
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3732D04965107BA16D03334398680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:175;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(30864003)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: co02Nj/kS94WrWzhxZA2/5HESHF5iF24H+lcmfwTkdmTbmfEnfegRACc0p2XoT7HBmeWHj4dm6/aPI52fJ+rxGjO6LVAmZjh9XGGPcPKeMHGLWHFdrurQh+hNsC0qzwLe9nos3JBysjSTkrqMvoXSfLEvge1oD4ikf+n9320ivN5JNTLimEfZ6SWVOJ2i/q3PQt7IyrMzbkHk1G53kHWzRu8DSQ4mA3qNaS19t5Ig8/23MJz2rHPLaWmEKXOXNqSfLQH6J+LN8PiwiFlU5gdhY+Ekbgks4vJ1Sy36EQX3PFUqQ8wZkGw16HKVbl/NefEDkF+0e53f/7wgcO9aWYAb/zITmRskWQA7nmIyufboJZY1rwTgUZRXN0qBvKQ1dtxEsuQz3L7NO9sMnM2GCQP3Y7tClzSI98VH/VjHujrC7C2X+3aV95XoACZ7sRu5IH6
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2d0b55-f28c-4bb7-5e36-08d756d5afb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:27.4513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kB7oU0JUw+rE/v4nyPesocBdg/5n39BWCRSvAizVqWYCDVIq8MbtFEZn3UNhky+iCYFq6k9RPanmUNvJTI1eUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

Basic HW functions implemented for adjusting frequency,
adjusting time, getting and setting time.
With these callbacks we now do register ptp clock in the system.

Firmware interface parts are defined for PTP requests and interactions.
Enable/disable PTP counters in HW on clock register/unregister.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  21 ++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   3 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 125 ++++++++++++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 110 ++++++++++++++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  16 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   8 +-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     |  18 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   5 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  30 +++++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  97 +++++++++++---
 10 files changed, 403 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index 53d7478689a0..121e633fc25b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_hw.h: Declaration of abstract interface for NIC hardware specif=
ic
@@ -15,6 +15,9 @@
 #include "aq_rss.h"
 #include "hw_atl/hw_atl_utils.h"
=20
+#define AQ_HW_MAC_COUNTER_HZ   312500000ll
+#define AQ_HW_PHY_COUNTER_HZ   160000000ll
+
 #define AQ_RX_FIRST_LOC_FVLANID     0U
 #define AQ_RX_LAST_LOC_FVLANID	   15U
 #define AQ_RX_FIRST_LOC_FETHERT    16U
@@ -94,6 +97,7 @@ struct aq_stats_s {
 #define AQ_HW_FLAG_STOPPING    0x00000008U
 #define AQ_HW_FLAG_RESETTING   0x00000010U
 #define AQ_HW_FLAG_CLOSING     0x00000020U
+#define AQ_HW_PTP_AVAILABLE    0x01000000U
 #define AQ_HW_LINK_DOWN        0x04000000U
 #define AQ_HW_FLAG_ERR_UNPLUG  0x40000000U
 #define AQ_HW_FLAG_ERR_HW      0x80000000U
@@ -135,6 +139,7 @@ struct aq_hw_s {
 	u32 rpc_addr;
 	u32 rpc_tid;
 	struct hw_atl_utils_fw_rpc rpc;
+	s64 ptp_clk_offset;
 };
=20
 struct aq_ring_s;
@@ -235,6 +240,14 @@ struct aq_hw_ops {
 	int (*hw_set_offload)(struct aq_hw_s *self,
 			      struct aq_nic_cfg_s *aq_nic_cfg);
=20
+	void (*hw_get_ptp_ts)(struct aq_hw_s *self, u64 *stamp);
+
+	int (*hw_adj_clock_freq)(struct aq_hw_s *self, s32 delta);
+
+	int (*hw_adj_sys_clock)(struct aq_hw_s *self, s64 delta);
+
+	int (*hw_set_sys_clock)(struct aq_hw_s *self, u64 time, u64 ts);
+
 	int (*hw_set_fc)(struct aq_hw_s *self, u32 fc, u32 tc);
 };
=20
@@ -267,6 +280,12 @@ struct aq_fw_ops {
 	int (*set_power)(struct aq_hw_s *self, unsigned int power_state,
 			 u8 *mac);
=20
+	int (*send_fw_request)(struct aq_hw_s *self,
+			       const struct hw_fw_request_iface *fw_req,
+			       size_t size);
+
+	void (*enable_ptp)(struct aq_hw_s *self, int enable);
+
 	int (*set_eee_rate)(struct aq_hw_s *self, u32 speed);
=20
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index d283d0bc75a3..dc9769fe762b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -146,6 +146,9 @@ static int aq_nic_update_link_status(struct aq_nic_s *s=
elf)
 			self->aq_hw->aq_link_status.mbps);
 		aq_nic_update_interrupt_moderation_settings(self);
=20
+		if (self->aq_ptp)
+			aq_ptp_clock_init(self);
+
 		/* Driver has to update flow control settings on RX block
 		 * on any link event.
 		 * We should query FW whether it negotiated FC.
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index a320916cced3..02c2a8cd1219 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -15,15 +15,108 @@
=20
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
+	spinlock_t ptp_lock;
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_info;
 };
=20
+/* aq_ptp_adjfine
+ * @ptp: the ptp clock structure
+ * @ppb: parts per billion adjustment from base
+ *
+ * adjust the frequency of the ptp cycle counter by the
+ * indicated ppb from the base frequency.
+ */
+static int aq_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+
+	mutex_lock(&aq_nic->fwreq_mutex);
+	aq_nic->aq_hw_ops->hw_adj_clock_freq(aq_nic->aq_hw,
+					     scaled_ppm_to_ppb(scaled_ppm));
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
+	return 0;
+}
+
+/* aq_ptp_adjtime
+ * @ptp: the ptp clock structure
+ * @delta: offset to adjust the cycle counter by
+ *
+ * adjust the timer by resetting the timecounter structure.
+ */
+static int aq_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	unsigned long flags;
+
+	spin_lock_irqsave(&aq_ptp->ptp_lock, flags);
+	aq_nic->aq_hw_ops->hw_adj_sys_clock(aq_nic->aq_hw, delta);
+	spin_unlock_irqrestore(&aq_ptp->ptp_lock, flags);
+
+	return 0;
+}
+
+/* aq_ptp_gettime
+ * @ptp: the ptp clock structure
+ * @ts: timespec structure to hold the current time value
+ *
+ * read the timecounter and return the correct value on ns,
+ * after converting it into a struct timespec.
+ */
+static int aq_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *t=
s)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	unsigned long flags;
+	u64 ns;
+
+	spin_lock_irqsave(&aq_ptp->ptp_lock, flags);
+	aq_nic->aq_hw_ops->hw_get_ptp_ts(aq_nic->aq_hw, &ns);
+	spin_unlock_irqrestore(&aq_ptp->ptp_lock, flags);
+
+	*ts =3D ns_to_timespec64(ns);
+
+	return 0;
+}
+
+/* aq_ptp_settime
+ * @ptp: the ptp clock structure
+ * @ts: the timespec containing the new time for the cycle counter
+ *
+ * reset the timecounter to use a new base value instead of the kernel
+ * wall timer value.
+ */
+static int aq_ptp_settime(struct ptp_clock_info *ptp,
+			  const struct timespec64 *ts)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(ptp, struct aq_ptp_s, ptp_info);
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	unsigned long flags;
+	u64 ns =3D timespec64_to_ns(ts);
+	u64 now;
+
+	spin_lock_irqsave(&aq_ptp->ptp_lock, flags);
+	aq_nic->aq_hw_ops->hw_get_ptp_ts(aq_nic->aq_hw, &now);
+	aq_nic->aq_hw_ops->hw_adj_sys_clock(aq_nic->aq_hw, (s64)ns - (s64)now);
+
+	spin_unlock_irqrestore(&aq_ptp->ptp_lock, flags);
+
+	return 0;
+}
+
 static struct ptp_clock_info aq_ptp_clock =3D {
 	.owner		=3D THIS_MODULE,
 	.name		=3D "atlantic ptp",
+	.max_adj	=3D 999999999,
 	.n_ext_ts	=3D 0,
 	.pps		=3D 0,
+	.adjfine	=3D aq_ptp_adjfine,
+	.adjtime	=3D aq_ptp_adjtime,
+	.gettime64	=3D aq_ptp_gettime,
+	.settime64	=3D aq_ptp_settime,
 	.n_per_out	=3D 0,
 	.n_pins		=3D 0,
 	.pin_config	=3D NULL,
@@ -32,9 +125,20 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 {
 	struct hw_atl_utils_mbox mbox;
+	struct ptp_clock *clock;
 	struct aq_ptp_s *aq_ptp;
 	int err =3D 0;
=20
+	if (!aq_nic->aq_hw_ops->hw_get_ptp_ts) {
+		aq_nic->aq_ptp =3D NULL;
+		return 0;
+	}
+
+	if (!aq_nic->aq_fw_ops->enable_ptp) {
+		aq_nic->aq_ptp =3D NULL;
+		return 0;
+	}
+
 	hw_atl_utils_mpi_read_stats(aq_nic->aq_hw, &mbox);
=20
 	if (!(mbox.info.caps_ex & BIT(CAPS_EX_PHY_PTP_EN))) {
@@ -50,10 +154,26 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
=20
 	aq_ptp->aq_nic =3D aq_nic;
=20
+	spin_lock_init(&aq_ptp->ptp_lock);
+
 	aq_ptp->ptp_info =3D aq_ptp_clock;
+	clock =3D ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);
+	if (!clock || IS_ERR(clock)) {
+		netdev_err(aq_nic->ndev, "ptp_clock_register failed\n");
+		err =3D PTR_ERR(clock);
+		goto err_exit;
+	}
+	aq_ptp->ptp_clock =3D clock;
=20
 	aq_nic->aq_ptp =3D aq_ptp;
=20
+	/* enable ptp counter */
+	aq_utils_obj_set(&aq_nic->aq_hw->flags, AQ_HW_PTP_AVAILABLE);
+	mutex_lock(&aq_nic->fwreq_mutex);
+	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 1);
+	aq_ptp_clock_init(aq_nic);
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
 	return 0;
=20
 err_exit:
@@ -79,6 +199,11 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 	if (!aq_ptp)
 		return;
=20
+	/* disable ptp */
+	mutex_lock(&aq_nic->fwreq_mutex);
+	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
 	kfree(aq_ptp);
 	aq_nic->aq_ptp =3D NULL;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 2ad3fa6316ce..881caa8ee319 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_b0.c: Definition of Atlantic hardware specific functions. *=
/
@@ -49,6 +49,8 @@
 	.mac_regs_count =3D 88,		  \
 	.hw_alive_check_addr =3D 0x10U
=20
+#define FRAC_PER_NS 0x100000000LL
+
 const struct aq_hw_caps_s hw_atl_b0_caps_aqc100 =3D {
 	DEFAULT_B0_BOARD_BASIC_CAPABILITIES,
 	.media_type =3D AQ_HW_MEDIA_TYPE_FIBRE,
@@ -1005,6 +1007,104 @@ static int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s=
 *self,
 	return aq_hw_err_from_flags(self);
 }
=20
+#define get_ptp_ts_val_u64(self, indx) \
+	((u64)(hw_atl_pcs_ptp_clock_get(self, indx) & 0xffff))
+
+static void hw_atl_b0_get_ptp_ts(struct aq_hw_s *self, u64 *stamp)
+{
+	u64 ns;
+
+	hw_atl_pcs_ptp_clock_read_enable(self, 1);
+	hw_atl_pcs_ptp_clock_read_enable(self, 0);
+	ns =3D (get_ptp_ts_val_u64(self, 0) +
+	      (get_ptp_ts_val_u64(self, 1) << 16)) * NSEC_PER_SEC +
+	     (get_ptp_ts_val_u64(self, 3) +
+	      (get_ptp_ts_val_u64(self, 4) << 16));
+
+	*stamp =3D ns + self->ptp_clk_offset;
+}
+
+static void hw_atl_b0_adj_params_get(u64 freq, s64 adj, u32 *ns, u32 *fns)
+{
+	/* For accuracy, the digit is extended */
+	s64 base_ns =3D ((adj + NSEC_PER_SEC) * NSEC_PER_SEC);
+	u64 nsi_frac =3D 0;
+	u64 nsi;
+
+	base_ns =3D div64_s64(base_ns, freq);
+	nsi =3D div64_u64(base_ns, NSEC_PER_SEC);
+
+	if (base_ns !=3D nsi * NSEC_PER_SEC) {
+		s64 divisor =3D div64_s64((s64)NSEC_PER_SEC * NSEC_PER_SEC,
+					base_ns - nsi * NSEC_PER_SEC);
+		nsi_frac =3D div64_s64(FRAC_PER_NS * NSEC_PER_SEC, divisor);
+	}
+
+	*ns =3D (u32)nsi;
+	*fns =3D (u32)nsi_frac;
+}
+
+static void
+hw_atl_b0_mac_adj_param_calc(struct hw_fw_request_ptp_adj_freq *ptp_adj_fr=
eq,
+			     u64 phyfreq, u64 macfreq)
+{
+	s64 adj_fns_val;
+	s64 fns_in_sec_phy =3D phyfreq * (ptp_adj_freq->fns_phy +
+					FRAC_PER_NS * ptp_adj_freq->ns_phy);
+	s64 fns_in_sec_mac =3D macfreq * (ptp_adj_freq->fns_mac +
+					FRAC_PER_NS * ptp_adj_freq->ns_mac);
+	s64 fault_in_sec_phy =3D FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_phy;
+	s64 fault_in_sec_mac =3D FRAC_PER_NS * NSEC_PER_SEC - fns_in_sec_mac;
+	/* MAC MCP counter freq is macfreq / 4 */
+	s64 diff_in_mcp_overflow =3D (fault_in_sec_mac - fault_in_sec_phy) *
+				   4 * FRAC_PER_NS;
+
+	diff_in_mcp_overflow =3D div64_s64(diff_in_mcp_overflow,
+					 AQ_HW_MAC_COUNTER_HZ);
+	adj_fns_val =3D (ptp_adj_freq->fns_mac + FRAC_PER_NS *
+		       ptp_adj_freq->ns_mac) + diff_in_mcp_overflow;
+
+	ptp_adj_freq->mac_ns_adj =3D div64_s64(adj_fns_val, FRAC_PER_NS);
+	ptp_adj_freq->mac_fns_adj =3D adj_fns_val - ptp_adj_freq->mac_ns_adj *
+				    FRAC_PER_NS;
+}
+
+static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
+{
+	self->ptp_clk_offset +=3D delta;
+
+	return 0;
+}
+
+static int hw_atl_b0_set_sys_clock(struct aq_hw_s *self, u64 time, u64 ts)
+{
+	s64 delta =3D time - (self->ptp_clk_offset + ts);
+
+	return hw_atl_b0_adj_sys_clock(self, delta);
+}
+
+static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *self, s32 ppb)
+{
+	struct hw_fw_request_iface fwreq;
+	size_t size;
+
+	memset(&fwreq, 0, sizeof(fwreq));
+
+	fwreq.msg_id =3D HW_AQ_FW_REQUEST_PTP_ADJ_FREQ;
+	hw_atl_b0_adj_params_get(AQ_HW_MAC_COUNTER_HZ, ppb,
+				 &fwreq.ptp_adj_freq.ns_mac,
+				 &fwreq.ptp_adj_freq.fns_mac);
+	hw_atl_b0_adj_params_get(AQ_HW_PHY_COUNTER_HZ, ppb,
+				 &fwreq.ptp_adj_freq.ns_phy,
+				 &fwreq.ptp_adj_freq.fns_phy);
+	hw_atl_b0_mac_adj_param_calc(&fwreq.ptp_adj_freq,
+				     AQ_HW_PHY_COUNTER_HZ,
+				     AQ_HW_MAC_COUNTER_HZ);
+
+	size =3D sizeof(fwreq.msg_id) + sizeof(fwreq.ptp_adj_freq);
+	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
+}
+
 static int hw_atl_b0_hw_fl3l4_clear(struct aq_hw_s *self,
 				    struct aq_rx_filter_l3l4 *data)
 {
@@ -1177,6 +1277,12 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.hw_get_regs                 =3D hw_atl_utils_hw_get_regs,
 	.hw_get_hw_stats             =3D hw_atl_utils_get_hw_stats,
 	.hw_get_fw_version           =3D hw_atl_utils_get_fw_version,
-	.hw_set_offload              =3D hw_atl_b0_hw_offload_set,
+
+	.hw_get_ptp_ts           =3D hw_atl_b0_get_ptp_ts,
+	.hw_adj_sys_clock        =3D hw_atl_b0_adj_sys_clock,
+	.hw_set_sys_clock        =3D hw_atl_b0_set_sys_clock,
+	.hw_adj_clock_freq       =3D hw_atl_b0_adj_clock_freq,
+
+	.hw_set_offload          =3D hw_atl_b0_hw_offload_set,
 	.hw_set_fc                   =3D hw_atl_b0_set_fc,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 6f340695e6bd..eb982288fc52 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_llh.c: Definitions of bitfield and register access function=
s for
@@ -1526,6 +1526,20 @@ void hw_atl_reg_glb_cpu_scratch_scp_set(struct aq_hw=
_s *aq_hw,
 			glb_cpu_scratch_scp);
 }
=20
+void hw_atl_pcs_ptp_clock_read_enable(struct aq_hw_s *aq_hw,
+				      u32 ptp_clock_read_enable)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_ADR,
+			    HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSK,
+			    HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_SHIFT,
+			    ptp_clock_read_enable);
+}
+
+u32 hw_atl_pcs_ptp_clock_get(struct aq_hw_s *aq_hw, u32 index)
+{
+	return aq_hw_read_reg(aq_hw, HW_ATL_PCS_PTP_TS_VAL_ADDR(index));
+}
+
 void hw_atl_mcp_up_force_intr_set(struct aq_hw_s *aq_hw, u32 up_force_intr=
)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_MCP_UP_FORCE_INTERRUPT_ADR,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index c3ee278c3747..7753ab860c95 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_llh.h: Declarations of bitfield and register access functio=
ns for
@@ -715,6 +715,12 @@ void hw_atl_msm_reg_wr_strobe_set(struct aq_hw_s *aq_h=
w, u32 reg_wr_strobe);
 /* set pci register reset disable */
 void hw_atl_pci_pci_reg_res_dis_set(struct aq_hw_s *aq_hw, u32 pci_reg_res=
_dis);
=20
+/* pcs */
+void hw_atl_pcs_ptp_clock_read_enable(struct aq_hw_s *aq_hw,
+				      u32 ptp_clock_read_enable);
+
+u32 hw_atl_pcs_ptp_clock_get(struct aq_hw_s *aq_hw, u32 index);
+
 /* set uP Force Interrupt */
 void hw_atl_mcp_up_force_intr_set(struct aq_hw_s *aq_hw, u32 up_force_intr=
);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_inter=
nal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index 35887ad89025..65fb74a4d5ea 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_llh_internal.h: Preprocessor definitions
@@ -2440,6 +2440,22 @@
 /* default value of bitfield register write strobe */
 #define HW_ATL_MSM_REG_WR_STROBE_DEFAULT 0x0
=20
+/* register address for bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_ADR 0x00004628
+/* bitmask for bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSK 0x00000010
+/* inverted bitmask for bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSKN 0xFFFFFFEF
+/* lower bit position of bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_SHIFT 4
+/* width of bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_WIDTH 1
+/* default value of bitfield PTP Digital Clock Read Enable */
+#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_DEFAULT 0x0
+
+/* register address for ptp counter reading */
+#define HW_ATL_PCS_PTP_TS_VAL_ADDR(index) (0x00004900 + (index) * 0x4)
+
 /* mif soft reset bitfield definitions
  * preprocessor definitions for the bitfield "soft reset".
  * port=3D"pif_glb_res_i"
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 32512539ae86..6fc5640065bd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -327,8 +327,7 @@ int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self,=
 u32 a,
 	return err;
 }
=20
-static int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 =
*p,
-					 u32 cnt)
+int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32=
 cnt)
 {
 	u32 val;
 	int err =3D 0;
@@ -964,4 +963,6 @@ const struct aq_fw_ops aq_fw_1x_ops =3D {
 	.set_eee_rate =3D NULL,
 	.get_eee_rate =3D NULL,
 	.set_flow_control =3D NULL,
+	.send_fw_request =3D NULL,
+	.enable_ptp =3D NULL,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 766e02c7fd4e..f2eb94f298e2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -279,6 +279,34 @@ struct __packed offload_info {
 	u8 buf[0];
 };
=20
+/* Mailbox FW Request interface */
+struct __packed hw_fw_request_ptp_adj_freq {
+	u32 ns_mac;
+	u32 fns_mac;
+	u32 ns_phy;
+	u32 fns_phy;
+	u32 mac_ns_adj;
+	u32 mac_fns_adj;
+};
+
+struct __packed hw_fw_request_ptp_adj_clock {
+	u32 ns;
+	u32 sec;
+	int sign;
+};
+
+#define HW_AQ_FW_REQUEST_PTP_ADJ_FREQ	         0x12
+#define HW_AQ_FW_REQUEST_PTP_ADJ_CLOCK	         0x13
+
+struct __packed hw_fw_request_iface {
+	u32 msg_id;
+	union {
+		/* PTP FW Request */
+		struct hw_fw_request_ptp_adj_freq ptp_adj_freq;
+		struct hw_fw_request_ptp_adj_clock ptp_adj_clock;
+	};
+};
+
 enum hw_atl_rx_action_with_traffic {
 	HW_ATL_RX_DISCARD,
 	HW_ATL_RX_HOST,
@@ -561,6 +589,8 @@ struct aq_stats_s *hw_atl_utils_get_hw_stats(struct aq_=
hw_s *self);
 int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self, u32 a,
 				  u32 *p, u32 cnt);
=20
+int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32=
 cnt);
+
 int hw_atl_utils_fw_set_wol(struct aq_hw_s *self, bool wol_enabled, u8 *ma=
c);
=20
 int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsigned int rpc_size);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 7bc51f8d6f2f..f649ac949d06 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_utils_fw2x.c: Definition of firmware 2.x functions for
@@ -17,14 +17,17 @@
 #include "hw_atl_utils.h"
 #include "hw_atl_llh.h"
=20
-#define HW_ATL_FW2X_MPI_RPC_ADDR        0x334
+#define HW_ATL_FW2X_MPI_RPC_ADDR         0x334
=20
-#define HW_ATL_FW2X_MPI_MBOX_ADDR       0x360
-#define HW_ATL_FW2X_MPI_EFUSE_ADDR	0x364
-#define HW_ATL_FW2X_MPI_CONTROL_ADDR	0x368
-#define HW_ATL_FW2X_MPI_CONTROL2_ADDR	0x36C
-#define HW_ATL_FW2X_MPI_STATE_ADDR	0x370
-#define HW_ATL_FW2X_MPI_STATE2_ADDR     0x374
+#define HW_ATL_FW2X_MPI_MBOX_ADDR        0x360
+#define HW_ATL_FW2X_MPI_EFUSE_ADDR       0x364
+#define HW_ATL_FW2X_MPI_CONTROL_ADDR     0x368
+#define HW_ATL_FW2X_MPI_CONTROL2_ADDR    0x36C
+#define HW_ATL_FW2X_MPI_STATE_ADDR       0x370
+#define HW_ATL_FW2X_MPI_STATE2_ADDR      0x374
+
+#define HW_ATL_FW3X_EXT_CONTROL_ADDR     0x378
+#define HW_ATL_FW3X_EXT_STATE_ADDR       0x37c
=20
 #define HW_ATL_FW2X_CAP_PAUSE            BIT(CAPS_HI_PAUSE)
 #define HW_ATL_FW2X_CAP_ASYM_PAUSE       BIT(CAPS_HI_ASYMMETRIC_PAUSE)
@@ -444,6 +447,54 @@ static int aq_fw2x_set_power(struct aq_hw_s *self, uns=
igned int power_state,
 	return err;
 }
=20
+static int aq_fw2x_send_fw_request(struct aq_hw_s *self,
+				   const struct hw_fw_request_iface *fw_req,
+				   size_t size)
+{
+	u32 ctrl2, orig_ctrl2;
+	u32 dword_cnt;
+	int err =3D 0;
+	u32 val;
+
+	/* Write data to drvIface Mailbox */
+	dword_cnt =3D size / sizeof(u32);
+	if (size % sizeof(u32))
+		dword_cnt++;
+	err =3D hw_atl_utils_fw_upload_dwords(self, aq_fw2x_rpc_get(self),
+					    (void *)fw_req, dword_cnt);
+	if (err < 0)
+		goto err_exit;
+
+	/* Toggle statistics bit for FW to update */
+	ctrl2 =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
+	orig_ctrl2 =3D ctrl2 & BIT(CAPS_HI_FW_REQUEST);
+	ctrl2 =3D ctrl2 ^ BIT(CAPS_HI_FW_REQUEST);
+	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, ctrl2);
+
+	/* Wait FW to report back */
+	err =3D readx_poll_timeout_atomic(aq_fw2x_state2_get, self, val,
+					orig_ctrl2 !=3D (val &
+						       BIT(CAPS_HI_FW_REQUEST)),
+					1U, 10000U);
+
+err_exit:
+	return err;
+}
+
+static void aq_fw3x_enable_ptp(struct aq_hw_s *self, int enable)
+{
+	u32 ptp_opts =3D aq_hw_read_reg(self, HW_ATL_FW3X_EXT_STATE_ADDR);
+	u32 all_ptp_features =3D BIT(CAPS_EX_PHY_PTP_EN) |
+						   BIT(CAPS_EX_PTP_GPIO_EN);
+
+	if (enable)
+		ptp_opts |=3D all_ptp_features;
+	else
+		ptp_opts &=3D ~all_ptp_features;
+
+	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
+}
+
 static int aq_fw2x_set_eee_rate(struct aq_hw_s *self, u32 speed)
 {
 	u32 mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
@@ -534,19 +585,21 @@ static u32 aq_fw2x_state2_get(struct aq_hw_s *self)
 }
=20
 const struct aq_fw_ops aq_fw_2x_ops =3D {
-	.init =3D aq_fw2x_init,
-	.deinit =3D aq_fw2x_deinit,
-	.reset =3D NULL,
-	.renegotiate =3D aq_fw2x_renegotiate,
-	.get_mac_permanent =3D aq_fw2x_get_mac_permanent,
-	.set_link_speed =3D aq_fw2x_set_link_speed,
-	.set_state =3D aq_fw2x_set_state,
+	.init               =3D aq_fw2x_init,
+	.deinit             =3D aq_fw2x_deinit,
+	.reset              =3D NULL,
+	.renegotiate        =3D aq_fw2x_renegotiate,
+	.get_mac_permanent  =3D aq_fw2x_get_mac_permanent,
+	.set_link_speed     =3D aq_fw2x_set_link_speed,
+	.set_state          =3D aq_fw2x_set_state,
 	.update_link_status =3D aq_fw2x_update_link_status,
-	.update_stats =3D aq_fw2x_update_stats,
-	.get_phy_temp =3D aq_fw2x_get_phy_temp,
-	.set_power =3D aq_fw2x_set_power,
-	.set_eee_rate =3D aq_fw2x_set_eee_rate,
-	.get_eee_rate =3D aq_fw2x_get_eee_rate,
-	.set_flow_control =3D aq_fw2x_set_flow_control,
-	.get_flow_control =3D aq_fw2x_get_flow_control
+	.update_stats       =3D aq_fw2x_update_stats,
+	.get_phy_temp       =3D aq_fw2x_get_phy_temp,
+	.set_power          =3D aq_fw2x_set_power,
+	.set_eee_rate       =3D aq_fw2x_set_eee_rate,
+	.get_eee_rate       =3D aq_fw2x_get_eee_rate,
+	.set_flow_control   =3D aq_fw2x_set_flow_control,
+	.get_flow_control   =3D aq_fw2x_get_flow_control,
+	.send_fw_request    =3D aq_fw2x_send_fw_request,
+	.enable_ptp         =3D aq_fw3x_enable_ptp,
 };
--=20
2.17.1

