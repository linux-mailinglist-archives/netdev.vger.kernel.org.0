Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36C3DE294
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfJUDjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:39:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43078 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726799AbfJUDjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:39:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9L3SEn1004944
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=VNvaTWXthWJrPwZd4kzqp4ngENTU2VIBfNNc7vvRgoI=;
 b=peWcX9d/p6E19+ObUjzYzVQjmGpX7Jdq87EbIDvBNXn8cHKwZ9b8AeF/rPOFhBnGS6uQ
 QZiTWOJ6atcJK7pq4TIGb0dNlOK33e1mEzkjVFRjHt8p4jwykRjOGCliPGu4C2uh0yJs
 PZZyV9WPR39Kpmy9+gLeStQlWq3o0JYYCPI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vr0ah4wjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:11 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 20 Oct 2019 20:39:10 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 05FF3861976; Sun, 20 Oct 2019 20:39:03 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/7] Auto-guess program type on bpf_object__open
Date:   Sun, 20 Oct 2019 20:38:55 -0700
Message-ID: <20191021033902.3856966-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_01:2019-10-18,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=924 impostorscore=0 suspectscore=8 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set's main goal is to teach bpf_object__open() (and its variants)
to automatically derive BPF program type/expected attach type from section
names, similarly to how bpf_prog_load() was doing it. This significantly
improves user experience by eliminating yet another
obvious-only-in-the-hindsight surprise, when using libbpf APIs.

There are a bunch of auxiliary clean-ups and improvements. E.g.,
bpf_program__get_type() and bpf_program__get_expected_attach_type() are added
for completeness and symmetry with corresponding setter APIs. Some clean up
and fixes in selftests/bpf are done as well.

Andrii Nakryiko (7):
  tools: sync if_link.h
  libbpf: add bpf_program__get_{type, expected_attach_type) APIs
  libbpf: add uprobe/uretprobe and tp/raw_tp section suffixes
  libbpf: teach bpf_object__open to guess program types
  selftests/bpf: make a copy of subtest name
  selftests/bpf: make reference_tracking test use subtests
  selftest/bpf: get rid of a bunch of explicit BPF program type setting

 tools/include/uapi/linux/if_link.h            |  2 +
 tools/lib/bpf/libbpf.c                        | 80 ++++++++++++-------
 tools/lib/bpf/libbpf.h                        |  5 ++
 tools/lib/bpf/libbpf.map                      |  2 +
 .../selftests/bpf/prog_tests/attach_probe.c   |  5 --
 .../selftests/bpf/prog_tests/core_reloc.c     |  1 -
 .../selftests/bpf/prog_tests/rdonly_maps.c    |  4 -
 .../bpf/prog_tests/reference_tracking.c       |  3 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c | 18 ++---
 tools/testing/selftests/bpf/test_maps.c       |  4 -
 tools/testing/selftests/bpf/test_progs.c      | 17 ++--
 11 files changed, 83 insertions(+), 58 deletions(-)

-- 
2.17.1

