Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745A44BA849
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbiBQScW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Feb 2022 13:32:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244495AbiBQScL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:32:11 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B7FA198
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:31:54 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HG9WRB005098
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:31:54 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e92mqa72y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:31:54 -0800
Received: from twshared29821.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 10:31:53 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 434A32A7BFA79; Thu, 17 Feb 2022 10:31:45 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>,
        <syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com>,
        <syzbot+ecb1e7e51c52f68f7481@syzkaller.appspotmail.com>,
        <syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com>
Subject: [PATCH bpf-next] bpf: bpf_prog_pack: set proper size before freeing ro_header
Date:   Thu, 17 Feb 2022 10:30:01 -0800
Message-ID: <20220217183001.1876034-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: hkjx9i6pVJvetKnODizFjxFu9bldqMDH
X-Proofpoint-ORIG-GUID: hkjx9i6pVJvetKnODizFjxFu9bldqMDH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_07,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 mlxlogscore=928
 suspectscore=0 clxscore=1034 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202170085
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

bpf_prog_pack_free() uses header->size to decide whether the header
should be freed with module_memfree() or the bpf_prog_pack logic.
However, in kvmalloc() failure path of bpf_jit_binary_pack_alloc(),
header->size is not set yet. As a result, bpf_prog_pack_free() may treat
a slice of a pack as a standalone kvmalloc'd header and call
module_memfree() on the whole pack. This in turn causes use-after-free by
other users of the pack.

Fix this by setting ro_header->size before freeing ro_header.

Fixes: 33c9805860e5 ("bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]")
Reported-by: syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com
Reported-by: syzbot+ecb1e7e51c52f68f7481@syzkaller.appspotmail.com
Reported-by: syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 44623c9b5bb1..ebb0193d07f0 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1069,6 +1069,7 @@ bpf_jit_binary_pack_alloc(unsigned int proglen, u8 **image_ptr,
 
 	*rw_header = kvmalloc(size, GFP_KERNEL);
 	if (!*rw_header) {
+		bpf_arch_text_copy(&ro_header->size, &size, sizeof(size));
 		bpf_prog_pack_free(ro_header);
 		bpf_jit_uncharge_modmem(size);
 		return NULL;
-- 
2.30.2

