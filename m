Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0632C1044
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389955AbgKWQZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730953AbgKWQZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 11:25:13 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB74C0613CF;
        Mon, 23 Nov 2020 08:25:12 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id u184so2890269qkf.3;
        Mon, 23 Nov 2020 08:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26qh6i2eGfOcoKG6E7lebiENkOUg1hdH6kx3SGNVLBQ=;
        b=rHbH5xWryWRCnHL3Mk5fHCL95ADMqjjFePpvneGnOrBtjXfxM4DrtwavS3eOTJX+Ul
         zXtZ7JXu11vNMMSUvoNVT8OpVX/MsOyaxu+K64i4Sj+QDi13XhxfvA8v8mUG23sJSemY
         BhS/Ad04IzG8I2B/I5IPEpaAmLR9rt7TpSr6T9Y5xbpxkYLK1gLrLZtnBaTd8Rc6Z7Ay
         eRG+77Ymj+Sm+BKyymIL+22968m5H9tLqCzcZ3PTZm3RIqLeiM+7Yn5FgNKRzndHjwJk
         4SoET71jI/79Okcc13+r1868zEy37zQN5h/U5uWbAOvksVJLJ/79BIgmQvYihtL5sJgo
         h2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26qh6i2eGfOcoKG6E7lebiENkOUg1hdH6kx3SGNVLBQ=;
        b=XIzjI9tGBSlFCcW1tI8/GokAkSu2leMhsKRoClK3WicyiS5yIR1GSbCilS+Rt7L+ad
         hHurS++j8xdZ5bbOorOB/CtP3NVGDS37CjcNN3KaQ8fiqVH02NIiHRD1GaKNR2fPlNik
         0IQ17v/ju4bAhuo6QC+liGqdRm5n6YZr5fHLojw9hwtK72NUJ665bOSc/4wsRjhqS8je
         f2hzW4Z1oHo6+2D9a+w2SF1FqZU9lDMZ+btTOPTTAOrp3eHenwSzjqQB52QuXDNDLOpf
         4fj27hhMYYzu7yDg3pNyEASHCr3u16D4fR7wNxu/3vEYdVUKOQpuxp7eEFvU49rK8PA9
         SlAQ==
X-Gm-Message-State: AOAM531o7xM+/T5YUJUeJNaGtiyozKyrfAc+afIPWFsZTz4vMjMezgFW
        cRxESYyBIQ/uNFLsTUDF7mfGbnmZow8=
X-Google-Smtp-Source: ABdhPJxPH05YkSZ0JDhnggfenKDQWL1+lUPiQM4PFkiz4T5bLo1oSB4ETFwhMoN5058nDtz3p2aM5Q==
X-Received: by 2002:ae9:e719:: with SMTP id m25mr193611qka.139.1606148711576;
        Mon, 23 Nov 2020 08:25:11 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id o187sm10109187qkb.120.2020.11.23.08.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 08:25:10 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     linux-kselftest@vger.kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, acardace@redhat.com,
        shuah@kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH] tools/testing: add kselftest shell helper library
Date:   Mon, 23 Nov 2020 11:25:08 -0500
Message-Id: <20201123162508.585279-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Kselftest expects processes to signal pass/fail/skip through exitcode.

C programs can include kselftest.h for readable definitions.

Add analogous kselftest.sh for shell tests. Extract the existing
definitions from udpgso_bench.sh.

Tested: make TARGETS=net kselftest
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20201113231655.139948-4-acardace@redhat.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

applies cleanly to netnext (f9e425e99b07) and kselftest (v5.10-rc1)
---
 tools/testing/selftests/kselftest.sh        | 52 +++++++++++++++++++++
 tools/testing/selftests/net/udpgso_bench.sh | 42 +----------------
 2 files changed, 53 insertions(+), 41 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest.sh

diff --git a/tools/testing/selftests/kselftest.sh b/tools/testing/selftests/kselftest.sh
new file mode 100644
index 000000000000..c5a1cff57402
--- /dev/null
+++ b/tools/testing/selftests/kselftest.sh
@@ -0,0 +1,52 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# kselftest shell test support library
+#
+# - Define pass/fail/skip exitcodes
+# - Multiprocess support: aggregate child process results
+
+readonly KSFT_PASS=0
+readonly KSFT_FAIL=1
+readonly KSFT_SKIP=4
+
+readonly GREEN='\033[0;92m'
+readonly YELLOW='\033[0;33m'
+readonly RED='\033[0;31m'
+readonly NC='\033[0m' # No Color
+
+num_pass=0
+num_err=0
+num_skip=0
+
+# Test child process exit code, add to aggregates.
+kselftest_test_exitcode() {
+	local -r exitcode=$1
+
+	if [[ ${exitcode} -eq ${KSFT_PASS} ]]; then
+		num_pass=$(( $num_pass + 1 ))
+	elif [[ ${exitcode} -eq ${KSFT_SKIP} ]]; then
+		num_skip=$(( $num_skip + 1 ))
+	else
+		num_err=$(( $num_err + 1 ))
+	fi
+}
+
+# Exit from main process.
+kselftest_exit() {
+	echo -e "$(basename $0): PASS=${num_pass} SKIP=${num_skip} FAIL=${num_err}"
+
+	if [[ $num_err -ne 0 ]]; then
+		echo -e "$(basename $0): ${RED}FAIL${NC}"
+		exit ${KSFT_FAIL}
+	fi
+
+	if [[ $num_skip -ne 0 ]]; then
+		echo -e "$(basename $0): ${YELLOW}SKIP${NC}"
+		exit ${KSFT_SKIP}
+	fi
+
+	echo -e "$(basename $0): ${GREEN}PASS${NC}"
+	exit ${KSFT_PASS}
+}
+
diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
index 80b5d352702e..c1f9affe6cf0 100755
--- a/tools/testing/selftests/net/udpgso_bench.sh
+++ b/tools/testing/selftests/net/udpgso_bench.sh
@@ -3,47 +3,7 @@
 #
 # Run a series of udpgso benchmarks
 
-readonly GREEN='\033[0;92m'
-readonly YELLOW='\033[0;33m'
-readonly RED='\033[0;31m'
-readonly NC='\033[0m' # No Color
-
-readonly KSFT_PASS=0
-readonly KSFT_FAIL=1
-readonly KSFT_SKIP=4
-
-num_pass=0
-num_err=0
-num_skip=0
-
-kselftest_test_exitcode() {
-	local -r exitcode=$1
-
-	if [[ ${exitcode} -eq ${KSFT_PASS} ]]; then
-		num_pass=$(( $num_pass + 1 ))
-	elif [[ ${exitcode} -eq ${KSFT_SKIP} ]]; then
-		num_skip=$(( $num_skip + 1 ))
-	else
-		num_err=$(( $num_err + 1 ))
-	fi
-}
-
-kselftest_exit() {
-	echo -e "$(basename $0): PASS=${num_pass} SKIP=${num_skip} FAIL=${num_err}"
-
-	if [[ $num_err -ne 0 ]]; then
-		echo -e "$(basename $0): ${RED}FAIL${NC}"
-		exit ${KSFT_FAIL}
-	fi
-
-	if [[ $num_skip -ne 0 ]]; then
-		echo -e "$(basename $0): ${YELLOW}SKIP${NC}"
-		exit ${KSFT_SKIP}
-	fi
-
-	echo -e "$(basename $0): ${GREEN}PASS${NC}"
-	exit ${KSFT_PASS}
-}
+source "$(dirname $0)/../kselftest.sh"
 
 wake_children() {
 	local -r jobs="$(jobs -p)"
-- 
2.29.2.454.gaff20da3a2-goog

