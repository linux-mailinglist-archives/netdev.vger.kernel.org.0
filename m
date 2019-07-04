Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058095FE26
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfGDV1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:27:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46772 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbfGDV1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:27:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so3230373wru.13
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rBAvqk5Lee9P3/iFEoKbYrpRp6bOz8xfKO0gRnG7T/A=;
        b=USLsSejGFH1AyitieoHpiakUDgruq8zdcSMHXAYW3oFfV1GCkTnFP95OUEaa7eGN52
         efK1b+fqoFvW+M54eOiG9wm1WNXJkReW4WSHGPMcMhGWFO2IQhJDkwS3sgCuby1o9/uL
         r9hkrfNgBkwOFNvkBRQjw03vEKVZ47wJxUw/At3FbHL9lXXTK72Fw0Dv76umNXUHvwRR
         vIbqHYh6Q/Gy2o+SMVegPb1vLUrauIEf5irMqmVyxyILZHWUsBuAu5Rj7WZnGRjKu/7I
         FTQAY4Kt7mPhLI4JoB4MwxErt3zlnt5fIf04GCE+a8yCKHHv6z8Vu87W/BsWQIre0hO2
         Y3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rBAvqk5Lee9P3/iFEoKbYrpRp6bOz8xfKO0gRnG7T/A=;
        b=l8MwxB3I4iMRZxwYXWmIXo9kPHDzBndaXepi8GIqHti9KHeaKR+YpOF1E2jM8+i3a5
         CzX9Ids9wv+TQBdAsSuqjPOTbwaOl+h+U1orrCXqU5xpxKxpiAifsakV8nn0QKlqLpry
         mUpaudsiNCZzy9wFEib0H9MR21HSDeeXGqu4wOKFOAlVsILUYcHGkrusGNhyu+qURU1e
         4g5kbK9TV8zywECNHQelmxE6VWA7BHEUgqbWi7Ka3Forb8QzZjXGwxYIUhjUQsCXsvg4
         /g05UpW/rnapDYiCcOnZj43awaDXTSMm+/ZOdjJ4rXyg6YPPccFOCJLI1X+J8QR7lL+z
         a/fg==
X-Gm-Message-State: APjAAAU/Sn8z0fpb4uBw3AOlrk+DzkWQ0grTPIs8rIKZ9ZSlTqIHwpgv
        naeQ0EBqh1Yx5lF9bCVwGoEjZQ==
X-Google-Smtp-Source: APXvYqwDNXYvNH5AjI0e1o3E6zlAtQBclKtGaxRxbSYcLYaArr2Rfg+Q6LInHw+FEayzR568IDvj6Q==
X-Received: by 2002:adf:ca0f:: with SMTP id o15mr358930wrh.135.1562275630883;
        Thu, 04 Jul 2019 14:27:10 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t17sm9716654wrs.45.2019.07.04.14.27.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 14:27:10 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     ecree@solarflare.com, naveen.n.rao@linux.vnet.ibm.com,
        andriin@fb.com, jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [RFC bpf-next 7/8] bpf: migrate insn remove to list patching infra
Date:   Thu,  4 Jul 2019 22:26:50 +0100
Message-Id: <1562275611-31790-8-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch migrate dead code remove pass to new list patching
infrastructure.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/verifier.c | 59 +++++++++++++++++----------------------------------
 1 file changed, 19 insertions(+), 40 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 58d6bbe..abe11fd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8500,49 +8500,30 @@ verifier_linearize_list_insn(struct bpf_verifier_env *env,
 	return ret_env;
 }
 
-static int opt_remove_dead_code(struct bpf_verifier_env *env)
+static int opt_remove_useless_code(struct bpf_verifier_env *env)
 {
-	struct bpf_insn_aux_data *aux_data = env->insn_aux_data;
-	int insn_cnt = env->prog->len;
-	int i, err;
-
-	for (i = 0; i < insn_cnt; i++) {
-		int j;
-
-		j = 0;
-		while (i + j < insn_cnt && !aux_data[i + j].seen)
-			j++;
-		if (!j)
-			continue;
-
-		err = verifier_remove_insns(env, i, j);
-		if (err)
-			return err;
-		insn_cnt = env->prog->len;
-	}
-
-	return 0;
-}
-
-static int opt_remove_nops(struct bpf_verifier_env *env)
-{
-	const struct bpf_insn ja = BPF_JMP_IMM(BPF_JA, 0, 0, 0);
-	struct bpf_insn *insn = env->prog->insnsi;
-	int insn_cnt = env->prog->len;
-	int i, err;
+	struct bpf_insn_aux_data *auxs = env->insn_aux_data;
+	const struct bpf_insn nop =
+		BPF_JMP_IMM(BPF_JA, 0, 0, 0);
+	struct bpf_list_insn *list, *elem;
+	int ret = 0;
 
-	for (i = 0; i < insn_cnt; i++) {
-		if (memcmp(&insn[i], &ja, sizeof(ja)))
+	list = bpf_create_list_insn(env->prog);
+	if (IS_ERR(list))
+		return PTR_ERR(list);
+	for (elem = list; elem; elem = elem->next) {
+		if (auxs[elem->orig_idx - 1].seen &&
+		    memcmp(&elem->insn, &nop, sizeof(nop)))
 			continue;
 
-		err = verifier_remove_insns(env, i, 1);
-		if (err)
-			return err;
-		insn_cnt--;
-		i--;
+		elem->flag |= LIST_INSN_FLAG_REMOVED;
 	}
 
-	return 0;
+	env = verifier_linearize_list_insn(env, list);
+	if (IS_ERR(env))
+		ret = PTR_ERR(env);
+	bpf_destroy_list_insn(list);
+	return ret;
 }
 
 static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
@@ -9488,9 +9469,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		if (ret == 0)
 			opt_hard_wire_dead_code_branches(env);
 		if (ret == 0)
-			ret = opt_remove_dead_code(env);
-		if (ret == 0)
-			ret = opt_remove_nops(env);
+			ret = opt_remove_useless_code(env);
 	} else {
 		if (ret == 0)
 			sanitize_dead_code(env);
-- 
2.7.4

