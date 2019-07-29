Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE33D79C9A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfG2XIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:08:34 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40058 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfG2XId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 19:08:33 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so61170127qtn.7
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 16:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lfHDVdso4ezkVrhq1PLJnFarrTLzVdQsKbY5P200dGw=;
        b=W9SoEoGCD3ro9KH3A4X+nb83pGtCeFhjZZDLe9s4xXQSzfDf7BfBhbadhHgtGXHRh7
         C5XlIY4OEKHdJvbzJhR5XOaQkngVYIqM7LmQDpWBP7hokS4PJ1Q3aR/hXp3854Qp+Eh2
         lS8NMtD/37JIdnRnimklZD/yxR/BjPvix8AcWt/hWBFBVSCFozcNA40ayqxZfHgDZCE9
         rFSqcd1ZQyAYSm6UO65KQp//IjT490S/RX64L07mGZyed/L7ZNCGmjGDo5+8Wh2h6kCH
         WaYH3v7UKT+QToP6p2XhRExBYe3NeT9e+7kAajhddsJtngpYahW/xJkCjn891umUgway
         g0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lfHDVdso4ezkVrhq1PLJnFarrTLzVdQsKbY5P200dGw=;
        b=a3DQeUq4VMA9EQb9oINJCsc2cqrJfO+Jm+j8Sq/N/7qZDUiTtismsTUFq1cVPY6KF0
         54lvu0ZDLQusx4GQGflI5ZnhKFtFl7IcV6cnJceh1ZDpjKTcAGL2m9IM5Ov8hC9M6FfS
         mMCe5jaT6yheRmr9NQ83qWLpicM+nC8ghuroSgDmFh5uA4YLO9pZE4G99f/LrlxTsnS/
         +5HD5KNlKs8o+YOpyFdhaqWsZ69u7kTQ8AWmT1w27EOKxSjcmC4IGE516qe6jgSI7wQZ
         64dXlU/o0hI5ENrnUciyQvzkI5jyxV5r0VEmcJW90Mh95eb+0VkLRnjuOPZ6WNeT11/k
         ASMw==
X-Gm-Message-State: APjAAAVXZ6unT+evl9NRM2gs4WC+A/sWA3m4vB0lYKMt2FFocBWiJrsC
        Ft/QSC8+NUeg4FSsg5uhYyf9sQ==
X-Google-Smtp-Source: APXvYqyeWojAbqmZbGQNqT2N16XTecNOMi9dha9dSD4X8mmIhSR0rZOy48aybnSFEYlHQdxeU1RtTw==
X-Received: by 2002:aed:2dc7:: with SMTP id i65mr60551185qtd.365.1564441713074;
        Mon, 29 Jul 2019 16:08:33 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p32sm31933448qtb.67.2019.07.29.16.08.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 16:08:32 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH net] selftests/tls: fix TLS tests with CONFIG_TLS=n
Date:   Mon, 29 Jul 2019 16:08:03 -0700
Message-Id: <20190729230803.10781-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build bot reports some recent TLS tests are failing
with CONFIG_TLS=n. Correct the expected return code
and skip TLS installation if not supported.

Tested with CONFIG_TLS=n and CONFIG_TLS=m.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: cf32526c8842 ("selftests/tls: add a test for ULP but no keys")
Fixes: 65d41fb317c6 ("selftests/tls: add a bidirectional test")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/testing/selftests/net/tls.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 630c5b884d43..d995e6503b1a 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -69,7 +69,7 @@ FIXTURE_SETUP(tls_basic)
 
 	ret = setsockopt(self->fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
 	if (ret != 0) {
-		ASSERT_EQ(errno, ENOTSUPP);
+		ASSERT_EQ(errno, ENOENT);
 		self->notls = true;
 		printf("Failure setting TCP_ULP, testing without tls\n");
 		return;
@@ -696,21 +696,26 @@ TEST_F(tls, recv_lowat)
 
 TEST_F(tls, bidir)
 {
-	struct tls12_crypto_info_aes_gcm_128 tls12;
 	char const *test_str = "test_read";
 	int send_len = 10;
 	char buf[10];
 	int ret;
 
-	memset(&tls12, 0, sizeof(tls12));
-	tls12.info.version = TLS_1_3_VERSION;
-	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	if (!self->notls) {
+		struct tls12_crypto_info_aes_gcm_128 tls12;
 
-	ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12, sizeof(tls12));
-	ASSERT_EQ(ret, 0);
+		memset(&tls12, 0, sizeof(tls12));
+		tls12.info.version = TLS_1_3_VERSION;
+		tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
 
-	ret = setsockopt(self->cfd, SOL_TLS, TLS_TX, &tls12, sizeof(tls12));
-	ASSERT_EQ(ret, 0);
+		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
+				 sizeof(tls12));
+		ASSERT_EQ(ret, 0);
+
+		ret = setsockopt(self->cfd, SOL_TLS, TLS_TX, &tls12,
+				 sizeof(tls12));
+		ASSERT_EQ(ret, 0);
+	}
 
 	ASSERT_EQ(strlen(test_str) + 1, send_len);
 
-- 
2.21.0

