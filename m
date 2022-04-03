Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AC54F0A51
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359060AbiDCOpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359050AbiDCOpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:08 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4690396BE;
        Sun,  3 Apr 2022 07:43:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso1004258pju.1;
        Sun, 03 Apr 2022 07:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5CxbSxA/J1soVGI5URWZ3SJvoX16Jti84XlHml42gb0=;
        b=CGwtQuWXU/VwhcRt7NCPMRag0RxSznS6oEMmSlI/uZ30bVxa79K9LBvTXpeNLtW0Wl
         Dk5Y71QMfKxgkBdBJqVB1bgt7jIcd3+J9jXJYvSegnZqZZk/2adPP2WqyStW6Qm+Cg7I
         K7EydzJO2vBPBwvPsmb/X27d8SCwsJMvRwlTd/NK6+DNFqq6hseoAhc/Ql8Iykliap+t
         b8hZEH7JQKlumlK34TdbEbSp7srUj8BP3tTeQtit1Gb6ijTsbpTH2YlGSAz48Xo3P7FV
         blm8ii1fZHbgayNyM3LnCVgzujsBhpqblFojiFBnKXQcUre2LF0os4exMzGQtA3oFpZF
         oYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5CxbSxA/J1soVGI5URWZ3SJvoX16Jti84XlHml42gb0=;
        b=FWTz8LpOBtKwAdKNnmVaDsoRoXoBcK1BUWpvQP5FuGC/UEBhC0ZwI0n8vC2UYxfDTE
         QI+OruwSyt85yZRfIqISpnJPJioHlkOYD42P4lWcfTN9cZ//gsD5ij6QgZnVPJl4Sra2
         SQ+C/uHZkUL3Qcpe72x3/R1s9rsdguDAgkcWbGJkH9Qprf9rYTlksGISr79jBkY0H+cW
         puCioBRWEDIpaXjw/RXYd3ZokwolSSyCUR7nlpoX2EvEHE/6fwXZNXMLaYorSjeXyx2P
         IDyFKqe8JGjha5LLUBak0J/wVSY2NXOQqFjqLx5mTNtyWLxxlmXcEVbWUu2D3h1AEgbj
         Ro+Q==
X-Gm-Message-State: AOAM530Gf57YNC7NOZAL4QIIXzvK9wDU0sY6R5ZrDu+Cb4NUvr31t0ga
        0/u4pBkPw2JGBo4pXBBb9Dw=
X-Google-Smtp-Source: ABdhPJyZ3MeZYp7fgly/e9xEJIXa59fmV7ckCKAEZ4S5NEUtvnjv2F4NaPOLcRjF+RGKGF/LHJ2peA==
X-Received: by 2002:a17:90a:8581:b0:1b2:7541:af6c with SMTP id m1-20020a17090a858100b001b27541af6cmr21633631pjn.48.1648996994414;
        Sun, 03 Apr 2022 07:43:14 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:13 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 4/9] bpf: samples: Replace RLIMIT_MEMLOCK with LIBBPF_STRICT_ALL in xdpsock_user
Date:   Sun,  3 Apr 2022 14:42:55 +0000
Message-Id: <20220403144300.6707-5-laoar.shao@gmail.com>
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
 samples/bpf/xdpsock_user.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 6f3fe30ad283..be7d2572e3e6 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -25,7 +25,6 @@
 #include <string.h>
 #include <sys/capability.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <sys/un.h>
@@ -1886,7 +1885,6 @@ int main(int argc, char **argv)
 {
 	struct __user_cap_header_struct hdr = { _LINUX_CAPABILITY_VERSION_3, 0 };
 	struct __user_cap_data_struct data[2] = { { 0 } };
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	bool rx = false, tx = false;
 	struct sched_param schparam;
 	struct xsk_umem_info *umem;
@@ -1917,11 +1915,8 @@ int main(int argc, char **argv)
 				data[1].effective, data[1].inheritable, data[1].permitted);
 		}
 	} else {
-		if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-			fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
-				strerror(errno));
-			exit(EXIT_FAILURE);
-		}
+		/* Use libbpf 1.0 API mode */
+		libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 		if (opt_num_xsks > 1)
 			load_xdp_program(argv, &obj);
-- 
2.17.1

