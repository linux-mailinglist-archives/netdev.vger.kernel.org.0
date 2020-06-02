Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E31EB4DF
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFBFEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:04:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgFBFEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 01:04:08 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05251grT011082
        for <netdev@vger.kernel.org>; Mon, 1 Jun 2020 22:04:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nAQuVayxGYp7wLT421UePdQLmspE11aR99gEdGM9yx8=;
 b=UaTreZ9viG/drcBUo7WoYOlcA5UMJjTH7N6uaS4Eayp2NrWV6IzDJeBmifTbrC2n6DuW
 uf9470d+iKVjjUMr8SnOuQsUB/N8sX1TINtPggpgI3+BXSc0BvSM8doOY6Nx7x8pgoxX
 HAA2J6GE47zlrrHXxDSu4cxlD3FKCFcfi1E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31c7rvaqmk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 22:04:08 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Jun 2020 22:04:06 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 36A7C2EC305E; Mon,  1 Jun 2020 22:03:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: fix sample_cnt shared between two threads
Date:   Mon, 1 Jun 2020 22:03:49 -0700
Message-ID: <20200602050349.215037-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-02_04:2020-06-01,2020-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 cotscore=-2147483648 impostorscore=0 lowpriorityscore=0 mlxlogscore=968
 bulkscore=0 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=8
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sample_cnt volatile to fix possible selftests failure due to compile=
r
optimization preventing latest sample_cnt value to be visible to main thr=
ead.
sample_cnt is incremented in background thread, which is then joined into=
 main
thread. So in terms of visibility sample_cnt update is ok. But because it=
's
not volatile, compiler might make optimizations that would prevent main t=
hread
to see latest updated value. Fix this by marking global variable volatile=
.

Fixes: cb1c9ddd5525 ("selftests/bpf: Add BPF ringbuf selftests")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/tes=
ting/selftests/bpf/prog_tests/ringbuf.c
index bb8541f240e2..2bba908dfa63 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -25,7 +25,7 @@ struct sample {
 	char comm[16];
 };
=20
-static int sample_cnt;
+static volatile int sample_cnt;
=20
 static int process_sample(void *ctx, void *data, size_t len)
 {
--=20
2.24.1

