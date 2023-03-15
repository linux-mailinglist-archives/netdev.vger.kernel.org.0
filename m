Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D5E6BB834
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjCOPnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjCOPnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:43:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCBC7A92F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:43:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-540e3b152a3so144818227b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6fXsD9tdN4Hcq/yJ62UIKt/XJRYN2tPURfjPLUEjr0=;
        b=TAJGmWSknxXEUNMGDSE3hD+8EEJWMyJnRMuJ6IRKRiILOjS3LsNwUL8jcsGPbj7YO/
         vjmgHNQcdF54rbo+o5CI6l6CPCqrjuw2TVjEoLqZsMH3mNUWtyrbdPgS9VFfsNvgZ+oJ
         UIAbYZ//yqiiCmU3ExQELT/Ri2c26+ICGx2y6m+QciQqRwmLp2RWUV6Y25w7D2qRSaUo
         Fde3a+POQXetmZyMTYSoK/qYvrbA405wZpkIT2jw4PaZl5zvyprqaB2OX99gm+SwkCOz
         KgM+DkQMXeBaBsc1mnFB401F5cV0gAFSa4P03RGmgi+ppsoaNHDO6tRuM1h0PD9o7LIM
         YdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6fXsD9tdN4Hcq/yJ62UIKt/XJRYN2tPURfjPLUEjr0=;
        b=EKUHz8g/5wt//qVyFZA3p/FMjgvJuk0G0GoUKOqRGAuqS+SXlhTwKfVvQHNO9R2Oh8
         74pItkq503Tj2hSieYQXxBWoHbKHk6zn94/NoOnZRn19bC2Qwu8bkZpGtMv3hcoLWGkl
         ivkfRdQadcll4j4oirIpG41uejoU7De8GAhVs9J1iMEQ0KGgNZPk1nKiEOW2BzcC+e+F
         et9db9Gu2qeqqC9GYrz+xIJGc9S+j2hg3lEm6XSFK3/asZcSQDUOxAZAHzHwdfEhCtQj
         7k3VV4wsd6Kv/h7MBKLZztMLWXhLvst9Jjk/ORPKhBfV12Hga/9WsKg+pHM/bXGhSRPv
         9mrw==
X-Gm-Message-State: AO0yUKUo+c1mbHASdhNeZTidKGlpyCi3CA9jm0aHjJYQKyA9wR1TrkK+
        FW0U0ZztX3HfYFNat5d5s8ABC1LZ5nr6Vg==
X-Google-Smtp-Source: AK7set+tulwZYMGJLOVNu3J8XAiwYot78L2UoqTnWDoSvFc/Hk32N9jEnzP/srSPu/OCmgC2zB/152v/ehCFxA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:208:b0:9fe:195a:ce0d with SMTP
 id j8-20020a056902020800b009fe195ace0dmr21470841ybs.10.1678894979655; Wed, 15
 Mar 2023 08:42:59 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:45 +0000
In-Reply-To: <20230315154245.3405750-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-9-edumazet@google.com>
Subject: [PATCH net-next 8/8] inet_diag: constify raw_lookup() socket argument
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

Now both raw_v4_match() and raw_v6_match() accept a const socket,
raw_lookup() can do the same to clarify its role.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/raw_diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 999321834b94a8f7f2a4996575b7cfaafb6fa2b7..bca49a844f01083cdfdade6f52852d48ddb36d70 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -34,7 +34,7 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
  * use helper to figure it out.
  */
 
-static bool raw_lookup(struct net *net, struct sock *sk,
+static bool raw_lookup(struct net *net, const struct sock *sk,
 		       const struct inet_diag_req_v2 *req)
 {
 	struct inet_diag_req_raw *r = (void *)req;
-- 
2.40.0.rc1.284.g88254d51c5-goog

