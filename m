Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BECD0163
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbfJHTqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:46:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729935AbfJHTqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:46:00 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98JjhCH002990
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 12:45:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=4ZqodNMNzZghFxCeYdYkqXUZ3wwf06nIFSa1OQsT53g=;
 b=IXOBO9jkEoF6ka4d5hBoZ2HKkIOEwCTZvk+F1pa401KYFSD4kegYH53vipq/Prvb0CRf
 HHHPOg7CnYL2hf6xLvtS7TJiizKUSnoxcGH9gcTiBbJkBMfJSJTn/U10vO7vyRYB94Z4
 nlP5nnIUw7faVhsp+YGS8kR/1C+tuEYyyG4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vg6nmqayv-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:45:59 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 12:45:57 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 78B1E8618E0; Tue,  8 Oct 2019 12:45:56 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/2] Track read-only map contents as known scalars in BPF verifiers
Date:   Tue, 8 Oct 2019 12:45:46 -0700
Message-ID: <20191008194548.2344473-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_07:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 suspectscore=8
 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=694 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080151
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

Andrii Nakryiko (2):
  bpf: track contents of read-only maps as scalars
  selftests/bpf: add read-only map values propagation tests

 kernel/bpf/verifier.c                         | 58 ++++++++++-
 .../selftests/bpf/prog_tests/rdonly_maps.c    | 99 +++++++++++++++++++
 .../selftests/bpf/progs/test_rdonly_maps.c    | 83 ++++++++++++++++
 3 files changed, 238 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_rdonly_maps.c

-- 
2.17.1

