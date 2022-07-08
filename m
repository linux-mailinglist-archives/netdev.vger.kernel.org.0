Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7423956BEC1
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiGHQ3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239120AbiGHQ3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:29:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D4B7E018
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:29:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j2-20020a2597c2000000b0064b3e54191aso16596436ybo.20
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 09:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6bgZe//DlxPmeNsWv8U8hnyAHoM/S0ajxM1bWxop6fY=;
        b=mal+0w2dpgaMwf/mp26eTo4ZpQJAmFGKZ+bOQjQTy9vc6GCItO4381laNfabIxM498
         nNXTvT4FT1R6i6SvvvNQvI8xaV5GtkN0emFBFUlYGmqnbz6b4VWTrTuDJOYhCYZNGlWI
         e/TFzZK5CWfbG9eNepqPjRoh1M5X//5cUUhhzRs8yyI7eWDaKfy0tGCf5GX6XTPRVj4J
         OO3QcjOrZXiE1WehQWvAjRNl2V1mSizuDuzOyJAkHKNscZmLlcrAQK4vkcuTFDjerZTi
         M+/0nsWOY2rtS74sk48YXiaFCXDE5WSZpnDtS8wezwBmENdM8IRcD15VM+YFLezZSvHo
         qjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6bgZe//DlxPmeNsWv8U8hnyAHoM/S0ajxM1bWxop6fY=;
        b=d1a3GVA7YCglaOLAOaiOGjr+/uTUuhJtSwG/2Pq59KucdjGcAYP8JCsdICZL+qvJAt
         MCe2uOWIoj9+WwqsHYOJplRq868MtcMLiCMpq5iNGN466uzXxAfl85BPuHQxUMFCxCaE
         bb3LdVGfzFR/pa3ZM0bHljMomqxQ3bE3YtBvyLuxgmh56cr0qvQTx+wfKDJ+agfq/P2x
         iyB1tZ+pSf7zgCHGvI/pMOjhhLUfFKk9t9TpfGbZj3SFECqh5/FABWGg7ZAVGxDq+8Un
         RaDBPRJ+n8ShVwKO3PENenqjKDTkW2rT5gBXfXU7lidi8C+l0uPpzLl0a3Eh+Ltfp59M
         kY1Q==
X-Gm-Message-State: AJIora+6DwuT85fQz1Cd0i3gvXrvZWar4arXZmqYzyf/kwFK0wWKmp5j
        UioxrtzSn8vR0D7HaQeQFazxzzg2o+sl4w==
X-Google-Smtp-Source: AGRyM1vozljnvfawrKsztWllKvbb/WbV1QY7ZhgRUDwAypkUDK5YhjXKOKk2hSxJRXISch52V4NV17QvBaaGLg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:c206:0:b0:664:7368:f14d with SMTP id
 s6-20020a25c206000000b006647368f14dmr4723497ybf.619.1657297739800; Fri, 08
 Jul 2022 09:28:59 -0700 (PDT)
Date:   Fri,  8 Jul 2022 16:28:58 +0000
Message-Id: <20220708162858.1955086-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net] af_unix: fix unix_sysctl_register() error path
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to kfree(table) if @table has been kmalloced,
ie for non initial network namespace.

Fixes: 849d5aa3a1d8 ("af_unix: Do not call kmemdup() for init_net's sysctl table.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/unix/sysctl_net_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 3f1fdffd6092c6d06d4f530d813ffcc1b02f3ee4..500129aa710c73537cde5208a48e75842259ee04 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -43,7 +43,7 @@ int __net_init unix_sysctl_register(struct net *net)
 	return 0;
 
 err_reg:
-	if (net_eq(net, &init_net))
+	if (!net_eq(net, &init_net))
 		kfree(table);
 err_alloc:
 	return -ENOMEM;
-- 
2.37.0.rc0.161.g10f37bed90-goog

