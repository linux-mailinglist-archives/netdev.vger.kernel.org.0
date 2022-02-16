Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198254B8EF8
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiBPRST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:18:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiBPRSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:18:18 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B2DBECDA
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:18:06 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i6so2652176pfc.9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NJWCySHP56arW/R9ReEej6WlDEdQoMS3aBy27/5bsD0=;
        b=ghzSTn4mWlKzn5Mwlz6D+kECg36+jqmABX6LtHmwha1X3u19fQCwGeK9jsq9i3XBsk
         EBfaVIo9l4lCuc3B4H3ANoV/wws09Wg1bxVeyPWftMIjP5OHsFe1LJlru6rc/IzqvjMS
         Tbed8K4IGKyFjetMNQPLylBNVOYtG3Erz0nxKUwr4QWLswtm7aetKvhtk2KELDuAwLOh
         Yi5XEP0T80v1TJa6WbtHubkiVcxNLUsouD/4VqBmUUh5DVbXTl7e/hDl10xGZTNBG5Wc
         8UnC8gl6GV5yxJ2SV9YFp/jBE3Eu6r6KpIQy2GTkjHu7dYcPO103BNjVsDbtYumWmK57
         rZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NJWCySHP56arW/R9ReEej6WlDEdQoMS3aBy27/5bsD0=;
        b=TRKwcCHvpnsuvC2/AIeDL/R8oosdn+9Wc5EzE/q4Hpn7PZs5b/BaJZq0kQ10I4I1et
         7EgZz/XrN7CHIDzvrUvx6ayBql7+9ojDCZxkehMXHfVoSU+yfzLLLAuVZISZnUAUeVZg
         qcic/SIspdAkqps/SwQV6wYy25VOxUpC3zLfvAVNwKMoKgA2w3y87XgJUDXjTSOqFS5b
         hbXe11PySuX4UPJVeRDIzy7h87Fcl+b9FEs9sVdrZb9g2aGd4yyj8NuahKgyNlCLDYNY
         2wLKPNn30heZwDqvmsfm6bbujpeJWhvMA/uWIj9ObZUNWHp+/FO3kRn8bib67Wors1Zh
         MrAA==
X-Gm-Message-State: AOAM530LUMF+7PaUNb+99Zn1BUkL0KEPOvwHZYx17Uye9KZW6L/PfvPu
        HAz5L+F4r8BJN4Zpl2ba75g=
X-Google-Smtp-Source: ABdhPJzJkbUOUv8uD9T9R6IUKlR4DifXFnAYNjXmhCS85ifRzuYdQxazwkMivZqXLydzB9LtUIZucQ==
X-Received: by 2002:a63:2d6:0:b0:342:b7e5:a7f1 with SMTP id 205-20020a6302d6000000b00342b7e5a7f1mr3057649pgc.591.1645031885944;
        Wed, 16 Feb 2022 09:18:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b2d6:3f21:5f47:8e5a])
        by smtp.gmail.com with ESMTPSA id 68sm298559pgh.2.2022.02.16.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 09:18:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: add sanity check in proto_register()
Date:   Wed, 16 Feb 2022 09:18:01 -0800
Message-Id: <20220216171801.3604366-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

From: Eric Dumazet <edumazet@google.com>

prot->memory_allocated should only be set if prot->sysctl_mem
is also set.

This is a followup of commit 25206111512d ("crypto: af_alg - get
rid of alg_memory_allocated").

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 09d31a7dc68f88af42f75f3f445818fe273b04fb..d76218ab4999922879401262ba873b62aff943a0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3718,6 +3718,10 @@ int proto_register(struct proto *prot, int alloc_slab)
 {
 	int ret = -ENOBUFS;
 
+	if (prot->memory_allocated && !prot->sysctl_mem) {
+		pr_err("%s: missing sysctl_mem\n", prot->name);
+		return -EINVAL;
+	}
 	if (alloc_slab) {
 		prot->slab = kmem_cache_create_usercopy(prot->name,
 					prot->obj_size, 0,
-- 
2.35.1.265.g69c8d7142f-goog

