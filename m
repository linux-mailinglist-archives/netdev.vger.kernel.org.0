Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A973604FA8
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJSSbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiJSSbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A6D1870B7
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666204261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cCN3nXaInVHD32MhWWcbdwlbpc4R68KG15B7DnjepoI=;
        b=Q0IjRtod3Kr/J34Rp/DkRe8LEinY2uFHYeppzieYywpmbOwyXAlXgpkSwo6Ou/Cxa1hJCa
        xGyA5A9swflXVzlkAgxjdoaZZHCON+wAhEB9k/yZo+YrGEVdrSFlHO42HHS2B77QyhN8Yw
        O6eNqqpBJX2qmK7LSmNmbQUgj+0vs2g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-Wt-r0j5kN0SP8etswylORg-1; Wed, 19 Oct 2022 14:30:57 -0400
X-MC-Unique: Wt-r0j5kN0SP8etswylORg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9978D185A7AD;
        Wed, 19 Oct 2022 18:30:56 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F23C49BB63;
        Wed, 19 Oct 2022 18:30:56 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Kevin Sprague <ksprague0711@gmail.com>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 2/2] selftests: add openvswitch selftest suite
Date:   Wed, 19 Oct 2022 14:30:54 -0400
Message-Id: <20221019183054.105815-3-aconole@redhat.com>
In-Reply-To: <20221019183054.105815-1-aconole@redhat.com>
References: <20221019183054.105815-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous commit resolves a WARN splat that can be difficult to reproduce,
but with the ovs-dpctl.py utility, it can be trivial.  Introduce a test
case which creates a DP, and then downgrades the feature set.  This will
include a utility 'ovs-dpctl.py' that can be extended to do additional
work.

Signed-off-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Kevin Sprague <ksprague0711@gmail.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/net/openvswitch/Makefile        |  13 +
 .../selftests/net/openvswitch/openvswitch.sh  | 216 +++++++++
 .../selftests/net/openvswitch/ovs-dpctl.py    | 411 ++++++++++++++++++
 5 files changed, 642 insertions(+)
 create mode 100644 tools/testing/selftests/net/openvswitch/Makefile
 create mode 100755 tools/testing/selftests/net/openvswitch/openvswitch.sh
 create mode 100644 tools/testing/selftests/net/openvswitch/ovs-dpctl.py

diff --git a/MAINTAINERS b/MAINTAINERS
index abbe88e1c50b..295a6b0fbe26 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15434,6 +15434,7 @@ S:	Maintained
 W:	http://openvswitch.org
 F:	include/uapi/linux/openvswitch.h
 F:	net/openvswitch/
+F:	tools/testing/selftests/net/openvswitch/
 
 OPERATING PERFORMANCE POINTS (OPP)
 M:	Viresh Kumar <vireshk@kernel.org>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 0464b2c6c1e4..f07aef7c592c 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -49,6 +49,7 @@ TARGETS += net
 TARGETS += net/af_unix
 TARGETS += net/forwarding
 TARGETS += net/mptcp
+TARGETS += net/openvswitch
 TARGETS += netfilter
 TARGETS += nsfs
 TARGETS += pidfd
diff --git a/tools/testing/selftests/net/openvswitch/Makefile b/tools/testing/selftests/net/openvswitch/Makefile
new file mode 100644
index 000000000000..2f1508abc826
--- /dev/null
+++ b/tools/testing/selftests/net/openvswitch/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+
+top_srcdir = ../../../../..
+
+CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
+
+TEST_PROGS := openvswitch.sh
+
+TEST_FILES := ovs-dpctl.py
+
+EXTRA_CLEAN := test_netlink_checks
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/net/openvswitch/openvswitch.sh b/tools/testing/selftests/net/openvswitch/openvswitch.sh
new file mode 100755
index 000000000000..bebc20f157dc
--- /dev/null
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -0,0 +1,216 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# OVS kernel module self tests
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+PAUSE_ON_FAIL=no
+VERBOSE=0
+TRACING=0
+
+tests="
+	netlink_checks				ovsnl: validate netlink attrs and settings"
+
+info() {
+    [ $VERBOSE = 0 ] || echo $*
+}
+
+ovs_base=`pwd`
+sbxs=
+sbx_add () {
+	info "adding sandbox '$1'"
+
+	sbxs="$sbxs $1"
+
+	NO_BIN=0
+
+	# Create sandbox.
+	local d="$ovs_base"/$1
+	if [ -e $d ]; then
+		info "removing $d"
+		rm -rf "$d"
+	fi
+	mkdir "$d" || return 1
+	ovs_setenv $1
+}
+
+ovs_exit_sig() {
+	[ -e ${ovs_dir}/cleanup ] && . "$ovs_dir/cleanup"
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
+}
+
+ovs_sbx() {
+	if test "X$2" != X; then
+		(ovs_setenv $1; shift; "$@" >> ${ovs_dir}/debug.log)
+	else
+		ovs_setenv $1
+	fi
+}
+
+ovs_add_dp () {
+	info "Adding DP/Bridge IF: sbx:$1 dp:$2 {$3, $4, $5}"
+	ovs_sbx "$1" python3 $ovs_base/ovs-dpctl.py add-dp "$2" "$3" "$4" "$5" || return 1
+	on_exit "ovs_sbx $1 python3 $ovs_base/ovs-dpctl.py del-dp $2;"
+}
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
+# netlink_validation
+# - Create a dp
+# - check no warning with "old version" simulation
+test_netlink_checks () {
+	sbx_add "test_netlink_checks" || return 1
+
+	info "setting up new DP"
+	ovs_add_dp "test_netlink_checks" nv0 || return 1
+	# now try again
+	PRE_TEST=$(dmesg | grep -E "RIP: [0-9a-fA-Fx]+:ovs_dp_cmd_new\+")
+	ovs_add_dp "test_netlink_checks" nv0 -V 0 || return 1
+	POST_TEST=$(dmesg | grep -E "RIP: [0-9a-fA-Fx]+:ovs_dp_cmd_new\+")
+	if [ "$PRE_TEST" != "$POST_TEST" ]; then
+		info "failed - gen warning"
+		return 1
+	fi
+
+	return 0
+}
+
+run_test() {
+	(
+	tname="$1"
+	tdesc="$2"
+
+	if ! lsmod | grep openvswitch >/dev/null 2>&1; then
+		stdbuf -o0 printf "TEST: %-60s  [NOMOD]\n" "${tdesc}"
+		return $ksft_skip
+	fi
+
+	if python3 ovs-dpctl.py help 2>&1 | \
+	     grep "Need to install the python" >/dev/null 2>&1; then
+		stdbuf -o0 printf "TEST: %-60s  [PYLIB]\n" "${tdesc}"
+		return $ksft_skip
+	fi
+	printf "TEST: %-60s  [START]\n" "${tname}"
+
+	unset IFS
+
+	eval test_${tname}
+	ret=$?
+
+	if [ $ret -eq 0 ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${tdesc}"
+		ovs_exit_sig
+		rm -rf "$ovs_dir"
+	elif [ $ret -eq 1 ]; then
+		printf "TEST: %-60s  [FAIL]\n" "${tdesc}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "Pausing. Logs in $ovs_dir/. Hit enter to continue"
+			read a
+		fi
+		ovs_exit_sig
+		[ "${PAUSE_ON_FAIL}" = "yes" ] || rm -rf "$ovs_dir"
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
+			[ $all_skipped = true ] && [ $exitcode=$ksft_skip ] && exitcode=0
+			all_skipped=false
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
diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
new file mode 100644
index 000000000000..791d76b7adcd
--- /dev/null
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -0,0 +1,411 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+# Controls the openvswitch module.  Part of the kselftest suite, but
+# can be used for some diagnostic purpose as well.
+
+import logging
+import multiprocessing
+import socket
+import struct
+import sys
+
+try:
+    from libnl.attr import NLA_NESTED, NLA_STRING, NLA_U32, NLA_UNSPEC
+    from libnl.attr import nla_get_string, nla_get_u32
+    from libnl.attr import nla_put, nla_put_string, nla_put_u32
+    from libnl.attr import nla_policy
+
+    from libnl.error import errmsg
+
+    from libnl.genl.ctrl import genl_ctrl_resolve
+    from libnl.genl.genl import genl_connect, genlmsg_parse, genlmsg_put
+
+    from libnl.handlers import nl_cb_alloc, nl_cb_set
+    from libnl.handlers import NL_CB_CUSTOM, NL_CB_MSG_IN, NL_CB_VALID
+    from libnl.handlers import NL_OK, NL_STOP
+
+    from libnl.linux_private.netlink import NLM_F_ACK, NLM_F_DUMP
+    from libnl.linux_private.netlink import NLM_F_REQUEST, NLMSG_DONE
+
+    from libnl.msg import NL_AUTO_SEQ, nlmsg_alloc, nlmsg_hdr
+
+    from libnl.nl import NLMSG_ERROR, nl_recvmsgs_default, nl_send_auto
+    from libnl.socket_ import nl_socket_alloc, nl_socket_set_cb
+    from libnl.socket_ import nl_socket_get_local_port
+except ModuleNotFoundError:
+    print("Need to install the python libnl3 library.")
+    print("Exiting without error.")
+    exit(0)
+
+
+global sk
+global ovs_families
+
+OVS_DATAPATH_FAMILY = "ovs_datapath"
+OVS_VPORT_FAMILY = "ovs_vport"
+OVS_FLOW_FAMILY = "ovs_flow"
+OVS_PACKET_FAMILY = "ovs_packet"
+OVS_METER_FAMILY = "ovs_meter"
+OVS_CT_LIMIT_FAMILY = "ovs_ct_limit"
+
+OVS_DATAPATH_VERSION = 2
+OVS_HDR_LEN = 4
+OVS_DP_CMD_NEW = 1
+OVS_DP_CMD_DEL = 2
+OVS_DP_CMD_GET = 3
+OVS_DP_CMD_SET = 4
+
+OVS_DP_F_VPORT_PIDS = 1 << 1
+OVS_DP_F_DISPATCH_UPCALL_PER_CPU = 1 << 3
+
+OVS_DP_ATTR_NAME = 1
+OVS_DP_ATTR_UPCALL_PID = 2
+OVS_DP_ATTR_STATS = 3
+OVS_DP_ATTR_MEGAFLOW_STATS = 4
+OVS_DP_ATTR_USER_FEATURES = 5
+OVS_DP_ATTR_PAD = 6
+OVS_DP_ATTR_MASKS_CACHE_SIZE = 7
+OVS_DP_ATTR_PER_CPU_PIDS = 8
+OVS_DP_ATTR_MAX = 8
+
+OVS_VPORT_CMD_NEW = 1
+OVS_VPORT_CMD_DEL = 2
+OVS_VPORT_CMD_GET = 3
+OVS_VPORT_CMD_SET = 4
+
+OVS_VPORT_ATTR_PORT_NO = 1
+OVS_VPORT_ATTR_TYPE = 2
+OVS_VPORT_ATTR_NAME = 3
+OVS_VPORT_ATTR_OPTIONS = 4
+OVS_VPORT_ATTR_UPCALL_PID = 5
+OVS_VPORT_ATTR_STATS = 6
+OVS_VPORT_ATTR_PAD = 7
+OVS_VPORT_ATTR_IFINDEX = 8
+OVS_VPORT_ATTR_NETNSID = 9
+OVS_VPORT_ATTR_MAX = 9
+
+OVS_VPORT_TYPE_NETDEV = 1
+OVS_VPORT_TYPE_INTERNAL = 2
+OVS_VPORT_TYPE_GRE = 3
+OVS_VPORT_TYPE_VXLAN = 4
+OVS_VPORT_TYPE_GENEVE = 5
+OVS_VPORT_TYPE_MAX = 5
+
+
+def nl_sk_transaction(msg, sk, cb):
+    nl_socket_set_cb(sk, cb)
+    ret = nl_send_auto(sk, msg)
+    if ret < 0:
+        print("send error: ", end='')
+        print(errmsg[abs(ret)])
+    ret = nl_recvmsgs_default(sk)
+    if ret < 0:
+        print("recv error: ", end='')
+        print(errmsg[abs(ret)])
+    return ret
+
+
+def if_exists(ifname):
+    try:
+        socket.if_nametoindex(ifname)
+        return True
+    except OSError:
+        return False
+
+
+def get_family(ovs_family_name):
+    """
+    Retrieve a GENL family ID via the global nl socket
+    Returns: family ID for the requested family name
+    """
+    global sk
+    if sk is None:
+        raise ConnectionError("sk not correctly setup")
+    numid = genl_ctrl_resolve(sk, ovs_family_name.encode('utf-8'))
+    return numid
+
+
+def dpctl_netlink_init():
+    """
+    Initializes the global netlink socket, and ovs familly dictionary
+    Returns: 0 on success, any other value is error
+    """
+    global sk, ovs_families
+    sk = nl_socket_alloc()
+    ret = genl_connect(sk)
+    if ret:
+        print(errmsg[abs(ret)])
+        sk = None
+        return ret
+    ovs_families = {}
+    family_probe = [OVS_DATAPATH_FAMILY, OVS_VPORT_FAMILY, OVS_FLOW_FAMILY,
+                    OVS_PACKET_FAMILY, OVS_METER_FAMILY, OVS_CT_LIMIT_FAMILY]
+    for family in family_probe:
+        ovs_families[family] = get_family(family)
+        if ovs_families[family] == -1:
+            return -1
+    return 0
+
+
+def parse_dp_msg(nlh, target_dict):
+    dp_dict = {}
+    attrs = dict((i, None) for i in range(OVS_DP_ATTR_MAX))
+    dp_policy = dict((i, None) for i in range(OVS_DP_ATTR_MAX))
+    dp_policy.update({
+        OVS_DP_ATTR_NAME: nla_policy(type_=NLA_STRING, maxlen=15),
+        OVS_DP_ATTR_UPCALL_PID: nla_policy(type_=NLA_U32),
+        OVS_DP_ATTR_STATS: nla_policy(type_=NLA_NESTED),
+        OVS_DP_ATTR_MEGAFLOW_STATS: nla_policy(type_=NLA_NESTED),
+        OVS_DP_ATTR_USER_FEATURES: nla_policy(type_=NLA_U32),
+        OVS_DP_ATTR_MASKS_CACHE_SIZE: nla_policy(type_=NLA_U32),
+        OVS_DP_ATTR_PER_CPU_PIDS: nla_policy(type_=NLA_UNSPEC)
+    })
+    ret = genlmsg_parse(nlh, 4, attrs, OVS_DP_ATTR_MAX, dp_policy)
+    if ret:
+        print("Error parsing datapath")
+        return -1
+    if attrs[1] is None:
+        print("Error?")
+    dp_name = nla_get_string(attrs[1]).decode('utf-8')
+    b = bytes(attrs[OVS_DP_ATTR_STATS].payload)
+    stats = struct.unpack("=QQQQ", b[:32])
+    dp_dict[OVS_DP_ATTR_STATS] = stats
+    b = bytes(attrs[OVS_DP_ATTR_MEGAFLOW_STATS].payload)
+    stats = struct.unpack("=QIIQQ", b[:32])
+    dp_dict[OVS_DP_ATTR_MEGAFLOW_STATS] = [stats[i] for i in (0, 1, 3)]
+    dp_dict[OVS_DP_ATTR_MASKS_CACHE_SIZE] = nla_get_u32(
+        attrs[OVS_DP_ATTR_MASKS_CACHE_SIZE])
+    target_dict[dp_name] = dp_dict
+
+
+def show_dp_cb(msg, dp_dict):
+    nlh = nlmsg_hdr(msg)
+    if nlh.nlmsg_type == NLMSG_DONE:
+        retn = NL_STOP
+    parse_dp_msg(nlh, dp_dict)
+    retn = NL_OK
+    return retn
+
+
+def show_vport_cb(msg, dp_vport_dict):
+    dp, vport_dict = dp_vport_dict
+    nlh = nlmsg_hdr(msg)
+    retn = None
+    if nlh.nlmsg_type == NLMSG_DONE:
+        retn = NL_STOP
+    attrs = dict((i, None) for i in range(OVS_DP_ATTR_MAX))
+    port_policy = dict((i, None) for i in range(OVS_VPORT_ATTR_MAX))
+    port_policy.update({
+            OVS_VPORT_ATTR_PORT_NO: nla_policy(type_=NLA_U32),
+            OVS_VPORT_ATTR_TYPE: nla_policy(type_=NLA_U32),
+            OVS_VPORT_ATTR_NAME: nla_policy(type_=NLA_STRING, maxlen=15),
+            OVS_VPORT_ATTR_OPTIONS: nla_policy(type_=NLA_NESTED),
+            OVS_VPORT_ATTR_UPCALL_PID: nla_policy(type_=NLA_UNSPEC),
+            OVS_VPORT_ATTR_STATS: nla_policy(type_=NLA_NESTED),
+            OVS_VPORT_ATTR_IFINDEX: nla_policy(type_=NLA_U32),
+        })
+    genlmsg_parse(nlh, OVS_HDR_LEN, attrs, OVS_DP_ATTR_MAX, port_policy)
+    if attrs[1] is not None:
+        port_info = "Port " + str(nla_get_u32(attrs[1])) + ": "
+        if attrs[3] is not None:
+            port_info += nla_get_string(attrs[3]).decode('utf-8')
+            if attrs[OVS_VPORT_ATTR_TYPE] is not None:
+                port_type = nla_get_u32(attrs[OVS_VPORT_ATTR_TYPE])
+                if port_type == OVS_VPORT_TYPE_INTERNAL:
+                    port_info += " (internal)"
+    vport_dict[dp].append(port_info)
+    if retn is None:
+        retn = NL_OK
+    return retn
+
+
+def dpctl_show_print(dp_info, vport_info):
+    for i in dp_info:
+        print("{}".format(i))
+        indent = 2 * " "
+        fields = ("Hit", "Missed", "Lost", "Flows")
+        f_zip = zip(fields, dp_info[i][OVS_DP_ATTR_STATS])
+        format_list = [val for pair in f_zip for val in pair]
+        out_string = indent + "Lookups: {}: {} {}: {} {}: {}\n"
+        out_string += indent + "{}: {}"
+        print(out_string.format(*format_list))
+        fields = ("Hit", "Total", "Hit")
+        f_zip = zip(fields, dp_info[i][OVS_DP_ATTR_MEGAFLOW_STATS])
+        format_list = [val for pair in f_zip for val in pair]
+        out_string = indent + "Masks: {}: {} {}: {}\n"
+        out_string += indent + "Cache: {}: {}"
+        print(out_string.format(*format_list))
+        print("Caches:\n" + indent + "Masks-cache: size: {}".
+              format(dp_info[i][OVS_DP_ATTR_MASKS_CACHE_SIZE]))
+        indent = 4 * " "
+        for port in vport_info[i]:
+            print(indent + port)
+
+
+def dpctl_show(dp=None):
+    global sk, ovs_families
+    cb_dp_show = nl_cb_alloc(NL_CB_CUSTOM)
+    dp_info = {}
+    vport_info = {}
+    nl_cb_set(cb_dp_show, NL_CB_VALID, NL_CB_CUSTOM, show_dp_cb, dp_info)
+    msg_dpctl_get = nlmsg_alloc()
+    if dp is not None:
+        if not if_exists(dp):
+            print("That interface does not exist.")
+            return -1
+        flag = NLM_F_REQUEST
+    else:
+        flag = NLM_F_DUMP
+    genlmsg_put(msg_dpctl_get, 0, NL_AUTO_SEQ,
+                ovs_families[OVS_DATAPATH_FAMILY], OVS_HDR_LEN,
+                flag, OVS_DP_CMD_GET, OVS_DATAPATH_VERSION)
+    if dp is not None:
+        nla_put_string(msg_dpctl_get, OVS_DP_ATTR_NAME, dp.encode('utf-8'))
+    nl_sk_transaction(msg_dpctl_get, sk, cb_dp_show)
+    vport_info = dict((i, []) for i in dp_info)
+    # for each datapath, call down and ask it to tell us its vports.
+    for dp in vport_info:
+        msg_vport_get = nlmsg_alloc()
+        ba = genlmsg_put(msg_vport_get, 0, NL_AUTO_SEQ,
+                         ovs_families[OVS_VPORT_FAMILY], OVS_HDR_LEN,
+                         NLM_F_DUMP, OVS_VPORT_CMD_GET, OVS_DATAPATH_VERSION)
+        ba[0:OVS_HDR_LEN] = struct.pack('=I', socket.if_nametoindex(dp))
+        cb_vport_show = nl_cb_alloc(NL_CB_CUSTOM)
+        nl_cb_set(cb_vport_show, NL_CB_VALID, NL_CB_CUSTOM,
+                  show_vport_cb, (dp, vport_info))
+        nl_sk_transaction(msg_vport_get, sk, cb_vport_show)
+    dpctl_show_print(dp_info, vport_info)
+
+
+def mod_cb(msg, add):
+    nlh = nlmsg_hdr(msg)
+    if nlh.nlmsg_type == NLMSG_ERROR:
+        b = nlh.payload
+        s = struct.unpack('=i', b[:4])[0]
+        if s:
+            print(errmsg[abs(s)])
+            return NL_STOP
+    action = "added" if add else "deleted"
+    print("Successfully {} the datapath.".format(action))
+    return NL_OK
+
+
+def dpctl_mod_dp(args, add=True, setpid=False, hdrval=None):
+    global ovs_families, sk
+
+    dp = args[0]
+    cmd = OVS_DP_CMD_NEW if add else OVS_DP_CMD_DEL
+    msg_dpctl_cmd = nlmsg_alloc()
+
+    userfeatures = 0
+    if hdrval is None:
+        hdrver = OVS_DATAPATH_VERSION
+        userfeatures = OVS_DP_F_VPORT_PIDS
+    else:
+        segment = hdrval.find(":")
+        if segment == -1:
+            segment = len(hdrval)
+        hdrver = int(hdrval[:segment], 0)
+        if len(hdrval[:segment]):
+            userfeatures = int(hdrval[:segment], 0)
+
+    genlmsg_put(msg_dpctl_cmd, 0, NL_AUTO_SEQ,
+                ovs_families[OVS_DATAPATH_FAMILY], OVS_HDR_LEN,
+                NLM_F_ACK, cmd, hdrver)
+
+    nla_put_u32(msg_dpctl_cmd, OVS_DP_ATTR_UPCALL_PID, 0)
+    nla_put_string(msg_dpctl_cmd, OVS_DP_ATTR_NAME, dp.encode('utf-8'))
+
+    if setpid:
+        userfeatures &= ~OVS_DP_F_VPORT_PIDS
+        userfeatures |= OVS_DP_F_DISPATCH_UPCALL_PER_CPU
+        procarray = None
+        nproc = multiprocessing.cpu_count()
+        for i in range(nproc):
+            if procarray is not None:
+                procarray += struct.pack("=I", nl_socket_get_local_port(sk))
+            else:
+                procarray = struct.pack('=I', nl_socket_get_local_port(sk))
+        nla_put(msg_dpctl_cmd, OVS_DP_ATTR_UPCALL_PID, len(procarray),
+                procarray)
+    nla_put_u32(msg_dpctl_cmd, OVS_DP_ATTR_USER_FEATURES, userfeatures)
+    cb_dp_mod = nl_cb_alloc(NL_CB_CUSTOM)
+    nl_cb_set(cb_dp_mod, NL_CB_MSG_IN, NL_CB_CUSTOM, mod_cb, add)
+    return nl_sk_transaction(msg_dpctl_cmd, sk, cb_dp_mod)
+
+
+def dpctl_add_dp(dp):
+    setpid = False
+    dphdr = None
+    if len(dp) > 1:
+        for i in range(len(dp)):
+            if dp[i] == '-u':
+                setpid = True
+            elif dp[i] == '-V':
+                i += 1
+                dphdr = dp[i]
+
+    return dpctl_mod_dp(dp, True, setpid, dphdr)
+
+
+def dpctl_del_dp(dp):
+    args = [dp]
+    return dpctl_mod_dp(args, False)
+
+
+def help(errStr=None):
+    """
+    Display a help message, include errStr if there was an error.
+    Return: None
+    """
+    if errStr is None:
+        print("ovs-dpctl.py: openvswitch module controller")
+    else:
+        print(errStr)
+    print("usage:")
+    print("  show [DP]\t\t\tDispay information about all datapaths, or DP")
+    print("  add-dp DP\t\t\tAdd new datapath DP")
+    print("  del-dp DP\t\t\tDelete local datapath DP")
+
+
+def main(argv):
+    if len(argv) < 2:
+        help()
+        return 0
+    count = 1
+    for arg in argv[1:]:
+        count += 1
+        if arg in ("-v", "--verbose"):
+            logging.basicConfig(level=logging.DEBUG)
+        if arg in ("-h", "--help", "help"):
+            help()
+            return 0
+        if arg == "show":
+            dpctl_netlink_init()
+            if len(argv) <= count:
+                dpctl_show()
+            else:
+                dpctl_show(argv[count])
+            return 0
+        elif arg == "add-dp":
+            dpctl_netlink_init()
+            if len(argv) < 3:   # 3rd arg should be DP name or additional opts
+                help("Missing a DP name")
+                return -1
+            else:
+                dpctl_add_dp(argv[count:])
+            return 0
+        elif arg == "del-dp":
+            dpctl_netlink_init()
+            if len(argv) < 3:   # 3rd arg MUST be DP name
+                help("Missing a DP name")
+                return -1
+            else:
+                dpctl_del_dp(argv[count])
+            return 0
+    return 0
+
+
+if __name__ == "__main__":
+    sys.exit(main(sys.argv))
-- 
2.34.3

