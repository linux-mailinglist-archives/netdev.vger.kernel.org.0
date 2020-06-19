Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB5201E5F
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgFSW5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbgFSW5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 18:57:44 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CED4F21D7D;
        Fri, 19 Jun 2020 22:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592607463;
        bh=3ZTl+A/Kacpq2EA0Kulq1UyudM0GeuQ/Ht1E3auto+w=;
        h=From:To:Cc:Subject:Date:From;
        b=DOZgSg/spKDM3Zz1thY8RJMn/BJUwXPDZukfdMYGZf/31Q6WJJb1y034UyB4Ps8pV
         5O4up5g44OYM4VyTdApQgkVRwlGYInqe3aWafBGGthacRsOGoR0wn3e7f3hPZnFwtW
         4o6XQxFxilD3zcT5egN5eEMmFJjoAg9lbclo6CUg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v2 bpf-next 0/8] introduce support for XDP programs in CPUMAP
Date:   Sat, 20 Jun 2020 00:57:16 +0200
Message-Id: <cover.1592606391.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to what David Ahern proposed in [1] for DEVMAPs, introduce the
capability to attach and run a XDP program to CPUMAP entries.
The idea behind this feature is to add the possibility to define on which CPU
run the eBPF program if the underlying hw does not support RSS.
I respin patch 1/6 from a previous series sent by David [2].
The functionality has been tested on Marvell Espressobin, i40e and mlx5.
Detailed tests results can be found here:
https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpumap04-map-xdp-prog.org

Changes since v1:
- added performance test results
- added kselftest support
- fixed memory accounting with page_pool
- extended xdp_redirect_cpu_user.c to load an external program to perform
  redirect
- reported ifindex to attached eBPF program
- moved bpf_cpumap_val definition to include/uapi/linux/bpf.h

[1] https://patchwork.ozlabs.org/project/netdev/cover/20200529220716.75383-1-dsahern@kernel.org/
[2] https://patchwork.ozlabs.org/project/netdev/patch/20200513014607.40418-2-dsahern@kernel.org/


David Ahern (1):
  net: Refactor xdp_convert_buff_to_frame

Lorenzo Bianconi (7):
  samples/bpf: xdp_redirect_cpu_user: do not update bpf maps in option
    loop
  cpumap: formalize map value as a named struct
  bpf: cpumap: add the possibility to attach an eBPF program to cpumap
  bpf: cpumap: implement XDP_REDIRECT for eBPF programs attached to map
    entries
  libbpf: add SEC name for xdp programs attached to CPUMAP
  samples/bpf: xdp_redirect_cpu: load a eBPF program on cpumap
  selftest: add tests for XDP programs in CPUMAP entries

 include/linux/bpf.h                           |   6 +
 include/net/xdp.h                             |  41 ++--
 include/trace/events/xdp.h                    |  16 +-
 include/uapi/linux/bpf.h                      |  14 ++
 kernel/bpf/cpumap.c                           | 161 +++++++++++---
 net/core/dev.c                                |   8 +
 samples/bpf/xdp_redirect_cpu_kern.c           |  25 ++-
 samples/bpf/xdp_redirect_cpu_user.c           | 208 ++++++++++++++++--
 tools/include/uapi/linux/bpf.h                |  14 ++
 tools/lib/bpf/libbpf.c                        |   2 +
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  70 ++++++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c  |  38 ++++
 12 files changed, 531 insertions(+), 72 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c

-- 
2.26.2

