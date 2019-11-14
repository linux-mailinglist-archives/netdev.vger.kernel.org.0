Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B43BFC33A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKNJ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56360 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727066AbfKNJ62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDbHfRef8E4JEoIlx017VIijFBk4nzrys+O/YLbv6gs=;
        b=fg/yMEODsN1NEzZVYgwDVa1X5Y+YBLY5Je1XWRvzWYsTeOZQKKoDv1pQyhmQvWSNeZHjmg
        1LRImmfEBZIOjdrE7VwJzUl5/LTxM5Yiz4Icf8hVNmgKQju8wwZnDfJpHywZzw642WOv7I
        88tsGuQi8Qlk9GPY4avZ8+37LAX70l0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49--txdL2sUNamqXRM8s7VjQA-1; Thu, 14 Nov 2019 04:58:24 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AB66593A0;
        Thu, 14 Nov 2019 09:58:21 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D84F519757;
        Thu, 14 Nov 2019 09:58:17 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
Subject: [PATCH net-next v2 04/15] vsock: add 'transport' member in the struct vsock_sock
Date:   Thu, 14 Nov 2019 10:57:39 +0100
Message-Id: <20191114095750.59106-5-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: -txdL2sUNamqXRM8s7VjQA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation to support multiple transports, this patch adds
the 'transport' member at the 'struct vsock_sock'.
This new field is initialized during the creation in the
__vsock_create() function.

This patch also renames the global 'transport' pointer to
'transport_single', since for now we're only supporting a single
transport registered at run-time.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h   |  1 +
 net/vmw_vsock/af_vsock.c | 56 +++++++++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index c660402b10f2..a5e1e134261d 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -27,6 +27,7 @@ extern spinlock_t vsock_table_lock;
 struct vsock_sock {
 =09/* sk must be the first member. */
 =09struct sock sk;
+=09const struct vsock_transport *transport;
 =09struct sockaddr_vm local_addr;
 =09struct sockaddr_vm remote_addr;
 =09/* Links for the global tables of bound and connected sockets. */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index eb13693e9d04..d813967d7dd5 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -126,7 +126,7 @@ static struct proto vsock_proto =3D {
  */
 #define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
=20
-static const struct vsock_transport *transport;
+static const struct vsock_transport *transport_single;
 static DEFINE_MUTEX(vsock_register_mutex);
=20
 /**** UTILS ****/
@@ -408,7 +408,9 @@ static bool vsock_is_pending(struct sock *sk)
=20
 static int vsock_send_shutdown(struct sock *sk, int mode)
 {
-=09return transport->shutdown(vsock_sk(sk), mode);
+=09struct vsock_sock *vsk =3D vsock_sk(sk);
+
+=09return vsk->transport->shutdown(vsk, mode);
 }
=20
 static void vsock_pending_work(struct work_struct *work)
@@ -518,7 +520,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk,
 static int __vsock_bind_dgram(struct vsock_sock *vsk,
 =09=09=09      struct sockaddr_vm *addr)
 {
-=09return transport->dgram_bind(vsk, addr);
+=09return vsk->transport->dgram_bind(vsk, addr);
 }
=20
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
@@ -536,7 +538,7 @@ static int __vsock_bind(struct sock *sk, struct sockadd=
r_vm *addr)
 =09 * like AF_INET prevents binding to a non-local IP address (in most
 =09 * cases), we only allow binding to the local CID.
 =09 */
-=09cid =3D transport->get_local_cid();
+=09cid =3D vsk->transport->get_local_cid();
 =09if (addr->svm_cid !=3D cid && addr->svm_cid !=3D VMADDR_CID_ANY)
 =09=09return -EADDRNOTAVAIL;
=20
@@ -586,6 +588,7 @@ struct sock *__vsock_create(struct net *net,
 =09=09sk->sk_type =3D type;
=20
 =09vsk =3D vsock_sk(sk);
+=09vsk->transport =3D transport_single;
 =09vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 =09vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
=20
@@ -616,7 +619,7 @@ struct sock *__vsock_create(struct net *net,
 =09=09vsk->connect_timeout =3D VSOCK_DEFAULT_CONNECT_TIMEOUT;
 =09}
=20
-=09if (transport->init(vsk, psk) < 0) {
+=09if (vsk->transport->init(vsk, psk) < 0) {
 =09=09sk_free(sk);
 =09=09return NULL;
 =09}
@@ -640,7 +643,7 @@ static void __vsock_release(struct sock *sk, int level)
 =09=09/* The release call is supposed to use lock_sock_nested()
 =09=09 * rather than lock_sock(), if a sock lock should be acquired.
 =09=09 */
-=09=09transport->release(vsk);
+=09=09vsk->transport->release(vsk);
=20
 =09=09/* When "level" is SINGLE_DEPTH_NESTING, use the nested
 =09=09 * version to avoid the warning "possible recursive locking
@@ -668,7 +671,7 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 =09struct vsock_sock *vsk =3D vsock_sk(sk);
=20
-=09transport->destruct(vsk);
+=09vsk->transport->destruct(vsk);
=20
 =09/* When clearing these addresses, there's no need to set the family and
 =09 * possibly register the address family with the kernel.
@@ -692,13 +695,13 @@ static int vsock_queue_rcv_skb(struct sock *sk, struc=
t sk_buff *skb)
=20
 s64 vsock_stream_has_data(struct vsock_sock *vsk)
 {
-=09return transport->stream_has_data(vsk);
+=09return vsk->transport->stream_has_data(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
=20
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
-=09return transport->stream_has_space(vsk);
+=09return vsk->transport->stream_has_space(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_space);
=20
@@ -867,6 +870,7 @@ static __poll_t vsock_poll(struct file *file, struct so=
cket *sock,
 =09=09=09mask |=3D EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
=20
 =09} else if (sock->type =3D=3D SOCK_STREAM) {
+=09=09const struct vsock_transport *transport =3D vsk->transport;
 =09=09lock_sock(sk);
=20
 =09=09/* Listening sockets that have connections in their accept
@@ -942,6 +946,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, str=
uct msghdr *msg,
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
 =09struct sockaddr_vm *remote_addr;
+=09const struct vsock_transport *transport;
=20
 =09if (msg->msg_flags & MSG_OOB)
 =09=09return -EOPNOTSUPP;
@@ -950,6 +955,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, str=
uct msghdr *msg,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09lock_sock(sk);
=20
@@ -1034,8 +1040,8 @@ static int vsock_dgram_connect(struct socket *sock,
 =09if (err)
 =09=09goto out;
=20
-=09if (!transport->dgram_allow(remote_addr->svm_cid,
-=09=09=09=09    remote_addr->svm_port)) {
+=09if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
+=09=09=09=09=09 remote_addr->svm_port)) {
 =09=09err =3D -EINVAL;
 =09=09goto out;
 =09}
@@ -1051,7 +1057,9 @@ static int vsock_dgram_connect(struct socket *sock,
 static int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 =09=09=09       size_t len, int flags)
 {
-=09return transport->dgram_dequeue(vsock_sk(sock->sk), msg, len, flags);
+=09struct vsock_sock *vsk =3D vsock_sk(sock->sk);
+
+=09return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
 }
=20
 static const struct proto_ops vsock_dgram_ops =3D {
@@ -1077,6 +1085,8 @@ static const struct proto_ops vsock_dgram_ops =3D {
=20
 static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
 {
+=09const struct vsock_transport *transport =3D vsk->transport;
+
 =09if (!transport->cancel_pkt)
 =09=09return -EOPNOTSUPP;
=20
@@ -1113,6 +1123,7 @@ static int vsock_stream_connect(struct socket *sock, =
struct sockaddr *addr,
 =09int err;
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09struct sockaddr_vm *remote_addr;
 =09long timeout;
 =09DEFINE_WAIT(wait);
@@ -1120,6 +1131,7 @@ static int vsock_stream_connect(struct socket *sock, =
struct sockaddr *addr,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09lock_sock(sk);
=20
@@ -1363,6 +1375,7 @@ static int vsock_stream_setsockopt(struct socket *soc=
k,
 =09int err;
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09u64 val;
=20
 =09if (level !=3D AF_VSOCK)
@@ -1383,6 +1396,7 @@ static int vsock_stream_setsockopt(struct socket *soc=
k,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09lock_sock(sk);
=20
@@ -1440,6 +1454,7 @@ static int vsock_stream_getsockopt(struct socket *soc=
k,
 =09int len;
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09u64 val;
=20
 =09if (level !=3D AF_VSOCK)
@@ -1463,6 +1478,7 @@ static int vsock_stream_getsockopt(struct socket *soc=
k,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09switch (optname) {
 =09case SO_VM_SOCKETS_BUFFER_SIZE:
@@ -1507,6 +1523,7 @@ static int vsock_stream_sendmsg(struct socket *sock, =
struct msghdr *msg,
 {
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09ssize_t total_written;
 =09long timeout;
 =09int err;
@@ -1515,6 +1532,7 @@ static int vsock_stream_sendmsg(struct socket *sock, =
struct msghdr *msg,
=20
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
 =09total_written =3D 0;
 =09err =3D 0;
=20
@@ -1646,6 +1664,7 @@ vsock_stream_recvmsg(struct socket *sock, struct msgh=
dr *msg, size_t len,
 {
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09int err;
 =09size_t target;
 =09ssize_t copied;
@@ -1656,6 +1675,7 @@ vsock_stream_recvmsg(struct socket *sock, struct msgh=
dr *msg, size_t len,
=20
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
 =09err =3D 0;
=20
 =09lock_sock(sk);
@@ -1870,7 +1890,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
=20
 =09switch (cmd) {
 =09case IOCTL_VM_SOCKETS_GET_LOCAL_CID:
-=09=09if (put_user(transport->get_local_cid(), p) !=3D 0)
+=09=09if (put_user(transport_single->get_local_cid(), p) !=3D 0)
 =09=09=09retval =3D -EFAULT;
 =09=09break;
=20
@@ -1917,7 +1937,7 @@ int __vsock_core_init(const struct vsock_transport *t=
, struct module *owner)
 =09if (err)
 =09=09return err;
=20
-=09if (transport) {
+=09if (transport_single) {
 =09=09err =3D -EBUSY;
 =09=09goto err_busy;
 =09}
@@ -1926,7 +1946,7 @@ int __vsock_core_init(const struct vsock_transport *t=
, struct module *owner)
 =09 * unload while there are open sockets.
 =09 */
 =09vsock_proto.owner =3D owner;
-=09transport =3D t;
+=09transport_single =3D t;
=20
 =09vsock_device.minor =3D MISC_DYNAMIC_MINOR;
 =09err =3D misc_register(&vsock_device);
@@ -1956,7 +1976,7 @@ int __vsock_core_init(const struct vsock_transport *t=
, struct module *owner)
 err_deregister_misc:
 =09misc_deregister(&vsock_device);
 err_reset_transport:
-=09transport =3D NULL;
+=09transport_single =3D NULL;
 err_busy:
 =09mutex_unlock(&vsock_register_mutex);
 =09return err;
@@ -1973,7 +1993,7 @@ void vsock_core_exit(void)
=20
 =09/* We do not want the assignment below re-ordered. */
 =09mb();
-=09transport =3D NULL;
+=09transport_single =3D NULL;
=20
 =09mutex_unlock(&vsock_register_mutex);
 }
@@ -1984,7 +2004,7 @@ const struct vsock_transport *vsock_core_get_transpor=
t(void)
 =09/* vsock_register_mutex not taken since only the transport uses this
 =09 * function and only while registered.
 =09 */
-=09return transport;
+=09return transport_single;
 }
 EXPORT_SYMBOL_GPL(vsock_core_get_transport);
=20
--=20
2.21.0

