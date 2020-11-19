Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95212B9E18
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgKSXXC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Nov 2020 18:23:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23634 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726474AbgKSXXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:23:02 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJNKgIZ027851
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:23:01 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34wgckr7mx-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:23:01 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 15:22:51 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DAE722EC9B9C; Thu, 19 Nov 2020 15:22:47 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 1/6] bpf: fix bpf_put_raw_tracepoint()'s use of __module_address()
Date:   Thu, 19 Nov 2020 15:22:39 -0800
Message-ID: <20201119232244.2776720-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119232244.2776720-1-andrii@kernel.org>
References: <20201119232244.2776720-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 suspectscore=8 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=825
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190160
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__module_address() needs to be called with preemption disabled or with
module_mutex taken. preempt_disable() is enough for read-only uses, which is
what this fix does.

Fixes: a38d1107f937 ("bpf: support raw tracepoints in modules")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/trace/bpf_trace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d255bc9b2bfa..bb98a377050a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2060,7 +2060,11 @@ struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name)
 
 void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp)
 {
-	struct module *mod = __module_address((unsigned long)btp);
+	struct module *mod;
+
+	preempt_disable();
+	mod = __module_address((unsigned long)btp);
+	preempt_enable();
 
 	if (mod)
 		module_put(mod);
-- 
2.24.1

