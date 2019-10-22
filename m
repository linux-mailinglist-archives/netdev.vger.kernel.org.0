Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F012DE0134
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbfJVJxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:42 -0400
Received: from mail-eopbgr780047.outbound.protection.outlook.com ([40.107.78.47]:41694
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730312AbfJVJxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjIhA8m70y6/xy9j1jqpGccPfqEGG5+nR0GlmKVd+OT4V+rgQeS2nRlDYoTWmZbMmlQNM7BmjkFbee04wOkCahDuulabSTUz/h0W8QObfH/R+S72a0AdeEOuetZe6yGP4xNLUf13QuXHY7K59oBCQdIFNWzuiNx1slxYkbtBxqDp8tp8abAOl6w/gamuuipUyqKLY7HLm+Fr2STOLhAfF4/AaybSA/t2081PKmtxycG2+S51AtoyQdjvLFaJVJdvU/TVsVd6ECosd1XVHzS7UqUCFE7YJ3Dv9YofbTv1+Q6bILRB+e9dbf/uVwho17m2EZ93w6OdZee4O2Uxu8yANQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lS8mqcqvcs38Ed6c3k3C5bF8rr/o/LKnKZ3VUPkYdIg=;
 b=PMdccMmML7BDrsrt/aPsqAwqrF+Mnjg0Jo5DBKBL2BBDRQ/T319XeST6RWUrn6vvAegAbHAQIsMY9ERwPcVhQj2qfD0WUoAithEV4S2Z7xyu1J6gGFe85IQMEST/EbZwTd6ViDXeO+8hBvKidvs2893KClw0H8/vvysiFbXSuPJbNFVDfap3eq8mavVkOOGZnkmlF65kGwxXXyGwJmT7MxL8GX8FmLlYAbYWUGIHrykd3xFiXYeDIp+cYuI5IL+1Ij+YyI64CaTDNmx63pY6u42fEAxBnRsc590ipDYg9BowGwn1JRk3MPz8vdPZ88AIRfkbUYdnn8YI2rkKACX09g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lS8mqcqvcs38Ed6c3k3C5bF8rr/o/LKnKZ3VUPkYdIg=;
 b=Kz+G7Jp+3j9p/028utUJ3S54wU8Dst5H3M/3n1L3GbJRZ95j+E8dFeq1qHALX2B64wWgDD+v/NCJP1KyL4BbdCTvkNQoXAORubnu07wCbK0pEvVi7Ye4kmeFKdYek8y+X0AkyW7OVkq74EVi2uZ4mPx9x7t52+iT0fEXvoDe8/w=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:36 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:36 +0000
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
Subject: [PATCH v3 net-next 06/12] net: aquantia: implement data PTP datapath
Thread-Topic: [PATCH v3 net-next 06/12] net: aquantia: implement data PTP
 datapath
Thread-Index: AQHViL6S2Kt4CpuEM0yQgCuILkmRmw==
Date:   Tue, 22 Oct 2019 09:53:35 +0000
Message-ID: <13c973abf7a0573fbe8e98d48ab07f7d62d05cb5.1571737612.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: a38c51cc-a128-4cf2-24dc-08d756d5b4bb
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB37322961C87AC9D6B0B38BEF98680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:163;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(30864003)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gYyBNTj2KBfT1xN1QbpKE1U1pdNaB/H8yuSVr0hNBzEh6e4HlqET74Q4AbEA541tXXPjMUsshb8pJ2pXYsBJTV4LbXAoKhhjYCECF3781PdewWU677NQ5WnTVWXyitB3VUkVeNZxlUS3cnIMJpm0/tZJpqwyWfkCmMxRUn8tvU/cUehwZ6FmgJ3AYyyQw+SzmoiZcQACt5clbOeT0mp/nlcIAdKC0PE/qcBGOLvM42pNM2Xa3QhOatf6jqRb49mHxxqXw2zo6cefvdPdyZBVXY6ryAa+D33TDK/WlIJDvlNBjcMI+HP58QdtA4A6LhxjMxBwMyjS/UsqLe/s6i0zib8bOywA0PPV/MvZxdf43tXUSV4SlsomH+3YXQMCencGkKFRtq1F+tTyXLYZhylxaDl/LTOf/rDIBsTqTzDlGVO9mc8D4ZR4Vq/1sW5E87vb
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a38c51cc-a128-4cf2-24dc-08d756d5b4bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:35.8939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n+CJGLrq6xMcwLCQ5BQ/VbeNZPjIPq7Lc27RkCCdvCODfEs/5xEgsJCQL8akm9I4+cpLw+aWmIRueqW5hs51pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <epomozov@marvell.com>

Here we do alloc/free IRQs for PTP rings.
We also implement processing of PTP packets on TX and RX sides.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   4 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  12 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  23 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  18 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   3 +
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |   5 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 534 +++++++++++++++++-
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   |  19 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  31 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |   1 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 100 ++++
 11 files changed, 738 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_cfg.h
index 02f1b70c4e25..8c633caf79d2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_cfg.h: Definition of configuration parameters and constants. */
@@ -27,7 +27,7 @@
=20
 #define AQ_CFG_INTERRUPT_MODERATION_USEC_MAX (0x1FF * 2)
=20
-#define AQ_CFG_IRQ_MASK                      0x1FFU
+#define AQ_CFG_IRQ_MASK                      0x3FFU
=20
 #define AQ_CFG_VECS_MAX   8U
 #define AQ_CFG_TCS_MAX    8U
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index edc7d83ef5e1..5b0f42818033 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -244,6 +244,12 @@ struct aq_hw_ops {
=20
 	int (*hw_rx_tc_mode_get)(struct aq_hw_s *self, u32 *tc_mode);
=20
+	int (*hw_ring_hwts_rx_fill)(struct aq_hw_s *self,
+				    struct aq_ring_s *aq_ring);
+
+	int (*hw_ring_hwts_rx_receive)(struct aq_hw_s *self,
+				       struct aq_ring_s *ring);
+
 	void (*hw_get_ptp_ts)(struct aq_hw_s *self, u64 *stamp);
=20
 	int (*hw_adj_clock_freq)(struct aq_hw_s *self, s32 delta);
@@ -252,6 +258,12 @@ struct aq_hw_ops {
=20
 	int (*hw_set_sys_clock)(struct aq_hw_s *self, u64 time, u64 ts);
=20
+	u16 (*rx_extract_ts)(struct aq_hw_s *self, u8 *p, unsigned int len,
+			     u64 *timestamp);
+
+	int (*extract_hwts)(struct aq_hw_s *self, u8 *p, unsigned int len,
+			    u64 *timestamp);
+
 	int (*hw_set_fc)(struct aq_hw_s *self, u32 fc, u32 tc);
 };
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index bb65dd39f847..f630032af8e1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_main.c: Main file for aQuantia Linux driver. */
@@ -10,10 +10,13 @@
 #include "aq_nic.h"
 #include "aq_pci_func.h"
 #include "aq_ethtool.h"
+#include "aq_ptp.h"
 #include "aq_filters.h"
=20
 #include <linux/netdevice.h>
 #include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
=20
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(AQ_CFG_DRV_VERSION);
@@ -93,6 +96,24 @@ static int aq_ndev_start_xmit(struct sk_buff *skb, struc=
t net_device *ndev)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
=20
+	if (unlikely(aq_utils_obj_test(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP))) {
+		/* Hardware adds the Timestamp for PTPv2 802.AS1
+		 * and PTPv2 IPv4 UDP.
+		 * We have to push even general 320 port messages to the ptp
+		 * queue explicitly. This is a limitation of current firmware
+		 * and hardware PTP design of the chip. Otherwise ptp stream
+		 * will fail to sync
+		 */
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) ||
+		    unlikely((ip_hdr(skb)->version =3D=3D 4) &&
+			     (ip_hdr(skb)->protocol =3D=3D IPPROTO_UDP) &&
+			     ((udp_hdr(skb)->dest =3D=3D htons(319)) ||
+			      (udp_hdr(skb)->dest =3D=3D htons(320)))) ||
+		    unlikely(eth_hdr(skb)->h_proto =3D=3D htons(ETH_P_1588)))
+			return aq_ptp_xmit(aq_nic, skb);
+	}
+
+	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index ecca2c4cf140..65384f45805f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -146,8 +146,11 @@ static int aq_nic_update_link_status(struct aq_nic_s *=
self)
 			self->aq_hw->aq_link_status.mbps);
 		aq_nic_update_interrupt_moderation_settings(self);
=20
-		if (self->aq_ptp)
+		if (self->aq_ptp) {
 			aq_ptp_clock_init(self);
+			aq_ptp_tm_offset_set(self,
+					     self->aq_hw->aq_link_status.mbps);
+		}
=20
 		/* Driver has to update flow control settings on RX block
 		 * on any link event.
@@ -196,6 +199,8 @@ static void aq_nic_service_task(struct work_struct *wor=
k)
 					     service_task);
 	int err;
=20
+	aq_ptp_service_task(self);
+
 	if (aq_utils_obj_test(&self->flags, AQ_NIC_FLAGS_IS_NOT_READY))
 		return;
=20
@@ -408,6 +413,10 @@ int aq_nic_start(struct aq_nic_s *self)
 				goto err_exit;
 		}
=20
+		err =3D aq_ptp_irq_alloc(self);
+		if (err < 0)
+			goto err_exit;
+
 		if (self->aq_nic_cfg.link_irq_vec) {
 			int irqvec =3D pci_irq_vector(self->pdev,
 						   self->aq_nic_cfg.link_irq_vec);
@@ -440,9 +449,8 @@ int aq_nic_start(struct aq_nic_s *self)
 	return err;
 }
=20
-static unsigned int aq_nic_map_skb(struct aq_nic_s *self,
-				   struct sk_buff *skb,
-				   struct aq_ring_s *ring)
+unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
+			    struct aq_ring_s *ring)
 {
 	unsigned int ret =3D 0U;
 	unsigned int nr_frags =3D skb_shinfo(skb)->nr_frags;
@@ -973,6 +981,8 @@ int aq_nic_stop(struct aq_nic_s *self)
 	else
 		aq_pci_func_free_irqs(self);
=20
+	aq_ptp_irq_free(self);
+
 	for (i =3D 0U, aq_vec =3D self->aq_vec[0];
 		self->aq_vecs > i; ++i, aq_vec =3D self->aq_vec[i])
 		aq_vec_stop(aq_vec);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index d0979bba7ed3..576432adda4c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -54,6 +54,7 @@ struct aq_nic_cfg_s {
 #define AQ_NIC_FLAG_STOPPING    0x00000008U
 #define AQ_NIC_FLAG_RESETTING   0x00000010U
 #define AQ_NIC_FLAG_CLOSING     0x00000020U
+#define AQ_NIC_PTP_DPATH_UP     0x02000000U
 #define AQ_NIC_LINK_DOWN        0x04000000U
 #define AQ_NIC_FLAG_ERR_UNPLUG  0x40000000U
 #define AQ_NIC_FLAG_ERR_HW      0x80000000U
@@ -129,6 +130,8 @@ void aq_nic_cfg_start(struct aq_nic_s *self);
 int aq_nic_ndev_register(struct aq_nic_s *self);
 void aq_nic_ndev_free(struct aq_nic_s *self);
 int aq_nic_start(struct aq_nic_s *self);
+unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
+			    struct aq_ring_s *ring);
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb);
 int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void=
 *p);
 int aq_nic_get_regs_count(struct aq_nic_s *self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers=
/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 74b9f3f1da81..e82c96b50373 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_pci_func.c: Definition of PCI functions. */
@@ -269,6 +269,9 @@ static int aq_pci_probe(struct pci_dev *pdev,
 	numvecs =3D min((u8)AQ_CFG_VECS_DEF,
 		      aq_nic_get_cfg(self)->aq_hw_caps->msix_irqs);
 	numvecs =3D min(numvecs, num_online_cpus());
+	/* Request IRQ vector for PTP */
+	numvecs +=3D 1;
+
 	numvecs +=3D AQ_HW_SERVICE_IRQS;
 	/*enable interrupts */
 #if !AQ_CFG_FORCE_LEGACY_INT
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index f2fd0ca14a49..fbb1912a34d7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -8,12 +8,24 @@
  */
=20
 #include <linux/ptp_clock_kernel.h>
+#include <linux/interrupt.h>
 #include <linux/clocksource.h>
=20
 #include "aq_nic.h"
 #include "aq_ptp.h"
 #include "aq_ring.h"
=20
+#define AQ_PTP_TX_TIMEOUT        (HZ *  10)
+
+enum ptp_speed_offsets {
+	ptp_offset_idx_10 =3D 0,
+	ptp_offset_idx_100,
+	ptp_offset_idx_1000,
+	ptp_offset_idx_2500,
+	ptp_offset_idx_5000,
+	ptp_offset_idx_10000,
+};
+
 struct ptp_skb_ring {
 	struct sk_buff **buff;
 	spinlock_t lock;
@@ -22,6 +34,12 @@ struct ptp_skb_ring {
 	unsigned int tail;
 };
=20
+struct ptp_tx_timeout {
+	spinlock_t lock;
+	bool active;
+	unsigned long tx_start;
+};
+
 struct aq_ptp_s {
 	struct aq_nic_s *aq_nic;
 	spinlock_t ptp_lock;
@@ -29,8 +47,16 @@ struct aq_ptp_s {
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_info;
=20
+	atomic_t offset_egress;
+	atomic_t offset_ingress;
+
 	struct aq_ring_param_s ptp_ring_param;
=20
+	struct ptp_tx_timeout ptp_tx_timeout;
+
+	unsigned int idx_vector;
+	struct napi_struct napi;
+
 	struct aq_ring_s ptp_tx;
 	struct aq_ring_s ptp_rx;
 	struct aq_ring_s hwts_rx;
@@ -38,6 +64,101 @@ struct aq_ptp_s {
 	struct ptp_skb_ring skb_ring;
 };
=20
+struct ptp_tm_offset {
+	unsigned int mbps;
+	int egress;
+	int ingress;
+};
+
+static struct ptp_tm_offset ptp_offset[6];
+
+void aq_ptp_tm_offset_set(struct aq_nic_s *aq_nic, unsigned int mbps)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	int i, egress, ingress;
+
+	if (!aq_ptp)
+		return;
+
+	egress =3D 0;
+	ingress =3D 0;
+
+	for (i =3D 0; i < ARRAY_SIZE(ptp_offset); i++) {
+		if (mbps =3D=3D ptp_offset[i].mbps) {
+			egress =3D ptp_offset[i].egress;
+			ingress =3D ptp_offset[i].ingress;
+			break;
+		}
+	}
+
+	atomic_set(&aq_ptp->offset_egress, egress);
+	atomic_set(&aq_ptp->offset_ingress, ingress);
+}
+
+static int __aq_ptp_skb_put(struct ptp_skb_ring *ring, struct sk_buff *skb=
)
+{
+	unsigned int next_head =3D (ring->head + 1) % ring->size;
+
+	if (next_head =3D=3D ring->tail)
+		return -ENOMEM;
+
+	ring->buff[ring->head] =3D skb_get(skb);
+	ring->head =3D next_head;
+
+	return 0;
+}
+
+static int aq_ptp_skb_put(struct ptp_skb_ring *ring, struct sk_buff *skb)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	ret =3D __aq_ptp_skb_put(ring, skb);
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	return ret;
+}
+
+static struct sk_buff *__aq_ptp_skb_get(struct ptp_skb_ring *ring)
+{
+	struct sk_buff *skb;
+
+	if (ring->tail =3D=3D ring->head)
+		return NULL;
+
+	skb =3D ring->buff[ring->tail];
+	ring->tail =3D (ring->tail + 1) % ring->size;
+
+	return skb;
+}
+
+static struct sk_buff *aq_ptp_skb_get(struct ptp_skb_ring *ring)
+{
+	unsigned long flags;
+	struct sk_buff *skb;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	skb =3D __aq_ptp_skb_get(ring);
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	return skb;
+}
+
+static unsigned int aq_ptp_skb_buf_len(struct ptp_skb_ring *ring)
+{
+	unsigned long flags;
+	unsigned int len;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	len =3D (ring->head >=3D ring->tail) ?
+	ring->head - ring->tail :
+	ring->size - ring->tail + ring->head;
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	return len;
+}
+
 static int aq_ptp_skb_ring_init(struct ptp_skb_ring *ring, unsigned int si=
ze)
 {
 	struct sk_buff **buff =3D kmalloc(sizeof(*buff) * size, GFP_KERNEL);
@@ -55,10 +176,75 @@ static int aq_ptp_skb_ring_init(struct ptp_skb_ring *r=
ing, unsigned int size)
 	return 0;
 }
=20
+static void aq_ptp_skb_ring_clean(struct ptp_skb_ring *ring)
+{
+	struct sk_buff *skb;
+
+	while ((skb =3D aq_ptp_skb_get(ring)) !=3D NULL)
+		dev_kfree_skb_any(skb);
+}
+
 static void aq_ptp_skb_ring_release(struct ptp_skb_ring *ring)
 {
-	kfree(ring->buff);
-	ring->buff =3D NULL;
+	if (ring->buff) {
+		aq_ptp_skb_ring_clean(ring);
+		kfree(ring->buff);
+		ring->buff =3D NULL;
+	}
+}
+
+static void aq_ptp_tx_timeout_init(struct ptp_tx_timeout *timeout)
+{
+	spin_lock_init(&timeout->lock);
+	timeout->active =3D false;
+}
+
+static void aq_ptp_tx_timeout_start(struct aq_ptp_s *aq_ptp)
+{
+	struct ptp_tx_timeout *timeout =3D &aq_ptp->ptp_tx_timeout;
+	unsigned long flags;
+
+	spin_lock_irqsave(&timeout->lock, flags);
+	timeout->active =3D true;
+	timeout->tx_start =3D jiffies;
+	spin_unlock_irqrestore(&timeout->lock, flags);
+}
+
+static void aq_ptp_tx_timeout_update(struct aq_ptp_s *aq_ptp)
+{
+	if (!aq_ptp_skb_buf_len(&aq_ptp->skb_ring)) {
+		struct ptp_tx_timeout *timeout =3D &aq_ptp->ptp_tx_timeout;
+		unsigned long flags;
+
+		spin_lock_irqsave(&timeout->lock, flags);
+		timeout->active =3D false;
+		spin_unlock_irqrestore(&timeout->lock, flags);
+	}
+}
+
+static void aq_ptp_tx_timeout_check(struct aq_ptp_s *aq_ptp)
+{
+	struct ptp_tx_timeout *timeout =3D &aq_ptp->ptp_tx_timeout;
+	unsigned long flags;
+	bool timeout_flag;
+
+	timeout_flag =3D false;
+
+	spin_lock_irqsave(&timeout->lock, flags);
+	if (timeout->active) {
+		timeout_flag =3D time_is_before_jiffies(timeout->tx_start +
+						      AQ_PTP_TX_TIMEOUT);
+		/* reset active flag if timeout detected */
+		if (timeout_flag)
+			timeout->active =3D false;
+	}
+	spin_unlock_irqrestore(&timeout->lock, flags);
+
+	if (timeout_flag) {
+		aq_ptp_skb_ring_clean(&aq_ptp->skb_ring);
+		netdev_err(aq_ptp->aq_nic->ndev,
+			   "PTP Timeout. Clearing Tx Timestamp SKBs\n");
+	}
 }
=20
 /* aq_ptp_adjfine
@@ -148,6 +334,263 @@ static int aq_ptp_settime(struct ptp_clock_info *ptp,
 	return 0;
 }
=20
+static void aq_ptp_convert_to_hwtstamp(struct aq_ptp_s *aq_ptp,
+				       struct skb_shared_hwtstamps *hwtstamp,
+				       u64 timestamp)
+{
+	memset(hwtstamp, 0, sizeof(*hwtstamp));
+	hwtstamp->hwtstamp =3D ns_to_ktime(timestamp);
+}
+
+/* aq_ptp_tx_hwtstamp - utility function which checks for TX time stamp
+ * @adapter: the private adapter struct
+ *
+ * if the timestamp is valid, we convert it into the timecounter ns
+ * value, then store that result into the hwtstamps structure which
+ * is passed up the network stack
+ */
+void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timestamp)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	struct sk_buff *skb =3D aq_ptp_skb_get(&aq_ptp->skb_ring);
+	struct skb_shared_hwtstamps hwtstamp;
+
+	if (!skb) {
+		netdev_err(aq_nic->ndev, "have timestamp but tx_queus empty\n");
+		return;
+	}
+
+	timestamp +=3D atomic_read(&aq_ptp->offset_egress);
+	aq_ptp_convert_to_hwtstamp(aq_ptp, &hwtstamp, timestamp);
+	skb_tstamp_tx(skb, &hwtstamp);
+	dev_kfree_skb_any(skb);
+
+	aq_ptp_tx_timeout_update(aq_ptp);
+}
+
+/* aq_ptp_rx_hwtstamp - utility function which checks for RX time stamp
+ * @adapter: pointer to adapter struct
+ * @skb: particular skb to send timestamp with
+ *
+ * if the timestamp is valid, we convert it into the timecounter ns
+ * value, then store that result into the hwtstamps structure which
+ * is passed up the network stack
+ */
+static void aq_ptp_rx_hwtstamp(struct aq_ptp_s *aq_ptp, struct sk_buff *sk=
b,
+			       u64 timestamp)
+{
+	timestamp -=3D atomic_read(&aq_ptp->offset_ingress);
+	aq_ptp_convert_to_hwtstamp(aq_ptp, skb_hwtstamps(skb), timestamp);
+}
+
+bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return false;
+
+	return &aq_ptp->ptp_tx =3D=3D ring ||
+	       &aq_ptp->ptp_rx =3D=3D ring || &aq_ptp->hwts_rx =3D=3D ring;
+}
+
+u16 aq_ptp_extract_ts(struct aq_nic_s *aq_nic, struct sk_buff *skb, u8 *p,
+		      unsigned int len)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	u64 timestamp =3D 0;
+	u16 ret =3D aq_nic->aq_hw_ops->rx_extract_ts(aq_nic->aq_hw,
+						   p, len, &timestamp);
+
+	if (ret > 0)
+		aq_ptp_rx_hwtstamp(aq_ptp, skb, timestamp);
+
+	return ret;
+}
+
+static int aq_ptp_poll(struct napi_struct *napi, int budget)
+{
+	struct aq_ptp_s *aq_ptp =3D container_of(napi, struct aq_ptp_s, napi);
+	struct aq_nic_s *aq_nic =3D aq_ptp->aq_nic;
+	bool was_cleaned =3D false;
+	int work_done =3D 0;
+	int err;
+
+	/* Processing PTP TX traffic */
+	err =3D aq_nic->aq_hw_ops->hw_ring_tx_head_update(aq_nic->aq_hw,
+							&aq_ptp->ptp_tx);
+	if (err < 0)
+		goto err_exit;
+
+	if (aq_ptp->ptp_tx.sw_head !=3D aq_ptp->ptp_tx.hw_head) {
+		aq_ring_tx_clean(&aq_ptp->ptp_tx);
+
+		was_cleaned =3D true;
+	}
+
+	/* Processing HW_TIMESTAMP RX traffic */
+	err =3D aq_nic->aq_hw_ops->hw_ring_hwts_rx_receive(aq_nic->aq_hw,
+							 &aq_ptp->hwts_rx);
+	if (err < 0)
+		goto err_exit;
+
+	if (aq_ptp->hwts_rx.sw_head !=3D aq_ptp->hwts_rx.hw_head) {
+		aq_ring_hwts_rx_clean(&aq_ptp->hwts_rx, aq_nic);
+
+		err =3D aq_nic->aq_hw_ops->hw_ring_hwts_rx_fill(aq_nic->aq_hw,
+							      &aq_ptp->hwts_rx);
+
+		was_cleaned =3D true;
+	}
+
+	/* Processing PTP RX traffic */
+	err =3D aq_nic->aq_hw_ops->hw_ring_rx_receive(aq_nic->aq_hw,
+						    &aq_ptp->ptp_rx);
+	if (err < 0)
+		goto err_exit;
+
+	if (aq_ptp->ptp_rx.sw_head !=3D aq_ptp->ptp_rx.hw_head) {
+		unsigned int sw_tail_old;
+
+		err =3D aq_ring_rx_clean(&aq_ptp->ptp_rx, napi, &work_done, budget);
+		if (err < 0)
+			goto err_exit;
+
+		sw_tail_old =3D aq_ptp->ptp_rx.sw_tail;
+		err =3D aq_ring_rx_fill(&aq_ptp->ptp_rx);
+		if (err < 0)
+			goto err_exit;
+
+		err =3D aq_nic->aq_hw_ops->hw_ring_rx_fill(aq_nic->aq_hw,
+							 &aq_ptp->ptp_rx,
+							 sw_tail_old);
+		if (err < 0)
+			goto err_exit;
+	}
+
+	if (was_cleaned)
+		work_done =3D budget;
+
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
+		aq_nic->aq_hw_ops->hw_irq_enable(aq_nic->aq_hw,
+					1 << aq_ptp->ptp_ring_param.vec_idx);
+	}
+
+err_exit:
+	return work_done;
+}
+
+static irqreturn_t aq_ptp_isr(int irq, void *private)
+{
+	struct aq_ptp_s *aq_ptp =3D private;
+	int err =3D 0;
+
+	if (!aq_ptp) {
+		err =3D -EINVAL;
+		goto err_exit;
+	}
+	napi_schedule(&aq_ptp->napi);
+
+err_exit:
+	return err >=3D 0 ? IRQ_HANDLED : IRQ_NONE;
+}
+
+int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	struct aq_ring_s *ring =3D &aq_ptp->ptp_tx;
+	unsigned long irq_flags;
+	int err =3D NETDEV_TX_OK;
+	unsigned int frags;
+
+	if (skb->len <=3D 0) {
+		dev_kfree_skb_any(skb);
+		goto err_exit;
+	}
+
+	frags =3D skb_shinfo(skb)->nr_frags + 1;
+	/* Frags cannot be bigger 16KB
+	 * because PTP usually works
+	 * without Jumbo even in a background
+	 */
+	if (frags > AQ_CFG_SKB_FRAGS_MAX || frags > aq_ring_avail_dx(ring)) {
+		/* Drop packet because it doesn't make sence to delay it */
+		dev_kfree_skb_any(skb);
+		goto err_exit;
+	}
+
+	err =3D aq_ptp_skb_put(&aq_ptp->skb_ring, skb);
+	if (err) {
+		netdev_err(aq_nic->ndev, "SKB Ring is overflow (%u)!\n",
+			   ring->size);
+		return NETDEV_TX_BUSY;
+	}
+	skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
+	aq_ptp_tx_timeout_start(aq_ptp);
+	skb_tx_timestamp(skb);
+
+	spin_lock_irqsave(&aq_nic->aq_ptp->ptp_ring_lock, irq_flags);
+	frags =3D aq_nic_map_skb(aq_nic, skb, ring);
+
+	if (likely(frags)) {
+		err =3D aq_nic->aq_hw_ops->hw_ring_tx_xmit(aq_nic->aq_hw,
+						       ring, frags);
+		if (err >=3D 0) {
+			++ring->stats.tx.packets;
+			ring->stats.tx.bytes +=3D skb->len;
+		}
+	} else {
+		err =3D NETDEV_TX_BUSY;
+	}
+	spin_unlock_irqrestore(&aq_nic->aq_ptp->ptp_ring_lock, irq_flags);
+
+err_exit:
+	return err;
+}
+
+void aq_ptp_service_task(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+
+	if (!aq_ptp)
+		return;
+
+	aq_ptp_tx_timeout_check(aq_ptp);
+}
+
+int aq_ptp_irq_alloc(struct aq_nic_s *aq_nic)
+{
+	struct pci_dev *pdev =3D aq_nic->pdev;
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	int err =3D 0;
+
+	if (!aq_ptp)
+		return 0;
+
+	if (pdev->msix_enabled || pdev->msi_enabled) {
+		err =3D request_irq(pci_irq_vector(pdev, aq_ptp->idx_vector),
+				  aq_ptp_isr, 0, aq_nic->ndev->name, aq_ptp);
+	} else {
+		err =3D -EINVAL;
+		goto err_exit;
+	}
+
+err_exit:
+	return err;
+}
+
+void aq_ptp_irq_free(struct aq_nic_s *aq_nic)
+{
+	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
+	struct pci_dev *pdev =3D aq_nic->pdev;
+
+	if (!aq_ptp)
+		return;
+
+	free_irq(pci_irq_vector(pdev, aq_ptp->idx_vector), aq_ptp);
+}
+
 int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
@@ -189,6 +632,12 @@ int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
 	err =3D aq_nic->aq_hw_ops->hw_ring_rx_init(aq_nic->aq_hw,
 						 &aq_ptp->hwts_rx,
 						 &aq_ptp->ptp_ring_param);
+	if (err < 0)
+		goto err_exit;
+	err =3D aq_nic->aq_hw_ops->hw_ring_hwts_rx_fill(aq_nic->aq_hw,
+						      &aq_ptp->hwts_rx);
+	if (err < 0)
+		goto err_exit;
=20
 	return err;
=20
@@ -219,6 +668,8 @@ int aq_ptp_ring_start(struct aq_nic_s *aq_nic)
 	if (err < 0)
 		goto err_exit;
=20
+	napi_enable(&aq_ptp->napi);
+
 err_exit:
 	return err;
 }
@@ -234,6 +685,8 @@ void aq_ptp_ring_stop(struct aq_nic_s *aq_nic)
 	aq_nic->aq_hw_ops->hw_ring_rx_stop(aq_nic->aq_hw, &aq_ptp->ptp_rx);
=20
 	aq_nic->aq_hw_ops->hw_ring_rx_stop(aq_nic->aq_hw, &aq_ptp->hwts_rx);
+
+	napi_disable(&aq_ptp->napi);
 }
=20
 void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
@@ -306,6 +759,12 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 		goto err_exit_hwts_rx;
 	}
=20
+	aq_ptp->ptp_ring_param.vec_idx =3D aq_ptp->idx_vector;
+	aq_ptp->ptp_ring_param.cpu =3D aq_ptp->ptp_ring_param.vec_idx +
+			aq_nic_get_cfg(aq_nic)->aq_rss.base_cpu_number;
+	cpumask_set_cpu(aq_ptp->ptp_ring_param.cpu,
+			&aq_ptp->ptp_ring_param.affinity_mask);
+
 	return 0;
=20
 err_exit_hwts_rx:
@@ -347,6 +806,60 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 	.pin_config	=3D NULL,
 };
=20
+#define ptp_offset_init(__idx, __mbps, __egress, __ingress)   do { \
+		ptp_offset[__idx].mbps =3D (__mbps); \
+		ptp_offset[__idx].egress =3D (__egress); \
+		ptp_offset[__idx].ingress =3D (__ingress); } \
+		while (0)
+
+static void aq_ptp_offset_init_from_fw(const struct hw_aq_ptp_offset *offs=
ets)
+{
+	int i;
+
+	/* Load offsets for PTP */
+	for (i =3D 0; i < ARRAY_SIZE(ptp_offset); i++) {
+		switch (i) {
+		/* 100M */
+		case ptp_offset_idx_100:
+			ptp_offset_init(i, 100,
+					offsets->egress_100,
+					offsets->ingress_100);
+			break;
+		/* 1G */
+		case ptp_offset_idx_1000:
+			ptp_offset_init(i, 1000,
+					offsets->egress_1000,
+					offsets->ingress_1000);
+			break;
+		/* 2.5G */
+		case ptp_offset_idx_2500:
+			ptp_offset_init(i, 2500,
+					offsets->egress_2500,
+					offsets->ingress_2500);
+			break;
+		/* 5G */
+		case ptp_offset_idx_5000:
+			ptp_offset_init(i, 5000,
+					offsets->egress_5000,
+					offsets->ingress_5000);
+			break;
+		/* 10G */
+		case ptp_offset_idx_10000:
+			ptp_offset_init(i, 10000,
+					offsets->egress_10000,
+					offsets->ingress_10000);
+			break;
+		}
+	}
+}
+
+static void aq_ptp_offset_init(const struct hw_aq_ptp_offset *offsets)
+{
+	memset(ptp_offset, 0, sizeof(ptp_offset));
+
+	aq_ptp_offset_init_from_fw(offsets);
+}
+
 void aq_ptp_clock_init(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp =3D aq_nic->aq_ptp;
@@ -380,6 +893,8 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int i=
dx_vec)
 		return 0;
 	}
=20
+	aq_ptp_offset_init(&mbox.info.ptp_offset);
+
 	aq_ptp =3D kzalloc(sizeof(*aq_ptp), GFP_KERNEL);
 	if (!aq_ptp) {
 		err =3D -ENOMEM;
@@ -399,6 +914,15 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int =
idx_vec)
 		goto err_exit;
 	}
 	aq_ptp->ptp_clock =3D clock;
+	aq_ptp_tx_timeout_init(&aq_ptp->ptp_tx_timeout);
+
+	atomic_set(&aq_ptp->offset_egress, 0);
+	atomic_set(&aq_ptp->offset_ingress, 0);
+
+	netif_napi_add(aq_nic_get_ndev(aq_nic), &aq_ptp->napi,
+		       aq_ptp_poll, AQ_CFG_NAPI_WEIGHT);
+
+	aq_ptp->idx_vector =3D idx_vec;
=20
 	aq_nic->aq_ptp =3D aq_ptp;
=20
@@ -439,6 +963,12 @@ void aq_ptp_free(struct aq_nic_s *aq_nic)
 	aq_nic->aq_fw_ops->enable_ptp(aq_nic->aq_hw, 0);
 	mutex_unlock(&aq_nic->fwreq_mutex);
=20
+	netif_napi_del(&aq_ptp->napi);
 	kfree(aq_ptp);
 	aq_nic->aq_ptp =3D NULL;
 }
+
+struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_ptp)
+{
+	return aq_ptp->ptp_clock;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index 32350f75e138..2c84483fcac1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -17,6 +17,9 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx=
_vec);
 void aq_ptp_unregister(struct aq_nic_s *aq_nic);
 void aq_ptp_free(struct aq_nic_s *aq_nic);
=20
+int aq_ptp_irq_alloc(struct aq_nic_s *aq_nic);
+void aq_ptp_irq_free(struct aq_nic_s *aq_nic);
+
 int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic);
 void aq_ptp_ring_free(struct aq_nic_s *aq_nic);
=20
@@ -25,6 +28,22 @@ int aq_ptp_ring_start(struct aq_nic_s *aq_nic);
 void aq_ptp_ring_stop(struct aq_nic_s *aq_nic);
 void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic);
=20
+void aq_ptp_service_task(struct aq_nic_s *aq_nic);
+
+void aq_ptp_tm_offset_set(struct aq_nic_s *aq_nic, unsigned int mbps);
+
 void aq_ptp_clock_init(struct aq_nic_s *aq_nic);
=20
+/* Traffic processing functions */
+int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb);
+void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timestamp);
+
+/* Return either ring is belong to PTP or not*/
+bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *ring);
+
+u16 aq_ptp_extract_ts(struct aq_nic_s *aq_nic, struct sk_buff *skb, u8 *p,
+		      unsigned int len);
+
+struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_ptp);
+
 #endif /* AQ_PTP_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c
index 8e84ff6eefe3..f756cc0bbdf0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -10,6 +10,7 @@
 #include "aq_nic.h"
 #include "aq_hw.h"
 #include "aq_hw_utils.h"
+#include "aq_ptp.h"
=20
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
@@ -314,6 +315,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		self->sw_head =3D aq_ring_next_dx(self, self->sw_head),
 		--budget, ++(*work_done)) {
 		struct aq_ring_buff_s *buff =3D &self->buff_ring[self->sw_head];
+		bool is_ptp_ring =3D aq_ptp_ring(self->aq_nic, self);
 		struct aq_ring_buff_s *buff_ =3D NULL;
 		struct sk_buff *skb =3D NULL;
 		unsigned int next_ =3D 0U;
@@ -378,6 +380,11 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err =3D -ENOMEM;
 				goto err_exit;
 			}
+			if (is_ptp_ring)
+				buff->len -=3D
+					aq_ptp_extract_ts(self->aq_nic, skb,
+						aq_buf_vaddr(&buff->rxdata),
+						buff->len);
 			skb_put(skb, buff->len);
 			page_ref_inc(buff->rxdata.page);
 		} else {
@@ -386,6 +393,11 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 				err =3D -ENOMEM;
 				goto err_exit;
 			}
+			if (is_ptp_ring)
+				buff->len -=3D
+					aq_ptp_extract_ts(self->aq_nic, skb,
+						aq_buf_vaddr(&buff->rxdata),
+						buff->len);
=20
 			hdr_len =3D buff->len;
 			if (hdr_len > AQ_CFG_RX_HDR_SIZE)
@@ -445,8 +457,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		skb_set_hash(skb, buff->rss_hash,
 			     buff->is_hash_l4 ? PKT_HASH_TYPE_L4 :
 			     PKT_HASH_TYPE_NONE);
-
-		skb_record_rx_queue(skb, self->idx);
+		/* Send all PTP traffic to 0 queue */
+		skb_record_rx_queue(skb, is_ptp_ring ? 0 : self->idx);
=20
 		++self->stats.rx.packets;
 		self->stats.rx.bytes +=3D skb->len;
@@ -458,6 +470,21 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 	return err;
 }
=20
+void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic=
)
+{
+	while (self->sw_head !=3D self->hw_head) {
+		u64 ns;
+
+		aq_nic->aq_hw_ops->extract_hwts(aq_nic->aq_hw,
+						self->dx_ring +
+						(self->sw_head * self->dx_size),
+						self->dx_size, &ns);
+		aq_ptp_tx_hwtstamp(aq_nic, ns);
+
+		self->sw_head =3D aq_ring_next_dx(self, self->sw_head);
+	}
+}
+
 int aq_ring_rx_fill(struct aq_ring_s *self)
 {
 	unsigned int page_order =3D self->page_order;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.h
index 068689f44bc9..be3702a4dcc9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -177,5 +177,6 @@ int aq_ring_rx_fill(struct aq_ring_s *self);
 struct aq_ring_s *aq_ring_hwts_rx_alloc(struct aq_ring_s *self,
 		struct aq_nic_s *aq_nic, unsigned int idx,
 		unsigned int size, unsigned int dx_size);
+void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic=
);
=20
 #endif /* AQ_RING_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 55c7f9985692..bd9e5a598657 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -682,6 +682,46 @@ static int hw_atl_b0_hw_ring_rx_fill(struct aq_hw_s *s=
elf,
 	return aq_hw_err_from_flags(self);
 }
=20
+static int hw_atl_b0_hw_ring_hwts_rx_fill(struct aq_hw_s *self,
+					  struct aq_ring_s *ring)
+{
+	unsigned int i;
+
+	for (i =3D aq_ring_avail_dx(ring); i--;
+			ring->sw_tail =3D aq_ring_next_dx(ring, ring->sw_tail)) {
+		struct hw_atl_rxd_s *rxd =3D
+			(struct hw_atl_rxd_s *)
+			&ring->dx_ring[ring->sw_tail * HW_ATL_B0_RXD_SIZE];
+
+		rxd->buf_addr =3D ring->dx_ring_pa + ring->size * ring->dx_size;
+		rxd->hdr_addr =3D 0U;
+	}
+	/* Make sure descriptors are updated before bump tail*/
+	wmb();
+
+	hw_atl_reg_rx_dma_desc_tail_ptr_set(self, ring->sw_tail, ring->idx);
+
+	return aq_hw_err_from_flags(self);
+}
+
+static int hw_atl_b0_hw_ring_hwts_rx_receive(struct aq_hw_s *self,
+					     struct aq_ring_s *ring)
+{
+	while (ring->hw_head !=3D ring->sw_tail) {
+		struct hw_atl_rxd_hwts_wb_s *hwts_wb =3D
+			(struct hw_atl_rxd_hwts_wb_s *)
+			(ring->dx_ring + (ring->hw_head * HW_ATL_B0_RXD_SIZE));
+
+		/* RxD is not done */
+		if (!(hwts_wb->sec_lw0 & 0x1U))
+			break;
+
+		ring->hw_head =3D aq_ring_next_dx(ring, ring->hw_head);
+	}
+
+	return aq_hw_err_from_flags(self);
+}
+
 static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 					    struct aq_ring_s *ring)
 {
@@ -1133,6 +1173,61 @@ static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *=
self, s32 ppb)
 	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
 }
=20
+static u16 hw_atl_b0_rx_extract_ts(struct aq_hw_s *self, u8 *p,
+				   unsigned int len, u64 *timestamp)
+{
+	unsigned int offset =3D 14;
+	struct ethhdr *eth;
+	u64 sec;
+	u8 *ptr;
+	u32 ns;
+
+	if (len <=3D offset || !timestamp)
+		return 0;
+
+	/* The TIMESTAMP in the end of package has following format:
+	 * (big-endian)
+	 *   struct {
+	 *     uint64_t sec;
+	 *     uint32_t ns;
+	 *     uint16_t stream_id;
+	 *   };
+	 */
+	ptr =3D p + (len - offset);
+	memcpy(&sec, ptr, sizeof(sec));
+	ptr +=3D sizeof(sec);
+	memcpy(&ns, ptr, sizeof(ns));
+
+	sec =3D be64_to_cpu(sec) & 0xffffffffffffllu;
+	ns =3D be32_to_cpu(ns);
+	*timestamp =3D sec * NSEC_PER_SEC + ns + self->ptp_clk_offset;
+
+	eth =3D (struct ethhdr *)p;
+
+	return (eth->h_proto =3D=3D htons(ETH_P_1588)) ? 12 : 14;
+}
+
+static int hw_atl_b0_extract_hwts(struct aq_hw_s *self, u8 *p, unsigned in=
t len,
+				  u64 *timestamp)
+{
+	struct hw_atl_rxd_hwts_wb_s *hwts_wb =3D (struct hw_atl_rxd_hwts_wb_s *)p=
;
+	u64 tmp, sec, ns;
+
+	sec =3D 0;
+	tmp =3D (hwts_wb->sec_lw0 >> 2) & 0x3ff;
+	sec +=3D tmp;
+	tmp =3D (u64)((hwts_wb->sec_lw1 >> 16) & 0xffff) << 10;
+	sec +=3D tmp;
+	tmp =3D (u64)(hwts_wb->sec_hw & 0xfff) << 26;
+	sec +=3D tmp;
+	tmp =3D (u64)((hwts_wb->sec_hw >> 22) & 0x3ff) << 38;
+	sec +=3D tmp;
+	ns =3D sec * NSEC_PER_SEC + hwts_wb->ns;
+	if (timestamp)
+		*timestamp =3D ns + self->ptp_clk_offset;
+	return 0;
+}
+
 static int hw_atl_b0_hw_fl3l4_clear(struct aq_hw_s *self,
 				    struct aq_rx_filter_l3l4 *data)
 {
@@ -1309,11 +1404,16 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.hw_tx_tc_mode_get       =3D hw_atl_b0_tx_tc_mode_get,
 	.hw_rx_tc_mode_get       =3D hw_atl_b0_rx_tc_mode_get,
=20
+	.hw_ring_hwts_rx_fill        =3D hw_atl_b0_hw_ring_hwts_rx_fill,
+	.hw_ring_hwts_rx_receive     =3D hw_atl_b0_hw_ring_hwts_rx_receive,
+
 	.hw_get_ptp_ts           =3D hw_atl_b0_get_ptp_ts,
 	.hw_adj_sys_clock        =3D hw_atl_b0_adj_sys_clock,
 	.hw_set_sys_clock        =3D hw_atl_b0_set_sys_clock,
 	.hw_adj_clock_freq       =3D hw_atl_b0_adj_clock_freq,
=20
+	.rx_extract_ts           =3D hw_atl_b0_rx_extract_ts,
+	.extract_hwts            =3D hw_atl_b0_extract_hwts,
 	.hw_set_offload          =3D hw_atl_b0_hw_offload_set,
 	.hw_set_fc                   =3D hw_atl_b0_set_fc,
 };
--=20
2.17.1

