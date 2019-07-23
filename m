Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC86B71094
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 06:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbfGWEbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 00:31:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50220 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbfGWEbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 00:31:18 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N4UCV8013202
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=RsHuONIhX2I9cKO5OXUGYM2WGWA7jzy0qCO+mIuDktI=;
 b=lWviExiR2inKSkloMG/p6lmjTc85Gkm0iWqq7T6tZbvZzib7WBdhZgk5LNuauX3pBme4
 6hPsaDI5578dCOrUkaCgrnBXcv+6XgBe91yOo7UDVsMD4+1dXw88f4Mj/ZX1NFYjvQNm
 iqWfesWMecZfER8Ik8o1b/NK54sXntAoftk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2twqq1rjw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:17 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 22 Jul 2019 21:31:16 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 8ADB88614ED; Mon, 22 Jul 2019 21:31:16 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/5] switch samples and tests to libbpf perf buffer API
Date:   Mon, 22 Jul 2019 21:31:07 -0700
Message-ID: <20190723043112.3145810-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=813 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were few more tests and samples that were using custom perf buffer setup
code from trace_helpers.h. This patch set gets rid of all the usages of those
and removes helpers themselves. Libbpf provides nicer, but equally powerful
set of APIs to work with perf ring buffers, so let's have all the samples use
that and server as a good example.

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

-- 
2.17.1

