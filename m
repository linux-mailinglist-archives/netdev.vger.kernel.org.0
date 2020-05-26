Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E7C1E27AB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgEZQs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731499AbgEZQsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:48:25 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E38EC03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 09:48:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t16so8895574plo.7
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 09:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtmyfuqGTlQ/zWz9qxN+EzhJ/M4hzvfoqfhdZ74U/4k=;
        b=UKbhkhcSW2YuEjZ7ucKhVHc3DMVuZ9uMK7xRB6quJSLrdbGB7K85dwbsRyhxdClIo+
         +uRWmOB2wryK/uo5YUVsWXAbdK8OUct8gtjA753jYfNHE/ahzcZUGvdWjxM9yO9Bdf5N
         phDp7SfIAzsjMMFFaL+aw/cYmZ+9RcRi2zoiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtmyfuqGTlQ/zWz9qxN+EzhJ/M4hzvfoqfhdZ74U/4k=;
        b=P+Wra7JZ3Pc+RGZ91eMGZvrkExNarB0QDsDq2p5aY7eblLcUDctejw+E4Q1/8UdtYr
         +6sFpz4m9hEeR2zcNX4RDJiBdPBOTdrT/N7YpKWgoBPo4lrtsdoEAaH/8Ji9/7mrGbY9
         8qC0BmFgppPE4ffYcla4BX+8BZnB3q72CPmw3g2e7RconOrc5xIO4AVmFAiEa1AYaSrI
         c3w6VopC71yOV9pK/01JE8wdB5AMJYNN7Ono5O0LJoP12Gu9YzazrSqj23I8zQJy3vIp
         qHe+4nigMS0l/UEoBwhwjNBgKOotSBwkDTQxqLX84nEQp72mOf7T+zlz/YYOMkpvsGAl
         /Ojw==
X-Gm-Message-State: AOAM531THkiMfbRJkOb/vSiEouvIitUHiiwzOjL/c/sW9OjwPBwYxUaJ
        eBDsu5qPI52nncbc56drnkahxJD7Y6Y=
X-Google-Smtp-Source: ABdhPJw3Fnipeso7DXtoTmmLj9s6Xk0ZYOdgtPhYtX8Re3P8DHOEGT4n84RAlCt16K9Xi/IMHE51Mw==
X-Received: by 2002:a17:902:9a08:: with SMTP id v8mr1894672plp.90.1590511704434;
        Tue, 26 May 2020 09:48:24 -0700 (PDT)
Received: from alfred.cumulusnetworks.com ([216.129.126.119])
        by smtp.gmail.com with ESMTPSA id y138sm101871pfb.33.2020.05.26.09.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 09:48:23 -0700 (PDT)
From:   Stephen Worley <sworley@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, davem@davemloft.net, sworley1995@gmail.com,
        Stephen Worley <sworley@cumulusnetworks.com>
Subject: [PATCH] net-next: add large ecmp group nexthop tests
Date:   Tue, 26 May 2020 12:48:04 -0400
Message-Id: <20200526164804.477124-1-sworley@cumulusnetworks.com>
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
index 6560ed796ac4..41635859d245 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -19,8 +19,8 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime"
+IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp"
+IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp"
 
 ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
 TESTS="${ALL_TESTS}"
@@ -253,6 +253,60 @@ check_route6()
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
 ################################################################################
 # basic operations (add, delete, replace) on nexthops and nexthop groups
 #
@@ -519,6 +573,19 @@ ipv6_fcnal_runtime()
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
@@ -880,6 +947,19 @@ ipv4_fcnal_runtime()
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
 basic()
 {
 	echo

base-commit: 1a6da4fcdd02d5cb2c1deaec1a5cc2b06efd2a4d
-- 
2.26.2

