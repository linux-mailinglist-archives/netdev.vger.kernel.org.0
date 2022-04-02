Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D774EFFCF
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 10:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353090AbiDBIw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 04:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiDBIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 04:52:27 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FA3D403C3;
        Sat,  2 Apr 2022 01:50:32 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.41:47232.458224640
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.43 (unknown [10.64.8.41])
        by 189.cn (HERMES) with SMTP id 190901001DC;
        Sat,  2 Apr 2022 16:50:21 +0800 (CST)
Received: from  ([172.27.8.53])
        by gateway-151646-dep-b7fbf7d79-9vctg with ESMTP id 7c40bd6158ac417ba079583c19fc5d74 for ast@kernel.org;
        Sat, 02 Apr 2022 16:50:31 CST
X-Transaction-ID: 7c40bd6158ac417ba079583c19fc5d74
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 172.27.8.53
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From:   Song Chen <chensong_2000@189.cn>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Song Chen <chensong_2000@189.cn>
Subject: [PATCH v2] sample: bpf: syscall_tp_user: print result of verify_map
Date:   Sat,  2 Apr 2022 16:57:08 +0800
Message-Id: <1648889828-12417-1-git-send-email-chensong_2000@189.cn>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the end of the test, we already print out
    prog <prog number>: map ids <...> <...>
Value is the number read from kernel through bpf map, further print out
    verify map:<map id> val:<...>
will help users to understand the program runs successfully.

Signed-off-by: Song Chen <chensong_2000@189.cn>
---
 samples/bpf/syscall_tp_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/bpf/syscall_tp_user.c b/samples/bpf/syscall_tp_user.c
index a0ebf1833ed3..c55383068384 100644
--- a/samples/bpf/syscall_tp_user.c
+++ b/samples/bpf/syscall_tp_user.c
@@ -36,6 +36,9 @@ static void verify_map(int map_id)
 		fprintf(stderr, "failed: map #%d returns value 0\n", map_id);
 		return;
 	}
+
+	printf("verify map:%d val: %d\n", map_id, val);
+
 	val = 0;
 	if (bpf_map_update_elem(map_id, &key, &val, BPF_ANY) != 0) {
 		fprintf(stderr, "map_update failed: %s\n", strerror(errno));
-- 
2.25.1

