Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D5227D9E3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgI2VXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:23:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:52998 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbgI2VXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:23:16 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNN5d-00076k-RP; Tue, 29 Sep 2020 23:23:13 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 0/6] Various BPF helper improvements
Date:   Tue, 29 Sep 2020 23:23:00 +0200
Message-Id: <cover.1601414174.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds two BPF helpers, that is, one for retrieving the classid
of an skb and another one to redirect via the neigh subsystem, and improves
also the cookie helpers by removing the atomic counter. I've also added
the bpf_tail_call_static() helper to the libbpf API that we've been using
in Cilium for a while now, and last but not least the series adds a few
selftests. For details, please check individual patches, thanks!

v2 -> v3:
  - Removed double skb->dev = dev assignment (David)
  - Added headroom check for v6 path (David)
  - Set set flowi4_proto for ip_route_output_flow (David)
  - Rebased onto latest bpf-next
v1 -> v2:
  - Rework cookie generator to support nested contexts (Eric)
  - Use ip_neigh_gw6() and container_of() (David)
  - Rename __throw_build_bug() and improve comments (Andrii)
  - Use bpf_tail_call_static() also in BPF samples (Maciej)

Daniel Borkmann (6):
  bpf: add classid helper only based on skb->sk
  bpf, net: rework cookie generator as per-cpu one
  bpf: add redirect_neigh helper as redirect drop-in
  bpf, libbpf: add bpf_tail_call_static helper for bpf programs
  bpf, selftests: use bpf_tail_call_static where appropriate
  bpf, selftests: add redirect_neigh selftest

 include/linux/cookie.h                        |  51 +++
 include/linux/skbuff.h                        |   5 +
 include/linux/sock_diag.h                     |  14 +-
 include/net/net_namespace.h                   |   2 +-
 include/uapi/linux/bpf.h                      |  24 ++
 kernel/bpf/reuseport_array.c                  |   2 +-
 net/core/filter.c                             | 304 ++++++++++++++++--
 net/core/net_namespace.c                      |   9 +-
 net/core/sock_diag.c                          |   9 +-
 net/core/sock_map.c                           |   4 +-
 samples/bpf/sockex3_kern.c                    |  20 +-
 tools/include/uapi/linux/bpf.h                |  24 ++
 tools/lib/bpf/bpf_helpers.h                   |  46 +++
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  12 +-
 tools/testing/selftests/bpf/progs/tailcall1.c |  28 +-
 tools/testing/selftests/bpf/progs/tailcall2.c |  14 +-
 tools/testing/selftests/bpf/progs/tailcall3.c |   4 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c   |   4 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |   6 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c   |   6 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |   6 +-
 .../selftests/bpf/progs/test_tc_neigh.c       | 144 +++++++++
 tools/testing/selftests/bpf/test_tc_neigh.sh  | 168 ++++++++++
 23 files changed, 826 insertions(+), 80 deletions(-)
 create mode 100644 include/linux/cookie.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh.c
 create mode 100755 tools/testing/selftests/bpf/test_tc_neigh.sh

-- 
2.21.0

