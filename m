Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7B23B2160
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFWTqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWTqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:46:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE1BC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 12:43:57 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i4so1702686plt.12
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 12:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XB5JUou7Jni7zwQBTGW32WDxJ8f3yrretJGVyDCYjYE=;
        b=Y05WCe45J4sYTRS8EVxhN9yWHvGAsrturO0lgJ/Qc0HYcZfwkkq/+pEBnYLKIWZi48
         JiB6XBz/FbTFaI/0rg3C6SzQcSmMFeHlGni30J8BdGZIPrPJT7J+uURO7jr8hmPROksF
         Fe/v3F2KW2KTx64yWAJKAF7FSS7/bZ4dW0tAP3w9IBvqDerl9w4CpEVEkciXRusjVenY
         jm70xxyjQnPskcxTXfzWnHAP5IHE5YMVtJEQz2JfGPO6zMUc5xfPeemjS6VSJrEtQMss
         1goykr9zPe+syVPkWX7PVQyshKU1o6XRgSUox+ohs5TGcnJ5CdNHGqFtObj+Pe9iYsSv
         Wt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XB5JUou7Jni7zwQBTGW32WDxJ8f3yrretJGVyDCYjYE=;
        b=m1wEsEJz5hOnFCzMSWdJTyJpcypzCyN2JHfDffGCQgJ/v8OWTSXUnNwKH8qrXCHLOK
         5QS5/Y4HywhhaLJ5ze3urIPqjOKUoC13ml3HsBpnhWS3zW2oR/G4keBcQ689MxcyD4fR
         pFeJKfn4Ub/J0tsrM2W33zGa71GdNY2esbsVGXwNPRB47fmfjC6tIJ/+kMCC6rlNy4i7
         o0ZyhcuF9YAfWh2v1P6PK4o0gtWDJeSYKraVmJf7RNznNuKHUIqyvNVnXKt5v5CIQX8W
         6ee93XoYCALxF2BM99kws4s2esGKtp3EZxJSLayF0LZCPBMhA9BeoolWLgzESrI9LQmo
         tXig==
X-Gm-Message-State: AOAM531lPrOj7Sz7iKwB6ky0HBvAgWg/VGExIwVPpdPZYxBCOKM2isEt
        kGgb7Fve1/s1pM/BkvV0AGw=
X-Google-Smtp-Source: ABdhPJxur/JWKkFkFkvFSYUt5BkrE4uBq1S6yPH/Ly0r97WyqsXKzP+ilexiQXnVyu0KUl5WlBkzqg==
X-Received: by 2002:a17:902:3:b029:11f:e733:408f with SMTP id 3-20020a1709020003b029011fe733408fmr945235pla.21.1624477436861;
        Wed, 23 Jun 2021 12:43:56 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2053:62d5:263a:1851])
        by smtp.gmail.com with ESMTPSA id v14sm618205pgo.89.2021.06.23.12.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 12:43:56 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: [PATCH net] ipv6: fix out-of-bound access in ip6_parse_tlv()
Date:   Wed, 23 Jun 2021 12:43:53 -0700
Message-Id: <20210623194353.2021745-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

First problem is that optlen is fetched without checking
there is more than one byte to parse.

Fix this by taking care of IPV6_TLV_PAD1 before
fetching optlen (under appropriate sanity checks against len)

Second problem is that IPV6_TLV_PADN checks of zero
padding are performed before the check of remaining length.

Fixes: c1412fce7ecc ("net/ipv6/exthdrs.c: Strict PadN option checking")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tom Herbert <tom@herbertland.com>
---

Only compiled, I would appreciate a solid review of this patch before merging it, thanks !

 net/ipv6/exthdrs.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 6f7da8f3e2e5849f917853984c69bf02a0f1e27c..007959d4d3748f1e21f83946024a9967d08b25b6 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -135,18 +135,24 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 	len -= 2;
 
 	while (len > 0) {
-		int optlen = nh[off + 1] + 2;
-		int i;
+		int optlen, i;
 
-		switch (nh[off]) {
-		case IPV6_TLV_PAD1:
+		if (nh[off] == IPV6_TLV_PAD1) {
 			optlen = 1;
 			padlen++;
 			if (padlen > 7)
 				goto bad;
-			break;
+			off++;
+			len--;
+			continue;
+		}
+		if (len < 2)
+			goto bad;
+		optlen = nh[off + 1] + 2;
+		if (optlen > len)
+			goto bad;
 
-		case IPV6_TLV_PADN:
+		if (nh[off] == IPV6_TLV_PADN) {
 			/* RFC 2460 states that the purpose of PadN is
 			 * to align the containing header to multiples
 			 * of 8. 7 is therefore the highest valid value.
@@ -163,12 +169,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				if (nh[off + i] != 0)
 					goto bad;
 			}
-			break;
-
-		default: /* Other TLV code so scan list */
-			if (optlen > len)
-				goto bad;
-
+		} else {
 			tlv_count++;
 			if (tlv_count > max_count)
 				goto bad;
@@ -188,7 +189,6 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				return false;
 
 			padlen = 0;
-			break;
 		}
 		off += optlen;
 		len -= optlen;
-- 
2.32.0.288.g62a8d224e6-goog

