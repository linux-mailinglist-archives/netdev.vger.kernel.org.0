Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61D57219C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392143AbfGWVfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:35:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389412AbfGWVfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:35:00 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NLQIiQ003980
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:34:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=l59IJz/Pl3i3Po1J3KD9hdZaTUSN4axyc7V+n1XtiLM=;
 b=f61xOV9/u93CKU7x2YVsr5kZrVswrJJzziCKtSWZfvHE8d8vx9GlNfPeS64rKtCRsXUi
 LgsRk1uy9KJIvRA2gM5RKRnxKmXmYx48YqPlBeCbn/xoUF2FJLW1q7J0OP0qoaIJK1DN
 saVvkIHynEk9eeW37C5wq0IzN/gIJd+kDc8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tx61p13en-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:34:59 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 14:34:57 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2AE218615A2; Tue, 23 Jul 2019 14:34:56 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <songliubraving@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/5] switch samples and tests to libbpf perf buffer API
Date:   Tue, 23 Jul 2019 14:34:40 -0700
Message-ID: <20190723213445.1732339-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=872 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230216
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were few more tests and samples that were using custom perf buffer =
setup
code from trace_helpers.h. This patch set gets rid of all the usages of t=
hose
and removes helpers themselves. Libbpf provides nicer, but equally powerf=
ul
set of APIs to work with perf ring buffers, so let's have all the samples=
 use

v1->v2:
- make logging message one long line instead of two (Song).

Andrii Nakryiko (5):
  selftests/bpf: convert test_get_stack_raw_tp to perf_buffer API
  selftests/bpf: switch test_tcpnotify to perf_buffer API
  samples/bpf: convert xdp_sample_pkts_user to perf_buffer API
  samples/bpf: switch trace_output sample to perf_buffer API
  selftests/bpf: remove perf buffer helpers

 samples/bpf/trace_output_user.c               |  43 ++----
 samples/bpf/xdp_sample_pkts_user.c            |  61 +++------
 .../bpf/prog_tests/get_stack_raw_tp.c         |  78 ++++++-----
 .../bpf/progs/test_get_stack_rawtp.c          |   2 +-
 .../selftests/bpf/test_tcpnotify_user.c       |  90 +++++--------
 tools/testing/selftests/bpf/trace_helpers.c   | 125 ------------------
 tools/testing/selftests/bpf/trace_helpers.h   |   9 --
 7 files changed, 111 insertions(+), 297 deletions(-)

--=20
2.17.1

