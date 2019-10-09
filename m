Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BA6D197B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbfJIUPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:15:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64522 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731254AbfJIUPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:15:12 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99KEXZw020836
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 13:15:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=78SYb24LqN4mVB7wgWj5QvycWtv5qCPdSD44Rv0u5Sk=;
 b=e6QdWh8Vualgg1Uzt+imzczozgvj0IDKDYoifSXoo16STbbpT8camleeZQgR76iP+NDG
 MgSj2hfoBWrZhGu4ng2Q/4/0hMLzLukwtp5kD0UDqyKESLpti6t7WEvx9gvSEyIiHDsh
 OqsnpqeA9ioCRO+nUOH+F/JYp1MAjJLZUIk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vh6awc6qb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:15:11 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 9 Oct 2019 13:15:07 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 7201486191B; Wed,  9 Oct 2019 13:15:01 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/2] Track read-only map contents as known scalars in BPF verifiers
Date:   Wed, 9 Oct 2019 13:14:56 -0700
Message-ID: <20191009201458.2679171-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_09:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=8 spamscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=604 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With BPF maps supporting direct map access (currently, array_map w/ single
element, used for global data) that are read-only both from system call and
BPF side, it's possible for BPF verifier to track its contents as known
constants.

Now it's possible for user-space control app to pre-initialize read-only map
(e.g., for .rodata section) with user-provided flags and parameters and rely
on BPF verifier to detect and eliminate dead code resulting from specific
combination of input parameters.

v1->v2:
- BPF_F_RDONLY means nothing, stick to just map->frozen (Daniel);
- stick to passing just offset into map_direct_value_addr (Martin).

Andrii Nakryiko (2):
  bpf: track contents of read-only maps as scalars
  selftests/bpf: add read-only map values propagation tests

 kernel/bpf/verifier.c                         | 57 ++++++++++-
 .../selftests/bpf/prog_tests/rdonly_maps.c    | 99 +++++++++++++++++++
 .../selftests/bpf/progs/test_rdonly_maps.c    | 83 ++++++++++++++++
 3 files changed, 237 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_rdonly_maps.c

-- 
2.17.1

