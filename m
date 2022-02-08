Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90904AE33D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbiBHWV3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Feb 2022 17:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387169AbiBHWF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 17:05:28 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C3C0612B8
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 14:05:27 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 218H9uiQ011678
        for <netdev@vger.kernel.org>; Tue, 8 Feb 2022 14:05:27 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e3vp823ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 14:05:27 -0800
Received: from twshared22811.39.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 14:05:26 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4977529B2C7D2; Tue,  8 Feb 2022 14:05:18 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH bpf-next 2/2] bpf: fix bpf_prog_pack build HPAGE_PMD_SIZE
Date:   Tue, 8 Feb 2022 14:05:09 -0800
Message-ID: <20220208220509.4180389-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220208220509.4180389-1-song@kernel.org>
References: <20220208220509.4180389-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LQXQHKq9Uxff64AnLsf3hxmXGFdTRuCP
X-Proofpoint-GUID: LQXQHKq9Uxff64AnLsf3hxmXGFdTRuCP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 phishscore=0 impostorscore=0 adultscore=0 mlxlogscore=935
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1034 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080129
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build with CONFIG_TRANSPARENT_HUGEPAGE=n with BPF_PROG_PACK_SIZE as
PAGE_SIZE.

Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 306aa63fa58e..9519264ab1ee 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -814,7 +814,11 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
  * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
  * to host BPF programs.
  */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
+#else
+#define BPF_PROG_PACK_SIZE	PAGE_SIZE
+#endif
 #define BPF_PROG_CHUNK_SHIFT	6
 #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
 #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
-- 
2.30.2

