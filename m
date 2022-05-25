Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D1953357D
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbiEYCwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243710AbiEYCwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:52:31 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6CF46140
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:30 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id p63so2248241qkf.0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QIFYihfLoVNjGYO37YZAC90MNsOnmPZ04BsxoO1pbGA=;
        b=Jo8bOZAE2FEJJ62amfJVycIYsX/+E4BNr8IOExw+jeuaQsP8vZHamz867DShbpSDNW
         Tn0WDjaG/rB00k8+ro21wei9gC2LY+fmpEonwqArDiVT5pRgenIM7UR2aO1EvFMS2CZ8
         0SH8T6YbM7hCDgc0+ODUMcnW7GIesPjqTcmOQX83xL8J430WmcxgBoKcZ66HQ5tLWDE4
         BIqCxckGeSj3M0cg1OIhlCkGnNCMtc13cq4FmM4KItG9aFK6EF5nZokAqbXNPkeebXKQ
         pc4uJ1zLURmupgZb1stRGTYcMQJMXdQHWLhwrx5ozRsOKZ/+zpCQ9BI/9XuQ8u07Ty4G
         hJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QIFYihfLoVNjGYO37YZAC90MNsOnmPZ04BsxoO1pbGA=;
        b=NPr2PAJiphOxzQrS54koUj9H1UccA5gkO1wHCGnOyV2TTOgcYMaTuO8d7umQIIS0Zk
         FHPGxmQ9Lf5YMEVXUuX+ZxQj4gxfX83fuVNj+u2rsaiylrCkb/FJWkvnia607dlndt5P
         02yGlNcBQdUvx/H96P1qGF815pmDJp0euQkSiv5iApqPMhEhdwZ/XTPoFPX5R7CPR7L8
         Sjxcw9ooVUO5uEPXLSY10FfXXEnSTx8ZlBhEK8YMym0W/yKt6YDNunZABrtVwc36csxV
         co5Pxwtaqxk/tKm85v07hDQAbel2JRQL8LPbDaHT4Nvdq/UZNbuThN41cJn3guGaiI5r
         pF8A==
X-Gm-Message-State: AOAM533ho46bmNcnpUgVASA6ELRT5z1g6Lj+5FxXnkMCgB8hSS0G/JS7
        K3b77yVFnd5WNbgCFqTKhQ==
X-Google-Smtp-Source: ABdhPJwQOQlIegwRxUYtrRDCSv+XkbsCzUan0LIOsNTTC3PFWS1wtp2ByeZ43JFtnkThxDpW4iJY5w==
X-Received: by 2002:a05:620a:29cb:b0:6a0:9df:ab46 with SMTP id s11-20020a05620a29cb00b006a009dfab46mr19099112qkp.629.1653447149540;
        Tue, 24 May 2022 19:52:29 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id w71-20020a37624a000000b006a03cbb1323sm567403qkb.65.2022.05.24.19.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:52:29 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 3/7] ss: Do not call user_ent_hash_build() more than once
Date:   Tue, 24 May 2022 19:52:21 -0700
Message-Id: <546e9515257ecb00f09baea80ead5e9311c07f75.1653446538.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
References: <cover.1653446538.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

Call user_ent_hash_build() once after the getopt_long() loop if -p, -z
or -Z is used.

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 misc/ss.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index bccf01bb5efa..dd7b67a76255 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -596,13 +596,6 @@ static void user_ent_hash_build(void)
 	char *pid_context;
 	char *sock_context;
 	const char *no_ctx = "unavailable";
-	static int user_ent_hash_build_init;
-
-	/* If show_users & show_proc_ctx set only do this once */
-	if (user_ent_hash_build_init != 0)
-		return;
-
-	user_ent_hash_build_init = 1;
 
 	strlcpy(name, root, sizeof(name));
 
@@ -5509,7 +5502,6 @@ int main(int argc, char *argv[])
 			break;
 		case 'p':
 			show_users++;
-			user_ent_hash_build();
 			break;
 		case 'b':
 			show_options = 1;
@@ -5644,7 +5636,6 @@ int main(int argc, char *argv[])
 				exit(1);
 			}
 			show_proc_ctx++;
-			user_ent_hash_build();
 			break;
 		case 'N':
 			if (netns_switch(optarg))
@@ -5679,6 +5670,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (show_users || show_proc_ctx || show_sock_ctx)
+		user_ent_hash_build();
+
 	argc -= optind;
 	argv += optind;
 
-- 
2.20.1

