Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C222EFADD
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbhAHWKW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 17:10:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30744 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726059AbhAHWKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:10:22 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 108M94AV020001
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 14:09:41 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 35x79rpt9b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:09:41 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 14:09:39 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AFE612ECD237; Fri,  8 Jan 2021 14:09:37 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2 bpf-next 3/7] bpf: declare __bpf_free_used_maps() unconditionally
Date:   Fri, 8 Jan 2021 14:09:26 -0800
Message-ID: <20210108220930.482456-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210108220930.482456-1-andrii@kernel.org>
References: <20210108220930.482456-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_11:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=781 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__bpf_free_used_maps() is always defined in kernel/bpf/core.c, while
include/linux/bpf.h is guarding it behind CONFIG_BPF_SYSCALL. Move it out of
that guard region and fix compiler warning.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: a2ea07465c8d ("bpf: Fix missing prog untrack in release_maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/bpf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ef9309604b3e..6e585dbc10df 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1206,8 +1206,6 @@ void bpf_prog_sub(struct bpf_prog *prog, int i);
 void bpf_prog_inc(struct bpf_prog *prog);
 struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
-void __bpf_free_used_maps(struct bpf_prog_aux *aux,
-			  struct bpf_map **used_maps, u32 len);
 
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
 void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
@@ -1676,6 +1674,9 @@ static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
 	return bpf_prog_get_type_dev(ufd, type, false);
 }
 
+void __bpf_free_used_maps(struct bpf_prog_aux *aux,
+			  struct bpf_map **used_maps, u32 len);
+
 bool bpf_prog_get_ok(struct bpf_prog *, enum bpf_prog_type *, bool);
 
 int bpf_prog_offload_compile(struct bpf_prog *prog);
-- 
2.24.1

