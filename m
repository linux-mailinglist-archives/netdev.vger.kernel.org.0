Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1D36BD3ED
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjCPPgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjCPPgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:36:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FDAE20C5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so2206711ybg.21
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UC7AUyRVRuQAL1SzGjeVyHoxHMMkchQ03iO7MnXKXPE=;
        b=J4y5yyrS8KBgJ9oVYQ5AluugWJaaegIykMyixxxGzhiQdXf4O4b+SWLQvOiyrsZqlD
         AzBiydq7FVE5YGAdTERtLob1hv7y7CQtbqZMTUDm+cOCwCz6AgV3BaWfUaBsLORuwAyv
         bCYgat3kC/X4C+xpj74B1kHE3E1T4PPwDKAyJq+5oz186HNEAH++4iV2r0KNpJ3phMRO
         4mMv5IleCfiExOAiNhGEg2vtu8/Rs/ih0gzZJEaIH0yQrhoK4shLjLxUpGtehuWho2m7
         6gtd6RtEmd1GYdm0l9qwHrt+Q/N3E5JHCC8TaV06Awr2KQyom4xRwUtWTVCy1oy1xYlk
         H48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UC7AUyRVRuQAL1SzGjeVyHoxHMMkchQ03iO7MnXKXPE=;
        b=Dt94SK2KJmtZ6+8sLAqBS1s/WPG0VP3voJj1BbrzEDeH/qKKrQTRcaHvLtKkBUBzMq
         ZxnElJ3W/5MLd0S9HYiw440I6KSLI7G1i6MJKmfbAbqBD8CaalUAeWvqOdzBt6Se/JNU
         qKlG9ak04e0G/kNmjPw+wZfRgphqIHmV3/EI/Q69WHNhmLhiOuW4wlGJ3l2TwOGuQgmf
         LcwZv99u/Cbg/eZxGwPQYnDzYnyZE/QSTbY6X2K52QXqytOyBxIY/1aOUBg/8XyorSUu
         v0gHwlMYHWFgJx0Q16IMlxWvZl3yRbAQNPQwu567Kdrpad1dBRzh3hRGkIoBg/gRMB51
         nEYw==
X-Gm-Message-State: AO0yUKVXsWZtMfJDu1/mxx+VpC1joNgWR8Is2r++n1SnYDVUQr7m4QEa
        s5bxHuWzIZfkjBTSmbtuArhNJV4h+pKNYQ==
X-Google-Smtp-Source: AK7set86qC6asitUZgOhnj7M4u9b5qj0yBeddalhrfPhU1c/Jl2S70fxBa1jSo3Y3xm/OPhLpMjqS6/CIYLwLw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:b649:0:b0:541:8995:5334 with SMTP id
 h9-20020a81b649000000b0054189955334mr2573245ywk.3.1678980729078; Thu, 16 Mar
 2023 08:32:09 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:31:57 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-4-edumazet@google.com>
Subject: [PATCH v2 net-next 3/8] udp: constify __udp_is_mcast_sock() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clarifies __udp_is_mcast_sock() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/ipv4/udp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index dc8feb54d835f0824aa6833e36db34f686c456ec..aa32afd871ee50968f7bb8152401be60dece1454 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -578,12 +578,12 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 EXPORT_SYMBOL_GPL(udp4_lib_lookup);
 #endif
 
-static inline bool __udp_is_mcast_sock(struct net *net, struct sock *sk,
+static inline bool __udp_is_mcast_sock(struct net *net, const struct sock *sk,
 				       __be16 loc_port, __be32 loc_addr,
 				       __be16 rmt_port, __be32 rmt_addr,
 				       int dif, int sdif, unsigned short hnum)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 
 	if (!net_eq(sock_net(sk), net) ||
 	    udp_sk(sk)->udp_port_hash != hnum ||
-- 
2.40.0.rc2.332.ga46443480c-goog

