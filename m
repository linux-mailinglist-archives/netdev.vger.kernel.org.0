Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EEA4F8B7E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiDGWdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiDGWdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:33:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53550710F7
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:31:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v7-20020a05690204c700b0063dc849f9f8so5256928ybs.18
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 15:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mVRkJUJrBQiO7+Bsu1whxLXMRGnF9n+72bMW+OHddAU=;
        b=AYjwe+v0XMLfY7jZx6LsnB0JoRBo9syomvIEP6T6T7OWTEZFTxlqrmEa9/6TFm5h7i
         zabbHObdPEb6fS1hkMI7leGwyZRoN4T08PSCgSb93MA9QjsP/bjh4b48xkt9F9k6IQMS
         4ELLZMwEOmuYk9QVCZJq3U3Ad/k0jn7hBwWNbzo8jiNOFm2BiVay0d6cygSuSkgLtMRy
         ixi89Oi+4FR7LWAK1qtZwmKxyBpeQ0KLUdF1G38prXwCjTOHcTk17X+egtDD26zxk34j
         eRWQxPllBs6NpIg+ZtqVK/FiQ4UfyYFXrifhI0MSgol0iRQ5X4aZWnZX0EgAUFbrflSr
         uZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mVRkJUJrBQiO7+Bsu1whxLXMRGnF9n+72bMW+OHddAU=;
        b=u5hjgvu/GXP16XAe7QH151pAOBUA8GgWWYJTHcTt6uSZMpENZi0fUV9FXho3FCbW9c
         9XdO6Bom0M75jEdCkk3rU1uczMBPz0lhnSuunasDuQTX2myTbCWrpLphHCW02oAH2XGp
         CCbSCRuRgE02QiKNCEPp7IYs74IZm144oP/Em11tdRlcvWZcVOTJgvGjWJgTfNOJWFlS
         mpPxdk62d+7kNErYDEcJMAF7PqAiXb2NTj/Kayd8Jd03jsMHPNu0VRXcXEcHO5wtSdNH
         d2fDK0ufKLK/jOPDLxsDlrLHM2lwOi55j3lrSBULogI6dnu+gXhqd58IGwWJCR4Qoe7y
         XEzQ==
X-Gm-Message-State: AOAM530ztAUn25byrNBxnL/wSV6XixSISgTfXmqt+4/NIM4kB/o97QWr
        Fnj/P3a/tD8JC+vMCtZC57p3B5kEiei7i8237tWcmQ8NkJquoUoUI4W5rDQnq5oP6A7dzJwUILV
        76CCV+cy3iMJSarPtzX0W1u6StZ6+2AOJMUUln5BcA1oVUrW7G+wDKA==
X-Google-Smtp-Source: ABdhPJyLcjvVx5y++Qk77NNgUekWaOkb7vEEtnXRpQB5N39ZlXk4gXG6cXCB+61m3OAeTRXg4xNSZLk=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:9e25:5910:c207:e29a])
 (user=sdf job=sendgmr) by 2002:a81:9852:0:b0:2eb:9b44:37fc with SMTP id
 p79-20020a819852000000b002eb9b4437fcmr13679573ywg.263.1649370687440; Thu, 07
 Apr 2022 15:31:27 -0700 (PDT)
Date:   Thu,  7 Apr 2022 15:31:10 -0700
In-Reply-To: <20220407223112.1204582-1-sdf@google.com>
Message-Id: <20220407223112.1204582-6-sdf@google.com>
Mime-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH bpf-next v3 5/7] libbpf: add lsm_cgoup_sock type
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/common.c | 1 +
 tools/lib/bpf/libbpf.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 0c1e06cf50b9..2b3bf6fa413a 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -67,6 +67,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_TRACE_FEXIT]		= "fexit",
 	[BPF_MODIFY_RETURN]		= "mod_ret",
 	[BPF_LSM_MAC]			= "lsm_mac",
+	[BPF_LSM_CGROUP]		= "lsm_cgroup",
 	[BPF_SK_LOOKUP]			= "sk_lookup",
 	[BPF_TRACE_ITER]		= "trace_iter",
 	[BPF_XDP_DEVMAP]		= "xdp_devmap",
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 016ecdd1c3e1..789726df5fe8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8691,6 +8691,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("freplace/",		EXT, 0, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("lsm/",			LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
 	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
+	SEC_DEF("lsm_cgroup/",	LSM, BPF_LSM_CGROUP, SEC_ATTACH_BTF),
 	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
 	SEC_DEF("iter.s/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_iter),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
@@ -9112,6 +9113,7 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
 		*kind = BTF_KIND_TYPEDEF;
 		break;
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 		*prefix = BTF_LSM_PREFIX;
 		*kind = BTF_KIND_FUNC;
 		break;
-- 
2.35.1.1178.g4f1659d476-goog

