Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F055F4C7A
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJDXMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJDXML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:12:11 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6A456014;
        Tue,  4 Oct 2022 16:12:08 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofr54-000AIp-Cr; Wed, 05 Oct 2022 01:12:06 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 00/10] BPF link support for tc BPF programs
Date:   Wed,  5 Oct 2022 01:11:33 +0200
Message-Id: <20221004231143.19190-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26679/Tue Oct  4 09:56:50 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds BPF link support for tc BPF programs. We initially
presented the motivation, related work and design at this year's LPC
conference in the networking & BPF track [0], and have incorporated
feedback we received. The main changes are in first two patches and
the last one has an extensive batch of test cases we developed along
with it, please see individual patches for details. We tested this
series with the tc-testing selftest suite as well as the existing
and newly developed tc BPF tests from BPF selftests which all pass.
Thanks!

  [0] https://lpc.events/event/16/contributions/1353/

Daniel Borkmann (10):
  bpf: Add initial fd-based API to attach tc BPF programs
  bpf: Implement BPF link handling for tc BPF programs
  bpf: Implement link update for tc BPF link programs
  bpf: Implement link introspection for tc BPF link programs
  bpf: Implement link detach for tc BPF link programs
  libbpf: Change signature of bpf_prog_query
  libbpf: Add extended attach/detach opts
  libbpf: Add support for BPF tc link
  bpftool: Add support for tc fd-based attach types
  bpf, selftests: Add various BPF tc link selftests

 MAINTAINERS                                   |   4 +-
 include/linux/bpf.h                           |   4 +
 include/linux/netdevice.h                     |  14 +-
 include/linux/skbuff.h                        |   4 +-
 include/net/sch_generic.h                     |   2 +-
 include/net/xtc.h                             | 195 +++++
 include/uapi/linux/bpf.h                      |  45 +-
 kernel/bpf/Kconfig                            |   1 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/net.c                              | 451 +++++++++++
 kernel/bpf/syscall.c                          |  27 +-
 net/Kconfig                                   |   5 +
 net/core/dev.c                                | 262 +++---
 net/core/filter.c                             |   4 +-
 net/sched/Kconfig                             |   4 +-
 net/sched/sch_ingress.c                       |  48 +-
 tools/bpf/bpftool/net.c                       |  76 +-
 tools/include/uapi/linux/bpf.h                |  45 +-
 tools/lib/bpf/bpf.c                           |  27 +-
 tools/lib/bpf/bpf.h                           |  22 +-
 tools/lib/bpf/libbpf.c                        |  31 +-
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   2 +
 .../selftests/bpf/prog_tests/tc_link.c        | 756 ++++++++++++++++++
 .../selftests/bpf/progs/test_tc_link.c        |  43 +
 25 files changed, 1932 insertions(+), 143 deletions(-)
 create mode 100644 include/net/xtc.h
 create mode 100644 kernel/bpf/net.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_link.c

-- 
2.34.1

