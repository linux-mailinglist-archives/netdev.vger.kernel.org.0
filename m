Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C374DE9A6
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243689AbiCSRct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243717AbiCSRcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:41 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52754457B1;
        Sat, 19 Mar 2022 10:31:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id o13so7338313pgc.12;
        Sat, 19 Mar 2022 10:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cJVyZjeOEvx3Lfsyy6KEMt0pbjay35w3CRFKsCROdt0=;
        b=OK4rLjPj7lNzt5BEEa9L1Z4QKJn9pYIcC9ajSWth0exTWw1+1u7BCl8D0VakqT6IAU
         XiqRdOH1SNNrB82Q/huswOP4Djic+w+i/ATCAF0iFRKnuYzWMSlmLeCFj+p8H0mkCwll
         uGaN1fq/gOyLCrQc4QFUX6yg3FDa/+Tm8Duqp/jK7xhrm8G0YJkeUdwydfI0Hi7h21o+
         1MJA/7VNowNk3kjz8Dy3jqxyDhKGoWNqga1/bSRDlahTOhvLyJeVxSAv1CRN/qd7W+8a
         umByxC08emMOptRp0tA0lz9BeVjkJFX2rlDaErusVMQqbeg1dGyzSRL9RLgIOBdgGOsk
         fFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cJVyZjeOEvx3Lfsyy6KEMt0pbjay35w3CRFKsCROdt0=;
        b=0WgSZSfd7Q+RZ3juNq/VVRMe7XxC4aqt4z7JcIYl+VXs6D7VHjA18VZMkBMCzmtP1a
         HGm3Ddi4EScJp2UDzOV2FI3HxEivOt7NhaGsfDBKD6JUplmvZMfp2KjC07jEawV23kiJ
         wrKiQln+pFcf5V5bFIpRjloNcx5/r0lgkKzu7ikCeck79sODl7GvYCovsbmBhR8SMLJO
         xoEnD8YCGMvFHc8srHV+OUhTAqNrpE/3jLiU1IucExHTWzuySOnQ2pSWVKeaVf+0YRLZ
         8Iae0PSSSyM081Y5PE9J60r8lZBApoFIA+zePxxQjjHY9On5/vH7nG1BriUCelnYNs34
         3WTw==
X-Gm-Message-State: AOAM532kEcy7t/uIctCnvWkYAcl30UsZLe6HLYKfw28gOyODD09LgMIm
        HQJsoeNdP3FrP3YXtjZ5QwEwIoLrd2zJEpYVgbQ=
X-Google-Smtp-Source: ABdhPJwmiilJbVdPYG4/QB253/81b+H5bYLkd9Pn7OxLgGgpM8MfUoP7wNhIy4RR8R9itochanvoZA==
X-Received: by 2002:a62:684:0:b0:4f7:803:d1b0 with SMTP id 126-20020a620684000000b004f70803d1b0mr16231429pfg.10.1647711051443;
        Sat, 19 Mar 2022 10:30:51 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:50 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 09/14] bpf: Add no charge flag for bpf prog
Date:   Sat, 19 Mar 2022 17:30:31 +0000
Message-Id: <20220319173036.23352-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A no charge flag is also introduced for bpf prog, which is similar with
the no charge flag introduced for bpf map. The usecase of it is the same
too.

It is added in bpf_attr for BPF_PROG_LOAD command, and then set in
bpf_prog_aux for the memory allocation which is not at the loading path.
There're 4B holes after the member max_rdwr_access in struct bpf_prog_aux,
so we can place the new member there.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            | 8 ++++++++
 include/uapi/linux/bpf.h       | 3 +++
 kernel/bpf/syscall.c           | 4 +++-
 tools/include/uapi/linux/bpf.h | 3 +++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 90a542d5a411..69ff3e35b8f2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -214,6 +214,13 @@ map_flags_no_charge(gfp_t flags, union bpf_attr *attr)
 	return flags |= (attr->map_flags & BPF_F_NO_CHARGE) ? 0 : __GFP_ACCOUNT;
 }
 
+static inline gfp_t
+prog_flags_no_charge(gfp_t flags, union bpf_attr *attr)
+{
+	return flags |= (attr->prog_flags & BPF_F_PROG_NO_CHARGE) ?
+					0 : __GFP_ACCOUNT;
+}
+
 static inline gfp_t
 bpf_flags_no_charge(gfp_t flags, bool no_charge)
 {
@@ -958,6 +965,7 @@ struct bpf_prog_aux {
 	u32 ctx_arg_info_size;
 	u32 max_rdonly_access;
 	u32 max_rdwr_access;
+	bool no_charge; /* dont' charge memory to memcg */
 	struct btf *attach_btf;
 	const struct bpf_ctx_arg_aux *ctx_arg_info;
 	struct mutex dst_mutex; /* protects dst_* pointers below, *after* prog becomes visible */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 93ee04fb8c62..3c98b1b77db6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1121,6 +1121,9 @@ enum {
  * fully support xdp frags.
  */
 	BPF_F_XDP_HAS_FRAGS		= (1U << 5),
+
+/* Don't charge memory to memcg */
+	BPF_F_PROG_NO_CHARGE	= (1U << 6),
 };
 
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e84aeefa05f4..346f3df9fa1d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2230,7 +2230,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32 |
-				 BPF_F_XDP_HAS_FRAGS))
+				 BPF_F_XDP_HAS_FRAGS |
+				 BPF_F_PROG_NO_CHARGE))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2317,6 +2318,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
+	prog->aux->no_charge = attr->prog_flags & BPF_F_PROG_NO_CHARGE;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 71a4d8fdc880..89752e5c11c0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1121,6 +1121,9 @@ enum {
  * fully support xdp frags.
  */
 	BPF_F_XDP_HAS_FRAGS		= (1U << 5),
+
+/* Don't charge memory to memcg */
+	BPF_F_PROG_NO_CHARGE	= (1U << 6),
 };
 
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
-- 
2.17.1

