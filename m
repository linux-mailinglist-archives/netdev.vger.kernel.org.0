Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020D360CA57
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiJYKue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiJYKua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:50:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F293F2A24C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666695026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mIPFepEyIraktN2dDGt5aIieB+StF02kHm/qSHaC+H4=;
        b=XfknpCfjl091GKqu6kDeEbyu09fKX4P85QcGb/X/3p2bQdDETdfka2QhHeBvydVYVxORm4
        vYn4o2CWD3VJj3q7vLnhNxrTIrGSOydyzpfZierDp5t0/u6NKIdcjKWMLZvqnpcBh34kkk
        8KUFLB6QwtpBMfw4MVarKS1sHABve+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-cY8wv4sFMoyTkYqJqNvV6A-1; Tue, 25 Oct 2022 06:50:23 -0400
X-MC-Unique: cY8wv4sFMoyTkYqJqNvV6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6883E86F123;
        Tue, 25 Oct 2022 10:50:22 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0D2C2024CCA;
        Tue, 25 Oct 2022 10:50:20 +0000 (UTC)
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
Subject: [PATCH v2 net 2/2] selftests: add openvswitch selftest suite
Date:   Tue, 25 Oct 2022 06:50:18 -0400
Message-Id: <20221025105018.466157-3-aconole@redhat.com>
In-Reply-To: <20221025105018.466157-1-aconole@redhat.com>
References: <20221025105018.466157-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
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
tests and diagnostics.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
v1->v2: Convert to using pyroute2 for netlink messages
        Dropped Keving Sprague (since ovs-dpctl.py was rewritten)
        Re-ran flake8 and also ran black against ovs-dpctl.py

 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/net/openvswitch/Makefile        |  13 +
 .../selftests/net/openvswitch/openvswitch.sh  | 218 +++++++++++
 .../selftests/net/openvswitch/ovs-dpctl.py    | 351 ++++++++++++++++++
 5 files changed, 584 insertions(+)
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
index 000000000000..7ce46700a3ae
--- /dev/null
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -0,0 +1,218 @@
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
+	sbxname="$1"
+	shift
+	ovs_sbx "$sbxname" python3 $ovs_base/ovs-dpctl.py add-dp $*
+	on_exit "ovs_sbx $sbxname python3 $ovs_base/ovs-dpctl.py del-dp $1;"
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
+	if python3 ovs-dpctl.py -h 2>&1 | \
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
index 000000000000..3243c90d449e
--- /dev/null
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -0,0 +1,351 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+# Controls the openvswitch module.  Part of the kselftest suite, but
+# can be used for some diagnostic purpose as well.
+
+import argparse
+import errno
+import sys
+
+try:
+    from pyroute2 import NDB
+
+    from pyroute2.netlink import NLM_F_ACK
+    from pyroute2.netlink import NLM_F_REQUEST
+    from pyroute2.netlink import genlmsg
+    from pyroute2.netlink import nla
+    from pyroute2.netlink.exceptions import NetlinkError
+    from pyroute2.netlink.generic import GenericNetlinkSocket
+except ModuleNotFoundError:
+    print("Need to install the python pyroute2 package.")
+    sys.exit(0)
+
+
+OVS_DATAPATH_FAMILY = "ovs_datapath"
+OVS_VPORT_FAMILY = "ovs_vport"
+OVS_FLOW_FAMILY = "ovs_flow"
+OVS_PACKET_FAMILY = "ovs_packet"
+OVS_METER_FAMILY = "ovs_meter"
+OVS_CT_LIMIT_FAMILY = "ovs_ct_limit"
+
+OVS_DATAPATH_VERSION = 2
+OVS_DP_CMD_NEW = 1
+OVS_DP_CMD_DEL = 2
+OVS_DP_CMD_GET = 3
+OVS_DP_CMD_SET = 4
+
+OVS_VPORT_CMD_NEW = 1
+OVS_VPORT_CMD_DEL = 2
+OVS_VPORT_CMD_GET = 3
+OVS_VPORT_CMD_SET = 4
+
+
+class ovs_dp_msg(genlmsg):
+    # include the OVS version
+    # We need a custom header rather than just being able to rely on
+    # genlmsg because fields ends up not expressing everything correctly
+    # if we use the canonical example of setting fields = (('customfield',),)
+    fields = genlmsg.fields + (("dpifindex", "I"),)
+
+
+class OvsDatapath(GenericNetlinkSocket):
+
+    OVS_DP_F_VPORT_PIDS = 1 << 1
+    OVS_DP_F_DISPATCH_UPCALL_PER_CPU = 1 << 3
+
+    class dp_cmd_msg(ovs_dp_msg):
+        """
+        Message class that will be used to communicate with the kernel module.
+        """
+
+        nla_map = (
+            ("OVS_DP_ATTR_UNSPEC", "none"),
+            ("OVS_DP_ATTR_NAME", "asciiz"),
+            ("OVS_DP_ATTR_UPCALL_PID", "uint32"),
+            ("OVS_DP_ATTR_STATS", "dpstats"),
+            ("OVS_DP_ATTR_MEGAFLOW_STATS", "megaflowstats"),
+            ("OVS_DP_ATTR_USER_FEATURES", "uint32"),
+            ("OVS_DP_ATTR_PAD", "none"),
+            ("OVS_DP_ATTR_MASKS_CACHE_SIZE", "uint32"),
+            ("OVS_DP_ATTR_PER_CPU_PIDS", "array(uint32)"),
+        )
+
+        class dpstats(nla):
+            fields = (
+                ("hit", "=Q"),
+                ("missed", "=Q"),
+                ("lost", "=Q"),
+                ("flows", "=Q"),
+            )
+
+        class megaflowstats(nla):
+            fields = (
+                ("mask_hit", "=Q"),
+                ("masks", "=I"),
+                ("padding", "=I"),
+                ("cache_hits", "=Q"),
+                ("pad1", "=Q"),
+            )
+
+    def __init__(self):
+        GenericNetlinkSocket.__init__(self)
+        self.bind(OVS_DATAPATH_FAMILY, OvsDatapath.dp_cmd_msg)
+
+    def info(self, dpname, ifindex=0):
+        msg = OvsDatapath.dp_cmd_msg()
+        msg["cmd"] = OVS_DP_CMD_GET
+        msg["version"] = OVS_DATAPATH_VERSION
+        msg["reserved"] = 0
+        msg["dpifindex"] = ifindex
+        msg["attrs"].append(["OVS_DP_ATTR_NAME", dpname])
+
+        try:
+            reply = self.nlm_request(
+                msg, msg_type=self.prid, msg_flags=NLM_F_REQUEST
+            )
+            reply = reply[0]
+        except NetlinkError as ne:
+            if ne.code == errno.ENODEV:
+                reply = None
+            else:
+                raise ne
+
+        return reply
+
+    def create(self, dpname, shouldUpcall=False, versionStr=None):
+        msg = OvsDatapath.dp_cmd_msg()
+        msg["cmd"] = OVS_DP_CMD_NEW
+        if versionStr is None:
+            msg["version"] = OVS_DATAPATH_VERSION
+        else:
+            msg["version"] = int(versionStr.split(":")[0], 0)
+        msg["reserved"] = 0
+        msg["dpifindex"] = 0
+        msg["attrs"].append(["OVS_DP_ATTR_NAME", dpname])
+
+        dpfeatures = 0
+        if versionStr is not None and versionStr.find(":") != -1:
+            dpfeatures = int(versionStr.split(":")[1], 0)
+        else:
+            dpfeatures = OvsDatapath.OVS_DP_F_VPORT_PIDS
+
+        msg["attrs"].append(["OVS_DP_ATTR_USER_FEATURES", dpfeatures])
+        if not shouldUpcall:
+            msg["attrs"].append(["OVS_DP_ATTR_UPCALL_PID", 0])
+
+        try:
+            reply = self.nlm_request(
+                msg, msg_type=self.prid, msg_flags=NLM_F_REQUEST | NLM_F_ACK
+            )
+            reply = reply[0]
+        except NetlinkError as ne:
+            if ne.code == errno.EEXIST:
+                reply = None
+            else:
+                raise ne
+
+        return reply
+
+    def destroy(self, dpname):
+        msg = OvsDatapath.dp_cmd_msg()
+        msg["cmd"] = OVS_DP_CMD_DEL
+        msg["version"] = OVS_DATAPATH_VERSION
+        msg["reserved"] = 0
+        msg["dpifindex"] = 0
+        msg["attrs"].append(["OVS_DP_ATTR_NAME", dpname])
+
+        try:
+            reply = self.nlm_request(
+                msg, msg_type=self.prid, msg_flags=NLM_F_REQUEST | NLM_F_ACK
+            )
+            reply = reply[0]
+        except NetlinkError as ne:
+            if ne.code == errno.ENODEV:
+                reply = None
+            else:
+                raise ne
+
+        return reply
+
+
+class OvsVport(GenericNetlinkSocket):
+    class ovs_vport_msg(ovs_dp_msg):
+        nla_map = (
+            ("OVS_VPORT_ATTR_UNSPEC", "none"),
+            ("OVS_VPORT_ATTR_PORT_NO", "uint32"),
+            ("OVS_VPORT_ATTR_TYPE", "uint32"),
+            ("OVS_VPORT_ATTR_NAME", "asciiz"),
+            ("OVS_VPORT_ATTR_OPTIONS", "none"),
+            ("OVS_VPORT_ATTR_UPCALL_PID", "array(uint32)"),
+            ("OVS_VPORT_ATTR_STATS", "vportstats"),
+            ("OVS_VPORT_ATTR_PAD", "none"),
+            ("OVS_VPORT_ATTR_IFINDEX", "uint32"),
+            ("OVS_VPORT_ATTR_NETNSID", "uint32"),
+        )
+
+        class vportstats(nla):
+            fields = (
+                ("rx_packets", "=Q"),
+                ("tx_packets", "=Q"),
+                ("rx_bytes", "=Q"),
+                ("tx_bytes", "=Q"),
+                ("rx_errors", "=Q"),
+                ("tx_errors", "=Q"),
+                ("rx_dropped", "=Q"),
+                ("tx_dropped", "=Q"),
+            )
+
+    def type_to_str(vport_type):
+        if vport_type == 1:
+            return "netdev"
+        elif vport_type == 2:
+            return "internal"
+        elif vport_type == 3:
+            return "gre"
+        elif vport_type == 4:
+            return "vxlan"
+        elif vport_type == 5:
+            return "geneve"
+        return "unknown:%d" % vport_type
+
+    def __init__(self):
+        GenericNetlinkSocket.__init__(self)
+        self.bind(OVS_VPORT_FAMILY, OvsVport.ovs_vport_msg)
+
+    def info(self, vport_name, dpifindex=0, portno=None):
+        msg = OvsVport.ovs_vport_msg()
+
+        msg["cmd"] = OVS_VPORT_CMD_GET
+        msg["version"] = OVS_DATAPATH_VERSION
+        msg["reserved"] = 0
+        msg["dpifindex"] = dpifindex
+
+        if portno is None:
+            msg["attrs"].append(["OVS_VPORT_ATTR_NAME", vport_name])
+        else:
+            msg["attrs"].append(["OVS_VPORT_ATTR_PORT_NO", portno])
+
+        try:
+            reply = self.nlm_request(
+                msg, msg_type=self.prid, msg_flags=NLM_F_REQUEST
+            )
+            reply = reply[0]
+        except NetlinkError as ne:
+            if ne.code == errno.ENODEV:
+                reply = None
+            else:
+                raise ne
+        return reply
+
+
+def print_ovsdp_full(dp_lookup_rep, ifindex, ndb=NDB()):
+    dp_name = dp_lookup_rep.get_attr("OVS_DP_ATTR_NAME")
+    base_stats = dp_lookup_rep.get_attr("OVS_DP_ATTR_STATS")
+    megaflow_stats = dp_lookup_rep.get_attr("OVS_DP_ATTR_MEGAFLOW_STATS")
+    user_features = dp_lookup_rep.get_attr("OVS_DP_ATTR_USER_FEATURES")
+    masks_cache_size = dp_lookup_rep.get_attr("OVS_DP_ATTR_MASKS_CACHE_SIZE")
+
+    print("%s:" % dp_name)
+    print(
+        "  lookups: hit:%d missed:%d lost:%d"
+        % (base_stats["hit"], base_stats["missed"], base_stats["lost"])
+    )
+    print("  flows:%d" % base_stats["flows"])
+    pkts = base_stats["hit"] + base_stats["missed"]
+    avg = (megaflow_stats["mask_hit"] / pkts) if pkts != 0 else 0.0
+    print(
+        "  masks: hit:%d total:%d hit/pkt:%f"
+        % (megaflow_stats["mask_hit"], megaflow_stats["masks"], avg)
+    )
+    print("  caches:")
+    print("    masks-cache: size:%d" % masks_cache_size)
+
+    if user_features is not None:
+        print("  features: 0x%X" % user_features)
+
+    # port print out
+    vpl = OvsVport()
+    for iface in ndb.interfaces:
+        rep = vpl.info(iface.ifname, ifindex)
+        if rep is not None:
+            print(
+                "  port %d: %s (%s)"
+                % (
+                    rep.get_attr("OVS_VPORT_ATTR_PORT_NO"),
+                    rep.get_attr("OVS_VPORT_ATTR_NAME"),
+                    OvsVport.type_to_str(rep.get_attr("OVS_VPORT_ATTR_TYPE")),
+                )
+            )
+
+
+def main(argv):
+    parser = argparse.ArgumentParser()
+    parser.add_argument(
+        "-v",
+        "--verbose",
+        action="count",
+        help="Increment 'verbose' output counter.",
+    )
+    subparsers = parser.add_subparsers()
+
+    showdpcmd = subparsers.add_parser("show")
+    showdpcmd.add_argument(
+        "showdp", metavar="N", type=str, nargs="?", help="Datapath Name"
+    )
+
+    adddpcmd = subparsers.add_parser("add-dp")
+    adddpcmd.add_argument("adddp", help="Datapath Name")
+    adddpcmd.add_argument(
+        "-u",
+        "--upcall",
+        action="store_true",
+        help="Leave open a reader for upcalls",
+    )
+    adddpcmd.add_argument(
+        "-V",
+        "--versioning",
+        required=False,
+        help="Specify a custom version / feature string",
+    )
+
+    deldpcmd = subparsers.add_parser("del-dp")
+    deldpcmd.add_argument("deldp", help="Datapath Name")
+
+    args = parser.parse_args()
+
+    ovsdp = OvsDatapath()
+    ndb = NDB()
+
+    if hasattr(args, "showdp"):
+        found = False
+        for iface in ndb.interfaces:
+            rep = None
+            if args.showdp is None:
+                rep = ovsdp.info(iface.ifname, 0)
+            elif args.showdp == iface.ifname:
+                rep = ovsdp.info(iface.ifname, 0)
+
+            if rep is not None:
+                found = True
+                print_ovsdp_full(rep, iface.index, ndb)
+
+        if not found:
+            msg = "No DP found"
+            if args.showdp is not None:
+                msg += ":'%s'" % args.showdp
+            print(msg)
+    elif hasattr(args, "adddp"):
+        rep = ovsdp.create(args.adddp, args.upcall, args.versioning)
+        if rep is None:
+            print("DP '%s' already exists" % args.adddp)
+        else:
+            print("DP '%s' added" % args.adddp)
+    elif hasattr(args, "deldp"):
+        ovsdp.destroy(args.deldp)
+
+    return 0
+
+
+if __name__ == "__main__":
+    sys.exit(main(sys.argv))
-- 
2.34.3

