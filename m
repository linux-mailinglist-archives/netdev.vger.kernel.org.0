Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D435F9FD1
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJJOIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiJJOIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:08:09 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAA56EF02;
        Mon, 10 Oct 2022 07:08:06 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MmLKV3FffzwPL0;
        Mon, 10 Oct 2022 22:05:34 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 10 Oct
 2022 22:08:03 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
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
Subject: [PATCH bpf v3 2/6] libbpf: Fix memory leak in parse_usdt_arg()
Date:   Mon, 10 Oct 2022 10:25:49 -0400
Message-ID: <20221010142553.776550-3-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221010142553.776550-1-xukuohai@huawei.com>
References: <20221010142553.776550-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the arm64 version of parse_usdt_arg(), when sscanf returns 2, reg_name
is allocated but not freed. Fix it.

Fixes: 0f8619929c57 ("libbpf: Usdt aarch64 arg parsing support")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 tools/lib/bpf/usdt.c | 59 +++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index e83b497c2245..f3b5be7415b5 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -1351,8 +1351,10 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 	char *reg_name = NULL;
 	int arg_sz, len, reg_off;
 	long off;
+	int ret;
 
-	if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
+	ret = sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len);
+	if (ret == 3) {
 		/* Memory dereference case, e.g., -4@[sp, 96] */
 		arg->arg_type = USDT_ARG_REG_DEREF;
 		arg->val_off = off;
@@ -1361,32 +1363,37 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 		if (reg_off < 0)
 			return reg_off;
 		arg->reg_off = reg_off;
-	} else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
-		/* Memory dereference case, e.g., -4@[sp] */
-		arg->arg_type = USDT_ARG_REG_DEREF;
-		arg->val_off = 0;
-		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
-		if (reg_off < 0)
-			return reg_off;
-		arg->reg_off = reg_off;
-	} else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
-		/* Constant value case, e.g., 4@5 */
-		arg->arg_type = USDT_ARG_CONST;
-		arg->val_off = off;
-		arg->reg_off = 0;
-	} else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
-		/* Register read case, e.g., -8@x4 */
-		arg->arg_type = USDT_ARG_REG;
-		arg->val_off = 0;
-		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
-		if (reg_off < 0)
-			return reg_off;
-		arg->reg_off = reg_off;
 	} else {
-		pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
-		return -EINVAL;
+		if (ret == 2)
+			free(reg_name);
+
+		if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
+			/* Memory dereference case, e.g., -4@[sp] */
+			arg->arg_type = USDT_ARG_REG_DEREF;
+			arg->val_off = 0;
+			reg_off = calc_pt_regs_off(reg_name);
+			free(reg_name);
+			if (reg_off < 0)
+				return reg_off;
+			arg->reg_off = reg_off;
+		} else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
+			/* Constant value case, e.g., 4@5 */
+			arg->arg_type = USDT_ARG_CONST;
+			arg->val_off = off;
+			arg->reg_off = 0;
+		} else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
+			/* Register read case, e.g., -8@x4 */
+			arg->arg_type = USDT_ARG_REG;
+			arg->val_off = 0;
+			reg_off = calc_pt_regs_off(reg_name);
+			free(reg_name);
+			if (reg_off < 0)
+				return reg_off;
+			arg->reg_off = reg_off;
+		} else {
+			pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
+			return -EINVAL;
+		}
 	}
 
 	arg->arg_signed = arg_sz < 0;
-- 
2.30.2

