Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0027F3FDF19
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343876AbhIAP4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244935AbhIAP4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 11:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C937161075;
        Wed,  1 Sep 2021 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630511704;
        bh=6Z6K+XSWY4KGjocc/zwOs7KVWe0xhmUGz3v2fh4mNQ4=;
        h=From:To:Cc:Subject:Date:From;
        b=qq79HMM+U4/wvmcKU/ivffSOcqEtgeMQahB0mYre1sFnUH4rTCHv68JrQtvedS9vs
         1MituSk7uSjJkfyjxp/pbb3cGdWKUP6+zRvNHXTwLGscnnUHdD7fukZ5NCfyeON0u1
         gZ/wiX+b0qpnTOwv2VcPXx1gcCLNzTNiFlQESqAVkK9ZsAHd+Gllxor8TfH+EQ4UT0
         7j6kFfE06f23kq1bO7+WTKecr/qa9BGAha/oniyI4H775HPJJwnvkNaz4UM54asuCg
         FrjdmqjZO+//G+ANPa5GkHfXp+V0RRNdA3uvXoFtHJo+TnoS0DZNiA6J1FS0Rq8hJN
         9X2mHPJEL+F3g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] selftests: add simple GSO GRE test
Date:   Wed,  1 Sep 2021 08:55:01 -0700
Message-Id: <20210901155501.353635-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test case for commit a6e3f2985a80 ("ip6_tunnel: fix GRE6 segmentation").

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Looks like I never sent this out.

v2: correct the script name in the Makefile
---
 tools/testing/selftests/net/Makefile   |   1 +
 tools/testing/selftests/net/gre_gso.sh | 236 +++++++++++++++++++++++++
 2 files changed, 237 insertions(+)
 create mode 100755 tools/testing/selftests/net/gre_gso.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 378c0aac5a1a..492b273743b4 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -27,6 +27,7 @@ TEST_PROGS += udpgro_fwd.sh
 TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
+TEST_PROGS += gre_gso.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/gre_gso.sh b/tools/testing/selftests/net/gre_gso.sh
new file mode 100755
index 000000000000..facbb0c80443
--- /dev/null
+++ b/tools/testing/selftests/net/gre_gso.sh
@@ -0,0 +1,236 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test is for checking GRE GSO.
+
+ret=0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+# all tests in this script. Can be overridden with -t option
+TESTS="gre_gso"
+
+VERBOSE=0
+PAUSE_ON_FAIL=no
+PAUSE=no
+IP="ip -netns ns1"
+NS_EXEC="ip netns exec ns1"
+TMPFILE=`mktemp`
+PID=
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "    TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "    TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+		echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+
+	if [ "${PAUSE}" = "yes" ]; then
+		echo
+		echo "hit enter to continue, 'q' to quit"
+		read a
+		[ "$a" = "q" ] && exit 1
+	fi
+}
+
+setup()
+{
+	set -e
+	ip netns add ns1
+	ip netns set ns1 auto
+	$IP link set dev lo up
+
+	ip link add veth0 type veth peer name veth1
+	ip link set veth0 up
+	ip link set veth1 netns ns1
+	$IP link set veth1 name veth0
+	$IP link set veth0 up
+
+	dd if=/dev/urandom of=$TMPFILE bs=1024 count=2048 &>/dev/null
+	set +e
+}
+
+cleanup()
+{
+	rm -rf $TMPFILE
+	[ -n "$PID" ] && kill $PID
+	ip link del dev gre1 &> /dev/null
+	ip link del dev veth0 &> /dev/null
+	ip netns del ns1
+}
+
+get_linklocal()
+{
+	local dev=$1
+	local ns=$2
+	local addr
+
+	[ -n "$ns" ] && ns="-netns $ns"
+
+	addr=$(ip -6 -br $ns addr show dev ${dev} | \
+	awk '{
+		for (i = 3; i <= NF; ++i) {
+			if ($i ~ /^fe80/)
+				print $i
+		}
+	}'
+	)
+	addr=${addr/\/*}
+
+	[ -z "$addr" ] && return 1
+
+	echo $addr
+
+	return 0
+}
+
+gre_create_tun()
+{
+	local a1=$1
+	local a2=$2
+	local mode
+
+	[[ $a1 =~ ^[0-9.]*$ ]] && mode=gre || mode=ip6gre
+
+	ip tunnel add gre1 mode $mode local $a1 remote $a2 dev veth0
+	ip link set gre1 up
+	$IP tunnel add gre1 mode $mode local $a2 remote $a1 dev veth0
+	$IP link set gre1 up
+}
+
+gre_gst_test_checks()
+{
+	local name=$1
+	local addr=$2
+
+	$NS_EXEC nc -kl $port >/dev/null &
+	PID=$!
+	while ! $NS_EXEC ss -ltn | grep -q $port; do ((i++)); sleep 0.01; done
+
+	cat $TMPFILE | timeout 1 nc $addr $port
+	log_test $? 0 "$name - copy file w/ TSO"
+
+	ethtool -K veth0 tso off
+
+	cat $TMPFILE | timeout 1 nc $addr $port
+	log_test $? 0 "$name - copy file w/ GSO"
+
+	ethtool -K veth0 tso on
+
+	kill $PID
+	PID=
+}
+
+gre6_gso_test()
+{
+	local port=7777
+
+	setup
+
+	a1=$(get_linklocal veth0)
+	a2=$(get_linklocal veth0 ns1)
+
+	gre_create_tun $a1 $a2
+
+	ip  addr add 172.16.2.1/24 dev gre1
+	$IP addr add 172.16.2.2/24 dev gre1
+
+	ip  -6 addr add 2001:db8:1::1/64 dev gre1 nodad
+	$IP -6 addr add 2001:db8:1::2/64 dev gre1 nodad
+
+	sleep 2
+
+	gre_gst_test_checks GREv6/v4 172.16.2.2
+	gre_gst_test_checks GREv6/v6 2001:db8:1::2
+
+	cleanup
+}
+
+gre_gso_test()
+{
+	gre6_gso_test
+}
+
+################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+        -p          Pause on fail
+        -P          Pause after each test before cleanup
+        -v          verbose mode (show commands and output)
+EOF
+}
+
+################################################################################
+# main
+
+while getopts :t:pPhv o
+do
+	case $o in
+		t) TESTS=$OPTARG;;
+		p) PAUSE_ON_FAIL=yes;;
+		P) PAUSE=yes;;
+		v) VERBOSE=$(($VERBOSE + 1));;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+PEER_CMD="ip netns exec ${PEER_NS}"
+
+# make sure we don't pause twice
+[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v nc)" ]; then
+	echo "SKIP: Could not run test without nc tool"
+	exit $ksft_skip
+fi
+
+# start clean
+cleanup &> /dev/null
+
+for t in $TESTS
+do
+	case $t in
+	gre_gso)		gre_gso_test;;
+
+	help) echo "Test names: $TESTS"; exit 0;;
+	esac
+done
+
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
+exit $ret
-- 
2.31.1

