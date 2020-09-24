Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ABB277869
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgIXSVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:21:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:39312 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgIXSVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:21:38 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLVs8-0003zn-0k; Thu, 24 Sep 2020 20:21:36 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/6] Various BPF helper improvements
Date:   Thu, 24 Sep 2020 20:21:21 +0200
Message-Id: <cover.1600967205.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds two BPF helpers, that is, one for retrieving the classid
of an skb and another one to redirect via the neigh subsystem, and improves
also the cookie helpers by removing the atomic counter. I've also added
the bpf_tail_call_static() helper to the libbpf API that we've been using
in Cilium for a while now, and last but not least the series adds a few
selftests. For details, please check individual patches, thanks!

Daniel Borkmann (6):
  bpf: add classid helper only based on skb->sk
  bpf, net: rework cookie generator as per-cpu one
  bpf: add redirect_neigh helper as redirect drop-in
  bpf, libbpf: add bpf_tail_call_static helper for bpf programs
  bpf, selftests: use bpf_tail_call_static where appropriate
  bpf, selftests: add redirect_neigh selftest

 include/linux/cookie.h                        |  41 +++
 include/linux/skbuff.h                        |   5 +
 include/uapi/linux/bpf.h                      |  24 ++
 net/core/filter.c                             | 277 +++++++++++++++++-
 net/core/net_namespace.c                      |   5 +-
 net/core/sock_diag.c                          |   7 +-
 tools/include/uapi/linux/bpf.h                |  24 ++
 tools/lib/bpf/bpf_helpers.h                   |  32 ++
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  12 +-
 tools/testing/selftests/bpf/progs/tailcall1.c |  28 +-
 tools/testing/selftests/bpf/progs/tailcall2.c |  14 +-
 tools/testing/selftests/bpf/progs/tailcall3.c |   4 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c   |   4 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |   6 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c   |   6 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |   6 +-
 .../selftests/bpf/progs/test_tc_neigh.c       | 144 +++++++++
 tools/testing/selftests/bpf/test_tc_neigh.sh  | 168 +++++++++++
 18 files changed, 749 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/cookie.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh.c
 create mode 100755 tools/testing/selftests/bpf/test_tc_neigh.sh

-- 
2.21.0

