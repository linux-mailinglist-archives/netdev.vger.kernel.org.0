Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56BF3B9678
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhGATXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 15:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbhGATX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 15:23:26 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B49C061764;
        Thu,  1 Jul 2021 12:20:55 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id u14so7030303pga.11;
        Thu, 01 Jul 2021 12:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1CgQ/PnEyWs6JaL1Gp3My3DCnI1gq2qYMVWUFv4N6hc=;
        b=TwhVSFb18rR/4gIsU5b97cz48e+0oSEZxbh2AfnuMvTL2tACVC2ltbQXRAxYSIZWdY
         xTRcYTObjKWiqDfKbM1Ta/hDubCg91LXxGoitdWPKoX4sDwF0Hivb4ix7CTgHFWTEVDu
         oys9h+9/5NgdqAwWUaa+7eJzrdPiUf6SN7aLmijjsQIR5lNO3inh3LGMuOHCHKnSDK6f
         Ee6O7gfBr1NZFiOcjfdDcnsP78YE5xpR+I7//d8wQYSe4IgdOaziC4jxOpaJ80uaKBCy
         WPvYevf24hZ80u+hdJYDl/ndtodaTh8rtbf58pTcm6mQ1BnRHX6uUvvWuTMnL56bM3r2
         e8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1CgQ/PnEyWs6JaL1Gp3My3DCnI1gq2qYMVWUFv4N6hc=;
        b=hxuvdh1ZJiBhkQhwJwL6Q44olqjha+JIgaC5l57aiOHGgwCYFNYt8mLzTR4731H3JI
         sxGOFz7Z5rwHdwTrXdrVSwJMxDUYb8R0ED1bB1hf126aZHejtcj89pAn5RPq5BnxtvN3
         Slyp80boNWH6ulzKtyTyt9Tm0GVRz+htzkPZ5HuhTGg5KRtn9RYf7/Qf/3KxgfnMwwqH
         n4Jspc2Ofqg1TJY7vVYQLriYXIjITtmgw2lX6X0zwb+K7gp/iFbAW+H7GU1Fu8s7bPLB
         zpgzsMrB8voesaqQZ+tkRuHyVee7k2jZcNtkcGC+wf+pr9dEFuu7sXWFn3zRPxnN+/oj
         Tsxg==
X-Gm-Message-State: AOAM5300SJ08vFxIHmZtPUKgFvBny7CV2koQbFW7UXRBA18ZknIp+LN1
        jO8oN3W3dP1aX0Jf3aHg6wE=
X-Google-Smtp-Source: ABdhPJyQII7R+Y5oQbLYBA1CncYwd0yty2AZpKNCPwF5uuUmse8bR3aXhOBnz2p3bPejpDirMjdHgg==
X-Received: by 2002:a63:565f:: with SMTP id g31mr1131938pgm.164.1625167255127;
        Thu, 01 Jul 2021 12:20:55 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:f1f2])
        by smtp.gmail.com with ESMTPSA id w8sm607725pgf.81.2021.07.01.12.20.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jul 2021 12:20:54 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 4/9] bpf: Remember BTF of inner maps.
Date:   Thu,  1 Jul 2021 12:20:39 -0700
Message-Id: <20210701192044.78034-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

BTF is required for 'struct bpf_timer' to be recognized inside map value.
The bpf timers are supported inside inner maps.
Remember 'struct btf *' in inner_map_meta to make it available
to the verifier in the sequence:

struct bpf_map *inner_map = bpf_map_lookup_elem(&outer_map, ...);
if (inner_map)
    timer = bpf_map_lookup_elem(&inner_map, ...);

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/map_in_map.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 890dfe14e731..5cd8f5277279 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -3,6 +3,7 @@
  */
 #include <linux/slab.h>
 #include <linux/bpf.h>
+#include <linux/btf.h>
 
 #include "map_in_map.h"
 
@@ -51,6 +52,10 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	inner_map_meta->max_entries = inner_map->max_entries;
 	inner_map_meta->spin_lock_off = inner_map->spin_lock_off;
 	inner_map_meta->timer_off = inner_map->timer_off;
+	if (inner_map->btf) {
+		btf_get(inner_map->btf);
+		inner_map_meta->btf = inner_map->btf;
+	}
 
 	/* Misc members not needed in bpf_map_meta_equal() check. */
 	inner_map_meta->ops = inner_map->ops;
@@ -66,6 +71,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 
 void bpf_map_meta_free(struct bpf_map *map_meta)
 {
+	btf_put(map_meta->btf);
 	kfree(map_meta);
 }
 
-- 
2.30.2

