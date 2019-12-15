Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9F11F6BC
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 08:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfLOHIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 02:08:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60490 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbfLOHIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 02:08:50 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBF77Me5030896
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 23:08:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=kHZMS/PwvMTKOTlmmhL8ngUxDS3HYRtf2MSxDrn7VaE=;
 b=eCgWoUjPOiRHVCNo+XbjEcG3kAUKTCRC1fRHAx9YwGmyqSJ0uAiDAZRSJJAWlxvxX3KB
 Nb2lDUx9v4lW+pWPg3wbewoKMriXHmpd3aF6bfinWvbF7K5lbKk89DAuTlHB7mEaJbEa
 UNH5rv+jjWgHv6vGJbGUsVplRpOYUmiKw10= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wvv462smv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 23:08:49 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 14 Dec 2019 23:08:47 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 042182EC1683; Sat, 14 Dec 2019 23:08:46 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/2] CO-RE relocation support for flexible arrays
Date:   Sat, 14 Dec 2019 23:08:42 -0800
Message-ID: <20191215070844.1014385-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_01:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=8 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 mlxlogscore=595 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for flexible array accesses in a relocatable manner in BPF CO-RE.
It's a typical pattern in C, and kernel in particular, to provide
a fixed-length struct with zero-sized or dimensionless array at the end. In
such cases variable-sized array contents follows immediately after the end of
a struct. This patch set adds support for such access pattern by allowing
accesses to such arrays.

Patch #1 adds libbpf support. Patch #2 adds few test cases for validation.

Andrii Nakryiko (2):
  libbpf: support flexible arrays in CO-RE
  selftests/bpf: add flexible array relocation tests

 tools/lib/bpf/libbpf.c                        | 34 +++++++++++++---
 .../selftests/bpf/prog_tests/core_reloc.c     |  4 ++
 ...f__core_reloc_arrays___equiv_zero_sz_arr.c |  3 ++
 ..._core_reloc_arrays___err_bad_zero_sz_arr.c |  3 ++
 .../btf__core_reloc_arrays___fixed_arr.c      |  3 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 39 +++++++++++++++++++
 .../bpf/progs/test_core_reloc_arrays.c        |  8 ++--
 7 files changed, 85 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___equiv_zero_sz_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_bad_zero_sz_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___fixed_arr.c

-- 
2.17.1

