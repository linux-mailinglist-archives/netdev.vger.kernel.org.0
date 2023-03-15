Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA446BB82C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjCOPm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjCOPmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:42:54 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917CA74DD9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:52 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x18-20020a05620a099200b00745c25b2fa3so4472731qkx.16
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GGC1UKmb4hFSN3YGErEh1pF+1YaH6lPTo/aDscXVbkY=;
        b=RW+ff/FbGCuaF+KEeHotSSrnkZbCv1RroLNFYxjAQ0etAt4p4+6i81lU4gYnLNy+3d
         BdZVwotTTErzj2bHw6kxoWKpInuGkwTNrkmXevsjgJ1Ag7FnlAVZ/Twk93S4U+/xCViP
         EYZBf1w9QDcqEsk+iqf3MMXum6Qu5PmlOyWZlTcl9RL5mChlHq7t5rxRrznT7QeRFvW5
         kVxk2/T2AyKFjxFhKGTDi7ZxCTvScgfubxNN3pQwoxbg7LcCid44jFw1+tsIDx2hf4P8
         9JaSVIO+ZHLfrROPFfOfIZJ0vthapru3DNSZWdvpUwf4NFejl+sm7xeVFlT+CLjulEQW
         9KuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GGC1UKmb4hFSN3YGErEh1pF+1YaH6lPTo/aDscXVbkY=;
        b=oljdxrXgZhs2eczdivQWabAlE6NYm8HP4leuRqYzuPQtw5DkImDRcUoXd2gzdwOmn/
         BUpSPndDT8C+AggPXmYIIa5uqL7Cu9nYelfmi9kOtbn2Kt81bLlG9oiaro1mf7mn5Mxq
         ZZyhjvHac3f4e8sxrBMV7nzxbCQhlJYNh4qL8hnNHe1q1YCWWDfaGiPVe5OBjJdwQAiD
         GgoPNoIPtjilgKKgcrV8b1f6QirkvULng7bQEm5ZB83MBX3TUoM0Wl3I+s1hy7NUFGrJ
         tm7LMT6/7jPgYmGnTOrFRGhvLvsxsWN03kO04FdaDL61+ouvyqSSUW4MXQTwgfSSmPos
         EDvw==
X-Gm-Message-State: AO0yUKULRHbSnTzO9nkadR5Y3XCI63syBBuiiH0/AwEjhuMW4yiTji4c
        zsrzkbl7Zh2u939ymh03pTfMdNx/COLlqg==
X-Google-Smtp-Source: AK7set8z5dgYBhpnqyX+7KacBCUOat37NYdYzryMQJet333NTZogAW5yjuwVHwvmG8odkS3DHhpZ+sgEO5VFLA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:30c:b0:73b:aa08:79ea with SMTP
 id s12-20020a05620a030c00b0073baa0879eamr4454833qkm.5.1678894971680; Wed, 15
 Mar 2023 08:42:51 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:40 +0000
In-Reply-To: <20230315154245.3405750-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-4-edumazet@google.com>
Subject: [PATCH net-next 3/8] udp: constify __udp_is_mcast_sock() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
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
2.40.0.rc1.284.g88254d51c5-goog

