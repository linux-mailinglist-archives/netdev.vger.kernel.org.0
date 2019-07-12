Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E3966817
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfGLICm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:02:42 -0400
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:39331
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfGLICm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 04:02:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfaThhRUvLWf7mheW9dAnwttD2TS73wwMnrj8DB/1W69mAJkR4AHkdp8Cr6PcpsgsYtgmNm022Q2XL8hnI3XvytnQr9XtJAU3v+PyQo6okahV3XAegCV3agV5ZwtybIVcDvaQKVGqLVLTQi8Vm0DSQK51Cf+EKU3OcnpLlNnW/vptuVUMc6fb08awX7Nx13RYMc/OS4I30Dnac/eEGaUhya8viTwjYyBw1hKJSuS9j1G2GFv6ehG283fScJrTVGCnGmdHfs8ZEg0D21iuGaWYeH4/xipYv1w3/5QiEMnz5p2b3lLqKei1zKOLcEnGUptNTZIDUh0radekFAxVvZyrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubf4wlw6XMXhUtOdr3TRLXqnJmBm/1CH4dyQKRJzBrM=;
 b=Sw0KkxSg2igeJAhmCgXYEmnXZak6YECxvKpAgYjvONyhrwXWKofPGBsBVCzcX0BFkNGhzGo/Lcuzg0CePYeeDNJaufuoHpP58QuMfT1L2CKY48lTBAHo44Mq/LhEMQwXNdBc26wG4iYcejbRSU6waAdyyMiBcsYciac8EP+/qbgLZBHLUdidbFbi1W5iK5SD1lqe91+XQXqxejs3YPqcg3sddnlJt674JYENN2gPBqA95JlLjF6LnGBWUnDz2iGIS/nTOCzxiV00ICgh5KWhptQojAFV+zlVEmC0AX1Jqk+tia94+1XYp+4TF6mTOlzxT7aQUD5fFw/ldXZyc3pDCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubf4wlw6XMXhUtOdr3TRLXqnJmBm/1CH4dyQKRJzBrM=;
 b=jsIXEYayCO8CA4PQI974wVjcsSyL3b7zy+++IV5+zV/5pRM3XQsuE82ggRSdkd3TovW5UepaGhrhaMTz8XpkUJ0UXTg7ablXsR/UZKhElFE0Hhin8itjdfV2x4JbuLvm07k3JAZZajVjiU1/Le2M/LGFyZlVawT1+SscEnV0zwo=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4889.eurprd04.prod.outlook.com (20.176.234.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Fri, 12 Jul 2019 08:02:38 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 08:02:38 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 1/8] can: flexcan: allocate skb in flexcan_mailbox_read
Thread-Topic: [PATCH 1/8] can: flexcan: allocate skb in flexcan_mailbox_read
Thread-Index: AQHVOIgsNA5/gLaLbk685xStj6LiXg==
Date:   Fri, 12 Jul 2019 08:02:38 +0000
Message-ID: <20190712075926.7357-2-qiangqing.zhang@nxp.com>
References: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190712075926.7357-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce99b5e4-2422-4c4e-befc-08d7069f4e60
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4889;
x-ms-traffictypediagnostic: DB7PR04MB4889:
x-microsoft-antispam-prvs: <DB7PR04MB48898FA8F4FF56BB9E35CDD0E6F20@DB7PR04MB4889.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(50226002)(66066001)(2906002)(71190400001)(2616005)(476003)(71200400001)(8936002)(11346002)(25786009)(446003)(1076003)(478600001)(53936002)(305945005)(2501003)(14454004)(486006)(7736002)(6512007)(36756003)(52116002)(76176011)(8676002)(99286004)(102836004)(86362001)(256004)(5660300002)(81156014)(81166006)(26005)(64756008)(66556008)(66446008)(66476007)(386003)(6506007)(66946007)(3846002)(110136005)(4326008)(6116002)(54906003)(186003)(316002)(6486002)(68736007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4889;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 81d9GaYIan6jMzbaPYEmtBU+y6kZeRwwMT7Si8GmI4TTcKSk9VbJvYh5OA/D1HPA+Q7bBSxuf08TGpFo5TEzoX8UblzO9BmueVcP1oAajOi6HE6W5kgQm/D8vJsdRAvxlnfTElmLR7urVtNZ1daCoZTJUmmBqnw29fXG7Ozwl4t5rwxPLu2sS3EKtuyn3DYOXQZzQvmX3MZHomOP7hDuNn4oKWO/cMujHU13eisUqK5DP+vL7U17u4TvBIebUz0afGI5TrwVtYuAPsApLfRrxgWUEYpzNoSHR+YJGBIDfrj0p3kO4fCm5UOGP+iCdYvOjfdtNdweGA0j3GKYEfKvP5/IsXEq4E6jNkbi33/CKpr4/DQi6vvwJjk44fHw9lYhtuTKpba4318TazeUqWZ51LzXHgS2C4EEXIyOhMGdF6A=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce99b5e4-2422-4c4e-befc-08d7069f4e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 08:02:38.3672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to use alloc_canfd_skb() for CAN FD frames and alloc_can_skb()
for CAN classic frames. So we have to alloc skb in flexcan_mailbox_read().

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c      | 38 ++++++++++++++++++++--------------
 drivers/net/can/rx-offload.c   | 29 +++++++-------------------
 include/linux/can/rx-offload.h |  5 +++--
 3 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e35083ff31ee..7e12f3db0915 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -789,14 +789,15 @@ static inline struct flexcan_priv *rx_offload_to_priv=
(struct can_rx_offload *off
 	return container_of(offload, struct flexcan_priv, offload);
 }
=20
-static unsigned int flexcan_mailbox_read(struct can_rx_offload *offload,
-					 struct can_frame *cf,
-					 u32 *timestamp, unsigned int n)
+static unsigned int flexcan_mailbox_read(struct can_rx_offload *offload, b=
ool drop,
+					 struct sk_buff **skb, u32 *timestamp,
+					 unsigned int n)
 {
 	struct flexcan_priv *priv =3D rx_offload_to_priv(offload);
 	struct flexcan_regs __iomem *regs =3D priv->regs;
 	struct flexcan_mb __iomem *mb;
 	u32 reg_ctrl, reg_id, reg_iflag1;
+	struct can_frame *cf =3D NULL;
 	int i;
=20
 	mb =3D flexcan_get_mb(priv, n);
@@ -827,22 +828,27 @@ static unsigned int flexcan_mailbox_read(struct can_r=
x_offload *offload,
 		reg_ctrl =3D priv->read(&mb->can_ctrl);
 	}
=20
-	/* increase timstamp to full 32 bit */
-	*timestamp =3D reg_ctrl << 16;
+	if (!drop)
+		*skb =3D alloc_can_skb(offload->dev, &cf);
=20
-	reg_id =3D priv->read(&mb->can_id);
-	if (reg_ctrl & FLEXCAN_MB_CNT_IDE)
-		cf->can_id =3D ((reg_id >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
-	else
-		cf->can_id =3D (reg_id >> 18) & CAN_SFF_MASK;
+	if (*skb && cf) {
+		/* increase timstamp to full 32 bit */
+		*timestamp =3D reg_ctrl << 16;
=20
-	if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
-		cf->can_id |=3D CAN_RTR_FLAG;
-	cf->can_dlc =3D get_can_dlc((reg_ctrl >> 16) & 0xf);
+		reg_id =3D priv->read(&mb->can_id);
+		if (reg_ctrl & FLEXCAN_MB_CNT_IDE)
+			cf->can_id =3D ((reg_id >> 0) & CAN_EFF_MASK) | CAN_EFF_FLAG;
+		else
+			cf->can_id =3D (reg_id >> 18) & CAN_SFF_MASK;
=20
-	for (i =3D 0; i < cf->can_dlc; i +=3D sizeof(u32)) {
-		__be32 data =3D cpu_to_be32(priv->read(&mb->data[i / sizeof(u32)]));
-		*(__be32 *)(cf->data + i) =3D data;
+		if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
+			cf->can_id |=3D CAN_RTR_FLAG;
+		cf->can_dlc =3D get_can_dlc((reg_ctrl >> 16) & 0xf);
+
+		for (i =3D 0; i < cf->can_dlc; i +=3D sizeof(u32)) {
+			__be32 data =3D cpu_to_be32(priv->read(&mb->data[i / sizeof(u32)]));
+			*(__be32 *)(cf->data + i) =3D data;
+		}
 	}
=20
 	/* mark as read */
diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 2ce4fa8698c7..632919484ff7 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -121,32 +121,19 @@ static int can_rx_offload_compare(struct sk_buff *a, =
struct sk_buff *b)
 static struct sk_buff *can_rx_offload_offload_one(struct can_rx_offload *o=
ffload, unsigned int n)
 {
 	struct sk_buff *skb =3D NULL;
-	struct can_rx_offload_cb *cb;
-	struct can_frame *cf;
-	int ret;
+	u32 timestamp;
=20
 	/* If queue is full or skb not available, read to discard mailbox */
-	if (likely(skb_queue_len(&offload->skb_queue) <=3D
-		   offload->skb_queue_len_max))
-		skb =3D alloc_can_skb(offload->dev, &cf);
+	bool drop =3D unlikely(skb_queue_len(&offload->skb_queue) >
+			     offload->skb_queue_len_max);
=20
-	if (!skb) {
-		struct can_frame cf_overflow;
-		u32 timestamp;
+	if (offload->mailbox_read(offload, drop, &skb, &timestamp, n) && !skb)
+		offload->dev->stats.rx_dropped++;
=20
-		ret =3D offload->mailbox_read(offload, &cf_overflow,
-					    &timestamp, n);
-		if (ret)
-			offload->dev->stats.rx_dropped++;
+	if (skb) {
+		struct can_rx_offload_cb *cb =3D can_rx_offload_get_cb(skb);
=20
-		return NULL;
-	}
-
-	cb =3D can_rx_offload_get_cb(skb);
-	ret =3D offload->mailbox_read(offload, cf, &cb->timestamp, n);
-	if (!ret) {
-		kfree_skb(skb);
-		return NULL;
+		cb->timestamp =3D timestamp;
 	}
=20
 	return skb;
diff --git a/include/linux/can/rx-offload.h b/include/linux/can/rx-offload.=
h
index 8268811a697e..c54d80ef4314 100644
--- a/include/linux/can/rx-offload.h
+++ b/include/linux/can/rx-offload.h
@@ -23,8 +23,9 @@
 struct can_rx_offload {
 	struct net_device *dev;
=20
-	unsigned int (*mailbox_read)(struct can_rx_offload *offload, struct can_f=
rame *cf,
-				     u32 *timestamp, unsigned int mb);
+	unsigned int (*mailbox_read)(struct can_rx_offload *offload, bool drop,
+				     struct sk_buff **skb, u32 *timestamp,
+				     unsigned int mb);
=20
 	struct sk_buff_head skb_queue;
 	u32 skb_queue_len_max;
--=20
2.17.1

