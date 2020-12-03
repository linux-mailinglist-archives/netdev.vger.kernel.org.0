Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8CF2CCD7C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387570AbgLCDwx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 22:52:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14738 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726734AbgLCDwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:52:53 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B33jrrc014571
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 19:52:11 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7ybfrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:52:11 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 19:52:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C078B2ECA822; Wed,  2 Dec 2020 19:52:10 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v5 bpf-next 02/14] bpf: keep module's btf_data_size intact after load
Date:   Wed, 2 Dec 2020 19:51:52 -0800
Message-ID: <20201203035204.1411380-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203035204.1411380-1-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=737 phishscore=0
 mlxscore=0 suspectscore=25 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030020
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

