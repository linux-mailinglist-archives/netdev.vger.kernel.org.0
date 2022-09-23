Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C61D5E8603
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 00:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiIWWpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 18:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiIWWpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 18:45:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27839106504
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 15:45:00 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NM9Kcn030810
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 15:44:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=lJXt5Ubsu8qeV41sq1GA51M5lBK/C5UaoyBiH0W5OlY=;
 b=I76bChVcpqaw3ziI+mXPzHLisMGyv5lsBWgTpGYYd77WWj3R3jpcPEJNlt4lfBWmEVZ+
 fS5IRNjSOe4tBsODGpQVACmYjaUDxB154wnonB+B+sSCvCOP2+4UD6nbQMWECCyHK1AG
 QELa15XVnvXvFt6e6nqcu8k/3u0wgVIRo3M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jsa90n454-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 15:44:55 -0700
Received: from twshared10425.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 15:44:54 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 1A3C69A40674; Fri, 23 Sep 2022 15:44:53 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 bpf-next 0/5] bpf: Remove recursion check for struct_ops prog
Date:   Fri, 23 Sep 2022 15:44:53 -0700
Message-ID: <20220923224453.2351753-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: h3zmxaWUrf3u-5IrkXdPOwzyXk9pvthQ
X-Proofpoint-ORIG-GUID: h3zmxaWUrf3u-5IrkXdPOwzyXk9pvthQ
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_10,2022-09-22_02,2022-06-22_01
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

v2:
v1 [0] turned into a long discussion on a few cases and also
whether it needs to follow the bpf_run_ctx chain if there is
tracing bpf_run_ctx (kprobe/trace/trampoline) running in between.

It is a good signal that it is not obvious enough to reason
about it and needs a tradeoff for a more straight forward approach.

This revision uses one bit out of an existing 1 byte hole
in the tcp_sock.  It is in Patch 4.

[0]: https://lore.kernel.org/bpf/20220922225616.3054840-1-kafai@fb.com/T/#m=
d98d40ac5ec295fdadef476c227a3401b2b6b911

Martin KaFai Lau (5):
  bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
  bpf: Move the "cdg" tcp-cc check to the common sol_tcp_sockopt()
  bpf: Refactor bpf_setsockopt(TCP_CONGESTION) handling into another
    function
  bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur
    itself
  selftests/bpf: Check -EBUSY for the recurred
    bpf_setsockopt(TCP_CONGESTION)

 arch/x86/net/bpf_jit_comp.c                   |  3 +
 include/linux/bpf.h                           |  4 ++
 include/linux/tcp.h                           |  6 ++
 kernel/bpf/trampoline.c                       | 23 ++++++
 net/core/filter.c                             | 70 ++++++++++++++-----
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  4 ++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 25 ++++---
 7 files changed, 111 insertions(+), 24 deletions(-)

--=20
2.30.2

