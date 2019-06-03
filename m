Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2CD533B02
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFCWSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34036 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfFCWR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:17:59 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so6218972qtu.1
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vhZ951pGVFCn9/sgtoQHKccsOAI9h1D2KwRhjyVV/NM=;
        b=yvU0jx+EJJFviblu4xzXVXtONeN1y8e8jdKt8KCP9+QhVhg3jghmdefr4MM/dAvV1v
         H4voFHzKccKwCUn+Zig8ppO6UPD7sCiH6EskusZlDlpRJon13G5/S19twlHbEAzniIR8
         iK9hw+hgN1sXul0zFMFohmQ0OqX2IfNK/e/5cJVnMWPLA6xLybeBOBKyzTAnd2/G3uWH
         HttqlbtzKL1sEWJswkd+21Md0Ft7qEyoQBsFbJubICqTCw0YhBs1PPqua0jM0Q4Hvk+Q
         lyzJ4jYkzcEMlWwp5rcCk3Mq8VE9n1MyvR8BoWI7DINKXuIqLPnJyJLBO483K0oGFSRY
         tNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vhZ951pGVFCn9/sgtoQHKccsOAI9h1D2KwRhjyVV/NM=;
        b=EA3RwRYNDXXVgaRwGFJ2tZ619t0z3lSuy6f/6zCV59l15uSKSeu6J8jJ8UUQZg++8i
         6gaa82iOAzeFEFzbkKOSAyoPZcLAIJsG4JOd2dbfcYEaKY09uUoFWVcuH1Futxd1Br2S
         4CUIF9Gce5Bo9CCzbW3qr7Sdfv813ra24DZXDEN29+pwku1wvJ61XYYC6pvwRzx2I9SI
         JBUAjRh79tXO62nOAo11t1JlzWtCxzFGjOhL3LugotQxMDYDqWWa2QbfJLY0WbpJWo/J
         6yU0bEPKC2z4d2nHDyrRtM7niO8EaZ4fbWvw31KzJnjkDyOUx4Ja5hoL1m0C27D9RwHg
         m8bQ==
X-Gm-Message-State: APjAAAWbXHxltdlD6SmbR0a0QFQ4GFsiE990FEj5semckGuHMHXT3mQE
        lBJLFMIXEjWJf2B28QsjTfa4QA==
X-Google-Smtp-Source: APXvYqzg47XmmOuwPoruN0dSkScxQXv/j227U82ggTbXzlr1yq+xPi9kNRx8rWrhJ5HkR6cUFVYU7w==
X-Received: by 2002:a0c:96c4:: with SMTP id b4mr23299104qvd.2.1559600278117;
        Mon, 03 Jun 2019 15:17:58 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.17.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:17:57 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 2/8] net/tls: check return values from skb_copy_bits() and skb_store_bits()
Date:   Mon,  3 Jun 2019 15:16:59 -0700
Message-Id: <20190603221705.12602-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In light of recent bugs, we should make a better effort of
checking return values.  In theory none of the functions should
fail today.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b95c408fd771..dde6513628d2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -603,8 +603,10 @@ static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
 	sg_set_buf(&sg[0], buf,
 		   rxm->full_len + TLS_HEADER_SIZE +
 		   TLS_CIPHER_AES_GCM_128_IV_SIZE);
-	skb_copy_bits(skb, offset, buf,
-		      TLS_HEADER_SIZE + TLS_CIPHER_AES_GCM_128_IV_SIZE);
+	err = skb_copy_bits(skb, offset, buf,
+			    TLS_HEADER_SIZE + TLS_CIPHER_AES_GCM_128_IV_SIZE);
+	if (err)
+		goto free_buf;
 
 	/* We are interested only in the decrypted data not the auth */
 	err = decrypt_skb(sk, skb, sg);
@@ -618,8 +620,11 @@ static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
 	if (skb_pagelen(skb) > offset) {
 		copy = min_t(int, skb_pagelen(skb) - offset, data_len);
 
-		if (skb->decrypted)
-			skb_store_bits(skb, offset, buf, copy);
+		if (skb->decrypted) {
+			err = skb_store_bits(skb, offset, buf, copy);
+			if (err)
+				goto free_buf;
+		}
 
 		offset += copy;
 		buf += copy;
@@ -642,8 +647,11 @@ static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
 		copy = min_t(int, skb_iter->len - frag_pos,
 			     data_len + rxm->offset - offset);
 
-		if (skb_iter->decrypted)
-			skb_store_bits(skb_iter, frag_pos, buf, copy);
+		if (skb_iter->decrypted) {
+			err = skb_store_bits(skb_iter, frag_pos, buf, copy);
+			if (err)
+				goto free_buf;
+		}
 
 		offset += copy;
 		buf += copy;
-- 
2.21.0

