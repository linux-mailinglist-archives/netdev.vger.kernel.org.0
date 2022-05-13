Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A99C526D0D
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 00:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384853AbiEMWsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 18:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384850AbiEMWsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 18:48:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3610527FE;
        Fri, 13 May 2022 15:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652482113; x=1684018113;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jknNG3mEEPgr4q3ixj78wwwHeBd+dIoANpLZX+rO+Ek=;
  b=ERORl8o/nO97x3gjkdGiNqIb2HkVcdmL+AMk1RDs6hc/tx+XncFanTxH
   LVTHwplSt/Ov2tBljRn3tnXbCT2f/qWnq07O34nbdwYFXHw6l01gRSvkY
   fmoI6z2bil+8BNgqNmKcmT5Z8CZCLPZwY/Zf/SyKOYKeQxzVhakN5VlW/
   OuwOExvRe85IUN40hjQ0yTy1UhxL+iKOxvQpeq4/GdxQY3GPeQb/xrn+N
   Dae4u5Am+JM3uemPZOxLde/kutcKpviYSy/jlzYPHdC8sLF6HSx3vr0Ds
   55tC4lYW9aRfm4y6LCA/F+mI8im+sxXKqiaHNZNu5obLcDgkMIY5K37Zd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="270101176"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="270101176"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:48:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="815588245"
Received: from clakshma-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.160.121])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 15:48:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        geliang.tang@suse.com
Subject: [PATCH bpf-next v4 0/7] bpf: mptcp: Support for mptcp_sock
Date:   Fri, 13 May 2022 15:48:20 -0700
Message-Id: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 net/mptcp/bpf.c                               |  22 ++
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |   7 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  13 +
 tools/testing/selftests/bpf/config            |   3 +
 tools/testing/selftests/bpf/network_helpers.c |  43 ++-
 tools/testing/selftests/bpf/network_helpers.h |   4 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 265 ++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  82 ++++++
 18 files changed, 473 insertions(+), 9 deletions(-)
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c


base-commit: 0d2d2648931bdb1a629bf0df4e339e6a326a6136
-- 
2.36.1

