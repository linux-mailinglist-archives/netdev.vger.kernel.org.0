Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257E93AD3D9
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhFRUsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:48:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38651 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbhFRUsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 16:48:21 -0400
Received: from mail-oi1-f199.google.com ([209.85.167.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <seth.forshee@canonical.com>)
        id 1luLMt-0000Nh-Uk
        for netdev@vger.kernel.org; Fri, 18 Jun 2021 20:46:08 +0000
Received: by mail-oi1-f199.google.com with SMTP id f16-20020acacf100000b02901eed1481b82so5479033oig.20
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 13:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zVw79iU/33NoUWfSkfo4983/AAm4Rz8I7TNR8nI6E14=;
        b=MhZ80UdS/hIP7wiV4OhBlMBaWMiBBLIRIlcaz8sxMbluzuGotDaTGNlVTvUVa8WFr8
         sJKgGMQqnTJ6vIEKVlk9k/tL1bwXZOPWzeHzE/TMG33ZSGBGCt/oqhj8tkNVIzivbiBv
         Hc4KuFqQ7y15SpdfFXtQTi/w8Fe2DyqUG9Tx9xxgLAkGVUwY21p7xRxk6j3RRnaIf0dP
         kATqr4S2/Roxqslp3zKcMaZ3BuruWO1dAnHngcCHTLd8JIc+Qjjpgyn4SCdPsK4IftFw
         GVlFdTkckeEVKRvVs2nIBUpnx49GAepNbA5wFm4CIOLZ3q15XN+eXg96djaJ2P2oLfwV
         Ud7w==
X-Gm-Message-State: AOAM532s4RsKkd+oLMKkm2ai1vsXOfxSVxDLTSEqIrpX22wcwQn1D0MQ
        1z7mLNI7JsuhSB22pIt9fhfkJqSgM+Iht9sJLjqnITpfCddJ21D0NCEl6KebeeEAFoM8MWQoJ95
        mjsOEb1rs6m0z3A3BwWnqRELICE/UxM91Xw==
X-Received: by 2002:aca:c60c:: with SMTP id w12mr8616543oif.59.1624049134892;
        Fri, 18 Jun 2021 13:45:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmQG5KkxQKSJFYnEV9DPrJ3hC0tOa0J4wPnAYuEpy423vSkcokq3iPbIOf0H1fk4tvtjDwnQ==
X-Received: by 2002:aca:c60c:: with SMTP id w12mr8616531oif.59.1624049134667;
        Fri, 18 Jun 2021 13:45:34 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:ada:6eea:499c:8227])
        by smtp.gmail.com with ESMTPSA id f12sm2238728otc.79.2021.06.18.13.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 13:45:32 -0700 (PDT)
From:   Seth Forshee <seth.forshee@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        seth.forshee@canonical.com
Subject: [PATCH] selftests/tls: don't change cipher type in bidirectional test
Date:   Fri, 18 Jun 2021 15:45:32 -0500
Message-Id: <20210618204532.257773-1-seth.forshee@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bidirectional test attempts to change the cipher to
TLS_CIPHER_AES_GCM_128. The test fixture setup will have already set
the cipher to be tested, and if it was different than the one set by
the bidir test setsockopt() will fail on account of having different
ciphers for rx and tx, causing the test to fail.

Forcing the use of GCM when testing ChaCha doesn't make sense anyway,
so just use the cipher configured by the test fixture setup.

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 tools/testing/selftests/net/tls.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 426d07875a48..9f4c87f4ce1e 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -831,23 +831,6 @@ TEST_F(tls, bidir)
 	char const *test_str = "test_read";
 	int send_len = 10;
 	char buf[10];
-	int ret;
-
-	if (!self->notls) {
-		struct tls12_crypto_info_aes_gcm_128 tls12;
-
-		memset(&tls12, 0, sizeof(tls12));
-		tls12.info.version = variant->tls_version;
-		tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
-
-		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
-				 sizeof(tls12));
-		ASSERT_EQ(ret, 0);
-
-		ret = setsockopt(self->cfd, SOL_TLS, TLS_TX, &tls12,
-				 sizeof(tls12));
-		ASSERT_EQ(ret, 0);
-	}
 
 	ASSERT_EQ(strlen(test_str) + 1, send_len);
 
-- 
2.31.1

