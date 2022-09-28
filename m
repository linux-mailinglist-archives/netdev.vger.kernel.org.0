Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C355ED54E
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiI1GsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiI1Grr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:47:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8810FD2D47
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:45:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gp22so2001038pjb.4
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=3oi+SDB8187tzA+ckFvB0jb9wA6Rb4ijKO33wMIa3kM=;
        b=HiSxXIOHuPkQ3xrIKJ5Z6SZRWTXyIafydST8v7WI2ilz914qeGnYOHeWoS5ywVxQoh
         jMCcB22d95dWnK522xTJ2MF296aNbYi9UoXj7T+ke7gG1dvd4OrSsxU8edRpVODg99xy
         mfIMxF5uvvIl6Lq+COZ9rGpIQav6gZE4nSgZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=3oi+SDB8187tzA+ckFvB0jb9wA6Rb4ijKO33wMIa3kM=;
        b=nLbNU+TyTR5REukAb5p5MVljnoNY6kjZ5klzEFmjRnxphrpciriaHLwffs9AN06OFa
         O90hlJ8mWr7z/fU6LAvZHCH3++Dcl3Yhs7QzCjvQYFBP7VToqJdCdsZ5WRBWaxwTgawi
         Gm+r1JWWljCCmmvjJneKcOAmKk5Nbx+LeZqEal/S8MMW6vYZZrF0iuS9MhzqDozAO4QA
         zRAjjh5Y7Wk2ooLLcGQ5K9YEpjYb3LDRjGWGYXc/92qy7vAXOCjyfeJA1AxeALVAgUrz
         0x61dD9G7zCERcD/eXLISFDrOtvNzlwIMMDaiIuxCIAS5QTzlNzv9Gq0k1e9dBjx0ds4
         EsMQ==
X-Gm-Message-State: ACrzQf3cZTYFiro2HWfV73kGe1cSSP5v+TckOKjQOgq6D1Bi4vGC40hX
        XW9InlsE28/DibwdI1otE4G4BQ==
X-Google-Smtp-Source: AMsMyM6WS7BEaumrqQGACwZzKkPH3LAw4ZdRXJeMcZ4rU1pyupbOPHSROeHptmy3p/OepWGlNZ8eZQ==
X-Received: by 2002:a17:90b:4c8a:b0:202:b3cd:f960 with SMTP id my10-20020a17090b4c8a00b00202b3cdf960mr8881218pjb.129.1664347543006;
        Tue, 27 Sep 2022 23:45:43 -0700 (PDT)
Received: from localhost (82.181.189.35.bc.googleusercontent.com. [35.189.181.82])
        by smtp.gmail.com with UTF8SMTPSA id w16-20020aa79a10000000b0053639773ad8sm3053640pfj.119.2022.09.27.23.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 23:45:42 -0700 (PDT)
From:   Junichi Uekawa <uekawa@chromium.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        mst@redhat.com, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org, Junichi Uekawa <uekawa@chromium.org>
Subject: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Date:   Wed, 28 Sep 2022 15:45:38 +0900
Message-Id: <20220928064538.667678-1-uekawa@chromium.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When copying a large file over sftp over vsock, data size is usually 32kB,
and kmalloc seems to fail to try to allocate 32 32kB regions.

 Call Trace:
  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
  [<ffffffffb683ddce>] kthread+0xfd/0x105
  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3

Work around by doing kvmalloc instead.

Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
---

 drivers/vhost/vsock.c                   | 2 +-
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 368330417bde..5703775af129 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
+	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
 	if (!pkt->buf) {
 		kfree(pkt);
 		return NULL;
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ec2c2afbf0d0..3a12aee33e92 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
 
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
 {
-	kfree(pkt->buf);
+	kvfree(pkt->buf);
 	kfree(pkt);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
-- 
2.37.3.998.g577e59143f-goog

