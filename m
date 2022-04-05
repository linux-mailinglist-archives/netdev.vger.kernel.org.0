Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CDE4F4074
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387223AbiDEOav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345397AbiDEOXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:23:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9371B6EB09;
        Tue,  5 Apr 2022 06:09:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b15so12046178pfm.5;
        Tue, 05 Apr 2022 06:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5W0HLSh4kxqEqKp2k4JC+MHyJDV7uD5B6J5wpWqKsQ=;
        b=IUrZgFVxLvUPKV9t6MtsKjNwVW68RgltIuuuX/CtEngtGPzi6LibkcCu8EnM4BaOcG
         Kk4CQqMrNx2hIaj+GQiQyVZPlBpGvBl8wDts2N+EpsWfR//91R1dbFchUFHSnXTNrwBE
         Pg4XJJUVxyciMRFFDcpfU9uGTg3uAy1VSMXAKYSAUaWZvAc4p8ckVtrQZ8SSDVK8afoX
         Hs0mN/b2oM/AxPQ/4+bVsdkamX+UNJbECTTFWZctktcFzNGvAtQY81Ifrf7T/wFgRJ5Q
         cZoYemtVF0R7y9bbxw8ugWN4PwI8HP/wzMmvd0/VywfN8lYw310/9GC323eZFVoBSQ+K
         /09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5W0HLSh4kxqEqKp2k4JC+MHyJDV7uD5B6J5wpWqKsQ=;
        b=e5WimeB7xezHKPyS8burIIwG86JqyqyKchneR42UuChsCETWLYUyrtSmxnnGPgMWAx
         Di4utADKQRm1LMAnfoZnfvt/7pUyI2EMhq9GfxeJtMjxPM39S1rdE1Qdd0MXTR6Ux0R5
         G4ib4RbHDtmnjexG1oDC8MDQmzyyIRz9IRyKcE4wkLMOPOj6ssesxYeVkMuMCvcDQJjt
         ye8omh1B8hyQpL42wa44cNMvAyltbF4l3uQHGjBY7MFVZwaBC1r7aa3lfDPIOPON7Por
         F4ZuO5t8mwnQoLR4eSR3XQR4aKHpt7fi2Svo1KEtGdl6W1d1hDTvVPVadKnXJk5ygdvq
         jnXA==
X-Gm-Message-State: AOAM531w6KMFmg+ArBxU5kDQROnUozQYWdR8/q+RcH1DANXMxiPcnUKG
        kGh/BCw/s8FhmBavVJMvaMQ=
X-Google-Smtp-Source: ABdhPJzkThtzZC3V01k4BfUs/xUspZwDN3SdLfsy8x3gKseNaIL0SJXHA89TvdcN4iWr31ahrKSRsg==
X-Received: by 2002:a63:df4a:0:b0:399:460d:2da with SMTP id h10-20020a63df4a000000b00399460d02damr2769002pgj.315.1649164191900;
        Tue, 05 Apr 2022 06:09:51 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:51 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 27/27] bpf: runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
Date:   Tue,  5 Apr 2022 13:08:58 +0000
Message-Id: <20220405130858.12165-28-laoar.shao@gmail.com>
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
 tools/bpf/runqslower/runqslower.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/tools/bpf/runqslower/runqslower.c b/tools/bpf/runqslower/runqslower.c
index d78f4148597f..83c5993a139a 100644
--- a/tools/bpf/runqslower/runqslower.c
+++ b/tools/bpf/runqslower/runqslower.c
@@ -4,7 +4,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <sys/resource.h>
 #include <time.h>
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
@@ -88,16 +87,6 @@ int libbpf_print_fn(enum libbpf_print_level level,
 	return vfprintf(stderr, format, args);
 }
 
-static int bump_memlock_rlimit(void)
-{
-	struct rlimit rlim_new = {
-		.rlim_cur	= RLIM_INFINITY,
-		.rlim_max	= RLIM_INFINITY,
-	};
-
-	return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-}
-
 void handle_event(void *ctx, int cpu, void *data, __u32 data_sz)
 {
 	const struct runq_event *e = data;
@@ -133,11 +122,8 @@ int main(int argc, char **argv)
 
 	libbpf_set_print(libbpf_print_fn);
 
-	err = bump_memlock_rlimit();
-	if (err) {
-		fprintf(stderr, "failed to increase rlimit: %d", err);
-		return 1;
-	}
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	obj = runqslower_bpf__open();
 	if (!obj) {
-- 
2.17.1

