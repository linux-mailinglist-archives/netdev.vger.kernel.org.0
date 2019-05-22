Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F711272BC
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfEVXKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:10:49 -0400
Received: from mail-eopbgr750133.outbound.protection.outlook.com ([40.107.75.133]:13793
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727691AbfEVXKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 19:10:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=YmCkqrRKX6ct+LHX1bbrPsyQvisJ2ae5MkpjC7xOlG6E/Uctl7H5O3H827aQyCUxWOsOWJNib+AxcyH7KiOrGryT1aq/b1Y1zlfYkfSwMZ4pLMQTZq9nueUpRyaYMMJYsKuklu9TaeOQoixI5c0nChnumawl5Bga/fDrwEkpvIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9p0x2kTE2Y68R7pmM2B2VaJqo1dGY0QO+rqZvMbko8=;
 b=FWk7o3sJwgr9VWJfeKtnXJe43n4vpWsp7Q4tQDpVwbuKRkicVbhSujKwTvOU6cZNPljWjjKQ7NvNjNSWATte1gaOqXr6/OldCJtuuJxgzqLwN562bY2Typf+8axbxuj8UuHP4VpB1rrz+z5wDbfO0lx7XyxI1vZ/S0OtEEw0LL8=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9p0x2kTE2Y68R7pmM2B2VaJqo1dGY0QO+rqZvMbko8=;
 b=il9NNreqUmj9KC6wIpjj9Ft1qHdXjQadiL2yF5J4c1Fj921vXR8425wPoPY64ctUShdEd532KgLua/46KrSTbP5NsTJQcl4b5+IDBrMXcwOFt60ZD2B9hEUCG7zCUapt+BYcnjptcmqYC6b13klz9rLyWaRmlP08OJpDq0fRAYs=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0785.namprd21.prod.outlook.com (2603:10b6:404:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1943.3; Wed, 22 May
 2019 23:10:45 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1943.003; Wed, 22 May
 2019 23:10:45 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] hv_sock: perf: loop in send() to maximize bandwidth
Thread-Topic: [PATCH net-next] hv_sock: perf: loop in send() to maximize
 bandwidth
Thread-Index: AdUQ82kcrZ0lH8wWQ6mgUr9BJIMYLQ==
Date:   Wed, 22 May 2019 23:10:44 +0000
Message-ID: <BN6PR21MB0465FA591662A8B580AEF7D9C0000@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:2:a4eb:8a21:82ce:5b14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d53f8312-277f-455b-a32c-08d6df0ab80d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0785;
x-ms-traffictypediagnostic: BN6PR21MB0785:
x-microsoft-antispam-prvs: <BN6PR21MB0785447115B06990532B4C15C0000@BN6PR21MB0785.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(376002)(39860400002)(366004)(189003)(199004)(86362001)(186003)(8936002)(476003)(46003)(8676002)(81166006)(86612001)(76116006)(73956011)(66556008)(66446008)(316002)(10090500001)(71190400001)(71200400001)(22452003)(81156014)(66476007)(66946007)(52536014)(64756008)(486006)(305945005)(68736007)(5660300002)(7736002)(33656002)(478600001)(8990500004)(2906002)(10290500003)(14454004)(6636002)(9686003)(25786009)(6436002)(55016002)(256004)(1511001)(53936002)(102836004)(6506007)(110136005)(99286004)(54906003)(52396003)(4326008)(74316002)(7696005)(6116002)(14963001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0785;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5g5xmaPRTiY9MMuxP212YAmfxYQaFzNaksCp9nY2jOuBlnkE0jCa7Wr/vFmu2rnIpo/VEKlES0xIKIstUwm1QJPuwNOCl0zqRD3Y8lM2a7ddG9OEt4kqfZI8Er2Tj/qNa/inwAeHpkZJCZ26mBAu3PlQ6p9QVce3vYio2cwT1U8wkx/JHkNl5vADHcKJVxejSo67GdY1LUN+WwiBd25dHV+L+J/aBczgROnBQIPC2NKn7Hapm5fmFVGbS+CVGCj4mAbkSzae0meEM6KFvCZi3IXLzvdUQzNRTEphljGS41CbFpQ19V6c6bqaaftoW7w0eO1CM+iN2BRJAiKrJVp2KRQGF6oawc1SfXJvUCXIhQNVQV0apqTWbWw9PBhQxPiLOIO+HPNVbf5IL3u1zqWCMzxmeXbfxxEHGhwrF5sfy8I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d53f8312-277f-455b-a32c-08d6df0ab80d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 23:10:44.7179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0785
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
- The patch has been previously submitted to net and reviewed. The
feedback was to submit it to net-next.

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

