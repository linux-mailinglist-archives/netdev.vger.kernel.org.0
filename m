Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5AF3DD53C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhHBMIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbhHBMIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:08:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B658C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 05:08:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso24362819pjo.1
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 05:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PTiBhSwkCea98qDiT23buvBtsb9gfJUIRj5xML15LbA=;
        b=AwxZLgcT65GUilQ+qYh3pNT3wt1RwBwIssNdZsmb96xmIF4qy2qHbKj72p5YlqvGkb
         3gJqJbE7XUcZwunjGU5wYAiMKVXlPjAbP6FQ8QS8lrjjVLEbHweqfpCaXrcWEXzRG8C1
         danBUTn83/M04FP7E6A9h3UjAB2rBbU4v85iM/flY6jKXA+r/k2iw1556oQDh4YNp8So
         dgvf2K+rN/17nJlEQSqiF+j8Hr3Rnjrvn2gOH8AbPVm/loLNkv9Tjyg/llBUab/+7/q3
         IshikrSd0npLCkB0/0YGEVeZ419mIdS54GY8K3JxikQ04FlQkyKTdlwQipStcTFmz+DB
         lAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PTiBhSwkCea98qDiT23buvBtsb9gfJUIRj5xML15LbA=;
        b=BvgoFQLSDjwAFe1hB2Ze5aS7wLrGm0oyFqfNXu8qxP48AwN4xV88+RuWSX5qVG2m4M
         czMoWnqKWKwQbIxt0V4tZ6ZqpO7NMybkXGwPrh+uSlPPmzcRmXi/tHGsZnz79OtW8ZwT
         lwg7X9bhlBQlsznCEGGhU4uRgW8PQS1AuialLM1fzrZaCk3VfJ814Q3soHdizVkMVjq8
         /J3lrsGPGPHDIu7L/KlPfKvfXW4JODnJiQfQrNJxFPUYhw09KAbTpstVKhLLC/Jy83Ni
         66Xkshh+aEQhTqb+BKTF9EdLXetxQld1meMt5WEzBgz6D547rTXCc/rI+n3LkfvEAAVD
         jicw==
X-Gm-Message-State: AOAM531dshblZys+YMDtWv45zckB3niAQiM/2uknFPG3XOOW70GBYACn
        gr8JRcPV7MPHI+kVK88dHn1dsg==
X-Google-Smtp-Source: ABdhPJwf7bHaKaWhpbZNiqIyyNSOA8m7JriTu91VqX/WXhlCR944DRM/Coy5lsMW8EEGuYngY4bVEQ==
X-Received: by 2002:a17:902:8484:b029:101:7016:fb7b with SMTP id c4-20020a1709028484b02901017016fb7bmr13809258plo.23.1627906091423;
        Mon, 02 Aug 2021 05:08:11 -0700 (PDT)
Received: from n248-175-059.byted.org. ([121.30.179.62])
        by smtp.googlemail.com with ESMTPSA id f30sm12874867pgl.48.2021.08.02.05.08.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 05:08:11 -0700 (PDT)
From:   fuguancheng <fuguancheng@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        arseny.krasnov@kaspersky.com, andraprs@amazon.com,
        colin.king@canonical.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fuguancheng <fuguancheng@bytedance.com>
Subject: [PATCH 2/4] VSOCK DRIVER: support communication using additional guest cid
Date:   Mon,  2 Aug 2021 20:07:18 +0800
Message-Id: <20210802120720.547894-3-fuguancheng@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210802120720.547894-1-fuguancheng@bytedance.com>
References: <20210802120720.547894-1-fuguancheng@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in this patch are made to allow the guest communicate
with the host using the additional cids specified when
creating the guest.

In original settings, the packet sent with the additional CIDS will
be rejected when received by the host, the newly added function
vhost_vsock_contain_cid will fix this error.

Now that we have multiple CIDS, the VMADDR_CID_ANY now behaves like
this:
1. The client will use the first available cid specified in the cids
array if VMADDR_CID_ANY is used.
2. The host will still use the original default CID.
3. If a guest server binds to VMADDR_CID_ANY, then the server can
choose to connect to any of the available CIDs for this guest.

Signed-off-by: fuguancheng <fuguancheng@bytedance.com>
---
 drivers/vhost/vsock.c                   | 14 +++++++++++++-
 net/vmw_vsock/af_vsock.c                |  2 +-
 net/vmw_vsock/virtio_transport_common.c |  5 ++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f66c87de91b8..013f8ebf8189 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -74,6 +74,18 @@ struct vhost_vsock {
 	bool seqpacket_allow;
 };
 
+static bool
+vhost_vsock_contain_cid(struct vhost_vsock *vsock, u32 cid)
+{
+	u32 index;
+
+	for (index = 0; index < vsock->num_cid; index++) {
+		if (cid == vsock->cids[index])
+			return true;
+	}
+	return false;
+}
+
 static u32 vhost_transport_get_local_cid(void)
 {
 	return VHOST_VSOCK_DEFAULT_HOST_CID;
@@ -584,7 +596,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 
 		/* Only accept correctly addressed packets */
 		if (vsock->num_cid > 0 &&
-		    (pkt->hdr.src_cid) == vsock->cids[0] &&
+			vhost_vsock_contain_cid(vsock, pkt->hdr.src_cid) &&
 		    le64_to_cpu(pkt->hdr.dst_cid) == vhost_transport_get_local_cid())
 			virtio_transport_recv_pkt(&vhost_transport, pkt);
 		else
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4e1fbe74013f..c22ae7101e55 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -251,7 +251,7 @@ static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
 			    connected_table) {
 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
-		    dst->svm_port == vsk->local_addr.svm_port) {
+		    vsock_addr_equals_addr(&vsk->local_addr, dst)) {
 			return sk_vsock(vsk);
 		}
 	}
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 169ba8b72a63..cb45e2f801f1 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -197,7 +197,10 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (unlikely(!t_ops))
 		return -EFAULT;
 
-	src_cid = t_ops->transport.get_local_cid();
+	if (vsk->local_addr.svm_cid != VMADDR_CID_ANY)
+		src_cid = vsk->local_addr.svm_cid;
+	else
+		src_cid = t_ops->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
 		dst_cid	= vsk->remote_addr.svm_cid;
-- 
2.11.0

