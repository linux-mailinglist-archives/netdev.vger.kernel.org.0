Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5966C54385D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbiFHQFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiFHQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AA927F477
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:49 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so18696627pjb.3
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f6j9GBN0w5grHc+ifaZiPx7VIaBCMhY99fjc3Bz/5zI=;
        b=hk2j4KT4epHlqbZHiLJkBlPuG//+NAA3DEVO2L3G2Nbovsc0c7q/MAg4E1vvL5ra79
         Hor/ExkYq6GlMJVLGK/mAhuL84IXJnutfr6MwwuDfk8AlgAOSQ4T6ZP+QFz/tE1nLqcB
         ZtTBp1d73ayVc+8Gq9oLhwRVjZ1LnopXIHUN1oRMHRbaXC7XFLFwfckVktGto7BgyHT0
         PYC4ljS2ziRk0yqjkx02y5UWE5Fy+5pobXu5arEQ8lUcGWZckAVWAg4fK8boyDI3c6C0
         HalAL4x0tA2eVNPfciBD38X3z8W5VfkVdFWleJavCjG7bY53dOwvxGq1OaevrzpzH1sJ
         Lp2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6j9GBN0w5grHc+ifaZiPx7VIaBCMhY99fjc3Bz/5zI=;
        b=usV6667CYB79pFMXG834MykTZtJyfMSytneL1XLJw4d8TIxfjAKWqEXyh4N1XXGwlZ
         oyh11gztKIzS6IoQ27YJroTDc1/fs9UCJ0CIRNclvMPRSowBsWTzKkv/cbs9hMLQUFeL
         i8kXmSkpYrfzsoa0SGd7sVEpnPeghVUkCbQ/wDtSFyQ+G1EHILhnqAKob3Apt6OTkPQp
         YvpPZVhXEjyODcDwl8xjY5tL12Ao3LPgwKl20RP7S793/ixsLY3CEfsRdR4GYcOtEEz6
         xkzhQJfnIlBGxhh+SAXsVKMdrftpLO41ehuplCaUbPe2wqXIu6PGdWhzRKtcHPuU0Ys8
         ZF0Q==
X-Gm-Message-State: AOAM532+ubp5QoSdVMW/0M/hEChg4cJCx/9mo/IqiA8eqAzn/7Rj41VU
        /oLyXAotvubDIBwrCfEdiW4=
X-Google-Smtp-Source: ABdhPJz9ugGBaT2B0AolRRXP7XbcnUsfibp0pIgkkrZHMH/AQXafpKLHRIwH6Oz4oTB26ymyPARe+g==
X-Received: by 2002:a17:903:246:b0:153:84fe:a9b0 with SMTP id j6-20020a170903024600b0015384fea9b0mr34644464plh.163.1654704288504;
        Wed, 08 Jun 2022 09:04:48 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:48 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 5/8] af_unix: use DEBUG_NET_WARN_ON_ONCE()
Date:   Wed,  8 Jun 2022 09:04:35 -0700
Message-Id: <20220608160438.1342569-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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

Replace four WARN_ON() that have not triggered recently
with DEBUG_NET_WARN_ON_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/unix/af_unix.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 654dcef7cfb3849463be9d905ae625319fbae406..ae254195aac87f196a93853443048b40e332cc60 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -302,7 +302,7 @@ static void __unix_remove_socket(struct sock *sk)
 
 static void __unix_insert_socket(struct sock *sk)
 {
-	WARN_ON(!sk_unhashed(sk));
+	DEBUG_NET_WARN_ON_ONCE(!sk_unhashed(sk));
 	sk_add_node(sk, &unix_socket_table[sk->sk_hash]);
 }
 
@@ -554,9 +554,9 @@ static void unix_sock_destructor(struct sock *sk)
 		u->oob_skb = NULL;
 	}
 #endif
-	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
-	WARN_ON(!sk_unhashed(sk));
-	WARN_ON(sk->sk_socket);
+	DEBUG_NET_WARN_ON_ONCE(refcount_read(&sk->sk_wmem_alloc));
+	DEBUG_NET_WARN_ON_ONCE(!sk_unhashed(sk));
+	DEBUG_NET_WARN_ON_ONCE(sk->sk_socket);
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		pr_info("Attempt to release alive unix socket: %p\n", sk);
 		return;
-- 
2.36.1.255.ge46751e96f-goog

