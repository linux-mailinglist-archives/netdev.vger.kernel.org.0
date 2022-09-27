Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CA55EB662
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiI0Akx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiI0Akk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:40:40 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE513F9B
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:40:36 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d10so7166520pfh.6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=VJtCPwVDtwDjIooJZ4y0gRwQCahGRpaJT9wGcWMjORs=;
        b=VvuZQBTYao8dMp/XcrA6B5eGOq5huNfpsyfiYiH+2ZtLSq+BmDtB8jbNPZ6pFfMICQ
         +gBsND5fUECaHOcd7odlIE5mK4qJaPiVBjhxhhsCePIl06KYSL8MMrKHAGTMVIQjM52w
         ASs2h4yKd/r0HOLw9J9Odu+2wM5mZ/AQK8ZKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=VJtCPwVDtwDjIooJZ4y0gRwQCahGRpaJT9wGcWMjORs=;
        b=0vHGSijymvERjwUSChOocKSBsOxLoTnl+kSs1VPqXHYq/DeIO8KtValTYOZyujM0IH
         hfWrxCsN+bhEN0EL9F+pIztMnrjok/3hZcKBAhuSRf7J7kedll/1P2+RHrM/sZ7GCmW0
         HmCOjmazqi6OhsQ3B/itrSZUFzb8tCmmvBE1mqzJCxyhMjh9+Z6XcfMR6h0Ak8XqPPau
         e+8jBK29UQsp/T1BxQiTeRVDAAwCu78w9b0G2I4rDZm9UJLaDo+drjmRUbL65n3Jc6HO
         Xz+1+zfrpbW+DOthIfiBN4xJ6s9cGccYhiSzkhrJVckQGbCpewH8V8HurAOnVT3sUCzv
         2mrA==
X-Gm-Message-State: ACrzQf0ac1o5k+JhqYb2QQ9n5Bb8DcqcrsL9zsXo1Fk24QmdFN9yUct3
        hkWPZM5a3xNEsPBOnMjOt8PEbR5gsA65+Q==
X-Google-Smtp-Source: AMsMyM6lAcW419M+QieduWpZQ5tgxZTYWWxDyq0gne5Ik9qQ4QewnuhqSDR3T1g1KxvW29apUwnURQ==
X-Received: by 2002:a05:6a00:1990:b0:545:aa9e:be3d with SMTP id d16-20020a056a00199000b00545aa9ebe3dmr26702722pfl.59.1664239236206;
        Mon, 26 Sep 2022 17:40:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f35-20020a17090a28a600b00203125b6394sm53549pjd.40.2022.09.26.17.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:40:35 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] mlxsw: core_acl_flex_actions: Split memcpy() of struct flow_action_cookie flexible array
Date:   Mon, 26 Sep 2022 17:40:33 -0700
Message-Id: <20220927004033.1942992-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1634; h=from:subject; bh=anKrQLY+XsXKgHz694GQioMoU17jgmFoTynuopZyaGg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjMkaBfu8qN5shW54b50aHf+icSE8mqDj2fL3Oe3rs UiET1fGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYzJGgQAKCRCJcvTf3G3AJkJwD/ 4uuK+VZ1mJBwvloZTYwkWWvwMD6O3YJ7TlM8I3YOOzoU110PcLcBRFA7Fc/yXBhhfWyeu8zxZz4mG0 BJvV+bms9nxA+oed4ATwwaSmDBHEA+T+SNurvu3uC+aN5KYlnb1yE/jDO13fvSqQv0I803i+jEcyVO lk+W0UdsTTMivSv6LF80i6YZpfUokBfj1sRj02fhQCXLmxLE1YtiYyf/8kH2c6FM1nDHvTonWV+vyX bTTJeN2PG7tWse9aH2IJSIrCiRmQfLa9WzC2aYTNXaBvepHo+K65zWwJcVnVSn1jdOXD/ExTuFskWf pfdKMPEhjrf/aYNOYT8xk84SsDil50pYL+fpkUPj/qyU0qScRKPwwm5n82NvbbV5o79tn4oW8oqBu/ LGgLek3r0oxVr9ywDqwldNvEDtR3JMSTSyI/wcTWBtP1d1AZqNQHVsYFh3DJ17cDS2NXKYm6bBQkXx gLmYCl8Kp/LfWWxEJXHap6W8Lb1GXO/v1ccXCC3vmNU239OKe4vV2hpfYKLjY1u6KfpVBlo3VclLHV LxPrIANqJQby71uZk10OdGr8G0OgVSBTwGnRC6eIXC45o1pJwUpVXEgBILgskr8F5H0zPsMCtnfG+w KXZrR+CL6okF4VYg791WIUh1eRy9thQpt+y6zi663njUo/Pj39cmCR7+RQHQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To work around a misbehavior of the compiler's ability to see into
composite flexible array structs (as detailed in the coming memcpy()
hardening series[1]), split the memcpy() of the header and the payload
so no false positive run-time overflow warning will be generated.

[1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org

Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 636db9a87457..9dfe7148199f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -737,8 +737,9 @@ mlxsw_afa_cookie_create(struct mlxsw_afa *mlxsw_afa,
 	if (!cookie)
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&cookie->ref_count, 1);
-	memcpy(&cookie->fa_cookie, fa_cookie,
-	       sizeof(*fa_cookie) + fa_cookie->cookie_len);
+	cookie->fa_cookie = *fa_cookie;
+	memcpy(cookie->fa_cookie.cookie, fa_cookie->cookie,
+	       fa_cookie->cookie_len);
 
 	err = rhashtable_insert_fast(&mlxsw_afa->cookie_ht, &cookie->ht_node,
 				     mlxsw_afa_cookie_ht_params);
-- 
2.34.1

