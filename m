Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490BA26968
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfEVRve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:51:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728761AbfEVRve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:51:34 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MHelsj006135
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:51:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=TOFcnYy/N0pY4QXT1XCe0ChRYiG64rbZ0ccjsPakIPs=;
 b=JhmMA2nrUbiw62zZkU4Yw/GmwvEIWV3EnL4dBZLXZPFKWblNYa0B2PvglvfiyTkWybjb
 XIg5ZgobWjEnDBN5ee7PIpv14V+WcU7ekME8hIQDAlp8d+EnTtXdn8eAFVQFh6O5yM68
 bLCry2GoVcoDe0bwgb2g3NhIhdIwPUhXj84= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn1egj500-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:51:33 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 10:51:31 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 3E0AE861732; Wed, 22 May 2019 10:51:30 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next] libbpf: emit diff of mismatched public API, if any
Date:   Wed, 22 May 2019 10:51:28 -0700
Message-ID: <20190522175128.3680479-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=792 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220124
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
 tools/lib/bpf/Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index f91639bf5650..a2aceadf68db 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -204,6 +204,16 @@ check_abi: $(OUTPUT)libbpf.so
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
+		rm $(OUTPUT)libbpf_global_syms.tmp			 \
+		   $(OUTPUT)libbpf_versioned_syms.tmp;			 \
 		exit 1;							 \
 	fi
 
-- 
2.17.1

