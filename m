Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD655A407
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiFXV5b convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jun 2022 17:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiFXV5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:57:30 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1F387B7D
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:29 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OLaFdS022033
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:28 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvqxy2v0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 14:57:28 -0700
Received: from twshared34609.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 24 Jun 2022 14:57:27 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id C3B6494C39CB; Fri, 24 Jun 2022 14:57:20 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <x86@vger.kernel.org>
CC:     <dave.hansen@linux.intel.com>, <mcgrof@kernel.org>,
        <rick.p.edgecombe@intel.com>, <kernel-team@fb.com>,
        <daniel@iogearbox.net>, Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 0/5] bpf_prog_pack followup
Date:   Fri, 24 Jun 2022 14:57:07 -0700
Message-ID: <20220624215712.3050672-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Zu0IoColBpQveVyZ13BNZ4Z7Nmc5F6Yu
X-Proofpoint-GUID: Zu0IoColBpQveVyZ13BNZ4Z7Nmc5F6Yu
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_09,2022-06-24_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is the second half of v4 [1].

Changes v4 => v5:
1. Rebase and resolve conflicts due to module.c split.
2. Update experiment results (below).

For our web service production benchmark, bpf_prog_pack on 4kB pages
gives 0.5% to 0.7% more throughput than not using bpf_prog_pack.
bpf_prog_pack on 2MB pages 0.6% to 0.9% more throughput than not using
bpf_prog_pack. Note that 0.5% is a huge improvement for our fleet. I
believe this is also significant for other companies with many thousand
servers.

Update: Further experiments (suggested by Rick Edgecombe) showed that most
of benefit on the web service benchmark came from less direct map
fragmentation. The experiment is as follows:

Side A: 2MB bpf prog pack on a single 2MB page;
Side B: 2MB bpf prog pack on 512x 4kB pages;

The system only uses about 200kB for BPF programs, but 2MB is allocated
for bpf_prog_pack (for both A and B). Therefore, direct map fragmentation
caused by BPF programs is elminated, and we are only measuring the
performance difference of 1x 2MB page vs. ~50 4kB pages (we only use
about 50 out of the 512 pages). For these two sides, the difference in
system throughput is within the noise. I also measured iTLB-load-misses
caused by bpf programs, which is ~300/s for case A, and ~1600/s for case B.
The overall iTLB-load-misses is about 1.5M/s on these hosts. Therefore,
we can clearly see 2MB page reduces iTLB misses, but the difference is not
enough to have visible impact on system throughput.

Of course, the impact of iTLB miss will be more significant for systems
with more BPF programs loaded.

[1] https://lore.kernel.org/bpf/20220520235758.1858153-1-song@kernel.org/

Song Liu (5):
  module: introduce module_alloc_huge
  bpf: use module_alloc_huge for bpf_prog_pack
  vmalloc: WARN for set_vm_flush_reset_perms() on huge pages
  vmalloc: introduce huge_vmalloc_supported
  bpf: simplify select_bpf_prog_pack_size

 arch/x86/kernel/module.c     | 21 +++++++++++++++++++++
 include/linux/moduleloader.h |  5 +++++
 include/linux/vmalloc.h      |  7 +++++++
 kernel/bpf/core.c            | 25 ++++++++++---------------
 kernel/module/main.c         |  8 ++++++++
 mm/vmalloc.c                 |  5 +++++
 6 files changed, 56 insertions(+), 15 deletions(-)

--
2.30.2
