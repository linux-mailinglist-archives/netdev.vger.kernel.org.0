Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDE0342744
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 21:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhCSU7W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Mar 2021 16:59:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhCSU7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 16:59:13 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JKuEoZ005018
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:13 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1wd1ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:13 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 13:59:12 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E28F52ED268B; Fri, 19 Mar 2021 13:59:10 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/3] Handle no-BTF object files better
Date:   Fri, 19 Mar 2021 13:59:06 -0700
Message-ID: <20210319205909.1748642-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two issues caused by BPF object files with missing BTF type information:
  1. BPF skeleton generated for BPF object files that use global variables but
     are compiled without BTF won't compile.
  2. BPF static linker will crash attempting to fix up BTF for input object
     file with no BTF.

This patch set also extends static linking selftest to validate correct
handling of both conditions now. For that, selftests Makefile is enhanced to
allow selecting whether a given BPF object file should be compiled with BTF or
not, based on naming convention (.nobtf.c suffix).

Andrii Nakryiko (3):
  bpftool: improve skeleton generation for objects without BTF
  libbpf: skip BTF fixup if object file has no BTF
  selftests/bpf: allow compiling BPF objects without BTF

 tools/bpf/bpftool/gen.c                       | 81 +++++++++++++++----
 tools/lib/bpf/linker.c                        |  3 +
 tools/testing/selftests/bpf/Makefile          | 21 +++--
 .../selftests/bpf/prog_tests/static_linked.c  |  6 +-
 .../bpf/progs/test_static_linked3.nobtf.c     | 36 +++++++++
 5 files changed, 123 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked3.nobtf.c

-- 
2.30.2

