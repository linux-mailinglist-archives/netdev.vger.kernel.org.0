Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1005D12586F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLSA2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:28:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45602 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726536AbfLSA2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:28:42 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBJ0Q6wK023922
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=vfbQhXh/Xakk69vVb2LLOej57QJn3aEootPFG+x1SRU=;
 b=e1oePF/rI3sGpjTC+g/AkrAA5XVNiRKY3r5dDlYReTuxAsElqNcfJ1X86lmdCiQle+z7
 Flt4PQ3JTZlJPRjFkCA9lVbDWqkUUcjiHO8waymmt/auSjs0AYBAVRRwE6RMRqBbs291
 ly8IcTWkOHXDXsRcRd/Z2mxbiv8yU19UNgU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wyhy23w3j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 16:28:41 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 18 Dec 2019 16:28:39 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BAEBE2EC18AF; Wed, 18 Dec 2019 16:28:38 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] Libbpf extern support improvements
Date:   Wed, 18 Dec 2019 16:28:33 -0800
Message-ID: <20191219002837.3074619-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=8 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=949 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912190002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on latest feedback and discussions, this patch set implements the
following changes:

- Kconfig-provided externs have to be in .kconfig section, for which
  bpf_helpers.h provides convenient __kconfig macro (Daniel);
- instead of allowing to override Kconfig file path, switch this to ability to
  extend and override system Kconfig with user-provided custom values (Alexei);
- BTF is required when externs are used.

Andrii Nakryiko (3):
  libbpf: put Kconfig externs into .kconfig section
  libbpf: allow to augment system Kconfig through extra optional config
  libbpf: BTF is required when externs are present

 tools/bpf/bpftool/gen.c                       |   8 +-
 tools/lib/bpf/bpf_helpers.h                   |   2 +
 tools/lib/bpf/libbpf.c                        | 265 +++++++++++-------
 tools/lib/bpf/libbpf.h                        |   8 +-
 .../selftests/bpf/prog_tests/core_extern.c    |  32 +--
 .../selftests/bpf/prog_tests/skeleton.c       |  16 +-
 .../selftests/bpf/progs/test_core_extern.c    |  20 +-
 .../selftests/bpf/progs/test_skeleton.c       |   4 +-
 8 files changed, 194 insertions(+), 161 deletions(-)

-- 
2.17.1

