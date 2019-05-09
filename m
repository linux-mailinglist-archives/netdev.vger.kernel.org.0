Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C6B1959A
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEIXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:14:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39987 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfEIXOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:14:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id w20so2563417qka.7
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t9f3RnyeqgGYgCMSTk4BszCqgHVmpDgYZ8g4rlw8XyI=;
        b=us26jr3Sb+bLQLOtZCgOdjCrbVF+3YDz4OI4VRlQZu/0qBEiVVSEHqhw5vwOIJZNOE
         MoNeDfdToX2FxTeMN3xDEiC/v4nPbiddWRLQT47wufirjM3363E+4JDGx4Qn8tmHdHfJ
         VHngoLtoatM/5BF6woTmbYZR2qcooxJAVkXN9MVyEGuyD/mFDwLKnqRPWVFrygqmaCxl
         NvCF9GqJJ5hEOj5vqhZ1qZr18TEx8RtIVLqRN+mfu5E7qEZotNoUakz7QGGb1RVXQn3f
         xQC6m4/b9XtQxzj8qHeJXiZxVmsp00LNE+YbWaAcSGyXvb5xqfHhRI2RPCKHpAkyoKj+
         f8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t9f3RnyeqgGYgCMSTk4BszCqgHVmpDgYZ8g4rlw8XyI=;
        b=L45qay2gM4ey3het2wVPMZUiuLVcu+4lZAnf4d3NzIqJ56XkN0EfS5VbNqzYmO/zpC
         AsZYmbOz7JOETRgJc6q+xkeMv+ZqUMTioFLfXS+GDLNPKXSYiRd5HqU1OxYLxJ+6+AHY
         r11KAj1pGsIWjY9i6bPTwbuVw/6IPSOl7C8Fpepzu8EWSME2DlUzk0abKOXMuzysn8YL
         h6QUOdbOJXRiCAqsOCNLj05c5vGAVjeeug6UTo/L8Pwk/zGShJEKSPCRSsVQ8iRjsm7j
         rR13XwfNjP4IF6LYDguGBssOBhCeaKYa52SOwGabWMGWJKlRzxtioUnXtj+u5R/1UUwN
         TkpQ==
X-Gm-Message-State: APjAAAUIDcoFcBevssspAx7lu5xtxUVOTLN59nY8X37s0LVSf61ALC/n
        e8c5TBTZ7Ni6yt4/EbAt2UvtWA==
X-Google-Smtp-Source: APXvYqw+G64VMa8HnqeOttG9Tp+NZrv22rY9QIC/Io5XHhQ27EasurO+i2/+aGv6gt+c3etsxGnrFA==
X-Received: by 2002:a37:e507:: with SMTP id e7mr6070334qkg.322.1557443661135;
        Thu, 09 May 2019 16:14:21 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s42sm2036778qth.45.2019.05.09.16.14.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:14:20 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dave Watson <davejwatson@fb.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 2/2] net/tls: handle errors from padding_length()
Date:   Thu,  9 May 2019 16:14:07 -0700
Message-Id: <20190509231407.25685-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509231407.25685-1-jakub.kicinski@netronome.com>
References: <20190509231407.25685-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the time padding_length() is called the record header
is still part of the message.  If malicious TLS 1.3 peer
sends an all-zero record padding_length() will stop at
the record header, and return full length of the data
including the tail_size.

Subsequent subtraction of prot->overhead_size from rxm->full_len
will cause rxm->full_len to turn negative.  skb accessors,
however, will always catch resulting out-of-bounds operation,
so in practice this fix comes down to returning the correct
error code.  It also fixes a set but not used warning.

This code was added by commit 130b392c6cd6 ("net: tls: Add tls 1.3 support").

CC: Dave Watson <davejwatson@fb.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_sw.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c02293fb10e6..d93f83f77864 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -119,23 +119,25 @@ static int skb_nsg(struct sk_buff *skb, int offset, int len)
 }
 
 static int padding_length(struct tls_sw_context_rx *ctx,
-			  struct tls_context *tls_ctx, struct sk_buff *skb)
+			  struct tls_prot_info *prot, struct sk_buff *skb)
 {
 	struct strp_msg *rxm = strp_msg(skb);
 	int sub = 0;
 
 	/* Determine zero-padding length */
-	if (tls_ctx->prot_info.version == TLS_1_3_VERSION) {
+	if (prot->version == TLS_1_3_VERSION) {
 		char content_type = 0;
 		int err;
 		int back = 17;
 
 		while (content_type == 0) {
-			if (back > rxm->full_len)
+			if (back > rxm->full_len - prot->prepend_size)
 				return -EBADMSG;
 			err = skb_copy_bits(skb,
 					    rxm->offset + rxm->full_len - back,
 					    &content_type, 1);
+			if (err)
+				return err;
 			if (content_type)
 				break;
 			sub++;
@@ -170,9 +172,17 @@ static void tls_decrypt_done(struct crypto_async_request *req, int err)
 		tls_err_abort(skb->sk, err);
 	} else {
 		struct strp_msg *rxm = strp_msg(skb);
-		rxm->full_len -= padding_length(ctx, tls_ctx, skb);
-		rxm->offset += prot->prepend_size;
-		rxm->full_len -= prot->overhead_size;
+		int pad;
+
+		pad = padding_length(ctx, prot, skb);
+		if (pad < 0) {
+			ctx->async_wait.err = pad;
+			tls_err_abort(skb->sk, pad);
+		} else {
+			rxm->full_len -= pad;
+			rxm->offset += prot->prepend_size;
+			rxm->full_len -= prot->overhead_size;
+		}
 	}
 
 	/* After using skb->sk to propagate sk through crypto async callback
@@ -1478,7 +1488,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	int version = prot->version;
 	struct strp_msg *rxm = strp_msg(skb);
-	int err = 0;
+	int pad, err = 0;
 
 	if (!ctx->decrypted) {
 #ifdef CONFIG_TLS_DEVICE
@@ -1501,7 +1511,11 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 			*zc = false;
 		}
 
-		rxm->full_len -= padding_length(ctx, tls_ctx, skb);
+		pad = padding_length(ctx, prot, skb);
+		if (pad < 0)
+			return pad;
+
+		rxm->full_len -= pad;
 		rxm->offset += prot->prepend_size;
 		rxm->full_len -= prot->overhead_size;
 		tls_advance_record_sn(sk, &tls_ctx->rx, version);
-- 
2.21.0

