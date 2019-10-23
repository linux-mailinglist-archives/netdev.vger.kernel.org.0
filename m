Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1516FE170A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404248AbfJWJ6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:58:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404217AbfJWJ6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fY9kRAfeg9S5exAEeCR2/Eg7IAI3eCPFXL8A5gaHdUM=;
        b=KIb8ifgv6GMdbgw7DBj3qghdhvS03hU4SdCskOsiDlLNWIMTIPoKiZXiOFzKrYw5pSe7KD
        1BYS/MVyFCNOqHcOIDRfD1c25hbJ94veRmLDENBnQsSmEwxKG4j2HJb61jGID42stBl5bp
        smgwnxdSXxpn3fAMIa5fkqHSTBhJmjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-DR5l_pQzPwOPvEZ8NNP05Q-1; Wed, 23 Oct 2019 05:58:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45310107AD33;
        Wed, 23 Oct 2019 09:58:12 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9485C5C1B2;
        Wed, 23 Oct 2019 09:58:06 +0000 (UTC)
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
Subject: [PATCH net-next 11/14] vsock: add multi-transports support
Date:   Wed, 23 Oct 2019 11:55:51 +0200
Message-Id: <20191023095554.11340-12-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: DR5l_pQzPwOPvEZ8NNP05Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the support of multiple transports in the
VSOCK core.

With the multi-transports support, we can use vsock with nested VMs
(using also different hypervisors) loading both guest->host and
host->guest transports at the same time.

Major changes:
- vsock core module can be loaded regardless of the transports
- vsock_core_init() and vsock_core_exit() are renamed to
  vsock_core_register() and vsock_core_unregister()
- vsock_core_register() has a feature parameter (H2G, G2H, DGRAM)
  to identify which directions the transport can handle and if it's
  support DGRAM (only vmci)
- each stream socket is assigned to a transport when the remote CID
  is set (during the connect() or when we receive a connection request
  on a listener socket).
  The remote CID is used to decide which transport to use:
  - remote CID > VMADDR_CID_HOST will use host->guest transport
  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
- listener sockets are not bound to any transports since no transport
  operations are done on it. In this way we can create a listener
  socket, also if the transports are not loaded or with VMADDR_CID_ANY
  to listen on all transports.
- DGRAM sockets are handled as before, since only the vmci_transport
  provides this feature.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
RFC -> v1:
- documented VSOCK_TRANSPORT_F_* flags
- fixed vsock_assign_transport() when the socket is already assigned
  (e.g connection failed)
- moved features outside of struct vsock_transport, and used as
  parameter of vsock_core_register()
---
 drivers/vhost/vsock.c                   |   5 +-
 include/net/af_vsock.h                  |  17 +-
 net/vmw_vsock/af_vsock.c                | 237 ++++++++++++++++++------
 net/vmw_vsock/hyperv_transport.c        |  26 ++-
 net/vmw_vsock/virtio_transport.c        |   7 +-
 net/vmw_vsock/virtio_transport_common.c |  28 ++-
 net/vmw_vsock/vmci_transport.c          |  31 +++-
 7 files changed, 270 insertions(+), 81 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6d7e4f022748..b235f4bbe8ea 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -831,7 +831,8 @@ static int __init vhost_vsock_init(void)
 {
 =09int ret;
=20
-=09ret =3D vsock_core_init(&vhost_transport.transport);
+=09ret =3D vsock_core_register(&vhost_transport.transport,
+=09=09=09=09  VSOCK_TRANSPORT_F_H2G);
 =09if (ret < 0)
 =09=09return ret;
 =09return misc_register(&vhost_vsock_misc);
@@ -840,7 +841,7 @@ static int __init vhost_vsock_init(void)
 static void __exit vhost_vsock_exit(void)
 {
 =09misc_deregister(&vhost_vsock_misc);
-=09vsock_core_exit();
+=09vsock_core_unregister(&vhost_transport.transport);
 };
=20
 module_init(vhost_vsock_init);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index fa1570dc9f5c..27a3463e4892 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -91,6 +91,14 @@ struct vsock_transport_send_notify_data {
 =09u64 data2; /* Transport-defined. */
 };
=20
+/* Transport features flags */
+/* Transport provides host->guest communication */
+#define VSOCK_TRANSPORT_F_H2G=09=090x00000001
+/* Transport provides guest->host communication */
+#define VSOCK_TRANSPORT_F_G2H=09=090x00000002
+/* Transport provides DGRAM communication */
+#define VSOCK_TRANSPORT_F_DGRAM=09=090x00000004
+
 struct vsock_transport {
 =09/* Initialize/tear-down socket. */
 =09int (*init)(struct vsock_sock *, struct vsock_sock *);
@@ -154,12 +162,8 @@ struct vsock_transport {
=20
 /**** CORE ****/
=20
-int __vsock_core_init(const struct vsock_transport *t, struct module *owne=
r);
-static inline int vsock_core_init(const struct vsock_transport *t)
-{
-=09return __vsock_core_init(t, THIS_MODULE);
-}
-void vsock_core_exit(void);
+int vsock_core_register(const struct vsock_transport *t, int features);
+void vsock_core_unregister(const struct vsock_transport *t);
=20
 /* The transport may downcast this to access transport-specific functions =
*/
 const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *=
vsk);
@@ -190,6 +194,7 @@ struct sock *vsock_find_connected_socket(struct sockadd=
r_vm *src,
 =09=09=09=09=09 struct sockaddr_vm *dst);
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
+int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)=
;
=20
 /**** TAP ****/
=20
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d89381166028..dddd85d9a147 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -130,7 +130,12 @@ static struct proto vsock_proto =3D {
 #define VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)
 #define VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
=20
-static const struct vsock_transport *transport_single;
+/* Transport used for host->guest communication */
+static const struct vsock_transport *transport_h2g;
+/* Transport used for guest->host communication */
+static const struct vsock_transport *transport_g2h;
+/* Transport used for DGRAM communication */
+static const struct vsock_transport *transport_dgram;
 static DEFINE_MUTEX(vsock_register_mutex);
=20
 /**** UTILS ****/
@@ -182,7 +187,7 @@ static int vsock_auto_bind(struct vsock_sock *vsk)
 =09return __vsock_bind(sk, &local_addr);
 }
=20
-static int __init vsock_init_tables(void)
+static void vsock_init_tables(void)
 {
 =09int i;
=20
@@ -191,7 +196,6 @@ static int __init vsock_init_tables(void)
=20
 =09for (i =3D 0; i < ARRAY_SIZE(vsock_connected_table); i++)
 =09=09INIT_LIST_HEAD(&vsock_connected_table[i]);
-=09return 0;
 }
=20
 static void __vsock_insert_bound(struct list_head *list,
@@ -376,6 +380,62 @@ void vsock_enqueue_accept(struct sock *listener, struc=
t sock *connected)
 }
 EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
=20
+/* Assign a transport to a socket and call the .init transport callback.
+ *
+ * Note: for stream socket this must be called when vsk->remote_addr is se=
t
+ * (e.g. during the connect() or when a connection request on a listener
+ * socket is received).
+ * The vsk->remote_addr is used to decide which transport to use:
+ *  - remote CID > VMADDR_CID_HOST will use host->guest transport
+ *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
+ */
+int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
+{
+=09const struct vsock_transport *new_transport;
+=09struct sock *sk =3D sk_vsock(vsk);
+
+=09switch (sk->sk_type) {
+=09case SOCK_DGRAM:
+=09=09new_transport =3D transport_dgram;
+=09=09break;
+=09case SOCK_STREAM:
+=09=09if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
+=09=09=09new_transport =3D transport_h2g;
+=09=09else
+=09=09=09new_transport =3D transport_g2h;
+=09=09break;
+=09default:
+=09=09return -ESOCKTNOSUPPORT;
+=09}
+
+=09if (vsk->transport) {
+=09=09if (vsk->transport =3D=3D new_transport)
+=09=09=09return 0;
+
+=09=09vsk->transport->release(vsk);
+=09=09vsk->transport->destruct(vsk);
+=09}
+
+=09if (!new_transport)
+=09=09return -ENODEV;
+
+=09vsk->transport =3D new_transport;
+
+=09return vsk->transport->init(vsk, psk);
+}
+EXPORT_SYMBOL_GPL(vsock_assign_transport);
+
+static bool vsock_find_cid(unsigned int cid)
+{
+=09if (transport_g2h && cid =3D=3D transport_g2h->get_local_cid())
+=09=09return true;
+
+=09if (transport_h2g && cid =3D=3D VMADDR_CID_HOST)
+=09=09return true;
+
+=09return false;
+}
+
 static struct sock *vsock_dequeue_accept(struct sock *listener)
 {
 =09struct vsock_sock *vlistener;
@@ -414,6 +474,9 @@ static int vsock_send_shutdown(struct sock *sk, int mod=
e)
 {
 =09struct vsock_sock *vsk =3D vsock_sk(sk);
=20
+=09if (!vsk->transport)
+=09=09return -ENODEV;
+
 =09return vsk->transport->shutdown(vsk, mode);
 }
=20
@@ -530,7 +593,6 @@ static int __vsock_bind_dgram(struct vsock_sock *vsk,
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 {
 =09struct vsock_sock *vsk =3D vsock_sk(sk);
-=09u32 cid;
 =09int retval;
=20
 =09/* First ensure this socket isn't already bound. */
@@ -540,10 +602,9 @@ static int __vsock_bind(struct sock *sk, struct sockad=
dr_vm *addr)
 =09/* Now bind to the provided address or select appropriate values if
 =09 * none are provided (VMADDR_CID_ANY and VMADDR_PORT_ANY).  Note that
 =09 * like AF_INET prevents binding to a non-local IP address (in most
-=09 * cases), we only allow binding to the local CID.
+=09 * cases), we only allow binding to a local CID.
 =09 */
-=09cid =3D vsk->transport->get_local_cid();
-=09if (addr->svm_cid !=3D cid && addr->svm_cid !=3D VMADDR_CID_ANY)
+=09if (addr->svm_cid !=3D VMADDR_CID_ANY && !vsock_find_cid(addr->svm_cid)=
)
 =09=09return -EADDRNOTAVAIL;
=20
 =09switch (sk->sk_socket->type) {
@@ -592,7 +653,6 @@ static struct sock *__vsock_create(struct net *net,
 =09=09sk->sk_type =3D type;
=20
 =09vsk =3D vsock_sk(sk);
-=09vsk->transport =3D transport_single;
 =09vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 =09vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
=20
@@ -629,11 +689,6 @@ static struct sock *__vsock_create(struct net *net,
 =09=09vsk->buffer_max_size =3D VSOCK_DEFAULT_BUFFER_MAX_SIZE;
 =09}
=20
-=09if (vsk->transport->init(vsk, psk) < 0) {
-=09=09sk_free(sk);
-=09=09return NULL;
-=09}
-
 =09return sk;
 }
=20
@@ -650,7 +705,10 @@ static void __vsock_release(struct sock *sk, int level=
)
 =09=09/* The release call is supposed to use lock_sock_nested()
 =09=09 * rather than lock_sock(), if a sock lock should be acquired.
 =09=09 */
-=09=09vsk->transport->release(vsk);
+=09=09if (vsk->transport)
+=09=09=09vsk->transport->release(vsk);
+=09=09else if (sk->sk_type =3D=3D SOCK_STREAM)
+=09=09=09vsock_remove_sock(vsk);
=20
 =09=09/* When "level" is SINGLE_DEPTH_NESTING, use the nested
 =09=09 * version to avoid the warning "possible recursive locking
@@ -679,7 +737,8 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 =09struct vsock_sock *vsk =3D vsock_sk(sk);
=20
-=09vsk->transport->destruct(vsk);
+=09if (vsk->transport)
+=09=09vsk->transport->destruct(vsk);
=20
 =09/* When clearing these addresses, there's no need to set the family and
 =09 * possibly register the address family with the kernel.
@@ -896,7 +955,7 @@ static __poll_t vsock_poll(struct file *file, struct so=
cket *sock,
 =09=09=09mask |=3D EPOLLIN | EPOLLRDNORM;
=20
 =09=09/* If there is something in the queue then we can read. */
-=09=09if (transport->stream_is_active(vsk) &&
+=09=09if (transport && transport->stream_is_active(vsk) &&
 =09=09    !(sk->sk_shutdown & RCV_SHUTDOWN)) {
 =09=09=09bool data_ready_now =3D false;
 =09=09=09int ret =3D transport->notify_poll_in(
@@ -1146,7 +1205,6 @@ static int vsock_stream_connect(struct socket *sock, =
struct sockaddr *addr,
 =09err =3D 0;
 =09sk =3D sock->sk;
 =09vsk =3D vsock_sk(sk);
-=09transport =3D vsk->transport;
=20
 =09lock_sock(sk);
=20
@@ -1174,19 +1232,26 @@ static int vsock_stream_connect(struct socket *sock=
, struct sockaddr *addr,
 =09=09=09goto out;
 =09=09}
=20
+=09=09/* Set the remote address that we are connecting to. */
+=09=09memcpy(&vsk->remote_addr, remote_addr,
+=09=09       sizeof(vsk->remote_addr));
+
+=09=09err =3D vsock_assign_transport(vsk, NULL);
+=09=09if (err)
+=09=09=09goto out;
+
+=09=09transport =3D vsk->transport;
+
 =09=09/* The hypervisor and well-known contexts do not have socket
 =09=09 * endpoints.
 =09=09 */
-=09=09if (!transport->stream_allow(remote_addr->svm_cid,
+=09=09if (!transport ||
+=09=09    !transport->stream_allow(remote_addr->svm_cid,
 =09=09=09=09=09     remote_addr->svm_port)) {
 =09=09=09err =3D -ENETUNREACH;
 =09=09=09goto out;
 =09=09}
=20
-=09=09/* Set the remote address that we are connecting to. */
-=09=09memcpy(&vsk->remote_addr, remote_addr,
-=09=09       sizeof(vsk->remote_addr));
-
 =09=09err =3D vsock_auto_bind(vsk);
 =09=09if (err)
 =09=09=09goto out;
@@ -1586,7 +1651,7 @@ static int vsock_stream_sendmsg(struct socket *sock, =
struct msghdr *msg,
 =09=09goto out;
 =09}
=20
-=09if (sk->sk_state !=3D TCP_ESTABLISHED ||
+=09if (!transport || sk->sk_state !=3D TCP_ESTABLISHED ||
 =09    !vsock_addr_bound(&vsk->local_addr)) {
 =09=09err =3D -ENOTCONN;
 =09=09goto out;
@@ -1712,7 +1777,7 @@ vsock_stream_recvmsg(struct socket *sock, struct msgh=
dr *msg, size_t len,
=20
 =09lock_sock(sk);
=20
-=09if (sk->sk_state !=3D TCP_ESTABLISHED) {
+=09if (!transport || sk->sk_state !=3D TCP_ESTABLISHED) {
 =09=09/* Recvmsg is supposed to return 0 if a peer performs an
 =09=09 * orderly shutdown. Differentiate between that case and when a
 =09=09 * peer has not connected or a local shutdown occured with the
@@ -1886,7 +1951,9 @@ static const struct proto_ops vsock_stream_ops =3D {
 static int vsock_create(struct net *net, struct socket *sock,
 =09=09=09int protocol, int kern)
 {
+=09struct vsock_sock *vsk;
 =09struct sock *sk;
+=09int ret;
=20
 =09if (!sock)
 =09=09return -EINVAL;
@@ -1911,7 +1978,17 @@ static int vsock_create(struct net *net, struct sock=
et *sock,
 =09if (!sk)
 =09=09return -ENOMEM;
=20
-=09vsock_insert_unbound(vsock_sk(sk));
+=09vsk =3D vsock_sk(sk);
+
+=09if (sock->type =3D=3D SOCK_DGRAM) {
+=09=09ret =3D vsock_assign_transport(vsk, NULL);
+=09=09if (ret < 0) {
+=09=09=09sock_put(sk);
+=09=09=09return ret;
+=09=09}
+=09}
+
+=09vsock_insert_unbound(vsk);
=20
 =09return 0;
 }
@@ -1926,11 +2003,20 @@ static long vsock_dev_do_ioctl(struct file *filp,
 =09=09=09       unsigned int cmd, void __user *ptr)
 {
 =09u32 __user *p =3D ptr;
+=09u32 cid =3D VMADDR_CID_ANY;
 =09int retval =3D 0;
=20
 =09switch (cmd) {
 =09case IOCTL_VM_SOCKETS_GET_LOCAL_CID:
-=09=09if (put_user(transport_single->get_local_cid(), p) !=3D 0)
+=09=09/* To be compatible with the VMCI behavior, we prioritize the
+=09=09 * guest CID instead of well-know host CID (VMADDR_CID_HOST).
+=09=09 */
+=09=09if (transport_g2h)
+=09=09=09cid =3D transport_g2h->get_local_cid();
+=09=09else if (transport_h2g)
+=09=09=09cid =3D transport_h2g->get_local_cid();
+
+=09=09if (put_user(cid, p) !=3D 0)
 =09=09=09retval =3D -EFAULT;
 =09=09break;
=20
@@ -1970,24 +2056,13 @@ static struct miscdevice vsock_device =3D {
 =09.fops=09=09=3D &vsock_device_ops,
 };
=20
-int __vsock_core_init(const struct vsock_transport *t, struct module *owne=
r)
+static int __init vsock_init(void)
 {
-=09int err =3D mutex_lock_interruptible(&vsock_register_mutex);
+=09int err =3D 0;
=20
-=09if (err)
-=09=09return err;
-
-=09if (transport_single) {
-=09=09err =3D -EBUSY;
-=09=09goto err_busy;
-=09}
-
-=09/* Transport must be the owner of the protocol so that it can't
-=09 * unload while there are open sockets.
-=09 */
-=09vsock_proto.owner =3D owner;
-=09transport_single =3D t;
+=09vsock_init_tables();
=20
+=09vsock_proto.owner =3D THIS_MODULE;
 =09vsock_device.minor =3D MISC_DYNAMIC_MINOR;
 =09err =3D misc_register(&vsock_device);
 =09if (err) {
@@ -2008,7 +2083,6 @@ int __vsock_core_init(const struct vsock_transport *t=
, struct module *owner)
 =09=09goto err_unregister_proto;
 =09}
=20
-=09mutex_unlock(&vsock_register_mutex);
 =09return 0;
=20
 err_unregister_proto:
@@ -2016,28 +2090,15 @@ int __vsock_core_init(const struct vsock_transport =
*t, struct module *owner)
 err_deregister_misc:
 =09misc_deregister(&vsock_device);
 err_reset_transport:
-=09transport_single =3D NULL;
-err_busy:
-=09mutex_unlock(&vsock_register_mutex);
 =09return err;
 }
-EXPORT_SYMBOL_GPL(__vsock_core_init);
=20
-void vsock_core_exit(void)
+static void __exit vsock_exit(void)
 {
-=09mutex_lock(&vsock_register_mutex);
-
 =09misc_deregister(&vsock_device);
 =09sock_unregister(AF_VSOCK);
 =09proto_unregister(&vsock_proto);
-
-=09/* We do not want the assignment below re-ordered. */
-=09mb();
-=09transport_single =3D NULL;
-
-=09mutex_unlock(&vsock_register_mutex);
 }
-EXPORT_SYMBOL_GPL(vsock_core_exit);
=20
 const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *=
vsk)
 {
@@ -2045,12 +2106,70 @@ const struct vsock_transport *vsock_core_get_transp=
ort(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_core_get_transport);
=20
-static void __exit vsock_exit(void)
+int vsock_core_register(const struct vsock_transport *t, int features)
+{
+=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
+=09int err =3D mutex_lock_interruptible(&vsock_register_mutex);
+
+=09if (err)
+=09=09return err;
+
+=09t_h2g =3D transport_h2g;
+=09t_g2h =3D transport_g2h;
+=09t_dgram =3D transport_dgram;
+
+=09if (features & VSOCK_TRANSPORT_F_H2G) {
+=09=09if (t_h2g) {
+=09=09=09err =3D -EBUSY;
+=09=09=09goto err_busy;
+=09=09}
+=09=09t_h2g =3D t;
+=09}
+
+=09if (features & VSOCK_TRANSPORT_F_G2H) {
+=09=09if (t_g2h) {
+=09=09=09err =3D -EBUSY;
+=09=09=09goto err_busy;
+=09=09}
+=09=09t_g2h =3D t;
+=09}
+
+=09if (features & VSOCK_TRANSPORT_F_DGRAM) {
+=09=09if (t_dgram) {
+=09=09=09err =3D -EBUSY;
+=09=09=09goto err_busy;
+=09=09}
+=09=09t_dgram =3D t;
+=09}
+
+=09transport_h2g =3D t_h2g;
+=09transport_g2h =3D t_g2h;
+=09transport_dgram =3D t_dgram;
+
+err_busy:
+=09mutex_unlock(&vsock_register_mutex);
+=09return err;
+}
+EXPORT_SYMBOL_GPL(vsock_core_register);
+
+void vsock_core_unregister(const struct vsock_transport *t)
 {
-=09/* Do nothing.  This function makes this module removable. */
+=09mutex_lock(&vsock_register_mutex);
+
+=09if (transport_h2g =3D=3D t)
+=09=09transport_h2g =3D NULL;
+
+=09if (transport_g2h =3D=3D t)
+=09=09transport_g2h =3D NULL;
+
+=09if (transport_dgram =3D=3D t)
+=09=09transport_dgram =3D NULL;
+
+=09mutex_unlock(&vsock_register_mutex);
 }
+EXPORT_SYMBOL_GPL(vsock_core_unregister);
=20
-module_init(vsock_init_tables);
+module_init(vsock_init);
 module_exit(vsock_exit);
=20
 MODULE_AUTHOR("VMware, Inc.");
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index fc7e61765a4a..0ea66d87af39 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -165,6 +165,8 @@ static const guid_t srv_id_template =3D
 =09GUID_INIT(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
 =09=09  0x64, 0x00, 0x6a, 0x79, 0x86, 0xd3);
=20
+static bool hvs_check_transport(struct vsock_sock *vsk);
+
 static bool is_valid_srv_id(const guid_t *id)
 {
 =09return !memcmp(&id->b[4], &srv_id_template.b[4], sizeof(guid_t) - 4);
@@ -367,6 +369,18 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
=20
 =09=09new->sk_state =3D TCP_SYN_SENT;
 =09=09vnew =3D vsock_sk(new);
+
+=09=09hvs_addr_init(&vnew->local_addr, if_type);
+=09=09hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
+
+=09=09ret =3D vsock_assign_transport(vnew, vsock_sk(sk));
+=09=09/* Transport assigned (looking at remote_addr) must be the
+=09=09 * same where we received the request.
+=09=09 */
+=09=09if (ret || !hvs_check_transport(vnew)) {
+=09=09=09sock_put(new);
+=09=09=09goto out;
+=09=09}
 =09=09hvs_new =3D vnew->trans;
 =09=09hvs_new->chan =3D chan;
 =09} else {
@@ -430,9 +444,6 @@ static void hvs_open_connection(struct vmbus_channel *c=
han)
 =09=09new->sk_state =3D TCP_ESTABLISHED;
 =09=09sk->sk_ack_backlog++;
=20
-=09=09hvs_addr_init(&vnew->local_addr, if_type);
-=09=09hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
-
 =09=09hvs_new->vm_srv_id =3D *if_type;
 =09=09hvs_new->host_srv_id =3D *if_instance;
=20
@@ -880,6 +891,11 @@ static struct vsock_transport hvs_transport =3D {
=20
 };
=20
+static bool hvs_check_transport(struct vsock_sock *vsk)
+{
+=09return vsk->transport =3D=3D &hvs_transport;
+}
+
 static int hvs_probe(struct hv_device *hdev,
 =09=09     const struct hv_vmbus_device_id *dev_id)
 {
@@ -928,7 +944,7 @@ static int __init hvs_init(void)
 =09if (ret !=3D 0)
 =09=09return ret;
=20
-=09ret =3D vsock_core_init(&hvs_transport);
+=09ret =3D vsock_core_register(&hvs_transport, VSOCK_TRANSPORT_F_G2H);
 =09if (ret) {
 =09=09vmbus_driver_unregister(&hvs_drv);
 =09=09return ret;
@@ -939,7 +955,7 @@ static int __init hvs_init(void)
=20
 static void __exit hvs_exit(void)
 {
-=09vsock_core_exit();
+=09vsock_core_unregister(&hvs_transport);
 =09vmbus_driver_unregister(&hvs_drv);
 }
=20
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transp=
ort.c
index fb1fc7760e8c..83ad85050384 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -770,7 +770,8 @@ static int __init virtio_vsock_init(void)
 =09if (!virtio_vsock_workqueue)
 =09=09return -ENOMEM;
=20
-=09ret =3D vsock_core_init(&virtio_transport.transport);
+=09ret =3D vsock_core_register(&virtio_transport.transport,
+=09=09=09=09  VSOCK_TRANSPORT_F_G2H);
 =09if (ret)
 =09=09goto out_wq;
=20
@@ -781,7 +782,7 @@ static int __init virtio_vsock_init(void)
 =09return 0;
=20
 out_vci:
-=09vsock_core_exit();
+=09vsock_core_unregister(&virtio_transport.transport);
 out_wq:
 =09destroy_workqueue(virtio_vsock_workqueue);
 =09return ret;
@@ -790,7 +791,7 @@ static int __init virtio_vsock_init(void)
 static void __exit virtio_vsock_exit(void)
 {
 =09unregister_virtio_driver(&virtio_vsock_driver);
-=09vsock_core_exit();
+=09vsock_core_unregister(&virtio_transport.transport);
 =09destroy_workqueue(virtio_vsock_workqueue);
 }
=20
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index f7d0ecbd8f97..b39917eb120e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -453,7 +453,7 @@ int virtio_transport_do_socket_init(struct vsock_sock *=
vsk,
=20
 =09vsk->trans =3D vvs;
 =09vvs->vsk =3D vsk;
-=09if (psk) {
+=09if (psk && psk->trans) {
 =09=09struct virtio_vsock_sock *ptrans =3D psk->trans;
=20
 =09=09vvs->peer_buf_alloc =3D ptrans->peer_buf_alloc;
@@ -986,11 +986,13 @@ virtio_transport_send_response(struct vsock_sock *vsk=
,
=20
 /* Handle server socket */
 static int
-virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt=
)
+virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt=
,
+=09=09=09     struct virtio_transport *t)
 {
 =09struct vsock_sock *vsk =3D vsock_sk(sk);
 =09struct vsock_sock *vchild;
 =09struct sock *child;
+=09int ret;
=20
 =09if (le16_to_cpu(pkt->hdr.op) !=3D VIRTIO_VSOCK_OP_REQUEST) {
 =09=09virtio_transport_reset(vsk, pkt);
@@ -1020,6 +1022,17 @@ virtio_transport_recv_listen(struct sock *sk, struct=
 virtio_vsock_pkt *pkt)
 =09vsock_addr_init(&vchild->remote_addr, le64_to_cpu(pkt->hdr.src_cid),
 =09=09=09le32_to_cpu(pkt->hdr.src_port));
=20
+=09ret =3D vsock_assign_transport(vchild, vsk);
+=09/* Transport assigned (looking at remote_addr) must be the same
+=09 * where we received the request.
+=09 */
+=09if (ret || vchild->transport !=3D &t->transport) {
+=09=09release_sock(child);
+=09=09virtio_transport_reset(vsk, pkt);
+=09=09sock_put(child);
+=09=09return ret;
+=09}
+
 =09vsock_insert_connected(vchild);
 =09vsock_enqueue_accept(sk, child);
 =09virtio_transport_send_response(vchild, pkt);
@@ -1037,6 +1050,14 @@ static bool virtio_transport_space_update(struct soc=
k *sk,
 =09struct virtio_vsock_sock *vvs =3D vsk->trans;
 =09bool space_available;
=20
+=09/* Listener sockets are not associated with any transport, so we are
+=09 * not able to take the state to see if there is space available in the
+=09 * remote peer, but since they are only used to receive requests, we
+=09 * can assume that there is always space available in the other peer.
+=09 */
+=09if (!vvs)
+=09=09return true;
+
 =09/* buf_alloc and fwd_cnt is always included in the hdr */
 =09spin_lock_bh(&vvs->tx_lock);
 =09vvs->peer_buf_alloc =3D le32_to_cpu(pkt->hdr.buf_alloc);
@@ -1102,7 +1123,7 @@ void virtio_transport_recv_pkt(struct virtio_transpor=
t *t,
=20
 =09switch (sk->sk_state) {
 =09case TCP_LISTEN:
-=09=09virtio_transport_recv_listen(sk, pkt);
+=09=09virtio_transport_recv_listen(sk, pkt, t);
 =09=09virtio_transport_free_pkt(pkt);
 =09=09break;
 =09case TCP_SYN_SENT:
@@ -1120,6 +1141,7 @@ void virtio_transport_recv_pkt(struct virtio_transpor=
t *t,
 =09=09virtio_transport_free_pkt(pkt);
 =09=09break;
 =09}
+
 =09release_sock(sk);
=20
 =09/* Release refcnt obtained when we fetched this socket out of the
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 5955238ffc13..2eb3f16d53e7 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -57,6 +57,7 @@ static bool vmci_transport_old_proto_override(bool *old_p=
kt_proto);
 static u16 vmci_transport_new_proto_supported_versions(void);
 static bool vmci_transport_proto_to_notify_struct(struct sock *sk, u16 *pr=
oto,
 =09=09=09=09=09=09  bool old_pkt_proto);
+static bool vmci_check_transport(struct vsock_sock *vsk);
=20
 struct vmci_transport_recv_pkt_info {
 =09struct work_struct work;
@@ -1017,6 +1018,15 @@ static int vmci_transport_recv_listen(struct sock *s=
k,
 =09vsock_addr_init(&vpending->remote_addr, pkt->dg.src.context,
 =09=09=09pkt->src_port);
=20
+=09err =3D vsock_assign_transport(vpending, vsock_sk(sk));
+=09/* Transport assigned (looking at remote_addr) must be the same
+=09 * where we received the request.
+=09 */
+=09if (err || !vmci_check_transport(vpending)) {
+=09=09sock_put(pending);
+=09=09return err;
+=09}
+
 =09/* If the proposed size fits within our min/max, accept it. Otherwise
 =09 * propose our own size.
 =09 */
@@ -2008,7 +2018,7 @@ static u32 vmci_transport_get_local_cid(void)
 =09return vmci_get_context_id();
 }
=20
-static const struct vsock_transport vmci_transport =3D {
+static struct vsock_transport vmci_transport =3D {
 =09.init =3D vmci_transport_socket_init,
 =09.destruct =3D vmci_transport_destruct,
 =09.release =3D vmci_transport_release,
@@ -2038,10 +2048,25 @@ static const struct vsock_transport vmci_transport =
=3D {
 =09.get_local_cid =3D vmci_transport_get_local_cid,
 };
=20
+static bool vmci_check_transport(struct vsock_sock *vsk)
+{
+=09return vsk->transport =3D=3D &vmci_transport;
+}
+
 static int __init vmci_transport_init(void)
 {
+=09int features =3D VSOCK_TRANSPORT_F_DGRAM | VSOCK_TRANSPORT_F_H2G;
+=09int cid;
 =09int err;
=20
+=09cid =3D vmci_get_context_id();
+
+=09if (cid =3D=3D VMCI_INVALID_ID)
+=09=09return -EINVAL;
+
+=09if (cid !=3D VMCI_HOST_CONTEXT_ID)
+=09=09features |=3D VSOCK_TRANSPORT_F_G2H;
+
 =09/* Create the datagram handle that we will use to send and receive all
 =09 * VSocket control messages for this context.
 =09 */
@@ -2065,7 +2090,7 @@ static int __init vmci_transport_init(void)
 =09=09goto err_destroy_stream_handle;
 =09}
=20
-=09err =3D vsock_core_init(&vmci_transport);
+=09err =3D vsock_core_register(&vmci_transport, features);
 =09if (err < 0)
 =09=09goto err_unsubscribe;
=20
@@ -2096,7 +2121,7 @@ static void __exit vmci_transport_exit(void)
 =09=09vmci_transport_qp_resumed_sub_id =3D VMCI_INVALID_ID;
 =09}
=20
-=09vsock_core_exit();
+=09vsock_core_unregister(&vmci_transport);
 }
 module_exit(vmci_transport_exit);
=20
--=20
2.21.0

