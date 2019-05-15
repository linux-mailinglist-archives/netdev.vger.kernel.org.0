Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D38BB1E66D
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 02:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfEOA4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 20:56:09 -0400
Received: from mail-eopbgr680101.outbound.protection.outlook.com ([40.107.68.101]:2023
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfEOA4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 20:56:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=oigbJS5dK74b905sNEydOXIN6tydKwbQDM2tyvsjzANd+SqC+RRy/ZoyaI2kNVu5EQFFBvUQyVzqlHeX49kGS74Kw+jVRSRkMqBALsLmKiOMzm3EZVGaG8L/fYHNQHLjSry46Ve9Hp21U4R+NmtAIL0o4sRJ8HZ4kpK3NDuYAJ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bkdc3/5BuBGXEIH/Fh/sVpiIPNxeNgPy74/riz32xzc=;
 b=OV/7lCVUBV0SuEfW0NVWuZD/hvltmWhihk7QfuF9p6fLKqmedxcMvw3wZluPoiT1s59BxqatF+Yh+9YiLzgUocohLJJAozWZsb9qV1xIi6FZpb7GQnzmcMSF/32ZwSX60Jlg6h+INuaYeC9YD8ZG4AF2SXapJiFxhFcThOH9pkI=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bkdc3/5BuBGXEIH/Fh/sVpiIPNxeNgPy74/riz32xzc=;
 b=IYo5F4rbvs6NtIrkoFMLQswIoCtx1TXOeOaGQ9Fn3AlzPYdudFvxGC8A9c8KiblXz4VLo1WXkU454gqy8p9UInAmL5sqXe6clnx/ZrtWltUeZfvAghJzoGMICsweXTm04uolyNtZUKavdBwosA48JFwE7xcreW49jYlMDAcxj2Q=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0179.namprd21.prod.outlook.com (2603:10b6:404:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.4; Wed, 15 May
 2019 00:56:05 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1922.002; Wed, 15 May
 2019 00:56:05 +0000
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
Subject: [PATCH v2] hv_sock: Add support for delayed close
Thread-Topic: [PATCH v2] hv_sock: Add support for delayed close
Thread-Index: AdUKtaBXG33lHE0AQU2ynJ9GbZ74Uw==
Date:   Wed, 15 May 2019 00:56:05 +0000
Message-ID: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:7:f8d4:c8e7:5ebf:2c16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96ff9b84-c6ac-46dd-4022-08d6d8d01c3f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0179;
x-ms-traffictypediagnostic: BN6PR21MB0179:
x-microsoft-antispam-prvs: <BN6PR21MB01793379E5425F94C748387FC0090@BN6PR21MB0179.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(376002)(396003)(39860400002)(199004)(189003)(476003)(76116006)(86612001)(99286004)(86362001)(73956011)(46003)(55016002)(7696005)(9686003)(8936002)(2906002)(8676002)(81166006)(6436002)(186003)(66446008)(81156014)(14444005)(1511001)(66946007)(66476007)(66556008)(64756008)(256004)(52396003)(102836004)(316002)(6506007)(486006)(6116002)(7736002)(54906003)(25786009)(478600001)(4326008)(68736007)(53936002)(10090500001)(71200400001)(71190400001)(22452003)(110136005)(52536014)(33656002)(14454004)(305945005)(6636002)(74316002)(10290500003)(5660300002)(8990500004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0179;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iMQye8ecMFwkXmGJoaKXfahKuEUVQgAeu4N0GVn5XeC23Q2zOiCFv1wP4DkrCDyYF3YE0QySQpvh4s6eJJA3twrvxwwWXCEb+ePlSOnXX+QLAJIyUGmo3ks53cqIHR6rgNWAWrioxsSdHaR/RaMY3ql/yRnvXDvwEI7Vvsmau6BNs4FBRW/7mAQjJW32tutVt64+dBcuoQVUcZ+5eAxjWfWCYfi1SY70JK59kFTZN8IrM7uwCoQwosHRxt37SE+eO8uKRfRfe5E0FN2NKtqxMzstta4Ov4fv9COnsXgLFkxABde+EMEdMtAKZxRQaMkuKL+cd3x+HVwQYw67lIyUmN/hydrIWQhAvLXNiIqvBTz6WY9gjoWP3nEo3znzl/zIz8G8oDtlfA5mtCBqoM5gIVwskVPnFyAdmBhNdLh/YPU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ff9b84-c6ac-46dd-4022-08d6d8d01c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 00:56:05.5466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, hvsock does not implement any delayed or background close
logic. Whenever the hvsock socket is closed, a FIN is sent to the peer, and
the last reference to the socket is dropped, which leads to a call to
.destruct where the socket can hang indefinitely waiting for the peer to
close it's side. The can cause the user application to hang in the close()
call.

This change implements proper STREAM(TCP) closing handshake mechanism by
sending the FIN to the peer and the waiting for the peer's FIN to arrive
for a given timeout. On timeout, it will try to terminate the connection
(i.e. a RST). This is in-line with other socket providers such as virtio.

This change does not address the hang in the vmbus_hvsock_device_unregister
where it waits indefinitely for the host to rescind the channel. That
should be taken up as a separate fix.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
---
Changes since v1:
- Updated the title and description to better reflect the change. The title
was previously called 'hv_sock: Fix data loss upon socket close'
- Removed the sk_state_change call to keep the fix focused.
- Removed 'inline' keyword from the .c file and letting compiler do it.

 net/vmw_vsock/hyperv_transport.c | 108 ++++++++++++++++++++++++++++-------=
----
 1 file changed, 77 insertions(+), 31 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index a827547..982a8dc 100644
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
@@ -305,19 +308,32 @@ static void hvs_channel_cb(void *ctx)
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
=20
+		/* Release the reference taken while scheduling the timeout */
+		sock_put(sk);
+	}
+}
+
+static void hvs_close_connection(struct vmbus_channel *chan)
+{
+	struct sock *sk =3D get_per_channel_state(chan);
+
+	lock_sock(sk);
+	hvs_do_close_lock_held(vsock_sk(sk), true);
 	release_sock(sk);
 }
=20
@@ -452,50 +468,80 @@ static int hvs_connect(struct vsock_sock *vsk)
 	return vmbus_send_tl_connect_request(&h->vm_srv_id, &h->host_srv_id);
 }
=20
+static void hvs_shutdown_lock_held(struct hvsock *hvs, int mode)
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
--=20
2.7.4

