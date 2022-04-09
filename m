Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFC94FA7E3
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 15:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbiDINCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 09:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241797AbiDINC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 09:02:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3853A9FDF;
        Sat,  9 Apr 2022 06:00:18 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ll10so2579518pjb.5;
        Sat, 09 Apr 2022 06:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p5W0HLSh4kxqEqKp2k4JC+MHyJDV7uD5B6J5wpWqKsQ=;
        b=cAbL41Bcthg0onwuHVC3XtXSdY+3rMqIxOodkLU24AyMLkFNvhvmM6GbLARkWK3n10
         0fI+BpZ2I0C1prv/EiT4xDb+Vz/CC+VacqEftSZ74V2RNSsa6KKLF0kSbPwOS+PmV7Im
         JgNUTfRFkL2Tzvv6Dg/IafwOIW5pVAjQ3ae3OZUZKhlVNyTwe8CHGOm9wHDaRUfvSiwy
         ESFt4oxVqrSJgb+IfOjJ6KGLvI5qKPuT/csmbvevWqgbNE9npslwqJ73+AWNpOZgdy6y
         XVAVdi8rg7o+T6QiCV9lymWvPl5S/aM1TIap8Sq2h0YMh+4f4NfkruoSS9n/MXz79eMd
         at/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p5W0HLSh4kxqEqKp2k4JC+MHyJDV7uD5B6J5wpWqKsQ=;
        b=29xTqhdOt9ByY/Dw0LzDHEm1APN0HQTwKSA4Qd3tN5QBxSZkE/WPWM0MQ2ejVmhsy9
         YIIdFrDE44VQJZqFfyJv7eAgKkBcbeBcUOiuHtqzsCIxyXnjcAobkoFetG3/GnB1vu9I
         ZjthfX4zrZy1K5T4JqgswBUg03aDm4NTPmOR9pPCgeRrpNnCJXCBeGJ8NMW8gDIiprAb
         eY9YeLqQIu/LN2jnutFVEqYx0H6pzSnmOcTOEQodDbP2Pz1Lz6IVxpbP6WWFHXrgizJF
         c6HhD7Vl14c8SxPhEmi5xrCv8dT1Djv9Y7lJkCvD76oAyxb5VpVpsuZrmdn5kQjWgrZl
         4vyA==
X-Gm-Message-State: AOAM532ALkl5u+50wpjKWgJC/2TIRugyfX/J+QVt5GsIRCQTju89LWiU
        l7+xCCktj4MpUGXKr0uor1g=
X-Google-Smtp-Source: ABdhPJyb7yU2GQmQsRtNyWeScfVApF7nlOW73ZUGNntm+mrbzqqzx8NIiQuy8vNmd2CTLIkMTc8C7g==
X-Received: by 2002:a17:90a:b00f:b0:1c9:9205:433 with SMTP id x15-20020a17090ab00f00b001c992050433mr26570191pjq.116.1649509217084;
        Sat, 09 Apr 2022 06:00:17 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s10-20020a63a30a000000b003987eaef296sm24671871pge.44.2022.04.09.06.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:00:16 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v4 4/4] tools/runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
Date:   Sat,  9 Apr 2022 12:59:58 +0000
Message-Id: <20220409125958.92629-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220409125958.92629-1-laoar.shao@gmail.com>
References: <20220409125958.92629-1-laoar.shao@gmail.com>
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

