Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402BD13F231
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391885AbgAPSdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:33:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391575AbgAPRYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579195488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+VGSKYYAvkNoF8+cprFtOeKETpEfAOiLdOWkQthdSJs=;
        b=MPa5EpIFiKBNMhzGSOiCBcHx2AWuH0CcnIXp0q9/uccj3wffJacmneGYv/hQ8B0cA2mPA5
        pGAwUgZpR64Nnt82YvTUjDPcJJqWwa6gzxAr+rr3LO/CZVDm+jfc4pY2o426CYdnFVdl8S
        n9pp3GVzTZdWN8rRP+fZRj5hM0QVuC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-UUN55USqMMi3d6FObijG9Q-1; Thu, 16 Jan 2020 12:24:47 -0500
X-MC-Unique: UUN55USqMMi3d6FObijG9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0951A8010C7;
        Thu, 16 Jan 2020 17:24:45 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-242.ams2.redhat.com [10.36.117.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88F2F5C1D8;
        Thu, 16 Jan 2020 17:24:42 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 1/3] vsock: add network namespace support
Date:   Thu, 16 Jan 2020 18:24:26 +0100
Message-Id: <20200116172428.311437-2-sgarzare@redhat.com>
In-Reply-To: <20200116172428.311437-1-sgarzare@redhat.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a check of the "net" assigned to a socket during
the vsock_find_bound_socket() and vsock_find_connected_socket()
to support network namespace, allowing to share the same address
(cid, port) across different network namespaces.

This patch adds 'netns' module param to enable this new feature
(disabled by default), because it changes vsock's behavior with
network namespaces and could break existing applications.

G2H transports will use the default network namepsace (init_net).
H2G transports can use different network namespace for different
VMs.

This patch uses default network namepsace (init_net) in all
transports.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
RFC -> v1
 * added 'netns' module param
 * added 'vsock_net_eq()' to check the "net" assigned to a socket
   only when 'netns' support is enabled
---
 include/net/af_vsock.h                  |  7 +++--
 net/vmw_vsock/af_vsock.c                | 41 +++++++++++++++++++------
 net/vmw_vsock/hyperv_transport.c        |  5 +--
 net/vmw_vsock/virtio_transport_common.c |  5 +--
 net/vmw_vsock/vmci_transport.c          |  5 +--
 5 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b1c717286993..015913601fad 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -193,13 +193,16 @@ void vsock_enqueue_accept(struct sock *listener, st=
ruct sock *connected);
 void vsock_insert_connected(struct vsock_sock *vsk);
 void vsock_remove_bound(struct vsock_sock *vsk);
 void vsock_remove_connected(struct vsock_sock *vsk);
-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct ne=
t *net);
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
-					 struct sockaddr_vm *dst);
+					 struct sockaddr_vm *dst,
+					 struct net *net);
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *ps=
k);
 bool vsock_find_cid(unsigned int cid);
+bool vsock_net_eq(const struct net *net1, const struct net *net2);
+struct net *vsock_default_net(void);
=20
 /**** TAP ****/
=20
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9c5b2a91baad..457ccd677756 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -140,6 +140,10 @@ static const struct vsock_transport *transport_dgram=
;
 static const struct vsock_transport *transport_local;
 static DEFINE_MUTEX(vsock_register_mutex);
=20
+static bool netns;
+module_param(netns, bool, 0644);
+MODULE_PARM_DESC(netns, "Enable network namespace support");
+
 /**** UTILS ****/
=20
 /* Each bound VSocket is stored in the bind hash table and each connecte=
d
@@ -226,15 +230,18 @@ static void __vsock_remove_connected(struct vsock_s=
ock *vsk)
 	sock_put(&vsk->sk);
 }
=20
-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr,
+					      struct net *net)
 {
 	struct vsock_sock *vsk;
=20
 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
-		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
+		if (vsock_addr_equals_addr(addr, &vsk->local_addr) &&
+		    vsock_net_eq(net, sock_net(sk_vsock(vsk))))
 			return sk_vsock(vsk);
=20
 		if (addr->svm_port =3D=3D vsk->local_addr.svm_port &&
+		    vsock_net_eq(net, sock_net(sk_vsock(vsk))) &&
 		    (vsk->local_addr.svm_cid =3D=3D VMADDR_CID_ANY ||
 		     addr->svm_cid =3D=3D VMADDR_CID_ANY))
 			return sk_vsock(vsk);
@@ -244,13 +251,15 @@ static struct sock *__vsock_find_bound_socket(struc=
t sockaddr_vm *addr)
 }
=20
 static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *sr=
c,
-						  struct sockaddr_vm *dst)
+						  struct sockaddr_vm *dst,
+						  struct net *net)
 {
 	struct vsock_sock *vsk;
=20
 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
 			    connected_table) {
 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
+		    vsock_net_eq(net, sock_net(sk_vsock(vsk))) &&
 		    dst->svm_port =3D=3D vsk->local_addr.svm_port) {
 			return sk_vsock(vsk);
 		}
@@ -295,12 +304,12 @@ void vsock_remove_connected(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_remove_connected);
=20
-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct ne=
t *net)
 {
 	struct sock *sk;
=20
 	spin_lock_bh(&vsock_table_lock);
-	sk =3D __vsock_find_bound_socket(addr);
+	sk =3D __vsock_find_bound_socket(addr, net);
 	if (sk)
 		sock_hold(sk);
=20
@@ -311,12 +320,13 @@ struct sock *vsock_find_bound_socket(struct sockadd=
r_vm *addr)
 EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
=20
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
-					 struct sockaddr_vm *dst)
+					 struct sockaddr_vm *dst,
+					 struct net *net)
 {
 	struct sock *sk;
=20
 	spin_lock_bh(&vsock_table_lock);
-	sk =3D __vsock_find_connected_socket(src, dst);
+	sk =3D __vsock_find_connected_socket(src, dst, net);
 	if (sk)
 		sock_hold(sk);
=20
@@ -488,6 +498,18 @@ bool vsock_find_cid(unsigned int cid)
 }
 EXPORT_SYMBOL_GPL(vsock_find_cid);
=20
+bool vsock_net_eq(const struct net *net1, const struct net *net2)
+{
+	return !netns || net_eq(net1, net2);
+}
+EXPORT_SYMBOL_GPL(vsock_net_eq);
+
+struct net *vsock_default_net(void)
+{
+	return &init_net;
+}
+EXPORT_SYMBOL_GPL(vsock_default_net);
+
 static struct sock *vsock_dequeue_accept(struct sock *listener)
 {
 	struct vsock_sock *vlistener;
@@ -586,6 +608,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk=
,
 {
 	static u32 port;
 	struct sockaddr_vm new_addr;
+	struct net *net =3D sock_net(sk_vsock(vsk));
=20
 	if (!port)
 		port =3D LAST_RESERVED_PORT + 1 +
@@ -603,7 +626,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk=
,
=20
 			new_addr.svm_port =3D port++;
=20
-			if (!__vsock_find_bound_socket(&new_addr)) {
+			if (!__vsock_find_bound_socket(&new_addr, net)) {
 				found =3D true;
 				break;
 			}
@@ -620,7 +643,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk=
,
 			return -EACCES;
 		}
=20
-		if (__vsock_find_bound_socket(&new_addr))
+		if (__vsock_find_bound_socket(&new_addr, net))
 			return -EADDRINUSE;
 	}
=20
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
index b3bdae74c243..237c53316d70 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -201,7 +201,8 @@ static void hvs_remote_addr_init(struct sockaddr_vm *=
remote,
=20
 		remote->svm_port =3D host_ephemeral_port++;
=20
-		sk =3D vsock_find_connected_socket(remote, local);
+		sk =3D vsock_find_connected_socket(remote, local,
+						 vsock_default_net());
 		if (!sk) {
 			/* Found an available ephemeral port */
 			return;
@@ -350,7 +351,7 @@ static void hvs_open_connection(struct vmbus_channel =
*chan)
 		return;
=20
 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
-	sk =3D vsock_find_bound_socket(&addr);
+	sk =3D vsock_find_bound_socket(&addr, vsock_default_net());
 	if (!sk)
 		return;
=20
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virt=
io_transport_common.c
index d9f0c9c5425a..cecdfd91ed00 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1088,6 +1088,7 @@ virtio_transport_recv_listen(struct sock *sk, struc=
t virtio_vsock_pkt *pkt,
 void virtio_transport_recv_pkt(struct virtio_transport *t,
 			       struct virtio_vsock_pkt *pkt)
 {
+	struct net *net =3D vsock_default_net();
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
 	struct sock *sk;
@@ -1115,9 +1116,9 @@ void virtio_transport_recv_pkt(struct virtio_transp=
ort *t,
 	/* The socket must be in connected or bound table
 	 * otherwise send reset back
 	 */
-	sk =3D vsock_find_connected_socket(&src, &dst);
+	sk =3D vsock_find_connected_socket(&src, &dst, net);
 	if (!sk) {
-		sk =3D vsock_find_bound_socket(&dst);
+		sk =3D vsock_find_bound_socket(&dst, net);
 		if (!sk) {
 			(void)virtio_transport_reset_no_sock(t, pkt);
 			goto free_pkt;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transpor=
t.c
index 4b8b1150a738..3ad15d51b30b 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -669,6 +669,7 @@ static bool vmci_transport_stream_allow(u32 cid, u32 =
port)
=20
 static int vmci_transport_recv_stream_cb(void *data, struct vmci_datagra=
m *dg)
 {
+	struct net *net =3D vsock_default_net();
 	struct sock *sk;
 	struct sockaddr_vm dst;
 	struct sockaddr_vm src;
@@ -702,9 +703,9 @@ static int vmci_transport_recv_stream_cb(void *data, =
struct vmci_datagram *dg)
 	vsock_addr_init(&src, pkt->dg.src.context, pkt->src_port);
 	vsock_addr_init(&dst, pkt->dg.dst.context, pkt->dst_port);
=20
-	sk =3D vsock_find_connected_socket(&src, &dst);
+	sk =3D vsock_find_connected_socket(&src, &dst, net);
 	if (!sk) {
-		sk =3D vsock_find_bound_socket(&dst);
+		sk =3D vsock_find_bound_socket(&dst, net);
 		if (!sk) {
 			/* We could not find a socket for this specified
 			 * address.  If this packet is a RST, we just drop it.
--=20
2.24.1

