Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C99A342715
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 21:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCSUnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 16:43:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229974AbhCSUnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 16:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616186593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ob02EIiH/ikPbVHgz+EviYfRbvP2j3a+dVLvUdF8qRI=;
        b=Z90eNFC2Ou5mwNwt9P1F3aKK5szzw6Hx7A1JIHh4kLWII1GT/qrxMfGmcgrUCusXrgH/5E
        tJwDmIu2IKgA7OhHZuU6maKQmB5M96PPpnzcAfWVnyObrmHeODQV+mp3FRzua7t0hQGN0i
        lOtT50eAiHD4ohtTEY/sVxK4azHzfVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-lxYmyuj3PaKfZJHu4hz3Tg-1; Fri, 19 Mar 2021 16:43:10 -0400
X-MC-Unique: lxYmyuj3PaKfZJHu4hz3Tg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39BD687A83E;
        Fri, 19 Mar 2021 20:43:09 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (ovpn-117-172.rdu2.redhat.com [10.10.117.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 085955D9E3;
        Fri, 19 Mar 2021 20:43:07 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, Pravin B Shelar <pshelar@ovn.org>,
        Joe Stringer <joe@cilium.io>,
        Eelco Chaudron <echaudro@redhat.com>,
        Dan Williams <dcbw@redhat.com>
Subject: [PATCH] openvswitch: perform refragmentation for packets which pass through conntrack
Date:   Fri, 19 Mar 2021 16:43:07 -0400
Message-Id: <20210319204307.3128280-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a user instructs a flow pipeline to perform connection tracking,
there is an implicit L3 operation that occurs - namely the IP fragments
are reassembled and then processed as a single unit.  After this, new
fragments are generated and then transmitted, with the hint that they
should be fragmented along the max rx unit boundary.  In general, this
behavior works well to forward packets along when the MTUs are congruent
across the datapath.

However, if using a protocol such as UDP on a network with mismatching
MTUs, it is possible that the refragmentation will still produce an
invalid fragment, and that fragmented packet will not be delivered.
Such a case shouldn't happen because the user explicitly requested a
layer 3+4 function (conntrack), and that function generates new fragments,
so we should perform the needed actions in that case (namely, refragment
IPv4 along a correct boundary, or send a packet too big in the IPv6 case).

Additionally, introduce a test suite for openvswitch with a test case
that ensures this MTU behavior, with the expectation that new tests are
added when needed.

Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
Signed-off-by: Aaron Conole <aconole@redhat.com>
---
NOTE: checkpatch reports a whitespace error with the openvswitch.sh
      script - this is due to using tab as the IFS value.  This part
      of the script was copied from
      tools/testing/selftests/net/pmtu.sh so I think should be
      permissible.

 net/openvswitch/actions.c                  |   2 +-
 tools/testing/selftests/net/.gitignore     |   1 +
 tools/testing/selftests/net/Makefile       |   1 +
 tools/testing/selftests/net/openvswitch.sh | 394 +++++++++++++++++++++
 4 files changed, 397 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/openvswitch.sh

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 92a0b67b2728..d858ea580e43 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -890,7 +890,7 @@ static void do_output(struct datapath *dp, struct sk_buff *skb, int out_port,
 		if (likely(!mru ||
 		           (skb->len <= mru + vport->dev->hard_header_len))) {
 			ovs_vport_send(vport, skb, ovs_key_mac_proto(key));
-		} else if (mru <= vport->dev->mtu) {
+		} else if (mru) {
 			struct net *net = read_pnet(&dp->net);
 
 			ovs_fragment(net, vport, skb, mru, key);
diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 61ae899cfc17..d4d7487833be 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -30,3 +30,4 @@ hwtstamp_config
 rxtimestamp
 timestamping
 txtimestamp
+test_mismatched_mtu_with_conntrack
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 25f198bec0b2..dc9b556f86fd 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -23,6 +23,7 @@ TEST_PROGS += drop_monitor_tests.sh
 TEST_PROGS += vrf_route_leaking.sh
 TEST_PROGS += bareudp.sh
 TEST_PROGS += unicast_extensions.sh
+TEST_PROGS += openvswitch.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/openvswitch.sh b/tools/testing/selftests/net/openvswitch.sh
new file mode 100755
index 000000000000..7b6341688cc3
--- /dev/null
+++ b/tools/testing/selftests/net/openvswitch.sh
@@ -0,0 +1,394 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# OVS kernel module self tests
+#
+# Tests currently implemented:
+#
+# - mismatched_mtu_with_conntrack
+#	Set up two namespaces (client and server) which each have devices specifying
+#	incongruent MTUs (1450 vs 1500 in the test).  Transmit a UDP packet of 1901 bytes
+#	from client to server, and back.  Ensure that the ct() action
+#	uses the mru as a hint, but not a forced check.
+
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+PAUSE_ON_FAIL=no
+VERBOSE=0
+TRACING=0
+
+tests="
+	mismatched_mtu_with_conntrack		ipv4: IP Fragmentation with conntrack"
+
+
+usage() {
+	echo
+	echo "$0 [OPTIONS] [TEST]..."
+	echo "If no TEST argument is given, all tests will be run."
+	echo
+	echo "Options"
+	echo "  -t: capture traffic via tcpdump"
+	echo "  -v: verbose"
+	echo "  -p: pause on failure"
+	echo
+	echo "Available tests${tests}"
+	exit 1
+}
+
+on_exit() {
+	echo "$1" > ${ovs_dir}/cleanup.tmp
+	cat ${ovs_dir}/cleanup >> ${ovs_dir}/cleanup.tmp
+	mv ${ovs_dir}/cleanup.tmp ${ovs_dir}/cleanup
+}
+
+ovs_setenv() {
+	sandbox=$1
+
+	ovs_dir=$ovs_base${1:+/$1}; export ovs_dir
+
+	test -e ${ovs_dir}/cleanup || : > ${ovs_dir}/cleanup
+
+	OVS_RUNDIR=$ovs_dir; export OVS_RUNDIR
+	OVS_LOGDIR=$ovs_dir; export OVS_LOGDIR
+	OVS_DBDIR=$ovs_dir; export OVS_DBDIR
+	OVS_SYSCONFDIR=$ovs_dir; export OVS_SYSCONFDIR
+	OVS_PKGDATADIR=$ovs_dir; export OVS_PKGDATADIR
+}
+
+ovs_exit_sig() {
+	. "$ovs_dir/cleanup"
+	ovs-dpctl del-dp ovs-system
+}
+
+ovs_cleanup() {
+	ovs_exit_sig
+	[ $VERBOSE = 0 ] || echo "Error detected.  See $ovs_dir for more details."
+}
+
+ovs_normal_exit() {
+	ovs_exit_sig
+	rm -rf ${ovs_dir}
+}
+
+info() {
+    [ $VERBOSE = 0 ] || echo $*
+}
+
+kill_ovs_vswitchd () {
+	# Use provided PID or save the current PID if available.
+	TMPPID=$1
+	if test -z "$TMPPID"; then
+		TMPPID=$(cat $OVS_RUNDIR/ovs-vswitchd.pid 2>/dev/null)
+	fi
+
+	# Tell the daemon to terminate gracefully
+	ovs-appctl -t ovs-vswitchd exit --cleanup 2>/dev/null
+
+	# Nothing else to be done if there is no PID
+	test -z "$TMPPID" && return
+
+	for i in 1 2 3 4 5 6 7 8 9; do
+		# Check if the daemon is alive.
+		kill -0 $TMPPID 2>/dev/null || return
+
+		# Fallback to whole number since POSIX doesn't require
+		# fractional times to work.
+		sleep 0.1 || sleep 1
+	done
+
+	# Make sure it is terminated.
+	kill $TMPPID
+}
+
+start_daemon () {
+	info "exec: $@ -vconsole:off --detach --no-chdir --pidfile --log-file"
+	"$@" -vconsole:off --detach --no-chdir --pidfile --log-file >/dev/null
+	pidfile="$OVS_RUNDIR"/$1.pid
+
+	info "setting kill for $@..."
+	on_exit "test -e \"$pidfile\" && kill \`cat \"$pidfile\"\`"
+}
+
+if test "X$vswitchd_schema" = "X"; then
+	vswitchd_schema="/usr/share/openvswitch"
+fi
+
+ovs_sbx() {
+	if test "X$2" != X; then
+		(ovs_setenv $1; shift; "$@" >> ${ovs_dir}/debug.log)
+	else
+		ovs_setenv $1
+	fi
+}
+
+seq () {
+	if test $# = 1; then
+		set 1 $1
+	fi
+	while test $1 -le $2; do
+		echo $1
+		set `expr $1 + ${3-1}` $2 $3
+	done
+}
+
+ovs_wait () {
+	info "$1: waiting $2..."
+
+	# First try the condition without waiting.
+	if ovs_wait_cond; then info "$1: wait succeeded immediately"; return 0; fi
+
+	# Try a quick sleep, so that the test completes very quickly
+	# in the normal case.  POSIX doesn't require fractional times to
+	# work, so this might not work.
+	sleep 0.1
+	if ovs_wait_cond; then info "$1: wait succeeded quickly"; return 0; fi
+
+	# Then wait up to OVS_CTL_TIMEOUT seconds.
+	local d
+	for d in `seq 1 "$OVS_CTL_TIMEOUT"`; do
+		sleep 1
+		if ovs_wait_cond; then info "$1: wait succeeded after $d seconds"; return 0; fi
+	done
+
+	info "$1: wait failed after $d seconds"
+	ovs_wait_failed
+}
+
+sbxs=
+sbx_add () {
+	info "adding sandbox '$1'"
+
+	sbxs="$sbxs $1"
+
+	NO_BIN=0
+	which ovsdb-tool >/dev/null 2>&1 || NO_BIN=1
+	which ovsdb-server >/dev/null 2>&1 || NO_BIN=1
+	which ovs-vsctl >/dev/null 2>&1 || NO_BIN=1
+	which ovs-vswitchd >/dev/null 2>&1 || NO_BIN=1
+
+	if [ $NO_BIN = 1 ]; then
+		info "Missing required binaries..."
+		return 4
+	fi
+	# Create sandbox.
+	local d="$ovs_base"/$1
+	if [ -e $d ]; then
+		info "removing $d"
+		rm -rf "$d"
+	fi
+	mkdir "$d" || return 1
+	ovs_setenv $1
+
+	# Create database and start ovsdb-server.
+        info "$1: create db and start db-server"
+	: > "$d"/.conf.db.~lock~
+	ovs_sbx $1 ovsdb-tool create "$d"/conf.db "$vswitchd_schema"/vswitch.ovsschema || return 1
+	ovs_sbx $1 start_daemon ovsdb-server --detach --remote=punix:"$d"/db.sock || return 1
+
+	# Initialize database.
+	ovs_sbx $1 ovs-vsctl --no-wait -- init || return 1
+
+	# Start ovs-vswitchd
+        info "$1: start vswitchd"
+	ovs_sbx $1 start_daemon ovs-vswitchd -vvconn -vofproto_dpif -vunixctl
+
+	ovs_wait_cond () {
+		if ip link show ovs-netdev >/dev/null 2>&1; then return 1; else return 0; fi
+	}
+	ovs_wait_failed () {
+		:
+	}
+
+	ovs_wait "sandbox_add" "while ip link show ovs-netdev" || return 1
+}
+
+ovs_base=`pwd`
+
+# mismatched_mtu_with_conntrack test
+#  - client has 1450 byte MTU
+#  - server has 1500 byte MTU
+#  - use UDP to send 1901 bytes each direction for mismatched
+#    fragmentation.
+test_mismatched_mtu_with_conntrack() {
+
+	sbx_add "test_mismatched_mtu_with_conntrack" || return $?
+
+	info "create namespaces"
+	for ns in client server; do
+		ip netns add $ns || return 1
+		on_exit "ip netns del $ns"
+	done
+
+	# setup the base bridge
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-vsctl add-br br0 || return 1
+
+	# setup the client
+	info "setup client namespace"
+	ip link add c0 type veth peer name c1 || return 1
+	on_exit "ip link del c0 >/dev/null 2>&1"
+
+	ip link set c0 mtu 1450
+	ip link set c0 up
+
+	ip link set c1 netns client || return 1
+	ip netns exec client ip addr add 172.31.110.2/24 dev c1
+	ip netns exec client ip link set c1 mtu 1450
+	ip netns exec client ip link set c1 up
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-vsctl add-port br0 c0 || return 1
+
+	# setup the server
+	info "setup server namespace"
+	ip link add s0 type veth peer name s1 || return 1
+	on_exit "ip link del s0 >/dev/null 2>&1; ip netns exec server ip link del s0 >/dev/null 2>&1"
+	ip link set s0 up
+
+	ip link set s1 netns server || return 1
+	ip netns exec server ip addr add 172.31.110.1/24 dev s1 || return 1
+	ip netns exec server ip link set s1 up
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-vsctl add-port br0 s0 || return 1
+
+	info "setup flows"
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-ofctl del-flows br0
+
+	cat >${ovs_dir}/flows.txt <<EOF
+table=0,priority=100,arp action=normal
+table=0,priority=100,ip,udp action=ct(table=1)
+table=0,priority=10 action=drop
+
+table=1,priority=100,ct_state=+new+trk,in_port=c0,ip action=ct(commit),s0
+table=1,priority=100,ct_state=+est+trk,in_port=s0,ip action=c0
+
+EOF
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-ofctl --bundle add-flows br0 ${ovs_dir}/flows.txt || return 1
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-ofctl dump-flows br0
+
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-vsctl show
+
+	# setup echo
+	mknod -m 777 ${ovs_dir}/fifo p || return 1
+	# on_exit "rm ${ovs_dir}/fifo"
+
+	# test a udp connection
+	info "send udp data"
+	ip netns exec server sh -c 'cat ${ovs_dir}/fifo | nc -l -vv -u 8888 >${ovs_dir}/fifo 2>${ovs_dir}/s1-nc.log & echo $! > ${ovs_dir}/server.pid'
+	on_exit "test -e \"${ovs_dir}/server.pid\" && kill \`cat \"${ovs_dir}/server.pid\"\`"
+	if [ $TRACING = 1 ]; then
+		ip netns exec server sh -c "tcpdump -i s1 -l -n -U -xx >> ${ovs_dir}/s1-pkts.cap &"
+		ip netns exec client sh -c "tcpdump -i c1 -l -n -U -xx >> ${ovs_dir}/c1-pkts.cap &"
+	fi
+
+	ip netns exec client sh -c "python -c \"import time; print('a' * 1900); time.sleep(2)\" | nc -v -u 172.31.110.1 8888 2>${ovs_dir}/c1-nc.log" || return 1
+
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-appctl dpctl/dump-flows
+	ovs_sbx "test_mismatched_mtu_with_conntrack" ovs-ofctl dump-flows br0
+
+	info "check udp data was tx and rx"
+	grep "1901 bytes received" ${ovs_dir}/c1-nc.log || return 1
+	ovs_normal_exit
+}
+
+run_test() {
+	(
+	tname="$1"
+	tdesc="$2"
+
+	if ! lsmod | grep openvswitch >/dev/null 2>&1; then
+		printf "TEST: %-60s  [SKIP]\n" "${tdesc}"
+		return $ksft_skip
+	fi
+
+	unset IFS
+
+	eval test_${tname}
+	ret=$?
+
+	if [ $ret -eq 0 ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${tdesc}"
+		ovs_normal_exit
+	elif [ $ret -eq 1 ]; then
+		printf "TEST: %-60s  [FAIL]\n" "${tdesc}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "Pausing. Hit enter to continue"
+			read a
+		fi
+		ovs_exit_sig
+		exit 1
+	elif [ $ret -eq $ksft_skip ]; then
+		printf "TEST: %-60s  [SKIP]\n" "${tdesc}"
+	elif [ $ret -eq 2 ]; then
+		rm -rf test_${tname}
+		run_test "$1" "$2"
+	fi
+
+	return $ret
+	)
+	ret=$?
+	case $ret in
+		0)
+			all_skipped=false
+			[ $exitcode=$ksft_skip ] && exitcode=0
+		;;
+		$ksft_skip)
+			[ $all_skipped = true ] && exitcode=$ksft_skip
+		;;
+		*)
+			all_skipped=false
+			exitcode=1
+		;;
+	esac
+
+	return $ret
+}
+
+
+exitcode=0
+desc=0
+all_skipped=true
+
+while getopts :pvt o
+do
+	case $o in
+	p) PAUSE_ON_FAIL=yes;;
+	v) VERBOSE=1;;
+	t) if which tcpdump > /dev/null 2>&1; then
+		TRACING=1
+	   else
+		echo "=== tcpdump not available, tracing disabled"
+	   fi
+	   ;;
+	*) usage;;
+	esac
+done
+shift $(($OPTIND-1))
+
+IFS="	
+"
+
+for arg do
+	# Check first that all requested tests are available before running any
+	command -v > /dev/null "test_${arg}" || { echo "=== Test ${arg} not found"; usage; }
+done
+
+name=""
+desc=""
+for t in ${tests}; do
+	[ "${name}" = "" ]	&& name="${t}"	&& continue
+	[ "${desc}" = "" ]	&& desc="${t}"
+
+	run_this=1
+	for arg do
+		[ "${arg}" != "${arg#--*}" ] && continue
+		[ "${arg}" = "${name}" ] && run_this=1 && break
+		run_this=0
+	done
+	if [ $run_this -eq 1 ]; then
+		run_test "${name}" "${desc}"
+	fi
+	name=""
+	desc=""
+done
+
+exit ${exitcode}
-- 
2.25.4

