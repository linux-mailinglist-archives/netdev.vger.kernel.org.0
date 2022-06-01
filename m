Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDBD53AC50
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 19:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356489AbiFAR6L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Jun 2022 13:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344215AbiFAR6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 13:58:09 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4C4996BB
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 10:58:07 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251E8WnP020519
        for <netdev@vger.kernel.org>; Wed, 1 Jun 2022 10:58:07 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ge9m2hpqx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 10:58:07 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 10:58:05 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 05F078603CAF; Wed,  1 Jun 2022 10:57:56 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <rostedt@goodmis.org>, <jolsa@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH bpf-next 0/5] ftrace: host klp and bpf trampoline together
Date:   Wed, 1 Jun 2022 10:57:44 -0700
Message-ID: <20220601175749.3071572-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: aO0LqPKF9U38PhbkVKDjLvsxYBrPrzYJ
X-Proofpoint-ORIG-GUID: aO0LqPKF9U38PhbkVKDjLvsxYBrPrzYJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_06,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel Live Patch (livepatch, or klp) and bpf trampoline are important
features for modern systems. This set allows the two to work on the same
kernel function as the same time.

live patch uses ftrace with IPMODIFY, while bpf trampoline use direct
ftrace. Existing policy does not allow the two to attach to the same kernel
function. This is changed by fine tuning ftrace IPMODIFY policy, and allows
one non-DIRECT IPMODIFY ftrace_ops and one non-IPMODIFY DIRECT ftrace_ops
on the same kernel function at the same time. Please see 3/5 for more
details on this.

Note that, one of the constraint here is to let bpf trampoline use direct
call when it is not working on the same function as live patch. This is
achieved by allowing ftrace code to ask bpf trampoline to make changes.

Jiri Olsa (1):
  bpf, x64: Allow to use caller address from stack

Song Liu (4):
  ftrace: allow customized flags for ftrace_direct_multi ftrace_ops
  ftrace: add modify_ftrace_direct_multi_nolock
  ftrace: introduce FTRACE_OPS_FL_SHARE_IPMODIFY
  bpf: trampoline: support FTRACE_OPS_FL_SHARE_IPMODIFY

 arch/x86/net/bpf_jit_comp.c |  13 +-
 include/linux/bpf.h         |   8 ++
 include/linux/ftrace.h      |  79 +++++++++++
 kernel/bpf/trampoline.c     | 100 ++++++++++++--
 kernel/trace/ftrace.c       | 269 +++++++++++++++++++++++++++++++-----
 5 files changed, 416 insertions(+), 53 deletions(-)

--
2.30.2
