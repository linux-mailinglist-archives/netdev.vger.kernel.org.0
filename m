Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77EF125664
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfLRWRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:17:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfLRWRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:17:19 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIMHCCk017285
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 14:17:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=6oVoRIUSx1VS5czrR0Dgk46K3WidI6qmXRlUZSbYIvI=;
 b=V6ZRHO4eTgUN1DGkMUCRPvG8nN+z+wgbdUNTbBaWvn9Erhc0QG+zlPStahKUj0nJgpp6
 u6vOV4eoJHBmhzo7Ip5Q2hNbbxC9mSlTuxSTofmEQQyMf5FF3MyrDxA4haqEh95WJeQ2
 mBTwAFy26QFRvQzUzzhaKDGVBBXVIc4Lp14= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2wykmqk041-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 14:17:18 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 18 Dec 2019 14:17:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CAD252EC1761; Wed, 18 Dec 2019 14:17:08 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpftool: work-around rst2man conversion bug
Date:   Wed, 18 Dec 2019 14:17:07 -0800
Message-ID: <20191218221707.2552199-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_07:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=8 priorityscore=1501 malwarescore=0 mlxlogscore=774
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180169
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work-around what appears to be a bug in rst2man convertion tool, used to
create man pages out of reStructureText-formatted documents. If text line
starts with dot, rst2man will put it in resulting man file verbatim. This
seems to cause man tool to interpret it as a directive/command (e.g., `.bs`), and
subsequently not render entire line because it's unrecognized one.

Enclose '.xxx' words in extra formatting to work around.

Fixes: cb21ac588546 ("bpftool: Add gen subcommand manpage")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Documentation/bpftool-gen.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index b6a114bf908d..86a87da97d0b 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -112,13 +112,14 @@ DESCRIPTION
 
 		  If BPF object has global variables, corresponding structs
 		  with memory layout corresponding to global data data section
-		  layout will be created. Currently supported ones are: .data,
-		  .bss, .rodata, and .extern structs/data sections. These
-		  data sections/structs can be used to set up initial values of
-		  variables, if set before **example__load**. Afterwards, if
-		  target kernel supports memory-mapped BPF arrays, same
-		  structs can be used to fetch and update (non-read-only)
-		  data from userspace, with same simplicity as for BPF side.
+		  layout will be created. Currently supported ones are: *.data*,
+		  *.bss*, *.rodata*, and *.kconfig* structs/data sections.
+		  These data sections/structs can be used to set up initial
+		  values of variables, if set before **example__load**.
+		  Afterwards, if target kernel supports memory-mapped BPF
+		  arrays, same structs can be used to fetch and update
+		  (non-read-only) data from userspace, with same simplicity
+		  as for BPF side.
 
 	**bpftool gen help**
 		  Print short help message.
-- 
2.17.1

