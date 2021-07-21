Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FDB3D115A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbhGUNtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbhGUNtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:49:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C3EC0613C1
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:30:15 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d12so2393769wre.13
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsCZd4JYUlf4DgBXgVbea7RBOXoDbg1vUKFjYIRULao=;
        b=aRMmcMrQz3DNodcGZGJNIgwPB9ul8Scws6Wh44encugspS+AkIqOs1L5KeTTCR2oCr
         xm3up+Q1gK1r4UgRJfAUz0oWx54v97ib7+QiXJpg427VUpaTcC+kpFi2/kD7Pi2HuD9n
         amhCyXF4Un6rMyMpJ7diOOYjlg1OEoudCOCJAHmUH2+Lk8EDjkFIEdZo6zCvF/+FEnum
         pDNnXX42eNYuz/mqaozaReZ1dbcX5I19N5au4G2LtPAwqeEe/DqaFnJhKhtJjH0Ag/oC
         S9iAWmdAyeBp8wGcibVN1oM45ePOc9cSysgEkLqnvI5ihNEyG+lZ2phdaums+IGcpXAw
         ALBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsCZd4JYUlf4DgBXgVbea7RBOXoDbg1vUKFjYIRULao=;
        b=T4jhLQ+/QXm2R3GvaydLbmuBt9867s2sk3nOiBTUV48rvRGCnlPlnBmWnsGbm2gqjt
         ufisS4ZEvLp1MJHElO6lRFoWCo18CrNbHdPZXVwlF4G2S9MoHoNIEHCp8t5sQanv7RR8
         Ajft752JYWdvoMY2PbN1t1hOMv5LsStS3n/sgGojvgsw4reXByaslqN/OOXmS6p4YXVh
         cSZkVyorqPi0oUmfTMbeTXfU/bu5qde5THFxnnGq/3uS9JfnZt7HMx6T8MECT0ARtLXd
         8lDWY72hclQfrJyK7CNYUsFnXprT8LZ9W+KGNG79I+aqWn1YWypdCKj/DYNmnAA9idCj
         39uQ==
X-Gm-Message-State: AOAM533Ohdbv56o4FxBxOgEaNTXZOvuuk7Adb5mdGREWNzCkbry7wm+q
        pD5UwgY3FUNhDkYoQL4lCNOA1Q==
X-Google-Smtp-Source: ABdhPJy+FE5eryA5W6yWBtAOKXEQABDp/4ZN/cKYH6WivHT4TnZA/3j3HuxrxR7/mHKgfaB1peeREg==
X-Received: by 2002:adf:f149:: with SMTP id y9mr42188978wro.85.1626877814260;
        Wed, 21 Jul 2021 07:30:14 -0700 (PDT)
Received: from localhost.localdomain ([31.124.24.141])
        by smtp.gmail.com with ESMTPSA id 19sm133900wmj.2.2021.07.21.07.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 07:30:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Ram Muthiah <rammuthiah@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] virtio/vsock: Make vsock virtio packet buff size configurable
Date:   Wed, 21 Jul 2021 15:30:00 +0100
Message-Id: <20210721143001.182009-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ram Muthiah <rammuthiah@google.com>

After a virtual device has been running for some time, the SLAB
sustains ever increasing fragmentation. Contributing to this
fragmentation are the virtio packet buffer allocations which
are a drain on 64Kb compound pages. Eventually these can't be
allocated due to fragmentation.

To enable successful allocations for this packet buffer, the
packet buffer's size needs to be reduced.

In order to enable a reduction without impacting current users,
this variable is being exposed as a command line parameter.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Ram Muthiah <rammuthiah@google.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/virtio_vsock.h            | 4 +++-
 net/vmw_vsock/virtio_transport_common.c | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 35d7eedb5e8e4..8c77d60a74d34 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -7,9 +7,11 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 
+extern uint virtio_transport_max_vsock_pkt_buf_size;
+
 #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
 #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
-#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
+#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		virtio_transport_max_vsock_pkt_buf_size
 
 enum {
 	VSOCK_VQ_RX     = 0, /* for host to guest data */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 169ba8b72a630..d0d913afec8b6 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -26,6 +26,10 @@
 /* Threshold for detecting small packets to copy */
 #define GOOD_COPY_LEN  128
 
+uint virtio_transport_max_vsock_pkt_buf_size = 1024 * 64;
+module_param(virtio_transport_max_vsock_pkt_buf_size, uint, 0444);
+EXPORT_SYMBOL_GPL(virtio_transport_max_vsock_pkt_buf_size);
+
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
 {
-- 
2.32.0.402.g57bb445576-goog

