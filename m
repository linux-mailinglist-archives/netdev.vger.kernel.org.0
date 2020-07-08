Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A234217CCC
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgGHBx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:53:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbgGHBx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:53:26 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681r0Mr023096
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:53:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=aLozRH8QA8pa4wgTxRX8nO0d/fW5eY/X566EgGILmBA=;
 b=CsLaUozC3MJp3RAZ3haQDa0cVD1Wa1JGdOtewo8f7N4kBpFN0YzVOGPpEJKR2ey7KRFD
 iy2bsZ3A6vwJEXFonRyvubqjqA54X2YUO/xn9ROmx0UzwI5AZh20wocCJVQPP3VKCQF3
 g/TXOnpupiechycuSxTbSe0hlgCn15TfBSk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3239rs4xdt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:53:25 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:53:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 844622EC39F5; Tue,  7 Jul 2020 18:53:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Matthew Lim <matthewlim@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/6] Improve libbpf support of old kernels
Date:   Tue, 7 Jul 2020 18:53:12 -0700
Message-ID: <20200708015318.3827358-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=685
 mlxscore=0 suspectscore=8 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 cotscore=-2147483648 lowpriorityscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set improves libbpf's support of old kernels, missing features=
 like
BTF support, global variables support, etc.

Most critical one is a silent drop of CO-RE relocations if libbpf fails t=
o
load BTF (despite sanitization efforts). This is frequently the case for
kernels that have no BTF support whatsoever. There are still useful BPF
applications that could work on such kernels and do rely on CO-RE. To tha=
t
end, this series revamps the way BTF is handled in libbpf. Failure to loa=
d BTF
into kernel doesn't prevent libbpf from using BTF in its full capability
(e.g., for CO-RE relocations) internally.

Another issue that was identified was reliance of perf_buffer__new() on
BPF_OBJ_GET_INFO_BY_FD command, which is more recent that perf_buffer sup=
port
itself. Furthermore, BPF_OBJ_GET_INFO_BY_FD is needed just for some sanit=
y
checks to provide better user errors, so could be safely omitted if kerne=
l
doesn't provide it.

Perf_buffer selftest was adjusted to use skeleton, instead of bpf_prog_lo=
ad().
The latter uses BPF_F_TEST_RND_HI32 flag, which is a relatively recent
addition and unnecessary fails selftest in libbpf's Travis CI tests. By u=
sing
skeleton we both get a shorter selftest and it work on pretty ancient ker=
nels,
giving better libbpf test coverage.

One new selftest was added that relies on basic CO-RE features, but other=
wise
doesn't expect any recent features (like global variables) from kernel. A=
gain,
it's good to have better coverage of old kernels in libbpf testing.

Cc: Matthew Lim <matthewlim@fb.com>

Andrii Nakryiko (6):
  libbpf: make BTF finalization strict
  libbpf: add btf__set_fd() for more control over loaded BTF FD
  libbpf: improve BTF sanitization handling
  selftests/bpf: add test relying only on CO-RE and no recent kernel
    features
  libbpf: handle missing BPF_OBJ_GET_INFO_BY_FD gracefully in
    perf_buffer
  selftests/bpf: switch perf_buffer test to tracepoint and skeleton

 tools/lib/bpf/btf.c                           |   7 +-
 tools/lib/bpf/btf.h                           |   1 +
 tools/lib/bpf/libbpf.c                        | 150 ++++++++++--------
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/core_retro.c     |  33 ++++
 .../selftests/bpf/prog_tests/perf_buffer.c    |  42 ++---
 .../selftests/bpf/progs/test_core_retro.c     |  30 ++++
 .../selftests/bpf/progs/test_perf_buffer.c    |   4 +-
 8 files changed, 167 insertions(+), 101 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_retro.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_retro.c

--=20
2.24.1

