Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025D7102242
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKSKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:50:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38849 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfKSKuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:50:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so23236967wro.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 02:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VtahxqjVeuCdwoGzoPXc72omB/a3UxEWdQncKPHu5AQ=;
        b=iNW9Eky+z+ELXzIaMIpYMLxGObSuDpDFwwQrl0nWnobC71IOob/eltUGs1CUL/8iSa
         MPLCLKHtlof/6a+b0hCeLcaiqS3yez7DoTzCf5iv1DsHjb07PKw5goZvDfNvUUo+oGe+
         B5kmyJLqds0NCPoredHuTRWYq5h9FPE2GkFu2EWW7bvZMi3uCgKcLbrHmqTqiLEcCB4v
         Y5wtWuL3jMsy5YTpPGJR3tPX2+uuAKFqSNXX6cuIbXbMbhC1nyoeK02HJ7ybJPPhyLAc
         qrB0jk3gJM0m8JIEu2+Yu9Hfhi4nGNp3aBfqFS3G6XAU6tDMNQt6ts4DPQ0YDwZb+IwI
         ftKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VtahxqjVeuCdwoGzoPXc72omB/a3UxEWdQncKPHu5AQ=;
        b=ZjlW3j6EsMf6fFuxRDvac3ODTcIbOpOmuUj6pQvd++DMhXJbUuF2XH7EKI3KzoYwow
         ed15URsP1KbmdGK5B07HO87ulNMmYixBmEl419pnPKG2M0uyLCiNMukgdANWOTlPPC6C
         euv5dDz4UfZWl0KwroI6oCJa216IR26xFnRVtCI8kXu0YF/RwJatvsXyvXq9UYXoJNI/
         lFPmk/ctubjaDaiGPxqs9GPmb7SRn99Ju9casQW+6BeS12wMUhhOFnKNfwT0FqFX2AfO
         nufuwDEnOFerG2CdTVUMQeSFAlNlsl6xCcvCDhcAyAHainyXMKHOoifoNZtOo6sQu5dM
         zdLQ==
X-Gm-Message-State: APjAAAX7jGeZ5c0i9sAJTyucqqJS3pD3pUIst2Dn31EayaeoqtSbsWky
        2vr4Ki+DgGBpQxLlH2GtGzvNCw==
X-Google-Smtp-Source: APXvYqwsVb6LQAwZDbYFsQCXjKUiwldoMdtj1QrCtMI4ERl1Mqjmg/tSwHuMDU3NVeJ/IKBZueWglQ==
X-Received: by 2002:adf:e2cd:: with SMTP id d13mr23459204wrj.221.1574160617301;
        Tue, 19 Nov 2019 02:50:17 -0800 (PST)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g5sm2646708wma.43.2019.11.19.02.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 02:50:16 -0800 (PST)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next 1/2] selftests: bpftool: set EXIT trap after usage function
Date:   Tue, 19 Nov 2019 10:50:09 +0000
Message-Id: <20191119105010.19189-2-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119105010.19189-1-quentin.monnet@netronome.com>
References: <20191119105010.19189-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trap on EXIT is used to clean up any temporary directory left by the
build attempts. It is not needed when the user simply calls the script
with its --help option, and may not be needed either if we add checks
(e.g. on the availability of bpftool files) before the build attempts.

Let's move this trap and related variables lower down in the code, so
that we don't accidentally change the value returned from the script
on early exits at pre-checks.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../selftests/bpf/test_bpftool_build.sh       | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
index 4ba5a34bff56..1fc6f6247f9b 100755
--- a/tools/testing/selftests/bpf/test_bpftool_build.sh
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -1,18 +1,6 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 
-ERROR=0
-TMPDIR=
-
-# If one build fails, continue but return non-0 on exit.
-return_value() {
-	if [ -d "$TMPDIR" ] ; then
-		rm -rf -- $TMPDIR
-	fi
-	exit $ERROR
-}
-trap return_value EXIT
-
 case $1 in
 	-h|--help)
 		echo -e "$0 [-j <n>]"
@@ -20,7 +8,7 @@ case $1 in
 		echo -e ""
 		echo -e "\tOptions:"
 		echo -e "\t\t-j <n>:\tPass -j flag to 'make'."
-		exit
+		exit 0
 		;;
 esac
 
@@ -33,6 +21,18 @@ SCRIPT_REL_DIR=$(dirname $SCRIPT_REL_PATH)
 KDIR_ROOT_DIR=$(realpath $PWD/$SCRIPT_REL_DIR/../../../../)
 cd $KDIR_ROOT_DIR
 
+ERROR=0
+TMPDIR=
+
+# If one build fails, continue but return non-0 on exit.
+return_value() {
+	if [ -d "$TMPDIR" ] ; then
+		rm -rf -- $TMPDIR
+	fi
+	exit $ERROR
+}
+trap return_value EXIT
+
 check() {
 	local dir=$(realpath $1)
 
-- 
2.17.1

