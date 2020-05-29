Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728B11E74F1
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgE2Eiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgE2Eiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 00:38:46 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE96AC08C5C6;
        Thu, 28 May 2020 21:38:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q9so621100pjm.2;
        Thu, 28 May 2020 21:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ep1Y75nSvUJ2oBtRIK4h2m1Nreof7ObB+DQxpZqqpsI=;
        b=BH+p4CG7E2cbPop1pr/kLdO17nmqOVSo3nLFFYJ6ildoxIdtAr2mpgswJJ/z3QaLW8
         8adRoe99R8u6pwBGLqW1n2413W4AutqYD4B0xX7VmeyzgZ0PYPsDkXhuMFfWv2/XV8Vt
         FcXUIAN+6XFDuk1328iDzY3LKEosZdM82Ssvs9cuTdoysiG9PlL3jRfYhe5H7GklXDiK
         6AEIIfLoIhnA94vikgtYGbBRmk2w6CBjEvKDzcQJp3emMpLC1sr7wsNsPTNopXyjIRrI
         VVpuktTiv6hseCTKYum36+83dFi+rYR86FT2fT71K4gZDD6dLtL+4FaTmEqDxXl4FHim
         vSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ep1Y75nSvUJ2oBtRIK4h2m1Nreof7ObB+DQxpZqqpsI=;
        b=te+zyknKaiqZYtoiQp0KjFA+lJCmErawSiKhc519r339xhBZH3wHVHkjoHSEtxlmin
         gK6T4TH6PRhfWokRnWJHi76X8iVde4KGR6uOFWIxcLnWCpsSyyaO80ICNjTb5ouRE99Q
         DBSLgztiUSKwbMBcHYBgeeTMYNY1WvP+tRJrQP0CEP7YTOLw9vIw1UKK7lUhFPsl1UeP
         j2dCqgbwGb8/duI/26YhsHJZ6Z1wLgR17FOgZ2HZhgWM74VQnHnGpDTPosnBQRzYfw+/
         leLxyibEQeYCg0QBfwJ4cQzhEqzKlS1HyQ9Z26B4zBTRA+TZDkfxyxNUQaoAiXBd87y0
         4p9w==
X-Gm-Message-State: AOAM532Z8jpStCXI5YZXjsyz01B/lhOgOS4MoKJrQJYK4QngBMjbU5Ue
        bagOJvc+xJ05ovQRjQJ2q9V+AYRB
X-Google-Smtp-Source: ABdhPJyXx83DakMkmhIy2wczPoyND8XPj/xhi2TkN5KfmNGBXbgNIk4MjOgDuuDi0DgON3gcVkNApA==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr7707781pjb.173.1590727124320;
        Thu, 28 May 2020 21:38:44 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id w73sm6288777pfd.113.2020.05.28.21.38.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 21:38:43 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 1/4] bpf: Fix use-after-free in fmod_ret check
Date:   Thu, 28 May 2020 21:38:36 -0700
Message-Id: <20200529043839.15824-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
References: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Fix the following issue:
[  436.749342] BUG: KASAN: use-after-free in bpf_trampoline_put+0x39/0x2a0
[  436.749995] Write of size 4 at addr ffff8881ef38b8a0 by task kworker/3:5/2243
[  436.750712]
[  436.752677] Workqueue: events bpf_prog_free_deferred
[  436.753183] Call Trace:
[  436.756483]  bpf_trampoline_put+0x39/0x2a0
[  436.756904]  bpf_prog_free_deferred+0x16d/0x3d0
[  436.757377]  process_one_work+0x94a/0x15b0
[  436.761969]
[  436.762130] Allocated by task 2529:
[  436.763323]  bpf_trampoline_lookup+0x136/0x540
[  436.763776]  bpf_check+0x2872/0xa0a8
[  436.764144]  bpf_prog_load+0xb6f/0x1350
[  436.764539]  __do_sys_bpf+0x16d7/0x3720
[  436.765825]
[  436.765988] Freed by task 2529:
[  436.767084]  kfree+0xc6/0x280
[  436.767397]  bpf_trampoline_put+0x1fd/0x2a0
[  436.767826]  bpf_check+0x6832/0xa0a8
[  436.768197]  bpf_prog_load+0xb6f/0x1350
[  436.768594]  __do_sys_bpf+0x16d7/0x3720

prog->aux->trampoline = tr should be set only when prog is valid.
Otherwise prog freeing will try to put trampoline via prog->aux->trampoline,
but it may not point to a valid trampoline.

Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN")
Acked-by: KP Singh <kpsingh@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d2e27dba4ac6..8cf8dae86f00 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10522,22 +10522,13 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 }
 #define SECURITY_PREFIX "security_"
 
-static int check_attach_modify_return(struct bpf_verifier_env *env)
+static int check_attach_modify_return(struct bpf_prog *prog, unsigned long addr)
 {
-	struct bpf_prog *prog = env->prog;
-	unsigned long addr = (unsigned long) prog->aux->trampoline->func.addr;
-
-	/* This is expected to be cleaned up in the future with the KRSI effort
-	 * introducing the LSM_HOOK macro for cleaning up lsm_hooks.h.
-	 */
 	if (within_error_injection_list(addr) ||
 	    !strncmp(SECURITY_PREFIX, prog->aux->attach_func_name,
 		     sizeof(SECURITY_PREFIX) - 1))
 		return 0;
 
-	verbose(env, "fmod_ret attach_btf_id %u (%s) is not modifiable\n",
-		prog->aux->attach_btf_id, prog->aux->attach_func_name);
-
 	return -EINVAL;
 }
 
@@ -10765,11 +10756,18 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 				goto out;
 			}
 		}
+
+		if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
+			ret = check_attach_modify_return(prog, addr);
+			if (ret)
+				verbose(env, "%s() is not modifiable\n",
+					prog->aux->attach_func_name);
+		}
+
+		if (ret)
+			goto out;
 		tr->func.addr = (void *)addr;
 		prog->aux->trampoline = tr;
-
-		if (prog->expected_attach_type == BPF_MODIFY_RETURN)
-			ret = check_attach_modify_return(env);
 out:
 		mutex_unlock(&tr->mutex);
 		if (ret)
-- 
2.23.0

