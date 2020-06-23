Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6897E2067ED
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbgFWXIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:08:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55730 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387755AbgFWXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:08:10 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NN6JQL001034
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:08:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qZEHt4RHh7ib2heTqMonlYOEEjS3L/KCT0L9qTv5Ypc=;
 b=GhmDPVU3W9iNByDX+RJi6Uau4MFDmPMBD52Hf5Mb+Bh036+qaVDOTai3pk6ksnfktQ9S
 X7Kt+l++71a7RKImoEFuVrPt0/qexbK1dv6R3HIKPAknXyVc3I6Cey021JcBGf+++CrW
 L3Jhkw+1DMsgCiJsTxelfBYlNM2PouFi7zU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31utreg3wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:08:10 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 16:08:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 49A8D3704E81; Tue, 23 Jun 2020 16:08:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v5 03/15] bpf: support 'X' in bpf_seq_printf() helper
Date:   Tue, 23 Jun 2020 16:08:07 -0700
Message-ID: <20200623230807.3988014-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623230803.3987674-1-yhs@fb.com>
References: <20200623230803.3987674-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 cotscore=-2147483648 phishscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=916 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=8 spamscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'X' tells kernel to print hex with upper case letters.
/proc/net/tcp{4,6} seq_file show() used this, and
supports it in bpf_seq_printf() helper too.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/trace/bpf_trace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e729c9e587a0..dbee30e2ad91 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -681,7 +681,8 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char=
 *, fmt, u32, fmt_size,
 		}
=20
 		if (fmt[i] !=3D 'i' && fmt[i] !=3D 'd' &&
-		    fmt[i] !=3D 'u' && fmt[i] !=3D 'x') {
+		    fmt[i] !=3D 'u' && fmt[i] !=3D 'x' &&
+		    fmt[i] !=3D 'X') {
 			err =3D -EINVAL;
 			goto out;
 		}
--=20
2.24.1

