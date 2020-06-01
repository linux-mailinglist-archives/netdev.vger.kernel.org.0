Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A6C1EB029
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgFAU0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:26:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1764 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbgFAU0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:26:07 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 051KNDC6032519
        for <netdev@vger.kernel.org>; Mon, 1 Jun 2020 13:26:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=jhVyv6SCTRhzcDbzRM8m3iHR5YxHnLZfRHg/sXy5jco=;
 b=Jh2daGpQykN0yGVwI3SBQweg3X+FGVGJVA7KWidJJXlVkMhHd27Rkfop2p4Dz2hiUCps
 jvBs4QgS8RJgoSKatFnn05clGBZ+m9E2tw7GRwewCkC+3LlUYdwkjR/sNgepc7pRp3Um
 j8KddyuMr0p4AuNr0hgkYB/FT2aktH3oZSo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31bnafq636-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 13:26:06 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Jun 2020 13:26:04 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 526082EC2FCF; Mon,  1 Jun 2020 13:26:03 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: add _GNU_SOURCE for reallocarray to ringbuf.c
Date:   Mon, 1 Jun 2020 13:26:01 -0700
Message-ID: <20200601202601.2139477-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-01_12:2020-06-01,2020-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=507 impostorscore=0 bulkscore=0 clxscore=1015
 phishscore=0 suspectscore=8 adultscore=0 mlxscore=0 spamscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006010148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On systems with recent enough glibc, reallocarray compat won't kick in, s=
o
reallocarray() itself has to come from stdlib.h include. But _GNU_SOURCE =
is
necessary to enable it. So add it.

Fixes: 4cff2ba58bf1 ("libbpf: Add BPF ring buffer support")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/ringbuf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index bc10fa1d43c7..4fc6c6cbb4eb 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -4,6 +4,9 @@
  *
  * Copyright (C) 2020 Facebook, Inc.
  */
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
 #include <stdlib.h>
 #include <stdio.h>
 #include <errno.h>
--=20
2.24.1

