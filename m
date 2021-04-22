Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CA5367CD0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbhDVIsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbhDVIsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 04:48:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1617FC06174A;
        Thu, 22 Apr 2021 01:47:30 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s7so43850429wru.6;
        Thu, 22 Apr 2021 01:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lR3tEJkc0UfX+rxeKczp/hoK1T+iX+xo4rtGRKTZLtc=;
        b=Fpfx6yCuo2IVunfhJrPBTeRrVDVlIPPskGp8xhklUUnsPp+F8+U5URXmI91VZB3C+v
         3e9kYzhPE5BPLWXLmsH5fpR2ze9Xze+ouvGO+lT/cuR5WHOGhFm9hhlR4fRrasGmqKN5
         Cns/ACg0NTfqejj40M+VsQguSf/hiW7MIycqUpiWHi4R2NuiHbMUcz4kBJf9mdGVfbAU
         PA0NcqZ/E4jb57glx9D+U3X8OXuj3DcoSLDxQWulRXWeHQKhqQFlwNA6Q7rWOd7+3RbH
         1KbIaJgAzeKpB5LsB7l3pFH0qqRatf8Sof7X/cLiuGZ+uG+TZ9IPbZLtAmeUE3JDDIzc
         3L6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lR3tEJkc0UfX+rxeKczp/hoK1T+iX+xo4rtGRKTZLtc=;
        b=ddwQIZJyTDIsBnalf+gcYehommASDKl2FCgr2kG4cMSlbyN+4lNSJJt1ZcPUJJsvYn
         exdYiaQWjlTzboday9r9rn+cNIsaL1/zWVHhHLaaJzmhkKxqwz/OHOMoPPEJEdH06YLk
         SXctfghVv1jddH4ALPh/F4Q1Jkr67MV5+To+Qv01Vw/vuD13hhEKv82DHo3zVF9HN2GT
         HXBe6MfxejknDK1gE9YqJVz+ZeQxi0ApzWwcGVuwEhB5+ZPfxzVfgbjMSMwC105XSTXD
         zqpXQWez/oWZebyaukk+wgyU0UIiY12Xb+ggvjRWE1mV1MgM9od/LOyFmoN/xMT1aeMu
         xOxw==
X-Gm-Message-State: AOAM531R5yRQUFWiX9NoWuTzld9KEIupQs62vyizbJLLi2SZit5l84sO
        9uKxNkPsisfWi3XWusxwNojcaUW+g3k=
X-Google-Smtp-Source: ABdhPJxUtbUrA6Vj59sfZ+ei3QmXVEwECWDmlGEynB2ck9WovZUz6mfDCiTHoGgRVDMLxrbSHrMsKA==
X-Received: by 2002:a5d:564a:: with SMTP id j10mr2779707wrw.108.1619081248595;
        Thu, 22 Apr 2021 01:47:28 -0700 (PDT)
Received: from hthiery.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id v4sm2300553wme.14.2021.04.22.01.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 01:47:28 -0700 (PDT)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Vorel <petr.vorel@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH] lib/fs: fix issue when {name, open}_to_handle_at() is not implemented
Date:   Thu, 22 Apr 2021 10:46:13 +0200
Message-Id: <20210422084612.26374-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit d5e6ee0dac64b64e the usage of functions name_to_handle_at() and
open_by_handle_at() are introduced. But these function are not available
e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
availability in the configure script and in case of absence do a direct
syscall.

Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
---
 configure | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/fs.c  | 25 ++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/configure b/configure
index 2c363d3b..f1be9977 100755
--- a/configure
+++ b/configure
@@ -202,6 +202,58 @@ EOF
     rm -f $TMPDIR/setnstest.c $TMPDIR/setnstest
 }
 
+check_name_to_handle_at()
+{
+
+    cat >$TMPDIR/name_to_handle_at_test.c <<EOF
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
+
+    if $CC -I$INCLUDE -o $TMPDIR/name_to_handle_at_test $TMPDIR/name_to_handle_at_test.c >/dev/null 2>&1; then
+	echo "IP_CONFIG_NAME_TO_HANDLE_AT:=y" >>$CONFIG
+	echo "yes"
+	echo "CFLAGS += -DHAVE_NAME_TO_HANDLE_AT" >>$CONFIG
+    else
+	echo "no"
+    fi
+    rm -f $TMPDIR/name_to_handle_at_test.c $TMPDIR/name_to_handle_at_test
+}
+
+check_open_by_handle_at()
+{
+
+    cat >$TMPDIR/open_by_handle_at_test.c <<EOF
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+int main(int argc, char **argv)
+{
+	struct file_handle *fhp;
+	int mount_fd;
+	open_by_handle_at(mount_fd, fhp, O_RDONLY);
+	return 0;
+}
+EOF
+    if $CC -I$INCLUDE -o $TMPDIR/open_by_handle_at_test $TMPDIR/open_by_handle_at_test.c >/dev/null 2>&1; then
+	echo "IP_CONFIG_OPEN_BY_HANDLE_AT:=y" >>$CONFIG
+	echo "yes"
+	echo "CFLAGS += -DHAVE_OPEN_BY_HANDLE_AT" >>$CONFIG
+    else
+	echo "no"
+    fi
+    rm -f $TMPDIR/open_by_handle_at_test.c $TMPDIR/open_by_handle_at_test
+}
+
 check_ipset()
 {
     cat >$TMPDIR/ipsettest.c <<EOF
@@ -492,6 +544,12 @@ fi
 echo -n "libc has setns: "
 check_setns
 
+echo -n "libc has name_to_handle_at: "
+check_name_to_handle_at
+
+echo -n "libc has open_by_handle_at: "
+check_open_by_handle_at
+
 echo -n "SELinux support: "
 check_selinux
 
diff --git a/lib/fs.c b/lib/fs.c
index ee0b130b..c561d85b 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -30,6 +30,31 @@
 /* if not already mounted cgroup2 is mounted here for iproute2's use */
 #define MNT_CGRP2_PATH  "/var/run/cgroup2"
 
+
+#if (!defined HAVE_NAME_TO_HANDLE_AT && !defined HAVE_OPEN_BY_HANDLE_AT)
+struct file_handle {
+	unsigned handle_bytes;
+	int handle_type;
+	unsigned char f_handle[];
+};
+#endif
+
+#ifndef HAVE_NAME_TO_HANDLE_AT
+int name_to_handle_at(int dirfd, const char *pathname,
+	struct file_handle *handle, int *mount_id, int flags)
+{
+	return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
+	               mount_id, flags);
+}
+#endif
+
+#ifndef HAVE_OPEN_BY_HANDLE_AT
+int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
+{
+	return syscall(open_by_handle_at, 3, mount_fd, handle, flags);
+}
+#endif
+
 /* return mount path of first occurrence of given fstype */
 static char *find_fs_mount(const char *fs_to_find)
 {
-- 
2.30.0

