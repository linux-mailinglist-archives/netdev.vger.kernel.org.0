Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323DD272368
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIUMNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIUMNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B3CC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d4so11896609wmd.5
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+vyryLmkPcir5gGX7IxM9tzcLD9cCThO7+XXSg/AftU=;
        b=nVYvS9pRuUcZ77st4OjUMgypY2LMph8l0ypZo8J4/rsj7gGO2w21SZ7oABfuIRcF6L
         MEZwA6oqRj8Pz+v2+JcaEatwcA5OZdyxGWSr+WlxAGOsTu6x4sZGxoHEXu/m8jO7P8KT
         Uy7s86K2W75zjKIuQEyJb1YAttluhCF6gyx/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vyryLmkPcir5gGX7IxM9tzcLD9cCThO7+XXSg/AftU=;
        b=qiaL0JjYByG5ofOBq1/JXT6VhcnfJEWbfipI6ioMkHbVR2K+uJCv9qdtYQl9F/5LY5
         n/1dKpde4NRKoGWsyrZ9rUcAXfsVzEVENsYESgd824imhebt58SIv0YGXbMyQgY+0cM3
         WbSRW9EvMY385YqpBrX8xHRrtl879ngdiHNApX7k/ai4eN8DpPAyxWKMXuk8MYERAI8p
         pOIp1VAbL6OV1xHIVkMJGZZrdWceDncASYAomuPQDuvdDEQFxaVDW5xrURW4l8h89CeX
         1FnnAgcV9WVVOYGGAQfJ0HzJy+Fk3PEJVEEEGqiCUzs/k025N/4QWBk5//O+ugvlFOcX
         NLxQ==
X-Gm-Message-State: AOAM531m+jVE3In/8EvH1G4Lmc4axTh1WKJBzBdnC9BjH5Wex1LSqPYe
        pgv8Va4sw2tnKcusmgMEgmi0LA==
X-Google-Smtp-Source: ABdhPJwJKMyaohhIsUwmbvcHOyNrD3vMO+xgFeVXNCv9nOcvSiBRSrSRLyZZxxFO60HvaoPoAGZGCg==
X-Received: by 2002:a1c:4886:: with SMTP id v128mr30531141wma.139.1600690396155;
        Mon, 21 Sep 2020 05:13:16 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:15 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v4 01/11] btf: make btf_set_contains take a const pointer
Date:   Mon, 21 Sep 2020 13:12:17 +0100
Message-Id: <20200921121227.255763-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bsearch doesn't modify the contents of the array, so we can take a const pointer.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h | 2 +-
 kernel/bpf/btf.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5dcce0364634..4cbf92f5ecdb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1901,6 +1901,6 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
 struct btf_id_set;
-bool btf_id_set_contains(struct btf_id_set *set, u32 id);
+bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
 
 #endif /* _LINUX_BPF_H */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f9ac6935ab3c..a2330f6fe2e6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4772,7 +4772,7 @@ static int btf_id_cmp_func(const void *a, const void *b)
 	return *pa - *pb;
 }
 
-bool btf_id_set_contains(struct btf_id_set *set, u32 id)
+bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 {
 	return bsearch(&id, set->ids, set->cnt, sizeof(u32), btf_id_cmp_func) != NULL;
 }
-- 
2.25.1

