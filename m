Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E69BE16E1
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391035AbfJWJ5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:57:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54816 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390990AbfJWJ5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrWFvXQyogrOoIVt0ldFhISsLZ59Cn9KyEtJqWHGRz4=;
        b=bDGqQmF4E4nkam061ExDAF4IIvUSYmpTzRYbu4V9KKHdCvgEogd6K3xKb58Fs8zx12pJaG
        AHevev10IUIUwWQDcz/jOa3z3nnyC8GswSxJKzsXg1ujVo+oCTYPpoZFfBq2rUd2/3Pq0l
        RMIrgZVmvOFNKEwGVVghY7ql88LAxSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-77PGSS_8M_-kg7TYbOsZaw-1; Wed, 23 Oct 2019 05:57:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C02B680183D;
        Wed, 23 Oct 2019 09:57:14 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F29A45C1B2;
        Wed, 23 Oct 2019 09:56:29 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next 04/14] vsock: add 'transport' member in the struct vsock_sock
Date:   Wed, 23 Oct 2019 11:55:44 +0200
Message-Id: <20191023095554.11340-5-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 77PGSS_8M_-kg7TYbOsZaw-1
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
index 2f2582fb7fdd..c3a14f853eb0 100644
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
@@ -641,7 +644,7 @@ static void __vsock_release(struct sock *sk, int level)
 =09=09/* The release call is supposed to use lock_sock_nested()
 =09=09 * rather than lock_sock(), if a sock lock should be acquired.
 =09=09 */
-=09=09transport->release(vsk);
+=09=09vsk->transport->release(vsk);
=20
 =09=09/* When "level" is SINGLE_DEPTH_NESTING, use the nested
 =09=09 * version to avoid the warning "possible recursive locking
@@ -670,7 +673,7 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 =09struct vsock_sock *vsk =3D vsock_sk(sk);
=20
-=09transport->destruct(vsk);
+=09vsk->transport->destruct(vsk);
=20
 =09/* When clearing these addresses, there's no need to set the family and
 =09 * possibly register the address family with the kernel.
@@ -694,13 +697,13 @@ static int vsock_queue_rcv_skb(struct sock *sk, struc=
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
@@ -869,6 +872,7 @@ static __poll_t vsock_poll(struct file *file, struct so=
cket *sock,
 =09=09=09mask |=3D EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
=20
 =09} else if (sock->type =3D=3D SOCK_STREAM) {
+=09=09const struct vsock_transport *transport =3D vsk->transport;
 =09=09lock_sock(sk);
=20
 =09=09/* Listening sockets that have connections in their accept
@@ -944,6 +948,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, str=
uct msghdr *msg,
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
 =09struct sockaddr_vm *remote_addr;
+=09const struct vsock_transport *transport;
=20
 =09if (msg->msg_flags & MSG_OOB)
 =09=09return -EOPNOTSUPP;
@@ -952,6 +957,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, str=
uct msghdr *msg,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09lock_sock(sk);
=20
@@ -1036,8 +1042,8 @@ static int vsock_dgram_connect(struct socket *sock,
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
@@ -1053,7 +1059,9 @@ static int vsock_dgram_connect(struct socket *sock,
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
@@ -1079,6 +1087,8 @@ static const struct proto_ops vsock_dgram_ops =3D {
=20
 static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
 {
+=09const struct vsock_transport *transport =3D vsk->transport;
+
 =09if (!transport->cancel_pkt)
 =09=09return -EOPNOTSUPP;
=20
@@ -1115,6 +1125,7 @@ static int vsock_stream_connect(struct socket *sock, =
struct sockaddr *addr,
 =09int err;
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09struct sockaddr_vm *remote_addr;
 =09long timeout;
 =09DEFINE_WAIT(wait);
@@ -1122,6 +1133,7 @@ static int vsock_stream_connect(struct socket *sock, =
struct sockaddr *addr,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09lock_sock(sk);
=20
@@ -1365,6 +1377,7 @@ static int vsock_stream_setsockopt(struct socket *soc=
k,
 =09int err;
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09u64 val;
=20
 =09if (level !=3D AF_VSOCK)
@@ -1385,6 +1398,7 @@ static int vsock_stream_setsockopt(struct socket *soc=
k,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09lock_sock(sk);
=20
@@ -1442,6 +1456,7 @@ static int vsock_stream_getsockopt(struct socket *soc=
k,
 =09int len;
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09u64 val;
=20
 =09if (level !=3D AF_VSOCK)
@@ -1465,6 +1480,7 @@ static int vsock_stream_getsockopt(struct socket *soc=
k,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
=20
 =09switch (optname) {
 =09case SO_VM_SOCKETS_BUFFER_SIZE:
@@ -1509,6 +1525,7 @@ static int vsock_stream_sendmsg(struct socket *sock, =
struct msghdr *msg,
 {
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09ssize_t total_written;
 =09long timeout;
 =09int err;
@@ -1517,6 +1534,7 @@ static int vsock_stream_sendmsg(struct socket *sock, =
struct msghdr *msg,
=20
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
 =09total_written =3D 0;
 =09err =3D 0;
=20
@@ -1648,6 +1666,7 @@ vsock_stream_recvmsg(struct socket *sock, struct msgh=
dr *msg, size_t len,
 {
 =09struct sock *sk;
 =09struct vsock_sock *vsk;
+=09const struct vsock_transport *transport;
 =09int err;
 =09size_t target;
 =09ssize_t copied;
@@ -1658,6 +1677,7 @@ vsock_stream_recvmsg(struct socket *sock, struct msgh=
dr *msg, size_t len,
=20
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
+=09transport =3D vsk->transport;
 =09err =3D 0;
=20
 =09lock_sock(sk);
@@ -1872,7 +1892,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
=20
 =09switch (cmd) {
 =09case IOCTL_VM_SOCKETS_GET_LOCAL_CID:
-=09=09if (put_user(transport->get_local_cid(), p) !=3D 0)
+=09=09if (put_user(transport_single->get_local_cid(), p) !=3D 0)
 =09=09=09retval =3D -EFAULT;
 =09=09break;
=20
@@ -1919,7 +1939,7 @@ int __vsock_core_init(const struct vsock_transport *t=
, struct module *owner)
 =09if (err)
 =09=09return err;
=20
-=09if (transport) {
+=09if (transport_single) {
 =09=09err =3D -EBUSY;
 =09=09goto err_busy;
 =09}
@@ -1928,7 +1948,7 @@ int __vsock_core_init(const struct vsock_transport *t=
, struct module *owner)
 =09 * unload while there are open sockets.
 =09 */
 =09vsock_proto.owner =3D owner;
-=09transport =3D t;
+=09transport_single =3D t;
=20
 =09vsock_device.minor =3D MISC_DYNAMIC_MINOR;
 =09err =3D misc_register(&vsock_device);
@@ -1958,7 +1978,7 @@ int __vsock_core_init(const struct vsock_transport *t=
, struct module *owner)
 err_deregister_misc:
 =09misc_deregister(&vsock_device);
 err_reset_transport:
-=09transport =3D NULL;
+=09transport_single =3D NULL;
 err_busy:
 =09mutex_unlock(&vsock_register_mutex);
 =09return err;
@@ -1975,7 +1995,7 @@ void vsock_core_exit(void)
=20
 =09/* We do not want the assignment below re-ordered. */
 =09mb();
-=09transport =3D NULL;
+=09transport_single =3D NULL;
=20
 =09mutex_unlock(&vsock_register_mutex);
 }
@@ -1986,7 +2006,7 @@ const struct vsock_transport *vsock_core_get_transpor=
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

