Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A34B52E084
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343557AbiESXaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbiESXaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:30:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F172F106561;
        Thu, 19 May 2022 16:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653003021; x=1684539021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bIAkoA2BETm+H6tzNSJD8IT8c+t3sI9/4fSrTSTd5TU=;
  b=bYa19ukoPay40GQQa5tkpeOKmEwWXl+aW07yNPGmDQFpA5AGtdrOstPy
   E0Ur5ZWuKqPMxZP4P8MseoqicBIvKoGkdym6/1fLVdWzT5nJR01WBFRrJ
   4khHCzydhSsPPkubwobR5SsqvHwi7F3K7r9DaOx2b6r5FXAdng4Jk/sQd
   gWabUaT81CAADwpciZwI01VCYV5SazT73a9zfk6iAvGNqK86in2bAWbb8
   vMFCFEmgkoOfPH6AA+UjvivbiFxZj6MXPa2Hl7t2gW7B2CHXp0nXyy239
   PM+UPq+OHoGPTrKwvppEum+TfRCcYk5G0eisswNL72QB47ZWncRopbjqD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272547195"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272547195"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570491188"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.252.132.179])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 16:30:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, geliang.tang@suse.com,
        mptcp@lists.linux.dev
Subject: [PATCH bpf-next v5 0/7] bpf: mptcp: Support for mptcp_sock
Date:   Thu, 19 May 2022 16:30:09 -0700
Message-Id: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
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

This patch set adds BPF access to mptcp_sock structures, along with
associated self tests. You may recognize some of the code from earlier
(https://lore.kernel.org/bpf/20200918121046.190240-6-nicolas.rybowski@tessares.net/)
but it has been reworked quite a bit.


v1 -> v2: Emit BTF type, add func_id checks in verifier.c and bpf_trace.c,
remove build check for CONFIG_BPF_JIT, add selftest check for CONFIG_MPTCP,
and add a patch to include CONFIG_IKCONFIG/CONFIG_IKCONFIG_PROC for the
BPF self tests.

v2 -> v3: Access sysctl through the filesystem to work around CI use of
the more limited busybox sysctl command.

v3 -> v4: Dropped special case kernel code for tcp_sock is_mptcp, use
existing bpf_tcp_helpers.h, and add check for 'ip mptcp monitor' support.

v4 -> v5: Use BPF test skeleton, more consistent use of ASSERT macros,
drop some unnecessary parameters / checks, and use tracing to acquire
MPTCP token.

Geliang Tang (6):
  bpf: add bpf_skc_to_mptcp_sock_proto
  selftests/bpf: Enable CONFIG_IKCONFIG_PROC in config
  selftests/bpf: test bpf_skc_to_mptcp_sock
  selftests/bpf: verify token of struct mptcp_sock
  selftests/bpf: verify ca_name of struct mptcp_sock
  selftests/bpf: verify first of struct mptcp_sock

Nicolas Rybowski (1):
  selftests/bpf: add MPTCP test base

 MAINTAINERS                                   |   1 +
 include/linux/bpf.h                           |   1 +
 include/linux/btf_ids.h                       |   3 +-
 include/net/mptcp.h                           |   6 +
 include/uapi/linux/bpf.h                      |   7 +
 kernel/bpf/verifier.c                         |   1 +
 kernel/trace/bpf_trace.c                      |   2 +
 net/core/filter.c                             |  18 ++
 net/mptcp/Makefile                            |   2 +
 net/mptcp/bpf.c                               |  21 +++
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |   7 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  13 ++
 tools/testing/selftests/bpf/config            |   3 +
 tools/testing/selftests/bpf/network_helpers.c |  40 +++-
 tools/testing/selftests/bpf/network_helpers.h |   2 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 174 ++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  89 +++++++++
 18 files changed, 382 insertions(+), 10 deletions(-)
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c


base-commit: 834650b50ed283d9d34a32b425d668256bf2e487
-- 
2.36.1

