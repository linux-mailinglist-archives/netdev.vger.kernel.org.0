Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29D66566CA
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 03:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiL0C0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 21:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiL0CZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 21:25:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F762707
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so16048147pjj.2
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvMG7HI+MNWsEUIqh/BKpMAFptkHeZ7mWrh2CvuyciY=;
        b=7HVylYQ0632scSj+HTgHmiMQ9nmof478HLpvsoucgyabAEQZNGTPT3Z/qsis+kC59W
         z35iuuygucSkTPXxU2rQzouhhLGAIzGkvF3m7pk5+8xBSsGt+CbSN0lbq8ILUybz57yy
         cLyKQLDjZ6MgxEg4kRt1+iYywQ7HR8xyrDuFAzQVwnJcLNyWbuKPoxsVqhr721slS4Za
         O9+JHGODB/C27e+6KSmMqvmV9uRuZbcKyXuSTupy/YfskVRR+/DQMQ21jpFiz/NpFOp6
         qAegzBRb6C6gPU9eBEYbHN/r+zXNOUUvJ1CgMxl8Ye95yh50MnJl1XQGHGC7x49OYu+h
         WUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DvMG7HI+MNWsEUIqh/BKpMAFptkHeZ7mWrh2CvuyciY=;
        b=A/G9PDNuAf+AvswbNce+g7Pqm+3+GrYnL52IDOqIXp8+nBCiwj8fn/4+dEJ9qcsl0h
         KsND8gyymW3XQcPzfvxFxArkSUdJe4wGPsteqQrFP3D9d1gAQNCJKVEjVBLJ2414nE1j
         lxeigl0e+VTeG/11JRZrGRaRn7H2zR7VGnX/WWEkosMc891Ej6Ifie6qEpRLQqlEvsHn
         BEIWtG3493JvDpWz2gQyvvheEFviMyomVXhY40rf8IkGlBKVheG0O7/+srrIx3W+iPTe
         7YQhsPVkRr3kZtkCzuiH8E0FKS1eTzUEjEsL4NsH/9PNjAWpYzDYE69VvA3TgA1lDAFB
         uYTA==
X-Gm-Message-State: AFqh2ko+Lg/hreTzEKNFZmZQWXylvs4e5zUK3egadMRo/Hb2+j2IoZyt
        7dMiwLs4sN45+1DPhwdLZsYTjw==
X-Google-Smtp-Source: AMrXdXsCQQEPIYOXi9oM5ZYP8gBVlj2VmXkt8bjfLAfaQc9Y/meV2EpOLBa5VvOmiNYjdHQCuyrHug==
X-Received: by 2002:a17:902:a584:b0:18f:ac9f:29f6 with SMTP id az4-20020a170902a58400b0018fac9f29f6mr21116232plb.50.1672107950201;
        Mon, 26 Dec 2022 18:25:50 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b001870dc3b4c0sm2465014plk.74.2022.12.26.18.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 18:25:49 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH 6/9] caif_virtio: convert to new unified vringh APIs
Date:   Tue, 27 Dec 2022 11:25:28 +0900
Message-Id: <20221227022528.609839-7-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221227022528.609839-1-mie@igel.co.jp>
References: <20221227022528.609839-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vringh_*_kern APIs are being removed without vringh_init_kern(), so change
to use new APIs.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 drivers/net/caif/caif_virtio.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 0b0f234b0b50..f9dd79807afa 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -265,18 +265,12 @@ static int cfv_rx_poll(struct napi_struct *napi, int quota)
 		 */
 		if (riov->i == riov->used) {
 			if (cfv->ctx.head != USHRT_MAX) {
-				vringh_complete_kern(cfv->vr_rx,
-						     cfv->ctx.head,
-						     0);
+				vringh_complete(cfv->vr_rx, cfv->ctx.head, 0);
 				cfv->ctx.head = USHRT_MAX;
 			}
 
-			err = vringh_getdesc_kern(
-				cfv->vr_rx,
-				riov,
-				NULL,
-				&cfv->ctx.head,
-				GFP_ATOMIC);
+			err = vringh_getdesc(cfv->vr_rx, riov, NULL,
+					     &cfv->ctx.head);
 
 			if (err <= 0)
 				goto exit;
@@ -317,9 +311,9 @@ static int cfv_rx_poll(struct napi_struct *napi, int quota)
 
 		/* Really out of packets? (stolen from virtio_net)*/
 		napi_complete(napi);
-		if (unlikely(!vringh_notify_enable_kern(cfv->vr_rx)) &&
+		if (unlikely(!vringh_notify_enable(cfv->vr_rx)) &&
 		    napi_schedule_prep(napi)) {
-			vringh_notify_disable_kern(cfv->vr_rx);
+			vringh_notify_disable(cfv->vr_rx);
 			__napi_schedule(napi);
 		}
 		break;
@@ -329,7 +323,7 @@ static int cfv_rx_poll(struct napi_struct *napi, int quota)
 		dev_kfree_skb(skb);
 		/* Stop NAPI poll on OOM, we hope to be polled later */
 		napi_complete(napi);
-		vringh_notify_enable_kern(cfv->vr_rx);
+		vringh_notify_enable(cfv->vr_rx);
 		break;
 
 	default:
@@ -337,12 +331,12 @@ static int cfv_rx_poll(struct napi_struct *napi, int quota)
 		netdev_warn(cfv->ndev, "Bad ring, disable device\n");
 		cfv->ndev->stats.rx_dropped = riov->used - riov->i;
 		napi_complete(napi);
-		vringh_notify_disable_kern(cfv->vr_rx);
+		vringh_notify_disable(cfv->vr_rx);
 		netif_carrier_off(cfv->ndev);
 		break;
 	}
 out:
-	if (rxcnt && vringh_need_notify_kern(cfv->vr_rx) > 0)
+	if (rxcnt && vringh_need_notify(cfv->vr_rx) > 0)
 		vringh_notify(cfv->vr_rx);
 	return rxcnt;
 }
@@ -352,7 +346,7 @@ static void cfv_recv(struct virtio_device *vdev, struct vringh *vr_rx)
 	struct cfv_info *cfv = vdev->priv;
 
 	++cfv->stats.rx_kicks;
-	vringh_notify_disable_kern(cfv->vr_rx);
+	vringh_notify_disable(cfv->vr_rx);
 	napi_schedule(&cfv->napi);
 }
 
@@ -460,7 +454,7 @@ static int cfv_netdev_close(struct net_device *netdev)
 	/* Disable interrupts, queues and NAPI polling */
 	netif_carrier_off(netdev);
 	virtqueue_disable_cb(cfv->vq_tx);
-	vringh_notify_disable_kern(cfv->vr_rx);
+	vringh_notify_disable(cfv->vr_rx);
 	napi_disable(&cfv->napi);
 
 	/* Release any TX buffers on both used and available rings */
-- 
2.25.1

