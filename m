Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBCB3BF375
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhGHBVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhGHBV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 21:21:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE04C061764;
        Wed,  7 Jul 2021 18:18:47 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 62so4251079pgf.1;
        Wed, 07 Jul 2021 18:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1CgQ/PnEyWs6JaL1Gp3My3DCnI1gq2qYMVWUFv4N6hc=;
        b=P+o9Ycjq0p2Yk/XWgJh/w35pOjco16RzbfAJlKaGH/AQTFr98zMfBfR+35N9Gb5JRL
         eTuJ5PK90vDbrpLpzwvy3fXSU9xADcabEv7qMOK5/rk7itXdRjinEJKIWbZ6ZLa71wiZ
         55KMbzFFqnFsBNSxPrp+NgbWy0Vu06/c6cZT/z8cqs5ASOhLnpbt0dPhsRBrWoQQOiby
         9AcqAC2VvosnEbfOz/lTjaF6UnkRKaVZLe6o13FT8vjFNgSweYSRrlHuRuno3UkvGlZe
         ki06W+qY+4wcvcf8PvVZimyeuDJqsZxLB652i6u6LsV8qGPHPjEL7wIDTiQfIHfD9Nr+
         vVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1CgQ/PnEyWs6JaL1Gp3My3DCnI1gq2qYMVWUFv4N6hc=;
        b=FcyrS3aPF/7fU+yFBodC97oA3qs/NRzShw2q/C4vrB0qFm+21LugULJk2vRu+335Py
         itDmZfSv0dNeeryqJ0jGONBQ2s81M9sxWzOkzX4fbvGIhXVE1/BTMLhH3olYT8X5nwsO
         66mKhU0RxL7my5iZyoQtZ9BUC9FlyNuQf4Iz5kSrfIKqxuSiiSjFw2eNDrvNtr6WGk6W
         XQEAVdcNA+Na9g+kcwPiTaVrks9obaUMgxZQ6UiwVGqfV3eNPD/zJ/af0JQO6G0NaCQP
         jZKvQtJbHTvxei/37IuWSyPvhm1t/mI5HU+ISMh3mxvJupQtOjZZCvMv4obOZxfmsJqE
         ehMw==
X-Gm-Message-State: AOAM532qj2cmt6qkiSqSNNyGxJ90FZf0b/EB7RDHruJF3EaGOoP4ol5i
        f2V7Sq/RjMGoWsPCweX6eK4=
X-Google-Smtp-Source: ABdhPJx79DorCpbv1xV5f2n7H5JfubHXXsrrpLyA3cGjY+9a1FvEK+m4bHU/z0xcimVualrAnxvcJw==
X-Received: by 2002:a63:1c20:: with SMTP id c32mr28865680pgc.41.1625707127526;
        Wed, 07 Jul 2021 18:18:47 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:9f4e])
        by smtp.gmail.com with ESMTPSA id d20sm417450pfn.219.2021.07.07.18.18.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jul 2021 18:18:47 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 06/11] bpf: Remember BTF of inner maps.
Date:   Wed,  7 Jul 2021 18:18:28 -0700
Message-Id: <20210708011833.67028-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
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

