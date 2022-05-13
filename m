Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF805269A6
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383444AbiEMS4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383454AbiEMS4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B38E6B7F6
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:03 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p12so8492441pfn.0
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A19XDJDBYsixko11EpPg6VqehJxYk2XrmEZVWrbhfVk=;
        b=gBrPj/tZbX/3GK5iRqyczckOTmNGHak2YxDw3OeWDRhPZgVQUNy72l33XAmlO7Y1NY
         xycLKoxfXLtzglmE8YaaTK+pOQwVPGJGpb4K7JRsx+Z8G1K0jbdrhtO82mCwQdK3Lzap
         N0pA7As2f1XkE7Cb1b5KEEy2epUGbz9OXRK4dTRGEc7TgJtSyjgrRQRYtuzYP8nsQuS9
         OrL9+IEX8dLzfA8/88VeSd56KowEqLaroeGk8hQOz9c4+BnwUQdkaslOxP8xKa7itYj0
         MV/i/HODdDvEmj7S4iowaEa3N8xRVYAGCyAwTrxGvUrjt/L08RtVdcqDq48t+YfA1ScB
         ucvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A19XDJDBYsixko11EpPg6VqehJxYk2XrmEZVWrbhfVk=;
        b=w7Y0k5TmKtjSmHBEPptQ5vsj3C+I5qrMb5/3twRTHbm+dnxgzGqmq3u7JPSibEKRSp
         Ua1QoCkXSLLQVR2aaV908SV9aKXEzPyFqmx2FlTF8xM1n1grvQdrj5g2PKv/MDQxVkzD
         4X2vR0xfhWBRP5hPgW25+ZLlf1GNJbEFoeDgZ03X4pwcf4j4OQ6Z6s4h+1smBmj9a72n
         98+CNHUUDJLysBY27GQYS/lU4JCHRc0OYgz+NDM8rEuFTQ7hc6PbAprYAebWdiuh9z70
         u3VOX/IKXProQR5nEblmvIYr6bN6e5sqyyhY90yj6dVIPX/X0KOwb/lPpFe4dVcZriue
         OjpQ==
X-Gm-Message-State: AOAM5300+7cRQpGtJFSuxt8efVOkwQd11og9bki8zSPjSq8vCBk5A9fQ
        ssMrG8sNqKnt4LIYIwCnI1U=
X-Google-Smtp-Source: ABdhPJzceOAS1blBMRSvLjlJcqY1SP0aUEgz7A5H6nSmVvHnsSDd3DVGADEuAvYxxQDYCtGSEilMMA==
X-Received: by 2002:a63:8ac7:0:b0:3aa:fa62:5a28 with SMTP id y190-20020a638ac7000000b003aafa625a28mr5117082pgd.400.1652468162665;
        Fri, 13 May 2022 11:56:02 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:56:02 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 06/10] inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
Date:   Fri, 13 May 2022 11:55:46 -0700
Message-Id: <20220513185550.844558-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
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
2.36.0.550.gb090851708-goog

