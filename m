Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE6E7E4D2
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389197AbfHAVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:36:25 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34568 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389188AbfHAVgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 17:36:24 -0400
Received: by mail-qt1-f193.google.com with SMTP id k10so2712936qtq.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 14:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zCBWA/OdVamrB+LPIVMZvoMTftr2ESairujJQvdHx3c=;
        b=h3dwg0wpnNAdKJZR7VoPuIdPQuDcKU9nodHGZhDD3wk0rZvAA90DXKiDFbe03S+kgX
         6qP4VzsDstngSUQUL71NNGBhAwVq7vO1KRoVn9h/z4ec3DamTTYi882cMsU1n9pQ2Ahe
         pypqsyre2ub0Rn4Oswymgi16F7xXgH3p4ZUDNqCqiZ4u1lJ4edt7o7bv0r/A2+DkPN18
         GdmFD+VFReW2iW3iiBHDHVug9A7XCuCtuZw6Nbo7Ufg4Ngc/uNAfCvL4AgyQqSTzi4Tc
         lQoi6OS07PdyYuQP6AhEeqVeJ+bnYjTZZxXqoFXI4Cu7AAxJD1onFYwQthcjfVA2OB8g
         9NyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zCBWA/OdVamrB+LPIVMZvoMTftr2ESairujJQvdHx3c=;
        b=Ixs0vuj0uJEwlEcNgBHjcOa9hs6B6j89QSbgU4PfGpV9Zfop7OLjG6XuWHT1Nl2IfI
         h7swV1F+9NAn3KZgJKLx4Y7RUYi12eEFrLJ2izCzmN4Ut04mHIqmOk0XDPj0tPfFwSai
         S+QGDU6c1Wzr++BVDfevoAv+F0rNC9kNE3/TUPcSJagRltjoGlOkuLSw7Z/5Xa6C7ZGJ
         mIAZh9CvvpiRVU4+faZPWTPFAw8HdnPxghqwwtIAUxvuyeCCFCDK3cAIGcJjrcJKUOnf
         e52ZvuDqH9JJCbGYver/HZWRD+4PRs5V4+oWb98BNtOrGxaa8bTocuLPpfBrRrcYnr/t
         HSGw==
X-Gm-Message-State: APjAAAVNUfVrAFcDdRAvTlF0WJ/jtm7pb6CiVh67UFvm1HKCrXcM1pOW
        QdviVXyndeTyQR4CD+AWolU5tw==
X-Google-Smtp-Source: APXvYqxixfRklkF5ScvCb6eFZI4f4LeeHNXr6M2xQ/h/M/E5A9XouIpUDOsaCKUQsSZpZTS1wy6elg==
X-Received: by 2002:a0c:8809:: with SMTP id 9mr95894946qvl.141.1564695382853;
        Thu, 01 Aug 2019 14:36:22 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j19sm28746216qtq.94.2019.08.01.14.36.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 14:36:22 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 2/2] selftests/tls: add a litmus test for the socket reuse through shutdown
Date:   Thu,  1 Aug 2019 14:36:02 -0700
Message-Id: <20190801213602.19634-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801213602.19634-1-jakub.kicinski@netronome.com>
References: <20190801213602.19634-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that shutdown never works, and at the same time document how
I tested to came to the conclusion that currently reuse is not possible.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/testing/selftests/net/tls.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index d995e6503b1a..4c285b6e1db8 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -984,6 +984,30 @@ TEST_F(tls, shutdown_unsent)
 	shutdown(self->cfd, SHUT_RDWR);
 }
 
+TEST_F(tls, shutdown_reuse)
+{
+	struct sockaddr_in addr;
+	int ret;
+
+	shutdown(self->fd, SHUT_RDWR);
+	shutdown(self->cfd, SHUT_RDWR);
+	close(self->cfd);
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = htonl(INADDR_ANY);
+	addr.sin_port = 0;
+
+	ret = bind(self->fd, &addr, sizeof(addr));
+	EXPECT_EQ(ret, 0);
+	ret = listen(self->fd, 10);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	ret = connect(self->fd, &addr, sizeof(addr));
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EISCONN);
+}
+
 TEST(non_established) {
 	struct tls12_crypto_info_aes_gcm_256 tls12;
 	struct sockaddr_in addr;
-- 
2.21.0

