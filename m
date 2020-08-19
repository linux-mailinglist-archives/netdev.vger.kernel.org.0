Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC924926A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgHSBgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:36:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58226 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgHSBgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:36:14 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J1aBk9029355
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:36:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ctXDmn/1Vu2V+lzkz+r0BIlUDSWIIqxD2cOzSY9Fn8E=;
 b=ppZpETwNGO8Nw/treGrc/CrD9xzJi++GkdusXO2/IbxMfswfpKMv7hC4T+fdbr2+3dUv
 7eZhh3aY0VA5V59iRHfzxV93XX0RoGqNv0HfdLN1NmHNRBtmlXZg7qQZnW8uwsx9yzHc
 N+n6x4zD86A1ZFEJASXj4zxtYf4/dCCvjMY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304prp46c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 18:36:12 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 18:36:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4EB722EC5F07; Tue, 18 Aug 2020 18:36:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/4] libbpf: minimize feature detection (reallocarray, libelf-mmap)
Date:   Tue, 18 Aug 2020 18:36:03 -0700
Message-ID: <20200819013607.3607269-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 suspectscore=8 clxscore=1015 mlxlogscore=877 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of two feature detectors: reallocarray and libelf-mmap. Optional
feature detections complicate libbpf Makefile and cause more troubles for
various applications that want to integrate libbpf as part of their build=
.

Patch #1 replaces all reallocarray() uses into libbpf-internal reallocarr=
ay()
implementation. Patches #2 and #3 makes sure we won't re-introduce
reallocarray() accidentally. Patch #2 also removes last use of
libbpf_internal.h header inside bpftool. There is still nlattr.h that's u=
sed
by both libbpf and bpftool, but that's left for a follow up patch to spli=
t.
Patch #4 removed libelf-mmap feature detector and all its uses, as it's
trivial to handle missing mmap support in libbpf, the way objtool has bee=
n
doing it for a while.

v1->v2 and v2->v3:
  - rebase to latest bpf-next (Alexei).

Andrii Nakryiko (4):
  libbpf: remove any use of reallocarray() in libbpf
  tools/bpftool: remove libbpf_internal.h usage in bpftool
  libbpf: centralize poisoning and poison reallocarray()
  tools: remove feature-libelf-mmap feature detection

 tools/bpf/bpftool/gen.c                |   2 -
 tools/bpf/bpftool/net.c                | 299 +++++++++++++++++++++++--
 tools/build/Makefile.feature           |   1 -
 tools/build/feature/Makefile           |   4 -
 tools/build/feature/test-all.c         |   4 -
 tools/build/feature/test-libelf-mmap.c |   9 -
 tools/lib/bpf/Makefile                 |  10 +-
 tools/lib/bpf/bpf.c                    |   3 -
 tools/lib/bpf/bpf_prog_linfo.c         |   3 -
 tools/lib/bpf/btf.c                    |  14 +-
 tools/lib/bpf/btf_dump.c               |   9 +-
 tools/lib/bpf/hashmap.c                |   3 +
 tools/lib/bpf/libbpf.c                 |  38 ++--
 tools/lib/bpf/libbpf_internal.h        |  44 +++-
 tools/lib/bpf/libbpf_probes.c          |   3 -
 tools/lib/bpf/netlink.c                | 128 +----------
 tools/lib/bpf/nlattr.c                 |   9 +-
 tools/lib/bpf/ringbuf.c                |   8 +-
 tools/lib/bpf/xsk.c                    |   3 -
 tools/perf/Makefile.config             |   4 -
 tools/perf/util/symbol.h               |   2 +-
 21 files changed, 353 insertions(+), 247 deletions(-)
 delete mode 100644 tools/build/feature/test-libelf-mmap.c

--=20
2.24.1

