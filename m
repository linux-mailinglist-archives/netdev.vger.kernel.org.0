Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6940E45D128
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346272AbhKXXaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346033AbhKXXaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 293D8610A5;
        Wed, 24 Nov 2021 23:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796411;
        bh=7aFgvsgPV5PKcLPInFkaBR9whvMDzZAdOVGbseuKFxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4UnKsllsKxxE4CCjTZ25/hkzL0BXtkgKrz3KrEaM42dL3PKB5RAU1wEi1ItO7hs2
         +yfNC8NeMrG2XWcp60/0B9XsqGJYV8dSMsIQUfddpIAAsgWYTfAC0mVHIbaEkEq3Ai
         YoMgYRukgiF9hxpAywGl1rrAQM1chpB1J0TI6sY4Y59WSJBAN7iDg3tqtnQ7sbEZZo
         sYD4Ss2rq48ky1trR0NWmIKVwwaa8vCvdCRqNMxFwjupmkdbPP9RaizspHSq+Yxeyx
         +gUFwiqf+k2uvwSTCV1sfvVqN9ZdnB6uQh7HzPJeSjGeYu36hOoPd8VTOnlpveTxDt
         8a/k74wVbUObg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 4/9] tls: splice_read: fix record type check
Date:   Wed, 24 Nov 2021 15:25:52 -0800
Message-Id: <20211124232557.2039757-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't support splicing control records. TLS 1.3 changes moved
the record type check into the decrypt if(). The skb may already
be decrypted and still be an alert.

Note that decrypt_skb_update() is idempotent and updates ctx->decrypted
so the if() is pointless.

Reorder the check for decryption errors with the content type check
while touching them. This part is not really a bug, because if
decryption failed in TLS 1.3 content type will be DATA, and for
TLS 1.2 it will be correct. Nevertheless its strange to touch output
before checking if the function has failed.

Fixes: fedf201e1296 ("net: tls: Refactor control message handling on recv")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d81564078557..2f11f1db917a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2018,21 +2018,18 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (!skb)
 		goto splice_read_end;
 
-	if (!ctx->decrypted) {
-		err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
-
-		/* splice does not support reading control messages */
-		if (ctx->control != TLS_RECORD_TYPE_DATA) {
-			err = -EINVAL;
-			goto splice_read_end;
-		}
+	err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
+	if (err < 0) {
+		tls_err_abort(sk, -EBADMSG);
+		goto splice_read_end;
+	}
 
-		if (err < 0) {
-			tls_err_abort(sk, -EBADMSG);
-			goto splice_read_end;
-		}
-		ctx->decrypted = 1;
+	/* splice does not support reading control messages */
+	if (ctx->control != TLS_RECORD_TYPE_DATA) {
+		err = -EINVAL;
+		goto splice_read_end;
 	}
+
 	rxm = strp_msg(skb);
 
 	chunk = min_t(unsigned int, rxm->full_len, len);
-- 
2.31.1

