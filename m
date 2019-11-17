Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A853FF834
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfKQHIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:08:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37676 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbfKQHIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:08:41 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAH78clv021871
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=/VzIcsamFL10eFHhA9+aq4VqhPaMm0NUDW1QyjEMgqc=;
 b=oIAkDEIAoKUBvCdl7JgWkbQVlxyvpyClYYTXTm8Bw3f4/2LJDf9S/IPog6QVl6J06Ehq
 Do/3d91k3tw4nuiEY2BNa+3KpaKjmi21e7BBgrnpDIwvhbo+bg6Udy/4E9ZF9c3FmmoN
 cri+Oq/fk8o+UHQk1BWjnzA1bv61T3cGfFU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2waftjsfwu-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:40 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 23:08:15 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B626E2EC19AE; Sat, 16 Nov 2019 23:08:13 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/6] selftests/bpf: ensure no DWARF relocations for BPF object files
Date:   Sat, 16 Nov 2019 23:08:02 -0800
Message-ID: <20191117070807.251360-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117070807.251360-1-andriin@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=788 clxscore=1015 mlxscore=0 spamscore=0 impostorscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add -mattr=dwarfris attribute to llc to avoid having relocations against DWARF
data. These relocations make it impossible to inspect DWARF contents: all
strings are invalid.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b03dc2298fea..5737888cd6a7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -161,7 +161,7 @@ $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 define CLANG_BPF_BUILD_RULE
 	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
-	$(LLC) -march=bpf -mcpu=probe $4 -filetype=obj -o $2
+	$(LLC) -mattr=dwarfris -march=bpf -mcpu=probe $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but using native Clang and bpf LLC
 define CLANG_NATIVE_BPF_BUILD_RULE
-- 
2.17.1

