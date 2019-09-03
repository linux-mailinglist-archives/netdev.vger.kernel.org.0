Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309E8A603F
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfICEbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:31:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55743 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfICEbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 00:31:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id g207so12475245wmg.5
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZW/8YkLS+cDDic4DO/lmTc3tG2NX66OGuRBd6vj2Xk=;
        b=SV+LkTcmGJ7lNLN7HkuMv8l8Exz7AOjcNqz1zMk/pEjHBZ1T95d/r3IKCRTrXYp0P/
         MTQ4EbPu2LWX7MmSleU0cZcg4JDox8iCo5Ydf/zUDHOUXDUqLwbN8rWc5m/pNXB9xzKr
         kAk7DHRLW1ftXihIc+cAiswZoIdVaFc6eiheHPywQGVFIm2CfsYx/nHvGWPMZHHNuFs8
         m+Ud3WAcbzMlK3PQj8QjEsf4Yg3duN3+R/Oly+QBOdGcAy5Jzwk1cK5dc/gl0qREKGp0
         IWlIPZWW+sRjLdTyrlmsfcWhrG+SIEvG+W7Lnd3uKGm8NRP4yEyuVEneSIQPE92iSrPC
         RwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZW/8YkLS+cDDic4DO/lmTc3tG2NX66OGuRBd6vj2Xk=;
        b=lva4lPMwS04tImSSWtdp7BhsNOho+Lo84wLxS103rWH8k4ItEEfg7MWBx/rh9gceXA
         0gO2fSfymRYPyuSyugqVNO8JN0eP2KD++/JVSzNttiDYaaE0ELlHaOiPdvJfCui5leQ5
         W2LJc69ZjT/rxuZVwsoOshJXhHSMQdgY/tbd5LsY3tT5xUxJWjea15hYOkkmwSqnLKMG
         NcLIDxFezsE1oKuaK6abZMwS/qQRfcOspeXX4KDyrcS9LBDtVthD/aZEaRfeq+yN5WGF
         gf8908/F9x5flzDpX9jJyiRAdCeZ0ghaM7q1Y/02z1LBKmm5x0OQmcsgSquvwCpdi36o
         p+PA==
X-Gm-Message-State: APjAAAVx6VPCsJFvqtY/OqMm5fE+xMstwr/cXRNCGsuyOL9R46ixzPQt
        /WQf/CiKoykXP3AWPywTzFwaXA==
X-Google-Smtp-Source: APXvYqzxJ4HqTUyrasLzUraZ4wJcuubxEdDUixxP2vKL7DdRNNnrzEoe8Vx4+CohEeWIA7kf6Bij8Q==
X-Received: by 2002:a1c:7009:: with SMTP id l9mr39755751wmc.159.1567485098520;
        Mon, 02 Sep 2019 21:31:38 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e13sm21024465wmh.44.2019.09.02.21.31.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 21:31:37 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 3/5] net/tls: narrow down the critical area of device_offload_lock
Date:   Mon,  2 Sep 2019 21:31:04 -0700
Message-Id: <20190903043106.27570-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903043106.27570-1-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On setsockopt path we need to hold device_offload_lock from
the moment we check netdev is up until the context is fully
ready to be added to the tls_device_list.

No need to hold it around the get_netdev_for_sock().
Change the code and remove the confusing comment.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 46 +++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 2cd7318a1338..9e1bec1a0a28 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -935,17 +935,11 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-	/* We support starting offload on multiple sockets
-	 * concurrently, so we only need a read lock here.
-	 * This lock must precede get_netdev_for_sock to prevent races between
-	 * NETDEV_DOWN and setsockopt.
-	 */
-	down_read(&device_offload_lock);
 	netdev = get_netdev_for_sock(sk);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
 		rc = -EINVAL;
-		goto release_lock;
+		goto disable_cad;
 	}
 
 	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
@@ -956,10 +950,15 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	/* Avoid offloading if the device is down
 	 * We don't want to offload new flows after
 	 * the NETDEV_DOWN event
+	 *
+	 * device_offload_lock is taken in tls_devices's NETDEV_DOWN
+	 * handler thus protecting from the device going down before
+	 * ctx was added to tls_device_list.
 	 */
+	down_read(&device_offload_lock);
 	if (!(netdev->flags & IFF_UP)) {
 		rc = -EINVAL;
-		goto release_netdev;
+		goto release_lock;
 	}
 
 	ctx->priv_ctx_tx = offload_ctx;
@@ -967,9 +966,10 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 					     &ctx->crypto_send.info,
 					     tcp_sk(sk)->write_seq);
 	if (rc)
-		goto release_netdev;
+		goto release_lock;
 
 	tls_device_attach(ctx, sk, netdev);
+	up_read(&device_offload_lock);
 
 	/* following this assignment tls_is_sk_tx_device_offloaded
 	 * will return true and the context might be accessed
@@ -977,14 +977,14 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	 */
 	smp_store_release(&sk->sk_validate_xmit_skb, tls_validate_xmit_skb);
 	dev_put(netdev);
-	up_read(&device_offload_lock);
 
 	return 0;
 
-release_netdev:
-	dev_put(netdev);
 release_lock:
 	up_read(&device_offload_lock);
+release_netdev:
+	dev_put(netdev);
+disable_cad:
 	clean_acked_data_disable(inet_csk(sk));
 	crypto_free_aead(offload_ctx->aead_send);
 free_rec_seq:
@@ -1008,17 +1008,10 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	if (ctx->crypto_recv.info.version != TLS_1_2_VERSION)
 		return -EOPNOTSUPP;
 
-	/* We support starting offload on multiple sockets
-	 * concurrently, so we only need a read lock here.
-	 * This lock must precede get_netdev_for_sock to prevent races between
-	 * NETDEV_DOWN and setsockopt.
-	 */
-	down_read(&device_offload_lock);
 	netdev = get_netdev_for_sock(sk);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
-		rc = -EINVAL;
-		goto release_lock;
+		return -EINVAL;
 	}
 
 	if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
@@ -1029,16 +1022,21 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	/* Avoid offloading if the device is down
 	 * We don't want to offload new flows after
 	 * the NETDEV_DOWN event
+	 *
+	 * device_offload_lock is taken in tls_devices's NETDEV_DOWN
+	 * handler thus protecting from the device going down before
+	 * ctx was added to tls_device_list.
 	 */
+	down_read(&device_offload_lock);
 	if (!(netdev->flags & IFF_UP)) {
 		rc = -EINVAL;
-		goto release_netdev;
+		goto release_lock;
 	}
 
 	context = kzalloc(TLS_OFFLOAD_CONTEXT_SIZE_RX, GFP_KERNEL);
 	if (!context) {
 		rc = -ENOMEM;
-		goto release_netdev;
+		goto release_lock;
 	}
 	context->resync_nh_reset = 1;
 
@@ -1066,10 +1064,10 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	down_read(&device_offload_lock);
 release_ctx:
 	ctx->priv_ctx_rx = NULL;
-release_netdev:
-	dev_put(netdev);
 release_lock:
 	up_read(&device_offload_lock);
+release_netdev:
+	dev_put(netdev);
 	return rc;
 }
 
-- 
2.21.0

