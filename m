Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3ABF6B8290
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCMUSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCMUSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:18:21 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282046A4A
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:17:38 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id br8-20020a05622a1e0800b003c0189c37e1so7448516qtb.18
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678738657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qZNjZylXpZlqsXSx5fBI7eF05UVsFDZXf0HIJTTFwZ4=;
        b=RUEXji35P58EBsU0G4AHGH/GCWCHDgwJhoKyi+Ctqz9E94qdR+cGWSkAbkwIESkEoO
         9kZpPIxKT7Xvp+I+pBbIRtBbN1P+/fkHp3aodaPrv0rd1r1TTBOB7Hx8+Mx9VJwFluMB
         0AG+mXwML9BlbnxbwVDvdbBKLvzOxyt23+qhagEUcD+szuBoTyrGzrLVlv81Ufiz/qbq
         yhz1a55wuWI2OIqydIZNDq4srgbt1D2vdijvayYYyP/Z4Vpp7rjEZNQMg7/zFUnXqXaM
         3Hvo8e4Ve0DZVkNWnlBd8IEiAg6NJ7wo6oXztZ71J5SsTAmiNuEcgiMd1nGyppB8X4Sw
         +0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678738657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qZNjZylXpZlqsXSx5fBI7eF05UVsFDZXf0HIJTTFwZ4=;
        b=g7aCgzXP7Eeaf+oycGfg0m+WzlLZ2QWPheqY3o07vmtldFmnfKdqtCjeR+b0OP9FL1
         MJgNmw6VEjP+cUMw9+OdxKsHcIiou5zpfwsxDEHWe6DP4xSZ2NlfPMkOA7ixQlFmtxVo
         nHif5q46BzlouBl84Ccmo6eJu2PlgnFxvxK7JWqs7LI7GtBsrPztM30Nfv6N+OMnuxds
         4cuVwje7ZD9VfFBN2LrRTDliKM/voUVLd3BPJOg7hGVXX5xMQi9oMnz7/QK5K9TdupQu
         +9e37kuciFx7ME+VQxtAAri9I4v9XX/gDexlCdA1rIcNFYuj0XE4OY7kP66fMYnKkTRW
         UYgg==
X-Gm-Message-State: AO0yUKW0igi4yxDOsTdwqxEFavVY11rPdj4e/sre9BrO7LCLxaRVApQm
        12nNsDrmLTxiuT4vUt2sYn/Dv9dhyvzITA==
X-Google-Smtp-Source: AK7set9kbS6F/sKA03QV+hMZs3Sdvj1T6gvuScY/dsMR/YudxLt0AA769JWYyaAI4mmxJ3tpZxzur6hTfSOcxw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ae9:f00d:0:b0:745:6afc:9bb2 with SMTP id
 l13-20020ae9f00d000000b007456afc9bb2mr1516718qkg.14.1678738657306; Mon, 13
 Mar 2023 13:17:37 -0700 (PDT)
Date:   Mon, 13 Mar 2023 20:17:32 +0000
In-Reply-To: <20230313201732.887488-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230313201732.887488-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313201732.887488-3-edumazet@google.com>
Subject: [PATCH net-next 2/2] ipv6: remove one read_lock()/read_unlock() pair
 in rt6_check_neigh()
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

rt6_check_neigh() uses read_lock() to protect n->nud_state reading.

This seems overkill and causes false sharing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 25c00c6f5131c55055f30348ef4605f50440ddbb..e829bd880384077027dc79fcae1a62eb0073f7c8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -687,16 +687,16 @@ static enum rt6_nud_state rt6_check_neigh(const struct fib6_nh *fib6_nh)
 	neigh = __ipv6_neigh_lookup_noref(fib6_nh->fib_nh_dev,
 					  &fib6_nh->fib_nh_gw6);
 	if (neigh) {
-		read_lock(&neigh->lock);
-		if (neigh->nud_state & NUD_VALID)
+		u8 nud_state = READ_ONCE(neigh->nud_state);
+
+		if (nud_state & NUD_VALID)
 			ret = RT6_NUD_SUCCEED;
 #ifdef CONFIG_IPV6_ROUTER_PREF
-		else if (!(neigh->nud_state & NUD_FAILED))
+		else if (!(nud_state & NUD_FAILED))
 			ret = RT6_NUD_SUCCEED;
 		else
 			ret = RT6_NUD_FAIL_PROBE;
 #endif
-		read_unlock(&neigh->lock);
 	} else {
 		ret = IS_ENABLED(CONFIG_IPV6_ROUTER_PREF) ?
 		      RT6_NUD_SUCCEED : RT6_NUD_FAIL_DO_RR;
-- 
2.40.0.rc1.284.g88254d51c5-goog

