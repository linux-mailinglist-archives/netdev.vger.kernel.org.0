Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B422736F5A9
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 08:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhD3G14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 02:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhD3G1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 02:27:55 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEB8C06174A;
        Thu, 29 Apr 2021 23:27:07 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id zg3so21958255ejb.8;
        Thu, 29 Apr 2021 23:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xs0dLpLOjPpVnPASrxUlEldZYCSMQdMwxiE4uRpAVE=;
        b=pu4dCg8wMqoLaZPNo8l7m4HVzy2AtSPH3urmWWJi6lxKe3sQB0YkCFA92/ekiD3Nmj
         H+Gjtagm5Nq99uGgYAbTcrO7Cz3c7uNT+wFofH9KFOR4sUe0QjFWlpMVsyGFts7XfsrT
         FS5ztKRbjzsA3Nen6RKla4rc5ELSL0ddt5WvwOZPO1m4VD6Sq7sZsqWOWp6aeAhW1YtH
         ocURZNj2SPULTShaGB9+EgwAADrEjTKdxpK8RBy3Q6zJAiFkW3JYmv9o/AED9yJ97oJT
         w8U70NxkBBZo+qXE3BzTLbwhRFrUMNdhU+bFhN2LAKRO4CKaLtsLDVIDONNVm+H6hUgc
         01bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xs0dLpLOjPpVnPASrxUlEldZYCSMQdMwxiE4uRpAVE=;
        b=mqImM7fgBRvMBJwZF5zQs6gmr7MXmPBxjfuDz5bmFOFb1NwnISGpZabCnBh1NbFQoA
         2z2udPokH7MsEnO/VYPoY87yCh5JK08fE8lsPJsEooT2552fGgNT8HaPZL+qiIiJuXDP
         eQcjLGZPNJdnDDPUEoMWwg4UIOz1l5sihwPPBQu7LA5NZa+1UhOHI6wXLQOqrMMhGP8J
         p7tay4O8RF/XlJSMiL86zcBXswG2zika190NXNge8+S9Oh2FLlP5upj4zXBsggnZw/8j
         X7q9Bgn6sVfwmCdGFyH8wJQcVKS0noBe0TA7KjmmZZFFimufDRdkUxaQB5V6sUGbVKdX
         Wv6g==
X-Gm-Message-State: AOAM530h0Fn0YCyx2QQZvoPFAtUussEWP0q2lk45yw0Nt5kPuwY4Rm04
        zoDmccM7C4CaSF3zH8fPnisTFXdfmPm17zhS
X-Google-Smtp-Source: ABdhPJyN2Zjlu4gMwzZK3/UIZfzpjM6SXt3u0by49Vj39i49qf/OqoNGtvzB807YpqspQntGeEiOuQ==
X-Received: by 2002:a17:906:2287:: with SMTP id p7mr2432792eja.377.1619764025915;
        Thu, 29 Apr 2021 23:27:05 -0700 (PDT)
Received: from hthiery.kontron.local ([213.135.10.150])
        by smtp.gmail.com with ESMTPSA id p4sm1340958ejr.81.2021.04.29.23.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 23:27:05 -0700 (PDT)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Vorel <petr.vorel@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH iproute2-next v2] lib/fs: fix issue when {name,open}_to_handle_at() is not implemented
Date:   Fri, 30 Apr 2021 08:26:33 +0200
Message-Id: <20210430062632.21304-1-heiko.thiery@gmail.com>
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
v2:
 - small correction to subject
 - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
 - fix indentation in check function
 - removed empty lines (thanks to Petr Vorel)
 - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
 - check only for name_to_handle_at (thanks to Peter Vorel)

 configure | 28 ++++++++++++++++++++++++++++
 lib/fs.c  | 21 +++++++++++++++++++++
 2 files changed, 49 insertions(+)

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
index ee0b130b..feb12864 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -30,6 +30,27 @@
 /* if not already mounted cgroup2 is mounted here for iproute2's use */
 #define MNT_CGRP2_PATH  "/var/run/cgroup2"
 
+
+#ifndef defined HAVE_HANDLE_AT
+struct file_handle {
+	unsigned handle_bytes;
+	int handle_type;
+	unsigned char f_handle[];
+};
+
+int name_to_handle_at(int dirfd, const char *pathname,
+	struct file_handle *handle, int *mount_id, int flags)
+{
+	return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
+	               mount_id, flags);
+}
+
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

