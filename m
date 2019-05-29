Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462572D321
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfE2BOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:14:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbfE2BOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:14:35 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T1Bqt9018996
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zOtmJGpxHqYR543cv2Vlxa+nZTQNKi9ZSoPUZCCPJM8=;
 b=ejxQbbIzXBBXDzKh0LvmFdqtg+HPMCTtfDoPEPljntjgWeTsL6p+qsbx3JLxH11+ziEG
 CHKMocK4K5oG0PHJ7uj/z5PukmFIPn3x0p9t6Ag2eU3I1JfqOO1Mw77kRYfuxSC6faQN
 DFIZ3g19kUmv12cZtjdG4eI2cBTZAUtPTvU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2ssckegpba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:34 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 18:14:33 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E61AE8617AA; Tue, 28 May 2019 18:14:32 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/9] libbpf: preserve errno before calling into user callback
Date:   Tue, 28 May 2019 18:14:19 -0700
Message-ID: <20190529011426.1328736-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529011426.1328736-1-andriin@fb.com>
References: <20190529011426.1328736-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=894 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pr_warning ultimately may call into user-provided callback function,
which can clobber errno value, so we need to save it before that.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 05a73223e524..7b80b9ae8a1f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -565,12 +565,12 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 	} else {
 		obj->efile.fd = open(obj->path, O_RDONLY);
 		if (obj->efile.fd < 0) {
-			char errmsg[STRERR_BUFSIZE];
-			char *cp = libbpf_strerror_r(errno, errmsg,
-						     sizeof(errmsg));
+			char errmsg[STRERR_BUFSIZE], *cp;
 
+			err = -errno;
+			cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 			pr_warning("failed to open %s: %s\n", obj->path, cp);
-			return -errno;
+			return err;
 		}
 
 		obj->efile.elf = elf_begin(obj->efile.fd,
-- 
2.17.1

