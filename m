Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D3617698D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgCCAvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:51:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727413AbgCCAvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:51:21 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0230jfuB021987
        for <netdev@vger.kernel.org>; Mon, 2 Mar 2020 16:51:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=JYyvpVzgH0eSwDfDw3bktB0T0fqsogGIVZcGdsikBj4=;
 b=Vpa2HsFYFEKBbBKQJrq2/gOkm/XjlFhe2csalEcc3va5UZ0Xle+yMNRrxcreo49KVjAI
 0z6kOMYO+XxT0+7lfM75/CotiX78SoRU4cjHD53pCHkN4PYi8oFbFD90YqHxXeof5zgN
 z4SkHuacMfJUxfbMOKz+JGzn6hNZP7GYwM4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8dcywqd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 16:51:20 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 16:51:12 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 282992EC2E79; Mon,  2 Mar 2020 16:51:09 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/3] Convert BPF UAPI constants into enum values
Date:   Mon, 2 Mar 2020 16:32:30 -0800
Message-ID: <20200303003233.3496043-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=8 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=265 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert BPF-related UAPI constants, currently defined as #define macro, into
anonymous enums. This has no difference in terms of usage of such constants in
C code (they are still could be used in all the compile-time contexts that
`#define`s can), but they are recorded as part of DWARF type info, and
subsequently get recorded as part of kernel's BTF type info. This allows those
constants to be emitted as part of vmlinux.h auto-generated header file and be
used from BPF programs. Which is especially convenient for all kinds of BPF
helper flags and makes CO-RE BPF programs nicer to write.

libbpf's btf_dump logic currently assumes enum values are signed 32-bit
values, but that doesn't match a typical case, so switch it to emit unsigned
values. Once BTF encoding of BTF_KIND_ENUM is extended to capture signedness
properly, this will be made more flexible.

As an immediate validation of the approach, runqslower's copy of
BPF_F_CURRENT_CPU #define is dropped in favor of its enum variant from
vmlinux.h.

v2->v3:
- convert only constants usable from BPF programs (BPF helper flags, map
  create flags, etc) (Alexei);

v1->v2:
- fix up btf_dump test to use max 32-bit unsigned value instead of negative one.


Andrii Nakryiko (3):
  bpf: switch BPF UAPI #define constants used from BPF program side to
    enums
  libbpf: assume unsigned values for BTF_KIND_ENUM
  tools/runqslower: drop copy/pasted BPF_F_CURRENT_CPU definiton

 include/uapi/linux/bpf.h                      | 175 ++++++++++-------
 tools/bpf/runqslower/runqslower.bpf.c         |   3 -
 tools/include/uapi/linux/bpf.h                | 177 +++++++++++-------
 tools/lib/bpf/btf_dump.c                      |   8 +-
 .../bpf/progs/btf_dump_test_case_syntax.c     |   2 +-
 5 files changed, 224 insertions(+), 141 deletions(-)

-- 
2.17.1

