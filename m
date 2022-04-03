Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFDB4F0A52
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359048AbiDCOpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359061AbiDCOpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:11 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06843981F;
        Sun,  3 Apr 2022 07:43:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id i10-20020a17090a2aca00b001ca56c9ab16so2450441pjg.1;
        Sun, 03 Apr 2022 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HK1eCo+mLyg/XwHakRoHzB489bRiG0WUI2kqqYfKxfI=;
        b=iOw6e84K4C8ZnEXtf2bHwuPAcdTJ/cpmEMfUAPJ1S9UlI6Coju+rBPEA9Los7Ij2gM
         Nt2AZeLK6LR67J6MYEc/pJtcUR/gyOgCwGuYgtxRFwkTi2CFYTYHsulaICx6sV3dj9jb
         4oyvTNAvgSGrvIyM5iqOXd14C3FeaalYb8heMv+EfPbr3d2ZTZ9xD7Zq2nIAMrBHVggf
         akAxs4VVIbvTW7nEAEas0FUalerILTP0+Q5hKWyb+llOFkEqLcrVvO7CokLHk6sSjJjZ
         E/CTfv4LiaNBBJmPnIe35PnvFV4In8c4OJo7oY96TGM5jQHgytI0GvxVvrsj1+fH2Vcw
         T/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HK1eCo+mLyg/XwHakRoHzB489bRiG0WUI2kqqYfKxfI=;
        b=RhPFmiL+OifzRq9VrFIaIkLU5rMyO8LN4jul/+XzBe5SkI1OUOKeuwc0KgQVej9nf0
         rgSbURedb9+VOXHDKpvgt1QfaE1unc4Ww7XCNPjwfiHbHR+DnRIxR6W/CJ4vvKPZGnIr
         IXbvgYLholAfmS0azTvtLRu5fpY1oQvRlDb7f/3oVccQpkEySJKb/uHF1I0g6vWTFq/K
         qLjo5RwODo32ndHDKfTeVzLjoT9tf0SauD+HMlam9EWSKr7V0RebRCu99y4aWzuyVNal
         ClTSBuwp6aRR3+iQnU37UFUQT20ae8w4BCNdLz1eX6delToQ7Jj58WjtLIUFQ5PP8Suo
         czIg==
X-Gm-Message-State: AOAM533kAuXBRWQ8NN2Jk5p8ElaqE/PYKdbXxYttcWko2zQlWFOe/zzH
        iVxVPN8I3zP2G3JzvDkEbYc=
X-Google-Smtp-Source: ABdhPJwOfaaNu1LoKq7NdT94IdbsccNTltJ7Gu2VDErAbpxv7RuVwbJdiAXOD4dgMBW6tLp5NNRZcw==
X-Received: by 2002:a17:902:d505:b0:154:76c2:f7bb with SMTP id b5-20020a170902d50500b0015476c2f7bbmr54682361plg.83.1648996995403;
        Sun, 03 Apr 2022 07:43:15 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:15 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 5/9] bpf: samples: Replace RLIMIT_MEMLOCK with LIBBPF_STRICT_ALL in xsk_fwd
Date:   Sun,  3 Apr 2022 14:42:56 +0000
Message-Id: <20220403144300.6707-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220403144300.6707-1-laoar.shao@gmail.com>
References: <20220403144300.6707-1-laoar.shao@gmail.com>
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

Avoid using the deprecated RLIMIT_MEMLOCK.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 samples/bpf/xsk_fwd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xsk_fwd.c b/samples/bpf/xsk_fwd.c
index 2220509588a0..2324e18ccc7e 100644
--- a/samples/bpf/xsk_fwd.c
+++ b/samples/bpf/xsk_fwd.c
@@ -10,7 +10,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <time.h>
@@ -131,7 +130,6 @@ static struct bpool *
 bpool_init(struct bpool_params *params,
 	   struct xsk_umem_config *umem_cfg)
 {
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	u64 n_slabs, n_slabs_reserved, n_buffers, n_buffers_reserved;
 	u64 slabs_size, slabs_reserved_size;
 	u64 buffers_size, buffers_reserved_size;
@@ -140,9 +138,8 @@ bpool_init(struct bpool_params *params,
 	u8 *p;
 	int status;
 
-	/* mmap prep. */
-	if (setrlimit(RLIMIT_MEMLOCK, &r))
-		return NULL;
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	/* bpool internals dimensioning. */
 	n_slabs = (params->n_buffers + params->n_buffers_per_slab - 1) /
-- 
2.17.1

