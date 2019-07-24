Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED4C729B8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfGXISt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:18:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37722 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGXISs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 04:18:48 -0400
Received: from sf.home (trofi-1-pt.tunnel.tserv1.lon2.ipv6.he.net [IPv6:2001:470:1f1c:a0f::2])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: slyfox)
        by smtp.gentoo.org (Postfix) with ESMTPSA id D54093485F7;
        Wed, 24 Jul 2019 08:18:47 +0000 (UTC)
Received: by sf.home (Postfix, from userid 1000)
        id CB7FD243B1744; Wed, 24 Jul 2019 09:18:43 +0100 (BST)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     netdev@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] iproute2: devlink: use sys/queue.h from libbsd as a fallback
Date:   Wed, 24 Jul 2019 09:18:38 +0100
Message-Id: <20190724081838.18198-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On sys/queue.h does not exist linux-musl targets and
fails build as:

    devlink.c:28:10: fatal error: sys/queue.h: No such file or directory
       28 | #include <sys/queue.h>
          |          ^~~~~~~~~~~~~

The change pulls in 'sys/queue.h' from libbsd in case
system headers don't already provides it.

Tested on linux-musl and linux-glibc.

Bug: https://bugs.gentoo.org/690486
CC: Stephen Hemminger <stephen@networkplumber.org>
CC: netdev@vger.kernel.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 configure         | 30 ++++++++++++++++++++++++++++++
 devlink/devlink.c |  9 ++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 45fcffb6..a1ee946f 100755
--- a/configure
+++ b/configure
@@ -323,6 +323,33 @@ check_cap()
 	fi
 }
 
+check_sys_queue()
+{
+    cat >$TMPDIR/queue_test.c <<EOF
+#include <sys/queue.h>
+struct nest_qentry {
+	int attr_type;
+	TAILQ_ENTRY(nest_qentry) nest_entries;
+};
+int main(int argc, char **argv) {
+	return 0;
+}
+EOF
+    if $CC -I$INCLUDE -o $TMPDIR/queue_test $TMPDIR/queue_test.c >/dev/null 2>&1; then
+	echo "no"
+    else
+	if ${PKG_CONFIG} libbsd --exists; then
+		echo 'CFLAGS += -DHAVE_LIBBSD_SYS_QUEUE' `${PKG_CONFIG} libbsd --cflags` >>$CONFIG
+		echo 'LDLIBS +=' `${PKG_CONFIG} libbsd --libs` >> $CONFIG
+		echo "no"
+	else
+		echo 'CFLAGS += -DNEED_SYS_QUEUE' >>$CONFIG
+		echo "yes"
+	fi
+    fi
+    rm -f $TMPDIR/queue_test.c $TMPDIR/queue_test
+}
+
 quiet_config()
 {
 	cat <<EOF
@@ -398,6 +425,9 @@ check_strlcpy
 echo -n "libcap support: "
 check_cap
 
+echo -n "need for sys/queue.h API: "
+check_sys_queue
+
 echo >> $CONFIG
 echo "%.o: %.c" >> $CONFIG
 echo '	$(QUIET_CC)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c -o $@ $<' >> $CONFIG
diff --git a/devlink/devlink.c b/devlink/devlink.c
index bb023c0c..fd91198c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -25,7 +25,14 @@
 #include <linux/devlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
-#include <sys/queue.h>
+#ifdef HAVE_LIBBSD_SYS_QUEUE
+#    include <bsd/sys/queue.h>
+#else
+#    include <sys/queue.h>
+#endif
+#ifdef NEED_SYS_QUEUE
+#    error "No <sys/queue.h> implementation found."
+#endif
 
 #include "SNAPSHOT.h"
 #include "list.h"
-- 
2.22.0

