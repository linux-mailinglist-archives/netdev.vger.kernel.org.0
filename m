Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B618A152
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgCRRQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:16:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25602 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbgCRRQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 13:16:36 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IHDIHm013665
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:16:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=hgDX6MRXQEvO2IgAs0ofKOYGeGkU/zmoIxwq7kkjWiA=;
 b=BkMhQETjATa1n0fuv1b2UymYMs3el7prEKWkQ35FJyqE+X6sbFs4Z1rvNc5HDSMlkabr
 mtTGXaScmLvNmsV7dmMrVmLqXTAvnAatY/8go9yac29ov22T/KwMC+aFV24lB+jrJzA0
 e2LlA2r5POI0fSmaYK2B3V1Q3uE1+I2RTQU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yua0wug4w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:16:35 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 10:16:34 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5D04529425EF; Wed, 18 Mar 2020 10:16:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/4] bpftool: Add struct_ops support
Date:   Wed, 18 Mar 2020 10:16:31 -0700
Message-ID: <20200318171631.128566-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=439
 priorityscore=1501 impostorscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0 clxscore=1015
 suspectscore=13 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180077
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds "struct_ops" support to bpftool.

The first two patches improve the btf_dumper in bpftool.
Patch 1: print the enum's name (if it is found) instead of the
         enum's value.
Patch 2: print a char[] as a string if all characters are printable.

"struct_ops" stores the prog_id in a func ptr.
Instead of printing a prog_id,
patch 3 adds an option to btf_dumper to allow a func ptr's value
to be printed with the full func_proto info and the prog_name.

Patch 4 implements the "struct_ops" bpftool command.

v4:
- Return -EINVAL in patch 1 (Andrii)

v3:
- Check for "case 1:" in patch 1 (Andrii)

v2:
- Typo fixes in comment and doc in patch 4 (Quentin)
- Link to a few other man pages in doc in patch 4 (Quentin)
- Alphabet ordering in include files in patch 4 (Quentin)
- Use GET_ARG() in patch 4 (Quentin)

Martin KaFai Lau (4):
  bpftool: Print the enum's name instead of value
  bpftool: Print as a string for char array
  bpftool: Translate prog_id to its bpf prog_name
  bpftool: Add struct_ops support

 .../Documentation/bpftool-struct_ops.rst      | 116 ++++
 tools/bpf/bpftool/bash-completion/bpftool     |  28 +
 tools/bpf/bpftool/btf_dumper.c                | 199 +++++-
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   2 +
 tools/bpf/bpftool/struct_ops.c                | 596 ++++++++++++++++++
 6 files changed, 927 insertions(+), 17 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
 create mode 100644 tools/bpf/bpftool/struct_ops.c

-- 
2.17.1

