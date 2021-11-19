Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF5456A34
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhKSGcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:32:03 -0500
Received: from mga17.intel.com ([192.55.52.151]:19701 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSGcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:32:03 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="215079468"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="215079468"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:29:01 -0800
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="507780013"
Received: from wuqiming-mobl.ccr.corp.intel.com (HELO lkp-bingo.fnst-test.com) ([10.255.28.64])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:28:54 -0800
From:   Li Zhijian <zhijianx.li@intel.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        peilin.ye@bytedance.com, cong.wang@bytedance.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, philip.li@intel.com,
        lizhijian@cn.fujitsu.com, Li Zhijian <zhijianx.li@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/2] selftests/tc-testing: match any qdisc type
Date:   Fri, 19 Nov 2021 14:24:56 +0800
Message-Id: <20211119062457.16668-1-zhijianx.li@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not always presume all kernels use pfifo_fast as the default qdisc.

For example, a fq_codel qdisk could have below output:
qdisc fq_codel 0: parent 1:4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
---
 .../selftests/tc-testing/tc-tests/qdiscs/mq.json     | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
index 88a20c781e49..c6046096d9db 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
@@ -15,7 +15,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "0",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "4",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -37,7 +37,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "0",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-9,a-f][0-9,a-f]{0,2} bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-9,a-f][0-9,a-f]{0,2}",
 	    "matchCount": "256",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -60,7 +60,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "4",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -82,7 +82,7 @@
 	    "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "0",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -106,7 +106,7 @@
 	    "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "0",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
@@ -128,7 +128,7 @@
 	    "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
 	    "expExitCode": "2",
 	    "verifyCmd": "$TC qdisc show dev $ETH",
-	    "matchPattern": "qdisc pfifo_fast 0: parent 1:[1-4] bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1",
+	    "matchPattern": "qdisc [a-zA-Z0-9_]+ 0: parent 1:[1-4]",
 	    "matchCount": "0",
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
-- 
2.32.0

