Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA67456A3A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhKSGcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:32:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:24755 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSGcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:32:09 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="214394774"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="214394774"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:29:07 -0800
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="507780038"
Received: from wuqiming-mobl.ccr.corp.intel.com (HELO lkp-bingo.fnst-test.com) ([10.255.28.64])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 22:29:01 -0800
From:   Li Zhijian <zhijianx.li@intel.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        peilin.ye@bytedance.com, cong.wang@bytedance.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, philip.li@intel.com,
        lizhijian@cn.fujitsu.com, Li Zhijian <zhijianx.li@intel.com>
Subject: [PATCH 2/2] selftests/tc-testings: Be compatible with newer tc output
Date:   Fri, 19 Nov 2021 14:24:57 +0800
Message-Id: <20211119062457.16668-2-zhijianx.li@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119062457.16668-1-zhijianx.li@intel.com>
References: <20211119062457.16668-1-zhijianx.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

old tc(iproute2-5.9.0) output:
 action order 1: bpf action.o:[action-ok] id 60 tag bcf7977d3b93787c jited default-action pipe
newer tc(iproute2-5.14.0) output:
 action order 1: bpf action.o:[action-ok] id 64 name tag bcf7977d3b93787c jited default-action pipe

It can fix below errors:
 # ok 260 f84a - Add cBPF action with invalid bytecode
 # not ok 261 e939 - Add eBPF action with valid object-file
 #       Could not match regex pattern. Verify command output:
 # total acts 0
 #
 #       action order 1: bpf action.o:[action-ok] id 42 name  tag bcf7977d3b93787c jited default-action pipe
 #        index 667 ref 1 bind 0

Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
---
 tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
index 503982b8f295..91832400ddbd 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
@@ -68,7 +68,7 @@
         "cmdUnderTest": "$TC action add action bpf object-file $EBPFDIR/action.o section action-ok index 667",
         "expExitCode": "0",
         "verifyCmd": "$TC action get action bpf index 667",
-        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ok\\] id [0-9]* tag [0-9a-f]{16}( jited)? default-action pipe.*index 667 ref",
+        "matchPattern": "action order [0-9]*: bpf action.o:\\[action-ok\\] id [0-9].* tag [0-9a-f]{16}( jited)? default-action pipe.*index 667 ref",
         "matchCount": "1",
         "teardown": [
             "$TC action flush action bpf"
-- 
2.32.0

