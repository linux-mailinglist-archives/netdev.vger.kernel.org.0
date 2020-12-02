Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612182CB171
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgLBAYr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Dec 2020 19:24:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16316 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbgLBAYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 19:24:47 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B20Fm6S030814
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 16:24:06 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfk1jwh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 16:24:04 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 16:24:00 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0AB262ECA70C; Tue,  1 Dec 2020 16:23:59 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v4 bpf-next 02/14] bpf: keep module's btf_data_size intact after load
Date:   Tue, 1 Dec 2020 16:16:04 -0800
Message-ID: <20201202001616.3378929-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201202001616.3378929-1-andrii@kernel.org>
References: <20201202001616.3378929-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_12:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=734 malwarescore=0 spamscore=0 suspectscore=25 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having real btf_data_size stored in struct module is benefitial to quickly
determine which kernel modules have associated BTF object and which don't.
There is no harm in keeping this info, as opposed to keeping invalid pointer.

Fixes: 607c543f939d ("bpf: Sanitize BTF data pointer after module is loaded")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/module.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 18f259d61d14..c3a9e972d3b2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3712,7 +3712,6 @@ static noinline int do_init_module(struct module *mod)
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	/* .BTF is not SHF_ALLOC and will get removed, so sanitize pointer */
 	mod->btf_data = NULL;
-	mod->btf_data_size = 0;
 #endif
 	/*
 	 * We want to free module_init, but be aware that kallsyms may be
-- 
2.24.1

