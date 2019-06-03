Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8622233B05
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfFCWSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34048 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfFCWSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:18:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id m29so6219175qtu.1
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ielN9uR1WYxE6wc1fWWNxMfBmHbzPSC3j1WJ3/+6KMY=;
        b=rBbK2VnNeVHsOYwpJPaiq7H5lUcMDo5vE3P7LUqHYQNu1Qzj8sS1YNOBg5pSUcYJIg
         808hwsFJSd8KDSx12VxqIL7umSze8qhFHNQGoktG6JsaIkaX4JHFxVfiJCxYg8C5mOGL
         xOMKvhOi91DCdx/P8qvtkB8hqMvdC7d1U/WE4WCOjWDYlzts2tq+HbJevApCISsKOCga
         tDNXOZg5PY/mlp/udkH6UQ1xcMRHgTeieHGcIBCZoNzSvr35dMSZX6Z2P0TOeSvqsXFw
         2ecF8z4sFhbj4Li+RyqVcTvPs9xDyFJ0SHyK/UfL/ZGuhfTAgM6yW8+NZIcAUsSzfSfB
         n6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ielN9uR1WYxE6wc1fWWNxMfBmHbzPSC3j1WJ3/+6KMY=;
        b=S75jxrg1u5ygC+0YOQQrFk77BqiszOOs+TGFAv74cY2CfvdhCnpwYQkWRGsSk3guJi
         skHTNz54jfvus6mgak2Z1hm2TctvB9ae1QkH38iWaROVtpobZZm0oBQqltUF4q+iNkwu
         IvYxzYgLyyxWsFRhyuwjJlMs022/KQ2sghdT+UmT+CGs4GDYtKLnjCpTI/T7N+Tnf0u0
         eY19GbWUmqBwFbTWbbS77W8eSTKLM6F5CHuwvPaSduPvf/vVioN+yYTthwkJEmr9tEI+
         PvsGDR4fwuyjg2a1Tt87plyfyFJWjDIW4ZmMVUUg0ZRBdaqa3WZvBsMTOre0oTJNSyDv
         6z7A==
X-Gm-Message-State: APjAAAXXUZWUy8dpW39p932WSYLyOkwaZvYmrL923N8OjouvyY2h10jU
        oMSKvk6oHextbNGW8Yz8ctHLgA==
X-Google-Smtp-Source: APXvYqxGBW9a6d5xlWBm20aRukPSj7qzrPJyDDFVzuDdaZcWZ3MlRxFAzvg/hjMuOl5trFqvlDwWYQ==
X-Received: by 2002:a0c:e8cf:: with SMTP id m15mr20086190qvo.81.1559600283033;
        Mon, 03 Jun 2019 15:18:03 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.18.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:18:02 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 5/8] net/tls: don't re-check msg decrypted status in tls_device_decrypted()
Date:   Mon,  3 Jun 2019 15:17:02 -0700
Message-Id: <20190603221705.12602-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_device_decrypted() is only called from decrypt_skb_update(),
when ctx->decrypted == false, there is no need to re-check the bit.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index dde6513628d2..bb9d229832cc 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -672,10 +672,6 @@ int tls_device_decrypted(struct sock *sk, struct sk_buff *skb)
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
 
-	/* Skip if it is already decrypted */
-	if (ctx->sw.decrypted)
-		return 0;
-
 	/* Check if all the data is decrypted already */
 	skb_walk_frags(skb, skb_iter) {
 		is_decrypted &= skb_iter->decrypted;
-- 
2.21.0

