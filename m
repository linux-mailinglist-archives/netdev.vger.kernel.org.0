Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64084E2F87
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351928AbiCUSBs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Mar 2022 14:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351920AbiCUSBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:01:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F163B5B3F9
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:00:19 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22LHI0Un022639
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:00:18 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ewxxh80gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:00:18 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Mar 2022 11:00:16 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 60B0B2DBF26F; Mon, 21 Mar 2022 11:00:14 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>,
        <syzbot+c946805b5ce6ab87df0b@syzkaller.appspotmail.com>
Subject: [PATCH bpf-next 1/2] bpf: fix bpf_prog_pack for multi-node setup
Date:   Mon, 21 Mar 2022 11:00:08 -0700
Message-ID: <20220321180009.1944482-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321180009.1944482-1-song@kernel.org>
References: <20220321180009.1944482-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: HUMEd6jc_0Gh97vnizQhOTJCZ5gY6Cze
X-Proofpoint-ORIG-GUID: HUMEd6jc_0Gh97vnizQhOTJCZ5gY6Cze
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_07,2022-03-21_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

module_alloc requires num_online_nodes * PMD_SIZE to allocate huge pages.
bpf_prog_pack uses pack of size num_online_nodes * PMD_SIZE.
OTOH, module_alloc returns addresses that are PMD_SIZE aligned (instead of
num_online_nodes * PMD_SIZE aligned). Therefore, PMD_MASK should be used
to calculate pack_ptr in bpf_prog_pack_free().

Fixes: ef078600eec2 ("bpf: Select proper size for bpf_prog_pack")
Reported-by: syzbot+c946805b5ce6ab87df0b@syzkaller.appspotmail.com
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9d661e07e77c..f6b20fcbeb24 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -829,6 +829,7 @@ struct bpf_prog_pack {
 #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
 
 static size_t bpf_prog_pack_size = -1;
+static size_t bpf_prog_pack_mask = -1;
 
 static int bpf_prog_chunk_count(void)
 {
@@ -850,8 +851,12 @@ static size_t select_bpf_prog_pack_size(void)
 	/* Test whether we can get huge pages. If not just use PAGE_SIZE
 	 * packs.
 	 */
-	if (!ptr || !is_vm_area_hugepages(ptr))
+	if (!ptr || !is_vm_area_hugepages(ptr)) {
 		size = PAGE_SIZE;
+		bpf_prog_pack_mask = PAGE_MASK;
+	} else {
+		bpf_prog_pack_mask = PMD_MASK;
+	}
 
 	vfree(ptr);
 	return size;
@@ -935,7 +940,7 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 		goto out;
 	}
 
-	pack_ptr = (void *)((unsigned long)hdr & ~(bpf_prog_pack_size - 1));
+	pack_ptr = (void *)((unsigned long)hdr & bpf_prog_pack_mask);
 
 	list_for_each_entry(tmp, &pack_list, list) {
 		if (tmp->ptr == pack_ptr) {
-- 
2.30.2

