Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755AC3DD541
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhHBMIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbhHBMIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:08:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEA1C061796
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 05:08:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t3so17250454plg.9
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 05:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j42q5rdRZ8gBlePD6vWg8hPTNcHOSjWSlt+Ho+ufcE8=;
        b=UwJwUPjlDNb71qW4v0Y+K8kmjyAwvH04VEeNmg7tGkkOuSswF/yNEXYddpFCC0XJ9c
         6fIn3JuZqAQXBkzx/b60j5tel3/imCLlvLyB7tC2jqffS2+Bcalqt6rw5xaVVKpLkZ9z
         LjZlRiL9LCaSjslKkC1oZPCMorGfIHC3uo78b2se7pFoCgGTxjaExiGm9IvecQO+zdpz
         YuQLqROwGIUxMALDUAhEgZ0EnJMw0nSnljq9o//n4uuT9Vo/0N5+kBmJb0C33qgGgYvh
         fZl6w/8FwwnWwHWI3TeKkLzdM5rLazrOPrBYSiKtEW+AarU1aQx8UL35gQr2rqp1zHBs
         EnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j42q5rdRZ8gBlePD6vWg8hPTNcHOSjWSlt+Ho+ufcE8=;
        b=VcSucQWG5gSQ6dj/IMdbADAlHPycznkUwu6YIVsdSQ8sE3sYJbzN8v2NFduile8/fy
         1iguowFYO15g/6YZQH4HaIFw8XlxHLLfeuQT9XCMxrhVhDd7Vuodv9VS2gJNYKb5Y3B/
         U/fUalvc8ZylVOBaTBLBkXmPLI0lUUWOw1ihsNFfS4zA29rwN/7G+rvkLdEbxXHlQQBM
         hntOHrpE4lwN+DOxXtVQ5EOy45W7SfToTNcktTx6DHTXJBDMpjuAoO8kob52Uk725qvO
         HmAtNsTAw5Oi7LjlibmJNC619Wd3S6Z+8lL1vT1e/CmOwExi6EpRtH2CoKTkvX/n6Oao
         P3WQ==
X-Gm-Message-State: AOAM532/me3/7N6Yraq1s65d2nLTVamrIWnhhBQp39YEpMUvYaQw/MFf
        YcrQJsNFQoI3eHNU+ocoa9Q21A==
X-Google-Smtp-Source: ABdhPJyWEyx8aChLggqRUs8fOfQ650EJoTGy+jTjblU9JsWLXnlVzZKnHrFbberN8DpROD+/drzUxQ==
X-Received: by 2002:a17:902:c20c:b029:12c:afb8:fad2 with SMTP id 12-20020a170902c20cb029012cafb8fad2mr6139991pll.19.1627906105954;
        Mon, 02 Aug 2021 05:08:25 -0700 (PDT)
Received: from n248-175-059.byted.org. ([121.30.179.62])
        by smtp.googlemail.com with ESMTPSA id f30sm12874867pgl.48.2021.08.02.05.08.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 05:08:25 -0700 (PDT)
From:   fuguancheng <fuguancheng@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        arseny.krasnov@kaspersky.com, andraprs@amazon.com,
        colin.king@canonical.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fuguancheng <fuguancheng@bytedance.com>
Subject: [PATCH 4/4] VSOCK DRIVER: support communication using host additional cids
Date:   Mon,  2 Aug 2021 20:07:20 +0800
Message-Id: <20210802120720.547894-5-fuguancheng@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210802120720.547894-1-fuguancheng@bytedance.com>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows the user to use the additional host CIDS to communicate
with the guest.  As server, the host can bind to any CIDS as long as
the cid can be mapped to one guest.

The VHOST_DEFAULT_CID can be used as normal.

As client, when connect to a remote server, if no address is specified to
be used, then it will use the first cid in the array. If the user wants
to use a specific cid, then the user can perfrom bind before the connect
operation, so that vsock_auto_bind will not be performed.

The patch depends on the previous patch which enables hypervisors such as
qemu to specify multiple cids for host and guest.

Signed-off-by: fuguancheng <fuguancheng@bytedance.com>
---
 drivers/vhost/vsock.c            | 39 ++++++++++++++++++++++++++++++++++++++-
 include/net/af_vsock.h           |  4 ++++
 net/vmw_vsock/af_vsock.c         | 20 ++++++++++++++------
 net/vmw_vsock/virtio_transport.c | 30 ++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f5d9b9f06ba5..104fcdea2dd7 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -57,8 +57,22 @@ struct vhost_vsock_ref {
 
 static bool vhost_transport_contain_cid(u32 cid)
 {
+	unsigned int index;
+	struct vhost_vsock_ref *ref;
+
 	if (cid == VHOST_VSOCK_DEFAULT_HOST_CID)
 		return true;
+
+	mutex_lock(&valid_host_mutex);
+	hash_for_each(valid_host_hash, index, ref, ref_hash) {
+		u32 other_cid = ref->cid;
+
+		if (other_cid == cid) {
+			mutex_unlock(&valid_host_mutex);
+			return true;
+		}
+	}
+	mutex_unlock(&valid_host_mutex);
 	return false;
 }
 
@@ -101,6 +115,21 @@ vhost_vsock_contain_cid(struct vhost_vsock *vsock, u32 cid)
 	return false;
 }
 
+/* Check if a cid is valid for the pkt to be received. */
+static bool
+vhost_vsock_contain_host_cid(struct vhost_vsock *vsock, u32 dst_cid)
+{
+	uint32_t index;
+
+	if (dst_cid == VHOST_VSOCK_DEFAULT_HOST_CID)
+		return true;
+	for (index = 0; index < vsock->num_host_cid; index++) {
+		if (vsock->hostcids[index] == dst_cid)
+			return true;
+	}
+	return false;
+}
+
 static u32 vhost_transport_get_local_cid(void)
 {
 	return VHOST_VSOCK_DEFAULT_HOST_CID;
@@ -128,6 +157,13 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 	return NULL;
 }
 
+/* This function checks if the cid is used by one of the guests. */
+static bool
+vhost_transport_contain_opposite_cid(u32 cid)
+{
+	return vhost_vsock_get(cid) != NULL;
+}
+
 /* Callers that dereference the return value must hold vhost_vsock_mutex or the
  * RCU read lock.
  */
@@ -512,6 +548,7 @@ static struct virtio_transport vhost_transport = {
 
 		.get_local_cid            = vhost_transport_get_local_cid,
 		.contain_cid              = vhost_transport_contain_cid,
+		.contain_opposite_cid     = vhost_transport_contain_opposite_cid,
 
 		.init                     = virtio_transport_do_socket_init,
 		.destruct                 = virtio_transport_destruct,
@@ -629,7 +666,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		/* Only accept correctly addressed packets */
 		if (vsock->num_cid > 0 &&
 			vhost_vsock_contain_cid(vsock, pkt->hdr.src_cid) &&
-		    le64_to_cpu(pkt->hdr.dst_cid) == vhost_transport_get_local_cid())
+		    vhost_vsock_contain_host_cid(vsock, le64_to_cpu(pkt->hdr.dst_cid)))
 			virtio_transport_recv_pkt(&vhost_transport, pkt);
 		else
 			virtio_transport_free_pkt(pkt);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index d0fc08fb9cac..739ac9aaff8f 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -171,6 +171,10 @@ struct vsock_transport {
 	/* Addressing. */
 	u32 (*get_local_cid)(void);
 	bool (*contain_cid)(u32 cid);
+	/* For transport_g2h, this checks if the cid is used by its host. */
+	/* For transport_h2g, this checks if the cid is used by one of its guests. */
+	/* This function is set to NULL for loopback_transport. */
+	bool (*contain_opposite_cid)(u32 cid);
 };
 
 /**** CORE ****/
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c22ae7101e55..d3037ee885be 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -397,9 +397,9 @@ static bool vsock_use_local_transport(unsigned int remote_cid)
 		return true;
 
 	if (transport_g2h) {
-		return remote_cid == transport_g2h->get_local_cid();
+		return transport_g2h->contain_cid(remote_cid);
 	} else {
-		return remote_cid == VMADDR_CID_HOST;
+		return transport_h2g->contain_cid(remote_cid);
 	}
 }
 
@@ -423,7 +423,9 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
  *    g2h is not loaded, will use local transport;
  *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
  *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
- *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
+ *  - remote CID > VMADDR_CID_HOST will use host->guest transport if
+ *    guest->host transport is not loaded.  Otherwise, if guest->host transport
+ *    contains the remote_cid, then use the guest->host transport.
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 {
@@ -434,15 +436,18 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	int ret;
 
 	/* If the packet is coming with the source and destination CIDs higher
-	 * than VMADDR_CID_HOST, then a vsock channel where all the packets are
+	 * than VMADDR_CID_HOST, and the source and destination CIDs are not
+	 * used by the host, then a vsock channel where all the packets are
 	 * forwarded to the host should be established. Then the host will
 	 * need to forward the packets to the guest.
 	 *
 	 * The flag is set on the (listen) receive path (psk is not NULL). On
 	 * the connect path the flag can be set by the user space application.
 	 */
-	if (psk && vsk->local_addr.svm_cid > VMADDR_CID_HOST &&
-	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
+	if (psk && transport_h2g && vsk->local_addr.svm_cid > VMADDR_CID_HOST &&
+	    !transport_h2g->contain_cid(vsk->local_addr.svm_cid) &&
+	    vsk->remote_addr.svm_cid > VMADDR_CID_HOST &&
+	    !transport_h2g->contain_cid(vsk->remote_addr.svm_cid))
 		vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
 
 	remote_flags = vsk->remote_addr.svm_flags;
@@ -458,6 +463,9 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
 			 (remote_flags & VMADDR_FLAG_TO_HOST))
 			new_transport = transport_g2h;
+		else if (remote_cid > VMADDR_CID_HOST && transport_g2h &&
+			 transport_g2h->contain_opposite_cid(remote_cid))
+			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
 		break;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index c552bc60e539..0c4a2f03318c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -99,6 +99,35 @@ static bool virtio_transport_contain_cid(u32 cid)
 	return ret;
 }
 
+/* This function checks if the transport_g2h is using the cid. */
+static bool virtio_transport_contain_opposite_cid(u32 cid)
+{
+	struct virtio_vsock *vsock;
+	bool ret;
+	u32 num_host_cid;
+
+	if (cid == VMADDR_CID_HOST)
+		return true;
+	num_host_cid = 0;
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
+	if (!vsock || vsock->number_host_cid == 0) {
+		ret = false;
+		goto out_rcu;
+	}
+
+	for (num_host_cid = 0; num_host_cid < vsock->number_host_cid; num_host_cid++) {
+		if (vsock->host_cids[num_host_cid] == cid) {
+			ret = true;
+			goto out_rcu;
+		}
+	}
+	ret = false;
+out_rcu:
+	rcu_read_unlock();
+	return ret;
+}
+
 static u32 virtio_transport_get_local_cid(void)
 {
 	struct virtio_vsock *vsock;
@@ -532,6 +561,7 @@ static struct virtio_transport virtio_transport = {
 
 		.get_local_cid            = virtio_transport_get_local_cid,
 		.contain_cid              = virtio_transport_contain_cid,
+		.contain_opposite_cid     = virtio_transport_contain_opposite_cid,
 
 		.init                     = virtio_transport_do_socket_init,
 		.destruct                 = virtio_transport_destruct,
-- 
2.11.0

