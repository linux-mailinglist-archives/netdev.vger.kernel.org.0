Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3183753AF37
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiFAVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiFAVBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:01:16 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02324220FE8
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 14:01:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m5-20020a17090a4d8500b001e0cfe135c7so1560892pjh.3
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 14:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UWMxiNyOlwtIdc3KQ0mHBpB/pAdWJlzdFsAZun7WkFE=;
        b=ifCfxZYqhDp1dPmwYPbtNaJASUd6PIp2vtBOnukFkDAxUdp0lRXEwulPEGZ/3mwfBL
         Wm80f4co2PZFiJv85JKL6oOupKLfcr14hjpoj1/KwPsCHi7BYGyC2L4kNkXNbIt1ONmd
         89NUBTFr+mtIvHVqfOdxoVVs5hVUUUx+gOs7f6Zojbs2mI2b9uVq1wfpz41BjiVEVX4I
         3Ur15yCLlUuOCp+aa4jf804n1w29DjfVd/+TJMJG7gOFbWRCrAqpVK7K+o++GAzzzh7U
         Um28h/p4dHMLHExl8pPtNUJ4hvgAv7cwHnVQziU5+/UFIzJjT/zqvDPTOQOo3js95t7X
         r0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UWMxiNyOlwtIdc3KQ0mHBpB/pAdWJlzdFsAZun7WkFE=;
        b=qLgO7BL1N8UIhEIjeiWEd+Fbdsc+5JU5djYatGTSawSSo0OiBR82VGeuzJHi0BK1yv
         C3r2YEUNt7qLMIMIp8DD/CeYioZhuhwCmFTP4G0hT42T9h4MN2QQ4CCtelgN36Hc3zoB
         MpMRJ8kiG1UpIVUD8wN2vhKr3cikz7F+tCwAKk1S7bDLTS6v7wrwBqKDqoPu9TkUyVa5
         Fwjvmm2daKXW/54GApRSBnwdgt4PJymD7sAPG2xNjpcu7F3XAKBig44W4VmNNq4ZbrQH
         zs2fw7dHrFgMphDqdtZK1c8m415SLiJm92gHThVxKodQVVFPOGAfurT9idXRXam8qFfD
         9rGA==
X-Gm-Message-State: AOAM532YvzGIGdPhmx/x+DIOyq9bBF2A4c7qK8PeLYtLp0jlECISOIb2
        0Nn4iW3Ts31tvjfnue0nd4xA54suqnx4j8BmO8wSiV85t0Kgw1lU8/+et++O6GLUP6FcHCJKGeh
        5uNoTTXST6Sf0sFzJlyjeLn1/YxBtqKgRf7kDl3vKD+W+FhN1blg9pQ==
X-Google-Smtp-Source: ABdhPJzNOi+ea50i2kSCcq9jcTne2sIbjuCUrl4O7DF7+LSX66rgt7ZVN7MztbXRtM7NM/JnvnWKToc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:8094:0:b0:505:b544:d1ca with SMTP id
 v20-20020aa78094000000b00505b544d1camr1024439pff.26.1654110152115; Wed, 01
 Jun 2022 12:02:32 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:14 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-8-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 07/11] libbpf: add lsm_cgoup_sock type
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
 tools/lib/bpf/libbpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5afe4cbd684f..a4209a1ad02f 100644
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
@@ -9157,6 +9158,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("freplace+",		EXT, 0, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("lsm+",			LSM, BPF_LSM_MAC, SEC_ATTACH_BTF, attach_lsm),
 	SEC_DEF("lsm.s+",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
+	SEC_DEF("lsm_cgroup+",		LSM, BPF_LSM_CGROUP, SEC_ATTACH_BTF),
 	SEC_DEF("iter+",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
 	SEC_DEF("iter.s+",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_iter),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
@@ -9610,6 +9612,7 @@ void btf_get_kernel_prefix_kind(enum bpf_attach_type attach_type,
 		*kind = BTF_KIND_TYPEDEF;
 		break;
 	case BPF_LSM_MAC:
+	case BPF_LSM_CGROUP:
 		*prefix = BTF_LSM_PREFIX;
 		*kind = BTF_KIND_FUNC;
 		break;
-- 
2.36.1.255.ge46751e96f-goog

