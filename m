Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB094EE5C7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 03:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243847AbiDABmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 21:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiDABmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 21:42:01 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0DC8256679;
        Thu, 31 Mar 2022 18:40:12 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.31:54702.941805125
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.43 (unknown [10.64.8.31])
        by 189.cn (HERMES) with SMTP id 640EC10023D;
        Fri,  1 Apr 2022 09:34:34 +0800 (CST)
Received: from  ([123.150.8.43])
        by gateway-153622-dep-749df8664c-cv9r2 with ESMTP id a0374471ff514ff584f9d185a0405b94 for ast@kernel.org;
        Fri, 01 Apr 2022 09:34:38 CST
X-Transaction-ID: a0374471ff514ff584f9d185a0405b94
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 123.150.8.43
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From:   Song Chen <chensong_2000@189.cn>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Song Chen <chensong_2000@189.cn>
Subject: [PATCH] sample: bpf: syscall_tp_user: print result of verify_map
Date:   Fri,  1 Apr 2022 09:41:12 +0800
Message-Id: <1648777272-21473-1-git-send-email-chensong_2000@189.cn>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syscall_tp only prints the map id and messages when something goes wrong,
but it doesn't print the value passed from bpf map. I think it's better
to show that value to users.

What's more, i also added a 2-second sleep before calling verify_map,
to make the value more obvious.

Signed-off-by: Song Chen <chensong_2000@189.cn>
---
 samples/bpf/syscall_tp_user.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/bpf/syscall_tp_user.c b/samples/bpf/syscall_tp_user.c
index a0ebf1833ed3..1faa7f08054e 100644
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
@@ -98,6 +101,7 @@ static int test(char *filename, int num_progs)
 	}
 	close(fd);
 
+	sleep(2);
 	/* verify the map */
 	for (i = 0; i < num_progs; i++) {
 		verify_map(map0_fds[i]);
-- 
2.25.1

