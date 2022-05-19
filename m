Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A167752E08F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343601AbiESXaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343550AbiESXaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:30:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0520C108A94;
        Thu, 19 May 2022 16:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653003022; x=1684539022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fpbu7J+T3sEY5KzKGDHOZcdSlNTcq4FmV5F0zYAzn2c=;
  b=nJ/ORpCTQ+oYPuwVv/WsHvciamTghyvXzVkkNEe6xubqincrW1yGUaRf
   w3aUp1HWUcEsypVa76bzs8AypJLyJSLAgRz7CX4t7Xq0okpuDW5LajgGb
   ixFu49KcYBSIYwa39Z5/K2JjF9OLlb+rE37PVfsU+RGDCe8YEur8uvDVw
   bB5YsFkO8U02Lqoga4279C9DAJNzbigAoV5byXVNc7orFJuyCtG1nN6g4
   O5IyzkfXtm6mrT5GKz47pvoQqWGKJzyWtauqLmqGW5xUNrDwxG+ATMTtQ
   ulRZH9wJDMH6PpCE3r/SS8ss4MaZn2GMT8F3C8jeOBDy7g1UwdLC79AZ2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272547198"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272547198"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570491195"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.132.179])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH bpf-next v5 2/7] selftests/bpf: Enable CONFIG_IKCONFIG_PROC in config
Date:   Thu, 19 May 2022 16:30:11 -0700
Message-Id: <20220519233016.105670-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
References: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/bpf/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 08c6e5a66d87..6840d4625e01 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -54,3 +54,5 @@ CONFIG_NF_DEFRAG_IPV6=y
 CONFIG_NF_CONNTRACK=y
 CONFIG_USERFAULTFD=y
 CONFIG_FPROBE=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
-- 
2.36.1

