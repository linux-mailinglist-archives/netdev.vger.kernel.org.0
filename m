Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B31B211EC
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 04:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfEQCF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 22:05:26 -0400
Received: from mail-eopbgr700121.outbound.protection.outlook.com ([40.107.70.121]:49504
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfEQCF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 22:05:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=oaD0OKdQakdJbTnW2aCeFhDI0+WcIsExaqqhFjlOwzrH1o/FJF2fMTE5ycXAZhSdVnpBJzNcOTzqfEA/cYy/uTs8+k6EOj8g7Ws8M9uTO4ar5vrEBnMCcSMRdt8JwqFtHtHFvUETNcAnocsxGZK2NiW//Q4JYGGmg1yo1GL5Mz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6seYDAJhRAxsLWd/YATLjL2+Zn1TrxIrD9kjcSa7tJ0=;
 b=T4atCcJs+eo/HGca7E+cfu7W36ff4Xw1mmJpn43fjNBxvopyvEc9zYP3AjWKYPs3nQOVBsI90EqTiE/TL78Y2TR1HZuTAB/41HaA6yXU8BBrCqFWrOZHQSiI1wBBzGI5FDbaiaZmCRoiSHof13miHAf+IdjOuQEjpUgzACbwOSM=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6seYDAJhRAxsLWd/YATLjL2+Zn1TrxIrD9kjcSa7tJ0=;
 b=F4gUCN21S0MYjowiQ0YFUExdc1f50ET6Ev1GlJTy+qeMUyp/wtlkCuN/i22v3ULKGX9oEFoxTElrkQsD6uey7wRgCNyTRmH3oTVvV+6NlHP5PaTL2WC/zZNtiEMMiccP5SoGW2VZK8Y7kpoyRmtXVMXq4+PuiBB2khRf6CL/x1E=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0756.namprd21.prod.outlook.com (2603:10b6:404:9c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256) id 15.20.1922.1; Fri, 17
 May 2019 02:05:23 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1922.002; Fri, 17 May
 2019 02:05:23 +0000
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
Subject: [PATCH] hv_sock: perf: loop in send() to maximize bandwidth
Thread-Topic: [PATCH] hv_sock: perf: loop in send() to maximize bandwidth
Thread-Index: AdUMVBbujvPfmRv4TlunnQ+yORJc9Q==
Date:   Fri, 17 May 2019 02:05:22 +0000
Message-ID: <BN6PR21MB046557834D46216464A6BA08C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:8:56d:b927:3a9:15b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8b63975-2324-4060-f372-08d6da6c1f13
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0756;
x-ms-traffictypediagnostic: BN6PR21MB0756:
x-microsoft-antispam-prvs: <BN6PR21MB0756DAD9ABF7607C8BF589E0C00B0@BN6PR21MB0756.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(366004)(136003)(376002)(199004)(189003)(4326008)(9686003)(14454004)(8936002)(10290500003)(86612001)(86362001)(55016002)(25786009)(71190400001)(71200400001)(478600001)(66446008)(5660300002)(52536014)(64756008)(256004)(73956011)(66476007)(76116006)(66946007)(66556008)(68736007)(33656002)(81156014)(81166006)(53936002)(54906003)(486006)(476003)(46003)(186003)(6506007)(99286004)(7696005)(7736002)(316002)(6116002)(6436002)(22452003)(10090500001)(1511001)(74316002)(8676002)(110136005)(2906002)(8990500004)(52396003)(6636002)(305945005)(102836004)(14963001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0756;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rIyhcgFVMPuFv0rZh7zWjIo+2pKVF2pxVtRrbFcmJ1UQVpwycJOWTTalb8EH5NL5rfiTt+TaBTFNjuCbLyxOCDx+nBGGn7rPRkjbbUpQRpAVb2n9cFQTOCmEIm1dqwfbhIepPrXgWQQ7FOyZ/nRrXBqnjYXKuXQHfHryirMcXVWkk8H4s7visfWJgYoxDWnfNAmh8B0WhiqfRN3ASQ5y55DLAQk1Ukwl/xWznUIuEWV8ervYGBILzUorhsW3bdeXT4Lys8y5JrFLhnPgYOw1eQLJB/Hj4DERB6R+Xzq5vaZB9VzlejsZTOC2CZw6diFJEUNwFAU9J400eZMGP8qqJO/ZrdY1ILd1arWtZl8DZFfdJZJfpcS/6EicyIvpZ5UnuSPGbdePLViRJvV47Qpj4dm28qFClSI5lHx2B2EhloM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b63975-2324-4060-f372-08d6da6c1f13
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 02:05:22.2930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0756
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the hv_sock send() iterates once over the buffer, puts data into
the VMBUS channel and returns. It doesn't maximize on the case when there
is a simultaneous reader draining data from the channel. In such a case,
the send() can maximize the bandwidth (and consequently minimize the cpu
cycles) by iterating until the channel is found to be full.

Perf data:
Total Data Transfer: 10GB/iteration
Single threaded reader/writer, Linux hvsocket writer with Windows hvsocket
reader
Packet size: 64KB
CPU sys time was captured using the 'time' command for the writer to send
10GB of data.
'Send Buffer Loop' is with the patch applied.
The values below are over 10 iterations.

|--------------------------------------------------------|
|        |        Current        |   Send Buffer Loop    |
|--------------------------------------------------------|
|        | Throughput | CPU sys  | Throughput | CPU sys  |
|        | (MB/s)     | time (s) | (MB/s)     | time (s) |
|--------------------------------------------------------|
| Min    |     407    |   7.048  |    401     |  5.958   |
|--------------------------------------------------------|
| Max    |     455    |   7.563  |    542     |  6.993   |
|--------------------------------------------------------|
| Avg    |     440    |   7.411  |    451     |  6.639   |
|--------------------------------------------------------|
| Median |     446    |   7.417  |    447     |  6.761   |
|--------------------------------------------------------|

Observation:
1. The avg throughput doesn't really change much with this change for this
scenario. This is most probably because the bottleneck on throughput is
somewhere else.
2. The average system (or kernel) cpu time goes down by 10%+ with this
change, for the same amount of data transfer.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
---
 net/vmw_vsock/hyperv_transport.c | 45 +++++++++++++++++++++++++++---------=
----
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 982a8dc..7c13032 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -55,8 +55,9 @@ struct hvs_recv_buf {
 };
=20
 /* We can send up to HVS_MTU_SIZE bytes of payload to the host, but let's =
use
- * a small size, i.e. HVS_SEND_BUF_SIZE, to minimize the dynamically-alloc=
ated
- * buffer, because tests show there is no significant performance differen=
ce.
+ * a smaller size, i.e. HVS_SEND_BUF_SIZE, to maximize concurrency between=
 the
+ * guest and the host processing as one VMBUS packet is the smallest proce=
ssing
+ * unit.
  *
  * Note: the buffer can be eliminated in the future when we add new VMBus
  * ringbuffer APIs that allow us to directly copy data from userspace buff=
er
@@ -644,7 +645,9 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vs=
k, struct msghdr *msg,
 	struct hvsock *hvs =3D vsk->trans;
 	struct vmbus_channel *chan =3D hvs->chan;
 	struct hvs_send_buf *send_buf;
-	ssize_t to_write, max_writable, ret;
+	ssize_t to_write, max_writable;
+	ssize_t ret =3D 0;
+	ssize_t bytes_written =3D 0;
=20
 	BUILD_BUG_ON(sizeof(*send_buf) !=3D PAGE_SIZE_4K);
=20
@@ -652,20 +655,34 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *=
vsk, struct msghdr *msg,
 	if (!send_buf)
 		return -ENOMEM;
=20
-	max_writable =3D hvs_channel_writable_bytes(chan);
-	to_write =3D min_t(ssize_t, len, max_writable);
-	to_write =3D min_t(ssize_t, to_write, HVS_SEND_BUF_SIZE);
-
-	ret =3D memcpy_from_msg(send_buf->data, msg, to_write);
-	if (ret < 0)
-		goto out;
+	/* Reader(s) could be draining data from the channel as we write.
+	 * Maximize bandwidth, by iterating until the channel is found to be
+	 * full.
+	 */
+	while (len) {
+		max_writable =3D hvs_channel_writable_bytes(chan);
+		if (!max_writable)
+			break;
+		to_write =3D min_t(ssize_t, len, max_writable);
+		to_write =3D min_t(ssize_t, to_write, HVS_SEND_BUF_SIZE);
+		/* memcpy_from_msg is safe for loop as it advances the offsets
+		 * within the message iterator.
+		 */
+		ret =3D memcpy_from_msg(send_buf->data, msg, to_write);
+		if (ret < 0)
+			goto out;
=20
-	ret =3D hvs_send_data(hvs->chan, send_buf, to_write);
-	if (ret < 0)
-		goto out;
+		ret =3D hvs_send_data(hvs->chan, send_buf, to_write);
+		if (ret < 0)
+			goto out;
=20
-	ret =3D to_write;
+		bytes_written +=3D to_write;
+		len -=3D to_write;
+	}
 out:
+	/* If any data has been sent, return that */
+	if (bytes_written)
+		ret =3D bytes_written;
 	kfree(send_buf);
 	return ret;
 }
--=20
2.7.4

