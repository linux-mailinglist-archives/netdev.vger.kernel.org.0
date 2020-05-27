Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118D51E4A92
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391342AbgE0Qmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390729AbgE0Qme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:42:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56150C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:42:34 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id e11so11086536pfn.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JIF7v1WChr+BTVMRZm4F04l1in0YhHw2Q6aVok5z4FA=;
        b=XbI8lnG2LJ2OhBOO5/Rifzc3DelQXL0rSVgVdaQjQ3Ze9kQ4/vHJKcjg+RNJmmHrf+
         T4Xlcv3uz0Up2I6iy9VHXVq0WfBNazetlXR80Jmv0IgrLJTxFK89l2Sdg9Ise8c8UVgz
         m8VjmY8K8fKh0nD0COeixWED98aM4rHckGOEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JIF7v1WChr+BTVMRZm4F04l1in0YhHw2Q6aVok5z4FA=;
        b=PUFh6VmrSDXfy0F84anJnK2jzv+xcsEg6pP1/CCZA8aHfmJwRqrinXkUbyXDZPnrOV
         PtCFRnsKLBfPZW/zo6p55LM/KGizedxpX72H5vETBic1ESwz8FLLYAyPmMwB3huAAaaf
         P9QlilILH9uz8tWMz3Tgqt2dXHJ1qO9K9ni08xRhq0050gmrAap2z7W5X6SGaRuyRzKF
         QvqvnsiunqwjitQuazQLT2x7HWe1TvPeC/sd8EOsPE6+bITikEbxIdwVijOt93L5tYGB
         zi8fTT5tSPbcSHfE4Onx/9Nox53u/yKhoAgq8ohmYQkDCLvhetC7yMht1UmUjNq9g+cr
         avaQ==
X-Gm-Message-State: AOAM53138DlS4ThMI+ZS0dOFhjuH+X3g0H2Rl1tGynpgJtl9UXYonmTA
        p2ChLkV3EOrSNKQfRDEg+5Kha5oOLRQ=
X-Google-Smtp-Source: ABdhPJyTMn2mYKF1MHCkfXUYZYr2OXH7g0LNYBbQTJ1/uDEhytaFjZUK8l0cQUjF75WoyGGCZGRe/g==
X-Received: by 2002:a63:5644:: with SMTP id g4mr4618659pgm.381.1590597753218;
        Wed, 27 May 2020 09:42:33 -0700 (PDT)
Received: from alfred.cumulusnetworks.com ([216.129.126.119])
        by smtp.gmail.com with ESMTPSA id f23sm3234189pjt.13.2020.05.27.09.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:42:32 -0700 (PDT)
From:   Stephen Worley <sworley@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, davem@davemloft.net, sworley1995@gmail.com,
        Stephen Worley <sworley@cumulusnetworks.com>
Subject: [PATCH v2 net-next] net: add large ecmp group nexthop tests
Date:   Wed, 27 May 2020 12:41:42 -0400
Message-Id: <20200527164142.1356955-1-sworley@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple large ecmp group nexthop selftests to cover
the remnant fixed by d69100b8eee27c2d60ee52df76e0b80a8d492d34.

The tests create 100 x32 ecmp groups of ipv4 and ipv6 and then
dump them. On kernels without the fix, they will fail due
to data remnant during the dump.

Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 84 ++++++++++++++++++++-
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 51f8e9afe6ae..1e2f61262e4e 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -19,8 +19,8 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode ipv4_fdb_grp_fcnal"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode ipv6_fdb_grp_fcnal"
+IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal"
+IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal"
 
 ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
 TESTS="${ALL_TESTS}"
@@ -254,6 +254,60 @@ check_route6()
 	check_output "${out}" "${expected}"
 }
 
+check_large_grp()
+{
+	local ipv=$1
+	local ecmp=$2
+	local grpnum=100
+	local nhidstart=100
+	local grpidstart=1000
+	local iter=0
+	local nhidstr=""
+	local grpidstr=""
+	local grpstr=""
+	local ipstr=""
+
+	if [ $ipv -eq 4 ]; then
+		ipstr="172.16.1."
+	else
+		ipstr="2001:db8:91::"
+	fi
+
+	#
+	# Create $grpnum groups with specified $ecmp and dump them
+	#
+
+	# create nexthops with different gateways
+	iter=2
+	while [ $iter -le $(($ecmp + 1)) ]
+	do
+		nhidstr="$(($nhidstart + $iter))"
+		run_cmd "$IP nexthop add id $nhidstr via $ipstr$iter dev veth1"
+		check_nexthop "id $nhidstr" "id $nhidstr via $ipstr$iter dev veth1 scope link"
+
+		if [ $iter -le $ecmp ]; then
+			grpstr+="$nhidstr/"
+		else
+			grpstr+="$nhidstr"
+		fi
+		((iter++))
+	done
+
+	# create duplicate large ecmp groups
+	iter=0
+	while [ $iter -le $grpnum ]
+	do
+		grpidstr="$(($grpidstart + $iter))"
+		run_cmd "$IP nexthop add id $grpidstr group $grpstr"
+		check_nexthop "id $grpidstr" "id $grpidstr group $grpstr"
+		((iter++))
+	done
+
+	# dump large groups
+	run_cmd "$IP nexthop list"
+	log_test $? 0 "Dump large (x$ecmp) ecmp groups"
+}
+
 start_ip_monitor()
 {
 	local mtype=$1
@@ -700,6 +754,19 @@ ipv6_fcnal_runtime()
 	# route with src address and using nexthop - not allowed
 }
 
+ipv6_large_grp()
+{
+	local ecmp=32
+
+	echo
+	echo "IPv6 large groups (x$ecmp)"
+	echo "---------------------"
+
+	check_large_grp 6 $ecmp
+
+	$IP nexthop flush >/dev/null 2>&1
+}
+
 ipv4_fcnal()
 {
 	local rc
@@ -1066,6 +1133,19 @@ ipv4_fcnal_runtime()
 	log_test $? 0 "IPv4 route with MPLS encap, v6 gw - check"
 }
 
+ipv4_large_grp()
+{
+	local ecmp=32
+
+	echo
+	echo "IPv4 large groups (x$ecmp)"
+	echo "---------------------"
+
+	check_large_grp 4 $ecmp
+
+	$IP nexthop flush >/dev/null 2>&1
+}
+
 sysctl_nexthop_compat_mode_check()
 {
 	local sysctlname="net.ipv4.nexthop_compat_mode"

base-commit: dc0f3ed1973f101508957b59e529e03da1349e09
-- 
2.26.2

