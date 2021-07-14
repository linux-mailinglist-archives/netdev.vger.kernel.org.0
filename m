Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55AB3C7AD6
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhGNBIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhGNBIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:08:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2838C0613DD;
        Tue, 13 Jul 2021 18:05:33 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t9so318314pgn.4;
        Tue, 13 Jul 2021 18:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nsh0AS3OcdVrubNX9rYe3X2dfuQPi9s1kICXW8jXMeA=;
        b=H5dQBw+X60DcdfzpH1LdDkx0b7V3tGQHCFmkyOzdAJb43csV3Sfn1w0yoKXiClQabe
         MO03qRl2LFUf9NJDy13jQIkBEaayhL4LPOqNLGHI71xHvf4K2ZboD2ASvSFtH8ioMwea
         fjfdTEwm4lpmU1wE/nCctYGnREM8D1KnGVpf2B5l8A2n4F53dmGXJa0IsvuP/MIcF8vk
         g5xpAqNmL7TT26+yDSN6PfoqvT02Hs+Fp7Oy9jIGo25fuxumvlfTzEQIXy1lAVuDMKd+
         WctRTOQljmRZcJM9boZ60o/6un0yillQuXgTjSQEVRr0H0z8fMt8PLHJUYXgH8ye+FLv
         IA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nsh0AS3OcdVrubNX9rYe3X2dfuQPi9s1kICXW8jXMeA=;
        b=ostg2hSELmjjH9kRZNi7QXye9aw9S1zz52zqdUawZtD8XP1DSRGsWT9hS7osJfqrjT
         0N0N2nCbpk1e+6gw1SbMf1Ab2mKGydEh9psQYjgBtWbVLaZ/KQhuKC0qCZB1H/2zmSvu
         p3FVsBlIY7jyA3lW64lVQHc2nnCto/eeVJw/h4iaKOyNSKwOF7yyRTrcFVmP2CV/mYAm
         uA1BtU240NhuwWBil3whnxs5FwYMpSlrSPx4auW/4pxEPyjhWYZKEGY0MGCOb393vdZW
         7PFIdjKuLgJku1HAZ27gLRh9rjq2chrVzN4NSh8x5Jtey5zxVyN5fr8jASEouX8c4bJ3
         ttBg==
X-Gm-Message-State: AOAM532C4p6X7P2qMOsjQfofqm3zjfw39dO+/cQVJ8UUjaShuGrBXcOc
        4JAFSQF7caq89COIRWI+JGCHHn8852s=
X-Google-Smtp-Source: ABdhPJyaJ7o9bdnKT5FfhywUD3wgBa7NAxKXOR9NlXZt49+nRKdsNpWYhxQwMncM08EhidYDnMAA1A==
X-Received: by 2002:a65:4009:: with SMTP id f9mr6845936pgp.148.1626224733494;
        Tue, 13 Jul 2021 18:05:33 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:10f1])
        by smtp.gmail.com with ESMTPSA id cx4sm4073560pjb.53.2021.07.13.18.05.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 18:05:32 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 bpf-next 06/11] bpf: Remember BTF of inner maps.
Date:   Tue, 13 Jul 2021 18:05:14 -0700
Message-Id: <20210714010519.37922-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
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
Acked-by: Martin KaFai Lau <kafai@fb.com>
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

