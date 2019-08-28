Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1931A0C0A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfH1VER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbfH1VEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:15 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SL4703028850
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=1jDmYSoVy2rDExjAsXWrEgtJ4ohgtMYJM4vqyRYBsZA=;
 b=QW6qqG6Xstgm6RNIDS8R9W+by4b89PYa5upkJY5mEZLE72l9tlvL9kqUqT5A/LsbRDYd
 nJLPT26xS+gTvJG+OKX/p7AvuEV/7vYHAUmn58/NP/epiXMsK3GTS4+1U2YdrTeaWu9G
 YVbc9OsAHPjexU4LIYJQSeF7PtVbqN/LL0o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvfyhhng-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:13 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 14:03:53 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id 72AC6A25D5C9; Wed, 28 Aug 2019 14:03:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 00/10] bpf: bpf_(prog|map|attach)_type_(from|to)_str helpers
Date:   Wed, 28 Aug 2019 14:03:03 -0700
Message-ID: <cover.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908280206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Standardize commonly used bpf enum names by introducing helper methods to
libbpf.
When applications require enum to string mapping the related code is
copy-pasted from bpftool. It hardens maintenance, e.g. when new enum
values are added.

Patches 0001-0003 introduce __MAX_BPF_PROG_TYPE and __MAX_BPF_MAP_TYPE enum
type.
Patches 0004-0006 introduce helpers methods
libbpf_str_from_(prog|map|attach)_type and
libbpf_(prog|map|attach)_type_from_str.
Patches 0007-0008 extend and rename test_section_names test.
Patches 0009-0010 introduce the helpers to bpftool.

An alternative for adding __MAX_BPF_(PROG|MAP)_TYPE is using an erroneous
result of bpf_(prog|map|attach)_type_(from|to)_str as an indicator of
loop bound. The disadvantages are: tests won't fail when a string name
is not provided for a new enum value; whoever wants to loop over enum
values should be aware about this side feature of newly introduced helpers.

Julia Kartseva (10):
  bpf: introduce __MAX_BPF_PROG_TYPE and __MAX_BPF_MAP_TYPE enum values
  tools/bpf: sync bpf.h to tools/
  tools/bpf: handle __MAX_BPF_(PROG|MAP)_TYPE in switch statements
  tools/bpf: add libbpf_prog_type_(from|to)_str helpers
  tools/bpf: add libbpf_map_type_(from|to)_str helpers
  tools/bpf: add libbpf_attach_type_(from|to)_str
  selftests/bpf: extend test_section_names with type_(from|to)_str
  selftests/bpf: rename test_section_names to
    test_section_and_type_names
  tools/bpftool: use libbpf_(prog|map)_type_to_str helpers
  tools/bpftool: use libbpf_attach_type_to_str helper

 include/uapi/linux/bpf.h                      |   6 +
 tools/bpf/bpftool/cgroup.c                    |  60 +--
 tools/bpf/bpftool/feature.c                   |  47 ++-
 tools/bpf/bpftool/main.h                      |  33 --
 tools/bpf/bpftool/map.c                       |  80 +---
 tools/bpf/bpftool/prog.c                      |  31 +-
 tools/include/uapi/linux/bpf.h                |   6 +
 tools/lib/bpf/libbpf.c                        | 153 +++++++
 tools/lib/bpf/libbpf.h                        |  17 +
 tools/lib/bpf/libbpf.map                      |   6 +
 tools/lib/bpf/libbpf_probes.c                 |   2 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../bpf/test_section_and_type_names.c         | 378 ++++++++++++++++++
 .../selftests/bpf/test_section_names.c        | 233 -----------
 14 files changed, 673 insertions(+), 381 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_section_and_type_names.c
 delete mode 100644 tools/testing/selftests/bpf/test_section_names.c

-- 
2.17.1

