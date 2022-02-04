Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F195D4AA106
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbiBDUP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbiBDUPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:15:54 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE0BC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 12:15:54 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id e28so6021159pfj.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 12:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iXo2i758RYYv3KpN+SQBcMVGB8Iy3ivrUCagaN0J9Cg=;
        b=OotxEf7OrYp9dzOs7uWZZareR858X2kMvIiVDbeJM6BurtGzTJK0fPja5HXk+MtVpS
         wQ8pORgjIHjauIZfU/9d6xYnLYlEEbQQR/wuXlHsVhpjstnCYepdER38PYIfUhfZ58d9
         YmSRFUIA9fC6bRIXQ7MWQcW5z+QICO4yA1K6YhI8ztw9tUpYXR/hOOEpOI7EJjF7DdBh
         0x0VYaQ+u1YRPgyzsE5cZVnTj6eNH2yhfApXE/cpB73fNVhGvSziiQaEk2PqP6vIu/ak
         5eI4DP6bOZ2VXa5wXPQNf7BS2PZPBqIuEcDTMl5xeSJLlNMWn1XXQR7jMFt/Mg42v7SZ
         EVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iXo2i758RYYv3KpN+SQBcMVGB8Iy3ivrUCagaN0J9Cg=;
        b=awYSPl4Jc9LXyRgdhBZvzRKwPuSNIVE+JYkCjUC/dQpT8bAbupxKVr0fkPOPjtPacS
         5oFPhrEbPxjtGKYyzTEE3me9+jMHCutsaDxuZpSfy1m48D5SxkxzwoGvnr4L8O5nYZok
         jgQU/R04apD6PuU+KqYVH1xxrV6RJHrYHHtf/Maurp7YhJQxp2mrQ1eaHsnFFybPjIB8
         UfRLnulfex4XZyeOG+taxAATGUO35d3oLiqhEljlzi0uQ0qws/KmPENVvxGBcUdneYVx
         ylYsMG/va14sbFKRjX1JcgVxovzfIWxSUBe6efNCJ/AZgbICHM7NBTw/+B4T/9EtAgj/
         ELKA==
X-Gm-Message-State: AOAM531t5ADUUf/YvJ0o9FD2aIc21+TgqbkFzeJajNVQ0ELmCkeFUZ6y
        n+BTe+oZ7yd9EVvxg/QSVsE=
X-Google-Smtp-Source: ABdhPJwP/MasxM0m9r800C2xUaRi6DOLV0v7pA0TPLwaW6Q0kSvbUlhhWUHFnGfnC1z2hE+3bYpN8Q==
X-Received: by 2002:a63:2ad4:: with SMTP id q203mr570166pgq.136.1644005753599;
        Fri, 04 Feb 2022 12:15:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id d9sm3571417pfl.69.2022.02.04.12.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 12:15:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] ip6mr: ip6mr_sk_done() can exit early in common cases
Date:   Fri,  4 Feb 2022 12:15:46 -0800
Message-Id: <20220204201546.2703267-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220204201546.2703267-1-eric.dumazet@gmail.com>
References: <20220204201546.2703267-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In many cases, ip6mr_sk_done() is called while no ipmr socket
has been registered.

This removes 4 rtnl acquisitions per netns dismantle,
with following callers:

igmp6_net_exit(), tcpv6_net_exit(), ndisc_net_exit()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 541cd08871293eb5702e47e0645ea16394621e97..8e483e14b5709b1b8a6e9dfd6616a5bde5c273ee 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1575,6 +1575,9 @@ int ip6mr_sk_done(struct sock *sk)
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
 		return err;
 
+	if (!atomic_read(&net->ipv6.devconf_all->mc_forwarding))
+		return err;
+
 	rtnl_lock();
 	ip6mr_for_each_table(mrt, net) {
 		if (sk == rtnl_dereference(mrt->mroute_sk)) {
-- 
2.35.0.263.gb82422642f-goog

