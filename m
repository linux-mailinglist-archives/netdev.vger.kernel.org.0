Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7D2CCD80
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbgLCDwz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 22:52:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49802 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387581AbgLCDwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:52:54 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B33l6Jt005594
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 19:52:13 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3560xg0kj9-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:52:13 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 19:52:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 98FB82ECA822; Wed,  2 Dec 2020 19:52:08 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH v5 bpf-next 01/14] bpf: fix bpf_put_raw_tracepoint()'s use of __module_address()
Date:   Wed, 2 Dec 2020 19:51:51 -0800
Message-ID: <20201203035204.1411380-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203035204.1411380-1-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=793
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1034 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=8 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__module_address() needs to be called with preemption disabled or with
module_mutex taken. preempt_disable() is enough for read-only uses, which is
what this fix does. Also, module_put() does internal check for NULL, so drop
it as well.

Fixes: a38d1107f937 ("bpf: support raw tracepoints in modules")
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/trace/bpf_trace.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d255bc9b2bfa..23a390aac524 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2060,10 +2060,12 @@ struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name)
 
 void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp)
 {
-	struct module *mod = __module_address((unsigned long)btp);
+	struct module *mod;
 
-	if (mod)
-		module_put(mod);
+	preempt_disable();
+	mod = __module_address((unsigned long)btp);
+	module_put(mod);
+	preempt_enable();
 }
 
 static __always_inline
-- 
2.24.1

