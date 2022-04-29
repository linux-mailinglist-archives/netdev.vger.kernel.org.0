Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4855157C4
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381249AbiD2WFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381190AbiD2WFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:05:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F0DC5A8;
        Fri, 29 Apr 2022 15:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651269731; x=1682805731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+FuImKOJOtYzqv/FixcaUvgSqdHmeQHXTS1C2ZFwjaY=;
  b=St9XlFRIBZFhwAnQq/uTw88GRuh58IbFtpMEWXa07Xuczn14kqGSjiCU
   8CBblEOlZu5nQgAb+gQgFUdSLxknpXOegJWfHAwew5UyUV6kL53MScziD
   hlUGuRWlNWElZz8SohLI6X1ELjHEwt6DFbuG2rpeBJ5oc4lHIcLQOR2zi
   7+iqeIdvAEaRf8A71fSTHqwlX/pWdnudr0rd5RvXG2NLAVDfmx3ErOU/E
   As9Rq7DxGHvre+Theqi3YQ2mEzQYN99gddKIgh/1iq1ubsIlDVHzkTp/G
   Q6rpHufMn02JcQaBag6Qx0b2Q06clI7i1ZTMxvE523lthDj19hkj7o17K
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="266609690"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="266609690"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582419799"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.217.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v2 3/8] selftests: bpf: Enable CONFIG_IKCONFIG_PROC in config
Date:   Fri, 29 Apr 2022 15:01:59 -0700
Message-Id: <20220429220204.353225-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429220204.353225-1-mathew.j.martineau@linux.intel.com>
References: <20220429220204.353225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

CONFIG_IKCONFIG_PROC is required by BPF selftests, otherwise we get
errors like this:

 libbpf: failed to open system Kconfig
 libbpf: failed to load object 'kprobe_multi'
 libbpf: failed to load BPF skeleton 'kprobe_multi': -22

It's because /proc/config.gz is opened in bpf_object__read_kconfig_file()
in tools/lib/bpf/libbpf.c:

        file = gzopen("/proc/config.gz", "r");

So this patch enables CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC in
tools/testing/selftests/bpf/config.

Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/bpf/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 763db63a3890..8d7faff33c54 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -53,3 +53,5 @@ CONFIG_NF_DEFRAG_IPV4=y
 CONFIG_NF_DEFRAG_IPV6=y
 CONFIG_NF_CONNTRACK=y
 CONFIG_USERFAULTFD=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
-- 
2.36.0

