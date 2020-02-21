Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3213D166D43
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgBUDQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:16:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:59472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbgBUDQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 22:16:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4AFD9ADA3;
        Fri, 21 Feb 2020 03:16:15 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next v2 0/5] bpftool: Make probes which emit dmesg warnings optional
Date:   Fri, 21 Feb 2020 04:16:55 +0100
Message-Id: <20200221031702.25292-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Feature probes in bpftool related to bpf_probe_write_user and
bpf_trace_printk helpers emit dmesg warnings which might be confusing
for people running bpftool on production environments. This patch series
addresses that by filtering them out by default and introducing the new
positional argument "full" which enables all available probes.

The main motivation behind those changes is ability the fact that some
probes (for example those related to "trace" or "write_user" helpers)
emit dmesg messages which might be confusing for people who are running
on production environments. For details see the Cilium issue[0].

v1: https://lore.kernel.org/bpf/20200218190224.22508-1-mrostecki@opensuse.org/T/

v1 -> v2:
- Do not expose regex filters to users, keep filtering logic internal,
expose only the "full" option for including probes which emit dmesg
warnings.

[0] https://github.com/cilium/cilium/issues/10048

Michal Rostecki (5):
  bpftool: Move out sections to separate functions
  bpftool: Make probes which emit dmesg warnings optional
  bpftool: Update documentation of "bpftool feature" command
  bpftool: Update bash completion for "bpftool feature" command
  selftests/bpf: Add test for "bpftool feature" command

 .../bpftool/Documentation/bpftool-feature.rst |  15 +-
 tools/bpf/bpftool/bash-completion/bpftool     |  27 +-
 tools/bpf/bpftool/feature.c                   | 291 ++++++++++++------
 tools/testing/selftests/.gitignore            |   5 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/test_bpftool.py   | 228 ++++++++++++++
 tools/testing/selftests/bpf/test_bpftool.sh   |   5 +
 7 files changed, 463 insertions(+), 111 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
 create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh

-- 
2.25.0

