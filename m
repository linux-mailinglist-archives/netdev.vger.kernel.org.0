Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7309552411F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349401AbiEKXiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349398AbiEKXiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:19 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB559179435
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 7so3070283pga.12
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qvDoj7L5lsRvMJV9dNuhFJcDkWTXkUCEAxq9FkhBxoE=;
        b=dLqqLlbpP1BUjwQbwxlxD0tertYzS9jU7ovSYsdKpPUzQ2XZQlHPwueeY1I8mUAUjr
         hpT3LCoXM0fnwNklUnxhE6wZiBX7zmPgrJZ3rrjWIF02L820WO7/mQ/Yuko9qIvNamvb
         DuZnUUkkdPws1aSg7zsEs59cUkGprlFxLkmMoHoMSCTJAlBt2r9vGLSERMAZtuOLgmYv
         AUcB1HGNP/D3KnI+ziiuJuYpdNZPbXXoxW1hKDL5jp7jmcP9PFgYUzDiOO9IGjnmdCqx
         M8DEpimTWmFSl0p2/oPVcOz2bXagv9+05e8sqDGYuCfqn5b2Mys3bC/FaWro7bugmi79
         mMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qvDoj7L5lsRvMJV9dNuhFJcDkWTXkUCEAxq9FkhBxoE=;
        b=3UdY+I3765VJqOuVYo0Q5ms7jw9xz5JJZkuwj4iVYxzzK+ha1E6K8PaTV89JePutBO
         z5TaTGxRfAViDGjI3AOVr5TwMeApRXrpB2rNFBL1Faiq2AKG8h/3ZUOVtK/VCzxPCdG2
         bIHtqj9VGw8e2GW8X+VmTHzJXclMqaeaF+TgqmIYWy+Kj2QXcya7LhOQUxYNFZYnKzm+
         8SPzg0UiQQkJkd5un4vF/7FBQFWGKDTcmL0cmVaTFcTK/2ejCbtwKTNobsy4I66jam29
         w2oaiNeixx4SzG8+k+V3WN8Hm2u5Yg2nynpMK20/c6oO4bqMbXd3oaXih3TpPuT9GTZH
         o6Xw==
X-Gm-Message-State: AOAM530hMMbBZ2eH5B6DTmeOEDu9s9es2zaD8oVmSzLezsgwaKbRlQSy
        H10YyOQIBIIxPYTPMO0YiCk=
X-Google-Smtp-Source: ABdhPJyls1WrIhsg4wNuvKRY1B2g59jXxiYvClGLKiGTxNGbRZ/RusrST/Vrmbr+1R3jxQo4q8778Q==
X-Received: by 2002:a05:6a00:4197:b0:510:671d:709c with SMTP id ca23-20020a056a00419700b00510671d709cmr26948854pfb.61.1652312291242;
        Wed, 11 May 2022 16:38:11 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:10 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 06/10] inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
Date:   Wed, 11 May 2022 16:37:53 -0700
Message-Id: <20220511233757.2001218-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220511233757.2001218-1-eric.dumazet@gmail.com>
References: <20220511233757.2001218-1-eric.dumazet@gmail.com>
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

inet_csk_bind_conflict() can access sk->sk_bound_dev_if for
unlocked sockets.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/inet_connection_sock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e5b53c2bb2670fc90b789e853458f5c86a00c27..53f5f956d9485df5cb863c8287c1fa9989bb29c9 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -155,10 +155,14 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 	 */
 
 	sk_for_each_bound(sk2, &tb->owners) {
-		if (sk != sk2 &&
-		    (!sk->sk_bound_dev_if ||
-		     !sk2->sk_bound_dev_if ||
-		     sk->sk_bound_dev_if == sk2->sk_bound_dev_if)) {
+		int bound_dev_if2;
+
+		if (sk == sk2)
+			continue;
+		bound_dev_if2 = READ_ONCE(sk2->sk_bound_dev_if);
+		if ((!sk->sk_bound_dev_if ||
+		     !bound_dev_if2 ||
+		     sk->sk_bound_dev_if == bound_dev_if2)) {
 			if (reuse && sk2->sk_reuse &&
 			    sk2->sk_state != TCP_LISTEN) {
 				if ((!relax ||
-- 
2.36.0.512.ge40c2bad7a-goog

