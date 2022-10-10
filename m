Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C685F9891
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 08:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiJJGrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 02:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJJGrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 02:47:07 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9435247B;
        Sun,  9 Oct 2022 23:47:06 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Mm8Xz2cq9z6R7vH;
        Mon, 10 Oct 2022 14:44:51 +0800 (CST)
Received: from k01.huawei.com (unknown [10.67.174.197])
        by APP2 (Coremail) with SMTP id Syh0CgDnf9Tiv0NjoL4qAA--.49036S6;
        Mon, 10 Oct 2022 14:47:05 +0800 (CST)
From:   Xu Kuohai <xukuohai@huaweicloud.com>
To:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH bpf v2 4/5] selftest/bpf: Fix memory leak in kprobe_multi_test
Date:   Mon, 10 Oct 2022 03:04:53 -0400
Message-Id: <20221010070454.577433-5-xukuohai@huaweicloud.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221010070454.577433-1-xukuohai@huaweicloud.com>
References: <20221010070454.577433-1-xukuohai@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgDnf9Tiv0NjoL4qAA--.49036S6
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyfZw1fZF47Wr4xGrW3Jrb_yoW8Ar4Upa
        yFyw4Yka4xAF13X3W3GF48WFyruFsrZ34UuFWYvw15Cwn8Xw1kGF4xKay3KF95GrZ5Zw43
        u3W5trn5Ga1UXaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
        xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
        z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2
        Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
        6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0x
        vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAI
        cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUFgAwUUUUU
X-CM-SenderInfo: 50xn30hkdlqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Kuohai <xukuohai@huawei.com>

The get_syms() function in kprobe_multi_test.c does not free the string
memory allocated by sscanf correctly. Fix it.

Fixes: 5b6c7e5c4434 ("selftests/bpf: Add attach bench test")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 .../bpf/prog_tests/kprobe_multi_test.c          | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index d457a55ff408..07dd2c5b7f98 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -360,15 +360,14 @@ static int get_syms(char ***symsp, size_t *cntp)
 		 * to them. Filter out the current culprits - arch_cpu_idle
 		 * and rcu_* functions.
 		 */
-		if (!strcmp(name, "arch_cpu_idle"))
-			continue;
-		if (!strncmp(name, "rcu_", 4))
-			continue;
-		if (!strcmp(name, "bpf_dispatcher_xdp_func"))
-			continue;
-		if (!strncmp(name, "__ftrace_invalid_address__",
-			     sizeof("__ftrace_invalid_address__") - 1))
+		if (!strcmp(name, "arch_cpu_idle") ||
+			!strncmp(name, "rcu_", 4) ||
+			!strcmp(name, "bpf_dispatcher_xdp_func") ||
+			!strncmp(name, "__ftrace_invalid_address__",
+				 sizeof("__ftrace_invalid_address__") - 1)) {
+			free(name);
 			continue;
+		}
 		err = hashmap__add(map, name, NULL);
 		if (err) {
 			free(name);
@@ -394,7 +393,7 @@ static int get_syms(char ***symsp, size_t *cntp)
 	hashmap__free(map);
 	if (err) {
 		for (i = 0; i < cnt; i++)
-			free(syms[cnt]);
+			free(syms[i]);
 		free(syms);
 	}
 	return err;
-- 
2.30.2

