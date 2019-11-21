Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4970F104AF9
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:08:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11008 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbfKUHIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 02:08:20 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAL75UOV017148
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 23:08:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=y9b5pxS93Ze79R5ItaYKf+qrZDAvGCnSZtof5jhSpLk=;
 b=SxlnErDErFHG85Ht0AKdj5FmXE+U3LT8t8j5ttR3ZjXtI+CGhpjtG613fPtMZfviQtEt
 E4aquw6ZyoE9Wjagq4XDT/GxPwwKqeU0qOOLJkeQeyx1k1LTaQwocOJOM5kkQjMGX+jX
 75iKoCVy2Cu/UknIF3zR9TeDNAbAPMPrL58= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wct98r3q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 23:08:19 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 20 Nov 2019 23:08:18 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D646B2EC178E; Wed, 20 Nov 2019 23:08:16 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] selftests/bpf: ensure no DWARF relocations for BPF object files
Date:   Wed, 20 Nov 2019 23:07:40 -0800
Message-ID: <20191121070743.1309473-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191121070743.1309473-1-andriin@fb.com>
References: <20191121070743.1309473-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_08:2019-11-20,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=783 impostorscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=8 bulkscore=0 mlxscore=0 clxscore=1015
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210062
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
index 4fe4aec0367c..085678d88ef8 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -161,7 +161,7 @@ $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 define CLANG_BPF_BUILD_RULE
 	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
-	$(LLC) -march=bpf -mcpu=probe $4 -filetype=obj -o $2
+	$(LLC) -mattr=dwarfris -march=bpf -mcpu=probe $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
 define CLANG_NOALU32_BPF_BUILD_RULE
-- 
2.17.1

