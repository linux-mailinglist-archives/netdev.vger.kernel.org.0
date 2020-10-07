Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EE92858A9
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgJGG3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:29:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18636 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgJGG3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:29:43 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0976T6QK013959
        for <netdev@vger.kernel.org>; Tue, 6 Oct 2020 23:29:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=sLui42BnNkRqlJsx4joO6DBykPUYfOkBZnRIOo3kdh4=;
 b=goXrvAP+C/nImLe4CqZjozlQKXeRDU+GxemkbfY+DbDirkCGsia3ajxZPYRgy/moQuqp
 qTlIfT4/YEjsggarh6QrlfP2vK5Wc5t8tf6CvqhPJBzjNlSm4IPPMNq5ApIARfD4Rilr
 DKLSO/jngrmTxwEaRaOCBy8kZDKwZ/OG8A8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 341408rums-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 23:29:42 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 6 Oct 2020 23:29:41 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6F2B537058FB; Tue,  6 Oct 2020 23:29:33 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next] bpf: fix build failure for kernel/trace/bpf_trace.c with CONFIG_NET=n
Date:   Tue, 6 Oct 2020 23:29:33 -0700
Message-ID: <20201007062933.3425899-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_04:2020-10-06,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=636 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_NET is not defined, I hit the following build error:
    kernel/trace/bpf_trace.o:(.rodata+0x110): undefined reference to `bpf_p=
rog_test_run_raw_tp'

Commit 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
added test_run support for raw_tracepoint in /kernel/trace/bpf_trace.c.
But the test_run function bpf_prog_test_run_raw_tp is defined in
net/bpf/test_run.c, only available with CONFIG_NET=3Dy.

Adding a CONFIG_NET guard for
    .test_run =3D bpf_prog_test_run_raw_tp;
fixed the above build issue.

Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

Note: I found the above issue when I reviewed the following patch:
      https://lore.kernel.org/bpf/fcf3f659-027e-517f-086d-deb3ad33d953@fb.c=
om/T

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a136a6a63a71..a2a4535b6277 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1780,7 +1780,9 @@ const struct bpf_verifier_ops raw_tracepoint_verifier=
_ops =3D {
 };
=20
 const struct bpf_prog_ops raw_tracepoint_prog_ops =3D {
+#ifdef CONFIG_NET
 	.test_run =3D bpf_prog_test_run_raw_tp,
+#endif
 };
=20
 const struct bpf_verifier_ops tracing_verifier_ops =3D {
--=20
2.24.1

