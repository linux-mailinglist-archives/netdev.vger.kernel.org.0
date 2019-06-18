Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06EEE49D52
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfFRJc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:32:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36307 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729353AbfFRJcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:32:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id u8so2437292wmm.1
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 02:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uoXN0FMlnCUpKu8imJJI+ugif3yVx1vilVzoC6zQYtE=;
        b=dxRxqplD6Zfbb3Hp0XNyUCxyslkEl2gBsG8ZzNJl+E+Fy0rIZbK4Mpfwllp/cfqPD8
         P2soYlureqG3MP757/bHuyPVAnUlcfG09FdHa4XM5DeAJR//kGf4e+AnukNU7Rfx3nVG
         q1sa392gND3elQEVt7twNPpZZxdVA86wOB4NH3vjGP6+3UXBS0a9D4DBpf7J6EWaj/To
         4tNjZ5nJLlChKa05JX5O0I/2QJvlUMD0CuqQoUCDlCFjDQUJraZpITjJcW2b1+Nj3kDR
         ETzkrR2fQyOrR9lnvuP2cNLmMNib8yd3gWQnPOXB/YyksxXbRfjz1vbNnFO9T+2tOATU
         t1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uoXN0FMlnCUpKu8imJJI+ugif3yVx1vilVzoC6zQYtE=;
        b=SOW9mIxR/z4mWtB95WqdbLsR59BtpDntnRVfOS+7ONbNxhVAGTDet1qc1uIz6cevPt
         J2rIDFcagEU+avK492cVlqD3ZqTCMkY4S2G2dInq5n9x7nVrbTopai1//3ayTaV+Tnu3
         TAlCu1cDDZyV0eWFKN2b0BdqneDaxwxnK+Z86EgB6oXyzxQd7PQtciT8+w8zj/SJl8q3
         c1HI0ErLhoSPewEJsB7eZFs9WD9+Wpoixsmjgda+RtRj54hea5Ni2n6wAvtdALhDCZc+
         yxL56GFyR0q1KqF0dtXjpHH6+xukAVihKLVrU+Eo8LIAeiZK4xbYXpaYv15Xw/Z03Nuc
         QTaw==
X-Gm-Message-State: APjAAAWVCTfWldn8JYpptsvTTW2bPHRnWXo89yusGo+i7iWtEPaJhvHS
        /WtPD8yfs07oM4PNCDR6ywMeqJLCNelFNIJm
X-Google-Smtp-Source: APXvYqynweZQ417+bPZXKGYxSPB0gSxGojFa7Ep9w3PBtpqmepqATNENbwmZ/TT4f1MFsaRI9xbcyQ==
X-Received: by 2002:a1c:3942:: with SMTP id g63mr2375742wma.61.1560850342398;
        Tue, 18 Jun 2019 02:32:22 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:c97b:2293:609c:ae03])
        by smtp.gmail.com with ESMTPSA id y1sm1517104wma.32.2019.06.18.02.32.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:32:21 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH 2/2] net: fastopen: use endianness agnostic representation of the cookie
Date:   Tue, 18 Jun 2019 11:32:07 +0200
Message-Id: <20190618093207.13436-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use an explicit little endian representation of the fastopen
cookie, so that the value no longer depends on the endianness
of the system. This fixes a theoretical issue only, since
fastopen keys are unlikely to be shared across load balancing
server farms that are mixed in endiannes, but it might pop up
in validation/selftests as well, so let's just settle on little
endian across the board.

Note that this change only affects big endian systems.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/tcp.h     |  2 +-
 net/ipv4/tcp_fastopen.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 3d3659c638a6..f3a85a7fb4b1 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -58,7 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 
 /* TCP Fast Open Cookie as stored in memory */
 struct tcp_fastopen_cookie {
-	u64	val[DIV_ROUND_UP(TCP_FASTOPEN_COOKIE_MAX, sizeof(u64))];
+	__le64	val[DIV_ROUND_UP(TCP_FASTOPEN_COOKIE_MAX, sizeof(u64))];
 	s8	len;
 	bool	exp;	/* In RFC6994 experimental option format */
 };
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 61c15c3d3584..2704441a0bb0 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -123,10 +123,10 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 	if (req->rsk_ops->family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(syn);
 
-		foc->val[0] = siphash(&iph->saddr,
-				      sizeof(iph->saddr) +
-				      sizeof(iph->daddr),
-				      key);
+		foc->val[0] = cpu_to_le64(siphash(&iph->saddr,
+					  sizeof(iph->saddr) +
+					  sizeof(iph->daddr),
+					  key));
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
@@ -134,10 +134,10 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 	if (req->rsk_ops->family == AF_INET6) {
 		const struct ipv6hdr *ip6h = ipv6_hdr(syn);
 
-		foc->val[0] = siphash(&ip6h->saddr,
-				      sizeof(ip6h->saddr) +
-				      sizeof(ip6h->daddr),
-				      key);
+		foc->val[0] = cpu_to_le64(siphash(&ip6h->saddr,
+					  sizeof(ip6h->saddr) +
+					  sizeof(ip6h->daddr),
+					  key));
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
-- 
2.17.1

