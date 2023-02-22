Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF2269FD60
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjBVVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjBVVED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:04:03 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4FD3D092;
        Wed, 22 Feb 2023 13:04:02 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id fp16so8908056qtb.10;
        Wed, 22 Feb 2023 13:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXMU3ah44v7LWz1154kqywr6srN7fbh2udY8koGnYjc=;
        b=BZNzBdRNEuRVRMgyegb2FfXZeIWL3NFHqqc3y1AilCXJpwqJ4Irl5c9CtfzzIL69Z3
         uJn6i//DoF9XzdGxLMrcfk9rjAjwE8uXXLhj1bRaQl9qpWAz38h1MG5qfZiMt8jYrLoT
         oMHnX+T3mMoKBNIOaSG4t/XXgPw3LpEzJJy6KqRyyujrJyavotcgd3QJbDDlKrr5x5vk
         87ZtIJDBDJkDvXsmzA+WVpsq06eQ7NR4uefSg0OhoSupZ1d5ocFndlAoclnPiR/FZY06
         tnYZefo2SFwrQi/435KuAaBFxDrqnjVAWv0WjCm+ddGAzhBjxMnmmrM5Xa2ltpIRF3MX
         R5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXMU3ah44v7LWz1154kqywr6srN7fbh2udY8koGnYjc=;
        b=mTb8nD5AB2ewhhSbhFdqbURdZB07zfi+i/3BkOdo0YRAwYiI550+/uUr9Q63cATmHs
         8WQg25uc0yWTtx/raygZLcesT9AaRdSbkQ1nFDQ28F5E1GEbcZ+4xbGDl7qG+l4GAdSt
         6szxZKXn1uP5HAtd7fA7Aj0GMXIYheaZRW/yyQqz63kgTcEbexD3zzkL0gPRr0sPIvog
         nDnW98Pml7FPh/zOPYfNFrz7qsxCVdpY52FcgxYp/XEE+r09RR6XwumrSmKw+vtIrbIU
         r6P0yLRCFCtFdwauYKU+1uC7RkK3t7N48vhlR/5idbi0eaFMbADgzq1rgtiWKo9laHNL
         jhBA==
X-Gm-Message-State: AO0yUKVTEANxGtBxv8sQuFelQz3yMgcq77+cm3kPf+w5ZfIzURgSHoS3
        Nn3Kx2m5lSDo0nwQ/2bki6g=
X-Google-Smtp-Source: AK7set/Ah9XFYXOjjxnGa1ymQFpycg+JsLhYakkAVNO/VRtGbea7Bb9zjs+ZLsYNBKCul8cwzD4Jpw==
X-Received: by 2002:a05:622a:d0:b0:3a8:11ab:c537 with SMTP id p16-20020a05622a00d000b003a811abc537mr17486044qtw.63.1677099841378;
        Wed, 22 Feb 2023 13:04:01 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id ff23-20020a05622a4d9700b003b64f1b1f40sm3309109qtb.40.2023.02.22.13.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:04:00 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [RFC PATCH net-next 1/7] net: sunhme: Just restart autonegotiation if we can't bring the link up
Date:   Wed, 22 Feb 2023 16:03:49 -0500
Message-Id: <20230222210355.2741485-2-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230222210355.2741485-1-seanga2@gmail.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we've tried regular autonegotiation and forcing the link mode, just
restart autonegotiation instead of reinitializing the whole NIC.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index dd14114cbcfb..3eeda8f3fa80 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -589,7 +589,10 @@ static int set_happy_link_modes(struct happy_meal *hp, void __iomem *tregs)
 	return 1;
 }
 
-static int happy_meal_init(struct happy_meal *hp);
+static void
+happy_meal_begin_auto_negotiation(struct happy_meal *hp,
+				  void __iomem *tregs,
+				  const struct ethtool_link_ksettings *ep);
 
 static int is_lucent_phy(struct happy_meal *hp)
 {
@@ -743,12 +746,7 @@ static void happy_meal_timer(struct timer_list *t)
 					netdev_notice(hp->dev,
 						      "Link down, cable problem?\n");
 
-					ret = happy_meal_init(hp);
-					if (ret) {
-						/* ho hum... */
-						netdev_err(hp->dev,
-							   "Error, cannot re-init the Happy Meal.\n");
-					}
+					happy_meal_begin_auto_negotiation(hp, tregs, NULL);
 					goto out;
 				}
 				if (!is_lucent_phy(hp)) {
-- 
2.37.1

