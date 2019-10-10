Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08712D1F51
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfJJEPM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 00:15:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43568 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727309AbfJJEPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:15:11 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A4E5FA024766
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 21:15:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhm0ua7qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:15:10 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 21:15:09 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 29CD6760CF9; Wed,  9 Oct 2019 21:15:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 01/12] bpf: add typecast to raw_tracepoints to help BTF generation
Date:   Wed, 9 Oct 2019 21:14:52 -0700
Message-ID: <20191010041503.2526303-2-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010041503.2526303-1-ast@kernel.org>
References: <20191010041503.2526303-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_02:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=1 mlxlogscore=863 lowpriorityscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When pahole converts dwarf to btf it emits only used types.
Wrap existing __bpf_trace_##template() function into
btf_trace_##template typedef and use it in type cast to
make gcc emits this type into dwarf. Then pahole will convert it to btf.
The "btf_trace_" prefix will be used to identify BTF enabled raw tracepoints.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/trace/bpf_probe.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index d6e556c0a085..ff1a879773df 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -74,11 +74,12 @@ static inline void bpf_test_probe_##call(void)				\
 {									\
 	check_trace_callback_type_##call(__bpf_trace_##template);	\
 }									\
+typedef void (*btf_trace_##template)(void *__data, proto);		\
 static struct bpf_raw_event_map	__used					\
 	__attribute__((section("__bpf_raw_tp_map")))			\
 __bpf_trace_tp_map_##call = {						\
 	.tp		= &__tracepoint_##call,				\
-	.bpf_func	= (void *)__bpf_trace_##template,		\
+	.bpf_func	= (void *)(btf_trace_##template)__bpf_trace_##template,	\
 	.num_args	= COUNT_ARGS(args),				\
 	.writable_size	= size,						\
 };
-- 
2.23.0

