Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C88B1C4995
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgEDW2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728209AbgEDW2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:28:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5E5C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:28:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x2so43235pfx.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cJMf+LX27V0WOkoHK5RGaB2GQBlawx8Eb3REqvDLDB4=;
        b=QsxAHavd8yvDbL3M5530ckQor0EdXeE2vVeU8CIQNhJidSOe+kyZ+8WioO7G1yP40N
         pPQJ5IBxGJTZtr2Czrb9LiFsO0jxy49ADdSWXSHCmfHSJclMqcypXMxfOWNe5Gi3siyM
         wOCz1n5XoZVPXzh4wXHledSjWUw5rTQelNgBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cJMf+LX27V0WOkoHK5RGaB2GQBlawx8Eb3REqvDLDB4=;
        b=QGZQYpcweOBiLZomlNwrjcq1+Dl4NlDL+dyPnTDOD7gn7AqHIvRpy3Acs4mwXZBHno
         jll61lBU7K20expdTifR977zReFfHvaqfGaNJ/xuBC268aOAiMUCW4nbUOc63FbSv7k8
         KR0U0Zpq+JTWL9/NbZjNkt0wQB3HIruFnrB8ClDfhkCw/pWodtAzLP+GDHLCPdkG6HUC
         IVH83eAdPvsXmR5cJOcdgv3nSYqWCYFiTBcLvf70sVk+UScq7HG3xFH1ovRzp3ehB1AG
         x3FH7ZsPWdCkZpiklBwPt6Bdd3w6S2BozBSj7tgMcmUtYJNW4F5l6EOH7txA1xYt9oIk
         QUdQ==
X-Gm-Message-State: AGi0PuYzFE4ITJC5Ni9Ctr8RnAA4DtHh/XQAoyosD8eK0c9Wdxsx9PRJ
        K/f2SExfJJ4ybbiZ74WCFumvZQ==
X-Google-Smtp-Source: APiQypIY4sip9Nop/tyjabJRPSZ87Xg62stSblYKAByUm1mMCdKDrKnKjKzrr6jC6mCVh+wiYA+GXg==
X-Received: by 2002:a63:742:: with SMTP id 63mr391552pgh.33.1588631314574;
        Mon, 04 May 2020 15:28:34 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id ie17sm21213pjb.19.2020.05.04.15.28.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 15:28:33 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
Subject: [RFC PATCH net-next 5/5] selftests: net: add fdb nexthop tests
Date:   Mon,  4 May 2020 15:28:21 -0700
Message-Id: <1588631301-21564-6-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This commit adds ipv4 and ipv6 basic fdb tests to fib_nexthops.sh.
Started with a separate test script for fdb nexthops but seems like
its better for basic tests to live in fib_nexthops.sh for overall
nexthop API coverage.

TODO:
- runtime vxlan fdb tests: Its best to add test similar
to the forwarding/vxlan_symmetric.sh test (WIP at the moment. Any
suggestions welcome. Plan to include it in the non-RFC version)

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 77 ++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index dd0e5fe..41bce6c 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -19,8 +19,8 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode"
+IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode ipv4_fdb_grp_fcnal"
+IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode ipv6_fdb_grp_fcnal"
 
 ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
 TESTS="${ALL_TESTS}"
@@ -146,6 +146,7 @@ setup()
 	create_ns remote
 
 	IP="ip -netns me"
+	BRIDGE="bridge -netns me"
 	set -e
 	$IP li add veth1 type veth peer name veth2
 	$IP li set veth1 up
@@ -280,6 +281,78 @@ stop_ip_monitor()
 	return $rc
 }
 
+check_nexthop_fdb_support()
+{
+	$IP nexthop help 2>&1 | grep -q fdb
+	if [ $? -ne 0 ]; then
+		echo "SKIP: iproute2 too old, missing fdb nexthop support"
+		exit $ksft_skip
+	fi
+}
+
+ipv6_fdb_grp_fcnal()
+{
+	local rc
+
+	echo
+	echo "IPv6 fdb groups functional"
+	echo "--------------------------"
+
+	check_nexthop_fdb_support
+
+	# basic functionality: create a fdb nexthop group, default weight
+	run_cmd "$IP nexthop add id 61 via 2001:db8:91::2 fdb"
+	run_cmd "$IP nexthop add id 62 via 2001:db8:91::3 fdb"
+	run_cmd "$IP nexthop add id 101 group 61/62 fdb"
+	log_test $? 0 "Create nexthop group with single nexthop"
+
+	# get nexthop group
+	run_cmd "$IP nexthop get id 101"
+	log_test $? 0 "Get nexthop group by id"
+	check_nexthop "id 101" "id 101 group 61/62 fdb"
+
+	$IP link add name vx10 type vxlan id 1010 local 10.0.0.1 remote 10.0.0.2 dstport 4789 nolearning noudpcsum tos inherit ttl 100
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:12 dev vx10 nhid 101 self"
+	log_test $? 0 "Fdb mac add with nexthop"
+
+	run_cmd "$IP nexthop del id 101"
+	log_test $? 0 "Fdb nexthop delete"
+
+	$IP link del dev vx10
+}
+
+ipv4_fdb_grp_fcnal()
+{
+	local rc
+
+	echo
+	echo "IPv4 fdb groups functional"
+	echo "--------------------------"
+
+	check_nexthop_fdb_support
+
+	# create group with multiple nexthops
+	run_cmd "$IP nexthop add id 12 via 172.16.1.2 fdb"
+	run_cmd "$IP nexthop add id 13 via 172.16.1.3 fdb"
+	run_cmd "$IP nexthop add id 102 group 12/13 fdb"
+	log_test $? 0 "Nexthop group with multiple nexthops"
+	check_nexthop "id 102" "id 102 group 12/13"
+
+	# get nexthop group
+	run_cmd "$IP nexthop get id 102"
+	log_test $? 0 "Get nexthop group by id"
+	check_nexthop "id 102" "id 102 group 12/13 fdb"
+
+	run_cmd "$IP link add name vx10 type vxlan id 1010 local 10.0.0.1 remote 10.0.0.2 dstport 4789 nolearning noudpcsum tos inherit ttl 100"
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:13 dev vx10 nhid 102 self"
+	log_test $? 0 "Fdb mac add with nexthop"
+
+	run_cmd "$IP nexthop del id 102"
+	log_test $? 0 "Fdb nexthop delete"
+
+	$IP link del dev vx10
+}
+
 ################################################################################
 # basic operations (add, delete, replace) on nexthops and nexthop groups
 #
-- 
2.1.4

