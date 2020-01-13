Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADFC138C5F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 08:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAMHcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 02:32:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46474 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgAMHb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 02:31:59 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00D7Sb3l019219
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:31:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wrDuT1Q+OBHFng+pj7a2VJ7t2KmCR9W0BCZl5lHGyZw=;
 b=Gyn7mMvF1HeiUDOwkLUm3pIEUsnWt9IL21LPpyzJymeSemX5HaS6m0tbuvD/2Kw6olxN
 Xx68t66BSmLWk1e6BkCgbIsDjn7/xClrfcMzTjqctz0tgVdysO+BbI8lHGL3N37ZrWKj
 uOF3tXUKcgoTWOmsDkZ9cMdbUHcy2K5v5WI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xfd2ppg38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:31:58 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 12 Jan 2020 23:31:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B4D062EC2329; Sun, 12 Jan 2020 23:31:52 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/6] libbpf: clean up bpf_helper_defs.h generation output
Date:   Sun, 12 Jan 2020 23:31:39 -0800
Message-ID: <20200113073143.1779940-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200113073143.1779940-1-andriin@fb.com>
References: <20200113073143.1779940-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_01:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=9
 impostorscore=0 malwarescore=0 mlxlogscore=800 lowpriorityscore=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_helpers_doc.py script, used to generate bpf_helper_defs.h, unconditionally
emits one informational message to stderr. Remove it and preserve stderr to
contain only relevant errors. Also make sure script invocations command is
muted by default in libbpf's Makefile.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 scripts/bpf_helpers_doc.py | 2 --
 tools/lib/bpf/Makefile     | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 7548569e8076..90baf7d70911 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -158,8 +158,6 @@ class HeaderParser(object):
                 break
 
         self.reader.close()
-        print('Parsed description of %d helper function(s)' % len(self.helpers),
-              file=sys.stderr)
 
 ###############################################################################
 
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index db2afccde757..aee7f1a83c77 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -183,7 +183,7 @@ $(BPF_IN_STATIC): force elfdep zdep bpfdep $(BPF_HELPER_DEFS)
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
 
 $(BPF_HELPER_DEFS): $(srctree)/tools/include/uapi/linux/bpf.h
-	$(Q)$(srctree)/scripts/bpf_helpers_doc.py --header 		\
+	$(QUIET_GEN)$(srctree)/scripts/bpf_helpers_doc.py --header \
 		--file $(srctree)/tools/include/uapi/linux/bpf.h > $(BPF_HELPER_DEFS)
 
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
-- 
2.17.1

