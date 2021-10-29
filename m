Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7958043FFDC
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJ2PyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhJ2PyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 11:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8422B61183;
        Fri, 29 Oct 2021 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635522698;
        bh=fIzygt87+udWjiMz2vPNhcKPFrQ5fKJyEQSYz36HRr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LV3KZrUuaWKGIIMdNllpdkDpDKx07tMkWZomas2LCSXL+k1wYwOpHBDqgN718WYB/
         8ipAnnLduOQuvF1NqxK0To2KiEdDVyBuNm8CCXqtt6U5jxTIVozKKom25IqaSp0BF/
         oRcvdZOdqU5PN6aUaQGMVCunts2lWeet98uFuQRM93XR40E6ZH6j4xnG7j4wzMWlM+
         5DnJaYtMeFsywVfClrOLjvORYVLP87nvy27gvr3w9atCXUokiLClAjMHqAy0MlWtE8
         +gF2HhZUijHHmoDYaAvKSNAs0oDXQOF7EZRCrUCMUWNqIF/w7L4h902nUQdoImADeF
         JmdJJ8OVD/Mbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, willemb@google.com
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH net 2/2] selftests: udp: test for passing SO_MARK as cmsg
Date:   Fri, 29 Oct 2021 08:51:35 -0700
Message-Id: <20211029155135.468098-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029155135.468098-1-kuba@kernel.org>
References: <20211029155135.468098-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before fix:
|  Case IPv6 rejection returned 0, expected 1
|FAIL - 1/4 cases failed

With the fix:
| OK

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: shuah@kernel.org
CC: linux-kselftest@vger.kernel.org
---
 tools/testing/selftests/net/.gitignore      |  1 +
 tools/testing/selftests/net/Makefile        |  2 +
 tools/testing/selftests/net/cmsg_so_mark.c  | 67 +++++++++++++++++++++
 tools/testing/selftests/net/cmsg_so_mark.sh | 61 +++++++++++++++++++
 4 files changed, 131 insertions(+)
 create mode 100644 tools/testing/selftests/net/cmsg_so_mark.c
 create mode 100755 tools/testing/selftests/net/cmsg_so_mark.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 501550501216..7581a7348e1b 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -35,3 +35,4 @@ test_unix_oob
 gro
 ioam6_parser
 toeplitz
+cmsg_so_mark
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 492b273743b4..f56b652d5cc6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,6 +28,7 @@ TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
+TEST_PROGS += cmsg_so_mark.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
@@ -44,6 +45,7 @@ TEST_GEN_FILES += gro
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 TEST_GEN_FILES += toeplitz
+TEST_GEN_FILES += cmsg_so_mark
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/cmsg_so_mark.c b/tools/testing/selftests/net/cmsg_so_mark.c
new file mode 100644
index 000000000000..27f2804892a7
--- /dev/null
+++ b/tools/testing/selftests/net/cmsg_so_mark.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <errno.h>
+#include <netdb.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/types.h>
+#include <sys/socket.h>
+
+int main(int argc, const char **argv)
+{
+	char cbuf[CMSG_SPACE(sizeof(__u32))];
+	struct addrinfo hints, *ai;
+	struct cmsghdr *cmsg;
+	struct iovec iov[1];
+	struct msghdr msg;
+	int mark;
+	int err;
+	int fd;
+
+	if (argc != 4) {
+		fprintf(stderr, "Usage: %s <dst_ip> <port> <mark>\n", argv[0]);
+		return 1;
+	}
+	mark = atoi(argv[3]);
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_DGRAM;
+
+	ai = NULL;
+	err = getaddrinfo(argv[1], argv[2], &hints, &ai);
+	if (err) {
+		fprintf(stderr, "Can't resolve address: %s\n", strerror(errno));
+		return 1;
+	}
+
+	fd = socket(ai->ai_family, SOCK_DGRAM, IPPROTO_UDP);
+	if (fd < 0) {
+		fprintf(stderr, "Can't open socket: %s\n", strerror(errno));
+		freeaddrinfo(ai);
+		return 1;
+	}
+
+	iov[0].iov_base = "bla";
+	iov[0].iov_len = 4;
+
+	msg.msg_name = ai->ai_addr;
+	msg.msg_namelen = ai->ai_addrlen;
+	msg.msg_iov = iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cbuf;
+	msg.msg_controllen = sizeof(cbuf);
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SO_MARK;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(__u32));
+	*(__u32 *)CMSG_DATA(cmsg) = mark;
+
+	err = sendmsg(fd, &msg, 0);
+
+	close(fd);
+	freeaddrinfo(ai);
+	return err != 4;
+}
diff --git a/tools/testing/selftests/net/cmsg_so_mark.sh b/tools/testing/selftests/net/cmsg_so_mark.sh
new file mode 100755
index 000000000000..19c6aab8d0e9
--- /dev/null
+++ b/tools/testing/selftests/net/cmsg_so_mark.sh
@@ -0,0 +1,61 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+NS=ns
+IP4=172.16.0.1/24
+TGT4=172.16.0.2
+IP6=2001:db8:1::1/64
+TGT6=2001:db8:1::2
+MARK=1000
+
+cleanup()
+{
+    ip netns del $NS
+}
+
+trap cleanup EXIT
+
+# Namespaces
+ip netns add $NS
+
+# Connectivity
+ip -netns $NS link add type dummy
+ip -netns $NS link set dev dummy0 up
+ip -netns $NS addr add $IP4 dev dummy0
+ip -netns $NS addr add $IP6 dev dummy0
+
+ip -netns $NS rule add fwmark $MARK lookup 300
+ip -6 -netns $NS rule add fwmark $MARK lookup 300
+ip -netns $NS route add prohibit any table 300
+ip -6 -netns $NS route add prohibit any table 300
+
+# Test
+BAD=0
+TOTAL=0
+
+check_result() {
+    ((TOTAL++))
+    if [ $1 -ne $2 ]; then
+	echo "  Case $3 returned $1, expected $2"
+	((BAD++))
+    fi
+}
+
+ip netns exec $NS ./cmsg_so_mark $TGT4 1234 $((MARK + 1))
+check_result $? 0 "IPv4 pass"
+ip netns exec $NS ./cmsg_so_mark $TGT6 1234 $((MARK + 1))
+check_result $? 0 "IPv6 pass"
+
+ip netns exec $NS ./cmsg_so_mark $TGT4 1234 $MARK
+check_result $? 1 "IPv4 rejection"
+ip netns exec $NS ./cmsg_so_mark $TGT6 1234 $MARK
+check_result $? 1 "IPv6 rejection"
+
+# Summary
+if [ $BAD -ne 0 ]; then
+    echo "FAIL - $BAD/$TOTAL cases failed"
+    exit 1
+else
+    echo "OK"
+    exit 0
+fi
-- 
2.31.1

