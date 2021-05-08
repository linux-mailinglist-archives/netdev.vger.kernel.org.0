Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263D637702E
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 08:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhEHGvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 02:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhEHGvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 02:51:41 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1032EC061574;
        Fri,  7 May 2021 23:50:37 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id y124-20020a1c32820000b029010c93864955so8288024wmy.5;
        Fri, 07 May 2021 23:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+kPiQT9l5kLCQOFQafMyuYNpwEHfeW8NZGl6TxH6Z5c=;
        b=nJ6dixHMcb2iwrkr8u/Ijtre2V8ZdlfRCsm0NlfFaCovnOExXm4d5pqN0nnf8LzzMF
         i0mLlIzOoBFna6w0L+NHMqlpgBv0jijh6Y+6mGP8NDTARqoN5CbaY/1uUGTk1M4zk6m8
         r+lunBX8GqaAdMfvmkKSGVj0StcDoGzfFaeWNJO+mnMW3dSUoNSc0I2n+igQ8TRy1wVc
         FjakFTFmQJDHULhO3PluQfXDC7WhPwGyUT+cHKegY7L/PY3FoYjDp0rrn5EceiSLfR95
         gCXh/k7/FI4fFUyGJaGldOos7jGEs1VGgY/WoJLUGMOG/uuTT3K8onVuC1kwfjV41zcj
         J7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+kPiQT9l5kLCQOFQafMyuYNpwEHfeW8NZGl6TxH6Z5c=;
        b=AHifKO0K7GqBtYZQw6hlK34M3U5xLot3RyaK9H7mzh8AiCSJBIvLJlqWPelSWkRSOm
         0lxKXyTe0HqrvsJG/3RHhkMQY/mAp1JXIv4gZoIiLqOmSMJK1Z9QnNSDJ8KSg8w8rjsR
         SwlepYqutkeIUYlKDTkPmWivbPoab+9VZdSy0c4OP8Ua3XAV7ic/+iQAqre/CyZYPDij
         +aMx9GW7OTmH1d3Ugpj5waZFPSFFGsHvZ05iuZDgw0EA4W/HE66IUTDUo9I3mKKwOMjI
         ozn/bSrAd/AYgvCk0k8iwvS3a7HjQ263jU/mVd4iZE7D4MJ8XvqK7OrKgXQWoXlwqoyV
         w8gA==
X-Gm-Message-State: AOAM532e7stK9FeTjgZF/0vXf3hCANsDxOH/BOiMLdoQdSRQY78bLwoq
        9e3OKm+n5Gboi1CvOn4aI71+n/LBGomQTQ==
X-Google-Smtp-Source: ABdhPJxRze0MUTdHfEx1oHxxhD3kunauJXkvXFDXVxOHNb6Bm4bcWIoyKVYlaAq5ywplIzClqW6wPA==
X-Received: by 2002:a1c:dc41:: with SMTP id t62mr25999631wmg.14.1620456635463;
        Fri, 07 May 2021 23:50:35 -0700 (PDT)
Received: from t450s.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id t17sm11409266wrx.40.2021.05.07.23.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 23:50:34 -0700 (PDT)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     netdev@vger.kernel.org
Cc:     petr.vorel@gmail.com, dsahern@gmail.com, heiko.thiery@gmail.com,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
Subject: [PATCH iproute2-next v3] lib/fs: fix issue when {name,open}_to_handle_at() is not implemented
Date:   Sat,  8 May 2021 08:49:26 +0200
Message-Id: <20210508064925.8045-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit d5e6ee0dac64 the usage of functions name_to_handle_at() and
open_by_handle_at() are introduced. But these function are not available
e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
availability in the configure script and in case of absence do a direct
syscall.

Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
---
v3:
 - use correct syscall number (thanks to Petr Vorel)
 - add #include <sys/syscall.h> (thanks to Petr Vorel)
 - remove bogus parameters (thanks to Petr Vorel)
 - fix #ifdef (thanks to Petr Vorel)
 - added Fixes tag (thanks to David Ahern)
 - build test with buildroot 2020.08.3 using uclibc 1.0.34

v2:
 - small correction to subject
 - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
 - fix indentation in check function
 - removed empty lines (thanks to Petr Vorel)
 - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
 - check only for name_to_handle_at (thanks to Petr Vorel)

 configure | 28 ++++++++++++++++++++++++++++
 lib/fs.c  | 25 +++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/configure b/configure
index 2c363d3b..179eae08 100755
--- a/configure
+++ b/configure
@@ -202,6 +202,31 @@ EOF
     rm -f $TMPDIR/setnstest.c $TMPDIR/setnstest
 }
 
+check_name_to_handle_at()
+{
+    cat >$TMPDIR/name_to_handle_at_test.c <<EOF
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+int main(int argc, char **argv)
+{
+	struct file_handle *fhp;
+	int mount_id, flags, dirfd;
+	char *pathname;
+	name_to_handle_at(dirfd, pathname, fhp, &mount_id, flags);
+	return 0;
+}
+EOF
+    if $CC -I$INCLUDE -o $TMPDIR/name_to_handle_at_test $TMPDIR/name_to_handle_at_test.c >/dev/null 2>&1; then
+        echo "yes"
+        echo "CFLAGS += -DHAVE_HANDLE_AT" >>$CONFIG
+    else
+        echo "no"
+    fi
+    rm -f $TMPDIR/name_to_handle_at_test.c $TMPDIR/name_to_handle_at_test
+}
+
 check_ipset()
 {
     cat >$TMPDIR/ipsettest.c <<EOF
@@ -492,6 +517,9 @@ fi
 echo -n "libc has setns: "
 check_setns
 
+echo -n "libc has name_to_handle_at: "
+check_name_to_handle_at
+
 echo -n "SELinux support: "
 check_selinux
 
diff --git a/lib/fs.c b/lib/fs.c
index f161d888..05697a7e 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -25,11 +25,36 @@
 
 #include "utils.h"
 
+#ifndef HAVE_HANDLE_AT
+# include <sys/syscall.h>
+#endif
+
 #define CGROUP2_FS_NAME "cgroup2"
 
 /* if not already mounted cgroup2 is mounted here for iproute2's use */
 #define MNT_CGRP2_PATH  "/var/run/cgroup2"
 
+
+#ifndef HAVE_HANDLE_AT
+struct file_handle {
+	unsigned handle_bytes;
+	int handle_type;
+	unsigned char f_handle[];
+};
+
+static int name_to_handle_at(int dirfd, const char *pathname,
+	struct file_handle *handle, int *mount_id, int flags)
+{
+	return syscall(__NR_name_to_handle_at, dirfd, pathname, handle,
+	               mount_id, flags);
+}
+
+static int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
+{
+	return syscall(__NR_open_by_handle_at, mount_fd, handle, flags);
+}
+#endif
+
 /* return mount path of first occurrence of given fstype */
 static char *find_fs_mount(const char *fs_to_find)
 {
-- 
2.20.1

