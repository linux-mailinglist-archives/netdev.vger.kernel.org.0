Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F64CAC81
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbiCBRw2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Mar 2022 12:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244097AbiCBRw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:52:27 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0637D19B1
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 09:51:43 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222HZhxV027482
        for <netdev@vger.kernel.org>; Wed, 2 Mar 2022 09:51:43 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ehyr6qajs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 09:51:43 -0800
Received: from twshared5730.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 09:51:42 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5B6A62B54210F; Wed,  2 Mar 2022 09:51:34 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>,
        Kui-Feng Lee <kuifeng@fb.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH v2 bpf-next 2/2] bpf, x86: set header->size properly before freeing it
Date:   Wed, 2 Mar 2022 09:51:26 -0800
Message-ID: <20220302175126.247459-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302175126.247459-1-song@kernel.org>
References: <20220302175126.247459-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: UBprD07kvl7aCmnZgGEgSMRnK-9bYJRW
X-Proofpoint-ORIG-GUID: UBprD07kvl7aCmnZgGEgSMRnK-9bYJRW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=703 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020077
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

On do_jit failure path, the header is freed by bpf_jit_binary_pack_free.
While bpf_jit_binary_pack_free doesn't require proper ro_header->size,
bpf_prog_pack_free still uses it. Set header->size in bpf_int_jit_compile
before calling bpf_jit_binary_pack_free.

Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
Fixes: 33c9805860e5 ("bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]")
Reported-by: Kui-Feng Lee <kuifeng@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 5 ++++-
 kernel/bpf/core.c           | 9 ++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index c7db0fe4de2f..e6ff8f4f9ea4 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2330,8 +2330,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		if (proglen <= 0) {
 out_image:
 			image = NULL;
-			if (header)
+			if (header) {
+				bpf_arch_text_copy(&header->size, &rw_header->size,
+						   sizeof(rw_header->size));
 				bpf_jit_binary_pack_free(header, rw_header);
+			}
 			prog = orig_prog;
 			goto out_addrs;
 		}
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ebb0193d07f0..ab630f773ec1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1112,13 +1112,16 @@ int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
  *   1) when the program is freed after;
  *   2) when the JIT engine fails (before bpf_jit_binary_pack_finalize).
  * For case 2), we need to free both the RO memory and the RW buffer.
- * Also, ro_header->size in 2) is not properly set yet, so rw_header->size
- * is used for uncharge.
+ *
+ * bpf_jit_binary_pack_free requires proper ro_header->size. However,
+ * bpf_jit_binary_pack_alloc does not set it. Therefore, ro_header->size
+ * must be set with either bpf_jit_binary_pack_finalize (normal path) or
+ * bpf_arch_text_copy (when jit fails).
  */
 void bpf_jit_binary_pack_free(struct bpf_binary_header *ro_header,
 			      struct bpf_binary_header *rw_header)
 {
-	u32 size = rw_header ? rw_header->size : ro_header->size;
+	u32 size = ro_header->size;
 
 	bpf_prog_pack_free(ro_header);
 	kvfree(rw_header);
-- 
2.30.2

