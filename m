Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6804E10B724
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfK0UBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:01:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727166AbfK0UBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:01:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xARJjKI8007771
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:01:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=VLtJO48uxuyJ7SfqxDRtBf38gccXRnQxgFAwTUfAuK0=;
 b=FLMyV/2TcNwLzVdGcibwDQyQUa3VEopHIRBlapHUNDKnq6nb2sa0jzSq+Ib49yOKCpnV
 m2Zipl2knLc+WDymDpVSyhZ+sJoNp321MaTt1AQN2Fg4wgXOO5tzawwB+zJiH0avyjF1
 j4zdlBffajyf94ugtFRXd/a/U7Osas5ARDM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2whcy2pc7p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:01:40 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 27 Nov 2019 12:01:39 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B90442EC1C8E; Wed, 27 Nov 2019 12:01:37 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] libbpf: fix Makefile' libbpf symbol mismatch diagnostic
Date:   Wed, 27 Nov 2019 12:01:34 -0800
Message-ID: <20191127200134.1360660-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=713
 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix Makefile's diagnostic diff output when there is LIBBPF_API-versioned
symbols mismatch.

Fixes: 1bd63524593b ("libbpf: handle symbol versioning properly for libbpf.a")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 99425d0be6ff..1470303b1922 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -214,7 +214,7 @@ check_abi: $(OUTPUT)libbpf.so
 		     "versioned symbols in $^ ($(VERSIONED_SYM_COUNT))." \
 		     "Please make sure all LIBBPF_API symbols are"	 \
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
-		readelf -s --wide $(OUTPUT)libbpf-in.o |		 \
+		readelf -s --wide $(BPF_IN_SHARED) |			 \
 		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
-- 
2.17.1

