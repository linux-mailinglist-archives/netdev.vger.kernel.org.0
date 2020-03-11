Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579B318214B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgCKSx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:53:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35684 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730868AbgCKSx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 14:53:58 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BIixpU000765
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 11:53:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=agaD1L6x13VFkiieNxYQs4HHP2Frm3fHVTIhAYCNKC8=;
 b=iv/VNX7yc7oEp5rE1tStjfyKA1LtPr0AiBZYcKZ1Dnroh8S9SANpQuRPfKJ9MVn+dLp5
 k3CvoxNxaycFRKXju6AT6Bax07hh4xV7I92yuh0HvVzG9fTqMMZ71Cd9/C9b6wDAz/qZ
 NJj7kzGbTd0bAAxXTLJhSdaBSQketpt5cSE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ypn9g483a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 11:53:57 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 11 Mar 2020 11:53:55 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1C66E2EC2DD2; Wed, 11 Mar 2020 11:53:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: guarantee that useep() calls nanosleep() syscall
Date:   Wed, 11 Mar 2020 11:53:45 -0700
Message-ID: <20200311185345.3874602-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_09:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=8 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003110106
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some implementations of C runtime library won't call nanosleep() syscall from
usleep(). But a bunch of kprobe/tracepoint selftests rely on nanosleep being
called to trigger them. To make this more reliable, "override" usleep
implementation and call nanosleep explicitly.

Cc: Julia Kartseva <hex@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_progs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index a969c77e9456..2b0bc1171c9c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -29,6 +29,15 @@ struct prog_test_def {
 	int old_error_cnt;
 };
 
+/* Override C runtime library's usleep() implementation to ensure nanosleep()
+ * is always called. Usleep is frequently used in selftests as a way to
+ * trigger kprobe and tracepoints.
+ */
+int usleep(useconds_t usec)
+{
+	return syscall(__NR_nanosleep, usec * 1000UL);
+}
+
 static bool should_run(struct test_selector *sel, int num, const char *name)
 {
 	int i;
-- 
2.17.1

