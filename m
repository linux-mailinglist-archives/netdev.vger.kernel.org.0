Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD25E66AFA1
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjAOHRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjAOHQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:16:36 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EE9B46C;
        Sat, 14 Jan 2023 23:16:27 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 141so17650402pgc.0;
        Sat, 14 Jan 2023 23:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4I4IUYD2iUsel0bQWxcWEZ0X528rvr4lKqvUrGey0z4=;
        b=gsIUMdxCZ3YBLETWAp/bgHB/ej7qfLcbPkqlrklttjIg4r9fMF8VvSgZcqR6U/M1bu
         O9jSXCwbXQc9jp8bwJggqMS0GzKfFFAaiC1hnLmraa8w0S6ZdnUVHFbPTonAulkL5YEd
         0fySb/+hhhymkgoOurlsHSuPx+bfRbyFsKw03nb1EMcIVJgrKcI3b4Q1TdrfD8pk2f9u
         9PfGQTX6YCZmCIaTueuCdviqkEKrarMBusVWWLhwjrACoTh/lF2/KxXM/3Qd4vZawiyc
         6LodKm3V/YLw7B8c9LMgQbrt8HZR0iNJacL4s2j9mfn7AaWjsWv0neFzmcs9oEA+Vxkb
         rT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4I4IUYD2iUsel0bQWxcWEZ0X528rvr4lKqvUrGey0z4=;
        b=qQwPJpGo/K59Iw1llwlQc/7sLol7TO2mDhpiPSJZP3zMZ7lr1B+8rktlkhtooDmMgI
         CP49eRXsK4As30ad7jmzIJOiCbA5Vm3czLtjCNo2ejRAXz0ondi4aE/NZmC9ukfzrCQZ
         oTtKgFs8HhK80tdMz/vxFUO1SfMSjPp6CvwD2QmEdXvyUIjQVK0YZi/JVD+YWLgU9PWE
         Ok4YUAxzEnBhw5YuZ9Jpk0QNMOVo2lUrqnxK+O1+wNhna/+ORuX/n+cs69+fEuFHuKFH
         tUikOL36oyEMzKQYCKcK7EQ35ZhZotGwggkTUDVbFxWpfEBu+DON04GgU9MBlPuSzhHM
         Wsdw==
X-Gm-Message-State: AFqh2kq/SOFq9VQF2oTa7FltR9+w6GUTZyQl5XGVZ9M5kgI9RvzKxkP/
        4EFhPwANCXm3hPoeMuM5aw==
X-Google-Smtp-Source: AMrXdXubzKttbngkWL7N9qBggK46A7Q73hVWTw1G5sM+FvtwF6Wh89SuB5qipnPB0Ex6FejF/tRxCw==
X-Received: by 2002:aa7:8d4a:0:b0:578:333d:d6ab with SMTP id s10-20020aa78d4a000000b00578333dd6abmr83634589pfe.21.1673766986925;
        Sat, 14 Jan 2023 23:16:26 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:26 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 02/10] samples/bpf: refactor BPF functionality testing scripts
Date:   Sun, 15 Jan 2023 16:16:05 +0900
Message-Id: <20230115071613.125791-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, some test scripts are experiencing minor errors related to
executing tests.

    $ sudo ./test_cgrp2_sock.sh
    ./test_cgrp2_sock.sh: 22: test_cgrp2_sock: not found

This problem occurs because the path to the execution target is not
properly specified. Therefore, this commit solves this problem by
specifying a relative path to its executables. This commit also makes
a concise refactoring of hard-coded BPF program names.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/lwt_len_hist.sh     |  4 ++--
 samples/bpf/test_cgrp2_sock.sh  | 16 +++++++++-------
 samples/bpf/test_cgrp2_sock2.sh |  5 ++++-
 samples/bpf/test_cgrp2_tc.sh    |  4 ++--
 samples/bpf/test_lwt_bpf.sh     |  8 +++++---
 5 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/samples/bpf/lwt_len_hist.sh b/samples/bpf/lwt_len_hist.sh
index 0eda9754f50b..ff7d1ba0f7ed 100755
--- a/samples/bpf/lwt_len_hist.sh
+++ b/samples/bpf/lwt_len_hist.sh
@@ -4,7 +4,7 @@
 NS1=lwt_ns1
 VETH0=tst_lwt1a
 VETH1=tst_lwt1b
-
+BPF_PROG=lwt_len_hist_kern.o
 TRACE_ROOT=/sys/kernel/debug/tracing
 
 function cleanup {
@@ -30,7 +30,7 @@ ip netns exec $NS1 netserver
 
 echo 1 > ${TRACE_ROOT}/tracing_on
 cp /dev/null ${TRACE_ROOT}/trace
-ip route add 192.168.253.2/32 encap bpf out obj lwt_len_hist_kern.o section len_hist dev $VETH0
+ip route add 192.168.253.2/32 encap bpf out obj $BPF_PROG section len_hist dev $VETH0
 netperf -H 192.168.253.2 -t TCP_STREAM
 cat ${TRACE_ROOT}/trace | grep -v '^#'
 ./lwt_len_hist
diff --git a/samples/bpf/test_cgrp2_sock.sh b/samples/bpf/test_cgrp2_sock.sh
index 9f6174236856..36bd7cb46f06 100755
--- a/samples/bpf/test_cgrp2_sock.sh
+++ b/samples/bpf/test_cgrp2_sock.sh
@@ -3,6 +3,8 @@
 
 # Test various socket options that can be set by attaching programs to cgroups.
 
+MY_DIR=$(dirname $0)
+TEST=$MY_DIR/test_cgrp2_sock
 CGRP_MNT="/tmp/cgroupv2-test_cgrp2_sock"
 
 ################################################################################
@@ -19,7 +21,7 @@ print_result()
 
 check_sock()
 {
-	out=$(test_cgrp2_sock)
+	out=$($TEST)
 	echo $out | grep -q "$1"
 	if [ $? -ne 0 ]; then
 		print_result 1 "IPv4: $2"
@@ -33,7 +35,7 @@ check_sock()
 
 check_sock6()
 {
-	out=$(test_cgrp2_sock -6)
+	out=$($TEST -6)
 	echo $out | grep -q "$1"
 	if [ $? -ne 0 ]; then
 		print_result 1 "IPv6: $2"
@@ -61,7 +63,7 @@ cleanup_and_exit()
 
 	[ -n "$msg" ] && echo "ERROR: $msg"
 
-	test_cgrp2_sock -d ${CGRP_MNT}/sockopts
+	$TEST -d ${CGRP_MNT}/sockopts
 	ip li del cgrp2_sock
 	umount ${CGRP_MNT}
 
@@ -98,7 +100,7 @@ check_sock6 "dev , mark 0, priority 0" "No programs attached"
 
 # verify device is set
 #
-test_cgrp2_sock -b cgrp2_sock ${CGRP_MNT}/sockopts
+$TEST -b cgrp2_sock ${CGRP_MNT}/sockopts
 if [ $? -ne 0 ]; then
 	cleanup_and_exit 1 "Failed to install program to set device"
 fi
@@ -107,7 +109,7 @@ check_sock6 "dev cgrp2_sock, mark 0, priority 0" "Device set"
 
 # verify mark is set
 #
-test_cgrp2_sock -m 666 ${CGRP_MNT}/sockopts
+$TEST -m 666 ${CGRP_MNT}/sockopts
 if [ $? -ne 0 ]; then
 	cleanup_and_exit 1 "Failed to install program to set mark"
 fi
@@ -116,7 +118,7 @@ check_sock6 "dev , mark 666, priority 0" "Mark set"
 
 # verify priority is set
 #
-test_cgrp2_sock -p 123 ${CGRP_MNT}/sockopts
+$TEST -p 123 ${CGRP_MNT}/sockopts
 if [ $? -ne 0 ]; then
 	cleanup_and_exit 1 "Failed to install program to set priority"
 fi
@@ -125,7 +127,7 @@ check_sock6 "dev , mark 0, priority 123" "Priority set"
 
 # all 3 at once
 #
-test_cgrp2_sock -b cgrp2_sock -m 666 -p 123 ${CGRP_MNT}/sockopts
+$TEST -b cgrp2_sock -m 666 -p 123 ${CGRP_MNT}/sockopts
 if [ $? -ne 0 ]; then
 	cleanup_and_exit 1 "Failed to install program to set device, mark and priority"
 fi
diff --git a/samples/bpf/test_cgrp2_sock2.sh b/samples/bpf/test_cgrp2_sock2.sh
index ac45828ed2bd..00cc8d15373c 100755
--- a/samples/bpf/test_cgrp2_sock2.sh
+++ b/samples/bpf/test_cgrp2_sock2.sh
@@ -2,7 +2,10 @@
 # SPDX-License-Identifier: GPL-2.0
 
 BPFFS=/sys/fs/bpf
+MY_DIR=$(dirname $0)
+TEST=$MY_DIR/test_cgrp2_sock2
 LINK_PIN=$BPFFS/test_cgrp2_sock2
+BPF_PROG=$MY_DIR/sock_flags_kern.o
 
 function config_device {
 	ip netns add at_ns0
@@ -36,7 +39,7 @@ function config_bpffs {
 }
 
 function attach_bpf {
-	./test_cgrp2_sock2 /tmp/cgroupv2/foo sock_flags_kern.o $1
+	$TEST /tmp/cgroupv2/foo $BPF_PROG $1
 	[ $? -ne 0 ] && exit 1
 }
 
diff --git a/samples/bpf/test_cgrp2_tc.sh b/samples/bpf/test_cgrp2_tc.sh
index a6f1ed03ddf6..37a2c9cba6d0 100755
--- a/samples/bpf/test_cgrp2_tc.sh
+++ b/samples/bpf/test_cgrp2_tc.sh
@@ -76,8 +76,8 @@ setup_net() {
 	    sysctl -q net.ipv6.conf.$HOST_IFC.disable_ipv6=0
 	    sysctl -q net.ipv6.conf.$HOST_IFC.accept_dad=0
 
-	    $IP netns add ns || return $?
-	    $IP link set dev $NS_IFC netns ns || return $?
+	    $IP netns add $NS || return $?
+	    $IP link set dev $NS_IFC netns $NS || return $?
 	    $IP -n $NS link set dev $NS_IFC up || return $?
 	    $IP netns exec $NS sysctl -q net.ipv6.conf.$NS_IFC.disable_ipv6=0
 	    $IP netns exec $NS sysctl -q net.ipv6.conf.$NS_IFC.accept_dad=0
diff --git a/samples/bpf/test_lwt_bpf.sh b/samples/bpf/test_lwt_bpf.sh
index 65a976058dd3..8fc9356545d8 100755
--- a/samples/bpf/test_lwt_bpf.sh
+++ b/samples/bpf/test_lwt_bpf.sh
@@ -19,6 +19,8 @@ IPVETH3="192.168.111.2"
 
 IP_LOCAL="192.168.99.1"
 
+PROG_SRC="test_lwt_bpf.c"
+BPF_PROG="test_lwt_bpf.o"
 TRACE_ROOT=/sys/kernel/debug/tracing
 
 function lookup_mac()
@@ -36,7 +38,7 @@ function lookup_mac()
 
 function cleanup {
 	set +ex
-	rm test_lwt_bpf.o 2> /dev/null
+	rm $BPF_PROG 2> /dev/null
 	ip link del $VETH0 2> /dev/null
 	ip link del $VETH1 2> /dev/null
 	ip link del $VETH2 2> /dev/null
@@ -76,7 +78,7 @@ function install_test {
 	cleanup_routes
 	cp /dev/null ${TRACE_ROOT}/trace
 
-	OPTS="encap bpf headroom 14 $1 obj test_lwt_bpf.o section $2 $VERBOSE"
+	OPTS="encap bpf headroom 14 $1 obj $BPF_PROG section $2 $VERBOSE"
 
 	if [ "$1" == "in" ];  then
 		ip route add table local local ${IP_LOCAL}/32 $OPTS dev lo
@@ -374,7 +376,7 @@ DST_IFINDEX=$(cat /sys/class/net/$VETH0/ifindex)
 
 CLANG_OPTS="-O2 -target bpf -I ../include/"
 CLANG_OPTS+=" -DSRC_MAC=$SRC_MAC -DDST_MAC=$DST_MAC -DDST_IFINDEX=$DST_IFINDEX"
-clang $CLANG_OPTS -c test_lwt_bpf.c -o test_lwt_bpf.o
+clang $CLANG_OPTS -c $PROG_SRC -o $BPF_PROG
 
 test_ctx_xmit
 test_ctx_out
-- 
2.34.1

