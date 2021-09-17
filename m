Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26BF40FFD2
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbhIQT1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243124AbhIQT1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 15:27:39 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E94C061764
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 12:26:17 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h20so11366222ilj.13
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 12:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LfjPbohhavkhWKwUH/1kohR8OTnMGA2qFf1xFiq2UHI=;
        b=Lo+woY7Spj8UgYNNeMHQdnMWU2klrZ/GBMQ5e6FdAoGYqsYn5+G5X8wBnUoZFSsJEe
         poHOvO/0mVPmln7opKC0a5Wib3EmkEzGmvUPq+Rb/RqI9chpE4ieOOAxd5r73EHJ/OMl
         PQntOfNV9bLZZyW2qHGIH98GfWG8TXul36wUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LfjPbohhavkhWKwUH/1kohR8OTnMGA2qFf1xFiq2UHI=;
        b=iQ+q8nBpKBRMZxS5lbS+oGrBhy93X8LzNS0e4t0zRmusgDFMXLxRPJLM/RzkbTIYWy
         wnXEEkoaHIo0VFrSKSZeIqDqwnyZ6gNBC9xHqjOZFKQGhBovTLWDySQ1sNZ+FIZowMaK
         gq/Ay78wYyL+X+VXm/kQjDo003ZqQO3W8VdmuSlN0KdkTQ32xClwdRLOSy9iji9kCLk9
         zH0hyrHVcuB2tT+zOa1rD9sdIptNALNwpKgXQSE0sMtrljBM6XXE57t6O3r6QGlwyJ50
         ibz/3WaF4IYfStokyLwg1qkTkaTnD2ZhkZrJUypgUYP4Opr2cRQkrGnzeVv4y2RKTmCX
         qg1A==
X-Gm-Message-State: AOAM5321O6wGc3MGkoY45IQ+hTV4kK3PKPhgNa3wbagNpuTmQQ5OYtOV
        Ugue874FZ+RBqxoAKKkXLbnTxw==
X-Google-Smtp-Source: ABdhPJyM9NIWQgoA1uI3YhwlV9QCsoV76t9AMOguXV/oSCSoFT/5S3blhepGLBj6aij3GGKOp05Z5A==
X-Received: by 2002:a92:c145:: with SMTP id b5mr8896077ilh.203.1631906776241;
        Fri, 17 Sep 2021 12:26:16 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 9sm4049208ily.9.2021.09.17.12.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 12:26:15 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: net: af_unix: Fix incorrect args in test result msg
Date:   Fri, 17 Sep 2021 13:26:14 -0600
Message-Id: <20210917192614.24862-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the args to fprintf(). Splitting the message ends up passing
incorrect arg for "sigurg %d" and an extra arg overall. The test
result message ends up incorrect.

test_unix_oob.c: In function ‘main’:
test_unix_oob.c:274:43: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘char *’ [-Wformat=]
  274 |   fprintf(stderr, "Test 3 failed, sigurg %d len %d OOB %c ",
      |                                          ~^
      |                                           |
      |                                           int
      |                                          %s
  275 |   "atmark %d\n", signal_recvd, len, oob, atmark);
      |   ~~~~~~~~~~~~~
      |   |
      |   char *
test_unix_oob.c:274:19: warning: too many arguments for format [-Wformat-extra-args]
  274 |   fprintf(stderr, "Test 3 failed, sigurg %d len %d OOB %c ",

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/net/af_unix/test_unix_oob.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
index 0f3e3763f4f8..3dece8b29253 100644
--- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
+++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
@@ -271,8 +271,9 @@ main(int argc, char **argv)
 	read_oob(pfd, &oob);
 
 	if (!signal_recvd || len != 127 || oob != '%' || atmark != 1) {
-		fprintf(stderr, "Test 3 failed, sigurg %d len %d OOB %c ",
-		"atmark %d\n", signal_recvd, len, oob, atmark);
+		fprintf(stderr,
+			"Test 3 failed, sigurg %d len %d OOB %c atmark %d\n",
+			signal_recvd, len, oob, atmark);
 		die(1);
 	}
 
-- 
2.30.2

