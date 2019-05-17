Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E676321132
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 02:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfEQASc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 20:18:32 -0400
Received: from mail-eopbgr820127.outbound.protection.outlook.com ([40.107.82.127]:39922
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbfEQASc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 20:18:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=b2YH9QAzzp7pRNXL+NsljWNXwzjwvGun/0w7y4m4Y1z/BdN3c83i21gXxOZ/S4uYxaHq5ORl5ei1pGITrFDi/L8BBKyBu5kopiENobWVCsRVJ+eBW0iC7h2+aseoRTl6TYD4Tn0DvmjvOQVrzv663S/dvEgaTWsaMwWF4FWnbqk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPIwACT4+8KA0pV4gbOYy2zSe8lzP718lGcwjwP+cxY=;
 b=BsYRhR8ywtmd0voNqM33ObYelDBjCQfDAg9sxFnQlD47sSJC9Eobvv/bAdG1A1/hKD9/9pYw3geWGbZqENDK6Q1/DIZPsDDlO3WWUa2mz1xQrV87u93kqfNy4pttqiRkyvzeqzb3czcrtDNsrVsqA9Q4ZZ+JPqVfj4fFoip2v10=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPIwACT4+8KA0pV4gbOYy2zSe8lzP718lGcwjwP+cxY=;
 b=QegyjgsSlFEZGpgykR3KCh6sjGHXQIjRsGcvvkKvPq/qR1gcAvpIvng6eJeAaikKQet5SJ/74W0kxJXqTjHTg9p8xaR8gQk3EOqALXRrwVRR35FUQaRz8lJ7htAwjYYtOlMyZApu44t7/YVb2bo9tTBR7hvMCzunoGocwuqtw/U=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0689.namprd21.prod.outlook.com (2603:10b6:404:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.1; Fri, 17 May
 2019 00:16:49 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1922.002; Fri, 17 May
 2019 00:16:49 +0000
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
Subject: [PATCH] hv_sock: perf: Allow the socket buffer size options to
 influence the actual socket buffers
Thread-Topic: [PATCH] hv_sock: perf: Allow the socket buffer size options to
 influence the actual socket buffers
Thread-Index: AdULT8Ri+kxJVj56RXiGnzXz8jUENA==
Date:   Fri, 17 May 2019 00:16:48 +0000
Message-ID: <BN6PR21MB046528E2099CDE2C6C2200A7C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:8:56d:b927:3a9:15b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6dcc6c2-e8ec-4320-d0bf-08d6da5cf467
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0689;
x-ms-traffictypediagnostic: BN6PR21MB0689:
x-microsoft-antispam-prvs: <BN6PR21MB068967D99173513EEEFE07EAC00B0@BN6PR21MB0689.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(346002)(366004)(396003)(189003)(199004)(99286004)(54906003)(110136005)(305945005)(52536014)(86362001)(4326008)(25786009)(8676002)(5660300002)(81166006)(81156014)(7696005)(68736007)(7736002)(52396003)(8936002)(6116002)(71200400001)(71190400001)(86612001)(256004)(14444005)(9686003)(6506007)(186003)(10090500001)(46003)(478600001)(486006)(66476007)(33656002)(316002)(22452003)(6636002)(73956011)(66556008)(476003)(55016002)(102836004)(76116006)(6436002)(1511001)(64756008)(66446008)(14454004)(74316002)(10290500003)(2906002)(66946007)(8990500004)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0689;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BAgwyNxyur1PUB95DCoeDjymz9glWahUgSvQku/x4jXQZH7unV6ld7dttm088qYbEk53vkZPpqs1CapBCb7N7COZSBX93RdMvpvyJb8kqCrVq/Z9jKfdfYgdQ1Dzh+pLNjEX2jZQNg9bci7A2GkJiFGj2Px8pt1fPvegPvu1NFQJp1NDgbkje5BPULE41j6qGvR/+ehB+VlrZFCY9gEv5ssnUdVWFbjF4Y8sVRD8AnUQBnA7L7l+eH+n0Rfstf1gGs+ehvNK/4Y3g8NBw5jzquTXcoHMN7tRXa6dFq8emxLxd2ocsyTUjCw5/fWttJ/qb7OAbRGwhu20ukCg2SKbSeoXHxQgimhwJ2qmv8hRl6TBs3nsaSIh0xvWkCYdUjrOIVxD0g7bY05T7fhxtYX9OQxyKh64xOiex7OTXOIvCC4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6dcc6c2-e8ec-4320-d0bf-08d6da5cf467
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 00:16:48.9392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0689
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

