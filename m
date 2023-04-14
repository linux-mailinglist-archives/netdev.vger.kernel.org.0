Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9236E18FE
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjDNA0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjDNA0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:26:34 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B0A132
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:26:02 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id l16so5020062qtv.1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681431961; x=1684023961;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PYIT1lnM33FhMIDao3yAU/T7jZdFX13nUB4/ycJAyUs=;
        b=LhqSXenkCnqSOG+3dLmlz2mBTcp5bei9gpkyJdQVReVugd8dd8GVEjC3wku3rGmz2b
         izVyk33RC5zs/jdultZ//VQFjeuaZNCt39ZTLp8cceEqTvLr22XBbW9Tp8pzq0lNTKak
         W0oR+dShVLVw3YBqoOwm3LxHaosCRQQTF88m6d+X/KhSfogR+Ke4scUUhfgvp4RCQYDa
         IUCrQCB76Y0HxaauVJsDnJW2jmJZcK8c0Fq4UfHPiiAvgtwU+p4dz11hXw+bEdpDsHpY
         ZnHjrT68IA9U0nig7Lb8ILUVugNm7jgpZ0xYOL0P5R8MCvWhMz807P97vxqjxLdVJMFu
         PVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681431961; x=1684023961;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYIT1lnM33FhMIDao3yAU/T7jZdFX13nUB4/ycJAyUs=;
        b=T1ZvUUTZjRuzH777KXSo2WnYz6A7moS6Z+TipI7OgodEBqlf4YSo+UlB4By5FetIoU
         9EPVA+2q5PT5fXHwXf7s6yAn2VwkamJazX44FyK1WgS1CDwDPHuO0oLYBpY9xL3v8acT
         TwRvK0MspRaDrGZzfVRm4SrYpLTFFp+U/j1NmBrVsegvRLK9sH9NkmdC4Rg3MzDoLm2W
         AJESmP/2HURIQLnUl4zt28F2Mx9VCiNML3hWV6gAXg2km7WDd8WRnWMRNIX3Lo2AgLKc
         nbpIe5/KdoSOXnQl7yMXUbKoZ7aNiocoMfZVOO48j3CHFhvfeuJzzreNmEOsehnKMN+C
         mshw==
X-Gm-Message-State: AAQBX9fb8zPZ/dhyf2a9D2Vn9S14dRJabYXMV4FexYFnNEeowrTXJnxy
        Tq2qEVuRXQmj3TqsmS6EdFXKFA==
X-Google-Smtp-Source: AKy350aPLJcMQqSjxy50h0JNnq+b5WSX3RnhEmL+fP27aIWbXzY3nwNq61uEyJVNqIBWqgwQuxoLAw==
X-Received: by 2002:ac8:5a81:0:b0:3b3:7d5:a752 with SMTP id c1-20020ac85a81000000b003b307d5a752mr5087902qtc.50.1681431961400;
        Thu, 13 Apr 2023 17:26:01 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.122])
        by smtp.gmail.com with ESMTPSA id a1-20020ac844a1000000b003eabcc29132sm309928qto.29.2023.04.13.17.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 17:26:01 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Fri, 14 Apr 2023 00:25:57 +0000
Subject: [PATCH RFC net-next v2 1/4] virtio/vsock: support dgram
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v2-1-079cc7cee62e@bytedance.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for datagrams over virtio/vsock.

Message boundaries are preserved on a per-skb and per-vq entry basis.
Messages are copied in whole from the user to an SKB, which in turn is
added to the scatterlist for the virtqueue in whole for the device.
Messages do not straddle skbs and they do not straddle packets.
Messages may be truncated by the receiving user if their buffer is
shorter than the message.

Other properties of vsock datagrams:
- Datagrams self-throttle at the per-socket sk_sndbuf threshold.
- The same virtqueue is used as is used for streams and seqpacket flows
- Credits are not used for datagrams
- Packets are dropped silently by the device, which means the virtqueue
  will still get kicked even during high packet loss, so long as the
  socket does not exceed sk_sndbuf.

Future work might include finding a way to reduce the virtqueue kick
rate for datagram flows with high packet loss.

One outstanding issue with this commit is that it re-uses the stream
binding code and table, which means that there can not simultaneously be
VSOCK dgram and VSOCK stream/seqpacket of same port and CID. This should
be changed before undoing the RFC tag.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |   2 +-
 include/net/af_vsock.h                  |   1 +
 include/uapi/linux/virtio_vsock.h       |   1 +
 net/vmw_vsock/af_vsock.c                |  26 ++++-
 net/vmw_vsock/virtio_transport.c        |   2 +-
 net/vmw_vsock/virtio_transport_common.c | 199 ++++++++++++++++++++++++++++----
 6 files changed, 204 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6578db78f0ae..dff6ee1c479b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -921,7 +921,7 @@ static int __init vhost_vsock_init(void)
 	int ret;
 
 	ret = vsock_core_register(&vhost_transport.transport,
-				  VSOCK_TRANSPORT_F_H2G);
+				  VSOCK_TRANSPORT_F_H2G | VSOCK_TRANSPORT_F_DGRAM);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 0e7504a42925..57af28fede19 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -80,6 +80,7 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk);
 s64 vsock_stream_has_space(struct vsock_sock *vsk);
 struct sock *vsock_create_connected(struct sock *parent);
 void vsock_data_ready(struct sock *sk);
+int vsock_bind_stream(struct vsock_sock *vsk, struct sockaddr_vm *addr);
 
 /**** TRANSPORT ****/
 
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 64738838bee5..331be28b1d30 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -69,6 +69,7 @@ struct virtio_vsock_hdr {
 enum virtio_vsock_type {
 	VIRTIO_VSOCK_TYPE_STREAM = 1,
 	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
+	VIRTIO_VSOCK_TYPE_DGRAM = 3,
 };
 
 enum virtio_vsock_op {
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 413407bb646c..46b3f35e3adc 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -677,6 +677,19 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 	return 0;
 }
 
+int vsock_bind_stream(struct vsock_sock *vsk,
+		      struct sockaddr_vm *addr)
+{
+	int retval;
+
+	spin_lock_bh(&vsock_table_lock);
+	retval = __vsock_bind_connectible(vsk, addr);
+	spin_unlock_bh(&vsock_table_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(vsock_bind_stream);
+
 static int __vsock_bind_dgram(struct vsock_sock *vsk,
 			      struct sockaddr_vm *addr)
 {
@@ -2453,11 +2466,16 @@ int vsock_core_register(const struct vsock_transport *t, int features)
 	}
 
 	if (features & VSOCK_TRANSPORT_F_DGRAM) {
-		if (t_dgram) {
-			err = -EBUSY;
-			goto err_busy;
+		/* XXX: always chose the G2H variant over others, support nesting later */
+		if (features & VSOCK_TRANSPORT_F_G2H) {
+			if (t_dgram)
+				pr_warn("vsock: preferring g2h transport for dgram\n");
+			t_dgram = t;
+		}
+
+		if (!t_dgram) {
+			t_dgram = t;
 		}
-		t_dgram = t;
 	}
 
 	if (features & VSOCK_TRANSPORT_F_LOCAL) {
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..582c6c0f788f 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -775,7 +775,7 @@ static int __init virtio_vsock_init(void)
 		return -ENOMEM;
 
 	ret = vsock_core_register(&virtio_transport.transport,
-				  VSOCK_TRANSPORT_F_G2H);
+				  VSOCK_TRANSPORT_F_G2H | VSOCK_TRANSPORT_F_DGRAM);
 	if (ret)
 		goto out_wq;
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e4878551f140..925acface893 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -37,6 +37,35 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
 	return container_of(t, struct virtio_transport, transport);
 }
 
+/* Requires info->msg and info->vsk */
+static struct sk_buff *
+virtio_transport_sock_alloc_send_skb(struct virtio_vsock_pkt_info *info, unsigned int size,
+				     gfp_t mask, int *err)
+{
+	struct sk_buff *skb;
+	struct sock *sk;
+	int noblock;
+
+	if (size < VIRTIO_VSOCK_SKB_HEADROOM) {
+		*err = -EINVAL;
+		return NULL;
+	}
+
+	if (info->msg)
+		noblock = info->msg->msg_flags & MSG_DONTWAIT;
+	else
+		noblock = 1;
+
+	sk = sk_vsock(info->vsk);
+	sk->sk_allocation = mask;
+	skb = sock_alloc_send_skb(sk, size, noblock, err);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
+	return skb;
+}
+
 /* Returns a new packet on success, otherwise returns NULL.
  *
  * If NULL is returned, errp is set to a negative errno.
@@ -47,7 +76,8 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 			   u32 src_cid,
 			   u32 src_port,
 			   u32 dst_cid,
-			   u32 dst_port)
+			   u32 dst_port,
+			   int *errp)
 {
 	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
 	struct virtio_vsock_hdr *hdr;
@@ -55,9 +85,21 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	void *payload;
 	int err;
 
-	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
-	if (!skb)
+	/* dgrams do not use credits, self-throttle according to sk_sndbuf
+	 * using sock_alloc_send_skb. This helps avoid triggering the OOM.
+	 */
+	if (info->vsk && info->type == VIRTIO_VSOCK_TYPE_DGRAM) {
+		skb = virtio_transport_sock_alloc_send_skb(info, skb_len, GFP_KERNEL, &err);
+	} else {
+		skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
+		if (!skb)
+			err = -ENOMEM;
+	}
+
+	if (!skb) {
+		*errp = err;
 		return NULL;
+	}
 
 	hdr = virtio_vsock_hdr(skb);
 	hdr->type	= cpu_to_le16(info->type);
@@ -102,6 +144,7 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	return skb;
 
 out:
+	*errp = err;
 	kfree_skb(skb);
 	return NULL;
 }
@@ -183,7 +226,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
 
 static u16 virtio_transport_get_type(struct sock *sk)
 {
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_DGRAM)
+		return VIRTIO_VSOCK_TYPE_DGRAM;
+	else if (sk->sk_type == SOCK_STREAM)
 		return VIRTIO_VSOCK_TYPE_STREAM;
 	else
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
@@ -239,11 +284,10 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 
 		skb = virtio_transport_alloc_skb(info, skb_len,
 						 src_cid, src_port,
-						 dst_cid, dst_port);
-		if (!skb) {
-			ret = -ENOMEM;
+						 dst_cid, dst_port,
+						 &ret);
+		if (!skb)
 			break;
-		}
 
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
@@ -588,7 +632,56 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags)
 {
-	return -EOPNOTSUPP;
+	struct sk_buff *skb;
+	struct sock *sk;
+	size_t bytes;
+	int err;
+
+	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
+		return -EOPNOTSUPP;
+
+	sk = sk_vsock(vsk);
+	err = 0;
+
+	skb = skb_recv_datagram(sk, flags, &err);
+	if (!skb)
+		goto out;
+
+	/* If the user buffer is too short then truncate the message and set
+	 * MSG_TRUNC. The remainder will be discarded when the skb is freed.
+	 */
+	if (len < skb->len) {
+		bytes = len;
+		msg->msg_flags |= MSG_TRUNC;
+	} else {
+		bytes = skb->len;
+	}
+
+	/* Copy to msg from skb->data.
+	 * virtio_vsock_alloc_skb() should have already set
+	 * the skb pointers correctly. That is, skb->data
+	 * should not still be at skb->head.
+	 */
+	WARN_ON(skb->data == skb->head);
+	err = skb_copy_datagram_msg(skb, 0, msg, bytes);
+	if (err)
+		goto out;
+
+	/* On success, return the number bytes copied to the user buffer */
+	err = bytes;
+
+	if (msg->msg_name) {
+		/* Provide the address of the sender. */
+		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
+
+		vsock_addr_init(vm_addr, le64_to_cpu(virtio_vsock_hdr(skb)->src_cid),
+				le32_to_cpu(virtio_vsock_hdr(skb)->src_port));
+		msg->msg_namelen = sizeof(*vm_addr);
+	}
+
+out:
+	skb_free_datagram(&vsk->sk, skb);
+	return err;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
 
@@ -793,13 +886,13 @@ EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
 int virtio_transport_dgram_bind(struct vsock_sock *vsk,
 				struct sockaddr_vm *addr)
 {
-	return -EOPNOTSUPP;
+	return vsock_bind_stream(vsk, addr);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
 
 bool virtio_transport_dgram_allow(u32 cid, u32 port)
 {
-	return false;
+	return true;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
 
@@ -835,7 +928,37 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t dgram_len)
 {
-	return -EOPNOTSUPP;
+	struct virtio_vsock_pkt_info info = {
+		.op = VIRTIO_VSOCK_OP_RW,
+		.msg = msg,
+		.vsk = vsk,
+		.type = VIRTIO_VSOCK_TYPE_DGRAM,
+	};
+	const struct virtio_transport *t_ops;
+	u32 src_cid, src_port;
+	struct sk_buff *skb;
+	int err;
+
+	if (dgram_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+		return -EMSGSIZE;
+
+	t_ops = virtio_transport_get_ops(vsk);
+	if (unlikely(!t_ops))
+		return -EFAULT;
+
+	src_cid = t_ops->transport.get_local_cid();
+	src_port = vsk->local_addr.svm_port;
+
+	skb = virtio_transport_alloc_skb(&info, dgram_len,
+					 src_cid, src_port,
+					 remote_addr->svm_cid,
+					 remote_addr->svm_port,
+					 &err);
+
+	if (!skb)
+		return err;
+
+	return t_ops->send_pkt(skb);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
 
@@ -892,6 +1015,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.reply = true,
 	};
 	struct sk_buff *reply;
+	int err;
 
 	/* Send RST only if the original pkt is not a RST pkt */
 	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
@@ -904,9 +1028,10 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 					   le64_to_cpu(hdr->dst_cid),
 					   le32_to_cpu(hdr->dst_port),
 					   le64_to_cpu(hdr->src_cid),
-					   le32_to_cpu(hdr->src_port));
+					   le32_to_cpu(hdr->src_port),
+					   &err);
 	if (!reply)
-		return -ENOMEM;
+		return err;
 
 	return t->send_pkt(reply);
 }
@@ -1126,6 +1251,25 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		kfree_skb(skb);
 }
 
+/* This function takes ownership of the skb.
+ *
+ * It either places the skb on the sk_receive_queue or frees it.
+ */
+static int
+virtio_transport_recv_dgram(struct sock *sk, struct sk_buff *skb)
+{
+	int err;
+
+	err = sock_queue_rcv_skb(sk, skb);
+	if (err < 0) {
+		kfree_skb(skb);
+		return err;
+	}
+
+	sk->sk_data_ready(sk);
+	return 0;
+}
+
 static int
 virtio_transport_recv_connected(struct sock *sk,
 				struct sk_buff *skb)
@@ -1289,7 +1433,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 static bool virtio_transport_valid_type(u16 type)
 {
 	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
-	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
+	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET) ||
+	       (type == VIRTIO_VSOCK_TYPE_DGRAM);
 }
 
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
@@ -1303,22 +1448,25 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	struct vsock_sock *vsk;
 	struct sock *sk;
 	bool space_available;
+	u16 type;
 
 	vsock_addr_init(&src, le64_to_cpu(hdr->src_cid),
 			le32_to_cpu(hdr->src_port));
 	vsock_addr_init(&dst, le64_to_cpu(hdr->dst_cid),
 			le32_to_cpu(hdr->dst_port));
 
+	type = le16_to_cpu(hdr->type);
+
 	trace_virtio_transport_recv_pkt(src.svm_cid, src.svm_port,
 					dst.svm_cid, dst.svm_port,
 					le32_to_cpu(hdr->len),
-					le16_to_cpu(hdr->type),
+					type,
 					le16_to_cpu(hdr->op),
 					le32_to_cpu(hdr->flags),
 					le32_to_cpu(hdr->buf_alloc),
 					le32_to_cpu(hdr->fwd_cnt));
 
-	if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
+	if (!virtio_transport_valid_type(type)) {
 		(void)virtio_transport_reset_no_sock(t, skb);
 		goto free_pkt;
 	}
@@ -1330,13 +1478,15 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	if (!sk) {
 		sk = vsock_find_bound_socket(&dst);
 		if (!sk) {
-			(void)virtio_transport_reset_no_sock(t, skb);
+			if (type != VIRTIO_VSOCK_TYPE_DGRAM)
+				(void)virtio_transport_reset_no_sock(t, skb);
 			goto free_pkt;
 		}
 	}
 
-	if (virtio_transport_get_type(sk) != le16_to_cpu(hdr->type)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+	if (virtio_transport_get_type(sk) != type) {
+		if (type != VIRTIO_VSOCK_TYPE_DGRAM)
+			(void)virtio_transport_reset_no_sock(t, skb);
 		sock_put(sk);
 		goto free_pkt;
 	}
@@ -1352,12 +1502,18 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	/* Check if sk has been closed before lock_sock */
 	if (sock_flag(sk, SOCK_DONE)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		if (type != VIRTIO_VSOCK_TYPE_DGRAM)
+			(void)virtio_transport_reset_no_sock(t, skb);
 		release_sock(sk);
 		sock_put(sk);
 		goto free_pkt;
 	}
 
+	if (sk->sk_type == SOCK_DGRAM) {
+		virtio_transport_recv_dgram(sk, skb);
+		goto out;
+	}
+
 	space_available = virtio_transport_space_update(sk, skb);
 
 	/* Update CID in case it has changed after a transport reset event */
@@ -1389,6 +1545,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		break;
 	}
 
+out:
 	release_sock(sk);
 
 	/* Release refcnt obtained when we fetched this socket out of the

-- 
2.30.2

