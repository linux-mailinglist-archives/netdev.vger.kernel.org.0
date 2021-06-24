Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F673B24F4
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFXC1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhFXC1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:27:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E79C061767;
        Wed, 23 Jun 2021 19:25:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g24so2564626pji.4;
        Wed, 23 Jun 2021 19:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gP6eoa6ljP3AuFuPQbTsl3f9RNFxlRZpcXxaVVr18i4=;
        b=edfU0iuwZvuM7anv27QhK5agSCmyGIDSvtN6qzbhf8d0CAB0U2F3jY+euhT7CZMHJ3
         FWbm0py4SfD8BexHIdMaa8leibJcQkAVHxs2iRKJuSrb8nHb/QC+e0i+lvZsJygV6Cvo
         JMjU4WrTh8MWH4SuhIX5T8ZmhNu2/dnFEi4nxaVKGVp2S9Fgc9P2xHR1v6QokBXtmSyR
         YYakDY72SwHI8I2pAtd8+J92WOKnpNsJ/f4Qi/yf4ehNtYHh+0giGulm2SuptvtGiZAl
         yA7kKisHQ00jlbmoFEVJwdk54rrB/9kBGAivHAPZ3jvLrABL21gY+MFKVsTJlC+bIpcM
         2VJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gP6eoa6ljP3AuFuPQbTsl3f9RNFxlRZpcXxaVVr18i4=;
        b=AaOGgABAdOmAX/Gz1Q8LkEi8rn0PSAL7eWavzYhMYtmKEJMfBfhEQuzEPep/drZoRn
         WQtTg9R0T6S8oKIwuB+Qkurn6MreQ+lQFEOs9a+t2Sdfr8wr7xvlS90HpaBk1thzfvhV
         K0zAOeoXNn2myPTxYc9cugOPiEvOg2pr33Clle7XOM17BAnfzB1Aq4OOvY+nREbyi2Js
         mV59fzVnEzgB7MtUH7QAIyuwlGIHE54FDFjtBgjv11HynLiGztFufE7ZTI+Ijw5qIHGh
         0hurk0eOdta9g111l26BEuDn5GpQBWibuFXlm9JjSKWHhMz7B/sbM6Rc/a7RvZNZKI3w
         lhpQ==
X-Gm-Message-State: AOAM531+TTwX7lcIhAKOJGQdoSaP+VNDWGpr/ueLsaZaicMgKVbVdBI7
        2F6bPl5gkxTLZztsRYcGOFY=
X-Google-Smtp-Source: ABdhPJzPfW6biR7jB4aOj6R4wR2byXVJxzutQwOqkF0UZ2UPx0CIWZe0LOUulPlA4V2/rDNV6zDaAw==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr2841509pjb.13.1624501526909;
        Wed, 23 Jun 2021 19:25:26 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:a319])
        by smtp.gmail.com with ESMTPSA id f17sm4675965pjj.21.2021.06.23.19.25.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:25:26 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 3/8] bpf: Remember BTF of inner maps.
Date:   Wed, 23 Jun 2021 19:25:13 -0700
Message-Id: <20210624022518.57875-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
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
---
 kernel/bpf/map_in_map.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 2f961b941159..d737cff90922 100644
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

