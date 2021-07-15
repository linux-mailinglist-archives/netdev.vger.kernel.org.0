Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172AE3C9554
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhGOA5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhGOA51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:57:27 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE6CC06175F;
        Wed, 14 Jul 2021 17:54:34 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s18so4311465pgq.3;
        Wed, 14 Jul 2021 17:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aeaDK8ldlPaWIiIl8LFT1XouRDitTESLjaYk4S5/4f4=;
        b=XnGYzK62tiyLMUBio4HCjuIcqJ4Yd7KFSYR/ytndCXnV/UuxNiaFeKPllAPeqSl9oT
         1ri3epaxQHNsq5SXeEhz0zvDyCUsm6zd2xnH+HIpKBhDEGPll8hRv6WYmDHQ3LFgpQBv
         4HPV02hU6PL81tnBcJrtJ/bpB59+m7JAP/TFV7HfljTTvxaN4rmDNowyKyn2Po5vwIpj
         aA/cm1LhLseljyMCB0rbtQLIoygTnR38iWXOAN5dainPJ9SGboOJhsWeP1MB7orPxqKU
         byKLgWIHKPuAKDXbcxALGqhF2HW3PQd/VDegajgw3j0L1DXitZTlY4TzuxGSs4UUbRy6
         Ccpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aeaDK8ldlPaWIiIl8LFT1XouRDitTESLjaYk4S5/4f4=;
        b=XKpr0tjhWyEun7s5keHg9iTvaSeM2WjnQPWMCKu6BDjrISrU+gHIM5T8WC6ddTLZ2r
         JhCDU5AfTAOb6OchnVlxZojDbZfvpmPRyfFW4auxrlX0iOXejBD8mUGAXUNWOVOAXXuA
         hGQUJ8zbV9ydf+D17u2vdMx9PK+kSLgKXZi4zUvZDFo5o6UYxLggX9OoZ5TGx0qdyiMu
         Xi9JhoZ3gax8MIulbH46K+Zy6NTe8d2Z9O/tmqvoUG+CVQgDWCfPrZwOOlBFmt3m62ic
         YBUopZK5UMIJr+qAjHTlL9vtY/FjLOVMa0Ykrk+Cop+TqtK1T+9l3Q0mK/+oTrSwVPRl
         HVZw==
X-Gm-Message-State: AOAM5320OkZ9WU03IQCZS5HGnwPAE6zA6Ces9AGKA8v0nSUZil71uzoZ
        Wv1ylsIvk2LZmLB9sEf+gkY=
X-Google-Smtp-Source: ABdhPJzA2c7qtx3jBjxUuPoRYXRiBm6e5eqKfyq7eQ/N1/4iWnCn/hftg+jEpqduV5ycGM/2hkDAaQ==
X-Received: by 2002:a63:f202:: with SMTP id v2mr848209pgh.30.1626310474039;
        Wed, 14 Jul 2021 17:54:34 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:120c])
        by smtp.gmail.com with ESMTPSA id nl2sm3439011pjb.10.2021.07.14.17.54.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jul 2021 17:54:33 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 bpf-next 07/11] bpf: Relax verifier recursion check.
Date:   Wed, 14 Jul 2021 17:54:13 -0700
Message-Id: <20210715005417.78572-8-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In the following bpf subprogram:
static int timer_cb(void *map, void *key, void *value)
{
    bpf_timer_set_callback(.., timer_cb);
}

the 'timer_cb' is a pointer to a function.
ld_imm64 insn is used to carry this pointer.
bpf_pseudo_func() returns true for such ld_imm64 insn.

Unlike bpf_for_each_map_elem() the bpf_timer_set_callback() is asynchronous.
Relax control flow check to allow such "recursion" that is seen as an infinite
loop by check_cfg(). The distinction between bpf_for_each_map_elem() the
bpf_timer_set_callback() is done in the follow up patch.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cb393de3c818..1511f92b4cf4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9463,8 +9463,12 @@ static int visit_func_call_insn(int t, int insn_cnt,
 		init_explored_state(env, t + 1);
 	if (visit_callee) {
 		init_explored_state(env, t);
-		ret = push_insn(t, t + insns[t].imm + 1, BRANCH,
-				env, false);
+		ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env,
+				/* It's ok to allow recursion from CFG point of
+				 * view. __check_func_call() will do the actual
+				 * check.
+				 */
+				bpf_pseudo_func(insns + t));
 	}
 	return ret;
 }
-- 
2.30.2

