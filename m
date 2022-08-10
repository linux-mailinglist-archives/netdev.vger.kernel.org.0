Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4866158EFA9
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiHJPv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiHJPvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:51:44 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2349A4E873;
        Wed, 10 Aug 2022 08:51:42 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id a18-20020a05600c349200b003a30de68697so1852910wmq.0;
        Wed, 10 Aug 2022 08:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zKsqv0p5Obkg1TLb6/kUNEYbyvoYoWpfWSOapsGCJxI=;
        b=DFTQlY8ddG8nxlheZEdY1AhOzyhFf8i+cYlGvYaQA2jXHoy604PEPidno8824FFofg
         YVuRVy3aoGvd+VxIlbyTojzVgA6ObPKrHOe3N+BtwnJ8/SiHLCzaUthyY809sB53Uy0k
         A80hQEmxtBOQP5ObevE2QDwC8UdnYAyiC/9NRGBeNLRJhgqxJeTUEIEq3lyZCycgRAKv
         YeRgjQWebysXI2hCFaZdjrhd9yqY/GnXi1hw7QfcxVhAyGjXJUcOFXn8ZTBLEhYDSjyB
         tkKzffcoleVU5wSv7BENj8Sif4EsQ6FQBYNVk3yJnkXWSuO8uva7e43fGJIcAy/AtU+c
         ghIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zKsqv0p5Obkg1TLb6/kUNEYbyvoYoWpfWSOapsGCJxI=;
        b=G9aK6Gly5GgY0QpJ8fb3amum62meRzCgj4rlDdGRL7cdUR0YivFKfTWAhAvu7vxpOp
         0wB/xQk8WsXnhzymZnVag0UME1xBRGnUX35uKYhOLVt2gMswBcrvRxTi1UwYf5QEtFyX
         SRvB+EZX4NiRCVpY3QMF/uxofU3cOxNSvBBvpV5N4qLU0sdBvfoFgZvXuvDBEBlY77mu
         fmWALm5IHL7PBE+kuxowScTaRIq7D0ik75XB40oS1CDQYscfYfWeCEhueqWjiB87ht7v
         eBAW/nhhiIhU17GEZXgVO2VBMNegPdbDShUgkE9feIvukg6MyiWXTsMCVIuzuwiFTIHz
         rvvw==
X-Gm-Message-State: ACgBeo0/yTQ7g7bWh9HGB6rBfLllfriWPCVLpm39gwfO0vwOqw9ijL4E
        0oPjeNib66T+mzxDVPa807JLE5xt5KY=
X-Google-Smtp-Source: AA6agR7LF0ZwQ1BlKaVDicKs5LglruTEZwAxo7zyYgmWusQVZHSM24Cst0gJV7pB4XoOeH/qUhDY2A==
X-Received: by 2002:a05:600c:28cd:b0:3a5:4f45:b927 with SMTP id h13-20020a05600c28cd00b003a54f45b927mr2964921wmd.90.1660146700292;
        Wed, 10 Aug 2022 08:51:40 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 03/11] vhost/net: use struct ubuf_info_msgzc
Date:   Wed, 10 Aug 2022 16:49:11 +0100
Message-Id: <87cfb629defa270e5ed953c6e501a47278f916c9.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ubuf_info will be changed, use ubuf_info_msgzc instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/vhost/net.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 68e4ecd1cc0e..9b616536dd9e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -118,7 +118,7 @@ struct vhost_net_virtqueue {
 	/* Number of XDP frames batched */
 	int batched_xdp;
 	/* an array of userspace buffers info */
-	struct ubuf_info *ubuf_info;
+	struct ubuf_info_msgzc *ubuf_info;
 	/* Reference counting for outstanding ubufs.
 	 * Protected by vq mutex. Writers must also take device mutex. */
 	struct vhost_net_ubuf_ref *ubufs;
@@ -288,7 +288,7 @@ static int vhost_net_set_ubuf_info(struct vhost_net *n)
 		n->vqs[i].ubuf_info =
 			kmalloc_array(UIO_MAXIOV,
 				      sizeof(*n->vqs[i].ubuf_info),
-				      GFP_KERNEL);
+				      GFP_KERNEL | __GFP_ZERO);
 		if  (!n->vqs[i].ubuf_info)
 			goto err;
 	}
@@ -382,8 +382,9 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 }
 
 static void vhost_zerocopy_callback(struct sk_buff *skb,
-				    struct ubuf_info *ubuf, bool success)
+				    struct ubuf_info *ubuf_base, bool success)
 {
+	struct ubuf_info_msgzc *ubuf = uarg_to_msgzc(ubuf_base);
 	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
 	int cnt;
@@ -871,7 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	size_t len, total_len = 0;
 	int err;
 	struct vhost_net_ubuf_ref *ubufs;
-	struct ubuf_info *ubuf;
+	struct ubuf_info_msgzc *ubuf;
 	bool zcopy_used;
 	int sent_pkts = 0;
 
@@ -907,14 +908,14 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			ubuf = nvq->ubuf_info + nvq->upend_idx;
 			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
 			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
-			ubuf->callback = vhost_zerocopy_callback;
 			ubuf->ctx = nvq->ubufs;
 			ubuf->desc = nvq->upend_idx;
-			ubuf->flags = SKBFL_ZEROCOPY_FRAG;
-			refcount_set(&ubuf->refcnt, 1);
+			ubuf->ubuf.callback = vhost_zerocopy_callback;
+			ubuf->ubuf.flags = SKBFL_ZEROCOPY_FRAG;
+			refcount_set(&ubuf->ubuf.refcnt, 1);
 			msg.msg_control = &ctl;
 			ctl.type = TUN_MSG_UBUF;
-			ctl.ptr = ubuf;
+			ctl.ptr = &ubuf->ubuf;
 			msg.msg_controllen = sizeof(ctl);
 			ubufs = nvq->ubufs;
 			atomic_inc(&ubufs->refcount);
-- 
2.37.0

