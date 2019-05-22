Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B725272A6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfEVW4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:56:12 -0400
Received: from mail-eopbgr810108.outbound.protection.outlook.com ([40.107.81.108]:4352
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727365AbfEVW4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 18:56:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=N3pkW6insa9pAp/eUXxc9SBAlW6+lVkLV2ukgbYZSUbSSZ9vizQGrsprKX4mKdfYnBJsKz0G8OKjfeDhTHX0jo3KHEYto714D0lhu4140xBknEJYCWDByDfDT43ai1anQMkgBGgne4oJ/Qv1L2MWO3QAOKxZ3AVvKRw50cgQ6D8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIHp25cjr4Qv1JSkBU4oXBD83Bl3PL4GgFPgx/rZLLs=;
 b=SXWu6Kx1Lu03uFvkcfQq8zo+rhMXx23yN2LsMhIThlRjdMYtTQ61fivgHcMR4yc/hHL8/Kda7auMyaviQ5iIxr3I1TZ+XYCkGP5SohLdoM7F/jDicE4dynKDfU+FJ8HWBdyUMYcMMXxkEjfpi4h4+RNXLenQdaJ/tQPiKTPo6x4=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIHp25cjr4Qv1JSkBU4oXBD83Bl3PL4GgFPgx/rZLLs=;
 b=GoXOrZDps/QSvpcb9zeKIIQSB3Ql4Z1LuquvO8kGM0Zh5ODCuYb63HUGo5QHTAhdqH/Gvj/W9GGCVn7PIvUcwZ9395zggr5eliXzICnQLIaFiMNphLFizZxOrnh6vJr1/o4AdkSkvnOcOUvzyxcLYuNStAnX3/SJQHeCzlXYjg0=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0178.namprd21.prod.outlook.com (2603:10b6:404:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1943.3; Wed, 22 May
 2019 22:56:08 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1943.003; Wed, 22 May
 2019 22:56:08 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] hv_sock: perf: Allow the socket buffer size options
 to influence the actual socket buffers
Thread-Topic: [PATCH net-next] hv_sock: perf: Allow the socket buffer size
 options to influence the actual socket buffers
Thread-Index: AdUQ8PsjFNIw2dWyQTKbqbtYd11NLg==
Date:   Wed, 22 May 2019 22:56:07 +0000
Message-ID: <BN6PR21MB04652168EAE5D6D7D39BD4AAC0000@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:2:a4eb:8a21:82ce:5b14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2c9c030-5778-4d13-b93f-08d6df08ad55
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0178;
x-ms-traffictypediagnostic: BN6PR21MB0178:
x-microsoft-antispam-prvs: <BN6PR21MB01782E2F2CD5FCAE7B49A373C0000@BN6PR21MB0178.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(366004)(136003)(39860400002)(199004)(189003)(478600001)(2906002)(52396003)(99286004)(110136005)(54906003)(7696005)(6116002)(6506007)(102836004)(66556008)(66476007)(14454004)(476003)(52536014)(64756008)(6436002)(74316002)(10290500003)(66446008)(73956011)(4326008)(256004)(71200400001)(14444005)(9686003)(71190400001)(25786009)(66946007)(6636002)(55016002)(5660300002)(486006)(53936002)(76116006)(68736007)(86612001)(81166006)(81156014)(10090500001)(8936002)(86362001)(186003)(33656002)(46003)(8676002)(7736002)(1511001)(305945005)(22452003)(316002)(8990500004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0178;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WPpedvWaFB5kKKaR2juimutBvJdjKmOFBMQd6J9yDsn9WdfWIPEc3SFB6zaMU2Qm33IU1ANyxTKP00LiB1CIiRFAEBcCeuWQT58YHRsuiaiQoB1dbMAk+9xb1GROKi3CwR4/GZDxj9Tcc40n0eKaQZL9QNBLYgviyHetnC2hjF+4a86suyX+73/surK4zmt3knlGK8BndjjqA9BJ5Iz56UXq8UrCKfizHkdzRlIEWhcX0JI+w6b1TWhsUriNMSBnK0yuQdnmBQcKvdnzXG3m/p4/OjgDHyfl7zHH0uGLgUzO4uX+oQGGyOt80b+Zz03aOWmwOy4/9YezU9aVCoxq41nWZxiyCeU9sZcPGPfWTqHp+nZe+9oTDc3HIwq8G9ROEDAo6HEhpjEsETr+8vr+8YsTvHRkcVdF4D7RafCIPTg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c9c030-5778-4d13-b93f-08d6df08ad55
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 22:56:07.8000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0178
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the hv_sock buffer size is static and can't scale to the
bandwidth requirements of the application. This change allows the
applications to influence the socket buffer sizes using the SO_SNDBUF and
the SO_RCVBUF socket options.

Few interesting points to note:
1. Since the VMBUS does not allow a resize operation of the ring size, the
socket buffer size option should be set prior to establishing the
connection for it to take effect.
2. Setting the socket option comes with the cost of that much memory being
reserved/allocated by the kernel, for the lifetime of the connection.

Perf data:
Total Data Transfer: 1GB
Single threaded reader/writer
Results below are summarized over 10 iterations.

Linux hvsocket writer + Windows hvsocket reader:
|--------------------------------------------------------------------------=
-------------------|
|Packet size ->   |      128B       |       1KB       |       4KB       |  =
      64KB         |
|--------------------------------------------------------------------------=
-------------------|
|SO_SNDBUF size | |                 Throughput in MB/s (min/max/avg/median)=
:                  |
|               v |                                                        =
                   |
|--------------------------------------------------------------------------=
-------------------|
|      Default    | 109/118/114/116 | 636/774/701/700 | 435/507/480/476 |  =
 410/491/462/470   |
|      16KB       | 110/116/112/111 | 575/705/662/671 | 749/900/854/869 |  =
 592/824/692/676   |
|      32KB       | 108/120/115/115 | 703/823/767/772 | 718/878/850/866 | 1=
593/2124/2000/2085 |
|      64KB       | 108/119/114/114 | 592/732/683/688 | 805/934/903/911 | 1=
784/1943/1862/1843 |
|--------------------------------------------------------------------------=
-------------------|

Windows hvsocket writer + Linux hvsocket reader:
|--------------------------------------------------------------------------=
-------------------|
|Packet size ->   |     128B    |      1KB        |          4KB        |  =
      64KB         |
|--------------------------------------------------------------------------=
-------------------|
|SO_RCVBUF size | |               Throughput in MB/s (min/max/avg/median): =
                   |
|               v |                                                        =
                   |
|--------------------------------------------------------------------------=
-------------------|
|      Default    | 69/82/75/73 | 313/343/333/336 |   418/477/446/445   |  =
 659/701/676/678   |
|      16KB       | 69/83/76/77 | 350/401/375/382 |   506/548/517/516   |  =
 602/624/615/615   |
|      32KB       | 62/83/73/73 | 471/529/496/494 |   830/1046/935/939  | 9=
44/1180/1070/1100  |
|      64KB       | 64/70/68/69 | 467/533/501/497 | 1260/1590/1430/1431 | 1=
605/1819/1670/1660 |
|--------------------------------------------------------------------------=
-------------------|

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
---
- The table above exceeds the 75char limit for the patch. If that's a
problem, I can try to squeeze it in somehow within the limit.

- The patch has been previously submitted to net and reviewed. The
feedback was to submit it to net-next.

 net/vmw_vsock/hyperv_transport.c | 50 ++++++++++++++++++++++++++++++++----=
----
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 982a8dc..8d3a7b0 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -23,14 +23,14 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
=20
-/* The host side's design of the feature requires 6 exact 4KB pages for
- * recv/send rings respectively -- this is suboptimal considering memory
- * consumption, however unluckily we have to live with it, before the
- * host comes up with a better design in the future.
+/* Older (VMBUS version 'VERSION_WIN10' or before) Windows hosts have some
+ * stricter requirements on the hv_sock ring buffer size of six 4K pages. =
Newer
+ * hosts don't have this limitation; but, keep the defaults the same for c=
ompat.
  */
 #define PAGE_SIZE_4K		4096
 #define RINGBUFFER_HVS_RCV_SIZE (PAGE_SIZE_4K * 6)
 #define RINGBUFFER_HVS_SND_SIZE (PAGE_SIZE_4K * 6)
+#define RINGBUFFER_HVS_MAX_SIZE (PAGE_SIZE_4K * 64)
=20
 /* The MTU is 16KB per the host side's design */
 #define HVS_MTU_SIZE		(1024 * 16)
@@ -344,9 +344,12 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
=20
 	struct sockaddr_vm addr;
 	struct sock *sk, *new =3D NULL;
-	struct vsock_sock *vnew;
-	struct hvsock *hvs, *hvs_new;
+	struct vsock_sock *vnew =3D NULL;
+	struct hvsock *hvs =3D NULL;
+	struct hvsock *hvs_new =3D NULL;
+	int rcvbuf;
 	int ret;
+	int sndbuf;
=20
 	if_type =3D &chan->offermsg.offer.if_type;
 	if_instance =3D &chan->offermsg.offer.if_instance;
@@ -388,9 +391,34 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
 	}
=20
 	set_channel_read_mode(chan, HV_CALL_DIRECT);
-	ret =3D vmbus_open(chan, RINGBUFFER_HVS_SND_SIZE,
-			 RINGBUFFER_HVS_RCV_SIZE, NULL, 0,
-			 hvs_channel_cb, conn_from_host ? new : sk);
+
+	/* Use the socket buffer sizes as hints for the VMBUS ring size. For
+	 * server side sockets, 'sk' is the parent socket and thus, this will
+	 * allow the child sockets to inherit the size from the parent. Keep
+	 * the mins to the default value and align to page size as per VMBUS
+	 * requirements.
+	 * For the max, the socket core library will limit the socket buffer
+	 * size that can be set by the user, but, since currently, the hv_sock
+	 * VMBUS ring buffer is physically contiguous allocation, restrict it
+	 * further.
+	 * Older versions of hv_sock host side code cannot handle bigger VMBUS
+	 * ring buffer size. Use the version number to limit the change to newer
+	 * versions.
+	 */
+	if (vmbus_proto_version < VERSION_WIN10_V5) {
+		sndbuf =3D RINGBUFFER_HVS_SND_SIZE;
+		rcvbuf =3D RINGBUFFER_HVS_RCV_SIZE;
+	} else {
+		sndbuf =3D max_t(int, sk->sk_sndbuf, RINGBUFFER_HVS_SND_SIZE);
+		sndbuf =3D min_t(int, sndbuf, RINGBUFFER_HVS_MAX_SIZE);
+		sndbuf =3D ALIGN(sndbuf, PAGE_SIZE);
+		rcvbuf =3D max_t(int, sk->sk_rcvbuf, RINGBUFFER_HVS_RCV_SIZE);
+		rcvbuf =3D min_t(int, rcvbuf, RINGBUFFER_HVS_MAX_SIZE);
+		rcvbuf =3D ALIGN(rcvbuf, PAGE_SIZE);
+	}
+
+	ret =3D vmbus_open(chan, sndbuf, rcvbuf, NULL, 0, hvs_channel_cb,
+			 conn_from_host ? new : sk);
 	if (ret !=3D 0) {
 		if (conn_from_host) {
 			hvs_new->chan =3D NULL;
@@ -441,6 +469,7 @@ static u32 hvs_get_local_cid(void)
 static int hvs_sock_init(struct vsock_sock *vsk, struct vsock_sock *psk)
 {
 	struct hvsock *hvs;
+	struct sock *sk =3D sk_vsock(vsk);
=20
 	hvs =3D kzalloc(sizeof(*hvs), GFP_KERNEL);
 	if (!hvs)
@@ -448,7 +477,8 @@ static int hvs_sock_init(struct vsock_sock *vsk, struct=
 vsock_sock *psk)
=20
 	vsk->trans =3D hvs;
 	hvs->vsk =3D vsk;
-
+	sk->sk_sndbuf =3D RINGBUFFER_HVS_SND_SIZE;
+	sk->sk_rcvbuf =3D RINGBUFFER_HVS_RCV_SIZE;
 	return 0;
 }
=20
--=20
2.7.4

