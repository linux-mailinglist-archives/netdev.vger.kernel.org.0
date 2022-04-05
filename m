Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B334F4008
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387149AbiDEOaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240077AbiDEOW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:22:57 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89966C967;
        Tue,  5 Apr 2022 06:09:46 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h24so7712978pfo.6;
        Tue, 05 Apr 2022 06:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sMIpx83GHhT55vWRzyGcSd/gtnARLdSoACmZjUU1YlM=;
        b=hl1zkMOqf3L3sitfXM6rSuSZ30Mypk+Qa0y1D5a2lrdWkmUmlKYCaZSabJ4WWkjK75
         cMFJB83+XP0iqhjJGZTWwE0DAL8Pz1shMcyvykGDaoYSI7rMep8bgsM6hGeQz42Fgymf
         qXyrNNtm5+43FgLF4qwbFVYEUWjQLDnhf7LCzE0K9tUvWp2VL++T+Js/0aQmJgC2SuLn
         whxe3EtfpbDIqTxGhC9ffvxfbiaIDmjmJ3LAHomwswbik/wYfxjtHqBGqNVLzPtDm7zs
         Col7ph3wZczlX1zA9kC4FVJHRttb+STysd5lV0eT7k43AIT03NYYjUzErcTwZCimdgrh
         aRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sMIpx83GHhT55vWRzyGcSd/gtnARLdSoACmZjUU1YlM=;
        b=7HjAC+2uZo84PYpSASd1E1wg/LxM8GH290EQglyW9BLgpMyFA44VjzJ6fElUJ+x49Q
         F1+Xp7kxzOh0EHgfNDhgMGsvYyrMgqfVEIKzOv5nue2BY7pD+s72bmWo+V0353WO5Ojb
         jvE6/5f0Yb479qeuqIuDN+aN1PRubBGofWkEyUsGPVjPoRuWcELtb9weAevxQcxNXjxG
         HWPGPpMmezZnSJHjpQJxYBfEwn7u5q4/QPZM6ZQyWg+xAxyIChGucXKrkOdvjMiJEcHz
         xYuBUYF4n9yWY0t3PPnJByLVcf0ITUdzEImH0WpzxaTyn/S888YZXxt5eGFAXcIZxrKF
         ttYw==
X-Gm-Message-State: AOAM533FelBAk8npNCkn9620esSb2+lSfat3a/i436A4rTxIgsNE/QDW
        YRAScJzBJSTKTRAu1DL6kSg=
X-Google-Smtp-Source: ABdhPJyJ78hUGpcOeI9jmAiFxoJCiAIG2eCb3kckAVwgytM3dFeXks5r7/UrwVZCaYgtJcMViz6qLg==
X-Received: by 2002:a63:d314:0:b0:399:53e4:2bfd with SMTP id b20-20020a63d314000000b0039953e42bfdmr2854578pgg.120.1649164185881;
        Tue, 05 Apr 2022 06:09:45 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:45 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 22/27] bpf: samples: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in xsk_fwd
Date:   Tue,  5 Apr 2022 13:08:53 +0000
Message-Id: <20220405130858.12165-23-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
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

Explicitly set libbpf 1.0 API mode, then we can avoid using the deprecated
RLIMIT_MEMLOCK.

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

