Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4052C2795D8
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgIZBOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:14:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13828 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729874AbgIZBOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:14:34 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08Q16Rsx008821
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=5nkWAVkFufaH2PSMQ+FABwS1UCoQwNF3XepkyUdFiQ4=;
 b=Q0XX7pCuWTZmXbj8QELeER+k7KoK6sR+aZ3QCq3HJmdFsKnGjXZwvR+Ow/cXcC0VGxQP
 LoCm3Y/iaY0A6JPql2GFz79xpueyzdC94C98NGaXMOnrLEv6AgUiJ48/AQzBv9vhZ/tE
 MUySXZW4VYlVKeMfdX+xvahxfe2omY/7pzU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33qsp5aq5w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 18:14:33 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 18:14:31 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 844142EC75B0; Fri, 25 Sep 2020 18:14:23 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v2 bpf-next 0/9] libbpf: BTF writer APIs
Date:   Fri, 25 Sep 2020 18:13:48 -0700
Message-ID: <20200926011357.2366158-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=506 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009260005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a new set of BTF APIs to libbpf that allow to
conveniently produce BTF types and strings. Internals of struct btf were
changed such that it can transparently and automatically switch to writab=
le
mode, which allows appending BTF types and strings. This will allow for l=
ibbpf
itself to do more intrusive modifications of program's BTF (by rewriting =
it,
at least as of right now), which is necessary for the upcoming libbpf sta=
tic
linking. But they are complete and generic, so can be adopted by anyone w=
ho
has a need to produce BTF type information.

One such example outside of libbpf is pahole, which was actually converte=
d to
these APIs (locally, pending landing of these changes in libbpf) complete=
ly
and shows reduction in amount of custom pahole code necessary and brings =
nice
savings in memory usage (about 370MB reduction at peak for my kernel
configuration) and even BTF deduplication times (one second reduction,
23.7s -> 22.7s). Memory savings are due to avoiding pahole's own copy of
"uncompressed" raw BTF data. Time reduction comes from faster string
search and deduplication by relying on hashmap instead of BST used by pah=
ole's
own code. Consequently, these APIs are already tested on real-world
complicated kernel BTF, but there is also pretty extensive selftest doing
extra validations.

Selftests in patch #9 add a set of generic ASSERT_{EQ,STREQ,ERR,OK} macro=
s
that are useful for writing shorter and less repretitive selftests. I dec=
ided
to keep them local to that selftest for now, but if they prove to be usef=
ul in
more contexts we should move them to test_progs.h. And few more (e.g.,
inequality tests) macros are probably necessary to have a more complete s=
et.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

v1->v2:
  - fixed comments (John);
  - renamed btf__append_xxx() into btf__add_xxx() (Alexei);
  - added btf__find_str() in addition to btf__add_str();
  - btf__new_empty() now sets kernel FD to -1 initially.

Andrii Nakryiko (9):
  libbpf: refactor internals of BTF type index
  libbpf: remove assumption of single contiguous memory for BTF data
  libbpf: generalize common logic for managing dynamically-sized arrays
  libbpf: extract generic string hashing function for reuse
  libbpf: allow modification of BTF and add btf__add_str API
  libbpf: add btf__new_empty() to create an empty BTF object
  libbpf: add BTF writing APIs
  libbpf: add btf__str_by_offset() as a more generic variant of
    name_by_offset
  selftests/bpf: test BTF writing APIs

 tools/lib/bpf/bpf.c                           |    2 +-
 tools/lib/bpf/bpf.h                           |    2 +-
 tools/lib/bpf/btf.c                           | 1343 +++++++++++++++--
 tools/lib/bpf/btf.h                           |   44 +
 tools/lib/bpf/btf_dump.c                      |    9 +-
 tools/lib/bpf/hashmap.h                       |   12 +
 tools/lib/bpf/libbpf.map                      |   23 +
 tools/lib/bpf/libbpf_internal.h               |    3 +
 .../selftests/bpf/prog_tests/btf_write.c      |  278 ++++
 9 files changed, 1596 insertions(+), 120 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_write.c

--=20
2.24.1

