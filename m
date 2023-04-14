Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964766E18F5
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 02:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjDNA0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 20:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjDNA0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 20:26:12 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B234448D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:26:03 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id bn8so15002224qtb.2
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681431962; x=1684023962;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AeXK+YZDfGvT8N4veEQBLmfTPDbV8HnwPoAG/KMc8uk=;
        b=iD1ON+CSjyn81I5bfynPry8dYmrIhVjqo5HWLzEzkZ6dnmyhVxXAdkm7p3eeiX66HB
         DQHd+o7rWvxU+9qUm4cUP0y6v1T+sv1KY7yh8CmIyiU/gMfZkAPvM9THGLaxmgdSxpBx
         z/mgaMHMGYu2o1foiw3CWeJVXMgTDnem4qea2bLHVZIFQTqTpoZJfjRNyu99oCHT/eMe
         A/6uOHJA5jvuIqcatCtZ7njmoRC8Hodyvc1dwULspIeiZWwFjyZhK/llGoHH/6GXSgCH
         oHUx90wAae9PmSbE9xsHGVMz+YUKEJOvdzjkfgaVIagvX5PD+1OHiWawzNstzWBST6uv
         6vag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681431962; x=1684023962;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AeXK+YZDfGvT8N4veEQBLmfTPDbV8HnwPoAG/KMc8uk=;
        b=kpABKpQHKEdJZ5UEn2Nl/opy98FqlfG6B5Kv8TdZr5OFqNdXjqRgOl3LnDhuw3k80Q
         yubWQ7MqVHmDJlmHCjAKic8SxBDgRaYc0f1lfRxOP2YN0PhJTwm/jphjZrH5lgcW0tdM
         LG0G3UozGUek7UoC9TflfJVe9OJ4/4/ehc14q5aGfSXa862PBoCADP2oW7OaqQMzyk33
         XAlyn0n8SwikD3zfrPLouTtoaZu8ZwZZTZoPNR91ukaz63iwPGDXVY20OCoZanOw+KuY
         kIYkOJ+NHIQ6j1bM65JSSyGroyI/SPPTLhRE4USTxjlbnXEE2AhGBkDiBnnIe+Q+Q5i/
         fbBg==
X-Gm-Message-State: AAQBX9cychJCD0cvGaQP9/npELSS4fgEyHQv2f54BhTaEPbzOXWnIrNn
        Ozsd+BDh+edccXuBNj+GcaXRHw==
X-Google-Smtp-Source: AKy350Z7Z1WU/h310nrpIo+QfCgjEKXOZA1AmRPG5sOYpqNvx1wQYkAPoml8xgELCLfwyhZ0bbkiGA==
X-Received: by 2002:a05:622a:154:b0:3c0:3b79:9fb0 with SMTP id v20-20020a05622a015400b003c03b799fb0mr6558318qtw.47.1681431962311;
        Thu, 13 Apr 2023 17:26:02 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.122])
        by smtp.gmail.com with ESMTPSA id a1-20020ac844a1000000b003eabcc29132sm309928qto.29.2023.04.13.17.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 17:26:02 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Fri, 14 Apr 2023 00:25:58 +0000
Subject: [PATCH RFC net-next v2 2/4] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM
 feature bit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
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
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a feature bit for virtio vsock to support datagrams.
This commit should not be applied without first applying the commit
that implements datagrams for virtio.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c             | 3 ++-
 include/uapi/linux/virtio_vsock.h | 1 +
 net/vmw_vsock/virtio_transport.c  | 8 ++++++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index dff6ee1c479b..028cf079225e 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -32,7 +32,8 @@
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
 };
 
 enum {
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 331be28b1d30..0975b9c88292 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -40,6 +40,7 @@
 
 /* The feature bitmap for virtio vsock */
 #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
+#define VIRTIO_VSOCK_F_DGRAM		2	/* Host support dgram vsock */
 
 struct virtio_vsock_config {
 	__le64 guest_cid;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 582c6c0f788f..bb43eea9a6f9 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -29,6 +29,7 @@ static struct virtio_transport virtio_transport; /* forward declaration */
 struct virtio_vsock {
 	struct virtio_device *vdev;
 	struct virtqueue *vqs[VSOCK_VQ_MAX];
+	bool has_dgram;
 
 	/* Virtqueue processing is deferred to a workqueue */
 	struct work_struct tx_work;
@@ -640,7 +641,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	}
 
 	vsock->vdev = vdev;
-
 	vsock->rx_buf_nr = 0;
 	vsock->rx_buf_max_nr = 0;
 	atomic_set(&vsock->queued_replies, 0);
@@ -657,6 +657,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
+		vsock->has_dgram = true;
+
 	vdev->priv = vsock;
 
 	ret = virtio_vsock_vqs_init(vsock);
@@ -749,7 +752,8 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_VSOCK_F_SEQPACKET
+	VIRTIO_VSOCK_F_SEQPACKET,
+	VIRTIO_VSOCK_F_DGRAM
 };
 
 static struct virtio_driver virtio_vsock_driver = {

-- 
2.30.2

