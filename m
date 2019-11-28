Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BCE10CD93
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK1RPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:15:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfK1RPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:15:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574961334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJ8wmKVAVGzwQy9RJeA/HRES3+N97aoUgTm4JmySAyU=;
        b=WoZ35YLmpIA4mLtYJWzHwdpbUazCzX7k9wt8k+F7+0OucWXABbt+wb6PJJuvqHvzQTbvUl
        kHwe3ugfUK7zk/I5Z2Rgs7reiXmOSVHHDp9LLWg08tYEtlkID1LywYMsnhmgHxUu4taSLc
        bmiScLYcPl+Q9QDSrF4uGORWBjSMnhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2--QKnLjt9PjOK2AeJ3ke5Mw-1; Thu, 28 Nov 2019 12:15:32 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B7C3107ACC4;
        Thu, 28 Nov 2019 17:15:31 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CB89600C8;
        Thu, 28 Nov 2019 17:15:28 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 1/3] vsock: add network namespace support
Date:   Thu, 28 Nov 2019 18:15:17 +0100
Message-Id: <20191128171519.203979-2-sgarzare@redhat.com>
In-Reply-To: <20191128171519.203979-1-sgarzare@redhat.com>
References: <20191128171519.203979-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: -QKnLjt9PjOK2AeJ3ke5Mw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a check of the "net" assigned to a socket during
the vsock_find_bound_socket() and vsock_find_connected_socket()
to support network namespace, allowing to share the same address
(cid, port) across different network namespaces.

G2H transports will use the default network namepsace (init_net).
H2G transports can use different network namespace for different
VMs.

This patch uses default network namepsace (init_net) in all
transports.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h                  |  6 +++--
 net/vmw_vsock/af_vsock.c                | 31 ++++++++++++++++++-------
 net/vmw_vsock/hyperv_transport.c        |  5 ++--
 net/vmw_vsock/virtio_transport_common.c |  5 ++--
 net/vmw_vsock/vmci_transport.c          |  5 ++--
 5 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b1c717286993..fb7dcf73af5b 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -193,13 +193,15 @@ void vsock_enqueue_accept(struct sock *listener, stru=
ct sock *connected);
 void vsock_insert_connected(struct vsock_sock *vsk);
 void vsock_remove_bound(struct vsock_sock *vsk);
 void vsock_remove_connected(struct vsock_sock *vsk);
-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net =
*net);
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
-=09=09=09=09=09 struct sockaddr_vm *dst);
+=09=09=09=09=09 struct sockaddr_vm *dst,
+=09=09=09=09=09 struct net *net);
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)=
;
 bool vsock_find_cid(unsigned int cid);
+struct net *vsock_default_net(void);
=20
 /**** TAP ****/
=20
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9c5b2a91baad..b485b4a4e3e9 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -226,15 +226,18 @@ static void __vsock_remove_connected(struct vsock_soc=
k *vsk)
 =09sock_put(&vsk->sk);
 }
=20
-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr,
+=09=09=09=09=09      struct net *net)
 {
 =09struct vsock_sock *vsk;
=20
 =09list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
-=09=09if (vsock_addr_equals_addr(addr, &vsk->local_addr))
+=09=09if (vsock_addr_equals_addr(addr, &vsk->local_addr) &&
+=09=09    net_eq(net, sock_net(sk_vsock(vsk))))
 =09=09=09return sk_vsock(vsk);
=20
 =09=09if (addr->svm_port =3D=3D vsk->local_addr.svm_port &&
+=09=09    net_eq(net, sock_net(sk_vsock(vsk))) &&
 =09=09    (vsk->local_addr.svm_cid =3D=3D VMADDR_CID_ANY ||
 =09=09     addr->svm_cid =3D=3D VMADDR_CID_ANY))
 =09=09=09return sk_vsock(vsk);
@@ -244,13 +247,15 @@ static struct sock *__vsock_find_bound_socket(struct =
sockaddr_vm *addr)
 }
=20
 static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
-=09=09=09=09=09=09  struct sockaddr_vm *dst)
+=09=09=09=09=09=09  struct sockaddr_vm *dst,
+=09=09=09=09=09=09  struct net *net)
 {
 =09struct vsock_sock *vsk;
=20
 =09list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
 =09=09=09    connected_table) {
 =09=09if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
+=09=09    net_eq(net, sock_net(sk_vsock(vsk))) &&
 =09=09    dst->svm_port =3D=3D vsk->local_addr.svm_port) {
 =09=09=09return sk_vsock(vsk);
 =09=09}
@@ -295,12 +300,12 @@ void vsock_remove_connected(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_remove_connected);
=20
-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net =
*net)
 {
 =09struct sock *sk;
=20
 =09spin_lock_bh(&vsock_table_lock);
-=09sk =3D __vsock_find_bound_socket(addr);
+=09sk =3D __vsock_find_bound_socket(addr, net);
 =09if (sk)
 =09=09sock_hold(sk);
=20
@@ -311,12 +316,13 @@ struct sock *vsock_find_bound_socket(struct sockaddr_=
vm *addr)
 EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
=20
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
-=09=09=09=09=09 struct sockaddr_vm *dst)
+=09=09=09=09=09 struct sockaddr_vm *dst,
+=09=09=09=09=09 struct net *net)
 {
 =09struct sock *sk;
=20
 =09spin_lock_bh(&vsock_table_lock);
-=09sk =3D __vsock_find_connected_socket(src, dst);
+=09sk =3D __vsock_find_connected_socket(src, dst, net);
 =09if (sk)
 =09=09sock_hold(sk);
=20
@@ -488,6 +494,12 @@ bool vsock_find_cid(unsigned int cid)
 }
 EXPORT_SYMBOL_GPL(vsock_find_cid);
=20
+struct net *vsock_default_net(void)
+{
+=09return &init_net;
+}
+EXPORT_SYMBOL_GPL(vsock_default_net);
+
 static struct sock *vsock_dequeue_accept(struct sock *listener)
 {
 =09struct vsock_sock *vlistener;
@@ -586,6 +598,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk,
 {
 =09static u32 port;
 =09struct sockaddr_vm new_addr;
+=09struct net *net =3D sock_net(sk_vsock(vsk));
=20
 =09if (!port)
 =09=09port =3D LAST_RESERVED_PORT + 1 +
@@ -603,7 +616,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk,
=20
 =09=09=09new_addr.svm_port =3D port++;
=20
-=09=09=09if (!__vsock_find_bound_socket(&new_addr)) {
+=09=09=09if (!__vsock_find_bound_socket(&new_addr, net)) {
 =09=09=09=09found =3D true;
 =09=09=09=09break;
 =09=09=09}
@@ -620,7 +633,7 @@ static int __vsock_bind_stream(struct vsock_sock *vsk,
 =09=09=09return -EACCES;
 =09=09}
=20
-=09=09if (__vsock_find_bound_socket(&new_addr))
+=09=09if (__vsock_find_bound_socket(&new_addr, net))
 =09=09=09return -EADDRINUSE;
 =09}
=20
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 3c7d07a99fc5..fc48a861a0bc 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -201,7 +201,8 @@ static void hvs_remote_addr_init(struct sockaddr_vm *re=
mote,
=20
 =09=09remote->svm_port =3D host_ephemeral_port++;
=20
-=09=09sk =3D vsock_find_connected_socket(remote, local);
+=09=09sk =3D vsock_find_connected_socket(remote, local,
+=09=09=09=09=09=09 vsock_default_net());
 =09=09if (!sk) {
 =09=09=09/* Found an available ephemeral port */
 =09=09=09return;
@@ -350,7 +351,7 @@ static void hvs_open_connection(struct vmbus_channel *c=
han)
 =09=09return;
=20
 =09hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
-=09sk =3D vsock_find_bound_socket(&addr);
+=09sk =3D vsock_find_bound_socket(&addr, vsock_default_net());
 =09if (!sk)
 =09=09return;
=20
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio=
_transport_common.c
index 0e20b0f6eb65..10a8cbe39f61 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1075,6 +1075,7 @@ virtio_transport_recv_listen(struct sock *sk, struct =
virtio_vsock_pkt *pkt,
 void virtio_transport_recv_pkt(struct virtio_transport *t,
 =09=09=09       struct virtio_vsock_pkt *pkt)
 {
+=09struct net *net =3D vsock_default_net();
 =09struct sockaddr_vm src, dst;
 =09struct vsock_sock *vsk;
 =09struct sock *sk;
@@ -1102,9 +1103,9 @@ void virtio_transport_recv_pkt(struct virtio_transpor=
t *t,
 =09/* The socket must be in connected or bound table
 =09 * otherwise send reset back
 =09 */
-=09sk =3D vsock_find_connected_socket(&src, &dst);
+=09sk =3D vsock_find_connected_socket(&src, &dst, net);
 =09if (!sk) {
-=09=09sk =3D vsock_find_bound_socket(&dst);
+=09=09sk =3D vsock_find_bound_socket(&dst, net);
 =09=09if (!sk) {
 =09=09=09(void)virtio_transport_reset_no_sock(t, pkt);
 =09=09=09goto free_pkt;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 4b8b1150a738..3ad15d51b30b 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -669,6 +669,7 @@ static bool vmci_transport_stream_allow(u32 cid, u32 po=
rt)
=20
 static int vmci_transport_recv_stream_cb(void *data, struct vmci_datagram =
*dg)
 {
+=09struct net *net =3D vsock_default_net();
 =09struct sock *sk;
 =09struct sockaddr_vm dst;
 =09struct sockaddr_vm src;
@@ -702,9 +703,9 @@ static int vmci_transport_recv_stream_cb(void *data, st=
ruct vmci_datagram *dg)
 =09vsock_addr_init(&src, pkt->dg.src.context, pkt->src_port);
 =09vsock_addr_init(&dst, pkt->dg.dst.context, pkt->dst_port);
=20
-=09sk =3D vsock_find_connected_socket(&src, &dst);
+=09sk =3D vsock_find_connected_socket(&src, &dst, net);
 =09if (!sk) {
-=09=09sk =3D vsock_find_bound_socket(&dst);
+=09=09sk =3D vsock_find_bound_socket(&dst, net);
 =09=09if (!sk) {
 =09=09=09/* We could not find a socket for this specified
 =09=09=09 * address.  If this packet is a RST, we just drop it.
--=20
2.23.0

