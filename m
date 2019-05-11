Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76601A65A
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 04:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfEKCwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 22:52:53 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36927 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfEKCwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 22:52:53 -0400
Received: by mail-it1-f194.google.com with SMTP id l7so12311594ite.2
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 19:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1fNpqco5qTI/FVw/2N/OV6sdYiNRuMpuFae27tLYD8=;
        b=AsJhlTTxTVsHXRcV+TdHM1dqT6CDreRY5gyOr73MCbYVqnHrm9AQ3YBi3KpSl2YaBY
         AQA/RoOwihRXjLnMWyMT1lTIFCUMtWd/THzwzQ11ODv0V+hImkpFqMzlTyUA5vg4U8Lh
         iC7LdrFa9pBC97kV1H8nDMWfrZxoKKClWlX2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1fNpqco5qTI/FVw/2N/OV6sdYiNRuMpuFae27tLYD8=;
        b=H9qgbxWpRkjmzxSV06tLVpIrHj1l7F6g95wTrmJHfyWSwJsWBymrlSLigk8Kt7lyuL
         7KMYgPSG3svyBV+7wCmiL92v1isaHRww3jg8+Q0vQbjxEJ1jjTcFhvMX2qfF5uyjPyQE
         x5nb6NXor9316ycGzV0Ls8ft9L9xXXBV34W/JlUd01GNH6ydKdqwNI/dpGSKM9GDU81h
         UxcFeNj57wnZ+cIXvRP6kf2kNtBU7zuE29YT1zCxBniUZ5MdA4Rszx2T99r5rzKrcPDv
         7DmOlfoKE53vOs9Bqmp76Kossti6Pf0UCcvehAFZGmrBErs4FinaCO/Ll13YnWzu+KWQ
         uUIw==
X-Gm-Message-State: APjAAAXFaoN/DfRxNnf6PmyZUhuTBAkFfNhcDGZEakYnvCx1x4vm7Z2u
        goxgtECyOAc6E3HT8CDX6Y485w==
X-Google-Smtp-Source: APXvYqyMyX9jt4xcnd1qUvb3Gz1jooVogYkic/p578UGF9RMWCcUnZVoGP84Uj7fcMIrKG/QoqQHKg==
X-Received: by 2002:a24:5258:: with SMTP id d85mr10156123itb.124.1557543172404;
        Fri, 10 May 2019 19:52:52 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s69sm2962460ios.30.2019.05.10.19.52.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 19:52:51 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     shuah@kernel.org, alexei.starovoitov@gmail.com
Cc:     Shuah Khan <skhan@linuxfoundation.org>, daniel@iogearbox.net,
        davem@davemloft.net, torvalds@linux-foundation.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] selftests: fix bpf build/test workflow regression when KBUILD_OUTPUT is set
Date:   Fri, 10 May 2019 20:52:49 -0600
Message-Id: <20190511025249.32678-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 8ce72dc32578 ("selftests: fix headers_install circular dependency")
broke bpf build/test workflow. When KBUILD_OUTPUT is set, bpf objects end
up in KBUILD_OUTPUT build directory instead of in ../selftests/bpf.

The following bpf workflow breaks when it can't find the test_verifier:

cd tools/testing/selftests/bpf; make; ./test_verifier;

Fix it to set OUTPUT only when it is undefined in lib.mk. It didn't need
to be set in the first place.

Fixes: commit 8ce72dc32578 ("selftests: fix headers_install circular dependency")

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/lib.mk | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 098dd0065fb1..077337195783 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -3,15 +3,9 @@
 CC := $(CROSS_COMPILE)gcc
 
 ifeq (0,$(MAKELEVEL))
-    ifneq ($(O),)
-	OUTPUT := $(O)
-    else
-	ifneq ($(KBUILD_OUTPUT),)
-		OUTPUT := $(KBUILD_OUTPUT)
-	else
-		OUTPUT := $(shell pwd)
-		DEFAULT_INSTALL_HDR_PATH := 1
-	endif
+    ifeq ($(OUTPUT),)
+	OUTPUT := $(shell pwd)
+	DEFAULT_INSTALL_HDR_PATH := 1
     endif
 endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
-- 
2.17.1

