Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E48375FC7
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 07:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhEGFme convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 May 2021 01:42:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58850 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233669AbhEGFmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 01:42:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1475ZLe8028937
        for <netdev@vger.kernel.org>; Thu, 6 May 2021 22:41:34 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38cswg982p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 22:41:34 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 22:41:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 32B062ED7617; Thu,  6 May 2021 22:41:31 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [RFC PATCH bpf-next 4/7] bpftool: stop emitting static variables in BPF skeleton
Date:   Thu, 6 May 2021 22:41:16 -0700
Message-ID: <20210507054119.270888-5-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507054119.270888-1-andrii@kernel.org>
References: <20210507054119.270888-1-andrii@kernel.org>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ZYNKuNgCf_h2xFL4WPr2xtS_SVh37s6l
X-Proofpoint-ORIG-GUID: ZYNKuNgCf_h2xFL4WPr2xtS_SVh37s6l
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_01:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105070041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in [0], stop emitting static variables in BPF skeletons to avoid
issues with name-conflicting static variables across multiple
statically-linked BPF object files.

Users using static variables to pass data between BPF programs and user-space
should do a trivial one-time switch according to the following simple rules:
  - read-only `static volatile const` variables should be converted to
    `volatile const`;
  - read/write `static volatile` variables should just drop `static volatile`
    modifiers to become global variables/symbols. To better handle older Clang
    versions, such newly converted global variables should be explicitly
    initialized with a specific value or `= 0`/`= {}`, whichever is
    appropriate.

  [0] https://lore.kernel.org/bpf/CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com/T/#m664d4b0d6b31ac8b2669360e0fc2d6962e9f5ec1

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/gen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 06fee4a2910a..27dceaf66ecb 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -131,6 +131,10 @@ static int codegen_datasec_def(struct bpf_object *obj,
 		int need_off = sec_var->offset, align_off, align;
 		__u32 var_type_id = var->type;
 
+		/* static variables are not exposed through BPF skeleton */
+		if (btf_var(var)->linkage == BTF_VAR_STATIC)
+			continue;
+
 		if (off > need_off) {
 			p_err("Something is wrong for %s's variable #%d: need offset %d, already at %d.\n",
 			      sec_name, i, need_off, off);
-- 
2.30.2

