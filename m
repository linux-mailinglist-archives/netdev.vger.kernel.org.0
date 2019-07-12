Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F7667423
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfGLR0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:26:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726930AbfGLR0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:26:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6CHKB9h013729
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:26:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zS/2N2DJxm5EV4M9UWP3isNT5ZRtvFPkjdpVu4C979U=;
 b=oH4BFbYABEhmCY85ZBOCqQXnFgiHndBrKvrCtIAViYd0DZn4iaaT0SmRFXYfkbnc08dU
 wW8K/UPdRW6AfroZkD+WpGQzSgvmCmqbAzt9sUtweY3m48GxZRPmmRDxjhIswLX+0Utz
 no6lU0F7E0AH9Vk39AyX6Sl0s6iFdLlC46k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2tpk9ua6vd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:26:12 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 12 Jul 2019 10:26:10 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 3F0868614A9; Fri, 12 Jul 2019 10:26:09 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf 0/3] fix BTF verification size resolution
Date:   Fri, 12 Jul 2019 10:25:54 -0700
Message-ID: <20190712172557.4039121-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=547 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120177
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

Andrii Nakryiko (3):
  bpf: fix BTF verifier size resolution logic
  selftests/bpf: add trickier size resolution tests
  selftests/bpf: use typedef'ed arrays as map values

 kernel/bpf/btf.c                              | 19 ++--
 .../bpf/progs/test_get_stack_rawtp.c          |  3 +-
 .../bpf/progs/test_stacktrace_build_id.c      |  3 +-
 .../selftests/bpf/progs/test_stacktrace_map.c |  2 +-
 tools/testing/selftests/bpf/test_btf.c        | 88 +++++++++++++++++++
 5 files changed, 104 insertions(+), 11 deletions(-)

-- 
2.17.1

