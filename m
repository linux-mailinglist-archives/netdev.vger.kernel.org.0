Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC39853EE55
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 21:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiFFTK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 15:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiFFTK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 15:10:28 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78A7FF6D;
        Mon,  6 Jun 2022 12:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ORwKW
        Fk56HMzad/JWmbUIgh0dKgAvtfDALDjLaSv0do=; b=TGPcncl5Cva4ADwacH8jT
        HJNPF7BgO5mrk1Mrqy0/04Eu1utNxUHG92/+AK1N5+G9gr1n2AnXKDS1zR5KMzSB
        FJSIge+OLNhRChmOH6v8AWbskJX8IJQeKa7wd/nILR4aVdmabIOb+PNOuN4X5F5c
        ehfzAOKPdveNyxqPa36DYE=
Received: from localhost.localdomain (unknown [111.224.11.53])
        by smtp9 (Coremail) with SMTP id DcCowAAXkuBRTZ5iPFaKHQ--.29251S2;
        Tue, 07 Jun 2022 02:54:10 +0800 (CST)
From:   mangosteen728 <mangosteen728@163.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        mangosteen728 <mangosteen728@163.com>
Subject: [PATCH] bpf:add function bpf_get_task_exe_path
Date:   Mon,  6 Jun 2022 18:54:01 +0000
Message-Id: <20220606185401.3902-1-mangosteen728@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAAXkuBRTZ5iPFaKHQ--.29251S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr43JFW3GF4xWr1DZryrWFg_yoW8Wr1kpF
        n5Jw15tr9Iqa93Jr1fJrs7C3W5u395Z347GFs2gr4Fyw1rXF1xWa4jyr1aqF9YqrnYkaya
        vr4YkrZFk3srZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07ULFxUUUUUU=
X-Originating-IP: [111.224.11.53]
X-CM-SenderInfo: 5pdqw0pvwhv0qxsyqiywtou0bp/1tbiRxIYLlc7YAQ4PwAAss
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the absolute path to get the executable corresponding tothe task

Signed-off-by: mangosteen728 <mangosteen728@163.com>
---
Hi
This is my first attempt to submit patch, there are shortcomings please more but wait.

In security audit often need to get the absolute path to the executable of the process so I tried to add bpf_get_task_exe_path in the helpers function to get.

The code currently only submits the implementation of the function and how is this patch merge possible if I then add the relevant places。

thanks
mangosteen728
kernel/bpf/helpers.c | 37 +++++++++++++++++++++++++++++++++++++
1 file changed, 37 insertions(+)
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 225806a..797f850 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -257,6 +257,43 @@
 	.arg2_type	= ARG_CONST_SIZE,
 };
 
+BPF_CALL_3(bpf_get_task_exe_path, struct task_struct *, task, char *, buf, u32, sz)
+{
+	struct file *exe_file = NULL;
+	char *p = NULL;
+	long len = 0;
+
+	if (!sz)
+		return 0;
+	exe_file = get_task_exe_file(tsk);
+	if (IS_ERR_OR_NULL(exe_file))
+		return 0;
+	p = d_path(&exe_file->f_path, buf, sz);
+	if (IS_ERR_OR_NULL(path)) {
+		len = PTR_ERR(p);
+	} else {
+		len = buf + sz - p;
+		memmove(buf, p, len);
+	}
+	fput(exe_file);
+	return len;
+}
+
+static const struct bpf_func_proto bpf_get_task_exe_path_proto = {
+	.func       = bpf_get_task_exe_path,
+	.gpl_only   = false,
+	.ret_type   = RET_INTEGER,
+	.arg1_type  = ARG_PTR_TO_BTF_ID,
+	.arg2_type  = ARG_PTR_TO_MEM,
+	.arg3_type  = ARG_CONST_SIZE_OR_ZERO,
+};
+
-- 

