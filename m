Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46505178E0
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387571AbiEBVQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbiEBVQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:16:10 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7612193;
        Mon,  2 May 2022 14:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651525960; x=1683061960;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PvDGCGLLuYuPDJStpkzYAsiPIWAWemnXH5cKtMSAIJ8=;
  b=aTsLKOp0yhASlxAUDq+bMgYI9X0xvf6fqWccZ5wxbMjogxQaKyECEGaS
   1G1MTaCSkPVHJHHKIM+Uc0C4LIjg6W0qbEiCJNEUkx3ecxVgl/Q7I+yVn
   FjVbEtuPPigXd8xDWhDwn2svqX/p8WENvBSoMDchThyf+vOEIOr/vJDJ2
   R8+uq+pFMwm/AWgcVd1XILOGLO84BGitilZlpUHlYnjdWN2Ty2DnnIlg/
   A5TAh/gtLwov9FGbYuWYH8mhPqWYHK79Xlq6N46vJPmzQ4KmBOAXvrey/
   GyhWivrgbSqD84h+b4hSWav9M1iYxv9WZyxD1bP3CmeNLFWTOv8h7UtbW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="247878457"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="247878457"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:12:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="810393786"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:12:40 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev
Subject: [PATCH bpf-next v3 0/8] bpf: mptcp: Support for mptcp_sock and is_mptcp
Date:   Mon,  2 May 2022 14:12:26 -0700
Message-Id: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

v2 -> v3: Access sysctl through the filesystem to work around CI use of
the more limited busybox sysctl command.


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
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 272 ++++++++++++++++++
 .../testing/selftests/bpf/progs/mptcp_sock.c  |  80 ++++++
 19 files changed, 497 insertions(+), 10 deletions(-)
 create mode 100644 net/mptcp/bpf.c
 create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c


base-commit: 20b87e7c29dffcfa3f96f2e99daec84fd46cabdb
-- 
2.36.0

