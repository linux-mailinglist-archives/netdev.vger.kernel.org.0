Return-Path: <netdev+bounces-9023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DCE7269B9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09BF71C20E48
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05C137354;
	Wed,  7 Jun 2023 19:26:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BCC6118;
	Wed,  7 Jun 2023 19:26:39 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB51FDE;
	Wed,  7 Jun 2023 12:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=3Xi0WEnTaxZKt77bQRN8LV1oOyRPlPvGmnT+c3YFP6E=; b=BF64uvKCAWWKb7kmOo8ANZlzXI
	P2vuB+uQjkaovq13FWuJJaATOhiWYHPGeHAayJHDEs+I1URZ0MzTn8fWaS7v7Ca0OVg7mzKQvl12P
	wUbGYMFuevXL7IcnNLt1igaCdHZA8nRWdn9nj+pLSyGhzDCrwua/RWPUenUY3S+mDmPe3NBmu1UXY
	Ch+r8apBWn4sPyj1aEFSc1HGHolqi7GcMjZf8LywNhW0NBY61yq4lTrh2a8ZkIYNqQlP7+SLAGZYs
	h2upeMCFAHrKJ4q0qYQm+QIZkXMw6n/PUQDa9Bm/HiLogNklvojteRoxwoo9dOXkmZzJul3tnQFbG
	Mf64tzUw==;
Received: from 49.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.49] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q6ynh-000CXQ-JC; Wed, 07 Jun 2023 21:26:33 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: ast@kernel.org
Cc: andrii@kernel.org,
	martin.lau@linux.dev,
	razor@blackwall.org,
	sdf@google.com,
	john.fastabend@gmail.com,
	kuba@kernel.org,
	dxu@dxuuu.xyz,
	joe@cilium.io,
	toke@kernel.org,
	davem@davemloft.net,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 0/7] BPF link support for tc BPF programs
Date: Wed,  7 Jun 2023 21:26:18 +0200
Message-Id: <20230607192625.22641-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26931/Wed Jun  7 09:23:57 2023)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series adds BPF link support for tc BPF programs. We initially
presented the motivation, related work and design at last year's LPC
conference in the networking & BPF track [0], and a recent update on
our progress of the rework during this year's LSF/MM/BPF summit [1].
The main changes are in first two patches and the last two have an
extensive batch of test cases we developed along with it, please see
individual patches for details. We tested this series with tc-testing
selftest suite as well as BPF CI/selftests. Thanks!

  [0] https://lpc.events/event/16/contributions/1353/
  [1] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_borkmann.pdf

Daniel Borkmann (7):
  bpf: Add generic attach/detach/query API for multi-progs
  bpf: Add fd-based tcx multi-prog infra with link support
  libbpf: Add opts-based attach/detach/query API for tcx
  libbpf: Add link-based API for tcx
  bpftool: Extend net dump with tcx progs
  selftests/bpf: Add mprog API tests for BPF tcx opts
  selftests/bpf: Add mprog API tests for BPF tcx links

 MAINTAINERS                                   |    5 +-
 include/linux/bpf_mprog.h                     |  245 ++
 include/linux/netdevice.h                     |   15 +-
 include/linux/skbuff.h                        |    4 +-
 include/net/sch_generic.h                     |    2 +-
 include/net/tcx.h                             |  157 +
 include/uapi/linux/bpf.h                      |   72 +-
 kernel/bpf/Kconfig                            |    1 +
 kernel/bpf/Makefile                           |    3 +-
 kernel/bpf/mprog.c                            |  476 +++
 kernel/bpf/syscall.c                          |   95 +-
 kernel/bpf/tcx.c                              |  347 +++
 net/Kconfig                                   |    5 +
 net/core/dev.c                                |  267 +-
 net/core/filter.c                             |    4 +-
 net/sched/Kconfig                             |    4 +-
 net/sched/sch_ingress.c                       |   45 +-
 tools/bpf/bpftool/net.c                       |   92 +-
 tools/include/uapi/linux/bpf.h                |   72 +-
 tools/lib/bpf/bpf.c                           |   83 +-
 tools/lib/bpf/bpf.h                           |   61 +-
 tools/lib/bpf/libbpf.c                        |   50 +-
 tools/lib/bpf/libbpf.h                        |   17 +
 tools/lib/bpf/libbpf.map                      |    2 +
 .../selftests/bpf/prog_tests/tc_helpers.h     |   72 +
 .../selftests/bpf/prog_tests/tc_links.c       | 2279 ++++++++++++++
 .../selftests/bpf/prog_tests/tc_opts.c        | 2698 +++++++++++++++++
 .../selftests/bpf/progs/test_tc_link.c        |   40 +
 28 files changed, 6995 insertions(+), 218 deletions(-)
 create mode 100644 include/linux/bpf_mprog.h
 create mode 100644 include/net/tcx.h
 create mode 100644 kernel/bpf/mprog.c
 create mode 100644 kernel/bpf/tcx.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_links.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_link.c

-- 
2.34.1


