Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534925E7000
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiIVW42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiIVW4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:56:25 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E14CF961E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:23 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MKilZx023209
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=LNGwizE7l3YA6nXYCkYFAHlkqAg+a+y68OEYg2ll4OQ=;
 b=C4nCIFLy+lkXRqezprKyRYlMOCQNoIj83iLBnht11kArkfhg9pDzd80/gSHc32UniJHS
 7RzH3oZfcwe9WtnpZBn5Y1nGc8ouuUimc6FTKAUXEaO1n/exetgs00ljbmSCZQVfLyx4
 mxx0bnUZwPgkCJD5R1JPzWyKriwXapgxupE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jr7ar2me7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:56:23 -0700
Received: from twshared10425.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 15:56:22 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 5FE0F999DAC9; Thu, 22 Sep 2022 15:56:16 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 0/5] bpf: Remove recursion check for struct_ops prog
Date:   Thu, 22 Sep 2022 15:56:16 -0700
Message-ID: <20220922225616.3054840-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: LodDe2mA0zvcsbG95VH8f-IozZC0uUW_
X-Proofpoint-ORIG-GUID: LodDe2mA0zvcsbG95VH8f-IozZC0uUW_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_14,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The struct_ops is sharing the tracing-trampoline's enter/exit
function which tracks prog->active to avoid recursion.  It turns
out the struct_ops bpf prog will hit this prog->active and
unnecessarily skipped running the struct_ops prog.  eg.  The
'.ssthresh' may run in_task() and then interrupted by softirq
that runs the same '.ssthresh'.

The kernel does not call the tcp-cc's ops in a recursive way,
so this set is to remove the recursion check for struct_ops prog.

Martin KaFai Lau (5):
  bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
  bpf: Move the "cdg" tcp-cc check to the common sol_tcp_sockopt()
  bpf: Add bpf_run_ctx_type
  bpf: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur itself
  selftests/bpf: Check -EBUSY for the recurred
    bpf_setsockopt(TCP_CONGESTION)

 arch/x86/net/bpf_jit_comp.c                   |  3 ++
 include/linux/bpf.h                           | 21 ++++++--
 include/linux/filter.h                        |  3 ++
 kernel/bpf/bpf_iter.c                         |  2 +-
 kernel/bpf/cgroup.c                           |  2 +-
 kernel/bpf/trampoline.c                       | 27 ++++++++++
 kernel/trace/bpf_trace.c                      |  1 +
 net/bpf/test_run.c                            |  2 +-
 net/core/filter.c                             | 17 +++---
 net/ipv4/bpf_tcp_ca.c                         | 54 +++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  4 ++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 23 +++++---
 12 files changed, 139 insertions(+), 20 deletions(-)

--=20
2.30.2

