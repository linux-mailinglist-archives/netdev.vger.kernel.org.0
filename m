Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912EB27236C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgIUMNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgIUMN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EFDC0613DA
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w5so12488642wrp.8
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z1qkwm2krC1me1PC4GrW1m2JsGuP3YU0jl8TIW9fAOc=;
        b=UAi/yLDszYNy5gCkGiBbaFbX+d6AMkK/sK+i1sJuzEBIqUuAOc88L46L78IpbtUU17
         bcfU+/bM8XRCtGCeERLi9jGzcp8AQDX+ijb63RJYECN0yyrQFbzJnuSqvYWUQ23EchT/
         eWSI/mTs8Rw4ZmkQXfuGu9sjH5cUwoB3Fer3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1qkwm2krC1me1PC4GrW1m2JsGuP3YU0jl8TIW9fAOc=;
        b=nXSNQpGVMDTqUdpFiO8k0uRxh/MTrTDqJKaXv2gRKqMUUik2lDoLrNgpZy+jSlhu98
         nXOTWJ3EkzxqBfftjDSpudoC+fm+oL8hpDhzMzZH9afq1GlRSX2pqernbpu6nqD8ptch
         mG9rndv8l9/TRlvugQpiUZPC3aO4sKyq3i1sJCd7AHJC2xenCFkMBZgCxeC2S87sE/8Z
         C5CgEy/Tkn2cdv7izmcXjrPVaSNtFRsfjrPZyGbqZK6MlLg3OWXrQLFO6wlomSIeXr3j
         sCQByq21N9fCGOj4mpoWsm/7rQTfvcVW5IDnvTsaa9l9FoeUwDz9UoK2ic6HL+vg7Oet
         FgIw==
X-Gm-Message-State: AOAM532SxZevYDjLrOJQyshysJxqJXL10WlcNk3DlP+jMhtIuTQyoSg7
        I2FJJR8XxMv9RSYLnNM8JX9Vrg==
X-Google-Smtp-Source: ABdhPJzB03iZrwErF6A85yImydtBAUcLxSEfJuYInGDV6SOBaE+86fIGW79JMXozZ5AU7qLSYmeqrA==
X-Received: by 2002:a5d:4949:: with SMTP id r9mr54258422wrs.27.1600690406684;
        Mon, 21 Sep 2020 05:13:26 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:26 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 09/11] bpf: check ARG_PTR_TO_SPINLOCK register type in check_func_arg
Date:   Mon, 21 Sep 2020 13:12:25 +0100
Message-Id: <20200921121227.255763-10-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the check for PTR_TO_MAP_VALUE to check_func_arg, where all other
checking is done as well. Move the invocation of process_spin_lock away
from the register type checking, to allow a future refactoring.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e09eedb30117..eefc8256df1c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3781,10 +3781,6 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno,
 	struct bpf_map *map = reg->map_ptr;
 	u64 val = reg->var_off.value;
 
-	if (reg->type != PTR_TO_MAP_VALUE) {
-		verbose(env, "R%d is not a pointer to map_value\n", regno);
-		return -EINVAL;
-	}
 	if (!is_const) {
 		verbose(env,
 			"R%d doesn't have constant offset. bpf_spin_lock has to be at the constant offset\n",
@@ -3993,16 +3989,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		if (type != expected_type)
 			goto err_type;
 	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
-		if (meta->func_id == BPF_FUNC_spin_lock) {
-			if (process_spin_lock(env, regno, true))
-				return -EACCES;
-		} else if (meta->func_id == BPF_FUNC_spin_unlock) {
-			if (process_spin_lock(env, regno, false))
-				return -EACCES;
-		} else {
-			verbose(env, "verifier internal error\n");
-			return -EFAULT;
-		}
+		expected_type = PTR_TO_MAP_VALUE;
+		if (type != expected_type)
+			goto err_type;
 	} else if (arg_type_is_mem_ptr(arg_type)) {
 		expected_type = PTR_TO_STACK;
 		/* One exception here. In case function allows for NULL to be
@@ -4108,6 +4097,17 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		err = check_helper_mem_access(env, regno,
 					      meta->map_ptr->value_size, false,
 					      meta);
+	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
+		if (meta->func_id == BPF_FUNC_spin_lock) {
+			if (process_spin_lock(env, regno, true))
+				return -EACCES;
+		} else if (meta->func_id == BPF_FUNC_spin_unlock) {
+			if (process_spin_lock(env, regno, false))
+				return -EACCES;
+		} else {
+			verbose(env, "verifier internal error\n");
+			return -EFAULT;
+		}
 	} else if (arg_type_is_mem_ptr(arg_type)) {
 		/* The access to this pointer is only checked when we hit the
 		 * next is_mem_size argument below.
-- 
2.25.1

