Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B907E33A156
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 22:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhCMVJw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 16:09:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234377AbhCMVJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 16:09:36 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DL5ODf000372
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:36 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 378tah1vj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:09:36 -0800
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 13:09:35 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2224C2ED2050; Sat, 13 Mar 2021 13:09:25 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 1/4] libbpf: add explicit padding to bpf_xdp_set_link_opts
Date:   Sat, 13 Mar 2021 13:09:17 -0800
Message-ID: <20210313210920.1959628-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210313210920.1959628-1-andrii@kernel.org>
References: <20210313210920.1959628-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_10:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=538 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130165
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding such anonymous padding fixes the issue with uninitialized portions of
bpf_xdp_set_link_opts when using LIBBPF_DECLARE_OPTS macro with inline field
initialization:

DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd = -1);

When such code is compiled in debug mode, compiler is generating code that
leaves padding bytes uninitialized, which triggers error inside libbpf APIs
that do strict zero initialization checks for OPTS structs.

Adding anonymous padding field fixes the issue.

Fixes: bd5ca3ef93cd ("libbpf: Add function to set link XDP fd while specifying old program")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3c35eb401931..3d690d4e785c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -507,6 +507,7 @@ struct xdp_link_info {
 struct bpf_xdp_set_link_opts {
 	size_t sz;
 	int old_fd;
+	size_t :0;
 };
 #define bpf_xdp_set_link_opts__last_field old_fd
 
-- 
2.24.1

