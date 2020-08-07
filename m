Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4124423F414
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgHGVGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:06:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56024 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgHGVGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:06:36 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077KuuTn007121
        for <netdev@vger.kernel.org>; Fri, 7 Aug 2020 14:06:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=xA+PJgaP2MGZT8owly/cFRkq/+6SX04kkzCp/aaprd8=;
 b=na6mS3PRY4Y2j5BTkbDC7QpTRv00vAlXsaqJ/1I4SrGm/NfMMmFJ1vyOWPcudOdpu0oE
 YPtzS/mbbWaPgiQRhvdnpXAOVN5dhyVUf9GlmO5oIx4TUk/OsRzvAPn/sIH3O/g0EZFM
 D/TAK3tFE2ZgIfjNO9WRgbLAj63IGKzt5fE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32s96m9pv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:06:35 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 7 Aug 2020 14:06:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 758062EC5494; Fri,  7 Aug 2020 14:06:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 0/7] libbpf feature probing and sanitization improvements
Date:   Fri, 7 Aug 2020 14:06:22 -0700
Message-ID: <20200807210629.394335-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_20:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 mlxlogscore=799 spamscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=8 adultscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set refactors libbpf feature probing to be done lazily on as-n=
eeded
basis, instead of proactively testing all possible features libbpf knows
about. This allows to scale such detections and mitigations better, witho=
ut
issues unnecessary syscalls on each bpf_object__load() call. It's also no=
w
memoized globally, instead of per-bpf_object.

Building on that, libbpf will now detect availability of
bpf_probe_read_kernel() helper (which means also -user and -str variants)=
, and
will sanitize BPF program code by replacing such references to generic
variants (bpf_probe_read[_str]()). This allows to migrate all BPF program=
s
into proper -kernel/-user probing helpers, without the fear of breaking t=
hem
for old kernels.

With that, update BPF_CORE_READ() and related macros to use
bpf_probe_read_kernel(), as it doesn't make much sense to do CO-RE reloca=
tions
against user-space types. And the only class of cases in which BPF progra=
m
might read kernel type from user-space are UAPI data structures which by
definition are fixed in their memory layout and don't need relocating. Th=
is is
exemplified by test_vmlinux test, which is fixed as part of this patch se=
t as
well. BPF_CORE_READ() is useful for chainingg bpf_probe_read_{kernel,user=
}()
calls together even without relocation, so we might add user-space varian=
ts,
if there is a need.

While at making libbpf more useful for older kernels, also improve handli=
ng of
a complete lack of BTF support in kernel by not even attempting to load B=
TF
info into kernel. This eliminates annoying warning about lack of BTF supp=
ort
in the kernel and map creation retry without BTF. If user is using featur=
es
that require kernel BTF support, it will still fail, of course.

Andrii Nakryiko (7):
  libbpf: disable -Wswitch-enum compiler warning
  libbpf: make kernel feature probing lazy
  libbpf: factor out common logic of testing and closing FD
  libbpf: sanitize BPF program code for
    bpf_probe_read_{kernel,user}[_str]
  selftests/bpf: fix test_vmlinux test to use bpf_probe_read_user()
  libbpf: switch tracing and CO-RE helper macros to
    bpf_probe_read_kernel()
  libbpf: detect minimal BTF support and skip BTF loading, if missing

 tools/lib/bpf/Makefile                        |   2 +-
 tools/lib/bpf/bpf_core_read.h                 |  40 ++-
 tools/lib/bpf/bpf_tracing.h                   |   4 +-
 tools/lib/bpf/libbpf.c                        | 319 +++++++++++-------
 .../selftests/bpf/progs/test_vmlinux.c        |  12 +-
 5 files changed, 240 insertions(+), 137 deletions(-)

--=20
2.24.1

