Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934133B967A
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhGATXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbhGATX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:23:29 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B559C061765;
        Thu,  1 Jul 2021 12:20:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v7so7077432pgl.2;
        Thu, 01 Jul 2021 12:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NPgBdaZsczlBDOTGQkaIHxgLQdCXAK4wLCMHRE4mdZg=;
        b=i+kuSkCMAr/X6IjOZX4WZ8ymTTVd3GC5LO4UmeoFKoGzlpDLX9TeA2P1IdjCWqXZUH
         AmsRzF8j3WxC8vDzY0NWT4bPWznFBVLuRahJ6tjA1tpv0iSaWgjjn1e/sfm+9765ILZ5
         pw4qLJTTmvfzJr5pbY92TmeK+DUwIAX1hEhnpKyyexuTdkfk/yj36quRm5dd1Zd0UHmo
         74n63zIuSkrnHf2vdY0JSg8bnxWkwUX+CaBb/SQr9ANwyJfQrMqtZVo/UC+TYQ1NfNeh
         GAkRUzKBjP3CO64Lph4VMEIoSTDrKh1Vmj/ED+q4YJfcXlbxArCvBfQPh+uVnxuzx0gw
         Ypsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NPgBdaZsczlBDOTGQkaIHxgLQdCXAK4wLCMHRE4mdZg=;
        b=ipivqEjJpvp0EiDdEDJ2uTtaJ6oHt+uXoXMnmoBWks5uYQu//OFoNnkhAPsw9IR1cn
         GJW2paLtVAbdJuwmgslZ3C1BDWoFkkwzrRNNhgMwkLYSddAAFk0Gw6hZVm3Xb2qwAZN2
         fTH69+yAe9K2fxDcrCd7dmkpS8ueBkcU281HIxsnn3iaMIjwOjHxgM0ppU/OiGUOI8EV
         ll3TJLEhCPfkCyTs9GSMfm8BLh4x/noarvrinWMZvn3+zoYGcSQKbRgfucxMvgvFqatj
         3JW5n2+uUDjpr/7t3mqdSL/xAQHDj7osHhsZ3pNzDH3v/v0880ZkRrk14hKQkbIASKxj
         KTiw==
X-Gm-Message-State: AOAM532r5GI3KOhVL8yXXKTdamqnznWxovBFRYoY7Lcn/Yp3GOKLUZdg
        8cap0fTKlsoqPltaTSITkcM=
X-Google-Smtp-Source: ABdhPJy2rNhuTCcQw1y1WIWth0dRM6NT7r4VLSazVRWBCWkwrRoGX0D5rAJWLEtwrGAMpvdAvTTZrg==
X-Received: by 2002:a63:5153:: with SMTP id r19mr1129983pgl.56.1625167256821;
        Thu, 01 Jul 2021 12:20:56 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id w8sm607725pgf.81.2021.07.01.12.20.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:20:56 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 5/9] bpf: Relax verifier recursion check.
Date:   Thu,  1 Jul 2021 12:20:40 -0700
Message-Id: <20210701192044.78034-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
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
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 62759164759d..45435471192b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9465,8 +9465,12 @@ static int visit_func_call_insn(int t, int insn_cnt,
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

