Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072345A768
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfF1XIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:08:11 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39096 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1XIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:08:11 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so8178131qta.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3X/04zhwrZPKCoSQmLee5JQ7e8O8NkvcQhEI2nEnj7k=;
        b=BrX3DWirXEI6sxzpVN6oZxt/L3odOOUQZZjr90odlP58EmYRpbXl4KnOXTeQXrnOiu
         1CUAN3bFNL9o+livGDtYIsOmlZMtaZDwoTRXOlg0SKezlLBPMFodsAMgPJAjp/ePy5Ev
         E/P+kqRK6GQshcP6ETPr83WzFxpqWlRnp0XYmQnVo7vW3zDNJxrIYisXX8NKDGqvQ1Vh
         ZwvD0F/2RiIONVFMAnsui/YG2maJNn3VGyjTbQZRSm5a6t4gn++xHeRTam4ZOVheDb/E
         l0VJC2oiPCWS++e74HccLo6IxIQpMpgYJHt/K+E9LhXSnXoz0BN4oNPr30BYSvnWQb4q
         Ww3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3X/04zhwrZPKCoSQmLee5JQ7e8O8NkvcQhEI2nEnj7k=;
        b=NvBawPkJTY0DVLPJ2k8aAYQ8kQGpVsoxL10zKtINykLY+pNbFxgYFN4siOGi5u/gW1
         GgMf7w5E74aumak0Mchm/mPpmsjTgSbVqhNiCYHEQEQPsiudHGjhgKZ7+AwElSqxrfql
         kK7imVWQAUH9YPml59esA1PxsmSxCw2aRmLA9mqvwEpCvdbtN2aF4lX628An0BhhxGFG
         rEOoFGIK7+9wL2fo7gEMuKkRXOEUYorTl5zFI/mQYDfEfQ1dusViYws9vpnaIrTGPBz+
         56e4UJGDu+0AhEDoMs95mmXFvmeI+Cy1IY/RpUZl92s/1HPT2Do/2hk1DVyP0zz1qOP7
         45Bw==
X-Gm-Message-State: APjAAAV7gNNTjfX3D0iZe/UMTcYecI3cZbCbCvVbTHwHbSGffbECDgjB
        EjA2oKwl9Q++36oqX/3qQOVXU7cfcjY=
X-Google-Smtp-Source: APXvYqz8y+xkabsY3pmrnnWgo7axr58axkGRGZUWduSX3RMpMRFp23djSVGT6n0Mk3RHZwTlDiXV0w==
X-Received: by 2002:ac8:17e6:: with SMTP id r35mr10006856qtk.215.1561763290114;
        Fri, 28 Jun 2019 16:08:10 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j19sm1391961qtq.94.2019.06.28.16.08.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 16:08:09 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net] net/tls: reject offload of TLS 1.3
Date:   Fri, 28 Jun 2019 16:07:59 -0700
Message-Id: <20190628230759.16360-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither drivers nor the tls offload code currently supports TLS
version 1.3. Check the TLS version when installing connection
state. TLS 1.3 will just fallback to the kernel crypto for now.

Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 1f9cf57d9754..397990407ed6 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -742,6 +742,11 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	}
 
 	crypto_info = &ctx->crypto_send.info;
+	if (crypto_info->version != TLS_1_2_VERSION) {
+		rc = -EOPNOTSUPP;
+		goto free_offload_ctx;
+	}
+
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
 		nonce_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
@@ -876,6 +881,9 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	struct net_device *netdev;
 	int rc = 0;
 
+	if (ctx->crypto_recv.info.version != TLS_1_2_VERSION)
+		return -EOPNOTSUPP;
+
 	/* We support starting offload on multiple sockets
 	 * concurrently, so we only need a read lock here.
 	 * This lock must precede get_netdev_for_sock to prevent races between
-- 
2.21.0

