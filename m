Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339E22DEC27
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgLRX5B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Dec 2020 18:57:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54112 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgLRX5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:57:01 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BINsB8d013116
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:21 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35gxe5jqby-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:56:20 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 15:56:19 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8AF4F2ECB8FE; Fri, 18 Dec 2020 15:56:16 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/3] Add user-space and non-CO-RE variants of BPF_CORE_READ()
Date:   Fri, 18 Dec 2020 15:56:11 -0800
Message-ID: <20201218235614.2284956-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_14:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=948 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180163
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two sets of BPF_CORE_READ()-like macros. One is for reading kernel data
from user address space (e.g., UAPI data structs for syscalls). Another one is
non-CO-RE variants, which don't emit CO-RE relocations and thus won't fail on
kernels without BTF. The latter one still provides much shorter way to write
reads that needs to chase few pointers.

Andrii Nakryiko (3):
  libbpf: add user-space variants of BPF_CORE_READ() family of macros
  libbpf: add non-CO-RE variants of BPF_CORE_READ() macro family
  selftests/bpf: add tests for user- and non-CO-RE BPF_CORE_READ()
    variants

 tools/lib/bpf/bpf_core_read.h                 | 136 +++++++++++++-----
 .../bpf/prog_tests/core_read_macros.c         |  64 +++++++++
 .../bpf/progs/test_core_read_macros.c         |  51 +++++++
 3 files changed, 212 insertions(+), 39 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_read_macros.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_read_macros.c

-- 
2.24.1

