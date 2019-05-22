Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD96267D5
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbfEVQPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:15:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729576AbfEVQPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 12:15:32 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MGE8U2021679
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 09:15:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=y4jjBi5lAputVXuORLEkfYbjo28VFZrE61m5FwRr33M=;
 b=F4WHBtGaObd52F8pq26RQaDaDqyfJ2HXxILkAHsNrjpApLeLZmgIvq3DRfv56Mzzbblf
 bnm2bhP/ZjC/AUbU8KNXtPar7nOfq7ONs1X0ajMOrgSfE/aCBoyZXNgyMtxT+6Wm6hvh
 X5TRZUNpcEEhcecEdMOZbTgT+kzXBb/lELk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2smrb1383r-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 09:15:31 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 22 May 2019 09:15:29 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2C2E186171B; Wed, 22 May 2019 09:15:29 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: emit diff of mismatched public API, if any
Date:   Wed, 22 May 2019 09:15:20 -0700
Message-ID: <20190522161520.3407245-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=738 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's easy to have a mismatch of "intended to be public" vs really
exposed API functions. While Makefile does check for this mismatch, if
it actually occurs it's not trivial to determine which functions are
accidentally exposed. This patch dumps out a diff showing what's not
supposed to be exposed facilitating easier fixing.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/.gitignore | 2 ++
 tools/lib/bpf/Makefile   | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
index d9e9dec04605..c7306e858e2e 100644
--- a/tools/lib/bpf/.gitignore
+++ b/tools/lib/bpf/.gitignore
@@ -3,3 +3,5 @@ libbpf.pc
 FEATURE-DUMP.libbpf
 test_libbpf
 libbpf.so.*
+libbpf_global_syms.tmp
+libbpf_versioned_syms.tmp
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index f91639bf5650..7e7d6d851713 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -204,6 +204,14 @@ check_abi: $(OUTPUT)libbpf.so
 		     "versioned symbols in $^ ($(VERSIONED_SYM_COUNT))." \
 		     "Please make sure all LIBBPF_API symbols are"	 \
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
+		readelf -s --wide $(OUTPUT)libbpf-in.o |		 \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
+		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
+		readelf -s --wide $(OUTPUT)libbpf.so |			 \
+		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
+		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
+		diff -u $(OUTPUT)libbpf_global_syms.tmp			 \
+		     $(OUTPUT)libbpf_versioned_syms.tmp;		 \
 		exit 1;							 \
 	fi
 
-- 
2.17.1

