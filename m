Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725286E18F7
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjDNA0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjDNA0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:26:21 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FCF44B2
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:26:04 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id w38so2901156qtc.11
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681431963; x=1684023963;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sgwRQCJ2TTylvD4k3At5szMGiHj6LYOV8Jadz8EYMjI=;
        b=Lyy/CkBv8ixpuNAsuvH1525ayIkK2tiUf88sF4M2VJadIOx/FCQy1mrjRyhtSC7//6
         ujcqMScf299r+8AyfEwAFda40Ve0gZzYHGT55BM1ODDc4j3AvydFa3TrQc4NVixQE07R
         JlrQQGWBNGPn8ftbi4pRikBieb9i+6X4QWMjW/tFtLAgTv0Fti+W6grHvsbJw44M6aQm
         qsNyIVVjp7W0/IlHVudegpbWXFvkVRNRnzK03wNM/RIw5r+ESHQ+FaQy8e1Q/yLU/inv
         RuaaS3WkUtSV9WTpzJJ3/2gFDue6k4fS+/Ys1fhyZfLfdcsJido4tZFN4P4j6ZfOu/DA
         +lvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681431963; x=1684023963;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgwRQCJ2TTylvD4k3At5szMGiHj6LYOV8Jadz8EYMjI=;
        b=hFoMWXeYr4n58eQeU10gbdrj9qALsCv9Wme9u8YyzYv7taujfOsH7SP48f/8rveKnG
         D5fTiwmhM67ygUEjPbWJqW0fHvR9FMt4VriWuCocydxhKpB4f+ziWAekiMiCc//WqD7n
         b9FjnRxpp2ZIW9p4EKO+34/FxSf6BUvRl1QcpVSloxU/jgd8AC0jGKGdxDMykim5U/Cz
         +QulhccunaA4yYVCQHbs64KhxfWAQUGdwASovmUx7QliFBTnsKlPBRtOKSLY+0LG3Hyv
         5ZCwowJfqxOYGdm/arHMpDswmHEtT4Z0OS3Ny9NmsL8gu8eHT+JZXkkBPNdDxSt9KxFC
         nz0g==
X-Gm-Message-State: AAQBX9d3j4Prma/wD92RZT5egSyt7QqsDyXEt/i5L85QdaHXU8Ru3R5/
        nFWVqdvRftol3Jk0HucU8BrFdg==
X-Google-Smtp-Source: AKy350YzsXHSD9ig6Vua9v+3cKJqv8wt5LQVPUfMKtGSUNwXCmYUWhDAosoBrAbi19i/4o9kU+Vglw==
X-Received: by 2002:a05:622a:587:b0:3ea:7fa6:d56b with SMTP id c7-20020a05622a058700b003ea7fa6d56bmr3679359qtb.21.1681431963299;
        Thu, 13 Apr 2023 17:26:03 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.122])
        by smtp.gmail.com with ESMTPSA id a1-20020ac844a1000000b003eabcc29132sm309928qto.29.2023.04.13.17.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 17:26:02 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Fri, 14 Apr 2023 00:25:59 +0000
Subject: [PATCH RFC net-next v2 3/4] vsock: Add lockless sendmsg() support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v2-3-079cc7cee62e@bytedance.com>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because the dgram sendmsg() path for AF_VSOCK acquires the socket lock
it does not scale when many senders share a socket.

Prior to this patch the socket lock is used to protect the local_addr,
remote_addr, transport, and buffer size variables. What follows are the
new protection schemes for the various protected fields that ensure a
race-free multi-sender sendmsg() path for vsock dgrams.

- local_addr
    local_addr changes as a result of binding a socket. The write path
    for local_addr is bind() and various vsock_auto_bind() call sites.
    After a socket has been bound via vsock_auto_bind() or bind(), subsequent
    calls to bind()/vsock_auto_bind() do not write to local_addr again. bind()
    rejects the user request and vsock_auto_bind() early exits.
    Therefore, the local addr can not change while a parallel thread is
    in sendmsg() and lock-free reads of local addr in sendmsg() are safe.
    Change: only acquire lock for auto-binding as-needed in sendmsg().

- vsk->transport
    Updated upon socket creation and it doesn't change again until the
    socket is destroyed, which only happens after the socket refcnt reaches
    zero. This prevents any sendmsg() call from being entered because the
    sockfd lookup fails beforehand. That is, sendmsg() and vsk->transport
    writes cannot execute in parallel. Additionally, connect() doesn't
    update vsk->transport for dgrams as it does for streams. Therefore
    vsk->transport is also safe to access lock-free in the sendmsg() path.
    No change.

- buffer size variables
    Not used by dgram, so they do not need protection. No change.

- remote_addr
    Needs additional protection because before this patch the
    remote_addr (consisting of several fields such as cid, port, and flags)
    only changed atomically under socket lock context. By acquiring the
    socket lock to read the structure, the changes made by connect() were
    always made visible to sendmsg() atomically. Consequently, to retain
    atomicity of updates but offer lock-free access, this patch
    redesigns this field as an RCU-protected pointer.

    Writers are still synchronized using the socket lock, but readers
    only read inside RCU read-side critical sections.

Helpers are introduced for accessing and updating the new pointer.

The remote_addr structure is wrapped together with an rcu_head into a
sockaddr_vm_rcu structure so that kfree_rcu() can be used. This removes
the need of writers to use synchronize_rcu() after freeing old structures
which is simply more efficient and reduces code churn where remote_addr
is already being updated inside read-side sections.

Only virtio has been tested, but updates were necessary to the VMCI and
hyperv code. Unfortunately the author does not have access to
VMCI/hyperv systems so those changes are untested.

Perf Tests
vCPUS: 16
Threads: 16
Payload: 4KB
Test Runs: 5
Type: SOCK_DGRAM

Before: 245.2 MB/s
After: 509.2 MB/s (+107%)

Notably, on the same test system, vsock dgram even outperforms
multi-threaded UDP over virtio-net with vhost and MQ support enabled.

Throughput metrics for single-threaded SOCK_DGRAM and
single/multi-threaded SOCK_STREAM showed no statistically signficant
throughput changes (lowest p-value reaching 0.27), with the range of the
mean difference ranging between -5% to +1%.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |  12 +-
 include/net/af_vsock.h                  |  19 ++-
 net/vmw_vsock/af_vsock.c                | 261 ++++++++++++++++++++++++++++----
 net/vmw_vsock/diag.c                    |  10 +-
 net/vmw_vsock/hyperv_transport.c        |  15 +-
 net/vmw_vsock/virtio_transport_common.c |  22 ++-
 net/vmw_vsock/vmci_transport.c          |  70 ++++++---
 7 files changed, 344 insertions(+), 65 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 028cf079225e..da105cb856ac 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -296,13 +296,17 @@ static int
 vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct vhost_vsock *vsock;
+	unsigned int cid;
 	int cnt = 0;
 	int ret = -ENODEV;
 
 	rcu_read_lock();
+	ret = vsock_remote_addr_cid(vsk, &cid);
+	if (ret < 0)
+		goto out;
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid);
+	vsock = vhost_vsock_get(cid);
 	if (!vsock)
 		goto out;
 
@@ -686,6 +690,10 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
 static void vhost_vsock_reset_orphans(struct sock *sk)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	unsigned int cid;
+
+	if (vsock_remote_addr_cid(vsk, &cid) < 0)
+		return;
 
 	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
 	 * under vsock_table_lock so the sock cannot disappear while we're
@@ -693,7 +701,7 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 */
 
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(cid))
 		return;
 
 	/* If the close timeout is pending, let it expire.  This avoids races
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 57af28fede19..c02fd6ad0047 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -25,12 +25,17 @@ extern spinlock_t vsock_table_lock;
 #define vsock_sk(__sk)    ((struct vsock_sock *)__sk)
 #define sk_vsock(__vsk)   (&(__vsk)->sk)
 
+struct sockaddr_vm_rcu {
+	struct sockaddr_vm addr;
+	struct rcu_head rcu;
+};
+
 struct vsock_sock {
 	/* sk must be the first member. */
 	struct sock sk;
 	const struct vsock_transport *transport;
 	struct sockaddr_vm local_addr;
-	struct sockaddr_vm remote_addr;
+	struct sockaddr_vm_rcu * __rcu remote_addr;
 	/* Links for the global tables of bound and connected sockets. */
 	struct list_head bound_table;
 	struct list_head connected_table;
@@ -206,7 +211,7 @@ void vsock_release_pending(struct sock *pending);
 void vsock_add_pending(struct sock *listener, struct sock *pending);
 void vsock_remove_pending(struct sock *listener, struct sock *pending);
 void vsock_enqueue_accept(struct sock *listener, struct sock *connected);
-void vsock_insert_connected(struct vsock_sock *vsk);
+int vsock_insert_connected(struct vsock_sock *vsk);
 void vsock_remove_bound(struct vsock_sock *vsk);
 void vsock_remove_connected(struct vsock_sock *vsk);
 struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
@@ -244,4 +249,14 @@ static inline void __init vsock_bpf_build_proto(void)
 {}
 #endif
 
+/* RCU-protected remote addr helpers */
+int vsock_remote_addr_cid(struct vsock_sock *vsk, unsigned int *cid);
+int vsock_remote_addr_port(struct vsock_sock *vsk, unsigned int *port);
+int vsock_remote_addr_cid_port(struct vsock_sock *vsk, unsigned int *cid,
+			       unsigned int *port);
+int vsock_remote_addr_copy(struct vsock_sock *vsk, struct sockaddr_vm *dest);
+bool vsock_remote_addr_bound(struct vsock_sock *vsk);
+bool vsock_remote_addr_equals(struct vsock_sock *vsk, struct sockaddr_vm *other);
+int vsock_remote_addr_update_cid_port(struct vsock_sock *vsk, u32 cid, u32 port);
+
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 46b3f35e3adc..93b4abbf20b4 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -145,6 +145,139 @@ static const struct vsock_transport *transport_local;
 static DEFINE_MUTEX(vsock_register_mutex);
 
 /**** UTILS ****/
+bool vsock_remote_addr_bound(struct vsock_sock *vsk)
+{
+	struct sockaddr_vm_rcu *remote_addr;
+	bool ret;
+
+	rcu_read_lock();
+	remote_addr = rcu_dereference(vsk->remote_addr);
+	if (!remote_addr) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	ret = vsock_addr_bound(&remote_addr->addr);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_bound);
+
+int vsock_remote_addr_copy(struct vsock_sock *vsk, struct sockaddr_vm *dest)
+{
+	struct sockaddr_vm_rcu *remote_addr;
+
+	rcu_read_lock();
+	remote_addr = rcu_dereference(vsk->remote_addr);
+	if (!remote_addr) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	memcpy(dest, &remote_addr->addr, sizeof(*dest));
+	rcu_read_unlock();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_copy);
+
+int vsock_remote_addr_cid(struct vsock_sock *vsk, unsigned int *cid)
+{
+	return vsock_remote_addr_cid_port(vsk, cid, NULL);
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_cid);
+
+int vsock_remote_addr_port(struct vsock_sock *vsk, unsigned int *port)
+{
+	return vsock_remote_addr_cid_port(vsk, NULL, port);
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_port);
+
+int vsock_remote_addr_cid_port(struct vsock_sock *vsk, unsigned int *cid,
+			       unsigned int *port)
+{
+	struct sockaddr_vm_rcu *remote_addr;
+
+	rcu_read_lock();
+	remote_addr = rcu_dereference(vsk->remote_addr);
+	if (!remote_addr) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	if (cid)
+		*cid = remote_addr->addr.svm_cid;
+	if (port)
+		*port = remote_addr->addr.svm_port;
+
+	rcu_read_unlock();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_cid_port);
+
+/* The socket lock must be held by the caller */
+int vsock_remote_addr_update_cid_port(struct vsock_sock *vsk, u32 cid, u32 port)
+{
+	struct sockaddr_vm_rcu *old, *new;
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	rcu_read_lock();
+	old = rcu_dereference(vsk->remote_addr);
+	if (!old) {
+		kfree(new);
+		return -EINVAL;
+	}
+	memcpy(&new->addr, &old->addr, sizeof(new->addr));
+	rcu_read_unlock();
+
+	new->addr.svm_cid = cid;
+	new->addr.svm_port = port;
+
+	old = rcu_replace_pointer(vsk->remote_addr, new, lockdep_sock_is_held(sk_vsock(vsk)));
+	kfree_rcu(old, rcu);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_update_cid_port);
+
+/* The socket lock must be held by the caller */
+int vsock_remote_addr_update(struct vsock_sock *vsk, struct sockaddr_vm *src)
+{
+	struct sockaddr_vm_rcu *old, *new;
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	memcpy(&new->addr, src, sizeof(new->addr));
+	old = rcu_replace_pointer(vsk->remote_addr, new, lockdep_sock_is_held(sk_vsock(vsk)));
+	kfree_rcu(old, rcu);
+
+	return 0;
+}
+
+bool vsock_remote_addr_equals(struct vsock_sock *vsk,
+			      struct sockaddr_vm *other)
+{
+	struct sockaddr_vm_rcu *remote_addr;
+	bool equals;
+
+	rcu_read_lock();
+	remote_addr = rcu_dereference(vsk->remote_addr);
+	if (!remote_addr) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	equals = vsock_addr_equals_addr(&remote_addr->addr, other);
+	rcu_read_unlock();
+
+	return equals;
+}
+EXPORT_SYMBOL_GPL(vsock_remote_addr_equals);
 
 /* Each bound VSocket is stored in the bind hash table and each connected
  * VSocket is stored in the connected hash table.
@@ -254,10 +387,16 @@ static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
 
 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
 			    connected_table) {
-		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
+		struct sockaddr_vm_rcu *remote_addr;
+
+		rcu_read_lock();
+		remote_addr = rcu_dereference(vsk->remote_addr);
+		if (vsock_addr_equals_addr(src, &remote_addr->addr) &&
 		    dst->svm_port == vsk->local_addr.svm_port) {
+			rcu_read_unlock();
 			return sk_vsock(vsk);
 		}
+		rcu_read_unlock();
 	}
 
 	return NULL;
@@ -270,14 +409,25 @@ static void vsock_insert_unbound(struct vsock_sock *vsk)
 	spin_unlock_bh(&vsock_table_lock);
 }
 
-void vsock_insert_connected(struct vsock_sock *vsk)
+int vsock_insert_connected(struct vsock_sock *vsk)
 {
-	struct list_head *list = vsock_connected_sockets(
-		&vsk->remote_addr, &vsk->local_addr);
+	struct list_head *list;
+	struct sockaddr_vm_rcu *remote_addr;
+
+	rcu_read_lock();
+	remote_addr = rcu_dereference(vsk->remote_addr);
+	if (!remote_addr) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	list = vsock_connected_sockets(&remote_addr->addr, &vsk->local_addr);
+	rcu_read_unlock();
 
 	spin_lock_bh(&vsock_table_lock);
 	__vsock_insert_connected(list, vsk);
 	spin_unlock_bh(&vsock_table_lock);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vsock_insert_connected);
 
@@ -438,10 +588,17 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 {
 	const struct vsock_transport *new_transport;
 	struct sock *sk = sk_vsock(vsk);
-	unsigned int remote_cid = vsk->remote_addr.svm_cid;
+	struct sockaddr_vm remote_addr;
+	unsigned int remote_cid;
 	__u8 remote_flags;
 	int ret;
 
+	ret = vsock_remote_addr_copy(vsk, &remote_addr);
+	if (ret < 0)
+		return ret;
+
+	remote_cid = remote_addr.svm_cid;
+
 	/* If the packet is coming with the source and destination CIDs higher
 	 * than VMADDR_CID_HOST, then a vsock channel where all the packets are
 	 * forwarded to the host should be established. Then the host will
@@ -451,10 +608,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	 * the connect path the flag can be set by the user space application.
 	 */
 	if (psk && vsk->local_addr.svm_cid > VMADDR_CID_HOST &&
-	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
-		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
+	    remote_addr.svm_cid > VMADDR_CID_HOST) {
+		remote_addr.svm_flags |= VMADDR_CID_HOST;
+
+		ret = vsock_remote_addr_update(vsk, &remote_addr);
+		if (ret < 0)
+			return ret;
+	}
 
-	remote_flags = vsk->remote_addr.svm_flags;
+	remote_flags = remote_addr.svm_flags;
 
 	switch (sk->sk_type) {
 	case SOCK_DGRAM:
@@ -742,6 +904,7 @@ static struct sock *__vsock_create(struct net *net,
 				   unsigned short type,
 				   int kern)
 {
+	struct sockaddr_vm *remote_addr;
 	struct sock *sk;
 	struct vsock_sock *psk;
 	struct vsock_sock *vsk;
@@ -761,7 +924,14 @@ static struct sock *__vsock_create(struct net *net,
 
 	vsk = vsock_sk(sk);
 	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+
+	remote_addr = kmalloc(sizeof(*remote_addr), GFP_KERNEL);
+	if (!remote_addr) {
+		sk_free(sk);
+		return NULL;
+	}
+	vsock_addr_init(remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
+	rcu_assign_pointer(vsk->remote_addr, remote_addr);
 
 	sk->sk_destruct = vsock_sk_destruct;
 	sk->sk_backlog_rcv = vsock_queue_rcv_skb;
@@ -845,6 +1015,7 @@ static void __vsock_release(struct sock *sk, int level)
 static void vsock_sk_destruct(struct sock *sk)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	struct sockaddr_vm_rcu *remote_addr;
 
 	vsock_deassign_transport(vsk);
 
@@ -852,8 +1023,8 @@ static void vsock_sk_destruct(struct sock *sk)
 	 * possibly register the address family with the kernel.
 	 */
 	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-
+	remote_addr = rcu_replace_pointer(vsk->remote_addr, NULL, 1);
+	kfree_rcu(remote_addr);
 	put_cred(vsk->owner);
 }
 
@@ -943,6 +1114,7 @@ static int vsock_getname(struct socket *sock,
 	struct sock *sk;
 	struct vsock_sock *vsk;
 	struct sockaddr_vm *vm_addr;
+	struct sockaddr_vm_rcu *rcu_ptr;
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
@@ -951,11 +1123,17 @@ static int vsock_getname(struct socket *sock,
 	lock_sock(sk);
 
 	if (peer) {
+		rcu_read_lock();
 		if (sock->state != SS_CONNECTED) {
 			err = -ENOTCONN;
 			goto out;
 		}
-		vm_addr = &vsk->remote_addr;
+		rcu_ptr = rcu_dereference(vsk->remote_addr);
+		if (!rcu_ptr) {
+			err = -EINVAL;
+			goto out;
+		}
+		vm_addr = &rcu_ptr->addr;
 	} else {
 		vm_addr = &vsk->local_addr;
 	}
@@ -975,6 +1153,8 @@ static int vsock_getname(struct socket *sock,
 	err = sizeof(*vm_addr);
 
 out:
+	if (peer)
+		rcu_read_unlock();
 	release_sock(sk);
 	return err;
 }
@@ -1161,7 +1341,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	int err;
 	struct sock *sk;
 	struct vsock_sock *vsk;
-	struct sockaddr_vm *remote_addr;
+	struct sockaddr_vm stack_addr, *remote_addr;
 	const struct vsock_transport *transport;
 
 	if (msg->msg_flags & MSG_OOB)
@@ -1172,15 +1352,26 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
 
-	lock_sock(sk);
+	/* If auto-binding is required, acquire the slock to avoid potential
+	 * race conditions. Otherwise, do not acquire the lock.
+	 *
+	 * We know that the first check of local_addr is racy (indicated by
+	 * data_race()). By acquiring the lock and then subsequently checking
+	 * again if local_addr is bound (inside vsock_auto_bind()), we can
+	 * ensure there are no real data races.
+	 *
+	 * This technique is borrowed by inet_send_prepare().
+	 */
+	if (data_race(!vsock_addr_bound(&vsk->local_addr))) {
+		lock_sock(sk);
+		err = vsock_auto_bind(vsk);
+		release_sock(sk);
+		if (err)
+			return err;
+	}
 
 	transport = vsk->transport;
 
-	err = vsock_auto_bind(vsk);
-	if (err)
-		goto out;
-
-
 	/* If the provided message contains an address, use that.  Otherwise
 	 * fall back on the socket's remote handle (if it has been connected).
 	 */
@@ -1199,18 +1390,26 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto out;
 		}
 	} else if (sock->state == SS_CONNECTED) {
-		remote_addr = &vsk->remote_addr;
+		err = vsock_remote_addr_copy(vsk, &stack_addr);
+		if (err < 0)
+			goto out;
 
-		if (remote_addr->svm_cid == VMADDR_CID_ANY)
-			remote_addr->svm_cid = transport->get_local_cid();
+		if (stack_addr.svm_cid == VMADDR_CID_ANY) {
+			stack_addr.svm_cid = transport->get_local_cid();
+			lock_sock(sk_vsock(vsk));
+			vsock_remote_addr_update(vsk, &stack_addr);
+			release_sock(sk_vsock(vsk));
+		}
 
 		/* XXX Should connect() or this function ensure remote_addr is
 		 * bound?
 		 */
-		if (!vsock_addr_bound(&vsk->remote_addr)) {
+		if (!vsock_addr_bound(&stack_addr)) {
 			err = -EINVAL;
 			goto out;
 		}
+
+		remote_addr = &stack_addr;
 	} else {
 		err = -EINVAL;
 		goto out;
@@ -1225,7 +1424,6 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
 
 out:
-	release_sock(sk);
 	return err;
 }
 
@@ -1243,8 +1441,7 @@ static int vsock_dgram_connect(struct socket *sock,
 	err = vsock_addr_cast(addr, addr_len, &remote_addr);
 	if (err == -EAFNOSUPPORT && remote_addr->svm_family == AF_UNSPEC) {
 		lock_sock(sk);
-		vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY,
-				VMADDR_PORT_ANY);
+		vsock_remote_addr_update_cid_port(vsk, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 		sock->state = SS_UNCONNECTED;
 		release_sock(sk);
 		return 0;
@@ -1263,7 +1460,10 @@ static int vsock_dgram_connect(struct socket *sock,
 		goto out;
 	}
 
-	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
+	err = vsock_remote_addr_update(vsk, remote_addr);
+	if (err < 0)
+		goto out;
+
 	sock->state = SS_CONNECTED;
 
 	/* sock map disallows redirection of non-TCP sockets with sk_state !=
@@ -1399,8 +1599,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		}
 
 		/* Set the remote address that we are connecting to. */
-		memcpy(&vsk->remote_addr, remote_addr,
-		       sizeof(vsk->remote_addr));
+		err = vsock_remote_addr_update(vsk, remote_addr);
+		if (err)
+			goto out;
 
 		err = vsock_assign_transport(vsk, NULL);
 		if (err)
@@ -1831,7 +2032,7 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
-	if (!vsock_addr_bound(&vsk->remote_addr)) {
+	if (!vsock_remote_addr_bound(vsk)) {
 		err = -EDESTADDRREQ;
 		goto out;
 	}
diff --git a/net/vmw_vsock/diag.c b/net/vmw_vsock/diag.c
index a2823b1c5e28..f843bae86b32 100644
--- a/net/vmw_vsock/diag.c
+++ b/net/vmw_vsock/diag.c
@@ -15,8 +15,14 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 			u32 portid, u32 seq, u32 flags)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	struct sockaddr_vm remote_addr;
 	struct vsock_diag_msg *rep;
 	struct nlmsghdr *nlh;
+	int err;
+
+	err = vsock_remote_addr_copy(vsk, &remote_addr);
+	if (err < 0)
+		return err;
 
 	nlh = nlmsg_put(skb, portid, seq, SOCK_DIAG_BY_FAMILY, sizeof(*rep),
 			flags);
@@ -36,8 +42,8 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 	rep->vdiag_shutdown = sk->sk_shutdown;
 	rep->vdiag_src_cid = vsk->local_addr.svm_cid;
 	rep->vdiag_src_port = vsk->local_addr.svm_port;
-	rep->vdiag_dst_cid = vsk->remote_addr.svm_cid;
-	rep->vdiag_dst_port = vsk->remote_addr.svm_port;
+	rep->vdiag_dst_cid = remote_addr.svm_cid;
+	rep->vdiag_dst_port = remote_addr.svm_port;
 	rep->vdiag_ino = sock_i_ino(sk);
 
 	sock_diag_save_cookie(sk, rep->vdiag_cookie);
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 7cb1a9d2cdb4..462b2ec3e6e9 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -336,9 +336,11 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		hvs_addr_init(&vnew->local_addr, if_type);
 
 		/* Remote peer is always the host */
-		vsock_addr_init(&vnew->remote_addr,
-				VMADDR_CID_HOST, VMADDR_PORT_ANY);
-		vnew->remote_addr.svm_port = get_port_by_srv_id(if_instance);
+		ret = vsock_remote_addr_update_cid_port(vnew, VMADDR_CID_HOST,
+							get_port_by_srv_id(if_instance));
+		if (ret < 0)
+			goto out;
+
 		ret = vsock_assign_transport(vnew, vsock_sk(sk));
 		/* Transport assigned (looking at remote_addr) must be the
 		 * same where we received the request.
@@ -459,13 +461,18 @@ static int hvs_connect(struct vsock_sock *vsk)
 {
 	union hvs_service_id vm, host;
 	struct hvsock *h = vsk->trans;
+	int err;
 
 	vm.srv_id = srv_id_template;
 	vm.svm_port = vsk->local_addr.svm_port;
 	h->vm_srv_id = vm.srv_id;
 
 	host.srv_id = srv_id_template;
-	host.svm_port = vsk->remote_addr.svm_port;
+
+	err = vsock_remote_addr_port(vsk, &host.svm_port);
+	if (err < 0)
+		return err;
+
 	h->host_srv_id = host.srv_id;
 
 	return vmbus_send_tl_connect_request(&h->vm_srv_id, &h->host_srv_id);
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 925acface893..1b87704e516a 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -258,8 +258,9 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	src_cid = t_ops->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
-		dst_cid	= vsk->remote_addr.svm_cid;
-		dst_port = vsk->remote_addr.svm_port;
+		ret = vsock_remote_addr_cid_port(vsk, &dst_cid, &dst_port);
+		if (ret < 0)
+			return ret;
 	} else {
 		dst_cid = info->remote_cid;
 		dst_port = info->remote_port;
@@ -1169,7 +1170,9 @@ virtio_transport_recv_connecting(struct sock *sk,
 	case VIRTIO_VSOCK_OP_RESPONSE:
 		sk->sk_state = TCP_ESTABLISHED;
 		sk->sk_socket->state = SS_CONNECTED;
-		vsock_insert_connected(vsk);
+		err = vsock_insert_connected(vsk);
+		if (err)
+			goto destroy;
 		sk->sk_state_change(sk);
 		break;
 	case VIRTIO_VSOCK_OP_INVALID:
@@ -1403,9 +1406,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	vchild = vsock_sk(child);
 	vsock_addr_init(&vchild->local_addr, le64_to_cpu(hdr->dst_cid),
 			le32_to_cpu(hdr->dst_port));
-	vsock_addr_init(&vchild->remote_addr, le64_to_cpu(hdr->src_cid),
-			le32_to_cpu(hdr->src_port));
-
+	vsock_remote_addr_update_cid_port(vchild, le64_to_cpu(hdr->src_cid),
+					  le32_to_cpu(hdr->src_port));
 	ret = vsock_assign_transport(vchild, vsk);
 	/* Transport assigned (looking at remote_addr) must be the same
 	 * where we received the request.
@@ -1420,7 +1422,13 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	if (virtio_transport_space_update(child, skb))
 		child->sk_write_space(child);
 
-	vsock_insert_connected(vchild);
+	ret = vsock_insert_connected(vchild);
+	if (ret) {
+		release_sock(child);
+		virtio_transport_reset_no_sock(t, skb);
+		sock_put(child);
+		return ret;
+	}
 	vsock_enqueue_accept(sk, child);
 	virtio_transport_send_response(vchild, skb);
 
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b370070194fa..c0c445e7d925 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -283,18 +283,25 @@ vmci_transport_send_control_pkt(struct sock *sk,
 				u16 proto,
 				struct vmci_handle handle)
 {
+	struct sockaddr_vm addr_stack;
+	struct sockaddr_vm *remote_addr = &addr_stack;
 	struct vsock_sock *vsk;
+	int err;
 
 	vsk = vsock_sk(sk);
 
 	if (!vsock_addr_bound(&vsk->local_addr))
 		return -EINVAL;
 
-	if (!vsock_addr_bound(&vsk->remote_addr))
+	if (!vsock_remote_addr_bound(vsk))
 		return -EINVAL;
 
+	err = vsock_remote_addr_copy(vsk, &addr_stack);
+	if (err < 0)
+		return err;
+
 	return vmci_transport_alloc_send_control_pkt(&vsk->local_addr,
-						     &vsk->remote_addr,
+						     remote_addr,
 						     type, size, mode,
 						     wait, proto, handle);
 }
@@ -317,6 +324,7 @@ static int vmci_transport_send_reset(struct sock *sk,
 	struct sockaddr_vm *dst_ptr;
 	struct sockaddr_vm dst;
 	struct vsock_sock *vsk;
+	int err;
 
 	if (pkt->type == VMCI_TRANSPORT_PACKET_TYPE_RST)
 		return 0;
@@ -326,13 +334,16 @@ static int vmci_transport_send_reset(struct sock *sk,
 	if (!vsock_addr_bound(&vsk->local_addr))
 		return -EINVAL;
 
-	if (vsock_addr_bound(&vsk->remote_addr)) {
-		dst_ptr = &vsk->remote_addr;
+	if (vsock_remote_addr_bound(vsk)) {
+		err = vsock_remote_addr_copy(vsk, &dst);
+		if (err < 0)
+			return err;
 	} else {
 		vsock_addr_init(&dst, pkt->dg.src.context,
 				pkt->src_port);
-		dst_ptr = &dst;
 	}
+	dst_ptr = &dst;
+
 	return vmci_transport_alloc_send_control_pkt(&vsk->local_addr, dst_ptr,
 					     VMCI_TRANSPORT_PACKET_TYPE_RST,
 					     0, 0, NULL, VSOCK_PROTO_INVALID,
@@ -490,7 +501,7 @@ static struct sock *vmci_transport_get_pending(
 
 	list_for_each_entry(vpending, &vlistener->pending_links,
 			    pending_links) {
-		if (vsock_addr_equals_addr(&src, &vpending->remote_addr) &&
+		if (vsock_remote_addr_equals(vpending, &src) &&
 		    pkt->dst_port == vpending->local_addr.svm_port) {
 			pending = sk_vsock(vpending);
 			sock_hold(pending);
@@ -1015,8 +1026,8 @@ static int vmci_transport_recv_listen(struct sock *sk,
 
 	vsock_addr_init(&vpending->local_addr, pkt->dg.dst.context,
 			pkt->dst_port);
-	vsock_addr_init(&vpending->remote_addr, pkt->dg.src.context,
-			pkt->src_port);
+	vsock_remote_addr_update_cid_port(vpending, pkt->dg.src.context,
+					  pkt->src_port);
 
 	err = vsock_assign_transport(vpending, vsock_sk(sk));
 	/* Transport assigned (looking at remote_addr) must be the same
@@ -1133,6 +1144,7 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 {
 	struct vsock_sock *vpending;
 	struct vmci_handle handle;
+	unsigned int vpending_remote_cid;
 	struct vmci_qp *qpair;
 	bool is_local;
 	u32 flags;
@@ -1189,8 +1201,13 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 	/* vpending->local_addr always has a context id so we do not need to
 	 * worry about VMADDR_CID_ANY in this case.
 	 */
-	is_local =
-	    vpending->remote_addr.svm_cid == vpending->local_addr.svm_cid;
+	err = vsock_remote_addr_cid(vpending, &vpending_remote_cid);
+	if (err < 0) {
+		skerr = EPROTO;
+		goto destroy;
+	}
+
+	is_local = vpending_remote_cid == vpending->local_addr.svm_cid;
 	flags = VMCI_QPFLAG_ATTACH_ONLY;
 	flags |= is_local ? VMCI_QPFLAG_LOCAL : 0;
 
@@ -1203,7 +1220,7 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 					flags,
 					vmci_transport_is_trusted(
 						vpending,
-						vpending->remote_addr.svm_cid));
+						vpending_remote_cid));
 	if (err < 0) {
 		vmci_transport_send_reset(pending, pkt);
 		skerr = -err;
@@ -1306,9 +1323,20 @@ vmci_transport_recv_connecting_client(struct sock *sk,
 		break;
 	case VMCI_TRANSPORT_PACKET_TYPE_NEGOTIATE:
 	case VMCI_TRANSPORT_PACKET_TYPE_NEGOTIATE2:
+		struct sockaddr_vm_rcu *remote_addr;
+
+		rcu_read_lock();
+		remote_addr = rcu_dereference(vsk->remote_addr);
+		if (!remote_addr) {
+			skerr = EPROTO;
+			err = -EINVAL;
+			rcu_read_unlock();
+			goto destroy;
+		}
+
 		if (pkt->u.size == 0
-		    || pkt->dg.src.context != vsk->remote_addr.svm_cid
-		    || pkt->src_port != vsk->remote_addr.svm_port
+		    || pkt->dg.src.context != remote_addr->addr.svm_cid
+		    || pkt->src_port != remote_addr->addr.svm_port
 		    || !vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)
 		    || vmci_trans(vsk)->qpair
 		    || vmci_trans(vsk)->produce_size != 0
@@ -1316,9 +1344,10 @@ vmci_transport_recv_connecting_client(struct sock *sk,
 		    || vmci_trans(vsk)->detach_sub_id != VMCI_INVALID_ID) {
 			skerr = EPROTO;
 			err = -EINVAL;
-
+			rcu_read_unlock();
 			goto destroy;
 		}
+		rcu_read_unlock();
 
 		err = vmci_transport_recv_connecting_client_negotiate(sk, pkt);
 		if (err) {
@@ -1379,6 +1408,7 @@ static int vmci_transport_recv_connecting_client_negotiate(
 	int err;
 	struct vsock_sock *vsk;
 	struct vmci_handle handle;
+	unsigned int remote_cid;
 	struct vmci_qp *qpair;
 	u32 detach_sub_id;
 	bool is_local;
@@ -1449,19 +1479,23 @@ static int vmci_transport_recv_connecting_client_negotiate(
 
 	/* Make VMCI select the handle for us. */
 	handle = VMCI_INVALID_HANDLE;
-	is_local = vsk->remote_addr.svm_cid == vsk->local_addr.svm_cid;
+
+	err = vsock_remote_addr_cid(vsk, &remote_cid);
+	if (err < 0)
+		goto destroy;
+
+	is_local = remote_cid == vsk->local_addr.svm_cid;
 	flags = is_local ? VMCI_QPFLAG_LOCAL : 0;
 
 	err = vmci_transport_queue_pair_alloc(&qpair,
 					      &handle,
 					      pkt->u.size,
 					      pkt->u.size,
-					      vsk->remote_addr.svm_cid,
+					      remote_cid,
 					      flags,
 					      vmci_transport_is_trusted(
 						  vsk,
-						  vsk->
-						  remote_addr.svm_cid));
+						  remote_cid));
 	if (err < 0)
 		goto destroy;
 

-- 
2.30.2

