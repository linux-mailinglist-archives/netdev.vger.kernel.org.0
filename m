Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A062C0454
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfI0L23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:28:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36571 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfI0L21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:28:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3448300894D;
        Fri, 27 Sep 2019 11:28:26 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A66335D9C3;
        Fri, 27 Sep 2019 11:28:23 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 10/13] vsock: add multi-transports support
Date:   Fri, 27 Sep 2019 13:27:00 +0200
Message-Id: <20190927112703.17745-11-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 27 Sep 2019 11:28:26 +0000 (UTC)
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
- vsock core module can be loaded interdependently of the transports
- each 'struct virtio_transport' has a new feature fields
  (H2G, G2H, DGRAM) to identify which directions the transport can
  handle and if it's support DGRAM (only vmci)
- vsock_core_init() and vsock_core_exit() are renamed to
  vsock_core_register() and vsock_core_unregister()
- each stream socket is assigned to a transport when the remote CID
  is set (during the connect() or when we receive a connection request
  on a listener socket).
  The remote CID is used to decide which transport to use:
  - remote CID > VMADDR_CID_HOST will use host->guest transport
  - remote CID <= VMADDR_CID_HOST will use guest->host transport
- listener sockets are not bound to any transports since no transport
  operations are done on it. In this way we can create a listener
  socket, also if the transports are not loaded or with VMADDR_CID_ANY
  to listen on all transports.
- DGRAM sockets are handled as before, since only the vmci_transport
  provides this feature.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
RFC:
- I'd like to move MODULE_ALIAS_NETPROTO(PF_VSOCK) to af_vsock.c.
  @Jorgen could this break the VMware products?
- DGRAM sockets are handled as before, I don't know if make sense work
  on it now, or when another transport will support DGRAM. The big
  issues here is that we cannot link 1-1 a socket to transport as
  for stream sockets since DGRAM is not connection-oriented.
---
 drivers/vhost/vsock.c                   |   6 +-
 include/net/af_vsock.h                  |  15 +-
 net/vmw_vsock/af_vsock.c                | 240 ++++++++++++++++++------
 net/vmw_vsock/hyperv_transport.c        |  28 ++-
 net/vmw_vsock/virtio_transport.c        |   8 +-
 net/vmw_vsock/virtio_transport_common.c |  28 ++-
 net/vmw_vsock/vmci_transport.c          |  31 ++-
 7 files changed, 275 insertions(+), 81 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6d7e4f022748..375af01a5b64 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -386,6 +386,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 
 static struct virtio_transport vhost_transport = {
 	.transport = {
+		.features                 = VSOCK_TRANSPORT_F_H2G,
+
 		.get_local_cid            = vhost_transport_get_local_cid,
 
 		.init                     = virtio_transport_do_socket_init,
@@ -831,7 +833,7 @@ static int __init vhost_vsock_init(void)
 {
 	int ret;
 
-	ret = vsock_core_init(&vhost_transport.transport);
+	ret = vsock_core_register(&vhost_transport.transport);
 	if (ret < 0)
 		return ret;
 	return misc_register(&vhost_vsock_misc);
@@ -840,7 +842,7 @@ static int __init vhost_vsock_init(void)
 static void __exit vhost_vsock_exit(void)
 {
 	misc_deregister(&vhost_vsock_misc);
-	vsock_core_exit();
+	vsock_core_unregister(&vhost_transport.transport);
 };
 
 module_init(vhost_vsock_init);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 86f8f463e01a..2a081d19e20d 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -94,7 +94,13 @@ struct vsock_transport_send_notify_data {
 	u64 data2; /* Transport-defined. */
 };
 
+#define VSOCK_TRANSPORT_F_H2G		0x00000001
+#define VSOCK_TRANSPORT_F_G2H		0x00000002
+#define VSOCK_TRANSPORT_F_DGRAM		0x00000004
+
 struct vsock_transport {
+	uint64_t features;
+
 	/* Initialize/tear-down socket. */
 	int (*init)(struct vsock_sock *, struct vsock_sock *);
 	void (*destruct)(struct vsock_sock *);
@@ -156,12 +162,8 @@ struct vsock_transport {
 
 /**** CORE ****/
 
-int __vsock_core_init(const struct vsock_transport *t, struct module *owner);
-static inline int vsock_core_init(const struct vsock_transport *t)
-{
-	return __vsock_core_init(t, THIS_MODULE);
-}
-void vsock_core_exit(void);
+int vsock_core_register(const struct vsock_transport *t);
+void vsock_core_unregister(const struct vsock_transport *t);
 
 /* The transport may downcast this to access transport-specific functions */
 const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk);
@@ -192,6 +194,7 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 					 struct sockaddr_vm *dst);
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
+int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 
 /**** TAP ****/
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 95e6db21e7e1..c52203fe52c4 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -130,7 +130,12 @@ static struct proto vsock_proto = {
 #define VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)
 #define VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
 
-static const struct vsock_transport *transport_single;
+/* Transport used for host->guest communication */
+static const struct vsock_transport *transport_h2g;
+/* Transport used for guest->host communication */
+static const struct vsock_transport *transport_g2h;
+/* Transport used for DGRAM communication */
+static const struct vsock_transport *transport_dgram;
 static DEFINE_MUTEX(vsock_register_mutex);
 
 /**** UTILS ****/
@@ -182,7 +187,7 @@ static int vsock_auto_bind(struct vsock_sock *vsk)
 	return __vsock_bind(sk, &local_addr);
 }
 
-static int __init vsock_init_tables(void)
+static void vsock_init_tables(void)
 {
 	int i;
 
@@ -191,7 +196,6 @@ static int __init vsock_init_tables(void)
 
 	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++)
 		INIT_LIST_HEAD(&vsock_connected_table[i]);
-	return 0;
 }
 
 static void __vsock_insert_bound(struct list_head *list,
@@ -376,6 +380,55 @@ void vsock_enqueue_accept(struct sock *listener, struct sock *connected)
 }
 EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
 
+/* Assign a transport to a socket and call the .init transport callback.
+ *
+ * Note: for stream socket this must be called when vsk->remote_addr is set
+ * (e.g. during the connect() or when a connection request on a listener
+ * socket is received).
+ * The vsk->remote_addr is used to decide which transport to use:
+ *  - remote CID > VMADDR_CID_HOST will use host->guest transport
+ *  - remote CID <= VMADDR_CID_HOST will use guest->host transport
+ */
+int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
+{
+	struct sock *sk = sk_vsock(vsk);
+	/* RFC-TODO: should vsk->transport be already assigned?
+	 * How to handle?
+	 */
+	WARN_ON(vsk->transport);
+
+	switch (sk->sk_type) {
+	case SOCK_DGRAM:
+		vsk->transport = transport_dgram;
+		break;
+	case SOCK_STREAM:
+		if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
+			vsk->transport = transport_h2g;
+		else
+			vsk->transport = transport_g2h;
+		break;
+	default:
+		return -ESOCKTNOSUPPORT;
+	}
+
+	if (!vsk->transport)
+		return -ENODEV;
+
+	return vsk->transport->init(vsk, psk);
+}
+EXPORT_SYMBOL_GPL(vsock_assign_transport);
+
+static bool vsock_find_cid(unsigned int cid)
+{
+	if (transport_g2h && cid == transport_g2h->get_local_cid())
+		return true;
+
+	if (transport_h2g && cid == VMADDR_CID_HOST)
+		return true;
+
+	return false;
+}
+
 static struct sock *vsock_dequeue_accept(struct sock *listener)
 {
 	struct vsock_sock *vlistener;
@@ -414,6 +467,9 @@ static int vsock_send_shutdown(struct sock *sk, int mode)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 
+	if (!vsk->transport)
+		return -ENODEV;
+
 	return vsk->transport->shutdown(vsk, mode);
 }
 
@@ -530,7 +586,6 @@ static int __vsock_bind_dgram(struct vsock_sock *vsk,
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
-	u32 cid;
 	int retval;
 
 	/* First ensure this socket isn't already bound. */
@@ -540,10 +595,9 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 	/* Now bind to the provided address or select appropriate values if
 	 * none are provided (VMADDR_CID_ANY and VMADDR_PORT_ANY).  Note that
 	 * like AF_INET prevents binding to a non-local IP address (in most
-	 * cases), we only allow binding to the local CID.
+	 * cases), we only allow binding to a local CID.
 	 */
-	cid = vsk->transport->get_local_cid();
-	if (addr->svm_cid != cid && addr->svm_cid != VMADDR_CID_ANY)
+	if (addr->svm_cid != VMADDR_CID_ANY && !vsock_find_cid(addr->svm_cid))
 		return -EADDRNOTAVAIL;
 
 	switch (sk->sk_socket->type) {
@@ -592,7 +646,6 @@ struct sock *__vsock_create(struct net *net,
 		sk->sk_type = type;
 
 	vsk = vsock_sk(sk);
-	vsk->transport = transport_single;
 	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 
@@ -629,11 +682,6 @@ struct sock *__vsock_create(struct net *net,
 		vsk->buffer_max_size = VSOCK_DEFAULT_BUFFER_MAX_SIZE;
 	}
 
-	if (vsk->transport->init(vsk, psk) < 0) {
-		sk_free(sk);
-		return NULL;
-	}
-
 	return sk;
 }
 EXPORT_SYMBOL_GPL(__vsock_create);
@@ -648,7 +696,10 @@ static void __vsock_release(struct sock *sk)
 		vsk = vsock_sk(sk);
 		pending = NULL;	/* Compiler warning. */
 
-		vsk->transport->release(vsk);
+		if (vsk->transport)
+			vsk->transport->release(vsk);
+		else if (sk->sk_type == SOCK_STREAM)
+			vsock_remove_sock(vsk);
 
 		lock_sock(sk);
 		sock_orphan(sk);
@@ -672,7 +723,8 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 
-	vsk->transport->destruct(vsk);
+	if (vsk->transport)
+		vsk->transport->destruct(vsk);
 
 	/* When clearing these addresses, there's no need to set the family and
 	 * possibly register the address family with the kernel.
@@ -882,7 +934,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 			mask |= EPOLLIN | EPOLLRDNORM;
 
 		/* If there is something in the queue then we can read. */
-		if (transport->stream_is_active(vsk) &&
+		if (transport && transport->stream_is_active(vsk) &&
 		    !(sk->sk_shutdown & RCV_SHUTDOWN)) {
 			bool data_ready_now = false;
 			int ret = transport->notify_poll_in(
@@ -1132,7 +1184,6 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 	err = 0;
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
 
 	lock_sock(sk);
 
@@ -1160,19 +1211,26 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 			goto out;
 		}
 
+		/* Set the remote address that we are connecting to. */
+		memcpy(&vsk->remote_addr, remote_addr,
+		       sizeof(vsk->remote_addr));
+
+		err = vsock_assign_transport(vsk, NULL);
+		if (err)
+			goto out;
+
+		transport = vsk->transport;
+
 		/* The hypervisor and well-known contexts do not have socket
 		 * endpoints.
 		 */
-		if (!transport->stream_allow(remote_addr->svm_cid,
+		if (!transport ||
+		    !transport->stream_allow(remote_addr->svm_cid,
 					     remote_addr->svm_port)) {
 			err = -ENETUNREACH;
 			goto out;
 		}
 
-		/* Set the remote address that we are connecting to. */
-		memcpy(&vsk->remote_addr, remote_addr,
-		       sizeof(vsk->remote_addr));
-
 		err = vsock_auto_bind(vsk);
 		if (err)
 			goto out;
@@ -1572,7 +1630,7 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
-	if (sk->sk_state != TCP_ESTABLISHED ||
+	if (!transport || sk->sk_state != TCP_ESTABLISHED ||
 	    !vsock_addr_bound(&vsk->local_addr)) {
 		err = -ENOTCONN;
 		goto out;
@@ -1698,7 +1756,7 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	lock_sock(sk);
 
-	if (sk->sk_state != TCP_ESTABLISHED) {
+	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
 		/* Recvmsg is supposed to return 0 if a peer performs an
 		 * orderly shutdown. Differentiate between that case and when a
 		 * peer has not connected or a local shutdown occured with the
@@ -1872,7 +1930,9 @@ static const struct proto_ops vsock_stream_ops = {
 static int vsock_create(struct net *net, struct socket *sock,
 			int protocol, int kern)
 {
+	struct vsock_sock *vsk;
 	struct sock *sk;
+	int ret;
 
 	if (!sock)
 		return -EINVAL;
@@ -1897,7 +1957,20 @@ static int vsock_create(struct net *net, struct socket *sock,
 	if (!sk)
 		return -ENOMEM;
 
-	vsock_insert_unbound(vsock_sk(sk));
+	vsk = vsock_sk(sk);
+
+	/* RFC-TODO: for dgram we still support only one transport, and
+	 * we assign it during the sock creation.
+	 */
+	if (sock->type == SOCK_DGRAM) {
+		ret = vsock_assign_transport(vsk, NULL);
+		if (ret < 0) {
+			sock_put(sk);
+			return ret;
+		}
+	}
+
+	vsock_insert_unbound(vsk);
 
 	return 0;
 }
@@ -1912,11 +1985,20 @@ static long vsock_dev_do_ioctl(struct file *filp,
 			       unsigned int cmd, void __user *ptr)
 {
 	u32 __user *p = ptr;
+	u32 cid = VMADDR_CID_ANY;
 	int retval = 0;
 
 	switch (cmd) {
 	case IOCTL_VM_SOCKETS_GET_LOCAL_CID:
-		if (put_user(transport_single->get_local_cid(), p) != 0)
+		/* To be compatible with the VMCI behavior, we prioritize the
+		 * guest CID instead of well-know host CID (VMADDR_CID_HOST).
+		 */
+		if (transport_g2h)
+			cid = transport_g2h->get_local_cid();
+		else if (transport_h2g)
+			cid = transport_h2g->get_local_cid();
+
+		if (put_user(cid, p) != 0)
 			retval = -EFAULT;
 		break;
 
@@ -1956,24 +2038,13 @@ static struct miscdevice vsock_device = {
 	.fops		= &vsock_device_ops,
 };
 
-int __vsock_core_init(const struct vsock_transport *t, struct module *owner)
+static int __init vsock_init(void)
 {
-	int err = mutex_lock_interruptible(&vsock_register_mutex);
+	int err = 0;
 
-	if (err)
-		return err;
-
-	if (transport_single) {
-		err = -EBUSY;
-		goto err_busy;
-	}
-
-	/* Transport must be the owner of the protocol so that it can't
-	 * unload while there are open sockets.
-	 */
-	vsock_proto.owner = owner;
-	transport_single = t;
+	vsock_init_tables();
 
+	vsock_proto.owner = THIS_MODULE;
 	vsock_device.minor = MISC_DYNAMIC_MINOR;
 	err = misc_register(&vsock_device);
 	if (err) {
@@ -1994,7 +2065,6 @@ int __vsock_core_init(const struct vsock_transport *t, struct module *owner)
 		goto err_unregister_proto;
 	}
 
-	mutex_unlock(&vsock_register_mutex);
 	return 0;
 
 err_unregister_proto:
@@ -2002,28 +2072,15 @@ int __vsock_core_init(const struct vsock_transport *t, struct module *owner)
 err_deregister_misc:
 	misc_deregister(&vsock_device);
 err_reset_transport:
-	transport_single = NULL;
-err_busy:
-	mutex_unlock(&vsock_register_mutex);
 	return err;
 }
-EXPORT_SYMBOL_GPL(__vsock_core_init);
 
-void vsock_core_exit(void)
+static void __exit vsock_exit(void)
 {
-	mutex_lock(&vsock_register_mutex);
-
 	misc_deregister(&vsock_device);
 	sock_unregister(AF_VSOCK);
 	proto_unregister(&vsock_proto);
-
-	/* We do not want the assignment below re-ordered. */
-	mb();
-	transport_single = NULL;
-
-	mutex_unlock(&vsock_register_mutex);
 }
-EXPORT_SYMBOL_GPL(vsock_core_exit);
 
 const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk)
 {
@@ -2034,12 +2091,77 @@ const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_core_get_transport);
 
-static void __exit vsock_exit(void)
+int vsock_core_register(const struct vsock_transport *t)
 {
-	/* Do nothing.  This function makes this module removable. */
+	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
+	int err = mutex_lock_interruptible(&vsock_register_mutex);
+
+	if (err)
+		return err;
+
+	t_h2g = transport_h2g;
+	t_g2h = transport_g2h;
+	t_dgram = transport_dgram;
+
+	/* RFC-TODO: vmci transport offer both H2G and G2H features in the
+	 * same transport. We are able to set the G2H feature only if we are
+	 * in a VMware guest, but we are not able to do the same for the host.
+	 */
+	if (t->features & VSOCK_TRANSPORT_F_H2G) {
+		if (t_h2g) {
+			err = -EBUSY;
+			goto err_busy;
+		}
+		t_h2g = t;
+	}
+
+	if (t->features & VSOCK_TRANSPORT_F_G2H) {
+		if (t_g2h) {
+			err = -EBUSY;
+			goto err_busy;
+		}
+		t_g2h = t;
+	}
+
+	if (t->features & VSOCK_TRANSPORT_F_DGRAM) {
+		if (t_dgram) {
+			err = -EBUSY;
+			goto err_busy;
+		}
+		t_dgram = t;
+	}
+
+	transport_h2g = t_h2g;
+	transport_g2h = t_g2h;
+	transport_dgram = t_dgram;
+
+err_busy:
+	mutex_unlock(&vsock_register_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vsock_core_register);
+
+void vsock_core_unregister(const struct vsock_transport *t)
+{
+	mutex_lock(&vsock_register_mutex);
+
+	/* RFC-TODO: maybe we should check if there are open sockets
+	 * assigned to that transport and avoid the unregistration
+	 */
+	if (transport_h2g == t)
+		transport_h2g = NULL;
+
+	if (transport_g2h == t)
+		transport_g2h = NULL;
+
+	if (transport_dgram == t)
+		transport_dgram = NULL;
+
+	mutex_unlock(&vsock_register_mutex);
 }
+EXPORT_SYMBOL_GPL(vsock_core_unregister);
 
-module_init(vsock_init_tables);
+module_init(vsock_init);
 module_exit(vsock_exit);
 
 MODULE_AUTHOR("VMware, Inc.");
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 306310794522..94e6fc905a77 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -163,6 +163,8 @@ static const guid_t srv_id_template =
 	GUID_INIT(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
 		  0x64, 0x00, 0x6a, 0x79, 0x86, 0xd3);
 
+static bool hvs_check_transport(struct vsock_sock *vsk);
+
 static bool is_valid_srv_id(const guid_t *id)
 {
 	return !memcmp(&id->b[4], &srv_id_template.b[4], sizeof(guid_t) - 4);
@@ -366,6 +368,18 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 
 		new->sk_state = TCP_SYN_SENT;
 		vnew = vsock_sk(new);
+
+		hvs_addr_init(&vnew->local_addr, if_type);
+		hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
+
+		ret = vsock_assign_transport(vnew, vsock_sk(sk));
+		/* Transport assigned (looking at remote_addr) must be the
+		 * same where we received the request.
+		 */
+		if (ret || !hvs_check_transport(vnew)) {
+			sock_put(new);
+			goto out;
+		}
 		hvs_new = vnew->trans;
 		hvs_new->chan = chan;
 	} else {
@@ -429,9 +443,6 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		new->sk_state = TCP_ESTABLISHED;
 		sk->sk_ack_backlog++;
 
-		hvs_addr_init(&vnew->local_addr, if_type);
-		hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
-
 		hvs_new->vm_srv_id = *if_type;
 		hvs_new->host_srv_id = *if_instance;
 
@@ -845,6 +856,8 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
 }
 
 static struct vsock_transport hvs_transport = {
+	.features                 = VSOCK_TRANSPORT_F_G2H,
+
 	.get_local_cid            = hvs_get_local_cid,
 
 	.init                     = hvs_sock_init,
@@ -879,6 +892,11 @@ static struct vsock_transport hvs_transport = {
 
 };
 
+static bool hvs_check_transport(struct vsock_sock *vsk)
+{
+	return vsk->transport == &hvs_transport;
+}
+
 static int hvs_probe(struct hv_device *hdev,
 		     const struct hv_vmbus_device_id *dev_id)
 {
@@ -927,7 +945,7 @@ static int __init hvs_init(void)
 	if (ret != 0)
 		return ret;
 
-	ret = vsock_core_init(&hvs_transport);
+	ret = vsock_core_register(&hvs_transport);
 	if (ret) {
 		vmbus_driver_unregister(&hvs_drv);
 		return ret;
@@ -938,7 +956,7 @@ static int __init hvs_init(void)
 
 static void __exit hvs_exit(void)
 {
-	vsock_core_exit();
+	vsock_core_unregister(&hvs_transport);
 	vmbus_driver_unregister(&hvs_drv);
 }
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index fb1fc7760e8c..0ff037ef7f8e 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -462,6 +462,8 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 
 static struct virtio_transport virtio_transport = {
 	.transport = {
+		.features                 = VSOCK_TRANSPORT_F_G2H,
+
 		.get_local_cid            = virtio_transport_get_local_cid,
 
 		.init                     = virtio_transport_do_socket_init,
@@ -770,7 +772,7 @@ static int __init virtio_vsock_init(void)
 	if (!virtio_vsock_workqueue)
 		return -ENOMEM;
 
-	ret = vsock_core_init(&virtio_transport.transport);
+	ret = vsock_core_register(&virtio_transport.transport);
 	if (ret)
 		goto out_wq;
 
@@ -781,7 +783,7 @@ static int __init virtio_vsock_init(void)
 	return 0;
 
 out_vci:
-	vsock_core_exit();
+	vsock_core_unregister(&virtio_transport.transport);
 out_wq:
 	destroy_workqueue(virtio_vsock_workqueue);
 	return ret;
@@ -790,7 +792,7 @@ static int __init virtio_vsock_init(void)
 static void __exit virtio_vsock_exit(void)
 {
 	unregister_virtio_driver(&virtio_vsock_driver);
-	vsock_core_exit();
+	vsock_core_unregister(&virtio_transport.transport);
 	destroy_workqueue(virtio_vsock_workqueue);
 }
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index bac9e7430a2e..ebb4701310a4 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -400,7 +400,7 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 
 	vsk->trans = vvs;
 	vvs->vsk = vsk;
-	if (psk) {
+	if (psk && psk->trans) {
 		struct virtio_vsock_sock *ptrans = psk->trans;
 
 		vvs->peer_buf_alloc = ptrans->peer_buf_alloc;
@@ -927,11 +927,13 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 
 /* Handle server socket */
 static int
-virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt)
+virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
+			     struct virtio_transport *t)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 	struct vsock_sock *vchild;
 	struct sock *child;
+	int ret;
 
 	if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_REQUEST) {
 		virtio_transport_reset(vsk, pkt);
@@ -962,6 +964,17 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt)
 	vsock_addr_init(&vchild->remote_addr, le64_to_cpu(pkt->hdr.src_cid),
 			le32_to_cpu(pkt->hdr.src_port));
 
+	ret = vsock_assign_transport(vchild, vsk);
+	/* Transport assigned (looking at remote_addr) must be the same
+	 * where we received the request.
+	 */
+	if (ret || vchild->transport != &t->transport) {
+		release_sock(child);
+		virtio_transport_reset(vsk, pkt);
+		sock_put(child);
+		return ret;
+	}
+
 	vsock_insert_connected(vchild);
 	vsock_enqueue_accept(sk, child);
 	virtio_transport_send_response(vchild, pkt);
@@ -979,6 +992,14 @@ static bool virtio_transport_space_update(struct sock *sk,
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	bool space_available;
 
+	/* Listener sockets are not associated with any transport, so we are
+	 * not able to take the state to see if there is space available in the
+	 * remote peer, but since they are only used to receive requests, we
+	 * can assume that there is always space available in the other peer.
+	 */
+	if (!vvs)
+		return true;
+
 	/* buf_alloc and fwd_cnt is always included in the hdr */
 	spin_lock_bh(&vvs->tx_lock);
 	vvs->peer_buf_alloc = le32_to_cpu(pkt->hdr.buf_alloc);
@@ -1044,7 +1065,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	switch (sk->sk_state) {
 	case TCP_LISTEN:
-		virtio_transport_recv_listen(sk, pkt);
+		virtio_transport_recv_listen(sk, pkt, t);
 		virtio_transport_free_pkt(pkt);
 		break;
 	case TCP_SYN_SENT:
@@ -1062,6 +1083,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		virtio_transport_free_pkt(pkt);
 		break;
 	}
+
 	release_sock(sk);
 
 	/* Release refcnt obtained when we fetched this socket out of the
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 8290d37b6587..52e63952d0d4 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -57,6 +57,7 @@ static bool vmci_transport_old_proto_override(bool *old_pkt_proto);
 static u16 vmci_transport_new_proto_supported_versions(void);
 static bool vmci_transport_proto_to_notify_struct(struct sock *sk, u16 *proto,
 						  bool old_pkt_proto);
+static bool vmci_check_transport(struct vsock_sock *vsk);
 
 struct vmci_transport_recv_pkt_info {
 	struct work_struct work;
@@ -1018,6 +1019,15 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	vsock_addr_init(&vpending->remote_addr, pkt->dg.src.context,
 			pkt->src_port);
 
+	err = vsock_assign_transport(vpending, vsock_sk(sk));
+	/* Transport assigned (looking at remote_addr) must be the same
+	 * where we received the request.
+	 */
+	if (err || !vmci_check_transport(vpending)) {
+		sock_put(pending);
+		return err;
+	}
+
 	/* If the proposed size fits within our min/max, accept it. Otherwise
 	 * propose our own size.
 	 */
@@ -2009,7 +2019,8 @@ static u32 vmci_transport_get_local_cid(void)
 	return vmci_get_context_id();
 }
 
-static const struct vsock_transport vmci_transport = {
+static struct vsock_transport vmci_transport = {
+	.features = VSOCK_TRANSPORT_F_DGRAM | VSOCK_TRANSPORT_F_H2G,
 	.init = vmci_transport_socket_init,
 	.destruct = vmci_transport_destruct,
 	.release = vmci_transport_release,
@@ -2039,10 +2050,24 @@ static const struct vsock_transport vmci_transport = {
 	.get_local_cid = vmci_transport_get_local_cid,
 };
 
+static bool vmci_check_transport(struct vsock_sock *vsk)
+{
+	return vsk->transport == &vmci_transport;
+}
+
 static int __init vmci_transport_init(void)
 {
+	int cid;
 	int err;
 
+	cid = vmci_get_context_id();
+
+	if (cid == VMCI_INVALID_ID)
+		return -EINVAL;
+
+	if (cid != VMCI_HOST_CONTEXT_ID)
+		vmci_transport.features |= VSOCK_TRANSPORT_F_G2H;
+
 	/* Create the datagram handle that we will use to send and receive all
 	 * VSocket control messages for this context.
 	 */
@@ -2066,7 +2091,7 @@ static int __init vmci_transport_init(void)
 		goto err_destroy_stream_handle;
 	}
 
-	err = vsock_core_init(&vmci_transport);
+	err = vsock_core_register(&vmci_transport);
 	if (err < 0)
 		goto err_unsubscribe;
 
@@ -2097,7 +2122,7 @@ static void __exit vmci_transport_exit(void)
 		vmci_transport_qp_resumed_sub_id = VMCI_INVALID_ID;
 	}
 
-	vsock_core_exit();
+	vsock_core_unregister(&vmci_transport);
 }
 module_exit(vmci_transport_exit);
 
-- 
2.21.0

