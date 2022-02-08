Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4044AD1AC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 07:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347615AbiBHGjm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Feb 2022 01:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiBHGjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 01:39:40 -0500
X-Greylist: delayed 803 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 22:39:40 PST
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EFEC0401EF
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 22:39:40 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217Id6KP029753
        for <netdev@vger.kernel.org>; Mon, 7 Feb 2022 22:26:17 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e2t078p9b-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 22:26:17 -0800
Received: from twshared0654.04.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 22:26:13 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0085B29A5FC92; Mon,  7 Feb 2022 22:26:01 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>
Subject: [PATCH bpf-next] bpf, x86_64: fail gracefully on bpf_jit_binary_pack_finalize failures
Date:   Mon, 7 Feb 2022 22:25:33 -0800
Message-ID: <20220208062533.3802081-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: DPddCK7ZHK8NT9MetetQCoeedJfbBA8_
X-Proofpoint-ORIG-GUID: DPddCK7ZHK8NT9MetetQCoeedJfbBA8_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_02,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=590 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080032
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

Instead of BUG_ON(), fail gracefully and return orig_prog.

Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
Signed-off-by: Song Liu <song@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 643f38b91e30..08e8fd8f954a 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2380,7 +2380,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			 *
 			 * Both cases are serious bugs that we should not continue.
 			 */
-			BUG_ON(bpf_jit_binary_pack_finalize(prog, header, rw_header));
+			if (WARN_ON(bpf_jit_binary_pack_finalize(prog, header, rw_header))) {
+				prog = orig_prog;
+				goto out_addrs;
+			}
+
 			bpf_tail_call_direct_fixup(prog);
 		} else {
 			jit_data->addrs = addrs;
-- 
2.30.2

