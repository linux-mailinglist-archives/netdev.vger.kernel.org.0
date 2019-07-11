Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F4C65213
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 08:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfGKGx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 02:53:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58606 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728070AbfGKGxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 02:53:25 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B6mN37030520
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:53:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=BLcsUOrmSHqWDTUoPEHBGSiBoxz+hpPL2PRsWllArSQ=;
 b=gU9LGWnLuw6qCppiYiN64B6JnD1gZwzFXOLx1SDd0jYm1NB04+hxvk4WdpLSUkTvvyh0
 ff5NPCgC3Fq44hOM3HEQBds9aqQ1joa6mYAVSB2/xnZd24cNOcfIyCUFAtHZhL1nHKzC
 +hwD2NtLk9P4FwycUmJZvdPfG5UQnfMg3ZE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnws68c2q-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:53:24 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 10 Jul 2019 23:53:23 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 06552861661; Wed, 10 Jul 2019 23:53:18 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/3] fix BTF verification size resolution
Date:   Wed, 10 Jul 2019 23:53:04 -0700
Message-ID: <20190711065307.2425636-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=608 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110079
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF size resolution logic isn't always resolving type size correctly, leading
to erroneous map creation failures due to value size mismatch.

This patch set:
1. fixes the issue (patch #1);
2. adds tests for trickier cases (patch #2);
3. and converts few test cases utilizing BTF-defined maps, that previously
   couldn't use typedef'ed arrays due to kernel bug (patch #3).

Patch #1 can be applied against bpf tree, but selftest ones (#2 and #3) have
to go against bpf-next for now.

Andrii Nakryiko (3):
  bpf: fix BTF verifier size resolution logic
  selftests/bpf: add trickier size resolution tests
  selftests/bpf: use typedef'ed arrays as map values

 kernel/bpf/btf.c                              | 14 ++-
 .../bpf/progs/test_get_stack_rawtp.c          |  3 +-
 .../bpf/progs/test_stacktrace_build_id.c      |  3 +-
 .../selftests/bpf/progs/test_stacktrace_map.c |  2 +-
 tools/testing/selftests/bpf/test_btf.c        | 88 +++++++++++++++++++
 5 files changed, 102 insertions(+), 8 deletions(-)

-- 
2.17.1

