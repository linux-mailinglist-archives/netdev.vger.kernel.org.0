Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B127467064
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378074AbhLCDCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:02:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:57249 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347836AbhLCDCk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 22:02:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="260901968"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="260901968"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:59:16 -0800
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="501015283"
Received: from liweilv-mobl.ccr.corp.intel.com (HELO lkp-bingo.fnst-test.com) ([10.255.30.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:59:13 -0800
From:   Li Zhijian <zhijianx.li@intel.com>
To:     kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizhijian@cn.fujitsu.com,
        Li Zhijian <zhijianx.li@intel.com>
Subject: [PATCH v3 3/3] selftests/tc-testing: Fix cannot create /sys/bus/netdevsim/new_device: Directory nonexistent
Date:   Fri,  3 Dec 2021 10:53:23 +0800
Message-Id: <20211203025323.6052-3-zhijianx.li@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203025323.6052-1-zhijianx.li@intel.com>
References: <20211203025323.6052-1-zhijianx.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Install netdevsim to provide /sys/bus/netdevsim/new_device interface.

It helps to fix:
 # ok 97 9a7d - Change ETS strict band without quantum # skipped - skipped - previous setup failed 11 ce7d
 #
 #
 # -----> prepare stage *** Could not execute: "echo "1 1 4" > /sys/bus/netdevsim/new_device"
 #
 # -----> prepare stage *** Error message: "/bin/sh: 1: cannot create /sys/bus/netdevsim/new_device: Directory nonexistent
 # "
 #
 # -----> prepare stage *** Aborting test run.
 #
 #
 # <_io.BufferedReader name=5> *** stdout ***
 #

Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
---
 tools/testing/selftests/tc-testing/config | 1 +
 tools/testing/selftests/tc-testing/tdc.sh | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index b1cd7efa4512..a3239d5e40c7 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -61,6 +61,7 @@ CONFIG_NET_SCH_FIFO=y
 CONFIG_NET_SCH_ETS=m
 CONFIG_NET_SCH_RED=m
 CONFIG_NET_SCH_FQ_PIE=m
+CONFIG_NETDEVSIM=m
 
 #
 ## Network testing
diff --git a/tools/testing/selftests/tc-testing/tdc.sh b/tools/testing/selftests/tc-testing/tdc.sh
index 7fe38c76db44..afb0cd86fa3d 100755
--- a/tools/testing/selftests/tc-testing/tdc.sh
+++ b/tools/testing/selftests/tc-testing/tdc.sh
@@ -1,5 +1,6 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+modprobe netdevsim
 ./tdc.py -c actions --nobuildebpf
 ./tdc.py -c qdisc
-- 
2.32.0

