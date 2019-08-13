Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC0A8C4BB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfHMXYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:24:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfHMXYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:24:20 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7DNKE3N010880
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 16:24:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=DMg04JCl1FAfGv0Hw1fgThC1dABfy2HbaEJvpxyuano=;
 b=ms3plO3dFxZh146uPho5hJZrFn6TQ4ApapnblmStnU91O3BDsjPNsD5BDU/t904hxM7z
 2BL+H3LSpbRHKuKyn0IZLKtRZ3lN7gNCYTFYbNlsgxIy2Db486Q5AC9MsU6W1r0JKdKB
 FXBZd1n2dZANyzJDVAvmU2B2In4Ac+U3VL4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uc1muhg5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 16:24:19 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 13 Aug 2019 16:24:18 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id BAB8C86150E; Tue, 13 Aug 2019 16:24:15 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: make libbpf.map source of truth for libbpf version
Date:   Tue, 13 Aug 2019 16:24:08 -0700
Message-ID: <20190813232408.1246694-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130220
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently libbpf version is specified in 2 places: libbpf.map and
Makefile. They easily get out of sync and it's very easy to update one,
but forget to update another one. In addition, Github projection of
libbpf has to maintain its own version which has to be remembered to be
kept in sync manually, which is very error-prone approach.

This patch makes libbpf.map a source of truth for libbpf version and
uses shell invocation to parse out correct full and major libbpf version
to use during build. Now we need to make sure that once new release
cycle starts, we need to add (initially) empty section to libbpf.map
with correct latest version.

This also will make it possible to keep Github projection consistent
with kernel sources version of libbpf by adopting similar parsing of
version from libbpf.map.

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Makefile   | 12 +++++-------
 tools/lib/bpf/libbpf.map |  3 +++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 9312066a1ae3..d9afc8509725 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -1,9 +1,10 @@
 # SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
 # Most of this file is copied from tools/lib/traceevent/Makefile
 
-BPF_VERSION = 0
-BPF_PATCHLEVEL = 0
-BPF_EXTRAVERSION = 4
+BPF_FULL_VERSION = $(shell \
+	grep -E 'LIBBPF_([0-9]+)\.([0-9]+)\.([0-9]+) \{' libbpf.map | \
+	tail -n1 | cut -d'_' -f2 | cut -d' ' -f1)
+BPF_VERSION = $(firstword $(subst ., ,$(BPF_FULL_VERSION)))
 
 MAKEFLAGS += --no-print-directory
 
@@ -79,15 +80,12 @@ export prefix libdir src obj
 libdir_SQ = $(subst ','\'',$(libdir))
 libdir_relative_SQ = $(subst ','\'',$(libdir_relative))
 
+LIBBPF_VERSION	= $(BPF_FULL_VERSION)
 VERSION		= $(BPF_VERSION)
-PATCHLEVEL	= $(BPF_PATCHLEVEL)
-EXTRAVERSION	= $(BPF_EXTRAVERSION)
 
 OBJ		= $@
 N		=
 
-LIBBPF_VERSION	= $(BPF_VERSION).$(BPF_PATCHLEVEL).$(BPF_EXTRAVERSION)
-
 LIB_TARGET	= libbpf.a libbpf.so.$(LIBBPF_VERSION)
 LIB_FILE	= libbpf.a libbpf.so*
 PC_FILE		= libbpf.pc
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index f9d316e873d8..4e72df8e98ba 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -184,3 +184,6 @@ LIBBPF_0.0.4 {
 		perf_buffer__new_raw;
 		perf_buffer__poll;
 } LIBBPF_0.0.3;
+
+LIBBPF_0.0.5 {
+} LIBBPF_0.0.4;
-- 
2.17.1

