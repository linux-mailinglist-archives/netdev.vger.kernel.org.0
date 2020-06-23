Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178B0205713
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbgFWQS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:18:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55614 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732347AbgFWQS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:18:58 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NG71Yx030093
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=z7spgnSOmuscC2mGy1XIVWhqozMpxXywcMyrApiOdZk=;
 b=llsNchWbZAeQKJDBxn7vV2LjRco3DojOV+R03pgTtsIPXLfkLHKvnALUh1zgJZn/qCTP
 yJDkWeBLJ20Bb/+nGT3KEiZ6r5n69Yn+IO9elg8A0OF3rqHAnjc+lg2wI5XCuSsGC4R/
 7T9HWTAp+STNld6YiUPVSX8sxLWoVRW+8yk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk3cgpuc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:57 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 09:18:00 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id EC3B1370330A; Tue, 23 Jun 2020 09:17:54 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 04/15] bpf: allow tracing programs to use bpf_jiffies64() helper
Date:   Tue, 23 Jun 2020 09:17:54 -0700
Message-ID: <20200623161754.2500657-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623161749.2500196-1-yhs@fb.com>
References: <20200623161749.2500196-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_10:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=8 phishscore=0 mlxlogscore=699
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/net/tcp{4,6} uses jiffies for various computations.
Let us add bpf_jiffies64() helper to tracing program
so bpf_iter and other programs can use it.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index dbee30e2ad91..afaec7e082d9 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1135,6 +1135,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, co=
nst struct bpf_prog *prog)
 		return &bpf_ringbuf_discard_proto;
 	case BPF_FUNC_ringbuf_query:
 		return &bpf_ringbuf_query_proto;
+	case BPF_FUNC_jiffies64:
+		return &bpf_jiffies64_proto;
 	default:
 		return NULL;
 	}
--=20
2.24.1

