Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AEF4100EF
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242904AbhIQVzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242303AbhIQVzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 17:55:21 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB83C061757
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 14:53:59 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id x2so11745999ila.11
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 14:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fWR0esOBVBV64rKinxIgFxJ4wKagR9YhECkqxWxa0Tw=;
        b=grs8gzHe5cek7z8ddLzkbZFT7aCOxQJODThfS5zh/JoI7HS4l1kwTTu7rDiPM2U1HS
         50yJla7O7avcIoYd7ryDuwWFWQotD8dMUhzDqWtwm0za2axPDLgCp3WOYQ7XsTUahFBA
         PmCw/f4CquFNZn9tPYHg/W1yqtFj2NG6e7mNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fWR0esOBVBV64rKinxIgFxJ4wKagR9YhECkqxWxa0Tw=;
        b=U/yWOFgeVl8XA6E7fskxyiMYbN9CvYzcmg+txlcoF9BltqWsj7fl/XMd5M+Fx0KXDL
         fWTyC/m3HFOHhNi2k99tIKlp6d3ERG7xn2Rhv4bzihwmURTg/GV5OoZ0SvwwrvGMM1jO
         tP/G5PkvpFL9b0aA7i0xn10TY0TspRuqhC+ZjIiNI3v6eyKZhqQ3fhYDZkOY73HLXWNZ
         8j2+oqR/NZWtLBxxLILc/4EvKVngnAdKCeWhe12j/ff3uoU25YpzDuO8SpzbJWfdgWgh
         eZ8oSrmCDJQNpe7YQ8nI94/QWtQ+cRJW5fn8+iw0z0ARb7ZOoKfkdczTJmzcoioeAtm+
         tUbg==
X-Gm-Message-State: AOAM533eAvQDyIdAFxSca+DNFAuFaML6j6DB3vhoZTE+xYjsGj5Yakz9
        ScWa5eaTNMIoZanrDTHOphwa4w==
X-Google-Smtp-Source: ABdhPJy2rJ1ey28tHL7q/gFDZW67ncHgR3kfTnhfa8+NV1dCDCgJWrmoAMq2uukUi+T5BT3LGK0oQg==
X-Received: by 2002:a92:cd09:: with SMTP id z9mr9916764iln.50.1631915638652;
        Fri, 17 Sep 2021 14:53:58 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b3sm4390167ile.37.2021.09.17.14.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 14:53:58 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: net: af_unix: Fix makefile to use TEST_GEN_PROGS
Date:   Fri, 17 Sep 2021 15:53:56 -0600
Message-Id: <20210917215356.33791-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Makefile uses TEST_PROGS instead of TEST_GEN_PROGS to define
executables. TEST_PROGS is for shell scripts that need to be
installed and run by the common lib.mk framework. The common
framework doesn't touch TEST_PROGS when it does build and clean.

As a result "make kselftest-clean" and "make clean" fail to remove
executables. Run and install work because the common framework runs
and installs TEST_PROGS. Build works because the Makefile defines
"all" rule which is unnecessary if TEST_GEN_PROGS is used.

Use TEST_GEN_PROGS so the common framework can handle build/run/
install/clean properly.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/net/af_unix/Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index cfc7f4f97fd1..df341648f818 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -1,5 +1,2 @@
-##TEST_GEN_FILES := test_unix_oob
-TEST_PROGS := test_unix_oob
+TEST_GEN_PROGS := test_unix_oob
 include ../../lib.mk
-
-all: $(TEST_PROGS)
-- 
2.30.2

