Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14ACB10B753
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfK0USP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:18:15 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35642 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfK0USO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:18:14 -0500
Received: by mail-lf1-f66.google.com with SMTP id r15so15265025lff.2
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTyVakY+FKaVZbH8OCz8X5WsDE7ShoVbvWz0mSzeKF4=;
        b=MMWL/BEGyswokmfED0cmNd/FTidFGtwRsbaX2ffc+Donchu7mlgjYG+VRFvZA+u4m+
         B5+4tpoByqBn98ZxelCctiafiC8s2uWn8l99dSNMOgrcAfFtPCcSPhCbRHJ5CLqThUu0
         x6Mui6W3Nmzs6OsiEJ9Dk2hshw638bIk8bNfyPKSDmpJraUjHfV26YNoGs5ed8FoLvJD
         b9MKzHsZOmk4YKMbaMJ6Jg+oSsE1T8/9g5nTxtxFNo1K+9NOm4Y8hKP2Py2b5VrK3vfe
         fLc2SdDZo3nsd1E0UjazFzRMus8++sPKTnVRWpmawW8tTFIJhRN3tZFrjUNMI42CNx3n
         YWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTyVakY+FKaVZbH8OCz8X5WsDE7ShoVbvWz0mSzeKF4=;
        b=rytiQMFua96bbKQYZcMLWMpSrRNrBqlVaobl5g8ljYGOLXjiR6fSjOd712tDRkWrwY
         CAWM8rdxlYa/15ic/oyL1Ki1Hyi0RWor7N/HYNARnzQqCXWXvYPTrU57HVB8oVllNry5
         Qmla2w7cyo7TtSMBGH+Tn5Yh6cgBsyq0KTPvMqrjxGow9GyNu0wGz7onQITzTyCEBPuN
         7ACPdg6QtxDTiLZHvbz1jQ/hPDqIQgzYbBiGV6TZjmeZQZ0M384zgy6ubR4U+iseF4EI
         vsg9BLFf56fWsfLWIWEz9GxiQMVIXunfO8ThmA44QkuSzlOSjfeynAplvaVUcpOTqe5o
         BxTw==
X-Gm-Message-State: APjAAAW+yNq7hEhaGu5iZviBMGJ1Y8beHi6GGeUPg/qPp6T4l2DNdRHs
        ONJrn9L8ukLcmNjtZoJde4QkSw==
X-Google-Smtp-Source: APXvYqxP6gqBUeFW8aUJlv+T3BenSxo2PjvIJwvWFo25CYL0gt/TPms/T2IJeWCD6bg6C2dCLYcEdw==
X-Received: by 2002:a19:4b48:: with SMTP id y69mr19812984lfa.140.1574885892624;
        Wed, 27 Nov 2019 12:18:12 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:18:12 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 6/8] net/tls: use sg_next() to walk sg entries
Date:   Wed, 27 Nov 2019 12:16:44 -0800
Message-Id: <20191127201646.25455-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Partially sent record cleanup path increments an SG entry
directly instead of using sg_next(). This should not be a
problem today, as encrypted messages should be always
allocated as arrays. But given this is a cleanup path it's
easy to miss was this ever to change. Use sg_next(), and
simplify the code.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tls.h  |  2 +-
 net/tls/tls_main.c | 13 ++-----------
 net/tls/tls_sw.c   |  3 ++-
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 9d32f7ce6b31..df630f5fc723 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -376,7 +376,7 @@ int tls_push_sg(struct sock *sk, struct tls_context *ctx,
 		int flags);
 int tls_push_partial_record(struct sock *sk, struct tls_context *ctx,
 			    int flags);
-bool tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
+void tls_free_partial_record(struct sock *sk, struct tls_context *ctx);
 
 static inline struct tls_msg *tls_msg(struct sk_buff *skb)
 {
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index bdca31ffe6da..b3da6c5ab999 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -209,24 +209,15 @@ int tls_push_partial_record(struct sock *sk, struct tls_context *ctx,
 	return tls_push_sg(sk, ctx, sg, offset, flags);
 }
 
-bool tls_free_partial_record(struct sock *sk, struct tls_context *ctx)
+void tls_free_partial_record(struct sock *sk, struct tls_context *ctx)
 {
 	struct scatterlist *sg;
 
-	sg = ctx->partially_sent_record;
-	if (!sg)
-		return false;
-
-	while (1) {
+	for (sg = ctx->partially_sent_record; sg; sg = sg_next(sg)) {
 		put_page(sg_page(sg));
 		sk_mem_uncharge(sk, sg->length);
-
-		if (sg_is_last(sg))
-			break;
-		sg++;
 	}
 	ctx->partially_sent_record = NULL;
-	return true;
 }
 
 static void tls_write_space(struct sock *sk)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 5989dfe5c443..2b2d0bae14a9 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2089,7 +2089,8 @@ void tls_sw_release_resources_tx(struct sock *sk)
 	/* Free up un-sent records in tx_list. First, free
 	 * the partially sent record if any at head of tx_list.
 	 */
-	if (tls_free_partial_record(sk, tls_ctx)) {
+	if (tls_ctx->partially_sent_record) {
+		tls_free_partial_record(sk, tls_ctx);
 		rec = list_first_entry(&ctx->tx_list,
 				       struct tls_rec, list);
 		list_del(&rec->list);
-- 
2.23.0

