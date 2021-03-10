Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118A8333225
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhCJADV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Mar 2021 19:03:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51822 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231216AbhCJADB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:03:01 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 129Ntuij019001
        for <netdev@vger.kernel.org>; Tue, 9 Mar 2021 16:03:01 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 376be72w88-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 16:03:01 -0800
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 9 Mar 2021 16:02:59 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 43F012ED1C63; Tue,  9 Mar 2021 16:02:56 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 1/2] libbpf: add explicit padding to bpf_xdp_set_link_opts
Date:   Tue, 9 Mar 2021 16:02:54 -0800
Message-ID: <20210310000254.4140487-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_20:2021-03-09,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=563 phishscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090118
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

