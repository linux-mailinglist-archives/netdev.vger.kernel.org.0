Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95308546B39
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350117AbiFJQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350007AbiFJQ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:58:22 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB9733A02
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:19 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q2-20020a170902dac200b00168b3978426so2036942plx.17
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xRcPDqj1mKOOR6+ZcC7hO72I0OFbqlU+YKKzpHrQK2A=;
        b=GP99K86mJjg4rIsgWSXfe/nqCeUeEg+vdIgLLwJsrQzwHgN1NlC7H41wJhQROI/89I
         6A26vBPbbPdKHgsk9F4SksInxu8mcMX70jNl0xEO0IkUcGEz7TYl48EXe+IwacojBpK3
         71LVcgJQAyuSfLr0jVbSBOW7VRyaIVMnDQ8TTm8zvvMmjQiFi4LCToL0jxhas5HhJl+G
         +Ry3jed5mFi8Nxb6Qghl5fWfM8uHIlqbjA0JB7mp+g/jvCr+Mk0jjSJoVC7vlQEBetAw
         nzLx0K4oAP8UqSHc/bu4/DkaNiUds4QPxUkp56FSxx/+0Ry6X7m9qw3CQpc0ie3EFdNR
         5hgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xRcPDqj1mKOOR6+ZcC7hO72I0OFbqlU+YKKzpHrQK2A=;
        b=tc8rwHuH9d6oB7vlCwY6mLieAvaDjjODXAwoWhRkNmGOa2L1NBxum5xdVan8f4NMof
         ADqtdgD3TMyvToBgAI9zYkXemjt4DuzQXGkoZcKA53C7R/hnxNfe9hTsSQA2vEC5xpZA
         ztfv6WhlfAR5px2fAv6e1UrM1UYb7SY1max+ac078Y8UC0h5EITjDFPKD4tVfAusuHpV
         UBQs/nyduiwADxBBWIEYCSiExmPBWkvGMFaU0zV3RJ1Xi4VJpPWz3f4w0BceP6O+BD0d
         30E1gNiaGcGWPdOjjAif35w/JgB2OPZiwtcGLrp5yd0a1RxCCyckm2azSrL1GRzHQRI5
         u8yw==
X-Gm-Message-State: AOAM53181wASeiEZ1ZfCRleHMssSIvr0Nwcu6masKB/5a/g/2ChYgf5Y
        SUXqN/1ePGBnaXm2/wmFsb6M+Qrp1njB10KKwPsZOwgdSG5fwoY7o1rju+lgQ3533wwa0U6p/qN
        jx8PHzcH4Yp2ds03k3pS5Erfo/njbwojMgEyDJpBSScqVOJMOZq/zcQ==
X-Google-Smtp-Source: ABdhPJzMov5oOTlb87gz4hrLsErXIurGXoZgIGF+Sr1bciKEAq40P4K3R+YJmTtXVCKevMdsneFZwpw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr1292pje.0.1654880297688; Fri, 10 Jun
 2022 09:58:17 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:58:00 -0700
In-Reply-To: <20220610165803.2860154-1-sdf@google.com>
Message-Id: <20220610165803.2860154-8-sdf@google.com>
Mime-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH bpf-next v9 07/10] libbpf: add lsm_cgoup_sock type
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lsm_cgroup/ is the prefix for BPF_LSM_CGROUP.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0781fae58a06..cb1720de1b65 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -107,6 +107,7 @@ static const char * const attach_type_name[] = {
 	[BPF_TRACE_FEXIT]		= "trace_fexit",
 	[BPF_MODIFY_RETURN]		= "modify_return",
 	[BPF_LSM_MAC]			= "lsm_mac",
+	[BPF_LSM_CGROUP]		= "lsm_cgroup",
 	[BPF_SK_LOOKUP]			= "sk_lookup",
 	[BPF_TRACE_ITER]		= "trace_iter",
 	[BPF_XDP_DEVMAP]		= "xdp_devmap",
@@ -9201,6 +9202,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("freplace+",		EXT, 0, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("lsm+",			LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
 	SEC_DEF("lsm.s+",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
+	SEC_DEF("lsm_cgroup+",		LSM, BPF_LSM_CGROUP, SEC_ATTACH_BTF),
 	SEC_DEF("iter+",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
 	SEC_DEF("iter.s+",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_iter),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
@@ -9654,6 +9656,7 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
 		*kind = BTF_KIND_TYPEDEF;
 		break;
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 		*prefix = BTF_LSM_PREFIX;
 		*kind = BTF_KIND_FUNC;
 		break;
-- 
2.36.1.476.g0c4daa206d-goog

