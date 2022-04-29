Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFC05157C1
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381153AbiD2WFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381186AbiD2WFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:05:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7638EDC59F;
        Fri, 29 Apr 2022 15:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651269729; x=1682805729;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e4ZQJt8QmkUQW3Q2NfOKvHTzJhDCEuC7kAGZGauFlKI=;
  b=ccjGurrETR7Zle+V/XZZokEsHTv466sAM+RDSXZEIwq5AyJ4HwfUJCcD
   F7FvzAdfk3zVRUT4qzxkAyH08WqVs7s7D2/K5/PagEsuY8Gs4kFPNSiHq
   eGBE0epkNRWwpal3gMVgvEI8bLPbFjZq8a3PXDbfISa8nApuSY3LaO3kB
   aZ8xhM53z4t98ClB60Z+6rKWqjR188NQu5p1lquiHz3MkDshrQzjyMF/A
   +usjUcliKDqWXS1uglv69/BNHblqoJZjtHVQCNbWjtNTF53bgB94QESXz
   YVAKtI/cMcXDc/fWyWhNF1T8orut/lwL9YBl+yjsy/ryp9HhB0W6Gi54H
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="266609687"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="266609687"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582419795"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.217.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 15:02:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev
Subject: [PATCH bpf-next v2 0/8] bpf: mptcp: Support for mptcp_sock and is_mptcp
Date:   Fri, 29 Apr 2022 15:01:56 -0700
Message-Id: <20220429220204.353225-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
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

This patch set adds BPF access to the is_mptcp flag in tcp_sock and
access to mptcp_sock structures, along with associated self tests. You
may recognize some of the code from earlier
(https://lore.kernel.org/bpf/20200918121046.190240-6-nicolas.rybowski@tessares.net/)
but it has been reworked quite a bit.


v1 -> v2: Emit BTF type, add func_id checks in verifier.c and bpf_trace.c,
remove build check for CONFIG_BPF_JIT, add selftest check for CONFIG_MPTCP,
and add a patch to include CONFIG_IKCONFIG/CONFIG_IKCONFIG_PROC for the
BPF self tests.


Geliang Tang (6):
  bpf: add bpf_skc_to_mptcp_sock_proto
  selftests: bpf: Enable CONFIG_IKCONFIG_PROC in config
  selftests: bpf: test bpf_skc_to_mptcp_sock
  selftests: bpf: verify token of struct mptcp_sock
  selftests: bpf: verify ca_name of struct mptcp_sock
  selftests: bpf: verify first of struct mptcp_sock

Nicolas Rybowski (2):
  bpf: expose is_mptcp flag to bpf_tcp_sock
  selftests: bpf: add MPTCP test base

 MAINTAINERS                                   |   2 +
 include/linux/bpf.h                           |   1 +
 include/linux/btf_ids.h                       |   3 +-
 include/net/mptcp.h                           |   6 +
 include/uapi/linux/bpf.h                      |   8 +
 kernel/bpf/verifier.c                         |   1 +
 kernel/trace/bpf_trace.c                      |   2 +
 net/core/filter.c                             |  27 +-
 net/mptcp/Makefile                            |   2 +
 net/mptcp/bpf.c                               |  22 ++
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |   8 +
 .../testing/selftests/bpf/bpf_mptcp_helpers.h |  17 ++
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   4 +
 tools/testing/selftests/bpf/config            |   3 +
 tools/testing/selftests/bpf/network_helpers.c |  43 ++-
 tools/testing/selftests/bpf/network_helpers.h |   4 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 258 ++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  80 ++++++
 19 files changed, 483 insertions(+), 10 deletions(-)
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c


base-commit: 20b87e7c29dffcfa3f96f2e99daec84fd46cabdb
-- 
2.36.0

