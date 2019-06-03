Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3659D33B08
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfFCWSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45669 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfFCWSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:18:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id j19so7730255qtr.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vs2kMMYqpyXH/imkrYG9inZHZITKvJLfjo8bIu/5Lro=;
        b=NAw3y2zM4JE3RajAlGIhsHd8hayo6yJXMa1eniFUySrnAmAe4FMM8aS53evzMxXUbT
         UGZDJrUCDiVGV9DCDhgxaAtuzdMBxaCcdn1QQME8ylWgew4c/kgPGnWQ5K2zzlGgn8aa
         iAIM0zO6lAE02eLBVJAUBg8N5K3CxitaiZRKu6q7OBV4IvL3Ctt4hBgICwSSZ+5JSUJs
         EhxrDrOfCXOzNDkneujXsttD5EZTe3ciPm4C7ABgrAGyhMOVEkeU0pRltXRui0VuAalQ
         dbW2pbwVzp8jL8Lj0RgfPfJmep1+05HFD+bgqN24FlxdOmotL3JYILyYiQM8Heu7nFYd
         Nh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vs2kMMYqpyXH/imkrYG9inZHZITKvJLfjo8bIu/5Lro=;
        b=D+/4rFdcHhW7/v9tzqfOzQXvlenAzFebX/9P4kc9XquzqCNvSXP88v4ET96eLDtepE
         8JEjbMDsVY2m8ZJeiaX4VcrCCNB/MhcUQY4827TKd3JCH3iNqiK+mXm5/RprHJ5Vgi4P
         5iB42PfCitci2vmN/v3ploLJ6vCkhMurrErNDcx3zETA66Poj+nQldAz9g9OlJ5GQyuI
         JILIpaToZFk2f54N3lrUibLgaQJ+iYnoVJYn/SirJEJKt+M9Upx6WwCxlIVlnFpUQazO
         yPn23RTPRuC37hzWhRdrCCEUbHcQMRN/1GkyEdGSnRSXTa8f7eDoqjI8tNUoJDmKcS4L
         l9Og==
X-Gm-Message-State: APjAAAXLxMoH9wSehAH8xX/C7pLGBvTLpL7ZytdD2gW0k0XCrsl2Wxrq
        5AtdBOghLkSWf6kMNYWhjHkYSw==
X-Google-Smtp-Source: APXvYqxEuciYFkfxH2CYDwMzGG2+gN4eB2PvO6trFwpQKE0928M6DUAPGaFNT+zWovkk1bZm5GUxpQ==
X-Received: by 2002:ac8:38c5:: with SMTP id g5mr25731522qtc.299.1559600288021;
        Mon, 03 Jun 2019 15:18:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.18.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:18:07 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 8/8] net/tls: don't pass version to tls_advance_record_sn()
Date:   Mon,  3 Jun 2019 15:17:05 -0700
Message-Id: <20190603221705.12602-9-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers pass prot->version as the last parameter
of tls_advance_record_sn(), yet tls_advance_record_sn()
itself needs a pointer to prot.  Pass prot from callers.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h    | 10 +++-------
 net/tls/tls_device.c |  2 +-
 net/tls/tls_sw.c     |  9 ++++-----
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index a463a6074e5d..0a0072636009 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -446,19 +446,15 @@ static inline struct tls_context *tls_get_ctx(const struct sock *sk)
 }
 
 static inline void tls_advance_record_sn(struct sock *sk,
-					 struct cipher_context *ctx,
-					 int version)
+					 struct tls_prot_info *prot,
+					 struct cipher_context *ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
-
 	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
 		tls_err_abort(sk, EBADMSG);
 
-	if (version != TLS_1_3_VERSION) {
+	if (prot->version != TLS_1_3_VERSION)
 		tls_bigint_increment(ctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 				     prot->iv_size);
-	}
 }
 
 static inline void tls_fill_prepend(struct tls_context *ctx,
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 8ffc8f95f55f..51e556e79371 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -264,7 +264,7 @@ static int tls_push_record(struct sock *sk,
 	list_add_tail(&record->list, &offload_ctx->records_list);
 	spin_unlock_irq(&offload_ctx->lock);
 	offload_ctx->open_record = NULL;
-	tls_advance_record_sn(sk, &ctx->tx, prot->version);
+	tls_advance_record_sn(sk, prot, &ctx->tx);
 
 	for (i = 0; i < record->num_frags; i++) {
 		frag = &record->frags[i];
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f833407c789f..bef71e54fad0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -534,7 +534,7 @@ static int tls_do_encryption(struct sock *sk,
 
 	/* Unhook the record from context if encryption is not failure */
 	ctx->open_rec = NULL;
-	tls_advance_record_sn(sk, &tls_ctx->tx, prot->version);
+	tls_advance_record_sn(sk, prot, &tls_ctx->tx);
 	return rc;
 }
 
@@ -1486,7 +1486,6 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
-	int version = prot->version;
 	struct strp_msg *rxm = strp_msg(skb);
 	int pad, err = 0;
 
@@ -1504,8 +1503,8 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 					       async);
 			if (err < 0) {
 				if (err == -EINPROGRESS)
-					tls_advance_record_sn(sk, &tls_ctx->rx,
-							      version);
+					tls_advance_record_sn(sk, prot,
+							      &tls_ctx->rx);
 
 				return err;
 			}
@@ -1520,7 +1519,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		rxm->full_len -= pad;
 		rxm->offset += prot->prepend_size;
 		rxm->full_len -= prot->overhead_size;
-		tls_advance_record_sn(sk, &tls_ctx->rx, version);
+		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 		ctx->decrypted = true;
 		ctx->saved_data_ready(sk);
 	} else {
-- 
2.21.0

