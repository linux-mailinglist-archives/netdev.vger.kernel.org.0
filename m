Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B3E5FB1C1
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 13:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiJKLnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 07:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJKLnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 07:43:37 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1377CB6B;
        Tue, 11 Oct 2022 04:43:34 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Mmv4Y2vPbz6Pmfc;
        Tue, 11 Oct 2022 19:41:17 +0800 (CST)
Received: from k01.huawei.com (unknown [10.67.174.197])
        by APP2 (Coremail) with SMTP id Syh0CgBX8NTXVkVj5HNpAA--.32480S6;
        Tue, 11 Oct 2022 19:43:32 +0800 (CST)
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
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH bpf-next v4 4/6] selftest/bpf: Fix memory leak in kprobe_multi_test
Date:   Tue, 11 Oct 2022 08:01:06 -0400
Message-Id: <20221011120108.782373-5-xukuohai@huaweicloud.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221011120108.782373-1-xukuohai@huaweicloud.com>
References: <20221011120108.782373-1-xukuohai@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgBX8NTXVkVj5HNpAA--.32480S6
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyfZw18AF1fXw43Cr13twb_yoW8ZFyDpa
        4xCw4YkF1xAF1rWFn7Ga1kXry5ur4kZry8Cry5tw13uw1kAwn5JF4IkayfKas3GrWkX3Wr
        C3Z7Gr9rK3yDX3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
        xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
        z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2
        Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
        6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0x
        vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAI
        cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUFgAwUUUUU
X-CM-SenderInfo: 50xn30hkdlqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
Acked-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index d457a55ff408..287b3ac40227 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -325,7 +325,7 @@ static bool symbol_equal(const void *key1, const void *key2, void *ctx __maybe_u
 static int get_syms(char ***symsp, size_t *cntp)
 {
 	size_t cap = 0, cnt = 0, i;
-	char *name, **syms = NULL;
+	char *name = NULL, **syms = NULL;
 	struct hashmap *map;
 	char buf[256];
 	FILE *f;
@@ -352,6 +352,8 @@ static int get_syms(char ***symsp, size_t *cntp)
 		/* skip modules */
 		if (strchr(buf, '['))
 			continue;
+
+		free(name);
 		if (sscanf(buf, "%ms$*[^\n]\n", &name) != 1)
 			continue;
 		/*
@@ -369,32 +371,32 @@ static int get_syms(char ***symsp, size_t *cntp)
 		if (!strncmp(name, "__ftrace_invalid_address__",
 			     sizeof("__ftrace_invalid_address__") - 1))
 			continue;
+
 		err = hashmap__add(map, name, NULL);
-		if (err) {
-			free(name);
-			if (err == -EEXIST)
-				continue;
+		if (err == -EEXIST)
+			continue;
+		if (err)
 			goto error;
-		}
+
 		err = libbpf_ensure_mem((void **) &syms, &cap,
 					sizeof(*syms), cnt + 1);
-		if (err) {
-			free(name);
+		if (err)
 			goto error;
-		}
-		syms[cnt] = name;
-		cnt++;
+
+		syms[cnt++] = name;
+		name = NULL;
 	}
 
 	*symsp = syms;
 	*cntp = cnt;
 
 error:
+	free(name);
 	fclose(f);
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

