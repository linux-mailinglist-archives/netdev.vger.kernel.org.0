Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29DA2B0FDA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKLVNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:13:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727149AbgKLVM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:12:59 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0ACL1g2e017372
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:12:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=3TxQl2Ty/QLplzdhLjMNcbakijcLZV5aaOyIRDAPopo=;
 b=OxOUw1eZxFKZ5XkOZlU7o7ag9pmZrItZ08qsgUW1RDxoodWkvRlVJZK41VuDpMSlsudn
 H7pmHKS9gwaWUqGLmIZ8/oM/foHZ1kXX7t66+/GPiMrYZ8+gpe9GLUc50OTFBcCSuwmk
 Dy1VPmWlv8bpLkXQY6AkACKPBa6SfAUcX5I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34r4sh5243-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:12:58 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 13:12:55 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1286B29469C4; Thu, 12 Nov 2020 13:12:55 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 0/4] bpf: Enable bpf_sk_storage for FENTRY/FEXIT/RAW_TP
Date:   Thu, 12 Nov 2020 13:12:55 -0800
Message-ID: <20201112211255.2585961-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_12:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 clxscore=1015 suspectscore=13 bulkscore=0 mlxlogscore=411
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011120123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is to allow the FENTRY/FEXIT/RAW_TP tracing program to use
bpf_sk_storage.  The first two patches are a cleanup.  The last patch is
tests.  Patch 3 has the required kernel changes to
enable bpf_sk_storage for FENTRY/FEXIT/RAW_TP.

Please see individual patch for details.

v2:
- Rename some of the function prefix from sk_storage to bpf_sk_storage
- Use prefix check instead of substr check

Martin KaFai Lau (4):
  bpf: Folding omem_charge() into sk_storage_charge()
  bpf: Rename some functions in bpf_sk_storage
  bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
  bpf: selftest: Use bpf_sk_storage in FENTRY/FEXIT/RAW_TP

 include/net/bpf_sk_storage.h                  |   2 +
 kernel/trace/bpf_trace.c                      |   5 +
 net/core/bpf_sk_storage.c                     | 135 +++++++++++++-----
 .../bpf/prog_tests/sk_storage_tracing.c       | 135 ++++++++++++++++++
 .../bpf/progs/test_sk_storage_trace_itself.c  |  29 ++++
 .../bpf/progs/test_sk_storage_tracing.c       |  95 ++++++++++++
 6 files changed, 369 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_storage_tra=
cing.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tra=
ce_itself.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tra=
cing.c

--=20
2.24.1

