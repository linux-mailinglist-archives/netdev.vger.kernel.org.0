Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08E6D5371
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 02:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbfJMAaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 20:30:25 -0400
Received: from mail-eopbgr790120.outbound.protection.outlook.com ([40.107.79.120]:28971
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727909AbfJMAaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 20:30:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ6Br5WaM9OuTWFe3PWfxz08gDuaDcZUjc/rAt7vW+iAvXmPfBXW4tqrl+Y2ESLpqSjZavV/oxgHTVIXSC+OASoSSdpVNXIu30g8K6YbIpoFIOl577MgUZbgOGO9l0MuM03FULfq9m0D/O352x13Vi56rJXBnQp4oK2MIn04KVgBQH/OsbBn6Bg8YY2g5/9UK8vp9DvsIcPCepa94TolLceJdj266wcVDk6vEwPAbpN6F0CeWp5z6dLJpsr3dN3LyRPLJDXX6Tj6KnoJtcXO0b3WEoLzPSLNAuF+xh/4nOjhz88m2jglxZko8clg1GcJqM985oExLgW22L4L1Jlhxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EG5G7qimE+xE/nYI+QR78uOrIjHq0uVn+zkQGG+GXl8=;
 b=Gy7PnMjwpK84e2xmbR4rnkeUhTnGdEncvIjtn97Mi7f1CU9gck94OdCFTlnUlZSNIsizWjGnA3bQrzxattZBo0XFBFSKFWGPPTerPS58kjNDaShPZnjHlsJ6FD+I0Qj3wHThVPP0HFnKamuUOXL5HvE2rd1xJ2k4SubNJofEzWE6ARkbkoQul6trur/jxso/iXj7ONEnEYA4oRghzaOKc/DmqYO/2nuar8kRuazd3bRfzbWNG3HVr2FulmKdo1sBaQooaZOSoFDbtgWXGamNV3QpGeCOxB6e3XUnQemfDW/ZEKPVBanD/Q0p4zA5DLilZd03O1aBCKSn7lntvhiz6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EG5G7qimE+xE/nYI+QR78uOrIjHq0uVn+zkQGG+GXl8=;
 b=atBv3aWKBStKRqdtc86HeM/9jgil2ZMYV20sgaWlShGTHRmXaIl3CvOR4GfBsYEOE+yKlm1hdSQ7+y9Tiwp3+MmeHyWMLCVcdHJymWyADS92SCDxSgVwuTVfssqFlNQRrcqMbPsEuQoqwq45OEyaMIyx8esazMkwd0S0NWQUbSU=
Received: from SN6PR2101MB1135.namprd21.prod.outlook.com (52.132.114.24) by
 SN6PR2101MB0941.namprd21.prod.outlook.com (52.132.114.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.4; Sun, 13 Oct 2019 00:30:21 +0000
Received: from SN6PR2101MB1135.namprd21.prod.outlook.com
 ([fe80::1cc6:7b31:4489:4fbb]) by SN6PR2101MB1135.namprd21.prod.outlook.com
 ([fe80::1cc6:7b31:4489:4fbb%6]) with mapi id 15.20.2367.012; Sun, 13 Oct 2019
 00:30:21 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "himadrispandya@gmail.com" <himadrispandya@gmail.com>
Subject: [PATCH net-next v2] hv_sock: use HV_HYP_PAGE_SIZE for Hyper-V
 communication
Thread-Topic: [PATCH net-next v2] hv_sock: use HV_HYP_PAGE_SIZE for Hyper-V
 communication
Thread-Index: AQHVgV1l4vYfBVWVdUyd4ivx4Qf29w==
Date:   Sun, 13 Oct 2019 00:30:21 +0000
Message-ID: <1570926595-8877-1-git-send-email-mikelley@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0048.namprd22.prod.outlook.com
 (2603:10b6:300:69::34) To SN6PR2101MB1135.namprd21.prod.outlook.com
 (2603:10b6:805:4::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [131.107.159.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 965f8288-97b2-4d75-ec74-08d74f74881b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: SN6PR2101MB0941:|SN6PR2101MB0941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR2101MB094170C8C752C5E01A089B9CD7910@SN6PR2101MB0941.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 01894AD3B8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(189003)(199004)(26005)(14454004)(81166006)(102836004)(50226002)(8936002)(71190400001)(478600001)(71200400001)(86362001)(2201001)(110136005)(4720700003)(10290500003)(386003)(6506007)(52116002)(4326008)(186003)(99286004)(81156014)(256004)(305945005)(7736002)(2501003)(8676002)(476003)(486006)(1511001)(6436002)(5660300002)(2616005)(2906002)(66066001)(316002)(6116002)(3846002)(36756003)(64756008)(66556008)(66446008)(66476007)(66946007)(25786009)(22452003)(10090500001)(6486002)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0941;H:SN6PR2101MB1135.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kv4mqjfvFdszKLFEZpn4M8SzkiRl8K1Vd5FDJo+qwcYiXKbdeUPO8R5ln/Hf5uSkUT0JL59ShpK7j8evSoFK3rr7GGQ/FQ4g8IgT8MHHWUyGe1KYKyalMNoFHclUJtxNkb1fsISocM6L4FDLcEMMdeoDyXzyBYCPBMfVy7u4Ay6f1wvUGdUTlHcyGUzBh0KZd4jSkaoaYWACFHT3qPi9XF6MlATI4bjvwn1k2omvrFIwPdjwqMDP0keP+u0R2p23xjrM6NvzI/CM/97adv3IDK2txDAL7l+bqAdUNLkBPM2L/zTACJ1JrLLV517M/aHrXu6YWPS8uRJ1rCsz+7dg1bJuAsHSIYPXvsInhHxh8G/OKuK7FxsVg17f9OT/EWieZ8N0uDYQ3unMJd9J/sp5tqb2/e1pQAXy3N1LSOVE+nU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965f8288-97b2-4d75-ec74-08d74f74881b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2019 00:30:21.6415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Vqvz5Z5c+zxQGd33iXL4uZC8uc7CfC9eoWSoTjki+q2PmIANFXHabyqCLyP0Yh+S5mH4cd7ZIYOlOUWVlS8cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Himadri Pandya <himadrispandya@gmail.com>

Current code assumes PAGE_SIZE (the guest page size) is equal
to the page size used to communicate with Hyper-V (which is
always 4K). While this assumption is true on x86, it may not
be true for Hyper-V on other architectures. For example,
Linux on ARM64 may have PAGE_SIZE of 16K or 64K. A new symbol,
HV_HYP_PAGE_SIZE, has been previously introduced to use when
the Hyper-V page size is intended instead of the guest page size.

Make this code work on non-x86 architectures by using the new
HV_HYP_PAGE_SIZE symbol instead of PAGE_SIZE, where appropriate.
Also replace the now redundant PAGE_SIZE_4K with HV_HYP_PAGE_SIZE.
The change has no effect on x86, but lays the groundwork to run
on ARM64 and others.

Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---

Changes in v2:
* Revised commit message and subject [Jakub Kicinski]

---
 net/vmw_vsock/hyperv_transport.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 261521d..d2929ea 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -13,15 +13,16 @@
 #include <linux/hyperv.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
+#include <asm/hyperv-tlfs.h>
=20
 /* Older (VMBUS version 'VERSION_WIN10' or before) Windows hosts have some
- * stricter requirements on the hv_sock ring buffer size of six 4K pages. =
Newer
- * hosts don't have this limitation; but, keep the defaults the same for c=
ompat.
+ * stricter requirements on the hv_sock ring buffer size of six 4K pages.
+ * hyperv-tlfs defines HV_HYP_PAGE_SIZE as 4K. Newer hosts don't have this
+ * limitation; but, keep the defaults the same for compat.
  */
-#define PAGE_SIZE_4K		4096
-#define RINGBUFFER_HVS_RCV_SIZE (PAGE_SIZE_4K * 6)
-#define RINGBUFFER_HVS_SND_SIZE (PAGE_SIZE_4K * 6)
-#define RINGBUFFER_HVS_MAX_SIZE (PAGE_SIZE_4K * 64)
+#define RINGBUFFER_HVS_RCV_SIZE (HV_HYP_PAGE_SIZE * 6)
+#define RINGBUFFER_HVS_SND_SIZE (HV_HYP_PAGE_SIZE * 6)
+#define RINGBUFFER_HVS_MAX_SIZE (HV_HYP_PAGE_SIZE * 64)
=20
 /* The MTU is 16KB per the host side's design */
 #define HVS_MTU_SIZE		(1024 * 16)
@@ -54,7 +55,8 @@ struct hvs_recv_buf {
  * ringbuffer APIs that allow us to directly copy data from userspace buff=
er
  * to VMBus ringbuffer.
  */
-#define HVS_SEND_BUF_SIZE (PAGE_SIZE_4K - sizeof(struct vmpipe_proto_heade=
r))
+#define HVS_SEND_BUF_SIZE \
+		(HV_HYP_PAGE_SIZE - sizeof(struct vmpipe_proto_header))
=20
 struct hvs_send_buf {
 	/* The header before the payload data */
@@ -393,10 +395,10 @@ static void hvs_open_connection(struct vmbus_channel =
*chan)
 	} else {
 		sndbuf =3D max_t(int, sk->sk_sndbuf, RINGBUFFER_HVS_SND_SIZE);
 		sndbuf =3D min_t(int, sndbuf, RINGBUFFER_HVS_MAX_SIZE);
-		sndbuf =3D ALIGN(sndbuf, PAGE_SIZE);
+		sndbuf =3D ALIGN(sndbuf, HV_HYP_PAGE_SIZE);
 		rcvbuf =3D max_t(int, sk->sk_rcvbuf, RINGBUFFER_HVS_RCV_SIZE);
 		rcvbuf =3D min_t(int, rcvbuf, RINGBUFFER_HVS_MAX_SIZE);
-		rcvbuf =3D ALIGN(rcvbuf, PAGE_SIZE);
+		rcvbuf =3D ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
 	}
=20
 	ret =3D vmbus_open(chan, sndbuf, rcvbuf, NULL, 0, hvs_channel_cb,
@@ -670,7 +672,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vs=
k, struct msghdr *msg,
 	ssize_t ret =3D 0;
 	ssize_t bytes_written =3D 0;
=20
-	BUILD_BUG_ON(sizeof(*send_buf) !=3D PAGE_SIZE_4K);
+	BUILD_BUG_ON(sizeof(*send_buf) !=3D HV_HYP_PAGE_SIZE);
=20
 	send_buf =3D kmalloc(sizeof(*send_buf), GFP_KERNEL);
 	if (!send_buf)
--=20
1.8.3.1

