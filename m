Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5DA18291
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfEHXKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:10:41 -0400
Received: from mail-eopbgr750105.outbound.protection.outlook.com ([40.107.75.105]:44934
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725910AbfEHXKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 19:10:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=XrFV0bylqRu17VikpysSsJQ2pzj4mdB4UnKsj9DI0zR3ePvqgxW9Tk1WO/yhH6Kzf8nYh7N4j5wdTRiW55yutTlwZcHi3BVMb8QHY4Ua2vNxcimIhiCDIZX2F4VA6DsdNeVghIzGu94orzEHf4qKJOfaiSoJWMDXUHwBx38Z9Z8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPWBW7VNfNhbihP7Fa8PiiCyG7+gdjX4wiM/FBM8NJg=;
 b=XZNfEuhdgrN8qwJdL0K2KFHvbDiKO5/QZXh64XMqeZO+q3RqSVwZj3wiirGo0nYceuWYsH5/vJoFYLk1WlEGARvOmDnpv4zaNp9FpA1273Kz1VnVmalfnshVrEGSqz4RLW61TVIT1BBx0EO/4V5s/uxCBLNGewq5HATutqJW1wY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPWBW7VNfNhbihP7Fa8PiiCyG7+gdjX4wiM/FBM8NJg=;
 b=G8/9bFQsNkqYe7z0w5LaoonxK1DFEWLKhSQdFJlBjZIZNDlfxOsLH8rEFMNQQQTeezi+uWeozSd9DlkpjN19t697AmRYEU2KPHy3KayWIFKqlptt5dSA+bTKmo5pWbS5WBD7aw27mN7TTF3unrlwKHNlRtvXNyNfBfG9ZquWAE4=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (10.172.111.143) by
 BN6PR21MB0161.namprd21.prod.outlook.com (10.173.200.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.3; Wed, 8 May 2019 23:10:35 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::ec59:338a:399e:a74a]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::ec59:338a:399e:a74a%7]) with mapi id 15.20.1900.002; Wed, 8 May 2019
 23:10:35 +0000
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
Subject: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Topic: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Index: AdUF8eO/rXjnGSU+Q+iHOcDDYgexQQ==
Date:   Wed, 8 May 2019 23:10:35 +0000
Message-ID: <BN6PR21MB0465168DEA6CABA910832A5BC0320@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:7:e95c:a07e:779d:a25a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccafa224-6f34-4144-3d37-08d6d40a60dc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0161;
x-ms-traffictypediagnostic: BN6PR21MB0161:
x-microsoft-antispam-prvs: <BN6PR21MB0161B469C8626F7A1896BAAFC0320@BN6PR21MB0161.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(346002)(376002)(366004)(189003)(199004)(6636002)(53936002)(14454004)(110136005)(54906003)(6436002)(256004)(14444005)(5660300002)(305945005)(74316002)(86362001)(7696005)(2906002)(86612001)(7736002)(71190400001)(71200400001)(6506007)(66946007)(73956011)(76116006)(66446008)(64756008)(66556008)(478600001)(66476007)(52536014)(8990500004)(102836004)(486006)(22452003)(6116002)(99286004)(55016002)(8676002)(33656002)(81156014)(10290500003)(25786009)(186003)(81166006)(68736007)(8936002)(46003)(10090500001)(316002)(476003)(4326008)(9686003)(1511001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0161;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yXwC07CEvPg1PnLqmrHovfl2UFS+X2qKuSOMXigAmmda4JK5ug9Q4Jilv+zi/iePmrapWMXtZdfWzsgSLJmghBUYRzcKGkNkwWIi01wTOr0QnDHfoAj6j8tAgbt9Lz4oQZENL7qLXmaGOkFu8R/1Hj8ve00l6ILYLB6AGJqLrKwVHAp0oALNCccIBzRbje8Xe7zvn666jRhJyIKroI5P0+llz9WZDdYkl5fmPDZ7w3M76o2rDZoZHBboDdkzxHo8vyH0RemKQowCkpmvcYbX0Jo7BqPTFHtR9A2u1cdxuvrETmGq8Ux7mBXP33VtUSbjFP5YPTb/flvP9Y/yPYUm+k6OrJ+km65XXLzlhTIOGk72ZNV8o4veIy2WS2t0i/86r3ALlpqfFaY3x45805altakIzTImGdDdCagVkrIkbY8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccafa224-6f34-4144-3d37-08d6d40a60dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 23:10:35.6879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when a hvsock socket is closed, the socket is shutdown and
immediately a RST is sent. There is no wait for the FIN packet to arrive
from the other end. This can lead to data loss since the connection is
terminated abruptly. This can manifest easily in cases of a fast guest
hvsock writer and a much slower host hvsock reader. Essentially hvsock is
not following the proper STREAM(TCP) closing handshake mechanism.

The fix involves adding support for the delayed close of hvsock, which is
in-line with other socket providers such as virtio. While closing, the
socket waits for a constant timeout, for the FIN packet to arrive from the
other end. On timeout, it will terminate the connection (i.e a RST).

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
---
 net/vmw_vsock/hyperv_transport.c | 122 ++++++++++++++++++++++++++++-------=
----
 1 file changed, 87 insertions(+), 35 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index a827547..62b986d 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -35,6 +35,9 @@
 /* The MTU is 16KB per the host side's design */
 #define HVS_MTU_SIZE		(1024 * 16)
=20
+/* How long to wait for graceful shutdown of a connection */
+#define HVS_CLOSE_TIMEOUT (8 * HZ)
+
 struct vmpipe_proto_header {
 	u32 pkt_type;
 	u32 data_size;
@@ -305,19 +308,33 @@ static void hvs_channel_cb(void *ctx)
 		sk->sk_write_space(sk);
 }
=20
-static void hvs_close_connection(struct vmbus_channel *chan)
+static void hvs_do_close_lock_held(struct vsock_sock *vsk,
+				   bool cancel_timeout)
 {
-	struct sock *sk =3D get_per_channel_state(chan);
-	struct vsock_sock *vsk =3D vsock_sk(sk);
-
-	lock_sock(sk);
+	struct sock *sk =3D sk_vsock(vsk);
=20
-	sk->sk_state =3D TCP_CLOSE;
 	sock_set_flag(sk, SOCK_DONE);
-	vsk->peer_shutdown |=3D SEND_SHUTDOWN | RCV_SHUTDOWN;
-
+	vsk->peer_shutdown =3D SHUTDOWN_MASK;
+	if (vsock_stream_has_data(vsk) <=3D 0)
+		sk->sk_state =3D TCP_CLOSING;
 	sk->sk_state_change(sk);
+	if (vsk->close_work_scheduled &&
+	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
+		vsk->close_work_scheduled =3D false;
+		vsock_remove_sock(vsk);
+
+		/* Release the reference taken while scheduling the timeout */
+		sock_put(sk);
+	}
+}
+
+/* Equivalent of a RST */
+static void hvs_close_connection(struct vmbus_channel *chan)
+{
+	struct sock *sk =3D get_per_channel_state(chan);
=20
+	lock_sock(sk);
+	hvs_do_close_lock_held(vsock_sk(sk), true);
 	release_sock(sk);
 }
=20
@@ -452,50 +469,80 @@ static int hvs_connect(struct vsock_sock *vsk)
 	return vmbus_send_tl_connect_request(&h->vm_srv_id, &h->host_srv_id);
 }
=20
+static inline void hvs_shutdown_lock_held(struct hvsock *hvs, int mode)
+{
+	struct vmpipe_proto_header hdr;
+
+	if (hvs->fin_sent || !hvs->chan)
+		return;
+
+	/* It can't fail: see hvs_channel_writable_bytes(). */
+	(void)hvs_send_data(hvs->chan, (struct hvs_send_buf *)&hdr, 0);
+	hvs->fin_sent =3D true;
+}
+
 static int hvs_shutdown(struct vsock_sock *vsk, int mode)
 {
 	struct sock *sk =3D sk_vsock(vsk);
-	struct vmpipe_proto_header hdr;
-	struct hvs_send_buf *send_buf;
-	struct hvsock *hvs;
=20
 	if (!(mode & SEND_SHUTDOWN))
 		return 0;
=20
 	lock_sock(sk);
+	hvs_shutdown_lock_held(vsk->trans, mode);
+	release_sock(sk);
+	return 0;
+}
=20
-	hvs =3D vsk->trans;
-	if (hvs->fin_sent)
-		goto out;
-
-	send_buf =3D (struct hvs_send_buf *)&hdr;
+static void hvs_close_timeout(struct work_struct *work)
+{
+	struct vsock_sock *vsk =3D
+		container_of(work, struct vsock_sock, close_work.work);
+	struct sock *sk =3D sk_vsock(vsk);
=20
-	/* It can't fail: see hvs_channel_writable_bytes(). */
-	(void)hvs_send_data(hvs->chan, send_buf, 0);
+	sock_hold(sk);
+	lock_sock(sk);
+	if (!sock_flag(sk, SOCK_DONE))
+		hvs_do_close_lock_held(vsk, false);
=20
-	hvs->fin_sent =3D true;
-out:
+	vsk->close_work_scheduled =3D false;
 	release_sock(sk);
-	return 0;
+	sock_put(sk);
 }
=20
-static void hvs_release(struct vsock_sock *vsk)
+/* Returns true, if it is safe to remove socket; false otherwise */
+static bool hvs_close_lock_held(struct vsock_sock *vsk)
 {
 	struct sock *sk =3D sk_vsock(vsk);
-	struct hvsock *hvs =3D vsk->trans;
-	struct vmbus_channel *chan;
=20
-	lock_sock(sk);
+	if (!(sk->sk_state =3D=3D TCP_ESTABLISHED ||
+	      sk->sk_state =3D=3D TCP_CLOSING))
+		return true;
=20
-	sk->sk_state =3D TCP_CLOSING;
-	vsock_remove_sock(vsk);
+	if ((sk->sk_shutdown & SHUTDOWN_MASK) !=3D SHUTDOWN_MASK)
+		hvs_shutdown_lock_held(vsk->trans, SHUTDOWN_MASK);
=20
-	release_sock(sk);
+	if (sock_flag(sk, SOCK_DONE))
+		return true;
=20
-	chan =3D hvs->chan;
-	if (chan)
-		hvs_shutdown(vsk, RCV_SHUTDOWN | SEND_SHUTDOWN);
+	/* This reference will be dropped by the delayed close routine */
+	sock_hold(sk);
+	INIT_DELAYED_WORK(&vsk->close_work, hvs_close_timeout);
+	vsk->close_work_scheduled =3D true;
+	schedule_delayed_work(&vsk->close_work, HVS_CLOSE_TIMEOUT);
+	return false;
+}
=20
+static void hvs_release(struct vsock_sock *vsk)
+{
+	struct sock *sk =3D sk_vsock(vsk);
+	bool remove_sock;
+
+	lock_sock(sk);
+	remove_sock =3D hvs_close_lock_held(vsk);
+	release_sock(sk);
+	if (remove_sock)
+		vsock_remove_sock(vsk);
 }
=20
 static void hvs_destruct(struct vsock_sock *vsk)
@@ -532,10 +579,11 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
 	return false;
 }
=20
-static int hvs_update_recv_data(struct hvsock *hvs)
+static int hvs_update_recv_data(struct vsock_sock *vsk)
 {
 	struct hvs_recv_buf *recv_buf;
 	u32 payload_len;
+	struct hvsock *hvs =3D vsk->trans;
=20
 	recv_buf =3D (struct hvs_recv_buf *)(hvs->recv_desc + 1);
 	payload_len =3D recv_buf->hdr.data_size;
@@ -543,8 +591,12 @@ static int hvs_update_recv_data(struct hvsock *hvs)
 	if (payload_len > HVS_MTU_SIZE)
 		return -EIO;
=20
-	if (payload_len =3D=3D 0)
+	/* Peer shutdown */
+	if (payload_len =3D=3D 0) {
+		struct sock *sk =3D sk_vsock(vsk);
 		hvs->vsk->peer_shutdown |=3D SEND_SHUTDOWN;
+		sk->sk_state_change(sk);
+	}
=20
 	hvs->recv_data_len =3D payload_len;
 	hvs->recv_data_off =3D 0;
@@ -566,7 +618,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vs=
k, struct msghdr *msg,
=20
 	if (need_refill) {
 		hvs->recv_desc =3D hv_pkt_iter_first(hvs->chan);
-		ret =3D hvs_update_recv_data(hvs);
+		ret =3D hvs_update_recv_data(vsk);
 		if (ret)
 			return ret;
 	}
@@ -581,7 +633,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vs=
k, struct msghdr *msg,
 	if (hvs->recv_data_len =3D=3D 0) {
 		hvs->recv_desc =3D hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
 		if (hvs->recv_desc) {
-			ret =3D hvs_update_recv_data(hvs);
+			ret =3D hvs_update_recv_data(vsk);
 			if (ret)
 				return ret;
 		}
--=20
2.7.4

