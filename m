Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA4F27BA9F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgI2CFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:05:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8016 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbgI2CFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 22:05:46 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T25jT0024140
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:05:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KNxveQPaHGG1pCEoyZRCMLeEvUZuqztPobe7iMtIl6Q=;
 b=rX0tl8naBpm7/bpWhrKQI6x1JLcr9ZmG4mGro6dEYA+j1K/3yCpnlU+cXTwjZuXXb2sG
 aL4sSNNESBK7XQlLYnAD/18JD1ex0jz4Pufhh26Kb+thy5kSKY0YUJF9yG4buEbLkkVo
 XhhRxCcti/WyOJzbjoxzg0vUAUxjUd3DjoY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33t3cpajy7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:05:45 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Sep 2020 19:05:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8F6B72EC773C; Mon, 28 Sep 2020 19:05:36 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v3 bpf-next 0/3] libbpf: BTF writer APIs
Date:   Mon, 28 Sep 2020 19:05:29 -0700
Message-ID: <20200929020533.711288-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-28,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxlogscore=343
 suspectscore=8 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a new set of BTF APIs to libbpf that allow to
conveniently produce BTF types and strings. These APIs will allow libbpf =
to do
more intrusive modifications of program's BTF (by rewriting it, at least =
as of
right now), which is necessary for the upcoming libbpf static linking. Bu=
t
they are complete and generic, so can be adopted by anyone who has a need=
 to
produce BTF type information.

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

Selftests in patch #3 add a set of generic ASSERT_{EQ,STREQ,ERR,OK} macro=
s
that are useful for writing shorter and less repretitive selftests. I dec=
ided
to keep them local to that selftest for now, but if they prove to be usef=
ul in
more contexts we should move them to test_progs.h. And few more (e.g.,
inequality tests) macros are probably necessary to have a more complete s=
et.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

v2->v3:
  - resending original patches #7-9 as patches #1-3 due to merge conflict=
;

v1->v2:
  - fixed comments (John);
  - renamed btf__append_xxx() into btf__add_xxx() (Alexei);
  - added btf__find_str() in addition to btf__add_str();
  - btf__new_empty() now sets kernel FD to -1 initially.

Andrii Nakryiko (3):
  libbpf: add BTF writing APIs
  libbpf: add btf__str_by_offset() as a more generic variant of
    name_by_offset
  selftests/bpf: test BTF writing APIs

 tools/lib/bpf/btf.c                           | 796 +++++++++++++++++-
 tools/lib/bpf/btf.h                           |  39 +
 tools/lib/bpf/libbpf.map                      |  20 +
 .../selftests/bpf/prog_tests/btf_write.c      | 278 ++++++
 4 files changed, 1128 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_write.c

--=20
2.24.1

