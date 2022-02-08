Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7734AE45D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357058AbiBHW3l convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Feb 2022 17:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386605AbiBHW1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 17:27:24 -0500
X-Greylist: delayed 1107 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 14:23:46 PST
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B8CC061266
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 14:23:46 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 218FCndf021646
        for <netdev@vger.kernel.org>; Tue, 8 Feb 2022 14:05:19 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e3tybb6r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 14:05:19 -0800
Received: from twshared0654.04.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 14:05:17 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9F0DB29B2C7A7; Tue,  8 Feb 2022 14:05:15 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH bpf-next 1/2] bpf: fix leftover header->pages in sparc and powerpc code.
Date:   Tue, 8 Feb 2022 14:05:08 -0800
Message-ID: <20220208220509.4180389-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220208220509.4180389-1-song@kernel.org>
References: <20220208220509.4180389-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QFvokBkIbANHCRxgqpgjf5Cezyg00Jgj
X-Proofpoint-GUID: QFvokBkIbANHCRxgqpgjf5Cezyg00Jgj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 malwarescore=0 spamscore=0 mlxlogscore=906 mlxscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080129
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

Replace header->pages * PAGE_SIZE with new header->size.

Fixes: ed2d9e1a26cc ("bpf: Use size instead of pages in bpf_binary_header")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp.c  | 2 +-
 arch/sparc/net/bpf_jit_comp_64.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index d6ffdd0f2309..9003c313475d 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -247,7 +247,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	fp->jited = 1;
 	fp->jited_len = proglen + FUNCTION_DESCR_SIZE;
 
-	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
+	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + bpf_hdr->size);
 	if (!fp->is_func || extra_pass) {
 		bpf_jit_binary_lock_ro(bpf_hdr);
 		bpf_prog_fill_jited_linfo(fp, addrs);
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index b1e38784eb23..fa0759bfe498 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1599,7 +1599,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	if (bpf_jit_enable > 1)
 		bpf_jit_dump(prog->len, image_size, pass, ctx.image);
 
-	bpf_flush_icache(header, (u8 *)header + (header->pages * PAGE_SIZE));
+	bpf_flush_icache(header, (u8 *)header + header->size);
 
 	if (!prog->is_func || extra_pass) {
 		bpf_jit_binary_lock_ro(header);
-- 
2.30.2

