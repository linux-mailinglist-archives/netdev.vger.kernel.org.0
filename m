Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF7AA603E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfICEbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:31:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40774 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfICEbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 00:31:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id t9so16459431wmi.5
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SMJ1L28NfyCI4pCcxApBzu/aQJPfByqOIykyBOmTxOw=;
        b=mDOJFQfk2f4HwiPwPoUfgtAipNiW8z2X++x/jjWRsCWKiYZ6eU7GpnkVpLV1O2FkJW
         6if4jviP+adGbL7ZjeD+EtePIKX2vYLjZBgEXGc2KblebL+fGnLPGe1BNShX+L4J5xc5
         lhjUXxfeqxvWO2Ok33cypibsFuiwlr/SDgrv13LVvtIRRTnMdTaIQMYA1XKIyWK0TV0N
         3mgHL6KCluLBMplTM6Xw3lsH9YalnzmxAAr2cmWckjUPYjxWm6niBWXaWfbr3bizNt3Q
         jup6c86eCknVgOz+QtQ+J7Lv0kjLBA9+oaj/jhh6rR7ochreqHPATFlalTymwUwGq0df
         JYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SMJ1L28NfyCI4pCcxApBzu/aQJPfByqOIykyBOmTxOw=;
        b=fEXc1Sxj6GOC4cLomKJNBBUJ0q2eiTwBq6kO9QGflm2E6imfMZQt2Fcw2rsC18fu4j
         UDJiXCui8UjP3oTUXYq2zrO1YJnY26nOBSzhkx5QRHEE4594qJ8p3W65YPyENN9v+yWJ
         RXRmX0OPTIr2y1R5Vv92UDt+vfX1pevvgvcucdL97LdO5xJhs/kGaD05PMg/7UJ/o7cB
         w7kqtDaWZR+37j5DpfeMc4J/oKmzu5I15Ir17q+ojpZmZVWum92E0B5kPdb9YnrMdqoi
         36b4ikQkgzeC4vVfPS3N/Pg+urGJTokP6w5VtyXKqKZ+Y+smm1dqjEjnxr8ApT2HuziV
         uw3g==
X-Gm-Message-State: APjAAAXmv90M6IBRF28a3H1N+YvAUMUfXEhz77RAxEpkdxgGG66X1di1
        iFeYWsLyRwqcRSdOBn4tc/xDrA==
X-Google-Smtp-Source: APXvYqwEWlnvEVyhRSWoTcvArVt24703ds1SHbMoBaQLe3cNIB26BVclXlmxZ/1U0QOtRcfMPyd6gQ==
X-Received: by 2002:a1c:540c:: with SMTP id i12mr2110133wmb.90.1567485095250;
        Mon, 02 Sep 2019 21:31:35 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e13sm21024465wmh.44.2019.09.02.21.31.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 21:31:34 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 2/5] net/tls: don't jump to return
Date:   Mon,  2 Sep 2019 21:31:03 -0700
Message-Id: <20190903043106.27570-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903043106.27570-1-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reusing parts of error path for normal exit will make
next commit harder to read, untangle the two.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index e188139f0464..2cd7318a1338 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -838,22 +838,18 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	struct net_device *netdev;
 	char *iv, *rec_seq;
 	struct sk_buff *skb;
-	int rc = -EINVAL;
 	__be64 rcd_sn;
+	int rc;
 
 	if (!ctx)
-		goto out;
+		return -EINVAL;
 
-	if (ctx->priv_ctx_tx) {
-		rc = -EEXIST;
-		goto out;
-	}
+	if (ctx->priv_ctx_tx)
+		return -EEXIST;
 
 	start_marker_record = kmalloc(sizeof(*start_marker_record), GFP_KERNEL);
-	if (!start_marker_record) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!start_marker_record)
+		return -ENOMEM;
 
 	offload_ctx = kzalloc(TLS_OFFLOAD_CONTEXT_SIZE_TX, GFP_KERNEL);
 	if (!offload_ctx) {
@@ -982,7 +978,8 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	smp_store_release(&sk->sk_validate_xmit_skb, tls_validate_xmit_skb);
 	dev_put(netdev);
 	up_read(&device_offload_lock);
-	goto out;
+
+	return 0;
 
 release_netdev:
 	dev_put(netdev);
@@ -999,7 +996,6 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	ctx->priv_ctx_tx = NULL;
 free_marker_record:
 	kfree(start_marker_record);
-out:
 	return rc;
 }
 
@@ -1058,7 +1054,11 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 		goto free_sw_resources;
 
 	tls_device_attach(ctx, sk, netdev);
-	goto release_netdev;
+	up_read(&device_offload_lock);
+
+	dev_put(netdev);
+
+	return 0;
 
 free_sw_resources:
 	up_read(&device_offload_lock);
-- 
2.21.0

