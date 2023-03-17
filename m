Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A856BF247
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjCQUTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCQUTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:19:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389532B2BA;
        Fri, 17 Mar 2023 13:19:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso10410530pjb.0;
        Fri, 17 Mar 2023 13:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679084372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DykUx1HbeAhX8oTWNoXUh40nOPiSPk2JHLd6IpEyXHY=;
        b=Vf+UbayJaUiQOpIPXNNFQUgOsPPFc/l7/DrK7qRj8UWgOQ6pHn5m/faFjpfDMY9DIZ
         gcjk3VHH6HL9zT1ewO9CAPwGzI8wpiJn03EGCxeB0mmHrlVWKhN6dOitzb+7h8roPC3Y
         Y9HiVsp0Xv/VyS01lkdfUZ/NWYKV/4j8FnXdYAqMWW0WU8YKP16VzFPWYyhqC0xxcWl3
         1DLNYk2bnORorDSHdYGPJgH9pQW8dPXq27rj0ihlj/tmUHAtdj8kMgGTCkGwOC02eN7h
         fiyTPkrH1s2kOHhxpFJk72WUvk0iHgncrPo9wZfF7bxyktMQ68/sgpp0Xd0WOP3r83Jk
         CtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DykUx1HbeAhX8oTWNoXUh40nOPiSPk2JHLd6IpEyXHY=;
        b=fdKdl9yehdeScX+1DjuD2UPoVtqkaJwMONQa8zW4Zr3fUpiFVb1I7en9LmfTjxGacn
         Rr6Ci5umXi2shDz/oZOlu5/mZYhBhDcqU/56dyag+uZDpJ8VL8UE4aNIbpJrjbe/g1vH
         VQOQyU1VAN2F9PtPcn/OKTwnXw5BJvN82qsAOr53yM4OdLixZHj+QgWDOrDhivWwU6Mn
         FWMQLfPpCllWBN3AsJH8kdSihWMYpemAEsbTS3rI4zzhBt09Uw6SdVKYEI8HOFeocJWP
         nPLRhPGwe1rAXRg57dc6i5gQANNpRG9HBUQQnIxR4WnXW2dJIZTZXALxf+TdPOW7KSba
         LCmA==
X-Gm-Message-State: AO0yUKX6kWERmH5F88rM97E/8/eB656GcAV7S8my88pv+StR1IyXUsu+
        NbhjWpx0/K/lxXNk/yndTyM=
X-Google-Smtp-Source: AK7set962yR1KyvWKVSeJx0w7rgHEDOvHLLTb1nLv8MVTTI2NJXKOlCewJN1iF8yuKYQ2DO4b/I7Wg==
X-Received: by 2002:a17:903:1247:b0:19e:d60a:e9e with SMTP id u7-20020a170903124700b0019ed60a0e9emr11540603plh.42.1679084372534;
        Fri, 17 Mar 2023 13:19:32 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id y9-20020a1709029b8900b0019e6f3112b6sm1924298plp.91.2023.03.17.13.19.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Mar 2023 13:19:32 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/4] libbpf: Fix relocation of kfunc ksym in ld_imm64 insn.
Date:   Fri, 17 Mar 2023 13:19:18 -0700
Message-Id: <20230317201920.62030-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
References: <20230317201920.62030-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

void *p = kfunc; -> generates ld_imm64 insn.
kfunc() -> generates bpf_call insn.

libbpf patches bpf_call insn correctly while only btf_id part of ld_imm64 is
set in the former case. Which means that pointers to kfuncs in modules are not
patched correctly and the verifier rejects load of such programs due to btf_id
being out of range. Fix libbpf to patch ld_imm64 for kfunc.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a557718401e4..4c34fbd7b5be 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7533,6 +7533,12 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 	ext->is_set = true;
 	ext->ksym.kernel_btf_id = kfunc_id;
 	ext->ksym.btf_fd_idx = mod_btf ? mod_btf->fd_array_idx : 0;
+	/* Also set kernel_btf_obj_fd to make sure that bpf_object__relocate_data()
+	 * populates FD into ld_imm64 insn when it's used to point to kfunc.
+	 * {kernel_btf_id, btf_fd_idx} -> fixup bpf_call.
+	 * {kernel_btf_id, kernel_btf_obj_fd} -> fixup ld_imm64.
+	 */
+	ext->ksym.kernel_btf_obj_fd = mod_btf ? mod_btf->fd : 0;
 	pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
 		 ext->name, kfunc_id);
 
-- 
2.34.1

