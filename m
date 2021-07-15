Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15483C9553
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhGOA5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhGOA5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:57:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB57C06175F;
        Wed, 14 Jul 2021 17:54:32 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 21so3568906pfp.3;
        Wed, 14 Jul 2021 17:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FVHofXjsSn+YToG5Mlz3X8cSwYGdWIyhL0CMSeE/g7s=;
        b=Ly7vuIixfpgcQpooe+AoYSlZZsn0KkQxd6czKtFYQGhqOiGU0zuUVzDiD04g9vXgj/
         Nr4ZhM/T97oevhsYrwTDfyXA8/LLR/EnyMGlhrTU3Nkf68AnqEEq2qJW22zGqGIkvcs1
         NbIBPkzRl1BodwdKJBzRQxdw84LA+XZcpEplDhPJnIkju7avv5sNW8xrXsG3abSi9NnZ
         pCzHZwdjJqvAJRfwQdr9afKzpipCL5p+PNrWhRKpa6FtQEI0WDGOCYr1QLRvDFExEuAi
         +PCGpnJphjcJIE9nYlCPyDW4a5OY+ebdmnRk2OYkeZEki38t/96v4fmUXv9/mT3uUVTp
         QkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FVHofXjsSn+YToG5Mlz3X8cSwYGdWIyhL0CMSeE/g7s=;
        b=jy6s2DWILUm113m2Uh0pV3khL/YBdGJUZdDxQj5LtQi41X3GWQEzEIpN/0GpV2fAND
         c+Cj6kvYhzQNkV2x33nd04tK1G8apVfDs+yBTsqjaSdsDTeMGjfKaW6EZ/Ut1DKkauQn
         gcS+QsnpGtmqA+KkqVoyrBRYyvlTL9uYGaU0DcHz2cKYutT6sKefxX+G9EPYoYDcfXYk
         ljofct4BzAZ8+eQVw9Rm+QCi40Xeur9mMAPsH3u6wTICRYS95ZVJvgEVUynON3QWtv0Z
         lb3a+K/wak3bd7kFBNgl3EI/XUPPgiiVBcO677A/H3Cr6lu5gA8Z0uB3G/I/a81ERMCC
         WEmg==
X-Gm-Message-State: AOAM5303MX553TqlT7P7JQE/ViVEZ0RW3NDuXRidhRYiiIhCTbn1Xf6Z
        J7chfJxGCx0jBgnRxE/AHJQ=
X-Google-Smtp-Source: ABdhPJzbELTcrg/1dIokAZRVdMAhksOzogxTUW9oT3kfxIigXq6XRmpiVk5SxCzn+RRAJlRqdu67WQ==
X-Received: by 2002:a63:4c0e:: with SMTP id z14mr809635pga.427.1626310472277;
        Wed, 14 Jul 2021 17:54:32 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:120c])
        by smtp.gmail.com with ESMTPSA id nl2sm3439011pjb.10.2021.07.14.17.54.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jul 2021 17:54:31 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 bpf-next 06/11] bpf: Remember BTF of inner maps.
Date:   Wed, 14 Jul 2021 17:54:12 -0700
Message-Id: <20210715005417.78572-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
References: <20210715005417.78572-1-alexei.starovoitov@gmail.com>
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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

